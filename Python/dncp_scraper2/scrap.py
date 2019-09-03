# -*- coding: utf-8 -*-
"""
Created on Mon Sep 1 07:05:40 2019

@authors: Hernán & Elvis
"""


from selenium import webdriver

import re
import os


import selenium.webdriver.support.ui as UI
from random import randint
from time import sleep
import datetime

import buscar_contrato
import datos_contrato
import descargar_docs
import formatt



def main(municipio = "Hernandarias", year = datetime.datetime.now().year):
    #Convocante de las licitaciones
    year = str(year)
    convocante = 'Municipalidad de '+ municipio

    ###### Change Download folder
    path = os.getcwd()+"\\Temps\\" + year
    if  not os.path.exists(os.getcwd() + "\\Temps\\" + year):
        os.makedirs(os.getcwd() + "\\Temps\\" + year)

    chrome_options = webdriver.ChromeOptions()
    prefs = {'download.default_directory' : path}
    chrome_options.add_experimental_option('prefs', prefs)
    driver = webdriver.Chrome(options=chrome_options)
    #wait until "Busqueda Avanzada" button is available
    sleep(0.5)

    wait = UI.WebDriverWait(driver, 5000)


    web_url = 'https://www.contrataciones.gov.py/buscador/contratos.html'
    driver.get(web_url)
    sleep(2)



    buscar_contrato.buscar_contrato(convocante, year, driver)
    solo_contratos = [] #Lista de contratos
    solo_licitacion = [] 

        
    ### Resultado de busqueda
    xp_nombres_licit = '//*[@id="contratos"]/ul/li/article/header/h3/a'
    xp_etapas_licit = '//*[@id="contratos"]/ul/li/article/div/div[1]/div[1]/div[2]/em'
    nombres_licitacion = driver.find_elements_by_xpath(xp_nombres_licit)
    etapas_licit = driver.find_elements_by_xpath(xp_etapas_licit)

    ## Hacer esto cada vez que se vuelve a la lista de resultados
    #i = 0 #para iterar sobre resultados en nombres
    for i, etapa in enumerate(etapas_licit):

        
        if etapa.text == 'Adjudicada':
            #enter to the licitacion
            enlace = nombres_licitacion[i].get_attribute('href')
            driver.execute_script("window.open('');")
            driver.switch_to.window(driver.window_handles[1])
            driver.get(enlace)
            sleep(3)

            contrato_out = datos_contrato.obtener_datos(driver)
            
            contrato_out.update({'periodo':int(year)})
            
            contrato_out = formatt.main(contrato_out)
            
            #Download files and get total amount.
            contrato_out = descargar_docs.main(driver, year, path,  contrato_out)
            
            solo_contratos.append(contrato_out)

            driver.close()
            driver.switch_to.window(driver.window_handles[0])

    driver.close()
    return solo_contratos

if __name__ == '__main__':

    datos = main()

