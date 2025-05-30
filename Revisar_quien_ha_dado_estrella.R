library(httr)
library(jsonlite)

usuario <- "santiagomota"
repositorio <- "Open_Data"

# Si tienes un token de GitHub, inclúyelo aquí (opcional pero recomendable)
# Puedes crearlo en: https://github.com/settings/tokens
github_token <- Sys.getenv("GITHUB_PAT")

headers <- add_headers(
    Authorization = paste("token", github_token),
    Accept = "application/vnd.github.v3.star+json"  # Cabecera especial
)

url <- paste0("https://api.github.com/repos/", usuario, "/", repositorio, "/stargazers")

res <- GET(url, headers)

if (status_code(res) == 200) {
    data <- content(res, as = "text", encoding = "UTF-8")
    json <- fromJSON(data, simplifyVector = FALSE)  
    
    stargazers <- data.frame(
        user = sapply(json, function(x) x$user$login),
        profile_url = sapply(json, function(x) x$user$html_url),
        starred_at = sapply(json, function(x) x$starred_at)
    )
    
    print(stargazers)
} else {
    print(paste("Error al acceder a la API:", status_code(res)))
}