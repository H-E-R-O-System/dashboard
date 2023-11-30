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
          style = "background-color: #FFFFFF",
          ### Start page contents ------
          tags$div(class="data_container",
            tags$div(class="profile_container",
              tags$div(class="profile_title", "John Doe"),
              tags$div(class="grid_item", style="grid-area: age", "Age: 45"),
              tags$div(class="grid_item", style="grid-area: cond", "Condition: Dementia"),
              tags$div(class="grid_item", style="grid-area: ring", create_spinner(75))
            )
          )
        )
      ),

      ## Tab to show interview data -----
      shiny::tabPanel(
        title = tags$div(class="tab_title", "Interview Data"),
        value = "interview_data",
        shiny::wellPanel(
          id = "interview_wp",
          style = "background-color: #FFFFFF",

          tags$div(class="data_container",
            tags$h1("Interview Summary", style="color:#000000; padding: 0px")
          ),
          tags$br(style="background-color: #F5F9FC; height: 50px"),

          ### Spiral Test ------
          tags$div(class = "data_container",
            tags$div(class="spiral_container",
              tags$div(class="grid_title", "Spiral Test", style="color: #658EA9"),
              tags$div(class="grid_item", style="grid-area: spiral_score", "20/100"),
              tags$div(class="grid_item", style="grid-area: spiral_radar",
                ## Add radar graph
                shiny::plotOutput("spiral_radar_chart")
              ),
            )
          ),
          ### GPCOG Test -------
          tags$br(style="background-color: #F5F9FC; height: 50px"),
          tags$div(class = "data_container",
            tags$div(class="gpcog_container",
              tags$div(class="grid_title", style="color: #74BDCB",
                "GPCOG Test"
                ),
              tags$div(class="grid_item", style="grid-area: gpcog_score",
                "Score: 6/9"
              ),
              tags$div(class="grid_item", style="grid-area: gpcog_bar",
                create_gpcog_bar(gpcog_score)
              )
            )
          ),
          ### PSS Test -----
          tags$br(style="background-color: #F5F9FC; height: 50px"),
          tags$div(class = "data_container",
            tags$div(class="pss_container",
              tags$div(class="grid_title",
                       "Percieved Stress Score", style="color: #FFA384"
              ),
              tags$div(
               class="pss_score_holder",
               style="background-color: #CDFAD5",
               "Score: 32/50"
              )
            )
          ),
          tags$br(style="background-color: #F5F9FC; height: 50px"),
          tags$div(class = "data_container",
                   tags$div(class="grid_title",
                            "Affective Computing", style="color: #FFA384"
                   )
          ),
          tags$br(style="background-color: #F5F9FC; height: 50px"),
          tags$div(class = "data_container",
                   tags$div(class="grid_title",
                            "Wisconsin Card Test", style="color: #FFA384"
                   )
          )
        )
      )
    )
  )
)
