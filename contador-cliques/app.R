library(shiny)

ui <- fluidPage(
  theme = bslib::bs_theme(version = 4),
  title = "Contador de cliques",
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  fluidRow(
    class = "align-items-center",
    column(
      width = 6,
      class = "text-center",
      shinyWidgets::actionBttn(
        inputId = "botao",
        label = "Clique aqui",
        style = "gradient",
        color = "warning",
        icon = icon("stopwatch")
      )
    ),
    column(
      width = 6,
      class = "text-center",
      uiOutput("num_total_cliques")
    )
  )
)

server <- function(input, output, session) {
  hora <- reactiveVal(value = Sys.time())
  num_cliques <- reactiveVal(value = 0)

  observeEvent(input$botao, {
    tempo_entre_cliques <- Sys.time() - hora()
    if (tempo_entre_cliques > 0.5) {
      num_cliques(1)
    } else {
      num_cliques(num_cliques() + 1)
    }
    hora(Sys.time())
  })

  output$num_total_cliques <- renderUI({
    tagList(
      p(class = "contagem-texto", "Cliques seguidos:"),
      p(class = "contagem", num_cliques())
    )
  })

}

shinyApp(ui, server)

