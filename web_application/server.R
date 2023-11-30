#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define server logic required to draw a histogram
function(input, output, session) {

    output$overall_score_circle <- shiny::renderUI({
      tags$div(class="percent1",
          tags$svg(
            tags$circle(cx="70", cy="70", r="70"),
            tags$circle(cx="70", cy="70", r="70"),
          ),
          tags$div(class="number",
            tags$h2(
              75,
              tags$span("%")
            )
          )
        )
    })

    output$spiral_radar_chart <- shiny::renderPlot({
      op <- par(mar = c(1, 2, 2, 1))
      create_radarchart(student1_data, caxislabels = c(0, 5, 10, 15, 20))
      par(op)
    })
}
