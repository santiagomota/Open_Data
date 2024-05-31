# Instalar las bibliotecas necesarias
if (!require("httr")) install.packages("httr")
if (!require("stringr")) install.packages("stringr")
if (!require("usethis")) install.packages("usethis")

# Cargar las bibliotecas
library(httr)
library(stringr)
library(usethis)

# Definir la URL del repositorio y el archivo README.md
repo_url <- "https://raw.githubusercontent.com/santiagomota/Open_Data/73b1a582cb5c908d00b914e0e541b8bf81605c9c/README.md"

# Leer el contenido del archivo README.md
readme_content <- readLines(repo_url, warn = FALSE)

# Extraer todos los enlaces del archivo README.md
extract_links <- function(text) {
    str_extract_all(text, "https?://[^\\s)]+")[[1]]
}

links <- unlist(lapply(readme_content, extract_links))

# Comprobar el estado de cada enlace
check_link <- function(link) {
    response <- tryCatch({
        httr::GET(link)
    }, error = function(e) {
        NULL
    })
    
    if (is.null(response)) {
        return(NA)
    }
    
    status <- status_code(response)
    return(status)
}

# Crear un data frame con los resultados
results <- data.frame(
    link = links,
    status = sapply(links, check_link)
)

# Mostrar los resultados
print(results)

# Guardar los resultados en un archivo CSV
# write.csv(results, "link_check_results.csv", row.names = FALSE)
