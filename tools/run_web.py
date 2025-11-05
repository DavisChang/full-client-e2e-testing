#!/usr/bin/env python
import argparse
import subprocess
from pathlib import Path


def main() -> None:
    parser = argparse.ArgumentParser(description="Run Robot Web suites with environment context")
    parser.add_argument("--env", default="dev")
    parser.add_argument("--user", default="standard")
    parser.add_argument("--suite", default="tests/web")
    args = parser.parse_args()

    report_dir = Path("reports") / f"{args.env}-web"
    report_dir.mkdir(parents=True, exist_ok=True)

    cmd = [
        "robot",
        f"--variable=ENV:{args.env}",
        "--variable=PLATFORM:web",
        f"--variable=USER_ROLE:{args.user}",
        f"-d={report_dir}",
        args.suite,
    ]
    subprocess.check_call(cmd)


if __name__ == "__main__":
    main()
