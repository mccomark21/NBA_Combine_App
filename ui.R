source("./utilities/utility.R")

ui <- dashboardPage(dashboardHeader(title = "NBA Combine Performance"),
                    dashboardSidebar(),
                    dashboardBody(
                      # Hide Warnings 
                      tags$style(type="text/css",".shiny-output-error { visibility: hidden; }",".shiny-output-error:before {visibility: hidden;}"),
                      
                      fluidRow(column(12,tabBox(title="",width = 12,
                                                tabPanel("Mark",
                                                         DTOutput('table')),
                                                tabPanel("Ben")
                      )))
                      
  )
)