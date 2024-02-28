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
      selected = NULL, # set to null for default
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
          tags$div(class="profile_layout",
            tags$div(class="data_container",
              tags$div(style="grid-area: sidebar",
                shiny::selectInput(
                  inputId = "user_filter",
                  label = "Select User",
                  choices = names(all_consults)
                ),
                shiny::dateRangeInput(
                  inputId = "activity_range_filter",
                  label = "Date range",
                  format = "dd-M",
                  start = today - lubridate::weeks(10),
                  end   = today, weekstart = 1
                ),
                shiny::textOutput("consult_count"),
              )
            ),
            tags$div(class="data_container", style=sprintf("background-color: %s", blue_3),
               tags$div(class="profile_container",
                  tags$div(class="profile_title", "John Doe"),
                  tags$div(class="grid_item", style="grid-area: age", "Age: 45"),
                  tags$div(class="grid_item", style="grid-area: cond", "Condition: Dementia"),
                  tags$div(class="grid_item", style="grid-area: ring", create_spinner(75, colour=hero_blue)
                  )
               )
            )
          ),
          tags$br(style="background-color: #F5F9FC; height: 50px"),
          tags$div(class="barchart_layout",
            tags$div(class="data_container",
              tags$div(style="grod-area:bar_chart",
                shiny::plotOutput("user_barchart", click="bar_click")
              )
            ),
            shiny::uiOutput("consult_summary")
          ),


          # tags$div(style="display: flex; background-color: #000000; align-items: stretch;",
          #   tags$div(style="flex: 1; padding-bottom: 0px; padding-right: 10px; background-color: #00FF00",
          #     tags$div(class="data_container", style="height:100%",
          #       # shiny::plotOutput("user_barchart", click="bar_click")
          #       "hi"
          #     )
          #
          #   ),
          #   tags$div(style="flex: 1; padding-bottom: 0px; height:100%; padding-left: 10px; background-color: #FF0000",
          #     shiny::uiOutput("consult_summary"),
          #   )
          # ),


          tags$br(style="background-color: #F5F9FC; height: 50px"),

          # tags$div(class="user_layout_1",
          #   tags$div(class="data_container",
          #     tags$div(style="grid-area: wct",
          #       tags$div(class="profile_title", "Wisconsin Card Test"),
          #       shiny::plotOutput("wisconsin_time_plot")
          #     )
          #   ),
          #   tags$div(class="data_container",
          #     tags$div(style="grid-area: pss",
          #       tags$div(class="profile_title", "Percieved Stress Score"),
          #       shiny::plotOutput("pss_time_plot")
          #     )
          #   )
          # )
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
            tags$h1("Interview Summary", style=glue("color:{hero_blue}; padding: 0px"))
          ),
          tags$br(style="background-color: #F5F9FC; height: 50px"),

          tags$div(class="consult_layout_2",

            tags$div(class="data_container",
              tags$div(style="grid-area: select_consult",
                shiny::selectInput(
                  inputId = "user_filter_consult",
                  label = "Select User",
                  choices = names(all_consults)
                ),
                shiny::selectInput(
                  inputId = "consult_filter",
                  label = "Select Consultation Date",
                  choices = names(all_consults)
                )
              )
            ),
            tags$div(class = "data_container",

               tags$div(class="pss_container",
                        tags$div(class="grid_title", style=glue("color: {hero_blue}"),
                                 "Percieved Stress Score"
                        ),
                        tags$div(class="grid_item", style="grid-area: pss_score",
                          shiny::uiOutput("pss_session_score")
                        ),
                        tags$div(class="grid_item", style="grid-area: pss_bar",
                                 shiny::uiOutput("pss_session_visual")
                        )
               )
            )
          ),
          ### PSS Test -----
          tags$br(style="background-color: #F5F9FC; height: 50px"),

          ### Wisconsin Card Test ------
          tags$div(class="consult_layout_1",
            tags$div(class="data_container",
              tags$div(class="wct_container",
                tags$div(class="grid_title",
                  "Wisconsin Card Test"
                ),
                tags$div(style="grid-area: wct_table;",
                  shiny::uiOutput("wisconsin_consult_visual")
                )
              )
            ),
            tags$div(class = "data_container",
              tags$div(class="spiral_container",
                tags$div(class="grid_title", "Spiral Test", style=glue("color:{hero_blue}")),
                tags$div(class="grid_item", style="grid-area: spiral_score", "20/100"),
                tags$div(class="grid_item", style="grid-area: spiral_radar",
                  shiny::plotOutput("spiral_radar_chart")
                )
              )
            )
          ),
          ### Spiral Test ------

          ### GPCOG Test -------
          # tags$br(style="background-color: #F5F9FC; height: 50px"),
          # tags$div(class = "data_container",
          #   tags$div(class="gpcog_container",
          #     tags$div(class="grid_title", style=glue("color: {hero_blue}"),
          #       "GPCOG Test"
          #       ),
          #     tags$div(class="grid_item", style="grid-area: gpcog_score",
          #       "Score: 6/9"
          #     ),
          #     tags$div(class="grid_item", style="grid-area: gpcog_bar",
          #       create_gpcog_bar(gpcog_score)
          #     )
          #   )
          # ),
          # tags$br(style="background-color: #F5F9FC; height: 50px"),
          # tags$div(class = "data_container",
          #   tags$div(class="grid_title",
          #     "Affective Computing", style=glue("color: {hero_blue}"),
          #   )
          # ),
          # tags$br(style="background-color: #F5F9FC; height: 50px"),
          # tags$div(class = "data_container",
          #   tags$div(class="grid_title",
          #     "Wisconsin Card Test", style=glue("color: {hero_blue}"),
          #   )
          # )
        )
      )
    )
  )
)
