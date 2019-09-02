# -*- coding: utf-8 -*-
"""
Created on Wed Aug 21 11:24:05 2019

@author: Hernán
"""

import os

import selenium.webdriver.support.ui as UI

from time import sleep    


def obtener_datos(driver):
    wait = UI.WebDriverWait(driver, 5000) #Capaz pasar a otra parte

    #driver.switch_to.window(ventana)
    #print(driver.title)
    xp_ul_steps = '/html/body/div[2]/div[2]/ul'
    ul_steps = driver.find_element_by_xpath(xp_ul_steps)
    step = ul_steps.find_element_by_class_name("active").text.lower()
    step = step.replace('ó','o')

   
    datos={
        'id_licitacion' : '//*[@id="datos_contrato"]/section[2]/div/div/div[1]/div[2]/em',
        'proveedor' : '//*[@id="datos_contrato"]/section[1]/div/div/div[1]/div[2]/em',
        'nombre_licitacion' : '//*[@id="datos_contrato"]/section[2]/div/div/div[2]/div[2]/em',
        'convocante' : '//*[@id="datos_contrato"]/section[2]/div/div/div[3]/div[2]',
        'fecha_firma': '//*[@id="datos_contrato"]/section[1]/div/div/div[4]/div[2]',
        'categoria' : '//*[@id="datos_contrato"]/section[2]/div/div/div[5]/div[2]',
        'nro_contrato': '//*[@id="datos_contrato"]/section[1]/div/div/div[3]/div[4]'
        'monto' : '//*[@id="datos_contrato"]/section[1]/div/div/div[3]/div[2]',
        'tags':'//*[@id="datos_contrato"]/div[2]/span'
        }
    
    licitacion = {} 
    for key in datos:
        try:
            if key != 'tags':
                info = driver.find_element_by_xpath(datos[key]).text
                
            else:
                #check whether the licitacion is plurianual
                is_plurianual = driver.find_elements_by_xpath(datos[key])
                info = 'Plurianual' in [a.text for a in info]
                print(info)
                
            licitacion.update({key:info})
                    
                    
        except:
            licitacion.update({key:''})
            pass
    
    return(licitacion)
  
        
