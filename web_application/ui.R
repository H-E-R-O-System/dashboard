#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

ui <- shiny::fluidPage(

  title = "",
  theme = shinythemes::shinytheme("flatly"),

  # Global CSS options for webpage -----
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "default_mode.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "ring_container.css")
  ),

  shinyWidgets::setBackgroundColor("#F5F9FC"),

  shiny::fluidRow(
    # Container to hold all of the webpage tabs ------
    shinydashboard::tabBox(
      id = "TabBox01",
      selected = NULL,
      title = "",
      width = 12,

      ## Tab to show patient overview -----
      shiny::tabPanel(
        title = tags$div(class="tab_title", "Patient Overview"),
        value = "patient_overview",
        ## Well Panel to hold page data
        shiny::wellPanel(
          id = "patient_wp",
          ### Start page contents ------
          shiny::fluidRow(
            #### Column 1 ----
            shiny::column(
              width = 6,
              shiny::fluidRow(
                shiny::column(
                  width = 12,
                  tags$h2("Ben Hoskings")
                )
              ),
              shiny::fluidRow(
                shiny::column(
                  width = 3,
                  tags$h3("Age: ")
                ),
                shiny::column(
                  width = 9,
                  tags$h3("Condition: ")
                )
              )
            ),
            #### Column 2 ----
            shiny::column(
              width = 6,
              shiny::htmlOutput("overall_score_circle")
            )
          )
        )
        )
        ,

      ## Tab to show interview data -----
      shiny::tabPanel(
        title = tags$div(class="tab_title", "Interview Data"),
        value = "interview_data",
        shiny::wellPanel(
          id = "interview_wp",
          ### Add page contents
        )
      ),
    )
  )
)
