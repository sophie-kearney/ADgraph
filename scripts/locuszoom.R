library(tidyverse)
remotes::install_github("cardiomoon/ggplotAssist")
library(ggplotAssist)

mouse_variants <- read.csv("mouse_variants.csv")
human_variants <- read.csv("human_variants.csv")

View(mouse_variants)
View(human_variants)

human_pval <- human_variants[human_variants$p_val!="",]
human_pval$location <- as.numeric(human_pval$location)
human_pval <- human_pval[!is.na(human_pval$location),]
human_pval$chromosome <- as.numeric(human_pval$chromosome)
human_pval <- human_pval[!is.na(human_pval$chromosome),]
human_pval$p_val <- gsub(" x 10-","e-", human_pval$p_val)
human_pval$p_val <- as.numeric(human_pval$p_val)
human_pval <- human_pval[!is.na(human_pval$p_val),]

chrom <- human_pval %>%
  group_by(chromosome)

ggplot(human_pval) +
  geom_point(aes(x=location, y=-log10(p_val), color=-log10(p_val))) +
  facet_wrap(~ chromosome, scale="free")

human_pval %>% filter(chromosome%in%c(19,7,2,1)) %>% 
  ggplot() +
  geom_point(aes(x=(location/1000000), y=-log10(p_val), color=-log10(p_val))) + 
  facet_wrap(~ chromosome, scale="free") +
  xlab("Position (Mb)") + 
  ylab("-log10(P Value)") + 
  guides(color=guide_legend(title="-log10(P Value)")) +
  scale_color_gradientn(colors = c("red","orange","yellow","green","lightblue","darkblue"), 
                        values = c(0, 0.03, 0.08, 0.2, 0.6, 1))
    
    
    #colours = viridis(5))
  #scale_color_gradient(low = "blue", high = "red")


