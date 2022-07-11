rm(list=ls())
setwd("/Users/niki/Dropbox/Nikita/College/Projects/Lazzara Lab/ABM_Wendell&Lim/Circuit_ABCD_Asymm_01/Output_3.1/Core_Shell_InitialRatios_SpheroidRadius_2")
outpath = paste("/Users/niki/Dropbox/Nikita/College/Projects/Lazzara Lab/ABM_Wendell&Lim/Circuit_ABCD_Asymm_01/Output_3.1/Core_Shell_InitialRatios_SpheroidRadius_2/R-plots/")

library(readxl)
library(ggplot2)
library(purrr)
library(tidyr)
library(dplyr)

all_features <- read_excel ("Core_Shell_all_features_ratios.xlsx")
features = unique(all_features$Feature)

plot_data = subset(all_features, Feature == "num_gray_enclosed_green_75" | Feature == "num_red_enclosed_green_75")
# plot_data$Value <- as.numeric(plot_data$Value)
freq <- plot_data %>% count(Ratio, Radius, Feature, Value)

# p <- ggplot(data=freq, aes(x=Feature, y=n, fill=Value)) + 
#    geom_bar(position = "fill",stat="identity") + 
#    # scale_fill_manual(values=c("#929938", "#AD5FA5","#AA865F","#24B46A")) +
#    coord_flip()+
#    facet_grid(rows=vars(Ratio,Radius))

p <- ggplot(data=freq, aes(x=Feature,y=n,fill=interaction(Feature,Value))) +
   geom_bar(position = "fill",stat="identity") + 
   # scale_y_continuous(labels=scales::percent) +
   scale_fill_manual(values=c("#DED9D7","#FBC4C3","#B5B0B0", "#FF8F87","#8C8888","#E86063","#6E6A6A"))+
   coord_flip() +
   facet_grid(rows=vars(Ratio,Radius))+
   theme_classic()

file1 = paste(outpath,"GroupsComparison_all_graph.png", sep = "")
png(filename = file1, width = 1000, height = 1000)
print(p)
dev.off()

n = 1
boxplot_list = list()
barplot_list = list()
for (n in 1:length(features)) {
   plot_data = subset(all_features, Feature == features[n])
   plot_data$Value <- as.numeric(plot_data$Value)
   
   boxp = ggplot(plot_data, aes(x=factor(Ratio), y=Value, fill=factor(Radius))) +
      geom_boxplot() + 
      labs(fill = "Spheroid Radius") + 
      geom_point(position=position_jitterdodge(),alpha=0.3) +
      theme_bw(base_size = 16) + 
      xlab("Initial A:B Ratio") + 
      ylab(features[n])
   boxplot_list[[n]] = boxp
   
   plot_data_descriptive <- aggregate(plot_data$Value, 
                                      by = list(Radius = plot_data$Radius, Ratio = plot_data$Ratio), 
                                      FUN = function(x) c(mean(x), sd(x)))
   plot_data_descriptive <- do.call(data.frame, plot_data_descriptive)
   barp = ggplot() +
      geom_bar(data = plot_data_descriptive, aes(x = factor(Ratio), y = x.1, fill = factor(Radius)), 
               stat = "identity", position=position_dodge()) +
      geom_errorbar(data = plot_data_descriptive, 
                    aes (x = factor(Ratio), y = x.1, fill = factor(Radius), ymin=x.1 - x.2, ymax=x.1 + x.2), width=.2,
                    position=position_dodge(.9)) +
      labs(fill = "Spheroid Radius") + 
      geom_point(data = plot_data, aes(x = factor(Ratio), y = Value, fill = factor(Radius)),
                 position=position_jitterdodge(),alpha=0.3) +
      theme_bw(base_size = 16) + 
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


