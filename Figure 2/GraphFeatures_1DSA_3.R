rm(list=ls())
setwd("/Users/niki/Dropbox/Nikita/College/Projects/Lazzara Lab/ABM_Wendell&Lim/Circuit_ABCD_Asymm_01/Output_3.1/1DSA_3.1")
outpath = paste("/Users/niki/Dropbox/Nikita/College/Projects/Lazzara Lab/ABM_Wendell&Lim/Circuit_ABCD_Asymm_01/Output_3.1/1DSA_3.1/Heatmaps_Five_Params/")

library(readxl)
library(ggplot2)
library(plotly)
library(purrr)
library(tidyr)
library(dplyr)

# all_data <- read_excel ("1DSA_all_features_param_sensALL.xlsx")
# p10_data <- subset(all_data,Variation=="p10")
# # sens = data.frame(matrix(ncol = 3, nrow = 0))
# # x <- c("Var", "Var_Variation", "Value")
# # colnames(sens) <- x
# # 
# # for (n in 1:length(params)) {
# #    cur_data = subset(all_data,all_data$Var == params[n])
# #    cur_data<-cur_data[order(cur_data$Var_Value),]
# #    vals = unique(cur_data$Var_Value)
# #    data_1 = subset(cur_data,cur_data$Var_Value == vals[1])
# #    data_2 = subset(cur_data,cur_data$Var_Value == vals[2])
# #    data_3 = subset(cur_data,cur_data$Var_Value == vals[3])
# #    
# #    sens$Var.append(data_1$Var)
# #    sens$Var.append(rep(c("+10"),length(data_1$Var)))
# #    sens$Var.append(data_3[5:37] - data_1[5:37])
# #    
# #    # sens$plus <- 
# #    # sens$minus
# # }

all_features <- read_excel ("1DSA_all_features_params_sens.xlsx")
plot_data <- subset(all_features, Var == "exp-expression-const" | Var == "homotypic-prob" |
                       Var == "heterotypic-prob" | Var == "cluster-pause-delay" | Var == "cluster-move-size")
bar = list()
c = 1
col <- names(all_features)

i=1
for(i in 3:35){
   all_features <- read_excel ("1DSA_all_features_params_sens.xlsx")
   plot_data <- subset(all_features, Var == "exp-expression-const" | Var == "homotypic-prob" |
                          Var == "heterotypic-prob" | Var == "cluster-pause-delay" | Var == "cluster-move-size")
   plot_data$Var = with(plot_data, reorder(Var, -abs(plot_data[[i]]),max))
   
   # all_features[[i]] <- as.numeric(all_features[[i]])
   
   p = ggplot(plot_data,aes(Var,Var_Value,fill = plot_data[[i]])) + 
      geom_tile() +
      xlab("Parameter") + 
      ylab("Parameter Variation") + 
      scale_fill_gradient2(low="red", mid = "white", high="blue") +
                           # midpoint=0,    #same midpoint for plots (mean of the range)
                           # breaks=seq(-1,0,1), #breaks in the scale bar
                           # limits=c(floor(rng[1]), ceiling(rng[2]))) + #same limits for plots
      ggtitle(col[[i]])

   bar[[i]] = p
}

i = 3
for(i in 3:35){
   file1 = paste(outpath, col[[i]], "barplot.png", sep = "_")
   png(filename = file1, width = 1000, height = 500)
   print(bar[[i]])
   dev.off()
}
   

