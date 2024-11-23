# Mejorado: Workflow Semillerio
# "Orden 227: Ni un paso atrás"

# Limpieza de memoria
rm(list = ls(all.names = TRUE)) # Eliminar todos los objetos
gc(full = TRUE) # Recolectar basura

require("rlang")
require("yaml")
require("data.table")

# Inicializar entorno global
if (!exists("envg")) envg <- env()

envg$EXPENV <- list()
envg$EXPENV$bucket_dir <- "~/buckets/b1"
envg$EXPENV$exp_dir <- "~/buckets/b1/expw227/"
envg$EXPENV$wf_dir <- "~/buckets/b1/flow227/"
envg$EXPENV$repo_dir <- "~/dmeyf2024/"
envg$EXPENV$datasets_dir <- "~/buckets/b1/datasets/"
envg$EXPENV$messenger <- "~/install/zulip_enviar.sh"

envg$EXPENV$semilla_primigenia <- 123456 # Cambiar a tu semilla preferida

# Error handler para reportar problemas
options(error = function() {
  traceback(20)
  options(error = NULL)
  cat(format(Sys.time(), "%Y%m%d %H%M%S"), "\n", file = "z-Rabort.txt", append = TRUE)
  stop("Saliendo después de error en el script")
})

#-------------------------------------------------------------------------------
# Incorporación de Dataset
DT_incorporar_dataset <- function(archivo) {
  if (-1 == (param_local <- exp_init())$resultado) return(0)
  param_local$meta$script <- "/src/wf-etapas/z1101_DT_incorporar_dataset.r"
  param_local$archivo_absoluto <- archivo
  param_local$primarykey <- c("numero_de_cliente", "foto_mes")
  param_local$entity_id <- c("numero_de_cliente")
  param_local$periodo <- c("foto_mes")
  param_local$clase <- c("clase_ternaria")
  return(exp_correr_script(param_local))
}

#-------------------------------------------------------------------------------
# Etapas optimizadas
# Catastrophe Analysis
CA_catastrophe_base <- function(metodo, atributos_eliminar = NULL) {
  if (-1 == (param_local <- exp_init())$resultado) return(0)
  param_local$meta$script <- "/src/wf-etapas/z1201_CA_reparar_dataset.r"
  param_local$metodo <- metodo # Opciones: "Ninguno", "MICE", "MachineLearning"
  param_local$atributos_eliminar <- atributos_eliminar
  return(exp_correr_script(param_local))
}

# Feature Engineering Intra-Mes
FEintra_manual_base <- function() {
  if (-1 == (param_local <- exp_init())$resultado) return(0)
  param_local$meta$script <- "/src/wf-etapas/z1301_FE_intrames_manual.r"
  return(exp_correr_script(param_local))
}

# Data Drifting
DR_drifting_base <- function(metodo) {
  if (-1 == (param_local <- exp_init())$resultado) return(0)
  param_local$meta$script <- "/src/wf-etapas/z1401_DR_corregir_drifting.r"
  param_local$metodo <- metodo # Opciones: "rank_cero_fijo", "deflacion", "estandarizar"
  return(exp_correr_script(param_local))
}

# Feature Engineering Histórico
FEhist_base <- function(lags = 1:3, ventana = 6, tendencias = TRUE) {
  if (-1 == (param_local <- exp_init())$resultado) return(0)
  param_local$meta$script <- "/src/wf-etapas/z1501_FE_historia.r"
  param_local$lag1 <- 1 %in% lags
  param_local$lag2 <- 2 %in% lags
  param_local$lag3 <- 3 %in% lags
  param_local$Tendencias1$run <- tendencias
  param_local$Tendencias1$ventana <- ventana
  return(exp_correr_script(param_local))
}

# Canaritos Asesinos
CN_canaritos_asesinos_base <- function(ratio = 1.0, desvio = 0) {
  if (-1 == (param_local <- exp_init())$resultado) return(0)
  param_local$meta$script <- "/src/wf-etapas/z1601_CN_canaritos_asesinos.r"
  param_local$CanaritosAsesinos$ratio <- ratio
  param_local$CanaritosAsesinos$desvios <- desvio
  return(exp_correr_script(param_local))
}

# Hyperparameter Tuning
HT_tuning_base <- function(iteraciones = 50) {
  if (-1 == (param_local <- exp_init())$resultado) return(0)
  param_local$meta$script <- "/src/wf-etapas/z2201_HT_lightgbm_gan.r"
  param_local$bo_iteraciones <- iteraciones
  param_local$lgb_param <- list(
    learning_rate = c(0.01, 0.1),
    num_leaves = c(31, 128, "integer"),
    feature_fraction = c(0.6, 0.9)
  )
  return(exp_correr_script(param_local))
}

#-------------------------------------------------------------------------------
# Flujo principal
wf_mejorado <- function(nombre) {
  param_local <- exp_wf_init(nombre)
  DT_incorporar_dataset("~/buckets/b1/datasets/competencia_02.csv.gz")
  CA_catastrophe_base("MICE")
  FEintra_manual_base()
  DR_drifting_base("deflacion")
  FEhist_base(lags = 1:2, ventana = 12)
  CN_canaritos_asesinos_base(ratio = 0.5, desvio = 2)
  ht <- HT_tuning_base(iteraciones = 60)
  return(exp_wf_end())
}

# Ejecutar el flujo
wf_mejorado("workflow_optimizado")