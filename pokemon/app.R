library(shiny)
library(shiny.router)

ui <- bslib::page_navbar(
  title = img(src = "logo.png", class = "logo_pkmn"),
  window_title = "Pokémon",
  fillable = FALSE,
  bg = "#355fab",
  id = "navbarId",
  bslib::nav_panel(
    title = "Comparador",
    value = "comparador",
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    mod_pag_comparador_ui("pag_comparador_1")
  ),
  bslib::nav_panel(
    title = "Quem é esse Pokémon?",
    value = "quem_e_esse_pokemon",
    mod_pag_quem_ui("mod_pag_quem_1")
  ),
  bslib::nav_spacer(),
  bslib::nav_item(
    tags$a(
      href = "https://github.com/williamorim/portfolio/tree/main/pokemon",
      target = "_blank",
      bsicons::bs_icon("github")
    )
  )
)

server <- function(input, output, session) {
  dados <- pokemon::pokemon_ptbr

  observeEvent(session$clientData$url_hash, priority = 1, {
    currentHash <- sub("#", "", session$clientData$url_hash)
    if (is.null(input$navbarId) || !is.null(currentHash) && currentHash != input$navbarId) {
      freezeReactiveValue(input, "navbarId")
      updateNavbarPage(session, "navbarId", selected = currentHash)
    }
  })

  observeEvent(input$navbarId, priority = 0, {
    currentHash <- sub("#", "", session$clientData$url_hash)
    pushQueryString <- paste0("#", input$navbarId)
    if (is.null(currentHash) || currentHash != input$navbarId) {
      freezeReactiveValue(input, "navbarId")
      updateQueryString(pushQueryString, mode = "push", session)
    }
  })

  mod_pag_comparador_server("pag_comparador_1", dados)
  mod_pag_quem_server("mod_pag_quem_1")
}

shinyApp(ui, server)
