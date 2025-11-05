from __future__ import annotations

import json
import os
import re
from functools import lru_cache
from pathlib import Path
from typing import Any, Dict

import yaml
from dotenv import load_dotenv
from robot.libraries.BuiltIn import BuiltIn

ROOT = Path(__file__).resolve().parents[2]
ENV_DIR = ROOT / "config" / "environments"
DRIVER_DIR = ROOT / "config" / "drivers"

load_dotenv(ROOT / ".env", override=False)

_ENV_PATTERN = re.compile(r"\$\{ENV:([A-Za-z0-9_]+)(:-([^}]*))?}")


def _resolve_env_tokens(value: str) -> str:
    def replace(match: re.Match[str]) -> str:
        key = match.group(1)
        default = match.group(3) or ""
        return os.environ.get(key, default)

    resolved = _ENV_PATTERN.sub(replace, value)
    return os.path.expandvars(resolved)


@lru_cache(maxsize=None)
def _load_yaml(path: Path) -> Dict[str, Any]:
    if not path.exists():
        raise FileNotFoundError(f"Missing config: {path}")
    with path.open("r", encoding="utf-8") as handle:
        data = yaml.safe_load(handle) or {}
    return _expand_env(data)


def _expand_env(node: Any) -> Any:
    if isinstance(node, dict):
        return {key: _expand_env(value) for key, value in node.items()}
    if isinstance(node, list):
        return [_expand_env(item) for item in node]
    if isinstance(node, str):
        return _resolve_env_tokens(node)
    return node


def load_context(environment: str = "dev", platform: str = "web", user_role: str | None = None) -> Dict[str, Any]:
    env_cfg = _load_yaml(ENV_DIR / f"{environment}.yaml")
    driver_cfg = _load_yaml(DRIVER_DIR / f"{platform}.yaml")

    remote_overrides = env_cfg.get("remote_endpoints", {})
    if platform in remote_overrides:
        driver_cfg["remote_url"] = remote_overrides[platform]

    merged_timeouts = {**env_cfg.get("timeouts", {}), **driver_cfg.get("timeouts", {})}

    role = user_role or env_cfg.get("default_user_role", "standard")
    credentials = env_cfg.get("credentials", {})
    selected_user = credentials.get(role)
    if not selected_user:
        raise ValueError(f"No credentials for role '{role}' in {environment}.yaml")

    context: Dict[str, Any] = {
        "environment": environment,
        "platform": platform,
        "base_url": env_cfg.get("base_url"),
        "api_base_url": env_cfg.get("api_base_url"),
        "remote_url": driver_cfg.get("remote_url"),
        "browser": driver_cfg.get("browser", "chrome"),
        "capabilities": driver_cfg.get("capabilities", {}),
        "timeouts": merged_timeouts,
        "credentials": credentials,
        "selected_user": {"role": role, **selected_user},
    }

    _set_robot_globals(context)
    return context


def _set_robot_globals(context: Dict[str, Any]) -> None:
    bi = BuiltIn()
    timeouts = context.get("timeouts", {})
    bi.set_global_variable("${ENVIRONMENT}", context["environment"])
    bi.set_global_variable("${PLATFORM}", context["platform"])
    bi.set_global_variable("${BASE_URL}", context.get("base_url"))
    bi.set_global_variable("${API_BASE_URL}", context.get("api_base_url"))
    bi.set_global_variable("${REMOTE_URL}", context["remote_url"])
    bi.set_global_variable("${BROWSER}", context["browser"])
    bi.set_global_variable("${DESIRED_CAPS}", context["capabilities"])
    bi.set_global_variable("${DESIRED_CAPS_JSON}", json.dumps(context["capabilities"]))
    bi.set_global_variable("${IMPLICIT_WAIT}", timeouts.get("implicit", 5))
    bi.set_global_variable("${EXPLICIT_TIMEOUT}", timeouts.get("explicit", 15))
    bi.set_global_variable("${PAGE_LOAD_TIMEOUT}", timeouts.get("page_load", 30))
    bi.set_global_variable("${ALL_CREDENTIALS}", context.get("credentials", {}))
    bi.set_global_variable("${SELECTED_USER}", context.get("selected_user", {}))
    bi.set_global_variable("${USERNAME}", context["selected_user"].get("username"))
    bi.set_global_variable("${PASSWORD}", context["selected_user"].get("password"))

