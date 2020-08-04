

from selenium import webdriver
import selenium.webdriver.support.ui as UI
import os
from time import sleep

def main():
    
    web_url = "https://www.facebook.com/lucas.d.ricardo/posts/2954952581254233"
    #path = os.getcwd()
    #prefs = {'download.default_directory' : path}
    driver = webdriver.Chrome()
    sleep(0.5)
    
    wait = UI.WebDriverWait(driver, 5000)
    driver.get(web_url)
    sleep(15)

if __name__ == '__main__':
    main()
