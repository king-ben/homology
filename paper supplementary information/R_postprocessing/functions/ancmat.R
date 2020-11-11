ancmat <- function(ind, hom=1){
  matrix(nrow=length(ind), ncol=507) -> ancestormatrix
  for(i in 1:length(ind)){
    for(j in 1:ncol(state2homoplasy0)){
      state2homoplasy0[ind[i],j] -> ancestormatrix[i, homoplasy2[[1]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state2homoplasy1)){
      state2homoplasy1[ind[i],j] -> ancestormatrix[i, homoplasy2[[2]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state2homoplasy2)){
      state2homoplasy2[ind[i],j] -> ancestormatrix[i, homoplasy2[[3]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state2homoplasy3)){
      state2homoplasy3[ind[i],j] -> ancestormatrix[i, homoplasy2[[4]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state2homoplasy4)){
      state2homoplasy4[ind[i],j] -> ancestormatrix[i, homoplasy2[[5]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state2homoplasy5)){
      state2homoplasy5[ind[i],j] -> ancestormatrix[i, homoplasy2[[6]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state2homoplasy6)){
      state2homoplasy6[ind[i],j] -> ancestormatrix[i, homoplasy2[[7]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state2homoplasy7)){
      state2homoplasy7[ind[i],j] -> ancestormatrix[i, homoplasy2[[8]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state2homoplasy8)){
      state2homoplasy8[ind[i],j] -> ancestormatrix[i, homoplasy2[[9]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state2homoplasy9)){
      state2homoplasy9[ind[i],j] -> ancestormatrix[i, homoplasy2[[10]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state3homoplasy0)){
      state3homoplasy0[ind[i],j] -> ancestormatrix[i, homoplasy3[[1]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state3homoplasy1)){
      state3homoplasy1[ind[i],j] -> ancestormatrix[i, homoplasy3[[2]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state3homoplasy2)){
      state3homoplasy2[ind[i],j] -> ancestormatrix[i, homoplasy3[[3]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state3homoplasy3)){
      state3homoplasy3[ind[i],j] -> ancestormatrix[i, homoplasy3[[4]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state3homoplasy4)){
      state3homoplasy4[ind[i],j] -> ancestormatrix[i, homoplasy3[[5]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state3homoplasy5)){
      state3homoplasy5[ind[i],j] -> ancestormatrix[i, homoplasy3[[6]][j]]
    }
  }

  for(i in 1:length(ind)){
    for(j in 1:ncol(state3homoplasy6)){
      state3homoplasy6[ind[i],j] -> ancestormatrix[i, homoplasy3[[7]][j]]
    }
  }

  c(490, 492:498, 500:507) -> cpos
  if(hom==0){
    for(i in 1:length(ind)){
      for(j in 1:length(cpos)){
        homology0state2homoplasy0[ind[i],j] -> ancestormatrix[i, cpos[j]]
      }
    }

    for(i in 1:length(ind)){
      homology0state2homoplasy1[ind[i],1] -> ancestormatrix[i, 499]
    }

    for(i in 1:length(ind)){
      homology0state2homoplasy2[ind[i],1] -> ancestormatrix[i, 491]
    }
  }
  if(hom==1){
    for(i in 1:length(ind)){
      for(j in 1:length(cpos)){
        homology1state2homoplasy0[ind[i],j] -> ancestormatrix[i, cpos[j]]
      }
    }

    for(i in 1:length(ind)){
      homology1state2homoplasy1[ind[i],1] -> ancestormatrix[i, 499]
    }

    for(i in 1:length(ind)){
      homology1state2homoplasy2[ind[i],1] -> ancestormatrix[i, 491]
    }
  }
  ancestormatrix[,c(1:261,263:477,479:507)] -> ancestormatrix2
  vector() -> rnam
  for(i in 1:length(ind)){
    paste("anc", i) -> rnam[i]
  }
  if(length(ind)>2){
    rnam -> rownames(ancestormatrix2)
  }

  return(ancestormatrix2)
}
