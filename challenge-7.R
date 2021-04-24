# # B. Kießling
# Challenge 7: plotly und leaflet
# Zur Überprüfung dienen erneut die beiden Outputs (plot und map)

# plotly Verhältnis Arbeitlosigkeit und Migration -----------------------------

# 1. Lade den Datensatz stadtteil_profil_updated.rds in das Objekt stadtteile
# 2. Erstelle ein Scatter-Plot mit arbeitslosenanteil_in_percent_dez_2019 auf der y-Achse
# und anteil_der_bevolkerung_mit_migrations_hintergrund_in_percent auf der x-Achse
# 3. Löse das Problem beim Column arbeitslosenanteil_in_percent_dez_2019, sodass sich dieser richtig visualisieren lässt
# Tipp: Die Funktion as.numeric() wird dir dabei weiterhelfen
# 4. Runde die beiden zu visualierenden Columns auf eine Nachkommastelle
# 5. Beschrifte die x-Achse und y-Achse und erstelle einen Titel für den Plot
# 6. Nutze die Argumente text und hoverinfo und stelle die Hoverinfo wie im Beispieldiagramm dar
# Tipp: Für die Gestaltung der Hoverinformationen findest du alle Informationen hier: https://plotly.com/r/text-and-annotations/ im Abschnitt Custom Hover Text
# 7. Speichere den Plot mit htmlwidgets::saveWidget(as_widget(plotobject), "myfirstplot.html")
# 8. Interpretiere die Daten

# leaflet: Arbeitslosigkeit pro Stadtteil ----------------------------------

# 1. Lade den Datensatz stadtteile_wsg84.RDS in das Objekt stadtteile_gps
# 2. Benenne die Columns im Objekt stadtteile_gps von Stadtteil und Bezirk und stadtteil und bezirk um
# 3. Joine beide Datensätze in das Objekt stadtteile und nutze die Funktion %>% st_as_sf() am Ende der Pipe, um das Objekt als sf zu konvertieren
# 4. Erstelle ein leaflet Objekt und wähle ein Design über addProviderTiles(), 
# 5. Setze setView() auf (9.993682, 53.551086 = und wähle eine Zoom-Stufe
# 6. Ergänze die Code-Fragmente
# 7. Speichere die Map mit htmlwidgets::saveWidget(as_widget(mapobject), "myfirstmap.html")

# Wir werden die Map in der nächsten Einheit weiter gestalten!

# load packages
library(plotly)
library(leaflet)
library(tidyverse)
library(sf)
library(dplyr)

# load data for plot

stadtteil <- readRDS("data/stadtteile_profil_updated.rds") %>%
  transform(arbeitslosenanteil_in_percent_dez_2019 = as.numeric(arbeitslosenanteil_in_percent_dez_2019)) %>% 
  mutate_at(vars(arbeitslosenanteil_in_percent_dez_2019, anteil_der_bevolkerung_mit_migrations_hintergrund_in_percent), funs(round(., 1)))

# plotly

plotobject <- plot_ly(data = stadtteil, 
                      x= ~anteil_der_bevolkerung_mit_migrations_hintergrund_in_percent, 
                      y = ~arbeitslosenanteil_in_percent_dez_2019, 
                      type="scatter", 
                      mode = "markers",
                      hoverinfo = "text",
                      text = ~paste('<br>Migrationsanteil: ', anteil_der_bevolkerung_mit_migrations_hintergrund_in_percent,
                                    '<br>Arbeitslosenanteil: ', arbeitslosenanteil_in_percent_dez_2019, 
                                    '<br>Stedtteil: ', stadtteil),
                      showlegend = FALSE) %>%
  layout(title = "Verhältnis von Arbeitslosen und Menschen mit Migrationshintergrund in Hamburg",
         xaxis = list(title = "Anteil Migrationshintergrund in %"),
         yaxis = list(title = "Arbeitslosenanteil in %"))


htmlwidgets::saveWidget(as_widget(plotobject), "myfirstplot.html")

# load data for map

stadtteile_gps <- readRDS("data/stadtteile_wsg84.RDS") %>% 
  rename(stadtteil = Stadtteil) %>%
  rename(bezirk = Bezirk)

# join data
stadtteile <- stadtteile %>% 
  left_join(stadtteile_gps) %>% 
  st_as_sf()

# leaflet 
bins <- c(0, 2, 4, 6, 8, 10, Inf)
pal <- colorBin("YlOrRd", domain = stadtteile$arbeitslosenanteil_in_percent_dez_2019, bins = bins)

leaflet() %>% 
  addProviderTiles() %>% 
  setView() %>% 
  addPolygons(data = ,
              fillColor = ~pal(arbeitslosenanteil_in_percent_dez_2019),
              weight = ,
              opacity = ,
              color = ,
              fillOpacity = )



