#' @name BE_ADMIN
#' @aliases BE_ADMIN_SECTORS BE_ADMIN_MUNTY BE_ADMIN_ARRD BE_ADMIN_PROV BE_ADMIN_RGN BE_ADMIN_BEL
#' @title Maps with administrative boundaries of Belgium extracted from Open Data at Statistics Belgium.
#' @description Maps with administrative boundaries of Belgium extracted from Open Data at Statistics Belgium. Namely:
#'
#' \itemize{
#' \item BE_ADMIN_SECTORS: sf data.frame with polygons and data at the level of the statistical sector
#' \item BE_ADMIN_MUNTY: sf data.frame with polygons and data at the level of the municipality
#' \item BE_ADMIN_ARRD: sf data.frame with polygons and data at the level of the district
#' \item BE_ADMIN_PROV: sf data.frame with polygons and data at the level of the province
#' \item BE_ADMIN_RGN: sf data.frame with polygons and data at the level of the region
#' \item BE_ADMIN_BEL: sf data.frame with polygons and data at the level of the whole of Belgium
#' }
#' The original data from Statistics Belgium contains the areas at the level of the statistical sectors. These were aggregated by using the
#' definition set forth on 01/01/2021 as available in the CS01012021 field.
#'
#' Mark that Brussels is not considered as a province but for convenience, the province level of Brussels is set to the region information.
#' More information about the data can be found in the inst/documentation folder.
#'
#' The data contains the following elements which were available at different levels.
#' \itemize{
#' \item CD_SECTOR_REFNIS: NIS-code for Statistical Sector
#' \item TX_SECTOR_DESCR_NL: name of the statistical sector (dutch)
#' \item TX_SECTOR_DESCR_FR: name of the statistical sector (french)
#' \item TX_SECTOR_DESCR_DE: name of the statistical sector (german)
#' \item CD_MUNTY_REFNIS: NIS-code for Municipality
#' \item TX_MUNTY_DESCR_NL: name of the municipality (dutch)
#' \item TX_MUNTY_DESCR_FR: name of the municipality (french)
#' \item TX_MUNTY_DESCR_DE: name of the municipality (german)
#' \item CD_ARRD_REFNIS: NIS-code for District (Arrondissement)
#' \item TX_ARRD_DESCR_NL: name of the district (dutch)
#' \item TX_ARRD_DESCR_FR: name of the district (french)
#' \item TX_ARRD_DESCR_DE: name of the district (german)
#' \item CD_PROV_REFNIS: NIS-code for Province
#' \item TX_PROV_DESCR_NL: name of the province (dutch)
#' \item TX_PROV_DESCR_FR: name of the province (french)
#' \item TX_PROV_DESCR_DE: name of the province (german)
#' \item CD_RGN_REFNIS: NIS-code for Region
#' \item TX_RGN_DESCR_NL: name of the province (dutch)
#' \item TX_RGN_DESCR_FR: name of the province (french)
#' \item TX_RGN_DESCR_DE: name of the province (german)
#' \item nuts0: Eurostat NUTS code level 0
#' \item nuts1: Eurostat NUTS code level 1
#' \item nuts2: Eurostat NUTS code level 2
#' \item nuts3: Eurostat NUTS code level 3
#' \item SURFACE.GIS.h: surface of the statistical sector (hectare)
#' \item SURFACE.GIS.km2: surface of the statistical sector (square km)
#' \item PERI.GIS.h: perimeter of the statistical sector
#' \item PERI.GIS.km: perimeter of the statistical sector (km)
#' \item fkdata: fake data to plot the maps
#' }
#'
#' @docType data
#' @source \url{https://statbel.fgov.be/en/open-data/statistical-sectors-2021}
#' @references \url{http://statbel.fgov.be/nl/statistieken/opendata/datasets/tools}
#' @examples
#' \dontrun{
#' data(BE_ADMIN_SECTORS)
#' class(BE_ADMIN_SECTORS)
#' str(BE_ADMIN_SECTORS)
#'
#' library(sp)
#' plot(subset(BE_ADMIN_SECTORS, TX_RGN_DESCR_NL %in% "Brussels Hoofdstedelijk Gewest"))
#' data(BE_ADMIN_MUNTY)
#' data(BE_ADMIN_ARRD)
#' data(BE_ADMIN_PROV)
#' data(BE_ADMIN_RRGN)
#' data(BE_ADMIN_BEL)
#' plot(BE_ADMIN_MUNTY)
#' plot(BE_ADMIN_RGN)
#' plot(BE_ADMIN_PROV)
#' }
NULL


#' @name BE_NIS_POSTAL
#' @title Link between postal code and NIS code at municipality level in Belgium.
#' @description Link between postal code and NIS code at municipality level in Belgium containing:
#' \itemize{
#' \item POSTAL_CODE: Postal code
#' \item NIS_CODE: NIS code
#' }
#'
#' @docType data
#' @source \url{https://vlaamseoverheid.atlassian.net/wiki/spaces/MG/pages/1042712614/Codetabellen}
#' @references \url{https://vlaamseoverheid.atlassian.net/wiki/spaces/MG/pages/1042712614/Codetabellen}
#' @examples
#' data(BE_NIS_POSTAL)
#' str(BE_NIS_POSTAL)
NULL


