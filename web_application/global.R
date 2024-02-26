# Load Required Libraries -------
library(shiny)
library(shinydashboard)
library(shinythemes)
library(shinyWidgets)
library(DT)
library(RSQLite)
library(shinyjs)
library(shinymanager)
library(shinytoastr)
library(shinyBS)
library(toastui)
library(shinydashboardPlus)
library(htmlwidgets)
library(waiter)
library(shinydisconnect)
library(shinyscreenshot)
library(bslib)
library(readr)
library(purrr)
library(shinyTime)
library(fmsb)

Sys.setenv(VROOM_CONNECTION_SIZE=5000072)

# Define app colours -------
v_main_colour <- "#0B3861"

# Define app Loading Screen -------
html_loading_screen <- shiny::tagList(
  waiter::spin_folding_cube(),
  shiny::br(),
  shiny::h4("Loading Web Application...")
)

base::source("app_functions.R")


# Define useful paths ---

v_functions_path <- "app_functions.R"
v_global_session_path <- "global_session.R"
v_prepared_data_path <- "data/prepared_data/"
v_database_path <- base::paste(v_prepared_data_path, "Coventry_Godiva.db", sep="")

# Load app functions ------
base::source(v_functions_path)

exam_scores <- data.frame(
  row.names = c("patient_1"),
  Error = 6.2,
  Speed = 10,
  Distance = 3.7,
  Acceleration = 8.7,
  Jerk = 7.9
)

# defines the limits for the scale on the
max_min <- data.frame(
  Error = c(20, 0), Speed = c(20, 0), Distance = c(20, 0),
  Acceleration = c(20, 0), Jerk = c(20, 0)
)
rownames(max_min) <- c("Max", "Min")

# Bind the variable ranges to the data
radar_df <- rbind(max_min, exam_scores)
student1_data <- radar_df[c("Max", "Min", "patient_1"), ]

gpcog_score = c(1, 0, 0, 1, 1, 1, 1, 1, 0)


hero_blue <-  "#274251"
blue_2 <- "#89A7AD"
blue_3 <- "#E6F1F7"
