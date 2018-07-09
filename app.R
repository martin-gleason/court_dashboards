
source("court_dashboard/reports.R")
source("court_dashboard/color_scheme.R")
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
                choices =  unique(c5_time$last_name),
                multiple = FALSE),
    
  sidebarPanel(
    actionButton("color_safe", label = "Color Safe")
  ),
    
    position = "left",
    fluid = TRUE), #end input
    
    
    mainPanel("Main Panel",
              plotOutput("time_study")
  )#end layouts 
  
)#end UI


# server <- function(input, output) {
#   
#   output$selected_var <- renderText({ 
#     paste("You have selected", input$var)
# 
# 
# output$date_input <- renderText({
#   format(input$date_input[[1]], "%m - %d - %Y")
# })
# 
# output$staff_select <- renderText({
#   paste("You have selected, ", input$staff_select[1])
#})
#}
#   })
#   
# }

# Define server logic
server <- function(input, output) {
  
  output$time_study <- renderPlot({
    c5_time %>% group_by(first_name, last_name) %>% 
      summarize(Hours_worked = sum(`Hours worked on project`)) %>% 
      arrange(Hours_worked) %>% 
      ggplot(aes(x = reorder(last_name, -Hours_worked), y = Hours_worked, fill = last_name)) + 
      geom_bar(stat = "identity") + 
      labs(x = "Task Recorded By", y = "Hours Worked", title = "Total Hours Worked: April 2018 - June 2018") +
      theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
      scale_fill_viridis(discrete = TRUE, guide_legend(title = "C5 Steering Committee")) + 
      geom_hline(aes(yintercept = mean(c5_time$`Hours worked on project`), linetype = "Average Hours Worked per Project")) + 
      scale_linetype(name = "") 
  })
}# End Serevdr
  

# Run the application 
shinyApp(ui = ui, server = server)

