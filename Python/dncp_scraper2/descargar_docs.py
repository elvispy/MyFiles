import os

import selenium.webdriver.support.ui as UI

from selenium import webdriver

from time import sleep

import glob

def find_proveedor(rows, datos):
    name = datos['proveedor'].lower().split(" ")

    for element in rows:
        prov_name = element.find_element_by_tag_name("td").text.lower()
        
        if name[0] in prov_name:
            return element
        
    return None

def move_to_download_folder(downloadPath, fileDestination,  newFileName, fileExtension):
    ''' This function moves all downloaded files to their corresponding ones'''
    
    if os.path.isfile(fileDestination+newFileName+fileExtension):
        files = glob.glob(downloadPath+"\\*"+fileExtension)
        for file in files:
            os.remove(file)
        return None

    got_file = False   
    ## Grab current file name.
    while got_file == False:
        try: 
            currentFile = glob.glob(downloadPath+"\\*"+fileExtension)[0]
        
            got_file = True

        except Exception as e:
            print(e)
            print ("File has not finished downloading")
            sleep(2)

    ## Create new file name
    
    fileDestination = fileDestination+newFileName+fileExtension
   
    os.rename(currentFile, fileDestination)


def main(driver, year, path, datos):
    wait = UI.WebDriverWait(driver, 5000) #Capaz pasar a otra parte



    xp_ul_tabs = '/html/body/div[2]/ul'
    ul_tabs = driver.find_element_by_xpath(xp_ul_tabs)
    ul_tabs.find_element_by_link_text("Documentos").click()
    sleep(3)


    #wait until the table charges:
    table_id = wait.until(
        lambda driver: driver.find_element_by_tag_name('tbody'))

    #Get all rows
    rows = table_id.find_elements_by_tag_name("tr")
    #get the correct row


    #[print(element.find_element_by_tag_name("td").text.lower()) for element in rows]

    
    row = [element for element in rows
           if ("contrato" in
               element.find_element_by_tag_name("td").text.lower() )][0]

    #Create folders
    nomenclatura = "{nro} {id_c} {name}".format(
        nro = datos['nro_contrato'].replace("/", "-"),
        id_c = datos['id_licitacion'],
        name = datos['nombre_empresa']
        )
    if  not os.path.exists(path + "\\" + nomenclatura):
        os.makedirs(path + "\\" + nomenclatura)

    
    #Download contract
    if os.path.isfile(path + "\\" + nomenclatura + "\\Contrato " + datos['nombre_empresa'] + ".pdf"):
        pass
    else:
        row.find_elements_by_tag_name("td")[-1].find_element_by_tag_name("a").click()
    
        #Move contract to correct folder
        move_to_download_folder(path, path + "\\" + nomenclatura + "\\",
                            "Contrato " + datos['nombre_empresa'],
                            ".pdf")

    #Buscando el codigo de contratacion
    xp_back_to_convocatoria = '/html/body/div[2]/div[2]/ul/li/a'
    driver.find_element_by_xpath(xp_back_to_convocatoria).click()
    sleep(2)

    xp_monto_total = '//*[@id="datos_adjudicacion"]/section/div/div/div[9]/div[2]'
    monto_total = driver.find_element_by_xpath(xp_monto_total).text
    
    datos.update({'monto_total':monto_total})
    
    datos['monto_total'] = int(datos['monto_total'][2:].replace(".", ""))
    
    #Click to Proveedores adjudicados
    ul_tabs = driver.find_element_by_xpath(xp_ul_tabs)
    ul_tabs.find_element_by_link_text("Proveedores Adjudicados").click()

    #wait until the table charges:
    table_id = wait.until(
        lambda driver: driver.find_element_by_tag_name('tbody'))

    #Get all rows
    rows = table_id.find_elements_by_tag_name("tr")

    row_proveedor = find_proveedor(rows, datos)




    sleep(0.1)
    #Download Codigo de Contratacion
    down_button = row_proveedor.find_elements_by_tag_name("td")[-1]
    
    #row_proveedor.find_element_by_tag_name("div").find_elements_by_tag_name("a")[-1].click()
    sleep(0.1)
    enlace = down_button.find_element_by_tag_name("ul").find_element_by_tag_name("li").find_element_by_tag_name("a").get_attribute('href')
    #ver si se puede hacer mas corto

    if os.path.isfile(path + "\\" + nomenclatura + "\\Codigo Contratacion.pdf"):
        pass
    else:
        driver.execute_script("window.open('');")
        driver.switch_to.window(driver.window_handles[2])
        driver.get(enlace)

    
        move_to_download_folder(path, path + "\\" + nomenclatura + "\\",
                            "Codigo de Contratacion",
                            ".pdf")
    
        driver.close()
        driver.switch_to.window(driver.window_handles[1])

    
    '''

    #Go for pliego de bases y condiciones
    xp_convocatoria = "/html/body/div[2]/div[2]/ul/li[2]/a"
    driver.find_element_by_xpath(xp_convocatoria).click()
    sleep(2)

    #Look in the docs
    xp_ul_tabs = '/html/body/div[2]/ul'
    ul_tabs = driver.find_element_by_xpath(xp_ul_tabs)
    ul_tabs.find_element_by_link_text("Documentos").click()

    sleep(0.5)

    #Go to page 2
    xp_page2 = '//*[@id="documentos"]/div[2]/div[2]/div[2]/div/ul/li[3]/a'
    driver.find_element_by_xpath(xp_page2).click()

    

    #Check "He leido las secciones estandares de esta convocatoria
    xp_checkbox = '//*[@id="checkboxSeccionesEstandares"]'
    var = driver.find_element_by_id("checkboxSeccionesEstandares")
    #driver.find_element_by_xpath(xp_checkbox).click()
    var.click()
    print("Ya debio clicar")

    sleep(2)

    rows = driver.find_element_by_tag_name("tbody").find_elements_by_tag_name("tr")

    Pliego_bases = [row for row in rows if ("bases" in row.find_element_by_tag_name("td").text.lower())][0]

    #Check the file extension to handle it properly
    pliego_extension = Pliego_bases.find_elements_by_tag_name("td")[-2].text
    plieg_extension = pliego_extension[-4:]

    enlace = Pliego_bases.find_elements_by_tag_name("td")[-1].find_element_by_tag_name("a").get_attribute('href')
    print(enlace)

    driver.execute_script("window.open('');")
    driver.switch_to.window(driver.window_handles[2])
    driver.get(enlace)

    
    move_to_download_folder(path, path + "\\" + nomenclatura + "\\",
                            "Pliego de Bases y Condiciones",
                            pliego_extension)
    
    driver.close()
    driver.switch_to.window(driver.window_handles[1])

    
    
    '''
    return datos
