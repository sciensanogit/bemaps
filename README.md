
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bemaps

*Shapefiles for statistical sectors and municipalities in Belgium*

The statistical sector is the basic territorial unit resulting from the
subdivision of the territory of municipalities by Statbel since 1970 for
the dissemination of its statistics at a finer level than the municipal
level. A statistical sector cannot extend over two municipalities and
any point in the municipal territory is part of one and the same
statistical sector. Over time, the definition of statistical sectors has
been updated, amongst others to take population growth and into account.
There have also been changes to the definitions of municipalities,
including a round of mergers that took place in 2019. To track these
changes, the `bemaps` package provides shapefiles, specified using
[Simple Feature Access](https://r-spatial.github.io/sf/), for
statistical sectors, municipalities, districs, provinces and regions in
Belgium.

## Available shapefiles

<table>
<thead>
<td>
Shapefile
</td>
<td>
Reference period
</td>
<td>
Number of sectors
</td>
<td>
Number of municipalities
</td>
<td>
Number of districs
</td>
<td>
Number of provinces
</td>
<td>
Number of regions
</td>
</thead>
<tr>
<td>
<strong>BE\_ADMIN\_SECTORS</strong>
</td>
<td>
2021-2022
</td>
<td>
19478
</td>
<td>
581
</td>
<td>
43
</td>
<td>
11
</td>
<td>
3
</td>
</tr>
<tr>
<td>
<strong>BE\_ADMIN\_MUNTY</strong>
</td>
<td>
2021-2022
</td>
<td>
\-
</td>
<td>
581
</td>
<td>
43
</td>
<td>
11
</td>
<td>
3
</td>
</tr>
<tr>
<td>
<strong>BE\_ADMIN\_ARRD</strong>
</td>
<td>
2021-2022
</td>
<td>
\-
</td>
<td>
\-
</td>
<td>
43
</td>
<td>
11
</td>
<td>
3
</td>
</tr>
<tr>
<td>
<strong>BE\_ADMIN\_PROV</strong>
</td>
<td>
2021-2022
</td>
<td>
\-
</td>
<td>
\-
</td>
<td>
\-
</td>
<td>
11
</td>
<td>
3
</td>
</tr>
<tr>
<td>
<strong>BE\_ADMIN\_RGN</strong>
</td>
<td>
2021-2022
</td>
<td>
\-
</td>
<td>
\-
</td>
<td>
\-
</td>
<td>
\-
</td>
<td>
3
</td>
</tr>
<tr>
<td>
<strong>BE\_ADMIN\_BEL</strong>
</td>
<td>
2021-2022
</td>
<td>
\-
</td>
<td>
\-
</td>
<td>
\-
</td>
<td>
\-
</td>
<td>
\-
</td>
</tr>
</table>

## Install

To download and install the latest development version from GitHub:

``` r
devtools::install_gitlab("depauwrobby/bemaps")
```

## Data sources

The idea for this package is inspired by the [BelgiumMaps.StatBel
package](https://github.com/bnosac/BelgiumMaps.StatBel), developed by
Jan Wijffels at
[BNOSAC](http://www.bnosac.be/index.php/blog/55-belgiummaps-statbel-r-package-with-administrative-boundaries-of-belgium).

The shapefiles are obtained from the Statbel open data:

-   **sh\_statbel\_statistical\_sectors\_20210101** includes the
    statistical sectors of Belgium on 01/01/2021:
    <https://statbel.fgov.be/en/open-data/statistical-sectors-2021>

More information about statistical sectors is available in the [Statbel
Vademecum](https://statbel.fgov.be/sites/default/files/files/opendata/Statistische%20sectoren/Secteurs%20stat-NL_tcm325-174181.pdf).

The link between postal code (ZIP) and NIS-code is obtained from the
Flanders:

-   **NIS-codes via gemeente-20220303.zip** includes the NIS-code and
    postal code by municipality, and can be used to link both.
