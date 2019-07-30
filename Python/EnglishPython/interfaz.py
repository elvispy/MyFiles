import app_graphical
from tkinter import *
#from tkinter import StringVar

blocked = False
Opens = {'A_P':False}

def format_example(example):
    #print(example)
    list1 = example.split(" ")
    res = ''
    aux = ''
    #print(list1)
    for i in list1:
        if len(aux + i)<40:
            aux += i + ' '
        else:
            res += aux + '\n'
            aux = i + ' '
    return res + aux
        
        

def fnCerrarAP():
    '''This will withdraw A_P, put btnSalir to normal state'''
    A_P.withdraw()
    Vmain.lift()
    btnSalir.config(state = NORMAL)
    Opens['A_P'] = False
def fnA_P():
    '''This will decoinify A_P unless it has already been decoinified
        Also it will change the state to disabled'''
    if not Opens['A_P']:
        Opens['A_P'] = True
        btnSalir.config(state = DISABLED)
        A_P.wm_deiconify()
    else:
        pass

def fnPista():
    textoEntry.set(word['answer'].replace(";", " or "))
    txtAnswer.config(state = DISABLED)
    #                 state = DISABled
    new_example = format_example(word['example'])
##    if len(word['example']) < 17:
##        new_example = word['example']
##    else:
##        for i in range(12,len(word['example'])):
##            if i == ' ':
##                new_example = word['example'][:i] + '\n' + word['example'][i:]
##                break
        
        
    lblExample.config(text = 'Example : "{}"'.format(new_example))

    lblExample.place(x = 10, y = 120)
    btnOK.place(x = 240, y = 70)
    btnVolverMain.config(state = DISABLED)

    btnAyuda.config(state = DISABLED)

    btnSumbit.config(state = DISABLED)

    

def fnOtro():
    #app_graphical.fnAnswer(False, word)

    lblExample.config(text = 'Example : ')
    
    word = app_graphical.main()

    lblOracion['text'] = word['verb']

       

def fnSumbit():
    global word
    #print(word)
    global blocked
    '''This function will check whether the answer is correct or not,
    and act accordingly. It will wait for a response and send the results to
    app_graphical'''
    user_answer = txtAnswer.get()
    
    
    if user_answer in word['answer'].split(";"):
        lblMsg.config(text = 'Correct!', fg = '#008000')

        
        app_graphical.fnAnswer(True, word)
        
    else:

        app_graphical.fnAnswer(False, word)
 
        lblMsg.config(text = 'Incorrect :(')

        lblMsg.config(fg = '#FF4500')
        
        
        '''
        word = app_graphical.main()
    
        lblOracion.config(text = 'The verb is: {}'
                      .format(word['verb'][0].upper() + word['verb'][1:]))
        '''

    textoEntry.set(word['answer'].replace(';', ' or '))
    
    lblMsg.place(x = 200, y = 15)

    new_example = format_example(word['example'])
        
    lblExample.config(text = new_example)

    lblExample.place(x = 10, y = 120)
        
    #---------------------------------
    #Blocking all widgets

    txtAnswer.config(state = DISABLED)
    
    btnVolverMain.config(state = DISABLED)
    
    btnAyuda.config(state = DISABLED)
    
    btnSumbit.config(state = DISABLED)
    
    #btnOtro.config(state = DISABLED)

    blocked = True

    
def UCW():
    pass

def fnCerrar():
    if btnSalir['state'] != DISABLED:
        Vmain.destroy()
        A_P.destroy()
        pass
    else:
        pass

def fnOK():
    global word
    textoEntry.set('')
    txtAnswer.config(state = NORMAL)
    lblExample.place_forget()
    #lblExample.config(text = '')
    
    app_graphical.fnAnswer(False, word)
    
    word = app_graphical.main()
    
    lblOracion.config(text = 'The verb is: {}'
                      .format(word['verb'][0].upper() + word['verb'][1:]))

    btnVolverMain.config(state = NORMAL)

    btnAyuda.config(state = NORMAL)

    btnSumbit.config(state = NORMAL)
    
    btnOK.place_forget()

    

def fnDesbloquear(key):
    global word
    global blocked
    #print(blocked)
    if blocked and key.keycode != 13:
        blocked = False
        
        txtAnswer.config(state = NORMAL)
    
        btnVolverMain.config(state = NORMAL)
    
        btnAyuda.config(state = NORMAL)
    
        btnSumbit.config(state = NORMAL)
    
        btnOtro.config(state = NORMAL)

        textoEntry.set('')

        lblMsg.place_forget()

        lblExample.place_forget()

        word = app_graphical.main()

        lblOracion.config(text = 'The verb is: {}'
                      .format(word['verb'][0].upper() + word['verb'][1:]))

        
        
