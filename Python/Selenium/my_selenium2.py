from selenium import webdriver

from selenium.webdriver.support.ui import WebDriverWait

import unittest

from time import sleep

class LoginTest(unittest.TestCase):

    def setUp(self):
        self.driver = webdriver.Chrome()
        self.driver.get('https://github.com/elvispy')

    def test_Login(self):
        searchXpath = '/html/body/div[1]/header/div[3]/div/div/form/label/input[1]'

        ButtonXpath = '//*[@id="js-pjax-container"]/div/div[1]/div[2]/div[2]/div[5]/div/div[1]/button'

        searchElement = WebDriverWait(driver, 10).until(
            lambda driver: find_element_by_xpath(searchXpath))
        buttonElement = WebDriverWait(driver, 10).until(
            lambda driver: find_element_by_xpath(ButtonXpath))

        searchElement.clear()
        searchElement.send_keys('This is what imlooking for')
        sleep(5)

        buttonElement.click()

        WebDriverWait(driver, 10).until(lambda driver: 

    def tearDown():
        self.driver.quit()
