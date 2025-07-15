#--------------------------------------
# Created by Suleman Rasheed 
# Last Updated: July 08, 2025

# Data Link:  https://discover.data.vic.gov.au/dataset/epa-air-watch-all-sites-air-quality-hourly-averages-yearly

# The data has hourly averages different pollutants in different suburns of Victoria (Australia)
#--------------------------------------

library(shiny)
library(shinydashboard)
library(readxl)
library(openair)
library(lubridate)

# path to Excel data file
path_data <- "2024_All_sites_air_quality_hourly_avg_AIR-I-F-V-VH-O-S1-DB-M2-4-0.xlsx"

# load sheet names and extract suburb names
all_sheets         <- excel_sheets(path_data)
suburb_sheet_names <- all_sheets[4:length(all_sheets)]
suburb_names       <- sub("_(.*)", "", suburb_sheet_names)



## User Interface (Context) ##
ui <- dashboardPage(
  dashboardHeader(title="Air Quality Victoria"),
  dashboardSidebar(
      selectInput("suburb_name", "Suburb Name", choices=suburb_names),
      uiOutput("pollutant_ui")
  ),
  dashboardBody(
    fluidRow(
      box(title="Environment Protection Authority (EPA) 2024 Dataset", 
        plotOutput("calPlot", height = "650"), width=12),      # width 1-12 inside each row
    )

  )
)

## Server (visual rendering) ##
server <- function(input, output, session) {
  
  # 1. Which sheet to read
  sheet_selected <- reactive({
    req(input$suburb_name)
    suburb_sheet_names[
      match(input$suburb_name, suburb_names)
    ]
  })
  
  # 2. Read & preprocess that sheet
  data_selected <- reactive({
    df <- read_excel(path_data, sheet = sheet_selected())
    df$date <- ymd_hms(df$datetime_local)
    df
  })
  
  # 3. Build a pollutant selector once the data is loaded
  output$pollutant_ui <- renderUI({
    df <- data_selected()
    req(df)
    pollutant_choices <- names(df)[6:(ncol(df)-1)] # to remove non-polltant cols (data/time)
    selectInput(
      "selected_pollutant",
      "Select Pollutant",
      choices = pollutant_choices,
      selected = pollutant_choices[1]
    )
  })
  
  # 4. Draw the calendarPlot for whatever the user picked
  output$calPlot <- renderPlot({
    df <- data_selected()
    req(input$selected_pollutant)
    p <- calendarPlot(
      df,
      pollutant = input$selected_pollutant,
      year      = 2024,
      main      = paste(input$suburb_name, "-", input$selected_pollutant)
    )
    print(p)
  })
}



shinyApp(ui, server)























### Comments: Works for a fixed data

# library(shiny)
# library(shinydashboard)
# library(readxl)
# library(openair)
# library(lubridate)
# 
# # path to your Excel file
# path_data <- "2024_All_sites_air_quality_hourly_avg_AIR-I-F-V-VH-O-S1-DB-M2-4-0.xlsx"
# data <- read_excel(path_data, sheet="Traralgon_10011")
# data$date <- ymd_hms(data$datetime_local)
# 
# 
# ## app.R ##
# ui <- dashboardPage(
#   dashboardHeader(),
#   dashboardSidebar(),
#   dashboardBody(
#     fluidRow(
#       box(title="Calendar Plot", 
#           plotOutput("calPlot", height = "600"), width=12),      # width 1-12 inside each row
#     )
#     
#   )
# )
# 
# server <- function(input, output) { 
#   output$calPlot <- renderPlot(
#     calendarPlot(data, pollutant="O3", year=2024, main="O3")
#   )   
# }
# 
# 
# shinyApp(ui, server)
# 


