"""
Google 搜尋測試 - Python pytest 版本
測試在 Google 搜尋 "apple"
"""
import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class TestGoogleSearch:
    """Google 搜尋測試類"""
    
    driver = None
    
    def setup_method(self):
        """在每個測試前設置瀏覽器"""
        # 使用本地 Chrome（也可以配置為使用 Selenium Grid）
        self.driver = webdriver.Chrome()
        self.driver.maximize_window()
        
    def teardown_method(self):
        """在每個測試後關閉瀏覽器"""
        if self.driver:
            self.driver.quit()
    
    def test_google_search_apple(self):
        """測試在 Google 搜尋 'apple'"""
        try:
            # 1. 開啟 Google
            print("\n1. 開啟 Google...")
            self.driver.get("https://www.google.com")
            
            # 2. 等待搜尋框出現
            print("2. 等待搜尋框...")
            search_box = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.NAME, "q"))
            )
            
            # 3. 輸入搜尋關鍵字 "apple"
            print("3. 輸入搜尋關鍵字: apple")
            search_box.clear()
            search_box.send_keys("apple")
            
            # 4. 按下 Enter 搜尋
            print("4. 執行搜尋...")
            search_box.send_keys(Keys.RETURN)
            
            # 5. 等待搜尋結果（等待 URL 改變）
            print("5. 等待搜尋結果...")
            import time
            time.sleep(3)  # 給頁面一些時間載入
            
            # 6. 驗證頁面標題包含搜尋關鍵字
            title = self.driver.title
            print(f"6. 頁面標題: {title}")
            assert "apple" in title.lower(), f"頁面標題不包含 'apple': {title}"
            
            # 7. 驗證頁面包含 "Apple" 關鍵字
            print("7. 驗證搜尋結果...")
            page_source = self.driver.page_source
            assert "Apple" in page_source, "搜尋結果中沒有找到 'Apple'"
            
            # 8. 嘗試找到搜尋結果區塊
            print("8. 檢查搜尋結果區塊...")
            try:
                results = self.driver.find_elements(By.CSS_SELECTOR, "h3")
                print(f"   找到 {len(results)} 個搜尋結果標題")
                if len(results) > 0:
                    print(f"   第一個結果: {results[0].text[:50]}...")
            except:
                print("   無法檢查搜尋結果詳情")
            
            print("\n✅ 測試通過！Google 搜尋 'apple' 成功")
            
        except Exception as e:
            print(f"\n❌ 測試失敗: {e}")
            # 截圖用於除錯
            try:
                self.driver.save_screenshot("google_search_error.png")
                print(f"錯誤截圖已保存: google_search_error.png")
            except:
                pass
            raise
    
    def test_google_homepage_loads(self):
        """測試 Google 首頁能否正常載入"""
        print("\n1. 開啟 Google 首頁...")
        self.driver.get("https://www.google.com")
        
        print("2. 驗證頁面標題...")
        assert "Google" in self.driver.title, f"頁面標題不正確: {self.driver.title}"
        
        print("3. 驗證搜尋框存在...")
        search_box = WebDriverWait(self.driver, 10).until(
            EC.presence_of_element_located((By.NAME, "q"))
        )
        assert search_box.is_displayed(), "搜尋框未顯示"
        
        print("\n✅ Google 首頁載入測試通過！")

