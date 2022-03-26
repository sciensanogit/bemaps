## Files
## .. Statistical sectors: https://statbel.fgov.be/en/open-data/statistical-sectors-2021
## .. NIS - postcode: https://vlaamseoverheid.atlassian.net/wiki/spaces/MG/pages/1042712614/Codetabellen

## packages necessary to create shapefile
library(rgdal)
library(sp)
library(sf)
library(rgeos)
library(tmap)
library(utils)
library(data.table)
library(maptools)
library(tools)
library(leaflet)
library(readr)
library(rmapshaper)
library(dplyr)
library(lubridate)

## provide url for download shapefile
url_shape <- "https://statbel.fgov.be/sites/default/files/files/opendata/Statistische%20sectoren/sh_statbel_statistical_sectors_31370_20210101.shp.zip"
url_postal_shape <- "https://bgu.bpost.be/assets/9738c7c0-5255-11ea-8895-34e12d0f0423_x-shapefile_31370.zip"

## download shapefile
download.file(url = url_shape, destfile = file.path(getwd(), "inst", "extdata", "shapefile.zip"))
download.file(url = url_postal_shape, destfile = file.path(getwd(), "inst", "extdata", "shapepostal.zip"))

## unzip shapefile
unzip(file.path(getwd(), "inst", "extdata", "shapefile.zip"), list = TRUE)
unzip(file.path(getwd(), "inst", "extdata", "shapefile.zip"),
      list = FALSE, exdir = file_path_sans_ext(
        file.path(getwd(), "inst", "extdata", "shapefile.zip")))
unzip(file.path(getwd(), "inst", "extdata", "shapepostal.zip"), list = TRUE)
unzip(file.path(getwd(), "inst", "extdata", "shapepostal.zip"),
      list = FALSE, exdir = file_path_sans_ext(
        file.path(getwd(), "inst", "extdata", "shapepostal.zip")))

## settings
settings <- list()
settings$hierarchy <- list()
settings$hierarchy$municipalities <- file.path(getwd(), "inst", "extdata", "TF_CAR_HHTYPE_MUNTY.txt")
settings$hierarchy$nis.sectors <- file.path(getwd(), "inst", "extdata", "TF_CAR_HH_SECTOR.txt")
settings$hierarchy$nis.postal <- file.path(getwd(), "inst", "extdata", "NIS_ZIP_MNTY.csv")
settings$hierarchy$refnis <- file.path(getwd(), "inst", "extdata", "TU_COM_REFNIS.txt")
settings$nis.sectors <- file.path(getwd(), "inst", "extdata", "shapefile")
settings$postal.sectors <- file.path(getwd(), "inst", "extdata", "shapepostal")

## .. add unzipped files
settings$nis.sectors.unz <- list.files(settings$nis.sectors, recursive = TRUE,
                                   pattern = ".shp", full.names = TRUE)
settings$postal.sectors.unz <- list.files(settings$postal.sectors, recursive = TRUE,
                                       pattern = ".shp", full.names = TRUE)

## load data
data <- list()
data$SECTOR <- read_csv2(settings$hierarchy$nis.sectors)
data$MUNY <- read_csv2(settings$hierarchy$municipalities)
data$POSTAL <- read_csv2(settings$hierarchy$nis.postal, comment = "#")
data$REFNIS <- read.table(settings$hierarchy$refnis, sep="|", header = TRUE,
                          encoding = "UTF-8", stringsAsFactors = FALSE, quote = "")

## Aggregate on level
## .. date
data$REFNIS$DT_VLDT_START <- as.Date(data$REFNIS$DT_VLDT_START, "%d/%m/%Y")
data$REFNIS$DT_VLDT_END <- as.Date(data$REFNIS$DT_VLDT_END, "%d/%m/%Y")
data$REFNIS$DT <- lubridate::interval(start = data$REFNIS$DT_VLDT_START,
                                      end = data$REFNIS$DT_VLDT_END)

# for (i in 2010:2022){
#   dt_ref <- lubridate::dmy(paste0("0101",i))
#   tmp <- subset(data$REFNIS, dt_ref %within% data$REFNIS$DT)
#
#   subset
#
# }

