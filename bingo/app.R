library(shiny)
library(dplyr)

ui <- fluidPage(
  theme = bslib::bs_theme(version = 4),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  title = "Bingo",
  h1("Bingo", align = "center"),
  br(),
  fluidRow(
    column(
      class = "text-center",
      width = 5,
      div(
        class = "botao-sortear",
        shinyWidgets::actionBttn(
          inputId = "botao_misturar",
          label = "Misturar bolas",
          style = "gradient",
          color = "primary"
        ),
        br(),
        br(),
        br(),
        shinyWidgets::actionBttn(
          inputId = "botao_sortear",
          label = "Sortear número",
          style = "gradient",
          color = "success"
        )
      )
    ),
    column(
      width = 7,
      reactable::reactableOutput("tabela")
    )
  )
)

server <- function(input, output, session) {

  numeros <- tibble::tibble(
    B = stringr::str_pad(1:15, 2, "left", 0),
    I = 16:30,
    N = 31:45,
    G = 46:60,
    O = 61:75
  )

  globo <- reactiveVal(unlist(numeros))

  observeEvent(input$botao_misturar, {
    removeUI(
      selector = "#audio_gaiola"
    )

    insertUI(
      selector = ".botao-sortear",
      where = "afterEnd",
      ui = tags$audio(
        src = "bingo_cage.m4a",
        type = "audio/m4a",
        autoplay = TRUE,
        controls = NA,
        id = "audio_gaiola",
        style = "display: none;"
      )
    )
  })

  observeEvent(input$botao_sortear, {

    removeUI(
      selector = "#audio_gaiola"
    )

    bola <- sample(globo(), 1)

    globo(globo()[globo() != bola])

    showModal(
      modalDialog(
        div(
          class = "bola-sorteada",
          div(
            class = "numero-sorteado",
            bola
          )
        ),
        footer = NULL,
        easyClose = TRUE
      )
    )

  })

  output$tabela <- reactable::renderReactable({
    numeros |>
      reactable::reactable(
        pagination = FALSE,
        borderless = TRUE,
        sortable = FALSE,
        bordered = TRUE,
        fullWidth = FALSE,
        theme = reactable::reactableTheme(
          backgroundColor = "#362700",
          borderColor = "#362700",
          borderWidth = "8px",
          headerStyle = list(color = "white"),
          style = list(
            backgroundImage = 'url("wood-pattern.png");'
          )
        ),
        defaultColDef = reactable::colDef(
          align = "center",
          html = TRUE,
          cell = function(value) {
            if (!value %in% globo()) {
              span(span(value), class = "sorteado")
            } else {
              span(value, class = "nao-sorteado")
            }
          }
        )
      )
  })

}

shinyApp(ui, server)
