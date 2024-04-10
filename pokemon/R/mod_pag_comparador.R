mod_pag_comparador_ui <- function(id) {
  ns <- NS(id)
  tagList(
    bslib::layout_columns(
      col_widths = c(3, 3, 3, 3),
      div(
        class = "coluna_imagem",
        uiOutput(ns("imagem1"))
      ),
      tagList(
        selectInput(
          ns("pokemon1"),
          label = "",
          choices = c("Carregando..." = ""),
        ),
        div(
          class = "tipo_pkmn",
          textOutput(ns("tipos1"))
        )
      ),
      tagList(
        selectInput(
          ns("pokemon2"),
          label = "",
          choices = c("Carregando..." = ""),
        ),
        div(
          class = "tipo_pkmn",
          div(
            style = "text-align: right;",
            textOutput(ns("tipos2"))
          )
        )
      ),
      div(
        class = "coluna_imagem",
        uiOutput(ns("imagem2"))
      )
    ),
    bslib::layout_columns(
      col_widths = c(3, 6, 3),
      uiOutput(ns("vb_pokemon1")),
      echarts4r::echarts4rOutput(ns("grafico_radar")),
      uiOutput(ns("vb_pokemon2"))
    )
  )
}

mod_pag_comparador_server <- function(id, dados) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    maximo <- 150

    pokemon <- setNames(
      dados$pokemon,
      stringr::str_to_sentence(dados$pokemon)
    )

    observe({
      if (input$pokemon2 == "") {
        opcoes <- pokemon
        selecionado <- opcoes[1]
      } else {
        opcoes <- pokemon[pokemon != input$pokemon2]
        selecionado <- isolate(input$pokemon1)
      }

      updateSelectInput(
        inputId = "pokemon1",
        choices = opcoes,
        selected = selecionado
      )
    })

    observe({
      if (input$pokemon1 == "") {
        opcoes <- pokemon[-1]
        selecionado <- opcoes[1]
      } else {
        opcoes <- pokemon[pokemon != input$pokemon1]
        selecionado <- isolate(input$pokemon2)
      }

      updateSelectInput(
        inputId = "pokemon2",
        choices = opcoes,
        selected = selecionado
      )
    })

    dados_filtrados1 <- reactive({
      req(input$pokemon1)
      dados |>
        dplyr::filter(pokemon == input$pokemon1)
    })

    dados_filtrados2 <- reactive({
      req(input$pokemon2)
      dados |>
        dplyr::filter(pokemon == input$pokemon2)
    })

    output$imagem1 <- renderUI({
      url <- criar_url_imagem(dados_filtrados1())
      img(src = url, width = "100%")
    })

    output$imagem2 <- renderUI({
      url <- criar_url_imagem(dados_filtrados2())
      img(src = url, width = "100%")
    })

    output$tipos1 <- renderText({
      pegar_tipos_pkmn(dados_filtrados1())
    })

    output$tipos2 <- renderText({
      pegar_tipos_pkmn(dados_filtrados2())
    })

    output$grafico_radar <- echarts4r::renderEcharts4r({

      cor1 <- dados_filtrados1()$cor_1

      if (dados_filtrados1()$tipo_1 == dados_filtrados2()$tipo_1) {
        if (!is.na(dados_filtrados2()$tipo_2)) {
          cor2 <- dados_filtrados2()$cor_2
        } else {
          cor2 <- "black"
        }
      } else {
        cor2 <- dados_filtrados2()$cor_1
      }

      pokemon1 <- stringr::str_to_sentence(dados_filtrados1()$pokemon)
      pokemon2 <- stringr::str_to_sentence(dados_filtrados2()$pokemon)

      tab_1 <- dados_filtrados1() |>
        dplyr::select(
          hp:velocidade
        ) |>
        tidyr::pivot_longer(
          cols = dplyr::everything(),
          names_to = "stats",
          values_to = "valor1"
        ) |>
        dplyr::mutate(
          stats = arrumar_nomes(stats)
        )

      tab_2 <- dados_filtrados2() |>
        dplyr::select(
          hp:velocidade
        ) |>
        tidyr::pivot_longer(
          cols = dplyr::everything(),
          names_to = "stats",
          values_to = "valor2"
        ) |>
        dplyr::mutate(
          stats = arrumar_nomes(stats)
        )

      tab_1 |>
        dplyr::left_join(tab_2, by = "stats") |>
        echarts4r::e_charts(x = stats) |>
        echarts4r::e_radar(serie = valor1, max = maximo, name = pokemon1) |>
        echarts4r::e_radar(serie = valor2, max = maximo, name = pokemon2) |>
        echarts4r::e_color(color = c(cor1, cor2)) |>
        echarts4r::e_tooltip() |>
        echarts4r::e_legend(padding = 0)

    })

    output$vb_pokemon1 <- renderUI({
      altura <- dados_filtrados1() |>
        dplyr::pull(altura)

      peso <- dados_filtrados1() |>
        dplyr::pull(peso)

      exp_base <- dados_filtrados1() |>
        dplyr::pull(exp_base)

      tagList(
        valuebox_altura(altura),
        valuebox_peso(peso),
        valuebox_exp_base(exp_base)
      )
    })

    output$vb_pokemon2 <- renderUI({
      altura <- dados_filtrados2() |>
        dplyr::pull(altura)

      peso <- dados_filtrados2() |>
        dplyr::pull(peso)

      exp_base <- dados_filtrados2() |>
        dplyr::pull(exp_base)

      tagList(
        valuebox_altura(altura),
        valuebox_peso(peso),
        valuebox_exp_base(exp_base)
      )
    })

  })
}

