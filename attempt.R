
library(bfastSpatial)


srdir <- dirout <- "H:\\cdr_bulk\\bfmSpatial"

dir.create(dirout, showWarning=FALSE)


list <- list.files(path = 'D:/RDEV2/Kimberley_bfastSpatial/graphs', 
                   full.names = TRUE)

list2 <- list.files(path = 'H:\\cdr_bulk\\kcdr', 
                   full.names = TRUE)


processLandsat(x=list[1], vi='ndvi', outdir=dirout, srdir=srdir, 
               delete=TRUE, mask='fmask', keep=0, overwrite=TRUE)

x=list[1]
ex <- extension(x)
tarlist <- untar(x, list=TRUE)
