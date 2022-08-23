
############################################################################
# Alexander DELAPORTE - CRLAO                                              #
# https://tekipaki.hypotheses.org/                                         #
# https://github.com/alxdrdelaporte/                                       #
# https://gitlab.com/alxdrdelaporte/                                       #
#                                                                          #
#                                                                          #
# Cartographier des données linguistiques avec R                           #
# https://tekipaki.hypotheses.org/2744                                     #
#                                                                          #
#                                                                          #
############################################################################

# Données d'entrée
# Voir : https://tekipaki.hypotheses.org/1225
# Données issues de la base Glottolog
# Glottolog 4.3 par Hammarström, Harald & Forkel, Robert & Haspelmath, Martin &
# Bank, Sebastian sous licence Creative Commons Attribution 4.0 International 
# License (https://creativecommons.org/licenses/by/4.0/)

# Imports
library(leaflet)
library(htmltools)

# Lecture des données d'entrée
hmon1336_url = "https://gitlab.com/tekipaki-blog/cartographie_linguistique_python/-/raw/master/hmon1336.tsv"
hmon1336 = read.csv(hmon1336_url, sep = '\t')
View(hmon1336)


### CARTE BASIQUE

# Déclaration de la carte
carte_facile = leaflet()

# Ajout du fond de carte
carte_facile = addTiles(carte_facile) # Valeur par défaut = OpenStreetMap

# Ajout des marqueurs
carte_facile = addCircleMarkers(carte_facile,
                      lng = hmon1336$Longitude,
                      lat = hmon1336$Latitude,
                      popup = hmon1336$Name)

# Visualisation de la carte
carte_facile


### CARTE AVEC PERSONNALISATION DES MARQUEURS ET CLUSTERS

# Déclaration de la carte
hmon1336_carte = leaflet(options = leafletOptions(minZoom = 2, maxZoom = 16))

# Choix du fond de carte
hmon1336_carte = addProviderTiles(hmon1336_carte,
                                   provider = providers$Wikimedia)

# Personnalisation des marqueurs avec icônes Ion icons
# Voir : https://rstudio.github.io/leaflet/markers.html
icons = awesomeIcons(
  icon = 'chatbubbles',
  iconColor = 'black',
  library = 'ion'
)

# Ajout des marqueurs à la carte, avec rassemblement en clusters
hmon1336_carte = addAwesomeMarkers(hmon1336_carte,
                                   hmon1336$Longitude,
                                   hmon1336$Latitude,
                                   popup = paste(sep = '<br/>',
                                                 htmlEscape(hmon1336$Name),
                                                 paste('<a href=',
                                                       paste('"',
                                                             'https://glottolog.org/resource/languoid/id/',
                                                             htmlEscape(hmon1336$ID),
                                                             '"',
                                                             sep = ''),
                                                       '>',
                                                       htmlEscape(hmon1336$ID),
                                                       '</a>')),
                                   icon = icons,
                                   clusterOptions = markerClusterOptions())

# Visualisation de la carte
hmon1336_carte

# Export HTML ou PNG
library(mapview)
mapshot(hmon1336_carte, url = "hmon1336_carte.html")
mapshot(hmon1336_carte, file = "hmon1336_carte.png")
