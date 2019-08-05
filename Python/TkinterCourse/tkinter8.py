from tkinter import *

Vmain = Tk()
Vmain.geometry('500x500')

def fnOnClickAceptar():

    lblMensaje['text'] = 'Has Aceptado la Operacion'
    btnAceptar.config(text='Ok')


    btnAceptar['state'] = DISABLED

    btnCancelar.config(state = NORMAL)

    imgDisable = PhotoImage(file = 'nin.png')

    btnCancelar.configure(image = imgDisable, compound = LEFT)

    btnCancelar.image = imgDisable



def fnOnClickCancelar():
    
    lblMensaje['text'] = 'Has Cancelado la Operacion'

    btnCancelar.place_forget()

imgAceptar = PhotoImage(file='radiologo.gif')

btnAceptar = Button(Vmain,
                    text = 'Aceptar',
                    activebackground = '#ED6A5A',
                    image = imgAceptar,
                    compound = LEFT,
                    width = 75,
                    height = 50,
                    activeforeground = '#F4F1BB',
                    command = fnOnClickAceptar)

btnCancelar = Button(Vmain, text = 'Cancelar',
                     bg = '#9BC1BC',
                     state = DISABLED,
                     command = fnOnClickCancelar)


lblMensaje = Label(Vmain, text = 'Clickee sobre un boton',
                   relief = FLAT)

lblToolTip = Label(Vmain,
                   text = 'Ayuda del Sistema',
                   relief = RAISED)

lblToolTip.place(x = 0,y = 100)
lblToolTip.place_forget()

btnAceptar.place(x = 50, y = 20)

btnCancelar.place(x =150, y = 50)

def fnToolTipAceptarOn(evento):
    sTexto = btnAceptar['text']

    btnAceptar['bg'] = '#E6EBE0'

    if sTexto == 'Ok':
        lblToolTip['text'] = 'Ya has aceptado la operacion'
    else:

        lblToolTip['text'] = 'Si presionas Aceptaras la operacion'

    lblToolTip.place(x = 50, y =80)

def fnToolTipCancelarOn(evento):

    lblToolTip['text'] = 'Si presionas Cancelaras la Operacion'

    lblToolTip.place(x = 150, y = 80)

def fnToolTipOff(evento):

    lblToolTip.place_forget()

    btnAceptar['bg'] = 'white'

btnAceptar.bind('<Enter>', fnToolTipAceptarOn)

btnCancelar.bind('<Enter>', fnToolTipCancelarOn)

btnAceptar.bind('<Leave>', fnToolTipOff)

btnCancelar.bind('<Leave>', fnToolTipOff)


Vmain.mainloop()
