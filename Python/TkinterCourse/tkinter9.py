from tkinter import *

Vmain = Tk()

Vmain.geometry('280x120+80+80')

Vmain.title('A09 ENTRY')

lblUsuario = Label(Vmain, text = 'Usuario: ')
lblUsuario.place(x=20, y = 20)

def fnKeyPressUsuario(key):
    print(key.keycode)
    print(key.char)

    if key.keycode == 27:
        Vmain.destroy()
    elif key.keycode == 13:
        
        print(txtUsuario.get())
        #txtUsuario.set('Probando prro')

txtUsuario = Entry(Vmain, bd = 5, justify = RIGHT)

txtUsuario.place(x = 120, y = 20)

lblContra = Label(Vmain, text = 'Password: ')

lblContra.place(x = 20, y = 60)

txtPass = Entry(Vmain)

txtPass.place(x = 120, y = 60)

def fnKeyPressClave(key):
    print(key.keycode)
    print(key.char)
    if key.keycode == 27:
        Vmain.destroy()
    elif key.keycode == 13:
        txtPass.insert(5,'insertado')

btnAceptar = Button(Vmain, text = 'Aceptar', activebackground = 'white',
                    width = 10,
                    activeforeground = 'green')
btnAceptar.place(x = 20, y = 80)

txtPass.bind('<Key>', fnKeyPressClave)
txtUsuario.bind('<Key>', fnKeyPressUsuario)
Vmain.mainloop()

