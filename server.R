source("./utilities/utility.R")

server <- function(input, output) {
  
  output$table <- renderDT(Combine_df)
  
}