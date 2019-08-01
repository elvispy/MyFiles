from tkinter import *

Vmain = Tk()

Vmain.title("Creando botones")

Vmain.geometry("400x200")

def fnOnAceptar():
    lblMensaje['text'] = 'Has Aceptado la Operacion'
    btnAceptar.config(text = 'Ok')

def fnOnCancelar():

    lblMensaje['text'] = 'Has Cancelado la Operacion'

    btnCancelar.place_forget()

btnAceptar = Button(Vmain,
                    text = 'Aceptar',
                    command = fnOnAceptar)

btnAceptar.place(x = 50, y = 50)

btnCancelar = Button(Vmain, text = "Cancelar",
                     bg = 'green',
                     command = fnOnCancelar)

btnCancelar.place(x = 150, y=50)

lblMensaje = Label(Vmain, text = "Acerca el Apuntador del mouse a los Botones",
                   relief = FLAT)

lblMensaje.place(x=10, y=10)#colocando el mensaje en el window

lblToolTip = Label(Vmain,
                   text = 'Ayuda del Sistema',
                   relief = RAISED)

lblToolTip.place(x=0, y=100)
lblToolTip.place_forget()

def fnToolTipAceptarOn(evento):

    sTexto = btnAceptar['text'] #obteniendo el texto del boton


    if (sTexto == "Ok"):

        lblToolTip['text'] = 'Ya has aceptado la operacion'

    else:

        lblToolTip['text'] = 'Si presionas Acpetaras la operacion'

    lblToolTip.place(x = 0, y = 100)

def fnToolTipCancelarOn(evento):

    lblToolTip['text'] = 'Si presionas Cancelaras la Operacion'

    lblToolTip.place(x = 0, y = 100)

def fnToolTipOff(evento):

    lblToolTip.place_forget()


btnAceptar.bind('<Enter>', fnToolTipAceptarOn)

btnCancelar.bind('<Enter>', fnToolTipCancelarOn)

btnAceptar.bind('<Leave>', fnToolTipOff)

btnCancelar.bind('<Leave>', fnToolTipOff)

Vmain.mainloop()

    

