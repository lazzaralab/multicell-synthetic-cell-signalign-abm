rm(list=ls())
setwd("/Users/niki/Dropbox/Nikita/College/Projects/Lazzara Lab/ABM_Wendell&Lim/Circuit_ABCD_Asymm_01/Output_3.1/DynamicCellSignalingEffect_2")
outpath = paste("/Users/niki/Dropbox/Nikita/College/Projects/Lazzara Lab/ABM_Wendell&Lim/Circuit_ABCD_Asymm_01/Output_3.1/DynamicCellSignalingEffect_2/R-plots/")

library(readxl)
library(ggplot2)
library(purrr)
library(tidyr)
library(dplyr)

all_features <- read_excel ("DynamicCellSignallingEffect_all_features_ratios.xlsx")
features = unique(all_features$Feature)
plot_data = subset(all_features, Feature == "core")

test_data = subset(all_features, Feature == "core")
test_data$Value <- as.factor(test_data$Value)
test_data$Condition <- as.factor(test_data$Condition)
kruskal.test(Value ~ Ratio, data = plot_data)
library(FSA)
dunnTest(Value ~ Ratio, data=plot_data,method="bh")


freq <- plot_data %>% count(Condition, Value)
contingency <- xtabs(n ~ Condition + Value, data = freq)
p <- ggplot(data=freq, aes(x=Condition,y=n,fill=Value)) +
   geom_bar(position = "fill",stat="identity") +
   # scale_y_continuous(labels=scales::percent) +
   scale_fill_manual(values=c("#94C954","#BF2026")) +
   # coord_flip() +
   # facet_grid(rows=vars(Ratio,Radius))+
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
   
   boxp = ggplot(plot_data, aes(x=factor(Condition), y=Value)) +
      geom_boxplot() + 
      # labs(fill = "Spheroid Radius") + 
      geom_point(alpha=0.3) +
      theme_bw(base_size = 16) + 
      xlab("Cell Signalling") + 
      ylab(features[n])
   boxplot_list[[n]] = boxp
   
   plot_data_descriptive <- aggregate(plot_data$Value, 
                                      by = list(Condition = plot_data$Condition), 
                                      FUN = function(x) c(mean(x), sd(x)))
   plot_data_descriptive <- do.call(data.frame, plot_data_descriptive)
   barp = ggplot() +
      geom_bar(data = plot_data_descriptive, aes(x = factor(Condition), y = x.1), 
               stat = "identity") +
      geom_errorbar(data = plot_data_descriptive, 
                    aes (x = factor(Condition), y = x.1, ymin=x.1 - x.2, ymax=x.1 + x.2), width=.2) +
      # labs(fill = "Spheroid Radius") + 
      geom_point(data = plot_data, aes(x = factor(Condition), y = Value),
                 alpha=0.3) +
      theme_bw(base_size = 16) + 
      xlab("Cell Signaling") + 
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


