
library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel(h1("Suprevisor/C5 Time Sheet", align = "center")),
  
  sidebarLayout(
    sidebarPanel(
      img(src = "c5.png", height = 200, width = 200), align = "center"),
    
    dateRangeInput("date_input", label = "Date Range:",
                    start = "2018-05-04",
                    end = Sys.Date(),
                    format= "mm/dd/yyyy")),
  sidebarPanel(
    selectInput("staff_select", label = "Staff Selection:",
                choices = c("Choice A" = "a",
                            "Choice B" = "b"),
                multiple = FALSE),
    
    position = "left",
    fluid = TRUE), #end input
    
    
    mainPanel("Main Panel",
              h2("something here too"),
              position = "right")#end layouts 
  
)#end UI


# Define server logic
server <- function(input, output) {
}

# Run the application 
shinyApp(ui = ui, server = server)