#### Second Script fine
# library(shiny)
# library(shinydashboard)
# library(readxl)
# library(openair)
# library(lubridate)
# 
# # path to your Excel file
# path_data <- "2024_All_sites_air_quality_hourly_avg_AIR-I-F-V-VH-O-S1-DB-M2-4-0.xlsx"
# 
# # load sheet names and extract suburb names
# all_sheets         <- excel_sheets(path_data)
# suburb_sheet_names <- all_sheets[4:length(all_sheets)]
# suburb_names       <- sub("_(.*)", "", suburb_sheet_names)
# 
# 
# 
# # Load data
# suburb = suburb_sheet_names[1]
# data <- read_excel(path_data, sheet=suburb)
# data$date <- ymd_hms(data$datetime_local)
# pollutant_names = names(data)[6:length(names(data))-1]
# pollutant = pollutant_names[2]
# print(pollutant_names)
# 
# 
# ## app.R ##
# ui <- dashboardPage(
#   dashboardHeader(title="Air Quality Victoria"),
#   dashboardSidebar(),
#   dashboardBody(
#     fluidRow(
#       box(title="Environment Protection Authority (EPA) 2024 Dataset", 
#           plotOutput("calPlot", height = "650"), width=12),      # width 1-12 inside each row
#     )
#     
#   )
# )
# 
# 
# server <- function(input, output) { 
#   output$calPlot <- renderPlot(
#     calendarPlot(data, pollutant=pollutant, year=2024, main=pollutant)
#   )   
# }
# 
# 
# shinyApp(ui, server)




# ##### Working for suburb names with custom pollutants
# 
# library(shiny)
# library(shinydashboard)
# library(readxl)
# library(openair)
# library(lubridate)
# 
# # path to your Excel file
# path_data <- "2024_All_sites_air_quality_hourly_avg_AIR-I-F-V-VH-O-S1-DB-M2-4-0.xlsx"
# 
# # load sheet names and extract suburb names
# all_sheets         <- excel_sheets(path_data)
# suburb_sheet_names <- all_sheets[4:length(all_sheets)]
# suburb_names       <- sub("_(.*)", "", suburb_sheet_names)
# 
# 
# 
# # # Load data
# # suburb = suburb_sheet_names[1]
# # data <- read_excel(path_data, sheet=suburb)
# # data$date <- ymd_hms(data$datetime_local)
# # pollutant_names = names(data)[6:length(names(data))-1]
# # pollutant = pollutant_names[2]
# # print(pollutant_names)
# 
# 
# ## app.R ##
# ui <- dashboardPage(
#   dashboardHeader(title="Air Quality Victoria"),
#   dashboardSidebar(
#     selectInput("suburb_name", "Suburb Name", choices=suburb_names)
#   ),
#   dashboardBody(
#     fluidRow(
#       box(title="Environment Protection Authority (EPA) 2024 Dataset", 
#           plotOutput("calPlot", height = "650"), width=12),      # width 1-12 inside each row
#     )
#     
#   )
# )
# 
# 
# server <- function(input, output, session) {
#   
#   # 1. match suburb dropdown to Excel sheet name
#   sheet_selected <- reactive({
#     req(input$suburb_name)
#     suburb_sheet_names[
#       match(input$suburb_name, suburb_names)
#     ]
#   })
#   
#   # 2. read & preprocess that sheet
#   data_selected <- reactive({
#     df <- read_excel(path_data, sheet = sheet_selected())
#     df$date <- ymd_hms(df$datetime_local)
#     df
#   })
#   
#   pollutant_names = names(df)[6:length(names(df))-1]
#   pollutant = pollutant_names[1]
#   print(pollutant_names)
#   print(pollutant)
#   
#   
#   
#   # 3. render a fixed-NO2 calendar plot
#   output$calPlot <- renderPlot({
#     df <- data_selected()
#     p <- calendarPlot(
#       df,
#       pollutant = pollutant,
#       year      = 2024,
#       main = paste(input$suburb_name, " - ", pollutant)
#       
#     )
#     print(p)
#   })
# }
# 
# 
# 
# shinyApp(ui, server)


