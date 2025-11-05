from appium import webdriver
from appium.options.mac import Mac2Options
from robot.libraries.BuiltIn import BuiltIn


class appium_helper:
    """Helper library for Mac Appium automation."""
    
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    
    def __init__(self):
        self.driver = None
    
    def create_mac_session(self, remote_url, capabilities):
        """Create an Appium session for Mac automation."""
        # Debug output
        print(f"DEBUG: Creating Mac session")
        print(f"DEBUG: Remote URL: {remote_url}")
        print(f"DEBUG: Capabilities type: {type(capabilities)}")
        print(f"DEBUG: Capabilities: {capabilities}")
        
        options = Mac2Options()
        
        # Set required capabilities
        options.platform_name = capabilities.get('platformName', 'mac')
        options.automation_name = capabilities.get('automationName', 'Mac2')
        
        # Set app-specific options from appium: prefixed capabilities
        for key, value in capabilities.items():
            if key.startswith('appium:'):
                clean_key = key.replace('appium:', '')
                if clean_key == 'bundleId':
                    options.bundle_id = value
                elif clean_key == 'arguments':
                    options.arguments = value
                elif clean_key == 'newCommandTimeout':
                    options.new_command_timeout = value
                else:
                    options.set_capability(key, value)
        
        print(f"DEBUG: Final capabilities: {options.to_capabilities()}")
        
        self.driver = webdriver.Remote(remote_url, options=options)
        
        return self.driver
    
    def find_element(self, locator):
        """Find element using Appium."""
        strategy, value = locator.split('=', 1)
        if strategy == 'xpath':
            return self.driver.find_element('xpath', value)
        return self.driver.find_element(strategy, value)
    
    def click_element(self, locator):
        """Click an element."""
        element = self.find_element(locator)
        element.click()
    
    def get_text(self, locator):
        """Get text from an element."""
        element = self.find_element(locator)
        return element.text
    
    def quit_driver(self):
        """Quit the Appium driver."""
        if self.driver:
            self.driver.quit()
            self.driver = None

