# inflation_table.R
# https://gist.github.com/EconMaett/4c6d135d92678164ed6eae461faa79fa
library(tidyverse)
library(eurostat)
library(countrycode)
library(gt)
library(gtExtras)

data <- get_eurostat("prc_hicp_manr", filters = list(coicop = "CP00")) |> 
  mutate(time = date(paste0(time, "-01")))

ea.avg <- data |>
  filter(geo == "EA") |>
  slice_max(time, n = 1) |>
  pull(values)


# Make the date column a date

findat <- data |>
  left_join(codelist |> select(eurostat, country.name.de), by = c("geo" = "eurostat")) |>
  filter(time >= "2019-01-01", geo %in% c(eurostat::ea_countries$code, "HR")) |>
  select(geo, country.name.de, time, values) |>
  drop_na()

trend <- findat |> summarise(trend = list(values), .by = geo)

plotdat <- findat |>
  slice_max(time, n = 1, by = geo) |>
  mutate(abw = values - ea.avg) |>
  left_join(trend)

plotdat |>
  arrange(desc(values)) |>
  mutate(geo = ifelse(geo == "EL", "GR", geo)) |>
  gt() |>
  fmt_number(columns = values, locale = "de", decimals = 1, pattern = "{x}%") |>
  fmt_number(columns = abw, locale = "de", decimals = 1, force_sign = T) |>
  fmt_date(columns = time, rows = everything(), date_style = "yM", locale = "en") |>
  fmt_flag(columns = geo, height = "1.5em") |>
  gt_plt_sparkline(
    column = trend, same_limit = FALSE,
    palette = c(rep("black", 2), rep("transparent", 3))
  ) |>
  cols_label(
    geo = "", country.name.de = "",
    time = "Monat", values = "Inflation", abw = "Abw. Ø"
  ) |>
  cols_width(country.name.de ~ px(150), values ~ px(100), abw ~ px(80)) |>
  cols_align(align = "center", columns = c(time, values, abw)) |>
  data_color(columns = values, method = "numeric", palette = "Reds", alpha = 0.9) |>
  gt_highlight_rows(
    rows = geo == "AT", columns = c(geo, country.name.de, time),
    target_col = country.name.de, bold_target_only = T, fill = "transparent"
  ) |>
  tab_header(title = html("Inflationsraten in der Eurozone")) |>
  tab_footnote(
    footnote = "Harmonisierte Verbraucherpreisindizes",
    locations = cells_column_labels(values)
  ) |>
  tab_footnote(
    footnote = "Abweichung zum Durchschnitt der Eurozone",
    locations = cells_column_labels(abw)
  ) |>
  tab_source_note(source_note = html("<p style='text-align:right;'>Daten: Eurostat. Grafik: @matschnetzer</p>")) |>
  gt_theme_538() |>
  tab_options(
    heading.title.font.size = 24, 
    footnotes.padding = 0,
    footnotes.font.size = 10,
    source_notes.font.size = 10
  ) |>
  gtsave(filename = "eu_inflation_table.html")

print(plotdat)

# END