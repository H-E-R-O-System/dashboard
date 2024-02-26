
create_radarchart <- function(data, color = "#00AFBB",
                              vlabels = colnames(data), vlcex = 0.7,
                              caxislabels = NULL, title = NULL, ...){
  fmsb::radarchart(
    data, axistype = 1,
    # Customize the polygon
    pcol = color, pfcol = scales::alpha(color, 0.5), plwd = 2, plty = 1,
    # Customize the grid
    cglcol = "grey", cglty = 1, cglwd = 0.8,
    # Customize the axis
    axislabcol = "grey",
    # Variable labels
    vlcex = vlcex, vlabels = vlabels,
    caxislabels = caxislabels, title = title, ...
  )
}

create_spinner <- function(x, colour) {
  tags$div(class="percent1", style=sprintf("stroke: %s; color: %s;", colour, colour),
    tags$svg(
     tags$circle(cx="70", cy="70", r="70"),
     tags$circle(cx="70", cy="70", r="70"),
    ),
    tags$div(class="number",
      tags$h2(
        x
      )
    )
  )
}

create_gpcog_bar <- function (score) {
  tags$table(style="border-style: solid;",
             tags$tr(style="border-style: solid; border: 2px;",
                     purrr::map(1:9, function(x) {
                       if (score[x] == 0) {
                         tags$td(class="gpcog_cell",
                                 style="background-color: #FFAAAA", x)
                       } else {
                         tags$td(class="gpcog_cell",
                                 style="background-color: #AAFFAA", x)
                       }
                     })
             )
  )
}


