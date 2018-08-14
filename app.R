source("mock_etl.R")
source("court_dashboard/color_scheme.R")
source("leaflet.R")
library(shiny)
library(kableExtra)



# Define UI
ui <- fluidPage(
  titlePanel(h1("Mock Dashboard: Supervisor", align = "center")),
  
  sidebarLayout(
    # sidebarPanel(
    #   img(src = "c5.png", height = 200, width = 200), align = "center"),
    # 
    # dateRangeInput("date_input", label = "Date Range:",
    #                start = "2018-05-04",
    #                end = Sys.Date(),
    #                format= "mm/dd/yyyy")),
  sidebarPanel(
    selectInput("staff_select", label = "Client Selection",
                choices =  unique(demographics$`Client ID`),
                multiple = FALSE)
    ),
    
    position = "left",
    fluid = TRUE, #end input
  
  
  mainPanel("Main Panel",
            tableOutput("table"))
  
  #sidebar for input on map
  
  #mainpanel for leaflet map
  ),
  mainPanel("Leaflet Map",
            leafletOutput("demo_map"))
  
  )#end layouts 
  
#end UI


server <- function(input, output){

  output$selected_var <- renderText({
     paste("You have selected", input$staff_select)
  })
  
  output$table <- function(){
    req(input$staff_select)
    demographics %>% 
      filter(`Client ID` == input$staff_select) %>% 
      knitr::kable("html", booktabs = TRUE) %>%
      kable_styling(bootstrap_options = c("striped", "bordered", "hover"))
  }

#output leaflet map  
  output$demo_map <- renderLeaflet({
    m %>% addTiles() %>%
      addMarkers(lng = chicago_demo$longitude, lat = chicago_demo$latitude)
    
  })
  }


# Run the application 
shinyApp(ui = ui, server = server)

