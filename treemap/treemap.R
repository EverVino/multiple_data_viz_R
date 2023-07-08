library("pacman")
p_load("readr")
p_load("dplyr")
p_load("ggplot2")
p_load("treemapify")
p_load("svglite")
setwd("/home/ever/ciudatos/uploaded")
data <- read_csv("BOLIVIA EXPORTACIONES SEGUN ACTIVIDAD ECONOMICA Y PRINCIPALES PRODUCTOS 1992-2022.csv")
# Realizando el data wrangling reemplazando ceros y ordenando para la gráfica
data <- data %>% replace(is.na(.), 0)
head(data)
data <- data %>% mutate(sumrow = (`Enero-2022` + 
                          `Diciembre-2022`+
                          `Febrero-2022`+
                          `Marzo-2022`+
                          `Abril-2022`+
                          `Mayo-2022`+
                          `Junio-2022`+
                          `Julio-2022`+
                          `Agosto-2022`+
                          `Septiembre-2022`+
                          `Octubre-2022`+
                          `Noviembre-2022`)*1000
                        )
data <- data %>% select(`CATEGORIA PRINCIPAL`, `ACTIVIDAD ECONÓMICA Y PRODUCTO`, sumrow)
head(data)
total <- sum(data$sumrow)
total

p_load("colorspace")
p_load("scales")

# Para crear repetitibilidad
set.seed(342)

PL <- c(rep("PL1", 6), rep("PL2", 6), rep("PL3", 6), rep("PL4", 6))
CNT <- sample(seq(1:50), 24)
YEAR <- rep(c("2013", "2014", "2015", "2016", "2017", "2018"), 4)
df <- data.frame(PL, YEAR, CNT)
head(df)

# Cantidad paletas de colores requeridas
n <- length(unique(data$`CATEGORIA PRINCIPAL`))

# Calculamos para los subgrupos
df2 <- data %>% 
  mutate(index = as.numeric(factor(`CATEGORIA PRINCIPAL`))- 1) %>%
  group_by(`CATEGORIA PRINCIPAL`) %>%
  mutate(
    max_CNT = max(`sumrow`),
    color = gradient_n_pal(
      sequential_hcl(
        6,
        h = 360 * index[1]/n,
        c = c(45, 20),
        l = c(30, 80),
        power = .5)[1:3]
    )(1-`sumrow`/max_CNT)
  )

ggplot(df2, aes(area = `sumrow`, fill = color, label=`ACTIVIDAD ECONÓMICA Y PRODUCTO` , subgroup=`CATEGORIA PRINCIPAL`)) +
  geom_treemap() +
  geom_treemap_subgroup_border(colour="white") +
  geom_treemap_text(#fontface = "italic",
                    family="Open Sans",
                    colour = "white",
                    place = "centre",
                    grow = T,
                    reflow=T) +
  geom_treemap_subgroup_text(place = "centre",
                             grow = T,
                             alpha = 0.5,
                             colour = "#FAFAFA",
                             min.size = 0) +
  
  scale_fill_identity()
ggsave(
  filename = "./exportaciones_bolivia.svg",
  path = "./",
  scale = 2,
  device = "svg",
  dpi = 500
)
