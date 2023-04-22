# Install packages
# install.packages("pacman")
# install.packages("devtools", dependencies = TRUE)
# install.packages("waffle", repos = "https://cinc.rud.is")
setwd("/home/ever/ciudatos/uploaded")
library("pacman")
p_load("ggplot2")
p_load("dplyr")
p_load("extrafont")
p_load("tidyr")

p_load("readr")
#p_unload("waffle")

library(waffle)

# read data from a csv file
data <- read_csv("BOLIVIA_DIAS_CON-PRECIPITACION(2005-2021).csv")
data$`2021` <- as.numeric(data$`2021`)

# Sorting data and taking just 2021 year column
sorted_data <- data %>% select(ESTACION, `2021`) %>% arrange(`2021`)

# Getting day without rain
tres_dep <-
  data %>% filter(ESTACION %in% c("Cobija", "La Paz", "Trinidad")) %>%
  select(ESTACION, "2021") %>%
  mutate(
    `DIAS SIN LLUVIA` = as.integer(365) - as.integer(`2021`),
    `DIAS CON LLUVIA` = as.integer(`2021`)
  ) %>%
  select(ESTACION, `DIAS CON LLUVIA`, `DIAS SIN LLUVIA`) %>%
  gather(key = TIEMPO,
         value = DIAS,
         c(`DIAS CON LLUVIA`, `DIAS SIN LLUVIA`))

head(tres_dep)

# To show in the desired order
new_order <- c("Cobija", "La Paz", "Trinidad")
tres_dep <-
  arrange(transform(tres_dep, ESTACION = factor(ESTACION, levels = new_order)), ESTACION)

# Plotting 
ggplot(tres_dep, aes(fill = TIEMPO, values = DIAS)) +
  geom_waffle(
    n_rows = 20,
    size = 0.53,
    colour = "white",
    flip = T
  ) +
  facet_wrap( ~ ESTACION, nrow = 1, strip.position = "bottom") +
  scale_fill_manual(
    name = NULL,
    values = c("#BFEFFF", "azure3"),
    labels = c("Días con lluvia", "Días sin lluvia")
  ) +
  labs(title = "Cantidad de días de lluvia en ciudades de Bolivia",
       caption = "Fuente: INE Bolivia") +
  
  theme_void(base_family = "Open Sans") +
  theme(
    strip.text = element_text(size = rel(1.3)),
    plot.title = element_text(
      face = "bold",
      size = rel(1.5),
      hjust = 0.5
    ),
    legend.text = element_text(size = rel(1.1)),
    plot.subtitle = element_text(size = rel(1.3), hjust = 0.5),
    plot.caption = element_text(vjust = 1, size = rel(1.2))
  )

# Saving the generated image
ggsave(
  filename = "./tre_dep.png",
  path = "./",
  # scale = 1,
  device = "png",
  dpi = 320
)
