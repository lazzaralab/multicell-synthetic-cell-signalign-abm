rm(list=ls())
setwd("/Users/niki/Dropbox/Nikita/College/Projects/Lazzara Lab/ABM_Wendell&Lim/Circuit_ABCD_Asymm_01/Output_3.1/Core_Pole_CellMovementComparison")
outpath = paste("/Users/niki/Dropbox/Nikita/College/Projects/Lazzara Lab/ABM_Wendell&Lim/Circuit_ABCD_Asymm_01/Output_3.1/Core_Pole_CellMovementComparison/")

library(readxl)
library(ggplot2)
library(purrr)
library(tidyr)
library(dplyr)

all_features <- read_excel ("HomotypicHeterotypic_all_features_5.3_ratios.xlsx")
features = unique(all_features$Feature)

n = 1
boxplot_list = list()
barplot_list = list()

plot_data = subset(all_features, (Feature == "Green-Movement-Fract") & (Ratio == "1A|1B" | Ratio == "4A|1B" | Ratio == "9A|1B") & (Radius == "5.3"))
plot_data$Value <- as.numeric(plot_data$Value)
plot_data$Time <- as.numeric(plot_data$Time)

plot_data_descriptive <- aggregate(plot_data$Value, 
                                   by = list(Ratio = plot_data$Ratio,Time = plot_data$Time), 
                                   FUN = function(x) c(mean(x), sd(x)))
plot_data_descriptive <- do.call(data.frame, plot_data_descriptive)

# p <- ggplot(data = plot_data_descriptive, aes(x = factor(Time), y = x.1, group=factor(Ratio))) +
#             geom_line(aes(color=factor(Ratio)),alpha = 0.8,size=2) +
#             scale_color_manual(values=c("#1CAF54","#95CA58","#C6E0B6")) +
#             # geom_line() +
#             theme_classic() + 
#             xlab("Initial A:B Ratio") + 
#             ylab(features[n])

p <- ggplot(data = plot_data_descriptive, aes(x = factor(Time), y = x.1, group=factor(Ratio))) +
  geom_ribbon(aes(fill=factor(Ratio),ymin=x.1+(1.96*x.2/10),ymax=x.1-(1.96*x.2/10)),alpha = 0.4) +
  scale_fill_manual(values=c("#1CAF54","#95CA58","#C6E0B6")) +
  geom_line(aes(color=factor(Ratio)),alpha = 0.8,size=2) +
  scale_color_manual(values=c("#1CAF54","#95CA58","#C6E0B6")) +
  theme_classic() + 
  xlab("Initial A:B Ratio") + 
  ylab(features[n])

file1 = paste(outpath,"GreenCellMovementOvertime_ribbon_5.3.png", sep = "_")
png(filename = file1, width = 2000, height = 500)
print(p)
dev.off()
   