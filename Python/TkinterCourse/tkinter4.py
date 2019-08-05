import tkinter as tk
from tkinter import messagebox
Vmain = tk.Tk()

Vmain.title("Ahh prro trais el omnitrix")

def fnCerrar():
    if messagebox.askokcancel("Salir", "Desea salir de la app?"):
        Vmain.destroy()

def fnShowInfo(evento):
    print("ShowInfo: ", evento)
    messagebox.showinfo("Show Info", "04 Messagebox")

def fnShowError(eventos):
    print("ShowError:", eventos)
    messagebox.showerror("Alv prro", "la cagaste krnal")

def fnShowWarning(eventos):
    print("ShowWarning:", eventos)
    messagebox.showwarning("No te pases de lanza", "Ten cuidado kp")

def fnAskYesNo(eventos):
    print("AskYesNo:", eventos)
    messagebox.askyesno("Salir con Return", "Desea salir de la app?")

def fnAskRetryCancel(eventos):
    print("AskRetryCancel: ", eventos)
    messagebox.askretrycancel("Salir con Escape", "Desea salir de la app?")


Vmain.protocol("WM_DELETE_WINDOW", fnCerrar)

Vmain.bind("<Control-Key-1>", fnShowInfo)

Vmain.bind("<Control-Key-2>", fnShowError)

Vmain.bind("<F1>", fnShowWarning)

Vmain.bind("<Return>", fnAskYesNo)

Vmain.bind("<Escape>", fnAskRetryCancel)

Vmain.mainloop()
