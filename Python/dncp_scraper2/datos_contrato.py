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

   
    datos={
        'id_licitacion' : '//*[@id="datos_contrato"]/section[2]/div/div/div[1]/div[2]/em',
        'proveedor' : '//*[@id="datos_contrato"]/section[1]/div/div/div[1]/div[2]/em',
        'nombre_licitacion' : '//*[@id="datos_contrato"]/section[2]/div/div/div[2]/div[2]/em',
        'convocante' : '//*[@id="datos_contrato"]/section[2]/div/div/div[3]/div[2]',
        'fecha_firma': '//*[@id="datos_contrato"]/section[1]/div/div/div[4]/div[2]',
        'categoria' : '//*[@id="datos_contrato"]/section[2]/div/div/div[5]/div[2]',
        'nro_contrato': '//*[@id="datos_contrato"]/section[1]/div/div/div[3]/div[4]',
        'monto_adjudicado':'//*[@id="datos_contrato"]/section[1]/div/div/div[3]/div[2]',
        'tags':'//*[@id="datos_contrato"]/div[2]/span',
        'RUC':'//*[@id="datos_contrato"]/section[1]/div/div/div[1]/div[4]'
        }
    
    licitacion = {} 
    for key in datos:
        try:
            if key != 'tags':
                info = driver.find_element_by_xpath(datos[key]).text
                
            else:
                try:
                    #check whether the licitacion is plurianual
                    is_plurianual = driver.find_elements_by_xpath(datos[key])
                    info = "Si" if 'Plurianual' in [a.text for a in is_plurianual] else "No"
                    print(info)
                except Exception as e:
                    raise e
                
            licitacion.update({key:info})
                    
                    
        except Exception as e:
            
            licitacion.update({key:''})
            pass
    return(licitacion)
  
        
