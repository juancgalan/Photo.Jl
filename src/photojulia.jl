module photojulia

using Images, ImageView, Blink, Interact

export photoinit

# Global variables that stores the display window and the current image
currentimage = nothing
currentdisplay = nothing

"""
Loads a file and displays it.
"""
function showfile(filename)
    global currentimage = load(filename)
    displayimage()
end

"""
Displays an image, if a previous image was loaded, the previous window is
destroyed.
"""
function displayimage()
    global currentimage
    global currentdisplay
    if currentimage == nothing
        return nothing
    end
    if currentdisplay != nothing
        ImageView.closeall()
    end
    imshow(currentimage)
    nothing
end

"""
Transforms the current image into gray scale. The new image will be displayed
on a new window and the original image will be destroyed.

Because this function is intented to be used as a response of an Interact
button event, it requires to specify an integer argument that holds the
amount of clicks made for such button.

"""
function color2gray(clickcount)
    global currentimage
    if currentimage != nothing
        currentimage = Gray.(currentimage)
    end
    displayimage()
end


"""
Dummy button function. Copy this function for each button you want to create.
"""
function dummyevent(clicks)
    println(clicks)
end

"""
This function creates the main menu window with a file picker and interactive
buttons.
"""
function createUI()
    # File picker
    ofile = filepicker("Select an Image...")

    # Grayscale button
    graybtn = button("Color2Gray")

    # Dummy buttons for layout proof test
    dummybtn1 = button("Dummy1")
    dummybtn2 = button("Dummy2")

    # Declare a link between open file event and button
    on(showfile, ofile)
    # Declare a link between grayscale event and button
    on(color2gray, graybtn)

    # Declare a Widget with all elements of the menu
    wdg = Widget([:File => ofile,
                  :Gray => graybtn,
                  :Dummy1 => dummybtn1,
                  :Dummy2 => dummybtn2])
    # Create the layout for the widget, its a two column layout
    @layout! wdg vbox(:File,
                      hbox(:Gray, :Dummy1),
                      hbox(:Dummy2))

    # Create the main window
    window = Window()
    title(window, "PhotoJl")

    # Insert  the widget
    body!(window, wdg)

    # Open devtools, uncomment the following if you want to see the chrome
    # devtools of electron.
    #opentools(window)
end

"""
Main Function. Call this function for creating the UI from the REPL 
"""
function photoinit()
    createUI()
end


end # module
