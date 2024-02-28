
wct_data_augmentation <- function(wct_data) {
  answers = wct_data$answers
  change_ids = wct_data$change_ids
  change_ids = c(0, change_ids, length(answers))

  diffs = diff(change_ids)
  col_count = max(diffs)

  rule_answers = list()
  for (idx in 1:(length(change_ids)-1)) {
    start_idx <- change_ids[idx]+1
    end_idx <- change_ids[idx+1]

    rule_set <- answers[start_idx:end_idx]
    rule_answers[[idx]] = c(rule_set, array(dim=col_count-length(rule_set)))
  }

  return(
    list("all_answers"= answers, "rule_answers"=rule_answers, "col_count"=col_count))
}


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

create_pss_bar <- function (score) {
  tags$table(style="border-style: solid; width: 90%",
    tags$tr(style="border-style: solid; border: 2px;",
      purrr::map(1:9, function(x) {
        if (score[x] == 0) {
          bg_colour = "#ffa080"
        } else if (score[x] == 1) {
          bg_colour = "#ffc080"
        } else if (score[x] == 2) {
          bg_colour = "#ffff80"
        } else if (score[x] == 3) {
          bg_colour = "#a5d46a"
        } else {
          bg_colour = "#84a954"
        }
        tags$td(
          class="gpcog_cell",
          style=glue("background-color: {bg_colour}"), score[x])
      })
    )
  )
}


create_wct_table <- function(rule_answers, col_count) {
  tags$table(class="wct_table",
    purrr::map(1:length(rule_answers), function(x) {
      tags$tr(class="wct_row",
        tags$td(class="gpcog_cell",
          glue("Rule {x}")
        ),
        purrr::map(1:col_count, function(y) {

          if (!is.na(rule_answers[[x]][y])) {
            if (rule_answers[[x]][y] == T) {
              bg_colour = "#AAFFAA"
            } else {
              bg_colour = "#FFAAAA"
            }
            tags$td(class="gpcog_cell",
              tags$div(class="dot", style=glue("background-color: {bg_colour}")
              )
            )
          }
        })
      )
    })
  )
}

## Time tarcking functions ------

generate_module_track_df <- function(consults) {
  time_data <- data.frame(matrix(ncol=5, nrow=0))
  colnames(time_data) <- c("consult_id", "date", "wct_score",
                           "pss_score", "vat_score")
  for (consult in consults) {
    time_data[nrow(time_data) + 1,] = c(
      consult$consult_id, consult$date,
      sum(consult$wct_data$all_answers), sum(consult$pss_data$answers),
      sum(consult$vat_data$answers)
    )
  }

  time_data <- time_data |>
    dplyr::mutate(date = as.Date(date)) |>
    dplyr::arrange(date)

  return(time_data)
}

generate_stacked_barchart <- function(consults_df, date_range, line_colour=NULL, plot_colour=NULL, bg_colour=NULL) {
  pivot_df <- consults_df |>
    dplyr::filter(dplyr::between(date, date_range[1], date_range[2])) |>
    tidyr::pivot_longer(
      !c(consult_id, date), names_to="test", values_to = "score") |>
    dplyr::mutate(score = as.numeric(score))

  p <- ggplot(pivot_df, aes(fill=test, y=score, x=date, group=1)) +
    geom_bar(position='stack', stat='identity') +
    theme(
      panel.background = element_rect(fill = 'white', color = 'white'),
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(color = 'lightgrey'),
      legend.position="bottom", legend.title = element_blank(),
      legend.text = element_text(size=16))

  if (!is.null(bg_colour)) {
    p + theme(
      plot.background = element_rect(fill=bg_colour, color=bg_colour),
      legend.background = element_rect(fill=bg_colour, color=bg_colour))

  } else {
    p
  }
}

generate_time_graph <- function(consults_df, date_range, col_name, line_colour=NULL, plot_colour=NULL, bg_colour=NULL) {

  filtered_df <- consults_df |>
    dplyr::filter(dplyr::between(date, date_range[1], date_range[2]))

  vals <- filtered_df |>
    dplyr::pull(col_name)

  p <- ggplot(filtered_df, aes(x=date, y=vals, group=1, color=line_colour)) + xlab("Date") + ylab("Score") +
    geom_point() + geom_line() +
    scale_color_manual(values=c(line_colour)) +
    theme(
      panel.background = element_rect(fill = 'white', color = 'white'),
      panel.grid.major.x = element_blank(),
      panel.grid.major.y = element_line(color = 'lightgrey'),
      legend.position="none")

  if (!is.null(bg_colour)) {
    p + theme(plot.background = element_rect(fill=bg_colour, color=bg_colour))

  } else {
    p
  }
}

generate_summary_card <- function(data_list) {
  tags$div(class="data_container", style="grid-area:consult",
    tags$div(class="grid_title",
      glue("Consultation date: {format(as.Date(data_list$date), '%d/%m/%y')}")
    ),
    tags$div(
      tags$div(class="grid_title",
        glue("Percieved Stress Score: {sum(data_list$pss_data$answers)}"),
      ),
      tags$div(class="grid_item",
        create_pss_bar(data_list$pss_data$answers)
      )
    ),
    tags$div(
      tags$div(class="grid_title",
        "Wisconsin Card Test"
      ),
      tags$div(class="grid_item",
        create_wct_table(
          data_list$wct_data$rule_answers,
          data_list$wct_data$col_count
        )
      )
    ),
    tags$div(
      tags$div(class="grid_title",
        glue(
          "Visual Attention Test: {sum(data_list$vat_data$answers)} out of
             {length(data_list$vat_data$answers)}")
      )
    ),
    tags$div(class="grid_title", {
      if (norm(data_list$clock_data$angle_errors, type="2") < 20) {
        result = "Pass"
      } else {
        result = "Fail"
      }
      glue("Clock test: {result}")
    })
  )
}

