# -*- coding: utf-8 -*-
"""
Created on Mon Aug 19 20:14:29 2019

@author: Hernán
"""
from selenium.webdriver.common.keys import Keys
from time import sleep



def buscar_contrato(convocante, year, driver):
    xp_lista_convocantes = '//*[@id="convocantes"]'
    xp_criterios_avanzados = '//*[@id="headingOne"]/h4/a' 
    xp_caract_esp = '//*[@id="collapseOne"]/div/div[1]/div/span[1]/span[1]/span/ul/li/input'
    xp_buscar = '//*[@id="btn_buscar"]'

    xp_year_inicio = '//*[@id="fecha_desde"]'
    xp_year_final = '//*[@id="fecha_hasta"]'
    xp_tipo_fecha = '//*[@id="tipo_fecha"]/option[3]'
    
    year_inicio = '01-01-{}'.format(year)
    year_final = '31-12-{}'.format(year)


    

    #Setting the convocante
    lista_convocantes = driver.find_element_by_xpath(xp_lista_convocantes)
    
    for option in lista_convocantes.find_elements_by_tag_name('option'):
        if option.text == convocante:
            option.click() 
            break


    #Setting dates
    driver.find_element_by_xpath(xp_year_inicio).send_keys(year_inicio, Keys.RETURN)
    driver.find_element_by_xpath(xp_year_final).send_keys(year_final, Keys.RETURN)
    driver.find_element_by_xpath(xp_tipo_fecha).click()
    
    
    #restricting to fonacide
    driver.find_element_by_xpath(xp_criterios_avanzados).click()
    sleep(0.5)
    #DONT MOVE THE SCREEN
    driver.find_element_by_xpath(xp_caract_esp).send_keys("Fonacide", Keys.RETURN)
    sleep(2)
    driver.find_element_by_xpath(xp_buscar).click()
    sleep(5)

    
