library(devtools)
install_github('loicdtx/bfastSpatial')
# load the package
library(bfastSpatial)

##work in progress
##copied from what worked with Busselton Swamp trial
##this not working yet


## Directories
imdir <- "E:\\DOCUMENTATION\\BART\\kimberley_cdr_imagery"
wkdir <- "E:\\DOCUMENTATION\\BART\\R\\RDEV\\Kimberley_bfastSpatial"
ndvi <- "E:\\DOCUMENTATION\\BART\\R\\RDEV\\Kimberley_bfastSpatial_output\\ndvi"
graphs <- "E:\\DOCUMENTATION\\BART\\R\\RDEV\\Kimberley_bfastSpatial_output\\graphs"

## aoi - extent required for clip and to standardise all extents for stack
shp <- "Kimberley_trial_extent"
aoi <- readOGR(dsn = wkdir, layer = shp)

## Testing and projecting the extent

# process 1 full scene to obtain CRS
list <- list.files(imdir, full.names = TRUE)
processLandsat(x=list[1], vi='ndvi', outdir=ndvi, srdir=ndvi, delete=TRUE,
               mask='fmask', keep=0, overwrite=TRUE)
# Get CRS of scene ndvi to transform extent
list <- list.files(ndvi, pattern=glob2rx('*ndvi*'), full.names=TRUE)
crs(raster(list[1]))
aoiT <- spTransform(aoi, crs(raster(list[1])))

# test now with extent arg
processLandsat(x=list[1], vi='ndvi', outdir=ndvi, srdir=ndvi, delete=TRUE,
               mask='fmask', e = extent(aoiT), keep=0, overwrite=TRUE)
list <- list.files(ndvi, pattern=glob2rx('*.grd'), full.names=TRUE)
plot(r <- raster(list[1]))



# Process each scene date with timer
start <- Sys.time()
processLandsatBatch(x=imdir, pattern=glob2rx('*.tar.gz'), outdir=ndvi, srdir=ndvi, 
                    e = extent(aoiT), delete=TRUE, vi='ndvi', mask='fmask', keep=0, 
                    overwrite=TRUE)
end <- Sys.time()
total <- end - start
total

# Create stack folder
stf <- file.path(dirname(imdir), 'stack')
dir.create(stf, showWarnings=FALSE)

# Data munging to create decent stack name
grlist <- list.files(path = ndvi, pattern = glob2rx("*.grd"))
shgrlist <- substr(grlist, 6, 21)
info <- getSceneinfo(shgrlist)
info <- dplyr::arrange(info, date)
sdate <- dplyr::first(info$date)
fdate <- dplyr::last(info$date)
sname <- paste0(info$path[1], info$row[1], "_", sdate, "_", fdate, "_", 
                "stack.grd")
stackName <- file.path(stf, sname)

# Make timestack raster brick
list <- list.files(path = ndvi, pattern = glob2rx('*.grd'))
setwd(ndvi)
timeStack(x=list, filename=stackName, datatype='INT2S', overwrite=TRUE)

#read it back
kimstack <- brick(stackName)
                    

# Some mucking around for interesting info

# scenes in stack
names(kimstack)
# scenes and scene info
stackinfo <- getSceneinfo(names(kimstack))
# number of observations per pixel
obs <- countObs(kimstack)
plot(obs)
summary(obs)

# make a histogram of scenes per year
stackinfo$year <- as.numeric(substr(stackinfo$date, 1, 4))
hist(stackinfo$year, breaks=c(1986:2016), main="p109r70: Scenes per Year", 
     xlab="year", ylab="# of scenes")

# some summary type plots
meanVI <- summaryBrick(busstack, fun=mean, na.rm=TRUE) # na.rm=FALSE by default
plot(meanVI)

annualMed <- annualSummary(busstack, fun=median, na.rm=TRUE)
plot(annualMed)


## By Pixel stats

# get centroid of plots and plot names
pts <- readOGR(dsn = wkdir, layer = "GIS_Investigation_sites_ver1_pt_mga50")
pts@data$Site_Id
rnames <- as.character(pts@data[, "Site_Id"])
rownames(pts@data) <- rnames
namesSHP <- rownames(pts@data)
namesjpeg <- paste0(graphs, "\\", namesSHP, ".jpeg")

# get 1 raster layer to query for cell id's
layer <- raster(busstack, 1)

cellvector <- cellFromXY(layer, pts@coords)

bfm <- bfmPixel(busstack, cell=cellvector[1], start = c(2007, 1))
plot(bfm$bfm, main = namesSHP[1], ylab = "NDVI * 10000", xlab = "Year")



setwd(wkdir)
for(i in 1:length(namesSHP)){
  bfm.i <- bfmPixel(busstack, cell = cellvector[i], start = c(2007, 1))
  jpeg(filename = namesjpeg[i], width = 842, height = 870)
  plot(bfm.i$bfm, main = namesSHP[i], ylab = "NDVI * 10000", xlab = "Year")
  dev.off()
}



plot(layer)
plot(pts, add = TRUE, lwd = 2, border = "green" )




spatialTime <- system.time(bfmSp <- bfmSpatial(busstack, start=c(2007, 1), order=1))
plot(bfmSp, 1)
writeRaster(bfmSp, filename = "bfm_busswamp_2007", format = "HFA", 
            datatype = 'FLT8S',
            bylayer = TRUE, suffix = c("breakpoint", "magnitude", "error"))