## load shapefile at statistical sector level
BE_ADMIN_SECTORS <- sf::read_sf(settings$nis.sectors.unz)
BE_ADMIN_SECTORS <- sf::st_zm(BE_ADMIN_SECTORS)
BE_ADMIN_SECTORS <- sf::as_Spatial(BE_ADMIN_SECTORS)
#BE_ADMIN_SECTORS <- rgdal::readOGR(settings$nis.sectors.unz, stringsAsFactors = FALSE, encoding = "UTF-8")

## Load shapefile at postal code level
BE_POSTAL <- sf::read_sf(settings$postal.sectors.unz)
BE_POSTAL <- sf::st_zm(BE_POSTAL)
BE_POSTAL <- sf::as_Spatial(BE_POSTAL)

## convert sp to make compatible with leaflet
BE_ADMIN_SECTORS <- sp::spTransform(x=BE_ADMIN_SECTORS, CRSobj = CRS("+proj=longlat +datum=WGS84"))

## aggregate on multiple levels
## .. SECTOR
## .. .. select only necessary variables
BE_ADMIN_SECTORS <- BE_ADMIN_SECTORS[c("CS01012021", "T_SEC_NL", "T_SEC_FR", "T_SEC_DE",
                                       "CNIS5_2021", "T_MUN_NL", "T_MUN_FR", "T_MUN_DE",
                                       "CNIS_ARRD_", "T_ARRD_NL", "T_ARRD_FR", "T_ARRD_DE",
                                       "CNIS_PROVI", "T_PROVI_NL", "T_PROVI_FR", "T_PROVI_DE",
                                       "CNIS_REGIO", "T_REGIO_NL", "T_REGIO_FR", "T_REGIO_DE",
                                       "NUTS1_2021", "NUTS2_2021", "NUTS3_2021", "M_AREA_HA",
                                       "M_PERI_M")]

## .. .. rename variables
BE_ADMIN_SECTORS@data <-
  rename(
    BE_ADMIN_SECTORS@data,
    CD_SECTOR_REFNIS = CS01012021,
    TX_SECTOR_DESCR_NL = T_SEC_NL,
    TX_SECTOR_DESCR_FR = T_SEC_FR,
    TX_SECTOR_DESCR_DE = T_SEC_DE,
    CD_MUNTY_REFNIS = CNIS5_2021,
    TX_MUNTY_DESCR_NL = T_MUN_NL,
    TX_MUNTY_DESCR_FR = T_MUN_FR,
    TX_MUNTY_DESCR_DE = T_MUN_DE,
    CD_ARRD_REFNIS = CNIS_ARRD_,
    TX_ARRD_DESCR_NL = T_ARRD_NL,
    TX_ARRD_DESCR_FR = T_ARRD_FR,
    TX_ARRD_DESCR_DE = T_ARRD_DE,
    CD_PROV_REFNIS = CNIS_PROVI,
    TX_PROV_DESCR_NL = T_PROVI_NL,
    TX_PROV_DESCR_FR = T_PROVI_FR,
    TX_PROV_DESCR_DE = T_PROVI_DE,
    CD_RGN_REFNIS = CNIS_REGIO,
    TX_RGN_DESCR_NL = T_REGIO_NL,
    TX_RGN_DESCR_FR = T_REGIO_FR,
    TX_RGN_DESCR_DE = T_REGIO_DE,
    nuts1 = NUTS1_2021,
    nuts2 = NUTS2_2021,
    nuts3 = NUTS3_2021,
    SURFACE.GIS.h = M_AREA_HA,
    PERI.GIS.m = M_PERI_M#,
    # SURFACE.GIS.km2 = Shape_Area,
    # SURFACE.CAD.km2 = Shape_Leng
  )

## .. ADD area in km2 and perimetere in km
BE_ADMIN_SECTORS$SURFACE.GIS.km2 <- BE_ADMIN_SECTORS$SURFACE.GIS.h / 100
BE_ADMIN_SECTORS$PERI.GIS.km     <- BE_ADMIN_SECTORS$PERI.GIS.m / 1000

