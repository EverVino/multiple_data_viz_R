# Configurando la carpeta de trabajo
setwd("/home/ever/ciudatos")
library("pacman")
p_load("readr")
p_load("wordcloud") # Biblioteca para graficar nuestra nube de palabras.
# Se usa un script en python para extraer las palabras más repetidas en 
# la CPE de Bolivia, no encontré una librería apropiada en R para
# hacer lo mismo
tabla <- read_csv("count_words.csv")
head(tabla)
# Para guardar en formato svg
# (puede requerir instalacion adicional de algunos paquetes)
svg("nube_palabras.svg")
wordcloud(words = tabla$word, 
          freq = tabla$count, 
          min.freq = 5, 
          max.words = 100, 
          random.order = FALSE, 
          colors = brewer.pal(8,"Paired"))
dev.off()
