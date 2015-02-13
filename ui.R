library(shiny)

# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Olympic medals at summer Olympic games"),
    
  # Sidebar with controls to select a dataset and specify the number
  # of observations to view
  sidebarPanel(
    selectInput("olympic", "Choose an Olympic game:", 
                choices = c("Sydney 2000" = 2000, "Athens 2004" = 2004, "Beijing 2008" = 2008, "London 2012" = 2012)),
    
    uiOutput("disciplineControls")
  ),
  
  # Show a summary of the dataset and an HTML table with the requested
  # number of observations
  mainPanel(
    #verbatimTextOutput("summary"),
    br(), 
    tabsetPanel(
      tabPanel("Graphics",
        br(), 
        column(12,
           wellPanel(
             radioButtons("medalCategory1","Choose the type of medal:",
               c("Total" = "total", "Gold" = "gold", "Silver" = "silver", "Bronze" = "bronze"), selected = NULL, inline = TRUE)
           )
        ),   
        plotOutput("myplot1")
      ),
      tabPanel("Table",
        br(), 
        column(12,
          wellPanel(
            radioButtons("medalCategory2","Choose the type of medal:",
              c("Total" = "total", "Gold" = "gold", "Silver" = "silver", "Bronze" = "bronze"), selected = NULL, inline = TRUE)
          )
        ),
        dataTableOutput('mytable1')
      ),
      tabPanel("Help page",
        br(), 
        p("This website uses data from the summer Olympic games since 2000 to calculate the number of gold, silver and bronze medals that each country has won on each game."),
        p("The data has been obtained from", a("Tableau.com", href="http://www.tableau.com/")),
        p("Please wait until all the menus are loaded and then select:"),
        tags$ul(
          tags$li("the Olympic game"),
          tags$li("the disciplines you are interested in"),
          tags$li("the type of medal")
        ),
        p("Data can be represented by a barplot or a table"),
        strong("The correct functionality of the web has been only tested using Chrome.")
      )
    )
  )
))
