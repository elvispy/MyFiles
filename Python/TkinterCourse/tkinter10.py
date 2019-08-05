from tkinter import *

Vmain = Tk()

Vmain.geometry('100x300')

Vmain.title('A10 Entry text')

def fnEliminar():
    '''This will delete the second char in the entry (list indexed)'''
    txtPrueba.delete(1) 

def fnEliminarAll():
    '''This will empty the entry'''
    txtPrueba.delete(0,len(txtPrueba.get()))

def fnSeleccionar():
    '''The will select all chars in the entry'''
    txtPrueba.select_range(0,len(txtPrueba.get()))

def fnDesSeleccionar():
    '''This function will unselect all text in the entry'''
    txtPrueba.select_clear()

def fnColocaCursor():
    '''this will put the text cursor in the third spot'''
    txtPrueba.icursor(3)

def fnSeleccionarHasta():
    '''This will select the first three chars'''
    txtPrueba.select_adjust(3)

def fnVerificaSel():
    '''This will print True if there is text selected'''
    print(txtPrueba.selection_present())

txtPrueba = Entry(Vmain)

txtPrueba.pack()

btnEliminar = Button(Vmain, text = 'Eliminar 1er', command = fnEliminar)

btnEliminar.pack()

btnEliminarAll = Button(Vmain, text  = 'Eliminar todo', command = fnEliminarAll)

btnEliminarAll.pack()

btnSeleccionar = Button(Vmain, text = 'Seleccionar Todo', command = fnSeleccionar)

btnSeleccionar.pack()

btnDesSeleccionar = Button(Vmain, text = 'Deseleccionar todo', command = fnDesSeleccionar)

btnDesSeleccionar.pack()

btnColocaCursor = Button(Vmain, command = fnColocaCursor, text = 'COlocar Cursor')

btnColocaCursor.pack()

btnSeleccionarHasta = Button(Vmain, command = fnSeleccionarHasta,
                             text = ' Seleccionar hasta')
btnSeleccionarHasta.pack()

btnVerificaSel = Button(Vmain, text = 'Verificar Seleccion', command = fnVerificaSel)

btnVerificaSel.pack()

Vmain.mainloop()
