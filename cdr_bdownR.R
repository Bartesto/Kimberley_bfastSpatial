
#Python script and path
pyPath <- "Z:\\DOCUMENTATION\\BART\\R\\python\\bulk-downloader"
pyScript <- "download_espa_order.py"
py <- paste0(pyPath, "\\", pyScript)

#Arguments
email <- paste0("-e barthuntley@iinet.net.au")
order <- paste0("-o ALL")
target <- paste0("-d H:\\cdr_bulk")
user <- "-u 30798574"
pass <- "-p ba211069rt"

args <- paste(py, email, order, target, user, pass, sep =" ")

shell(args)
