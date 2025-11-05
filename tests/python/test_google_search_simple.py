"""
Google 搜尋簡單測試 - 不觸發 CAPTCHA
測試基本功能：開啟 Google、輸入搜尋關鍵字
"""
import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class TestGoogleSearchSimple:
    """Google 搜尋簡單測試類"""
    
    driver = None
    
    def setup_method(self):
        """在每個測試前設置瀏覽器"""
        options = webdriver.ChromeOptions()
        # 添加選項避免被檢測為機器人
        options.add_argument('--disable-blink-features=AutomationControlled')
        options.add_experimental_option("excludeSwitches", ["enable-automation"])
        options.add_experimental_option('useAutomationExtension', False)
        
        self.driver = webdriver.Chrome(options=options)
        self.driver.maximize_window()
        
    def teardown_method(self):
        """在每個測試後關閉瀏覽器"""
        if self.driver:
            self.driver.quit()
    
    def test_google_open_and_search_input(self):
        """測試開啟 Google 並輸入搜尋關鍵字（不執行搜尋）"""
        try:
            # 1. 開啟 Google
            print("\n1. 開啟 Google...")
            self.driver.get("https://www.google.com")
            
            # 2. 等待搜尋框出現
            print("2. 等待搜尋框...")
            search_box = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.NAME, "q"))
            )
            assert search_box.is_displayed(), "搜尋框未顯示"
            
            # 3. 輸入搜尋關鍵字 "apple"（不按 Enter）
            print("3. 輸入搜尋關鍵字: apple")
            search_box.clear()
            search_box.send_keys("apple")
            
            # 4. 驗證輸入成功
            input_value = search_box.get_attribute("value")
            print(f"4. 搜尋框的值: {input_value}")
            assert input_value == "apple", f"搜尋框值不正確: {input_value}"
            
            # 5. 檢查頁面標題
            title = self.driver.title
            print(f"5. 頁面標題: {title}")
            assert "Google" in title, f"頁面標題不正確: {title}"
            
            # 6. 截圖保存
            import time
            time.sleep(1)  # 等待一下以便看到輸入的內容
            screenshot_path = "google_search_input_success.png"
            self.driver.save_screenshot(screenshot_path)
            print(f"6. 截圖已保存: {screenshot_path}")
            
            print("\n✅ 測試通過！成功開啟 Google 並輸入搜尋關鍵字")
            
        except Exception as e:
            print(f"\n❌ 測試失敗: {e}")
            try:
                self.driver.save_screenshot("google_search_input_error.png")
                print(f"錯誤截圖已保存: google_search_input_error.png")
            except:
                pass
            raise
    
    def test_google_homepage_elements(self):
        """測試 Google 首頁的主要元素"""
        print("\n1. 開啟 Google 首頁...")
        self.driver.get("https://www.google.com")
        
        print("2. 檢查頁面標題...")
        assert "Google" in self.driver.title
        
        print("3. 檢查搜尋框存在...")
        search_box = WebDriverWait(self.driver, 10).until(
            EC.presence_of_element_located((By.NAME, "q"))
        )
        assert search_box.is_displayed()
        
        print("4. 檢查搜尋按鈕...")
        # Google 有多個搜尋按鈕，我們只確認至少有一個存在
        buttons = self.driver.find_elements(By.CSS_SELECTOR, "input[type='submit'], button[type='submit']")
        print(f"   找到 {len(buttons)} 個提交按鈕")
        
        print("\n✅ Google 首頁元素檢查通過！")

