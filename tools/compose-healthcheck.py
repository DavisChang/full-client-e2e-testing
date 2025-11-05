#!/usr/bin/env python
from __future__ import annotations

import json
import sys
from typing import Iterable

import requests

SERVICES = {
    "selenium": "http://localhost:4444/wd/hub/status",
    "appium": "http://localhost:4723/wd/hub/status",
}


def check_service(name: str, url: str) -> tuple[str, bool, str]:
    try:
        response = requests.get(url, timeout=5)
        response.raise_for_status()
        payload = response.json()
        ready = payload.get("value", {}).get("ready", False)
        return name, ready, json.dumps(payload)
    except Exception as exc:  # noqa: BLE001 - we want the message
        return name, False, str(exc)


def main(targets: Iterable[str] | None = None) -> int:
    targets = set(targets or SERVICES.keys())
    failures: list[str] = []
    for name, url in SERVICES.items():
        if name not in targets:
            continue
        service, ready, info = check_service(name, url)
        status = "READY" if ready else "NOT_READY"
        print(f"[{service}] {status} -> {info}")
        if not ready:
            failures.append(service)
    return 0 if not failures else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
