
dir2chk <- "W:\\usgs\\109070" # What folder to create the list from
wkdir <- "D:\\RDEV2\\Kimberley_bfastSpatial" # Where to output the list as a txt file
txtname <- "downloads.txt" # Basic txt file name
split <- TRUE # Split list and make into one list per sensor (TRUE/FALSE)

# Function creates lists of downloaded scenes held by DPaW
sceneListR <- function(dir2chk, wkdir, split = FALSE, txtname){
  setwd(dir2chk)
  list.gz <- basename(list.files(pattern = glob2rx("*.tar|.tar.gz"), recursive = TRUE))
  setwd(wkdir)
  if(split == FALSE){
    write.table(list.gz, file = txtname, col.names = FALSE, row.names = FALSE, 
                quote = FALSE)
  } else {
    for(sensor in c("LT5", "LE7", "LC8")){
      lind <- grepl(sensor, list.gz)
      lout <- list.gz[lind]
      lname <- paste0(sensor, "_", txtname)
      write.table(lout, file = lname, col.names = FALSE, row.names = FALSE, 
                  quote = FALSE)
    }
  }
}

#Run the function
sceneListR(dir2chk, wkdir, split, txtname)


##individual txt files were manually edited to remove duplicates an dartifacts##



# Loop to format upload txt files
tlist <- list.files(pattern = ".txt")
tnames <- substr(tlist, 1, 3)

for(i in 1:length(tlist)){
  d <- read.table(tlist[i], stringsAsFactors = FALSE)
  write.table(substr(d[,1], 1, 21), paste0(tnames[i],"_upload.txt"), 
              col.names = FALSE, row.names = FALSE, quote = FALSE) 
}


