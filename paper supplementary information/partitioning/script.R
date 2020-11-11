getwd() -> rootdir
dir.create("output")
setwd(paste(rootdir, "/data", sep=""))
#read in homoplasy scores and convert to vector
read.table("homoplasy.txt", header=T) -> h
as.matrix(h) -> j
#transpose matrix before vector conversion
t(j) -> k
as.vector(k) -> l
l -> l2 -> l3
read.table("states.txt") -> st
st[,4] -> st
#l2 has two state, l3 3 state
NA -> l2[which(st==3)]
l2 -> h02 -> h12
NA -> l2[490:525]
NA -> h02[c(1:489, 508:525)]
NA -> h12[1:507]
NA -> l3[which(st!=3)]



#each element of list has different homoplasy score
list() -> homoplasy2
for(i in 0:max(na.omit(l2))){
  which(l2==(i)) -> homoplasy2[[i+1]]
}
list() -> homoplasy3
for(i in 0:max(na.omit(l3))){
  which(l3==(i)) -> homoplasy3[[i+1]]
}
list() -> homology0
for(i in 0:max(na.omit(h02))){
  which(h02==(i)) -> homology0[[i+1]]
}
list() -> homology1
for(i in 0:max(na.omit(h12))){
  which(h12==(i)) -> homology1[[i+1]]
}


library(XML)

list() -> alignments2
for(i in 0:(length(homoplasy2)-1)){
  data <- newXMLNode("data")
  xmlAttrs(data) = c(id=paste("2_state_", i, "_homoplasy", sep=""), spec = "FilteredAlignment", data="@matrix", filter=paste(as.character(homoplasy2[[i+1]]), sep="' '", collapse=","))
  datatype <- newXMLNode("userDataType", parent=data)
  xmlAttrs(datatype) = c(idref="morph2")
  data -> alignments2[[i+1]]
}


list() -> alignments3
for(i in 0:(length(homoplasy3)-1)){
  data <- newXMLNode("data")
  xmlAttrs(data) = c(id=paste("3_state_", i, "_homoplasy", sep=""), spec = "FilteredAlignment", data="@matrix", filter=paste(as.character(homoplasy3[[i+1]]), sep="' '", collapse=","))
  datatype <- newXMLNode("userDataType", parent=data)
  xmlAttrs(datatype) = c(idref="morph3")
  data -> alignments3[[i+1]]
}


list() -> hom0
for(i in 0:(length(homology0)-1)){
  data <- newXMLNode("data")
  xmlAttrs(data) = c(id=paste("homology0_2_state_", i, "_homoplasy", sep=""), spec = "FilteredAlignment", data="@matrix", filter=paste(as.character(homology0[[i+1]]), sep="' '", collapse=","))
  datatype <- newXMLNode("userDataType", parent=data)
  xmlAttrs(datatype) = c(idref="morph2")
  data -> hom0[[i+1]]
}

list() -> hom1
for(i in 0:(length(homology1)-1)){
  data <- newXMLNode("data")
  xmlAttrs(data) = c(id=paste("homology1_2_state_", i, "_homoplasy", sep=""), spec = "FilteredAlignment", data="@matrix", filter=paste(as.character(homology1[[i+1]]), sep="' '", collapse=","))
  datatype <- newXMLNode("userDataType", parent=data)
  xmlAttrs(datatype) = c(idref="morph2")
  data -> hom1[[i+1]]
}

setwd(paste(rootdir, "/output", sep=""))

sink("partitions.xml")
for(i in 1:length(alignments2)){
  print(alignments2[[i]])
}
for(i in 1:length(alignments3)){
  print(alignments3[[i]])
}
for(i in 1:length(hom0)){
  print(hom0[[i]])
}
for(i in 1:length(hom1)){
  print(hom1[[i]])
}
sink()

save(homoplasy2, homoplasy3, file="partitions.rData")
