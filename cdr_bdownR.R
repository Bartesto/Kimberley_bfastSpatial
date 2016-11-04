
#Python script and path
pyPath <- "D:\\RDEV2\\Kimberley_bfastSpatial\\bulk-downloader"
pyScript <- "download_espa_order.py"
py <- paste0(pyPath, "\\", pyScript)

#Arguments
email <- paste0("-e barthuntley@iinet.net.au")
order <- paste0("-o barthuntley@iinet.net.au-11032016-001812-872")
target <- paste0("-d H:\\cdr_bulk")
user <- "-u 30798574"
pass <- "-p ba211069rt"

args <- paste(py, email, order, target, user, pass, sep =" ")

shell(args)

#barthuntley@iinet.net.au-11032016-001812-872
barthuntley@iinet.net.au-11032016-001847-506
barthuntley@iinet.net.au-11032016-001925-777

##In a loop
#next order ID's
a <- "barthuntley@iinet.net.au-11032016-001847-506"
b <- "barthuntley@iinet.net.au-11032016-001925-777"

ids <- c(a, b)

for(id in ids){
  #Python script and path
  pyPath <- "D:\\RDEV2\\Kimberley_bfastSpatial\\bulk-downloader"
  pyScript <- "download_espa_order.py"
  py <- paste0(pyPath, "\\", pyScript)
  
  #Arguments
  email <- paste0("-e barthuntley@iinet.net.au")
  order <- paste0("-o ", id)
  target <- paste0("-d H:\\cdr_bulk")
  user <- "-u 30798574"
  pass <- "-p ba211069rt"
  
  args <- paste(py, email, order, target, user, pass, sep =" ")
  
  shell(args)
}