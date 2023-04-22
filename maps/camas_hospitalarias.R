setwd("/home/ever/ciudatos/mapas/departamentos")
library("pacman")
p_load("sf")
p_load("rgdal")
p_load("ggplot2")
p_load("dplyr")
p_load("readr")

#Reading the shp file
map <-
  st_read("Departamentos_Bolivia_2015.shp", options = "ENCODING=LATIN1")
n_map <- map

# Reading data
datos <-
  read_csv(
    "../../uploaded/BOLIVIA CAMAS HOSPITALARIAS Y HABITANTES POR CAMAS HOSPITALARIAS SEGUN DEPARTAMENTO 2005-2021.csv"
  )
head(datos)

n_datos <- datos %>% select(DEPARTAMENTO, INDICADOR, `2021`) %>%
  filter(`INDICADOR` == "Habitantes por Cama Hospitalaria") %>%
  select(DEPARTAMENTO, `2021`)

n_datos <-
  n_datos %>% mutate(`CAMAS_HOP/1000_HAB` = (1 / `2021`) * 1000) %>%
  select(DEPARTAMENTO, `CAMAS_HOP/1000_HAB`) %>%
  mutate(`CAMAS_HOP/1000_HAB` = round(`CAMAS_HOP/1000_HAB`, 2))

# Joining data
new_data <-
  left_join(n_map, n_datos, join_by(DEPARTAMEN == DEPARTAMENTO))
head(new_data)
new_data %>%
  ggplot() +
  geom_sf(color = "#563594",
          aes(fill = `CAMAS_HOP/1000_HAB`),
          lwd = 0.1) +
  geom_sf_text(
    aes(label = `CAMAS_HOP/1000_HAB`, color = `CAMAS_HOP/1000_HAB`),
    size = 5,
    fontface = "bold"
  ) +
  scale_colour_gradientn(
    colors = c("#4b4453", "#4b4453", "#4b4453", "#4b4453", "#fefedf"),
    guide = "none"
  ) +
  scale_fill_continuous(
    low = "#fbeaff",
    high = "#563594",
    na.value = "white",
    guide = "colorbar",
    labels = scales::label_number(big.mark = " ")
  ) +
  theme_void() +
  theme(legend.position = "none")

# Saving the generated image
ggsave(
  filename = "./camas_hospx1000hab.png",
  path = "./",
  #scale = 1,
  device = "png",
  dpi = 320
)
