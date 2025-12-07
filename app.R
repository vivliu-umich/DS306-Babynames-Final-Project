library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
library(broom)

# Load precomputed summary (small file)
gni_summary <- readRDS("gni_summary.rds")

ui <- fluidPage(
  titlePanel("Gender-Neutral Baby Names Across the US"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        "state", "Select a state:",
        choices = sort(unique(gni_summary$state)),
        selected = "CA"
      )
    ),
    mainPanel(
      plotOutput("trend_plot"),
      br(),
      textOutput("significance_text"),
      br(),
      DTOutput("ranking_table")
    )
  )
)

server <- function(input, output, session) {
  
  # Trend plot
  output$trend_plot <- renderPlot({
    df <- gni_summary %>% filter(state == input$state)
    ggplot(df, aes(year, prop_gender_neutral)) +
      geom_line(color = "#0072B2", size = 1.2) +
      geom_point(color = "#0072B2", size = 1.4) +
      scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
      labs(title = paste("Trend in", input$state),
           x = "Year", y = "% Gender-Neutral Names") +
      theme_minimal(base_size = 15)
  })
  
  # Significance text
  output$significance_text <- renderText({
    df <- gni_summary %>% filter(state == input$state)
    model <- lm(prop_gender_neutral ~ year, data = df)
    pval <- tidy(model)$p.value[2]
    slope <- tidy(model)$estimate[2]
    sig <- ifelse(pval < 0.05, "YES", "NO")
    dir <- ifelse(slope > 0, "increasing", "decreasing")
    paste0("Significant trend? ", sig, " (p=", round(pval,4), ")\nDirection: ", dir)
  })
  
  # Ranking table
  output$ranking_table <- renderDT({
    latest_year <- max(gni_summary$year)
    latest_data <- gni_summary %>% filter(year == latest_year)
    trend_stats <- gni_summary %>%
      group_by(state) %>%
      do({
        model <- lm(prop_gender_neutral ~ year, data = .)
        tidy(model)[2, c("estimate", "p.value")]
      }) %>%
      rename(slope = estimate, p_value = p.value)
    ranking <- latest_data %>%
      left_join(trend_stats, by="state") %>%
      mutate(percent = prop_gender_neutral*100,
             direction = ifelse(slope>0,"increasing","decreasing"),
             rank = row_number()) %>%
      select(rank,state,percent,direction,slope,p_value)
    datatable(ranking, rownames=FALSE, options=list(pageLength=10),
              colnames=c("Rank","State","% Gender-Neutral","Trend Direction","Slope","p-value"))
  })
}

shinyApp(ui, server)