## .. ADD nuts 0
BE_ADMIN_SECTORS@data$nuts0 <-  "BE"

## .. MAKE Brussels Capital Region into province
BE_ADMIN_SECTORS$TX_PROV_DESCR_NL <- ifelse(is.na(BE_ADMIN_SECTORS$TX_PROV_DESCR_NL), BE_ADMIN_SECTORS$TX_RGN_DESCR_NL, BE_ADMIN_SECTORS$TX_PROV_DESCR_NL)
BE_ADMIN_SECTORS$TX_PROV_DESCR_FR <- ifelse(is.na(BE_ADMIN_SECTORS$TX_PROV_DESCR_FR), BE_ADMIN_SECTORS$TX_RGN_DESCR_FR, BE_ADMIN_SECTORS$TX_PROV_DESCR_FR)
BE_ADMIN_SECTORS$TX_PROV_DESCR_DE <- ifelse(is.na(BE_ADMIN_SECTORS$TX_PROV_DESCR_DE), BE_ADMIN_SECTORS$TX_RGN_DESCR_DE, BE_ADMIN_SECTORS$TX_PROV_DESCR_DE)
BE_ADMIN_SECTORS$CD_PROV_REFNIS   <- ifelse(is.na(BE_ADMIN_SECTORS$CD_PROV_REFNIS), BE_ADMIN_SECTORS$CD_RGN_REFNIS, BE_ADMIN_SECTORS$CD_PROV_REFNIS)

## .. .. plot
#plot(BE_ADMIN_SECTORS)

## .. MUNTY
x <- split(BE_ADMIN_SECTORS, BE_ADMIN_SECTORS$CD_MUNTY_REFNIS)
x <- lapply(x, FUN=function(data){
  SpatialPolygonsDataFrame(gUnaryUnion(spgeom = data),
                           data = data.frame(CD_MUNTY_REFNIS = unique(data$CD_MUNTY_REFNIS),
                                             TX_MUNTY_DESCR_NL = unique(data$TX_MUNTY_DESCR_NL),
                                             TX_MUNTY_DESCR_FR = unique(data$TX_MUNTY_DESCR_FR),
                                             TX_MUNTY_DESCR_DE = unique(data$TX_MUNTY_DESCR_DE),
                                             CD_ARRD_REFNIS = unique(data$CD_ARRD_REFNIS),
                                             TX_ARRD_DESCR_NL = unique(data$TX_ARRD_DESCR_NL),
                                             TX_ARRD_DESCR_FR = unique(data$TX_ARRD_DESCR_FR),
                                             TX_ARRD_DESCR_DE = unique(data$TX_ARRD_DESCR_DE),
                                             CD_PROV_REFNIS = unique(data$CD_PROV_REFNIS),
                                             TX_PROV_DESCR_NL = unique(data$TX_PROV_DESCR_NL),
                                             TX_PROV_DESCR_FR = unique(data$TX_PROV_DESCR_FR),
                                             CD_RGN_REFNIS = unique(data$CD_RGN_REFNIS),
                                             TX_RGN_DESCR_NL = unique(data$TX_RGN_DESCR_NL),
                                             TX_RGN_DESCR_FR = unique(data$TX_RGN_DESCR_FR),
                                             TX_RGN_DESCR_DE = unique(data$TX_RGN_DESCR_DE),
                                             nuts0 = unique(data$nuts0),
                                             nuts1 = unique(data$nuts1),
                                             nuts2 = unique(data$nuts2),
                                             nuts3 = unique(data$nuts3),
                                             SURFACE.GIS.km2 = sum(data$SURFACE.GIS.km2),
                                             PERI.GIS.km = sum(data$PERI.GIS.km),
                                             stringsAsFactors=FALSE))
})
BE_ADMIN_MUNTY <- do.call(rbind, x)
#plot(BE_ADMIN_MUNTY)

