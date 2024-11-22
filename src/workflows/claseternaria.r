# Define el directorio correctamente
DIR <- "C:/Users/glova/OneDrive/Documentos"

# Cargamos los datos
cat("Cargando datos...\n")
data <- fread(paste0(DIR, "/ejemploternaria.csv"))


# Ordenar los datos por número de cliente y foto_mes
data <- data[order(data$numero_de_cliente, data$foto_mes), ]

# Crear la columna clase_ternaria
data$clase_ternaria <- "CONTINUA" # Inicializar con CONTINUA

# Identificar BAJA+1 y BAJA+2
for (i in 1:(nrow(data) - 1)) {
  if (data$numero_de_cliente[i] == data$numero_de_cliente[i + 1]) {
    if (data$foto_mes[i + 1] != data$foto_mes[i] + 1) {
      data$clase_ternaria[i] <- "BAJA+1"
    }
  } else {
    data$clase_ternaria[i] <- "BAJA+2"
  }
}

# Asegurar que los clientes en el último foto_mes tienen CONTINUA
ultimo_mes <- max(data$foto_mes)
data$clase_ternaria[data$foto_mes == ultimo_mes] <- "CONTINUA"

# Guardamos el dataset
fwrite(data, paste0(DIR, "/competencia_0223_ejmplo.csv"))