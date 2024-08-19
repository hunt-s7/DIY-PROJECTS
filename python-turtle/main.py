import turtle
import random

screen = turtle.Screen()
screen.bgcolor("black")

#Lets add some more colors
colors = ["red", "blue", "yellow", "white", "green", "orange"]

artist = turtle.Turtle()
#Lets increase the speed to max
artist.speed(0)

#This function draws a STAR
def draw_star():
    for i in range(50):
        artist.color(random.choice(colors))
        artist.forward(i * 10)
        artist.right(144) # With this angle turn, it should make something like triangles, Lets see

#draw_star()

def draw_abs1():
    for i in range(100):
        artist.color("orange")
        artist.forward(i * 10)
        artist.left(143) #What do we expect? This is going to be crazy

#Lets keep it, this abstract is good!
#draw_abs1()

# Crazy black hole wibe!!
def draw_cheapblackhole():
    for i in range(100):
        artist.color("orange")
        artist.forward(i * 10)
        artist.right(10) 
        artist.backward(i * 10)

#draw_cheapblackhole()

def draw_abs2():
    for i in range(100):
        artist.color("orange")
        artist.forward(i*10)
        artist.right(10) 
        artist.backward(i*10)
        artist.right(10) 

#draw_abs2()
def draw_abs3():
    for i in range(100):
        artist.color("orange")
        artist.forward(i*10)
        artist.right(60) 
        artist.backward(i*10)
        artist.right(30) 

def draw():
    for i in range(100):
        artist.color("orange")
        artist.forward(i*10)
        artist.right(30) 
        artist.backward(i*10)
        artist.right(30) 


draw()
artist.hideturtle()
turtle.done()









