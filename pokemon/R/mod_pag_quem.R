mod_pag_quem_ui <- function(id) {
  ns <- NS(id)
  div(
    class = "text-center",
    img(
      src = "https://37.media.tumblr.com/278ce435513b05daf5f30af5b437ad3f/tumblr_n2rjnv6JSd1szx1oxo1_500.gif",
      width = "500px"
    ),
    h2("Página em construção", class = "mt-4")
  )
}

mod_pag_quem_server <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}

#mod_pag_quem_ui("mod_pag_quem_1")
#mod_pag_quem_server("mod_pag_quem_1")
