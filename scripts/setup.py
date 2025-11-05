#!/usr/bin/env python3
"""
跨平台設置腳本
Cross-platform setup script for macOS and Windows
"""
import os
import platform
import subprocess
import sys
from pathlib import Path


def run_command(cmd, shell=False):
    """執行命令並即時顯示輸出"""
    print(f">>> {' '.join(cmd) if isinstance(cmd, list) else cmd}")
    try:
        subprocess.run(cmd, check=True, shell=shell)
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ 命令執行失敗: {e}")
        return False


def setup_venv():
    """創建並設置虛擬環境"""
    venv_path = Path(".venv")
    
    if venv_path.exists():
        print("✓ 虛擬環境已存在")
    else:
        print("📦 創建虛擬環境...")
        if not run_command([sys.executable, "-m", "venv", ".venv"]):
            return False
    
    return True


def install_python_deps():
    """安裝 Python 依賴"""
    print("\n📥 安裝 Python 依賴...")
    
    # 獲取 pip 路徑
    if platform.system() == "Windows":
        pip_path = Path(".venv") / "Scripts" / "pip"
    else:
        pip_path = Path(".venv") / "bin" / "pip"
    
    if not pip_path.exists():
        print(f"❌ 找不到 pip: {pip_path}")
        return False
    
    return run_command([str(pip_path), "install", "-r", "requirements.txt"])


def install_node_deps():
    """安裝 Node.js 依賴"""
    print("\n📥 安裝 Node.js 依賴...")
    
    # 檢查是否有 npm
    try:
        subprocess.run(["npm", "--version"], capture_output=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("⚠️  npm 未安裝，跳過 Node.js 依賴安裝")
        return True
    
    return run_command(["npm", "install"])


def setup_env_file():
    """設置環境變數文件"""
    env_file = Path(".env")
    env_example = Path(".env.example")
    
    if env_file.exists():
        print("\n✓ .env 文件已存在")
    elif env_example.exists():
        print("\n📝 從 .env.example 創建 .env...")
        try:
            env_file.write_text(env_example.read_text())
            print("✓ .env 文件已創建，請根據需要修改配置")
        except Exception as e:
            print(f"❌ 創建 .env 失敗: {e}")
            return False
    else:
        print("\n⚠️  未找到 .env.example")
    
    return True


def main():
    """主函數"""
    print("=" * 60)
    print("🚀 Full Client E2E Testing - 環境設置")
    print(f"📍 平台: {platform.system()} {platform.release()}")
    print(f"🐍 Python: {sys.version.split()[0]}")
    print("=" * 60)
    
    # 檢查是否在專案根目錄
    if not Path("requirements.txt").exists():
        print("❌ 請在專案根目錄執行此腳本")
        return 1
    
    # 執行設置步驟
    steps = [
        ("創建虛擬環境", setup_venv),
        ("安裝 Python 依賴", install_python_deps),
        ("安裝 Node.js 依賴", install_node_deps),
        ("設置環境變數", setup_env_file),
    ]
    
    for step_name, step_func in steps:
        print(f"\n{'=' * 60}")
        print(f"📌 步驟: {step_name}")
        print('=' * 60)
        if not step_func():
            print(f"\n❌ 設置失敗於: {step_name}")
            return 1
    
    # 成功完成
    print("\n" + "=" * 60)
    print("✅ 環境設置完成！")
    print("=" * 60)
    
    # 顯示下一步提示
    print("\n📝 下一步:")
    if platform.system() == "Windows":
        print("  1. 啟動虛擬環境:")
        print("     .venv\\Scripts\\activate")
        print("\n  2. 執行測試:")
        print("     python scripts\\run_tests.py --platform mac")
    else:
        print("  1. 啟動虛擬環境:")
        print("     source .venv/bin/activate")
        print("\n  2. 執行測試:")
        print("     python scripts/run_tests.py --platform mac")
    
    return 0


if __name__ == "__main__":
    sys.exit(main())

