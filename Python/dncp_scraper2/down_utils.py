# -*- coding: utf-8 -*-
"""
Created on Mon Aug 19 22:15:56 2019

@author: Hernán
"""
#From https://stackoverflow.com/questions/32123394/workflow-to-create-a-folder-if-it-doesnt-exist-already
import os
import errno
import time
from pathlib import Path


def make_path(path):
    try:
        os.makedirs(path)
    except OSError as exception:
        if exception.errno != errno.EEXIST:
            raise


#https://stackoverflow.com/questions/34338897/python-selenium-find-out-when-a-download-has-completed            
def wait_rename(dest_path, directory, timeout = 30):
    """
    Wait for downloads to finish with a specified timeout.

    Args
    ----
    dest_path: int, defaults to None
        The path to the destination folder.
    directory : str
        The path to the folder where the files will be downloaded.
    timeout : int
        How many seconds to wait until timing out.
    
    """
    
    seconds = 0
    dl_complete = False
    
    while dl_complete == False and seconds < timeout:
        time.sleep(1)
        chrome_temp_file = sorted(Path(directory).glob('*.crdownload'))
        downloaded_files = sorted(Path(directory).glob('*.*'))
        if (len(chrome_temp_file) == 0) and \
           (len(downloaded_files) >= 1):
            #Renombrar
            #https://stackoverflow.com/questions/8858008/how-to-move-a-file-in-python
            dest_path = dest_path + os.path.basename(downloaded_files[0])
            os.rename(downloaded_files[0], dest_path)
            dl_complete = True
        seconds += 1
    
    return dl_complete
            