# author : sakamoto_jin

from tkinter import *
import threading
import pyodbc


def initialise_database():
    server = '.'

    database = 'mydb'
    username = ''
    password = ''
    connection = pyodbc.connect(
        'Driver={SQL Server Native Client 11.0};SERVER=' + server + ';DATABASE=' + database + ';UID=' + username + ';PWD=' + password + ';Trusted_Connection=yes')

    global cursor
    cursor = connection.cursor()

    query = 'create table dbo.students (name varchar(25) not null , age int not null , college varchar(30) not null );'
    # cursor.execute(query)
    # cursor.commit()
    print("database initialised")


def initialise_graphics():
    global root
    root = Tk()
    root.geometry("600x500")
    root.title('sql_server_library_management_system')
    button1 = Button(text="insert", command=insert)
    button1.place(x=450, y=75)
    button2 = Button(text="update", command=update)
    button2.place(x=450, y=150)
    button3 = Button(text="clear", command=clear)
    button3.place(x=220, y=300)
    button4 = Button(text="view", command=view)
    button4.place(x=250, y=450)
    button5 = Button(text="delete", command=delete)
    button5.place(x=450, y=200)

    global listbox
    listbox = Listbox(root, width=20)
    listbox.pack()
    scroll = Scrollbar(root)
    scroll.pack(side=RIGHT, fill=Y)
    listbox.config(yscrollcommand=scroll.set)
    scroll.config(command=listbox.yview)
    listbox.place(x=415, y=320)

    global e1
    e1 = Entry(root)
    e1.place(x=200, y=50)

    l1 = Label(root, text="name")
    l1.place(x=100, y=50)
    global e2
    e2 = Entry(root)
    e2.place(x=200, y=75)

    l2 = Label(root, text="age")
    l2.place(x=100, y=75)

    global e3
    e3 = Entry(root)
    e3.place(x=200, y=100)

    l3 = Label(root, text="college")
    l3.place(x=100, y=100)

    global e4
    e4 = Entry(root)
    e4.place(x=200, y=150)

    l4 = Label(root, text="Enter name")
    l4.place(x=100, y=150)

    global e5
    e5 = Entry(root)
    e5.place(x=200, y=200)

    l5 = Label(root, text="Enter name")
    l5.place(x=100, y=200)

    root.mainloop()
    print("graphics initialised")


def insert():
    eq = "insert into dbo.students(name , age , college) values(?,?,?)"
    data = (e1.get(), int(e2.get()), e3.get())
    cursor.execute(eq, data)
    cursor.commit()
    print("insert success full")


def update():
    a = "update students set name=?,age=?,college=? where name=?"
    b = (e1.get(), int(e2.get()), e3.get(), e4.get())
    cursor.execute(a, b)
    cursor.commit()
    print('updated')


def clear():
    print('clear')
    e1.delete(0, END)
    e2.delete(0, END)
    e3.delete(0, END)
    e4.delete(0, END)
    e5.delete(0, END)
    listbox.delete(0, END)


def view():
    print('view')
    listbox.delete(0, END)
    global cursor
    cursor.execute("select * from students;")
    for row in cursor:
        listbox.insert(END, row)


def delete():
    a = "delete from students where name=?"
    b = (e5.get(),)
    cursor.execute(a, b)
    cursor.commit()
    print('deleted')


initialise_database()
initialise_graphics()





