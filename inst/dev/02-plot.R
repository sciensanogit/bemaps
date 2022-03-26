library(sp)
library(sf)
library(leaflet)
library(bemaps)
library(tidyverse)

# ## Get taxes / statistical sector
# tempfile <- tempfile()
# download.file("http://statbel.fgov.be/nl/binaries/TF_PSNL_INC_TAX_SECTOR_tcm325-278417.zip", tempfile)
# unzip(tempfile, list = TRUE)
# taxes <- read.table(unz(tempfile, filename = "TF_PSNL_INC_TAX_SECTOR.txt"), sep="|", header = TRUE,
#                     encoding = "UTF-8", stringsAsFactors = FALSE, quote = "", na.strings = c("", "C"))
# colnames(taxes)[1] <- "CD_YEAR"
#
# ## Get taxes in last year
# taxes <- subset(taxes, CD_YEAR == max(taxes$CD_YEAR))
# taxes <- taxes[, c("CD_YEAR", "CD_REFNIS_SECTOR",
#                    "MS_NBR_NON_ZERO_INC", "MS_TOT_NET_TAXABLE_INC", "MS_AVG_TOT_NET_TAXABLE_INC",
#                    "MS_MEDIAN_NET_TAXABLE_INC", "MS_INT_QUART_DIFF", "MS_INT_QUART_COEFF",
#                    "MS_INT_QUART_ASSYM")]
#
# ## Join taxes with the map
# data(BE_ADMIN_SECTORS, package = "BelgiumMaps.StatBel")
# data(BE_ADMIN_DISTRICT, package = "BelgiumMaps.StatBel")
# data(BE_ADMIN_MUNTY, package = "BelgiumMaps.StatBel")
# mymap <- merge(BE_ADMIN_SECTORS, taxes, by = "CD_REFNIS_SECTOR", all.x=TRUE, all.y=FALSE)
# mymap <- subset(mymap, TX_RGN_DESCR_NL %in% "Brussels Hoofdstedelijk Gewest")
#
# ## Visualise the data
# pal <- colorBin(palette = rev(heat.colors(11)), domain = mymap$MS_AVG_TOT_NET_TAXABLE_INC,
#                 bins = c(0, round(quantile(mymap$MS_AVG_TOT_NET_TAXABLE_INC, na.rm=TRUE, probs = seq(0.1, 0.9, by = 0.1)), 0), +Inf),
#                 na.color = "#cecece")
# m <- leaflet(mymap) %>%
#   addTiles() %>%
#   addLegend(title = "Net Taxable Income (EURO)", pal = pal, values = ~MS_AVG_TOT_NET_TAXABLE_INC, position = "bottomleft", na.label = "Missing") %>%
#   addPolygons(color = ~pal(MS_AVG_TOT_NET_TAXABLE_INC), stroke = FALSE, smoothFactor = 0.2, fillOpacity = 0.85,
#               popup = sprintf("%s: %s<br>%s: %s<br><br>%s €: Average net taxable income<br>%s €: Median net taxable income<br>%s declarations",
#                               mymap$TX_SECTOR_DESCR_NL, mymap$TX_MUNTY_DESCR_NL,
#                               mymap$TX_SECTOR_DESCR_FR, mymap$TX_MUNTY_DESCR_FR,
#                               mymap$MS_AVG_TOT_NET_TAXABLE_INC, mymap$MS_MEDIAN_NET_TAXABLE_INC,
#                               mymap$MS_NBR_NON_ZERO_INC))
# #m <- addPolylines(m, data = BE_ADMIN_DISTRICT, weight = 1.5, color = "black")
# m <- addPolylines(m, data = subset(BE_ADMIN_MUNTY, TX_RGN_DESCR_NL %in% "Brussels Hoofdstedelijk Gewest"), weight = 1.5, color = "black")
# m
#
# ## Save as HTML
# library(htmlwidgets)
# m$sizingPolicy$defaultHeight <- "100%"
# m$sizingPolicy$defaultWidth <- "100%"
# saveWidget(m, file="be_net_taxable_income_sector.html", selfcontained = FALSE)





data(BE_NIS_POSTAL)















## PLOT THE MAPS based on fake data
## .. BELGIUM
pal <- colorNumeric(
  palette = "Blues",
  domain = BE_ADMIN_BEL$fkdata)

leaflet(BE_ADMIN_BEL) %>%
  addTiles() %>%
  addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
              color = ~pal(fkdata),
              label = ~paste0(fkdata))
## .. REGION
pal <- colorNumeric(
  palette = "Blues",
  domain = BE_ADMIN_RGN$fkdata)

leaflet(BE_ADMIN_RGN) %>%
  addTiles() %>%
  addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
              color = ~pal(fkdata),
              label = ~paste0(fkdata))
## .. PROVINCES
pal <- colorNumeric(
  palette = "Blues",
  domain = BE_ADMIN_PROV$fkdata)

leaflet(BE_ADMIN_PROV) %>%
  addTiles() %>%
  addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
              color = ~pal(fkdata),
              label = ~paste0(fkdata))
## .. DISTRICT
pal <- colorNumeric(
  palette = "Blues",
  domain = BE_ADMIN_ARRD$fkdata)

leaflet(BE_ADMIN_ARRD) %>%
  addTiles() %>%
  addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
              color = ~pal(fkdata),
              label = ~paste0(fkdata))
## .. MUNTY
pal <- colorNumeric(
  palette = "Blues",
  domain = BE_ADMIN_MUNTY$fkdata)

leaflet(BE_ADMIN_MUNTY) %>%
  addTiles() %>%
  addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
              color = ~pal(fkdata),
              label = ~paste0(fkdata))
## .. SECTOR
pal <- colorNumeric(
  palette = "Blues",
  domain = BE_ADMIN_SECTORS$fkdata)

leaflet(BE_ADMIN_SECTORS) %>%
  addTiles() %>%
  addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
              color = ~pal(fkdata),
              label = ~paste0(fkdata))


## FILTER + PLOT THE MAPS
## .. Ghent
BE_ADMIN_SECTORS_GENT <-
  BE_ADMIN_SECTORS %>%
  filter(BE_ADMIN_SECTORS$TX_MUNTY_DESCR_NL == "Gent")

## .. .. plot
pal <- colorNumeric(
  palette = "Blues",
  domain = BE_ADMIN_SECTORS_GENT$fkdata)

leaflet(BE_ADMIN_SECTORS_GENT) %>%
  addTiles() %>%
  addPolygons(color = "#444444",  dashArray = "1", smoothFactor = 0.2, fillOpacity = 0.1,
              fillColor = ~pal(fkdata),
              weight = 1,
              label = ~paste0(TX_SECTOR_DESCR_NL, ":", fkdata),
              highlightOptions = highlightOptions(color = "white", weight = 1,
                                                  bringToFront = TRUE))
