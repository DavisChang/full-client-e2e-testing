from __future__ import annotations

import os

import requests


def _get(url_env: str, default: str) -> str:
    return os.environ.get(url_env, default)


def test_selenium_grid_health():
    url = _get("DEV_SELENIUM_GRID", "http://127.0.0.1:4444/wd/hub/status")
    if not url.endswith("/status"):
        url = f"{url.rstrip('/')}/status"
    response = requests.get(url, timeout=5)
    response.raise_for_status()
    assert response.json().get("value", {}).get("ready", False) is True


def test_appium_health():
    url = _get("DEV_APPIUM_ANDROID", "http://127.0.0.1:4723/wd/hub/status")
    if not url.endswith("/status"):
        url = f"{url.rstrip('/')}/status"
    response = requests.get(url, timeout=5)
    response.raise_for_status()
    assert response.json().get("value", {}).get("ready", False) is True
