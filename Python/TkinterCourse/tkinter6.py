from tkinter import *
from tkinter import messagebox

Vmain = Tk()

Vmain.geometry("800x600+10+10")

Vmain.title("Este es un titulo. Imagenes")

img = PhotoImage(file = 'radiologo.gif')

lblGif = Label(Vmain, image = img, relief = RAISED)

lblGif.pack() #we can put expand = 1

MSG = StringVar(Vmain, 'Hola a Todos')


lblprueba = Label(Vmain, text = MSG)

lblprueba.pack()
def fnLabelCLick(evento):
    print("Click:", evento, evento.type, evento.state)
    messagebox.showinfo("Click", "Sobre la imagen")

def fnLabelEnter(evento):
    print("Enter:", evento, evento.type, evento.focus, evento.state)

def fnLabelLeave(evento):
    print("Leave:", evento, evento.type, evento.focus, evento.state)

lblGif.bind("<Button>", fnLabelCLick)
lblGif.bind("<Enter>", fnLabelEnter)
lblGif.bind("<Leave>", fnLabelLeave)



Vmain.mainloop()
