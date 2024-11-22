# Ruta del archivo CSV original y la ruta para el archivo comprimido
source_file <- "/home/valenciag17/buckets/b1/datasets/competencia_02_nuevo.csv"
compressed_file <- "/home/valenciag17/buckets/b1/datasets/competencia_02_nuevo.csv.gz"

# Comprimir el archivo CSV
tryCatch({
  # Abrir el archivo CSV original
  data <- read.csv(source_file)
  
  # Escribir el archivo comprimido en formato .gz
  write.csv(data, gzfile(compressed_file), row.names = FALSE)
  
  cat("Archivo comprimido exitosamente en:", compressed_file, "\n")
}, error = function(e) {
  cat("Error al comprimir el archivo:", e$message, "\n")
})
