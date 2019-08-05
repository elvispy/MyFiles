from tkinter import *

Vmain = Tk()

Vmain.geometry("800x600+10+10")

Vmain.title("Este es un titulo")

xstring = StringVar()

xstring.set("Texto en un Label")

xColor = "#%02x%02x%02x" %(182, 192, 200)

lblMensaje = Label(Vmain, textvariable = xstring,
                   bg = "blue", #color de fondo
                   fg = xColor, #color de texto
                   relief = RAISED) #tipo de borde SUNKEN RAISED GROOVE RIDGE FLAT

lblMensaje.pack()

xstring2 = StringVar()

xstring2.set("Este es un segundo Label")

xfont = ("Helvetica", 10, "bold italic")

lblMensaje2 = Label(Vmain,
                    textvariable = xstring2,
                    font = xfont,
                    bg = 'red',
                    fg = 'white',
                    padx = 5,
                    pady = 5,
                    relief = GROOVE)

lblMensaje2.pack(fill = X)

xstring3 = StringVar()

xstring3.set("Este es un tercer label")

lblMensaje3 = Label(Vmain, textvariable = xstring3,
                    bg = 'green',
                    height = 5,
                    width = 25,
                    relief = RIDGE)

#lblMensaje3.pack()
lblMensaje3.pack(fill = Y)

Vmain.mainloop()
