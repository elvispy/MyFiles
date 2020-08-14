# Python code for Julia Fractal 
from PIL import Image
from time import perf_counter

# driver function 
if __name__ == "__main__":

    t = perf_counter()
	
    # setting the width, height and zoom 
    # of the image to be created 
    w, h, zoom = int(3840/4),int(2160/4),1

    # creating the new image in RGB mode 
    bitmap = Image.new("RGB", (w, h), "white") 

    # Allocating the storage for the image and 
    # loading the pixel data. 
    pix = bitmap.load() 

    # setting up the variables according to 
    # the equation to create the fractal 
    #cX, cY = -0.7, 0.27015
    zx = 0
    zy = 0
    moveX, moveY = -0.5, 0.0
    maxIter = 255

    for x in range(w): 
        for y in range(h): 
            cX = 1.5*(x - w/2)/(0.5*zoom*w) + moveX 
            cY = 1.0*(y - h/2)/(0.5*zoom*h) + moveY

            zx = 0
            zy = 0

            i = maxIter 
            while zx*zx + zy*zy < 4 and i > 1: 
                tmp = zx*zx - zy*zy + cX 
                zy,zx = 2.0*zx*zy + cY, tmp 
                i -= 1

            # convert byte to RGB (3 bytes), kinda 
            # magic to get nice colors 
            pix[x,y] = (i << 21) + (i << 10) + i*8

    # to display the created fractal   
    bitmap.show()

print("Time Elapsed:", perf_counter() - t)

