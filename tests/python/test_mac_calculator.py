#!/usr/bin/env python3
"""
Mac Calculator E2E Test
直接使用 Appium Python Client 測試 macOS Calculator
"""
import pytest
import time
from appium import webdriver
from appium.options.mac import Mac2Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class TestMacCalculator:
    """Mac Calculator 測試類別"""

    def setup_method(self):
        """在每個測試前設置 Appium session"""
        options = Mac2Options()
        options.platform_name = "mac"
        options.automation_name = "Mac2"
        options.bundle_id = "com.apple.calculator"

        self.driver = webdriver.Remote("http://127.0.0.1:4723", options=options)
        self.wait = WebDriverWait(self.driver, 10)

    def teardown_method(self):
        """在每個測試後關閉 session"""
        if self.driver:
            self.driver.quit()

    def test_calculator_addition_1_plus_2(self):
        """測試計算機加法功能：1 + 2 = 3"""
        try:
            # 點擊按鈕 1 (使用 title 屬性)
            button_1 = self.wait.until(
                EC.presence_of_element_located(
                    (By.XPATH, '//XCUIElementTypeButton[@title="1"]')
                )
            )
            button_1.click()

            # 點擊 + 號 (使用 title="+")
            button_plus = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeButton[@title="+"]'
            )
            button_plus.click()

            # 點擊按鈕 2 (使用 title="2")
            button_2 = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeButton[@title="2"]'
            )
            button_2.click()

            # 等待一下確保輸入完成
            time.sleep(0.3)

            # 點擊 = 號 (使用 label="等於")
            button_equals = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeButton[@title="="]'
            )
            button_equals.click()

            # 等待計算完成
            time.sleep(1)

            # 驗證結果 - 查找顯示結果的 StaticText (label="主要顯示方式")
            result = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeStaticText[@label="主要顯示方式"]'
            )
            result_text = result.get_attribute("value")

            assert (
                "3" in result_text
            ), f"Expected result to contain '3', but got '{result_text}'"

            print(f"✓ 測試通過！1 + 2 = {result_text}")

        except Exception as e:
            print(f"✗ 測試失敗：{e}")
            print("\n需要授予 Terminal.app accessibility 權限")
            raise

    def test_calculator_addition_5_plus_5(self):
        """測試計算機加法功能：5 + 5 = 10"""
        try:
            button_5 = self.wait.until(
                EC.presence_of_element_located(
                    (By.XPATH, '//XCUIElementTypeButton[@title="5"]')
                )
            )
            button_5.click()

            button_plus = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeButton[@title="+"]'
            )
            button_plus.click()

            button_5 = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeButton[@title="5"]'
            )
            button_5.click()

            time.sleep(0.3)

            button_equals = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeButton[@title="="]'
            )
            button_equals.click()

            time.sleep(1)

            result = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeStaticText[@label="主要顯示方式"]'
            )
            result_text = result.get_attribute("value")

            assert "10" in result_text, f"Expected '10', got '{result_text}'"

            print(f"✓ 測試通過！5 + 5 = {result_text}")

        except Exception as e:
            print(f"✗ 測試失敗：{e}")
            raise

    def test_calculator_addition_3_plus_7(self):
        """測試計算機加法功能：3 + 7 = 10"""
        try:
            button_3 = self.wait.until(
                EC.presence_of_element_located(
                    (By.XPATH, '//XCUIElementTypeButton[@title="3"]')
                )
            )
            button_3.click()

            button_plus = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeButton[@title="+"]'
            )
            button_plus.click()

            button_7 = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeButton[@title="7"]'
            )
            button_7.click()

            time.sleep(0.3)

            button_equals = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeButton[@title="="]'
            )
            button_equals.click()

            time.sleep(1)

            result = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeStaticText[@label="主要顯示方式"]'
            )
            result_text = result.get_attribute("value")

            assert "10" in result_text, f"Expected '10', got '{result_text}'"

            print(f"✓ 測試通過！3 + 7 = {result_text}")

        except Exception as e:
            print(f"✗ 測試失敗：{e}")
            raise

    def test_calculator_multiplication(self):
        """測試計算機乘法功能：4 × 5 = 20"""
        try:
            button_4 = self.wait.until(
                EC.presence_of_element_located(
                    (By.XPATH, '//XCUIElementTypeButton[@title="4"]')
                )
            )
            button_4.click()

            button_multiply = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeButton[@title="×"]'
            )
            button_multiply.click()

            button_5 = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeButton[@title="5"]'
            )
            button_5.click()

            time.sleep(0.3)

            button_equals = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeButton[@title="="]'
            )
            button_equals.click()

            time.sleep(1)

            result = self.driver.find_element(
                By.XPATH, '//XCUIElementTypeStaticText[@label="主要顯示方式"]'
            )
            result_text = result.get_attribute("value")

            assert "20" in result_text, f"Expected '20', got '{result_text}'"

            print(f"✓ 測試通過！4 × 5 = {result_text}")

        except Exception as e:
            print(f"✗ 測試失敗：{e}")
            raise

    def test_calculator_launches(self):
        """簡單測試：確認計算機應用程式成功啟動"""
        # 這個測試只確認 session 建立成功
        assert self.driver.session_id is not None
        print(f"✓ Calculator app 已成功啟動！Session ID: {self.driver.session_id}")


if __name__ == "__main__":
    # 直接執行此檔案進行測試
    pytest.main([__file__, "-v", "-s"])
