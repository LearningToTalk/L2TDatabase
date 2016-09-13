#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library("shiny")
library("L2TDatabase")
library("dplyr", warn.conflicts = FALSE)
library("ggplot2")

l2t <- l2t_connect(cnf_file = "../inst/l2t_db.cnf", db_name = "l2t")

tp1 <- tbl(l2t, "q_Scores_TimePoint1") %>% collect
tp2 <- tbl(l2t, "q_Scores_TimePoint2") %>% collect
tp3 <- tbl(l2t, "q_Scores_TimePoint3") %>% collect

all_studies <- bind_rows(tp1, tp2, tp3)
study_names <- unique(all_studies$Study)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(

   # Application title
   titlePanel("Score explorer"),


   sidebarLayout(
     sidebarPanel(
       # Drop-down to select study
       selectInput(inputId = "study_select",
                   label = h3("Select study"),
                   choices = as.list(study_names),
                   selected = 1)
      ),

      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
))

# Define server logic required to draw a histogram
server <- shinyServer(function(input, output) {

   output$distPlot <- renderPlot({
     x <- all_studies %>%
        filter(Study == input$study_select)

     # draw the histogram with the specified number of bins
     ggplot(x) + aes(x = EVT_GSV) + geom_histogram() + geom_density()
   })
})

# Run the application
shinyApp(ui = ui, server = server)

