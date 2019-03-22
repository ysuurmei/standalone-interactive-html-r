#########################################################################
############### CREATING STANDALONE INTERACTIVE HTML DOCS ###############
#########################################################################

#Author: Y. Suurmeijer
#Date: 22/03/2019
#Purpose: Example to show how to create basic interactive visualizations that work as standalone HTML

#Step 1: Install dependencies:
#For this to work you'll need several packages, htmltools, crosstalk and d3scatter
#The latter are available on github only and can be installed using devtools:
#devtools::install_github("rstudio/crosstalk")
#devtools::install_github("jcheng5/d3scatter")

library(htmltools)
library(crosstalk)
library(d3scatter)
library(leaflet)


#Step 2: Define shared data object:
#Crosstalk basically works by sharing data among loose widget elemnts without requiring a server element like in shiny
#As such you first need to define a shared dataset, this dataset should be output data only, please don't try to 
#Modify the data once it's defined, the example here uses the mtcars dataset

shared_mtcars <- SharedData$new(mtcars)

#Step 3: Define the UI
#This example ui uses the bscols function to space the elements, this is based on the Bootstrap column definition
#If you're not familiar with Bootstrap, this is basically the same defniition as cols in shiny UI definitions
#This example uses d3scatter, but libraries such as plotly are also compatible, for a full list check: https://rstudio.github.io/crosstalk/widgets.html
#You can use select input, slider and checbox elements in your UI definition

css_test <- ".css_text    {color: blue;}
             p            {color: red;}"

map_example <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")

test <- bscols(widths = c(3,NA,NA), #3 columns, one with defined with, the others are flexible
       list( #filling the first column, use list for multiple items below each other
         filter_checkbox("cyl", "Cylinders", shared_mtcars, ~cyl, inline = TRUE), #checkbox example (notice you use the shared data in the element definition!)
         filter_slider("hp", "Horsepower", shared_mtcars, ~hp, width = "100%"), #slider example
         filter_select("auto", "Automatic", shared_mtcars, ~ifelse(am == 0, "Yes", "No")), #select/dropdown example
         HTML("Some unformatted text"), 
         HTML("<h1> H1 Headers also work </h1>"), #Using the html tools package you can also format any text using standard html markup
          HTML("<b>bold text</b>"),
         HTML("<h2 class = css_text> application of CSS styling</h2>"),
          HTML(paste("<style>",css_test,"</style>")) #Include your CSS style sheets in the interface
         ),
       d3scatter(shared_mtcars, ~wt, ~mpg, ~factor(cyl), width="100%", height=250), #scatter plots both as seperate columns
       list(d3scatter(shared_mtcars, ~hp, ~qsec, ~factor(cyl), width="100%", height=250),
            map_example
            )
)

#Step 4: Test & export
#Simply run the ui element to see what your element looks like in the viewer window 
#To export as standalone webpage in the viewer click 'Export' -> 'Save as Webpage'
test


