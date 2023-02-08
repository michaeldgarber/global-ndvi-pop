#merge-ndvi-ls
#How can I merge the two now?

#January 26th, 2023
#I'm updating this script so that it merges the following rasters:
# ls_2019 is always the target raster
#NDVI
#GUB (rasterized from vector)
# ecoregion / biome ( rasterized from vector)

# Feb 8, 2023
# Note it would be less repetitive code to begin with global and then filter everything down,
# but beause of how long the global analysis takes to run, I'm going to get everything set up 
# with USA first and then run the global code later.

library(sf)
library(terra)
library(here)
library(tidyverse)
library(mapview)
library(tidyterra)

# Load target raster and other rasters-------
#that which everything will be merged to
setwd(here("data-processed"))
## USA files----
ls_2019_usa_48_wrangle = terra::rast("ls_2019_usa_48_wrangle.tif")
ndvi_2019_usa_48 = terra::rast("ndvi_2019_usa_48.tif")
biomes_14_usa_48_raster_biome_name = terra::rast("biomes_14_usa_48_raster_biome_name.tif")
gub_usa_48_raster_orig_fid = terra::rast("gub_usa_48_raster_orig_fid.tif")
countries_usa_48_raster_name_en = terra::rast("countries_usa_48_raster_name_en.tif")

#checks
res(biomes_14_usa_48_raster_biome_name)
dim(biomes_14_usa_48_raster_biome_name)
dim(ls_2019_usa_48_wrangle)
dim(ndvi_2019_usa_48)
res(ndvi_2019_usa_48)
res(ls_2019_usa_48_wrangle)
res(gub_usa_48_raster_orig_fid)
dim(gub_usa_48_raster_orig_fid)

## Global files-----
#TBD

# USA------
## Use re-sample to make the resolution of the NDVI raster the same as the other.-----
#Note I don't have to do this for the rasterized vectors because they were rasterized
#with respect to ls_2019_usa_48
ndvi_2019_usa_48_resample = resample(
  ndvi_2019_usa_48, #raster to be resampled 
  ls_2019_usa_48_wrangle #target resolution (for resolution)
  )

## Combine them using c()--------
pop_ndvi_gub_biome_usa_48 = c(
  ls_2019_usa_48_wrangle, 
  ndvi_2019_usa_48_resample,
  gub_usa_48_raster_orig_fid, #city boundaries
  biomes_14_usa_48_raster_biome_name, #biomes
  countries_usa_48_raster_name_en #country boundaries
  )

#save
setwd(here("data-processed"))
terra::writeRaster(
  pop_ndvi_gub_biome_usa_48,
  overwrite=TRUE,
  filename = "pop_ndvi_gub_biome_usa_48.tif" 
)


names(pop_ndvi_gub_biome_usa_48)
pop_ndvi_gub_biome_usa_48$ndvi_2019 %>% 
  raster::raster() %>% 
  mapview()
pop_ndvi_gub_biome_usa_48$pop_cat_1_8 %>% 
  raster::raster() %>% 
  mapview()
pop_ndvi_gub_biome_usa_48$ORIG_FID %>% 
  raster::raster() %>% 
  mapview()
pop_ndvi_gub_biome_usa_48$BIOME_NAME %>% 
  raster::raster() %>% 
  mapview()


# Globally-----

