# -*- coding: utf-8 -*-
"""
Created on Wed Aug 21 11:24:05 2019

@author: Hernán
"""

import os

import selenium.webdriver.support.ui as UI

from selenium import webdriver

from time import sleep    


def obtener_datos(driver):
    wait = UI.WebDriverWait(driver, 5000) #Capaz pasar a otra parte
    licitacion = {}
   
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
    


    
     
    for key in datos:
        try:
            
                
            if key == 'nombre_empresa':
                continue

            elif key != 'tags' :
                info = driver.find_element_by_xpath(datos[key]).text 
            else:
                try:
                    #check whether the licitacion is plurianual
                    is_plurianual = driver.find_elements_by_xpath(datos[key])
                    info = "Si" if 'Plurianual' in [a.text for a in is_plurianual] else "No"
                    key = "plurianual"
                except Exception as e:
                    raise e
            if key == 'nro_contrato':
                info.replace("-", "/")
            licitacion.update({key:info})
                    
                    
        except Exception as e:
            
            licitacion.update({key:''})
            pass

    xp_new_link = '//*[@id="datos_contrato"]/div[1]/div/div/ul/li[4]/a'
    
    enlace = driver.find_element_by_xpath(xp_new_link).get_attribute('href')
    
    driver.execute_script("window.open('');")
    
    driver.switch_to.window(driver.window_handles[2])

    driver.get(enlace)
    
    sleep(0.5)
    
    xp_values = '//*[@id="datos_proveedor"]/section[1]/div/div/div/div[1]'
    
    vals = driver.find_elements_by_xpath(xp_values)


    for i, div in enumerate(vals, start = 1):

        try:
            if "nombre de " in div.text.lower():
                break
        except:
            pass

    print(licitacion['proveedor'])
    print(i)
    
    xp_name_emp = '//*[@id="datos_proveedor"]/section[1]/div/div/div[{}]/div[2]'.format(i)
    
    
    name_emp = driver.find_element_by_xpath(xp_name_emp).text

    if name_emp == "":
        name_emp = licitacion['proveedor']

    print(name_emp)
    print("------------------")

    licitacion.update({'nombre_empresa':name_emp})
    sleep(5)
    driver.close()
    
    driver.switch_to.window(driver.window_handles[1])
    return(licitacion)
  
        