## .. ARRD
x <- split(BE_ADMIN_SECTORS, BE_ADMIN_SECTORS$CD_ARRD_REFNIS)
x <- lapply(x, FUN=function(data){
  SpatialPolygonsDataFrame(gUnaryUnion(spgeom = data),
                           data = data.frame(CD_ARRD_REFNIS = unique(data$CD_ARRD_REFNIS),
                                             TX_ARRD_DESCR_NL = unique(data$TX_ARRD_DESCR_NL),
                                             TX_ARRD_DESCR_FR = unique(data$TX_ARRD_DESCR_FR),
                                             TX_ARRD_DESCR_DE = unique(data$TX_ARRD_DESCR_DE),
                                             CD_PROV_REFNIS = unique(data$CD_PROV_REFNIS),
                                             TX_PROV_DESCR_NL = unique(data$TX_PROV_DESCR_NL),
                                             TX_PROV_DESCR_FR = unique(data$TX_PROV_DESCR_FR),
                                             CD_RGN_REFNIS = unique(data$CD_RGN_REFNIS),
                                             TX_RGN_DESCR_NL = unique(data$TX_RGN_DESCR_NL),
                                             TX_RGN_DESCR_FR = unique(data$TX_RGN_DESCR_FR),
                                             TX_RGN_DESCR_DE = unique(data$TX_RGN_DESCR_DE),
                                             nuts0 = unique(data$nuts0),
                                             nuts1 = unique(data$nuts1),
                                             nuts2 = unique(data$nuts2),
                                             #  nuts3 = unique(data$nuts3),
                                             SURFACE.GIS.km2 = sum(data$SURFACE.GIS.km2),
                                             PERI.GIS.km = sum(data$PERI.GIS.km),
                                             stringsAsFactors=FALSE))
})
BE_ADMIN_ARRD <- do.call(rbind, x)
#plot(BE_ADMIN_ARRD)

## .. PROV
x <- split(BE_ADMIN_SECTORS, BE_ADMIN_SECTORS$CD_PROV_REFNIS)
x <- lapply(x, FUN=function(data){
  SpatialPolygonsDataFrame(gUnaryUnion(spgeom = data),
                           data = data.frame(CD_PROV_REFNIS = unique(data$CD_PROV_REFNIS),
                                             TX_PROV_DESCR_NL = unique(data$TX_PROV_DESCR_NL),
                                             TX_PROV_DESCR_FR = unique(data$TX_PROV_DESCR_FR),
                                             CD_RGN_REFNIS = unique(data$CD_RGN_REFNIS),
                                             TX_RGN_DESCR_NL = unique(data$TX_RGN_DESCR_NL),
                                             TX_RGN_DESCR_FR = unique(data$TX_RGN_DESCR_FR),
                                             TX_RGN_DESCR_DE = unique(data$TX_RGN_DESCR_DE),
                                             nuts0 = unique(data$nuts0),
                                             nuts1 = unique(data$nuts1),
                                             nuts2 = unique(data$nuts2),
                                             # nuts3 = unique(data$nuts3),
                                             SURFACE.GIS.km2 = sum(data$SURFACE.GIS.km2),
                                             PERI.GIS.km = sum(data$PERI.GIS.km),
                                             stringsAsFactors=FALSE))
})
BE_ADMIN_PROV <- do.call(rbind, x)
#plot(BE_ADMIN_PROV)

## .. RGN
x <- split(BE_ADMIN_SECTORS, BE_ADMIN_SECTORS$CD_RGN_REFNIS)
x <- lapply(x, FUN=function(data){
  SpatialPolygonsDataFrame(gUnaryUnion(spgeom = data),
                           data = data.frame(CD_RGN_REFNIS = unique(data$CD_RGN_REFNIS),
                                             TX_RGN_DESCR_NL = unique(data$TX_RGN_DESCR_NL),
                                             TX_RGN_DESCR_FR = unique(data$TX_RGN_DESCR_FR),
                                             TX_RGN_DESCR_DE = unique(data$TX_RGN_DESCR_DE),
                                             nuts0 = unique(data$nuts0),
                                             nuts1 = unique(data$nuts1),
                                             # nuts2 = unique(data$nuts2),
                                             # nuts3 = unique(data$nuts3),
                                             SURFACE.GIS.h = sum(data$SURFACE.GIS.h),
                                             SURFACE.GIS.km2 = sum(data$SURFACE.GIS.km2),
                                             stringsAsFactors=FALSE))
})
BE_ADMIN_RGN <- do.call(rbind, x)
#plot(BE_ADMIN_RGN)

