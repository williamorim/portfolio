library(shiny)

ui <- shinyUI(
  fluidPage(
    tags$head(
      tags$link(
        rel = "stylesheet",
        href = "custom.css"
      ),
      tags$script(src = "script.js")
    ),
    titlePanel("Comparador de imagens"),
    sidebarLayout(
      sidebarPanel(
        fileInput("imagem1", label = "Imagem da esquerda", accept = "image/*"),
        fileInput("imagem2", label = "Imagem da direita", accept = "image/*")
      ),
      mainPanel(
        div(
          class = "img-comp-container",
          uiOutput("imagem1", class = "img-comp-img"),
          uiOutput("imagem2", class = "img-comp-img img-comp-overlay")
        )
      )
    )
  )
)

server <- function(input, output, session) {

  output$imagem1 <- renderUI({

    if (isTruthy(input$imagem1)) {
      tags$img(src = input$imagem1$datapath)
    } else {
      tags$img(
        src = "imagens_satelite_arcelormittal_barragem_de_rejeitos_2023_04---2018.jpg",
        width = "600px"
      )
    }

  })

  output$imagem2 <- renderUI({

    if (isTruthy(input$imagem2)) {
      tags$img(src = input$imagem2$datapath)
    } else {
      tagList(
        tags$img(
          src = "imagens_satelite_arcelormittal_barragem_de_rejeitos_2023_04---2019.jpg",
          width = "600px"
        ),
        tags$script("initComparisons();")
      )

    }

  })

}

shinyApp(ui, server, options = list(launch.browser = FALSE, port = 4243))
