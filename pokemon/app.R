library(shiny)

ui <- bslib::page_navbar(
  title = img(src = "logo.png", class = "logo_pkmn"),
  window_title = "Pokémon",
  fillable = FALSE,
  bg = "#355fab",
  bslib::nav_panel(
    title = "Comparador",
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
    ),
    mod_pag_comparador_ui("pag_comparador_1")
  ),
  bslib::nav_panel(
    title = "Quem é esse Pokémon?",
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

  mod_pag_comparador_server("pag_comparador_1", dados)
  mod_pag_quem_server("mod_pag_quem_1")

}

shinyApp(ui, server)
