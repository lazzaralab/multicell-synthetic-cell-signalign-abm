rm(list=ls())
setwd("/Users/niki/Dropbox/Nikita/College/Projects/Lazzara Lab/ABM_Wendell&Lim/Circuit_ABCD_Asymm_01/Output_3.1/Core_Pole_Ratio_Comparison")
outpath = paste("/Users/niki/Dropbox/Nikita/College/Projects/Lazzara Lab/ABM_Wendell&Lim/Circuit_ABCD_Asymm_01/Output_3.1/Core_Pole_Ratio_Comparison/R-Plots-subset/")

library(readxl)
library(ggplot2)
library(purrr)
library(tidyr)
library(dplyr)

all_features <- read_excel ("HomotypicHeterotypic_all_features_ratios.xlsx")
features = unique(all_features$Feature)

n = 1
boxplot_list = list()
barplot_list = list()
for (n in 1:length(features)) {
   plot_data = subset(all_features, Feature == features[n] & (Ratio == "1A|1B" | Ratio == "4A|1B" | Ratio == "9A|1B"))
   plot_data$Value <- as.numeric(plot_data$Value)
   
   boxp = ggplot(plot_data, aes(x=factor(Ratio), y=Value)) +
      geom_boxplot() + 
      # geom_point(position=position_dodge(),alpha=0.3) +
      theme_bw(base_size = 16) + 
      xlab("Initial A:B Ratio") + 
      ylab(features[n])
   boxplot_list[[n]] = boxp
   
   plot_data_descriptive <- aggregate(plot_data$Value, 
                                      by = list(Ratio = plot_data$Ratio), 
                                      FUN = function(x) c(mean(x), sd(x)))
   plot_data_descriptive <- do.call(data.frame, plot_data_descriptive)
   barp = ggplot() +
      geom_bar(data = plot_data_descriptive, aes(x = factor(Ratio), y = x.1), 
               stat = "identity", position=position_dodge()) +
      geom_errorbar(data = plot_data_descriptive, 
                    aes (x = factor(Ratio), y = x.1, ymin=x.1 - x.2, ymax=x.1 + x.2), width=.2,
                    position=position_dodge(.9)) +
      geom_point(data = plot_data, aes(x = factor(Ratio), y = Value),
                 position=position_dodge(),alpha=0.3) +
      theme_classic() + 
      xlab("Initial A:B Ratio") + 
      ylab(features[n])
   barplot_list[[n]] = barp
}
 
for (n in 1:length(features)) {
   file1 = paste(outpath,features[n],"boxplot.png", sep = "_")
   png(filename = file1, width = 550, height = 350)
   print(boxplot_list[[n]])
   dev.off()
}

for (n in 1:length(features)) {
   file2 = paste(outpath,features[n],"barplot.png", sep = "_")
   png(filename = file2, width = 550, height = 350)
   print(barplot_list[[n]])
   dev.off()
}

plot_data = subset(all_features, Feature == "green_avg_cent_dist" & (Ratio == "1A|1B" | Ratio == "4A|1B" | Ratio == "9A|1B"))
plot_data$Value <- as.numeric(plot_data$Value)
plot_data$Ratio <- as.factor(plot_data$Ratio)
shapiro.test(plot_data$Value)
kruskal.test(Value ~ Ratio, data = plot_data)
library(FSA)
dunnTest(Value ~ Ratio, data=plot_data,method="bh")

