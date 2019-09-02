# -*- coding: utf-8 -*-
"""
Created on Tue Aug 20 15:44:30 2019

@author: Hernán
"""

##Lo que se pide en doc reAc:
#No. N° - No hace falta
#No. Año - Se estira de fecha
#Si. N° de contrato
#Si. Empresa
#Si. Fecha de contrato
#Si. Monto total (₲)
#Si. Titulo de contrato
#No. Institución beneficiada
#No. Nº Instituciones beneficiadas
#No. Barrio/Localidad
#No. Monto FONACIDE
#No. Monto Individual (₲)
#No. Puesto en lista de priorización, Aula, Sanitario, Otros espacios
#No. Descripción de obra según título de contrato. 
#
#Guardar:
#    ID de licitacion
#    Fecha de firma de contrato
#    N° de contrato
#    nombre de empresa
#    ruc
#    monto de contrato
#    titulo de contrato

#from selenium import webdriver
import os
import re
import down_utils
import selenium.webdriver.support.ui as UI
from random import randint
from time import sleep
'''

def obtener_datos(driver):
    wait = UI.WebDriverWait(driver, 5000) #Capaz pasar a otra parte
    datos={
    'id_licitacion' : '//*[@id="datos_contrato"]/section[2]/div/div/div[1]/div[2]/em', 
    'fecha_firma_contrato' : '//*[@id="datos_contrato"]/section[1]/div/div/div[4]/div[2]',
    'num_contrato' : '//*[@id="datos_contrato"]/section[1]/div/div/div[3]/div[4]',
    'nombre_empresa' : '//*[@id="datos_contrato"]/section[1]/div/div/div[1]/div[2]/em',
    'ruc_empresa' : '//*[@id="datos_contrato"]/section[1]/div/div/div[1]/div[4]',
    'monto_adjudicado' : '//*[@id="datos_contrato"]/section[1]/div/div/div[3]/div[2]',
    'titulo_contrato' : '/html/body/div[2]/div[1]/h1',
    'municipio' : '//*[@id="datos_contrato"]/section[2]/div/div/div[3]/div[2]',
    }
    
    
    contrato = {}

    for key in datos:
        try:
          info = driver.find_element_by_xpath(datos[key]).text
          contrato.update({key:info})
        except:
            contrato.update({key:''})
            pass
    
    #Descarga del código de contratación
    xp_codigo_contratacion = '//*[@id="datos_contrato"]/div[1]/div/div/ul/li[5]/a'
    driver.find_element_by_xpath(xp_codigo_contratacion).click() 
    
    dest_path = (os.getcwd() +
                 '\\docs\\' + 
                 contrato['municipio'] + 
                 '\\' + 
                 contrato['fecha_firma_contrato'][-4:] + 
                 '\\' +
                 re.search("^(\d{2,3})", contrato['num_contrato']).group(1) + 
                 ' ' +
                 contrato['fecha_firma_contrato'][-4:] + 
                 ' ' +            
                 contrato['id_licitacion'] + ' ' +            
                 contrato['nombre_empresa'].title() +
                 '\\')
    
    #Asegurar que la carpeta de contrato existe
    down_utils.make_path(dest_path)
    
    directory = 'Downloads' #Carpeta default para descargar archivos. Configurado también al inciar Selenium
    descarga = down_utils.wait_rename(dest_path, directory, timeout = 30)
    contrato.update({'codigo_contratacion' : descarga})

    ### Navegar a la pestaña de documentos
    xp_documentos = '/html/body/div[2]/ul/li[4]/a'
    driver.find_element_by_xpath(xp_documentos).click() 

    ##### Encontrar el contrato
    #Funcion de encontrar en tabla, si no se encuentra pasar a la otra pagina si hay
    #Si no hay pagina o sino se encuentra en ninguna pagina guardar false
    
    #def downl_from_table(down):
    contrato_down = False
    table_id = wait.until(
            lambda driver: driver.find_element_by_tag_name('tbody'))
    # get all of the rows in the table
    rows = table_id.find_elements_by_tag_name("tr") 
    for row in rows:
        cols = row.find_elements_by_tag_name("td")
        #print('test')
        if cols[0].text == 'Orden de Compra o Contrato':
            contrato_down = True
            link = cols[3].find_element_by_tag_name("a")
            link.click()
            break
    
    if contrato_down == True:
        directory = 'Downloads' #Carpeta default para descargar archivos. Configurado también al inciar Selenium
        contrato_down = down_utils.wait_rename(dest_path, directory, timeout = 30)
        contrato.update({'contrato_download' : contrato_down})
    else:
        contrato.update({'contrato_download' : False})
                
    
    
    #Pasar a la página 2 de la tabla de documentos
    #xp_pagina2 = '//*[@id="documentos"]/div[2]/div[2]/div[2]/div/ul/li[3]/a'
    #driver.find_element_by_xpath(xp_pagina2).click()
    return(contrato)
    
    
'''
def entrar_guardar_datos(driver, link_contrato):
    wait = UI.WebDriverWait(driver, 5000) #Capaz pasar a otra parte
    
    
    
    driver.execute_script("window.open('');")
    driver.switch_to.window(driver.window_handles[2])
    driver.get(link_contrato)
    sleep(randint(5,10))
    
    '''
    
    datos={
    'id_licitacion' : '//*[@id="datos_planificacion"]/section/div/div/div[1]/div[2]/em', 
    'fecha_firma_contrato' : '//*[@id="datos_contrato"]/section[1]/div/div/div[4]/div[2]',
    'num_contrato' : '//*[@id="datos_contrato"]/section[1]/div/div/div[3]/div[4]',
    'nombre_empresa' : '//*[@id="datos_contrato"]/section[1]/div/div/div[1]/div[2]/em',
    'ruc_empresa' : '//*[@id="datos_contrato"]/section[1]/div/div/div[1]/div[4]',
    'monto_adjudicado' : '//*[@id="datos_contrato"]/section[1]/div/div/div[3]/div[2]',
    'titulo_contrato' : '/html/body/div[2]/div[1]/h1',
    'municipio' : '//*[@id="datos_contrato"]/section[2]/div/div/div[3]/div[2]',
    }
    
    
    contrato = {}

    for key in datos:
        try:
          info = driver.find_element_by_xpath(datos[key]).text
          contrato.update({key:info})
        except:
            contrato.update({key:''})
            pass
    '''
    
    #Descarga del código de contratación
    xp_codigo_contratacion = '//*[@id="datos_contrato"]/div[1]/div/div/ul/li[5]/a'
    driver.find_element_by_xpath(xp_codigo_contratacion).click() 
    
    dest_path = (os.getcwd() +
                 '\\docs\\' + 
                 contrato['municipio'] + 
                 '\\' + 
                 contrato['fecha_firma_contrato'][-4:] + 
                 '\\' +
                 re.search("^(\d{2,3})", contrato['num_contrato']).group(1) + 
                 ' ' +
                 contrato['fecha_firma_contrato'][-4:] + 
                 ' ' +            
                 contrato['id_licitacion'] + ' ' +            
                 contrato['nombre_empresa'].title() +
                 '\\')
    
    #Asegurar que la carpeta de contrato existe
    down_utils.make_path(dest_path)
    
    directory = 'Downloads' #Carpeta default para descargar archivos. Configurado también al inciar Selenium
    descarga = down_utils.wait_rename(dest_path, directory, timeout = 30)
    contrato.update({'codigo_contratacion' : descarga})

    ### Navegar a la pestaña de documentos
    xp_ul_tabs = '/html/body/div[2]/ul'
    ul_tabs = driver.find_element_by_xpath(xp_ul_tabs)
    ul_tabs.find_element_by_link_text("Documentos").click()#.get_attribute('href')
    
    #OLD CODE
    #xp_documentos = '/html/body/div[2]/ul/li[4]/a'
    #driver.find_element_by_xpath(xp_documentos).click() 

    ##### Encontrar el contrato
    #Funcion de encontrar en tabla, si no se encuentra pasar a la otra pagina si hay
    #Si no hay pagina o sino se encuentra en ninguna pagina guardar false
    
    #def downl_from_table(down):
    contrato_down = False
    table_id = wait.until(
            lambda driver: driver.find_element_by_tag_name('tbody'))
    # get all of the rows in the table
    rows = table_id.find_elements_by_tag_name("tr") 
    for row in rows:
        cols = row.find_elements_by_tag_name("td")
        #print('test')
        if cols[0].text == 'Orden de Compra o Contrato':
            contrato_down = True
            link = cols[3].find_element_by_tag_name("a")
            link.click()
            break
    
    if contrato_down == True:
        directory = 'Downloads' #Carpeta default para descargar archivos. Configurado también al inciar Selenium
        contrato_down = down_utils.wait_rename(dest_path, directory, timeout = 30)
        contrato.update({'contrato_download' : contrato_down})
    else:
        contrato.update({'contrato_download' : False})
                
    
    
    #Pasar a la página 2 de la tabla de documentos
    #xp_pagina2 = '//*[@id="documentos"]/div[2]/div[2]/div[2]/div/ul/li[3]/a'
    #driver.find_element_by_xpath(xp_pagina2).click()
       
    driver.close()
    driver.switch_to.window(driver.window_handles[1])
    
    
    
    return(contrato)