def fnCerrarA_P():
    if btnVolverMain['state'] != DISABLED:
        A_P.withdraw()

def fnGotoSumbit(key):
    if txtAnswer['state'] != DISABLED and key.keycode == 13 and len(txtAnswer.get()) > 0:
        
        fnSumbit()
        
Vmain = Tk()
bgmain = '#BEB2C8'
Vmain.config(bg= bgmain)

Vmain.geometry('430x400+510+80')

Vmain.title('Pagina principal')



#Now we create some buttons
btnPrepos = Button(Vmain, text = 'Adjective + Preposition \n Practice',
                   activebackground = bgmain,
                   fg = '#8D8D92',
                   command = fnA_P, cursor = 'top_left_arrow',
                   bg = '#D7D6D6',
                   font = ('Helvetica', 18, 'italic'))
btnPrepos.config( height = 3, width = 20)
#btnPrepos.place(x = 180, y = 20)
btnPrepos.pack()


btnUCW = Button(Vmain, text = 'Use the correct word \n Game',
                activebackground = bgmain,
                command = UCW,
                bg = '#F2DFD7',
                font = ('Helvetica', 18, 'italic'))
btnUCW.config(height = 3, width = 20)
btnUCW.pack()

btnSalir = Button(Vmain, text = 'Exit',
                  activebackground = bgmain,
                  command = fnCerrar,
                  font = ('Helvetica', 17, 'bold', 'italic'))
btnSalir.config(height = 3, width = 20)
btnSalir.pack()



#--------------------------------
#Here we create another window
A_P = Tk()
#import app_graphical

A_P.withdraw()

A_P.geometry('400x200+522+130')

A_P.title('Adjective + Preposition')

A_P.protocol("WM_DELETE_WINDOW", fnCerrarAP)

word = app_graphical.main()

btnVolverMain = Button(A_P, text = 'Go back',
                       font = ('Helvetica', 10, 'italic'),
                       bg = '#D7D6D6',
                       command = fnCerrarAP)

btnVolverMain.place(x = 10, y = 10)

btnAyuda = Button(A_P, text = 'Answer',
                  font = ('Helvetica', 12, 'italic'),
                  bg = '#D7D6D6',
                  command = fnPista)

btnAyuda.place(x = 325, y = 80)

btnOtro = Button(A_P, text = 'Change',
                 font = ('Helvetica', 12, 'italic'),
                 bg = '#D7D6D6',
                 command = fnOtro)

#btnOtro.place(x = 322, y = 30)

btnSumbit = Button(A_P, text = 'Sumbit',
                 font = ('Helvetica', 12, 'italic'),
                 bg = '#D7D6D6',
                 command = fnSumbit)

btnSumbit.place(x = 325, y = 130)

btnOK = Button(A_P, text = 'OK!', command = fnOK,
               font = ('Helvetica', 16, 'italic'),
               state = NORMAL)



lblOracion = Label(A_P, text = 'The verb is: ' + word['verb'][0].upper() +
                   word['verb'][1:],
                   font = ('Helvetica', 13, 'bold'),
                   bg = '#8D8D92', relief = RIDGE)

lblOracion.place(x = 10, y = 50)


lblRespuesta = Label(A_P, text = 'Give your answer: ',
                     font = ('Helvetica', 12),
                     fg = '#000000')

lblRespuesta.place(x = 10, y = 80)

textoEntry = StringVar(A_P)

txtAnswer = Entry(A_P,
                  font = ('Helvetica', 13, 'italic'),
                  relief = FLAT,
                  cursor = 'top_left_arrow',
                  width = 10,
                  textvariable = textoEntry)


txtAnswer.place(x = 140, y = 80)

lblExample = Label(A_P, text ='',
                   font = ('Helvetica', 10, 'italic'),
                   relief = SUNKEN, justify = LEFT,
                   bd = 5)

#lblExample.place(x = 10, y = 120)

#Msg = StringVar(A_P)
lblMsg = Label(A_P, text = '', fg = '#008000',
               font = ('Helvetica', 14, 'italic'))
#Msg.set('')
#lblMsg.place(x = 200, y = 15)


A_P.bind('<Key>', fnDesbloquear)
txtAnswer.bind('<Key>', fnGotoSumbit)
A_P.protocol("WM_DELETE_WINDOW", fnCerrarA_P)
Vmain.protocol("WM_DELETE_WINDOW", fnCerrar)
A_P.mainloop()

Vmain.mainloop()