## .. BELGIUM
BE_ADMIN_BEL <-
  SpatialPolygonsDataFrame(gUnaryUnion(spgeom = BE_ADMIN_SECTORS),
                           data = data.frame(nuts0 = unique(BE_ADMIN_SECTORS$nuts0),
                                             # nuts1 = unique(data$nuts1),
                                             # nuts2 = unique(data$nuts2),
                                             # nuts3 = unique(data$nuts3),
                                             SURFACE.GIS.km2 = sum(data$SURFACE.GIS.km2),
                                             PERI.GIS.km = sum(data$PERI.GIS.km),
                                             stringsAsFactors=FALSE))
#plot(BE_ADMIN_BEL)

## SIMPLIFY
BE_ADMIN_SECTORS_sf <- st_as_sf(BE_ADMIN_SECTORS)
BE_ADMIN_SECTORS <- ms_simplify(BE_ADMIN_SECTORS_sf)
BE_ADMIN_MUNTY_sf <- st_as_sf(BE_ADMIN_MUNTY)
BE_ADMIN_MUNTY <- ms_simplify(BE_ADMIN_MUNTY_sf)
BE_ADMIN_ARRD_sf <- st_as_sf(BE_ADMIN_ARRD)
BE_ADMIN_ARRD <- ms_simplify(BE_ADMIN_ARRD_sf)
BE_ADMIN_PROV_sf <- st_as_sf(BE_ADMIN_PROV)
BE_ADMIN_PROV <- ms_simplify(BE_ADMIN_PROV_sf)
BE_ADMIN_RGN_sf <- st_as_sf(BE_ADMIN_RGN)
BE_ADMIN_RGN <- ms_simplify(BE_ADMIN_RGN_sf)
BE_ADMIN_BEL_sf <- st_as_sf(BE_ADMIN_BEL)
BE_ADMIN_BEL <- ms_simplify(BE_ADMIN_BEL_sf)

## .. FAKE DATA FX
fake_data <- function(x){
  rpois(nrow(x), 10)
}

## .. ADD FAKE DATA
BE_ADMIN_BEL$fkdata <- fake_data(BE_ADMIN_BEL)
BE_ADMIN_RGN$fkdata <- fake_data(BE_ADMIN_RGN)
BE_ADMIN_ARRD$fkdata <- fake_data(BE_ADMIN_ARRD)
BE_ADMIN_PROV$fkdata <- fake_data(BE_ADMIN_PROV)
BE_ADMIN_MUNTY$fkdata <- fake_data(BE_ADMIN_MUNTY)
BE_ADMIN_SECTORS$fkdata <- fake_data(BE_ADMIN_SECTORS)

## POSTAL CODE vs NIS
BE_NIS_POSTAL <- data$POSTAL[c("POSTAL_CODE", "NIS_CODE", "DESC_NL", "DESC_FR", "DESC_DE")]
BE_NIS_POSTAL$NIS_CODE <- as.character(BE_NIS_POSTAL$NIS_CODE)

## ADD OTHER LEVELS: will have one row for each postal code, duplicating shapes, not all
BE_NIS_POSTAL <- merge(BE_NIS_POSTAL, select(as.data.frame(BE_ADMIN_MUNTY), -fkdata, -geometry), by.x = "NIS_CODE", by.y = "CD_MUNTY_REFNIS",
                       all.x = TRUE, all.y = TRUE)

## SAVE the data using the package usethis
usethis::use_data(BE_ADMIN_BEL, BE_ADMIN_RGN, BE_ADMIN_PROV, BE_ADMIN_ARRD,
                  BE_ADMIN_MUNTY, BE_ADMIN_SECTORS, BE_NIS_POSTAL, overwrite = TRUE,
                  compress = "xz", version = 2)

## REMOVE the large shapefiles
file.remove(file.path(getwd(), "inst", "extdata", "shapefile.zip"))
unlink(file.path(getwd(), "inst", "extdata", "shapefile"), recursive = TRUE)
