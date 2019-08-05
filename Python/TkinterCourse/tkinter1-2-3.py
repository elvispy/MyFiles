import tkinter as tk

Vmain = tk.Tk()

Vmain.title("Este es un titulo")

#Vmain.wm_state('zoomed') para maximizar
#Vmain.attributes('-fullscreen', True) para fullscreen total
ancho = Vmain.winfo_screenwidth()#gets the maximum width allowed
alto = Vmain.winfo_screenheight()#gets the maximum acceptable height
Vmain.geometry("%dx%d+%d+%d"%(300, 300, -8, 0)) #This method will define size and position

def fnCerrar():
    #Closes the window and prints out a message
    print("Has cerrado la ventana")
    Vmain.destroy()

def fnRedimensionar(eventos):
    #this will notify the new dimensions of the window
    print(eventos)
    print("Has redomensionado la ventana")


Vmain.protocol("WM_DELETE_WINDOW", fnCerrar)

Vmain.bind("<Configure>", fnRedimensionar)

Vmain.update()


'''
print("Ancho screen : ", Vmain.winfo_screenwidth())
print("Alto screen  : ", Vmain.winfo_screenheight())
print("Ancho Ventana: ", Vmain.winfo_width())
print("Alto Ventana : ", Vmain.winfo_height())
print("x            : ", Vmain.winfo_x())
print("y            : ", Vmain.winfo_y())
'''


print(Vmain.geometry())
Vmain.mainloop()
