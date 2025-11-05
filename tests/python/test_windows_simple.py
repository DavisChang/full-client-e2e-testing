#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Simple Windows Calculator Test - Compatible with WinAppDriver
Uses basic HTTP requests to work around Selenium 4 compatibility issues
"""
import pytest
import os
import time
import requests
from dotenv import load_dotenv

# Load environment
load_dotenv()

REMOTE_URL = os.getenv('WIN_REMOTE_URL', 'http://127.0.0.1:4724')
APP_ID = os.getenv('WINDOWS_APP_ID', 'Microsoft.WindowsCalculator_8wekyb3d8bbwe!App')


class TestWindowsCalculatorSimple:
    """Simple Calculator tests using direct HTTP"""
    
    def setup_method(self):
        """Create WinAppDriver session with retry logic"""
        print(f"\nConnecting to: {REMOTE_URL}")
        print(f"App: {APP_ID}")
        
        # Create session using direct HTTP POST with retry
        session_url = f"{REMOTE_URL}/session"
        payload = {
            "desiredCapabilities": {
                "app": APP_ID,
                "platformName": "Windows",
                "deviceName": "WindowsPC"
            }
        }
        
        # Retry up to 3 times as Calculator window may need time to initialize
        max_retries = 3
        last_error = None
        
        for attempt in range(max_retries):
            if attempt > 0:
                print(f"[INFO] Retrying... (attempt {attempt + 1}/{max_retries})")
                time.sleep(3)  # Wait 3 seconds before retry
            
            response = requests.post(session_url, json=payload, timeout=30)
            
            if response.status_code == 200:
                data = response.json()
                self.session_id = data.get('sessionId') or data.get('value', {}).get('sessionId')
                print(f"[OK] Session created: {self.session_id}")
                self.base_url = f"{REMOTE_URL}/session/{self.session_id}"
                
                # Additional wait to ensure window is fully loaded
                print("[INFO] Waiting for Calculator window to fully load...")
                time.sleep(2)
                print("[OK] Calculator ready")
                return
            else:
                last_error = f"Failed to create session: {response.status_code} - {response.text}"
                print(f"[WARN] Attempt {attempt + 1} failed")
        
        raise Exception(f"Failed after {max_retries} attempts: {last_error}")
    
    def teardown_method(self):
        """Close session"""
        if hasattr(self, 'session_id'):
            requests.delete(f"{REMOTE_URL}/session/{self.session_id}")
            print("\n[OK] Session closed")
    
    def _click_element_by_name(self, name):
        """Click element by name"""
        # Find element
        find_url = f"{self.base_url}/element"
        payload = {"using": "name", "value": name}
        response = requests.post(find_url, json=payload)
        
        if response.status_code != 200:
            raise Exception(f"Failed to find element '{name}': {response.text}")
        
        element_id = response.json().get('value', {}).get('ELEMENT') or response.json().get('value')
        if isinstance(element_id, dict):
            element_id = list(element_id.values())[0]
        
        # Click element
        click_url = f"{self.base_url}/element/{element_id}/click"
        requests.post(click_url, json={})
        time.sleep(0.2)
    
    def _get_result_text(self):
        """Get calculator result"""
        # Find result element
        find_url = f"{self.base_url}/element"
        payload = {"using": "accessibility id", "value": "CalculatorResults"}
        response = requests.post(find_url, json=payload)
        
        if response.status_code != 200:
            raise Exception(f"Failed to find result: {response.text}")
        
        element_id = response.json().get('value', {}).get('ELEMENT') or response.json().get('value')
        if isinstance(element_id, dict):
            element_id = list(element_id.values())[0]
        
        # Get text
        text_url = f"{self.base_url}/element/{element_id}/text"
        response = requests.get(text_url)
        result = response.json().get('value', '')
        result = result.replace("Display is", "").strip()
        return result
    
    def _clear_calculator(self):
        """Clear calculator"""
        try:
            self._click_element_by_name("Clear")
        except:
            try:
                self._click_element_by_name("Clear entry")
            except:
                pass  # Already clear
    
    def test_calculator_addition_1_plus_2(self):
        """Test: 1 + 2 = 3"""
        print("\nTest: 1 + 2 = 3")
        
        self._clear_calculator()
        self._click_element_by_name("One")
        self._click_element_by_name("Plus")
        self._click_element_by_name("Two")
        self._click_element_by_name("Equals")
        
        time.sleep(0.5)
        result = self._get_result_text()
        
        print(f"Result: {result}")
        assert "3" in result, f"Expected '3', got '{result}'"
        print("[PASS] 1 + 2 = 3")
    
    def test_calculator_addition_5_plus_5(self):
        """Test: 5 + 5 = 10"""
        print("\nTest: 5 + 5 = 10")
        
        self._clear_calculator()
        self._click_element_by_name("Five")
        self._click_element_by_name("Plus")
        self._click_element_by_name("Five")
        self._click_element_by_name("Equals")
        
        time.sleep(0.5)
        result = self._get_result_text()
        
        print(f"Result: {result}")
        assert "10" in result, f"Expected '10', got '{result}'"
        print("[PASS] 5 + 5 = 10")
    
    def test_calculator_subtraction(self):
        """Test: 10 - 3 = 7"""
        print("\nTest: 10 - 3 = 7")
        
        self._clear_calculator()
        self._click_element_by_name("One")
        self._click_element_by_name("Zero")
        self._click_element_by_name("Minus")
        self._click_element_by_name("Three")
        self._click_element_by_name("Equals")
        
        time.sleep(0.5)
        result = self._get_result_text()
        
        print(f"Result: {result}")
        assert "7" in result, f"Expected '7', got '{result}'"
        print("[PASS] 10 - 3 = 7")
    
    def test_calculator_multiplication(self):
        """Test: 4 x 5 = 20"""
        print("\nTest: 4 x 5 = 20")
        
        self._clear_calculator()
        self._click_element_by_name("Four")
        self._click_element_by_name("Multiply by")
        self._click_element_by_name("Five")
        self._click_element_by_name("Equals")
        
        time.sleep(0.5)
        result = self._get_result_text()
        
        print(f"Result: {result}")
        assert "20" in result, f"Expected '20', got '{result}'"
        print("[PASS] 4 x 5 = 20")


if __name__ == "__main__":
    pytest.main([__file__, "-v", "-s"])

