#!/usr/bin/env python3
"""
跨平台測試執行腳本
Cross-platform test runner for macOS and Windows
"""
import argparse
import platform
import subprocess
import sys
from datetime import datetime
from pathlib import Path


def get_robot_command():
    """獲取 robot 命令路徑（考慮虛擬環境）"""
    if platform.system() == "Windows":
        robot_path = Path(".venv") / "Scripts" / "robot"
        if not robot_path.exists():
            robot_path = Path(".venv") / "Scripts" / "robot.exe"
    else:
        robot_path = Path(".venv") / "bin" / "robot"
    
    # 如果虛擬環境中沒有，使用系統的
    if not robot_path.exists():
        return "robot"
    
    return str(robot_path)


def get_python_command():
    """獲取 Python 命令路徑（考慮虛擬環境）"""
    if platform.system() == "Windows":
        python_path = Path(".venv") / "Scripts" / "python.exe"
    else:
        python_path = Path(".venv") / "bin" / "python"
    
    # 如果虛擬環境中沒有，使用當前的 Python
    if not python_path.exists():
        return sys.executable
    
    return str(python_path)


def run_robot_tests(args):
    """執行 Robot Framework 測試"""
    robot_cmd = get_robot_command()
    
    # 構建報告目錄
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    report_dir = Path("reports") / f"{args.env}-{args.platform}-{timestamp}"
    report_dir.mkdir(parents=True, exist_ok=True)
    
    # 構建測試路徑
    if args.suite:
        test_path = args.suite
    else:
        test_path = str(Path("tests") / args.platform)
    
    # 構建 Robot Framework 命令
    cmd = [
        robot_cmd,
        f"--variable=ENV:{args.env}",
        f"--variable=PLATFORM:{args.platform}",
    ]
    
    if args.user_role:
        cmd.append(f"--variable=USER_ROLE:{args.user_role}")
    
    if args.tag:
        for tag in args.tag:
            cmd.extend(["--include", tag])
    
    cmd.extend([
        f"--outputdir={report_dir}",
        test_path,
    ])
    
    print(f"📋 執行命令: {' '.join(cmd)}")
    print(f"📁 報告目錄: {report_dir}")
    print("=" * 60)
    
    try:
        subprocess.run(cmd, check=True)
        print("\n✅ 測試執行成功！")
        print(f"📊 查看報告: {report_dir / 'report.html'}")
        return 0
    except subprocess.CalledProcessError as e:
        print(f"\n❌ 測試執行失敗: {e}")
        return 1


def run_python_tests(args):
    """執行 Python pytest 測試"""
    python_cmd = get_python_command()
    
    # 構建測試路徑
    if args.suite:
        test_path = args.suite
    else:
        test_path = str(Path("tests") / "python")
    
    # 構建 pytest 命令
    cmd = [
        python_cmd,
        "-m",
        "pytest",
        test_path,
        "-v",
    ]
    
    if args.markers:
        cmd.extend(["-m", args.markers])
    
    print(f"📋 執行命令: {' '.join(cmd)}")
    print("=" * 60)
    
    try:
        subprocess.run(cmd, check=True)
        print("\n✅ 測試執行成功！")
        return 0
    except subprocess.CalledProcessError as e:
        print(f"\n❌ 測試執行失敗: {e}")
        return 1


def clean_reports():
    """清理報告目錄"""
    reports_dir = Path("reports")
    if reports_dir.exists():
        print("🧹 清理報告目錄...")
        import shutil
        try:
            shutil.rmtree(reports_dir)
            reports_dir.mkdir()
            print("✓ 報告目錄已清理")
            return 0
        except Exception as e:
            print(f"❌ 清理失敗: {e}")
            return 1
    else:
        print("✓ 報告目錄不存在，無需清理")
        return 0


def main():
    """主函數"""
    parser = argparse.ArgumentParser(
        description="跨平台測試執行腳本 (Cross-platform test runner)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
範例 (Examples):
  # Robot Framework 測試
  python scripts/run_tests.py --platform mac --env dev
  python scripts/run_tests.py --platform web --env staging --tag smoke
  
  # Python pytest 測試
  python scripts/run_tests.py --type pytest --suite tests/python/test_mac_calculator.py
  
  # 清理報告
  python scripts/run_tests.py --clean
        """
    )
    
    # 測試類型
    parser.add_argument(
        "--type",
        choices=["robot", "pytest"],
        default="robot",
        help="測試類型 (預設: robot)"
    )
    
    # 平台選擇
    parser.add_argument(
        "--platform",
        "-p",
        choices=["web", "android", "mac", "windows"],
        help="目標平台 (web, android, mac, windows)"
    )
    
    # 環境選擇
    parser.add_argument(
        "--env",
        "-e",
        default="dev",
        help="環境配置 (dev, staging, prod) (預設: dev)"
    )
    
    # 用戶角色
    parser.add_argument(
        "--user-role",
        "-u",
        help="用戶角色 (standard, admin) (僅 Robot Framework)"
    )
    
    # 測試套件路徑
    parser.add_argument(
        "--suite",
        "-s",
        help="自定義測試套件路徑"
    )
    
    # Robot Framework 標籤
    parser.add_argument(
        "--tag",
        "-t",
        action="append",
        help="Robot Framework 標籤過濾 (可多次使用)"
    )
    
    # pytest markers
    parser.add_argument(
        "--markers",
        "-m",
        help="pytest markers 過濾"
    )
    
    # 清理選項
    parser.add_argument(
        "--clean",
        action="store_true",
        help="清理報告目錄"
    )
    
    args = parser.parse_args()
    
    # 顯示系統信息
    print("=" * 60)
    print("🧪 Full Client E2E Testing - 測試執行器")
    print(f"📍 平台: {platform.system()} {platform.release()}")
    print(f"🐍 Python: {sys.version.split()[0]}")
    print("=" * 60)
    
    # 處理清理命令
    if args.clean:
        return clean_reports()
    
    # 檢查必要參數
    if args.type == "robot" and not args.platform:
        parser.error("Robot Framework 測試需要指定 --platform")
    
    # 執行測試
    if args.type == "robot":
        return run_robot_tests(args)
    elif args.type == "pytest":
        return run_python_tests(args)
    
    return 0


if __name__ == "__main__":
    sys.exit(main())

