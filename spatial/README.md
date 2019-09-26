# Basics of spatial data analysis

Authors: Jakub Nowosad (Adam Mickiewicz University, Poznan)

### Description

R has a long history of supporting spatial data analysis, including spatial data downloading, preprocessing, visualizing, and modeling.
An essential step in this direction was, among other things, the creation of the sp package in 2005 and the raster package in 2010.
Recently, however, some new packages have appeared which have significantly changed the work with spatial data in R; in particular, the sf package, which integrates spatial vector data analysis with the tidyverse.
In tandem such developments, R's spatial ecosystem is maturing and diversifying in multiple areas including data access (e.g., rworldmap, rnaturalearth, cshapes); visualization (e.g., rasterVis, leaflet, mapview, ggmap, ggplot2, cartogram, tmap); and modeling (e.g, spatial components in mlr and INLA).

Such diversity has benefits but can be overwhelming.
This workshop will introduce participants to the spatial data analysis system in R.
The focus will be on *getting started*, with demonstrations of key packages, spatial analysis, and making maps.
Pointers to further materials will ensure that participants know where to get help and how to take confident next steps after the session.

### Requirements

Run the code below in R to install all of the required R packages.

```r
pkgs = c(
  "sf",                
  "raster",            
  "dplyr",            
  "tmap",
  "spData",
  "usethis"
)
to_install = !pkgs %in% installed.packages()
if(any(to_install)) {
  install.packages(pkgs[to_install])
}
```

Afterwards, run the code below (you should see a map as a result):

```r
library(sf)
library(tmap)
library(spData)

tm_shape(nz) +
  tm_borders(col = "red", 
             lwd = 3) +
  tm_scale_bar(breaks = c(0, 100, 200),
               text.size = 1) +
  tm_compass(position = c("LEFT", "center"),
             type = "rose", 
             size = 2) +
  tm_credits(text = "2019") +
  tm_layout(main.title = "My map",
            bg.color = "lightblue",
            inner.margins = c(0, 0, 0, 0))
```

Please see https://datacarpentry.org/geospatial-workshop/setup.html on how to install geospatial library dependencies.

### Bio

Jakub is an assistant professor in the Department of Geoinformation at the Adam Mickiewicz University in Poznan, Poland. His main research is focused on developing and applying spatial methods in order to broaden our understanding of processes and patterns in the environment. He has extensive teaching experience in the fields of spatial analysis, geostatistics, statistics, and machine learning. Jakub is also an active member of the #rspatial community and a co-author of the Geocomputation with R book.
