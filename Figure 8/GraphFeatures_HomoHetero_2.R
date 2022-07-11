rm(list=ls())
setwd("/Users/niki/Dropbox/Nikita/College/Projects/Lazzara Lab/ABM_Wendell&Lim/Circuit_ABCD_Asymm_01/Output_3.1/Homotypic-Heterotypic_SensitivityAnalysis_11")
outpath = paste("/Users/niki/Dropbox/Nikita/College/Projects/Lazzara Lab/ABM_Wendell&Lim/Circuit_ABCD_Asymm_01/Output_3.1/Homotypic-Heterotypic_SensitivityAnalysis_11/R-plots/")

library(readxl)
library(ggplot2)
library(plotly)
library(purrr)
library(tidyr)
library(dplyr)
library(plotly)
library(rPraat)

# all_features <- read_excel ("HomotypicHeterotypic_all_features_ratios.xlsx")
# features = unique(all_features$Feature)

all_features <- read_excel ("labelled_spheroids_6_clusters_FINAL.xlsx")
all_features$homo_c <- factor(all_features$homo_c,levels=c('0','25','50','75','100'))
all_features$homo_d <- factor(all_features$homo_d,levels=c('100','75','50','25','0'))
all_features$hetero <- as.numeric(all_features$hetero)
plot = list()
i = 1


freq <- all_features %>% count(homo_c, homo_d, label)
freq$label = factor(freq$label,levels=c('0','5','1','2','3','4'))

p = ggplot() +
   geom_bar(data = freq, aes(x = homo_c, y = n, fill = label),stat = "identity",position="fill") +
   scale_fill_manual(values = c('#AFE3C0','#90C290','#DFC09F','#A799B7','#B8CFDE','#E08F89')) +
   # scale_fill_manual(values= c("#B4E1CD","#FCCDAE","#CBD5E7","#E6F4CB","#FFF1B2","#F1E2CD","#CCCCCC")) +
   facet_grid(rows = vars(homo_d), switch="y") +
   theme_classic()

file1 = paste(outpath,"cluster_frequency_graph_5.png", sep = "")
png(filename = file1, width = 1000, height = 1000)
print(p)
dev.off()

all_features <- read_excel ("HomotypicHeterotypic_all_features_ratios.xlsx")
features <- unique(all_features$Feature)
radii = unique(all_features$Radius)
all_features$Homotypic_Prob_C <- as.numeric(all_features$Homotypic_Prob_C)
all_features$Homotypic_Prob_D <- as.numeric(all_features$Homotypic_Prob_D)
all_features$Hetertoypic_Prob <- as.numeric(all_features$Heterotypic_Prob)
plot = list()

for(i in 1:length(features)){
   plot_data = subset(all_features, Feature == features[i] & Heterotypic_Prob == 0)
   plot_data$Value <- as.numeric(plot_data$Value)
   color = "blue"

   if(str_contains(features[i],"green")){
      color = "#75A245"
   }
   else if(str_contains(features[i],"red")){
      color = "#BE2227"
   }

   plot_data_descriptive <- aggregate(plot_data$Value,
                                      by = list(Homotypic_Prob_C=plot_data$Homotypic_Prob_C,Homotypic_Prob_D=plot_data$Homotypic_Prob_D),
                                      FUN = function(x) c(mean(x), sd(x)))
   plot_data_descriptive <- do.call(data.frame, plot_data_descriptive)

   p = ggplot(plot_data_descriptive,aes(Homotypic_Prob_C,Homotypic_Prob_D,fill = x.1)) +
      geom_tile() +
      xlab("Homotypic_Prob_C") +
      ylab("Homotypic_Prob_D") +
      scale_fill_gradient(low="white",high=color) +
      ggtitle(features[[i]])
      # theme(xlab.text=element_text(size=14),legend.text=element_text(size=14),legend.text=element_text(size=14))
   plot[[i]] = p

   # p2 = ggplot() +
   #    geom_point(data=plot_data, aes(x = factor(Homotypic_Prob), y = factor(Hetertoypic_Prob), color = Value), size=2,alpha=0.1) +
   #    scale_color_continuous(limits=c(0,8)) +
   #    xlab("Homotypic Probability") +
   #    ylab("Heterotypic Probability")

   # plot_data$Value <- as.numeric(plot_data$Value)
   # plot_data_descriptive <- aggregate(plot_data$Value,
   #                                    by = list(Homotypic_Prob = plot_data$Homotypic_Prob, Heterotypic_Prob = plot_data$Heterotypic_Prob),
   #                                    FUN = function(x) c(mean(x), sd(x)))
   # plot_data_descriptive <- do.call(data.frame, plot_data_descriptive)
   # plot_ly(plot_data_descriptive,x=~Homotypic_Prob,y=~Heterotypic_Prob, z=~x.1)
   #
   # p1 = ggplot() +
   #    geom_bar(data = plot_data_descriptive, aes(x = factor(C_Express_Delay), y = x.1, fill = factor(D_Express_Delay)),
   #             stat = "identity", position=position_dodge()) +
   #    geom_errorbar(data = plot_data_descriptive,
   #                  aes (x = factor(C_Express_Delay), y = x.1, fill = factor(D_Express_Delay),
   #                       ymin=x.1 - x.2, ymax=x.1 + x.2), width=.2,position=position_dodge(.9)) +
   #    facet_grid(~ Ratio) +
   #    xlab("N-Cad Expression Delay (ticks)") +
   #    ylab(features[i]) +
   #    labs(fill = "P-Cad Expression Offset (ticks)")
   #
   # plot_data$Value <- as.numeric(plot_data$Value)
   # p2 = ggplot() +
   #    geom_boxplot(data=plot_data, aes(x = factor(Cdel), y = Value, fill = factor(Ddel))) +
   #    facet_grid(~ Ratio) +
   #    labs(fill = "P-Cad Expression Offset (ticks)") +
   #    xlab("N-Cad Expression Delay (ticks)") +
   #    ylab(features[i])
   # bar[[i]] = p1
   # box[[i]] = p2
}

i = 1
for(i in 1:length(features)){
   file1 = paste(outpath,features[i],"graph.png", sep = "")
   png(filename = file1, width = 1000, height = 1000)
   print(plot[[i]])
   dev.off()
}
