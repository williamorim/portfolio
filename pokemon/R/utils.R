criar_url_imagem <- function(tab) {
  id <- tab |>
    dplyr::pull(id) |>
    stringr::str_pad(
      width = 3,
      side = "left",
      pad = "0"
    )

  url <- glue::glue(
    "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/{id}.png"
  )
}

arrumar_nomes <- function(x) {
  dplyr::case_when(
    x == "hp" ~ "HP",
    x == "ataque" ~ "Ataque",
    x == "defesa" ~ "Defesa",
    x == "ataque_especial" ~ "Ataque especial",
    x == "defesa_especial" ~ "Defesa especial",
    x == "velocidade" ~ "Velocidade"
  )
}

pegar_tipos_pkmn <- function(tab) {
  tab |>
    dplyr::mutate(
      tipos = paste(na.omit(c(tipo_1, tipo_2)), collapse = ", ")
    ) |>
    dplyr::pull(tipos) |>
    stringr::str_to_sentence()
}

tema_vb <- function() {
  bslib::value_box_theme(
    bg = "#ffcc0255",
    fg = "#355fab"
  )
}

valuebox_altura <- function(x) {
  bslib::value_box(
    title = "Altura",
    value = glue::glue("{x}m"),
    showcase = icon("ruler-vertical"),
    theme = tema_vb()
  )
}

valuebox_peso <- function(x) {
  bslib::value_box(
    title = "Peso",
    value = glue::glue("{x}Kg"),
    showcase = icon("weight-hanging"),
    theme = tema_vb()
  )
}


valuebox_exp_base <- function(x) {
  bslib::value_box(
    title = "Experiência base",
    value = x,
    showcase = icon("dumbbell"),
    theme = tema_vb()
  )
}
