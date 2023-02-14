library(shiny)

dados <- readr::read_rds("pkmn.rds")

ui <- fluidPage(
  style = "padding-bottom: 200px;",
  theme = bslib::bs_theme(version = 4),
  h1("Gerador de relatório R Markdown"),
  hr(),
  fluidRow(
    column(
      width = 3,
      selectInput(
        "pokemon",
        label = "Selecione um pokemon",
        choices = unique(dados$pokemon)
      )
    ),
    column(
      width = 2,
      class = "align-self-center",
      actionButton("visualizar", "Visualizar relatório")
    ),
    column(
      width = 2,
      class = "align-self-center",
      downloadButton("gerar", "Baixar relatório")
    )
  ),
  br(),
  fluidRow(
    column(
      offset = 1,
      width = 10,
      uiOutput("preview")
    )
  )
)

server <- function(input, output, session) {

  preview <- eventReactive(input$visualizar, {

    withProgress(
      message = "Gerando relatório...",
      {

        incProgress(0.3)

        rmarkdown::render(
          input = "relatorio.Rmd",
          output_file = "www/preview.html",
          params = list(pokemon = input$pokemon)
        )

        incProgress(0.7)

      })

    tags$iframe(src = "preview.html", width = "100%", height = "800px")

  })

  output$preview <- renderUI({
    preview()
  })

  output$gerar <- downloadHandler(
    filename = function() {glue::glue("relatorio_{input$pokemon}.pdf")},
    content = function(file) {

      arquivo_html <- tempfile(fileext = ".html")

      withProgress(
        message = "Gerando relatório...",
        {

          incProgress(0.3)

          rmarkdown::render(
            input = "relatorio.Rmd",
            output_file = arquivo_html,
            params = list(pokemon = input$pokemon)
          )

          incProgress(0.4)

          pagedown::chrome_print(
            input = arquivo_html,
            output = file
          )

        })

    }
  )

}

shinyApp(ui, server)
