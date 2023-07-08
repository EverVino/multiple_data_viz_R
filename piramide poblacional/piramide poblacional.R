# Configure la carpeta de trabajo
setwd("/home/ever/ciudatos")
library("pacman")
p_load("ggplot2")
p_load("dplyr")
p_load("readr")
p_load("tidyr")
p_load("svglite")
p_load("lemon")

# Importando los datos de nuestro archivo CSV
# puede encontrar datos de los otros departamentos 
# en ciudados bolivia
data <- read_csv("TARIJA PROYECCIONES DE POBLACION POR SEXO, EDAD 2012-2022.csv", col_types = "f")
head(data)

# Realizando el data wrangling
data2022 <- data %>% select(`Rango de Edad`, Edad, `Hombres-2022`, `Mujeres-2022`)
head(data2022)

new_data <- data2022 %>% gather(key=generoaño, value=Valor, 3:4) %>% 
  separate(generoaño, into = c("genero", "año"), sep="-") %>%
  group_by(`Rango de Edad`, genero) %>% summarize(total=sum(Valor))
total_pop = sum(new_data$total)

head(new_data)
new_data <- new_data %>% mutate(porcentaje=paste(round(total/total_pop*100,2),"%",sep=""))

ggplot(data = new_data, 
       mapping = aes(x = ifelse(test = genero == "Hombres", yes = -total, no = total), 
                     y = `Rango de Edad`, fill = genero)) +
  geom_col() +
  geom_text(label= new_data$porcentaje, stat = "identity", 
            hjust=ifelse(test = new_data$genero == "Hombres",  yes = -0.25, no = 1.25),
            color="white", fontface="bold", size=3)+
  scale_x_symmetric(labels = abs) +
  scale_fill_brewer(palette="Set1") 
  theme_minimal()+
  labs(
    x = "",
    y = "",
    fill=""
  )+
  theme( 
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    axis.text.x=element_blank(), 
    axis.text.y=element_text( size=15),
    strip.text.x=element_text(size=15),
    legend.position="bottom",
    legend.text=element_text(size=20)
  )

ggsave(
  filename = "./tarijapoblacion2022.svg",
  path = "./",
  #scale = 1,
  device = "svg",
  dpi = 320
)
total_pop

