from selenium import webdriver

import os

from random import randint
from time import sleep
import selenium.webdriver.support.ui as UI

chrome_options = webdriver.ChromeOptions()

prefs = {'download.default_directory' : os.getcwd() }
chrome_options.add_experimental_option('prefs', prefs)
driver = webdriver.Chrome(options= chrome_options)


wait = UI.WebDriverWait(driver, 5000)

web_url = 'https://github.com/elvispy'

driver.get(web_url)
sleep(7)

abr = driver.find_elements_by_xpath('//*[@id="js-pjax-container"]/div/div[3]/div[3]/div[1]/div/ol/li[4]/div/div/div/a/span').click()

#link = driver.find_element_by_xpath('//*[@id="bar-horizontal"]/svg/g/g[2]/g[1]/rect').click()

driver.close()
