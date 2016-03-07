#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

library(jsonlite)

for(n in args){
fileName <- paste("/home/ubuntu/JSON_Files/", n, ".txt", sep="")
conn <- file(fileName,open="r")
linn <-readLines(conn)
output <- data.frame(text = "")
for (i in 1:length(linn)){
   output <- rbind(output, data.frame(text = linn[i]))
}

sources <- ""
for(i in 1:(length(output$text))){
if(length(grep("_source", toString(output$text[i]), ignore.case=TRUE)) != 0){
sources <- c(sources, i)
}}
sources <- sources[-1]

for(i in 1:(length(sources)-1)){
if(nchar(toString(output$text[sources[i]])) > 17){
sources <- sources[-i]
}}

export <- data.frame(text = "", lat = "", long = "", screename = "", url = "")
for(i in 1:(length(sources)-1)){
print(i)
sub <- output$text[as.numeric(sources[i]):(as.numeric(sources[i+1])-1)]
if(length(grep("type\" : \"Point", sub, ignore.case=TRUE)) != 0){
print("Yes - GeoLocation")
ind = grep("type\" : \"Point", sub, ignore.case=TRUE)
loc = strsplit(toString(sub[ind[1]+1]), ":")[[1]][2]
lat = strsplit(strsplit(loc, ",")[[1]][2], " ")[[1]][2]
lng = strsplit(strsplit(loc, ",")[[1]][1], " ")[[1]][3]
print(lat)
print(lng)
print(strsplit(substring(strsplit(toString(sub[4]), ":")[[1]][2],3,nchar(strsplit(toString(sub[4]), ":")[[1]][2])),"https")[[1]][1])
txt = gsub("https", "", substring(strsplit(toString(sub[4]), ":")[[1]][2],3,nchar(strsplit(toString(sub[4]), ":")[[1]][2])))
screename = gsub('\"', "", gsub(",","",gsub(" ", "",strsplit(toString(sub[grep("screen_name", sub, ignore.case=TRUE)[length(grep("screen_name", sub, ignore.case=TRUE))]]),":")[[1]][2])))
url = gsub(",", "", gsub('\"', "", (strsplit(toString(sub[grep("expanded_url", sub, ignore.case=TRUE)[1]]), " : ")[[1]][2])))
insert <- data.frame(text = txt, lat = lat, long = lng, screename = screename, url = url)
export <- rbind(export, insert)
}}
export <- export[2:(dim(export)[1]),]
jsn <- toJSON(export, pretty=TRUE)
path = paste("/home/ubuntu/JSON_Files/output/", n, ".json", sep="")
write(jsn, path)}