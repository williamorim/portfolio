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
          div(
            class = "img-comp-img",
            imageOutput("imagem1", width = "640px", height = "426px")
          ),
          div(
            class = "img-comp-img img-comp-overlay",
            imageOutput("imagem2", width = "640px", height = "426px")
          )
        )
      )
    ),
    tags$script("initComparisons();")
  )
)

server <- function(input, output, session) {

  output$imagem1 <- renderImage({

    if (isTruthy(input$imagem1)) {
      list(src = input$imagem1$datapath)
    } else {
      list(src = "www/horizon_pb.jpg")
    }

  }, deleteFile = FALSE)

  output$imagem2 <- renderImage({

    if (isTruthy(input$imagem2)) {
      list(src = input$imagem2$datapath)
    } else {
      list(src = "www/horizon.jpg")
    }

  }, deleteFile = FALSE)

}

shinyApp(ui, server)
