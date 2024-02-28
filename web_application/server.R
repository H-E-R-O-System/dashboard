
server <- function(input, output, session) {
  # Main Panel --------

  ## Define reactive values -----
  reactive_vals <- shiny::reactiveValues(
    user_consults = all_consults$user_1,
    date_range = c(today -lubridate::weeks(10), today),
    module_track_df = NULL,
    selected_consult = NULL
  )

  ## Define observe events ----
  shiny::observeEvent(
    ### Update user selection -------
    eventExpr = input$user_filter,
    handlerExpr = {
      reactive_vals$user_consults <- all_consults[[input$user_filter]]
      reactive_vals$module_track_df <- generate_module_track_df(
        reactive_vals$user_consults
      )
      reactive_vals$selected_consult = NULL
    }
  )

  shiny::observeEvent(
    eventExpr = input$activity_range_filter,
    handlerExpr = {
      ### Update date range -----
      reactive_vals$date_range = input$activity_range_filter
      reactive_vals$selected_consult = NULL
    }
  )

  shiny::observeEvent(
    eventExpr = input$bar_click,
    handlerExpr = {
      selected_rows <- reactive_vals$module_track_df |>
        dplyr::mutate(dist = abs(as.numeric(date) - input$bar_click$x)) |>
        dplyr::filter(dist < 2.5) |>
        dplyr::arrange(dist)

      reactive_vals$selected_consult <- selected_rows |>
        dplyr::first() |>
        dplyr::pull(consult_id)

      # print(reactive_vals$selected_consult)
    }
  )

  ## define UI outputs ------

  output$user_barchart <- shiny::renderPlot({
    if (!is.null(reactive_vals$module_track_df)) {
      generate_stacked_barchart(
        reactive_vals$module_track_df, reactive_vals$date_range, bg_colour=blue_3, line_colour=hero_blue
      )
    }
  })

  output$wisconsin_time_plot <- shiny::renderPlot({
    generate_time_graph(
      reactive_vals$module_track_df, reactive_vals$date_range, "wct_score", bg_colour=blue_3, line_colour=hero_blue
    )
  })

  output$pss_time_plot <- shiny::renderPlot({
    generate_time_graph(
      reactive_vals$module_track_df, reactive_vals$date_range, "pss_score", bg_colour=blue_3, line_colour=hero_blue
    )
  })

  output$wct_time_plot <- shiny::renderPlot({
    generate_time_graph(
      reactive_vals$module_track_df, reactive_vals$date_range, "pss_score", bg_colour=blue_3, line_colour=hero_blue
    )
  })

  output$consult_summary <- shiny::renderUI({
    if (!is.null(reactive_vals$selected_consult)) {
      if (!is.na(reactive_vals$selected_consult)) {
        consult_data <- reactive_vals$user_consults[[reactive_vals$selected_consult]]

        generate_summary_card(
          consult_data
        )
      }
    }
  })

  ## Finish

  shiny::observeEvent(
    eventExpr = input$user_filter_consult,
    handlerExpr = {
      consult_panel$user_data <- all_consults[[input$user_filter_consult]]

      consult_panel$user_data_df <- generate_module_track_df(consult_panel$user_data)

      choice_list <- consult_panel$user_data_df |> dplyr::pull("consult_id")
      names(choice_list) <- consult_panel$user_data_df |> dplyr::pull("date")
      shiny::updateSelectInput(
        inputId = "consult_filter",
        choices = choice_list
      )
    }
  )

  shiny::observeEvent(
    eventExpr = input$consult_filter,
    handlerExpr = {
      consult_panel$consult_data <- consult_panel$user_data[[input$consult_filter]]
      consult_panel$user_data_df <- generate_module_track_df(consult_panel$user_data)
    }
  )

  output$consult_count <- shiny::renderText(
    glue("Consultations: {length(user_panel$selected_consults)}")
  )

  output$vat_score <- shiny::renderText(
    glue("Consultations: {length(user_panel$selected_consults)}")
  )

  ### PSS outputs -------
  output$pss_session_visual <- shiny::renderUI({
    if (!is.null(consult_panel$consult_data$PSS_Answers)) {
      create_pss_bar(consult_panel$consult_data$PSS_Answers)
    }
  }

  )
  output$pss_session_score <- shiny::renderText(
    glue("Total Score: {sum(consult_panel$consult_data$PSS_Answers)}")
  )

  output$wisconsin_consult_visual <- shiny::renderUI({
    if (!is.null(consult_panel$consult_data)) {
      create_wct_table(
        consult_panel$consult_data$WCT_Rule_Answers,
        consult_panel$consult_data$WCT_Col_Count
      )
    }
  })

  user_panel <- shiny::reactiveValues(
    user_consults = all_consults$user_1,
    selected_consults = all_consults$user_1,
    module_time_changes = {
      df <- data.frame(matrix(ncol=3, nrow=0))
      colnames(df) <- c("date", "wct_score", "pss_score")
      df
    }
  )

  consult_panel <- shiny::reactiveValues(
    user_data = all_consults$user_1,
    consult_data = {all_consults$user_1[[1]]},
    user_data_df = {
      df <- data.frame(matrix(ncol=3, nrow=0))
      colnames(df) <- c("date", "wct_score", "pss_score")
      df
    }
  )
}
