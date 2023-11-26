library(tidyverse)
library(clusterProfiler)
library(org.Mm.eg.db)
library(enrichplot)
library(org.Hs.eg.db)
library(DOSE)
library(ggpubr)
library("patchwork")


mouse <- read.csv("mouse_variants.csv")

uniq <- mouse %>% group_by_all() %>% summarise(COUNT = n())

brain <- uniq[uniq$tissue=="striatum" | uniq$tissue=="hippocampus",]


human <- read.csv("human_variants.csv")
length(unique(human$gene_symbol))

######
# enrichment
######

human_entrez <- mapIds(org.Hs.eg.db, mouse$human_symbol, 'ENTREZID', 'SYMBOL')
human_ego <- enrichGO(gene  = human_entrez,
                OrgDb         = "org.Hs.eg.db",
                ont           = "BP",
                pAdjustMethod = "BH",
                readable=TRUE)
mouse_entrez <- mapIds(org.Mm.eg.db, mouse$mouse_symbol, 'ENTREZID', 'SYMBOL')
mouse_ego <- enrichGO(gene  = mouse_entrez,
                      OrgDb         = "org.Mm.eg.db",
                      ont           = "BP",
                      pAdjustMethod = "BH",
                      readable=TRUE)


####
# get common biological pathways
####

mres <- mouse_ego@result
hres <- human_ego@result

# write.csv(hres, "human.csv", row.names=FALSE)

both <- unique(intersect(mres$Description, hres$Description))

mcount <- mres %>% 
  filter(Description %in% both) %>%
  dplyr::select(Description, Count, p.adjust) %>%
  rename(Description="bp", Count="mouse", p.adjust="mouse_pval")

hcount <- hres %>% 
  filter(Description %in% both) %>%
  dplyr::select(Description, Count, p.adjust) %>%
  rename(Description="bp", Count="human", p.adjust="human_pval")

both_count <- merge(mcount, hcount, by="bp")

msum <- both_count %>% 
  arrange(desc(mouse)) %>%
  head(12) %>%
  dplyr::select(bp, mouse, mouse_pval) %>%
  rename(mouse_pval="pval",
         mouse="count") %>%
  mutate(log = log(pval)) %>%
  cbind(data.frame(species = rep("Mouse",12)))

hsum <- both_count %>% 
  arrange(desc(human)) %>%
  head(12) %>%
  dplyr::select(bp, human, human_pval) %>%
  rename(human_pval="pval",
         human="count") %>%
  mutate(log = log(pval)) %>%
  cbind(data.frame(species = rep("Human",12)))

together <- rbind(msum, hsum)
  
####
# experimental barplot
####

ggplot(together, aes(x=bp, y=count, fill=log)) + 
  geom_bar(stat = "identity") +
  facet_grid(. ~species) + 
  labs(y="Count", x="") + 
  scale_fill_gradientn(name="Log 
FDR Adjusted 
P Value", colors=viridis(5)) +
  coord_flip() +
  theme_minimal() + 
  theme(axis.line = element_line(colour = "grey50"), 
        strip.text.x = element_text(size = 13),
        strip.text.y = element_text(size = 13))

#######
# original barplot
#######
p1 <- msum %>%
  ggplot(aes(x=bp, y=mouse, fill=log)) +
     geom_bar(stat="identity") +
     labs(y="Count", x="") + 
     scale_fill_gradientn(name = "Adjusted
P Value", colours = c("blue", "red"),
                       values = scales::rescale(c(5.4e-21, 1e-27, 1e-29, 3.9e-31))) +
     coord_flip() + 
     ggtitle("Mouse") +
     theme_classic() +
     theme(plot.title = element_text(hjust = 0.5))

p2 <- hsum %>%
  ggplot(aes(x=bp, y=human, fill=log)) +
    geom_bar(stat="identity") +
    labs(y="Count", x="") + 
    coord_flip() +
    scale_fill_gradientn(name = "Adjusted
P Value", colours = c("blue", "red"),
                         values = scales::rescale(c(9e-10, 1e-14, 1e-20, 4e-31))) +
    ggtitle("Human") +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5))

ggarrange(p1, p2, legend="right")

#######
# barplot
#######

p1 <- barplot(human_ego, font.size=8) +
  ggtitle("Human") +
  guides(fill=guide_legend(title="Adjusted P Value")) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

p2 <- barplot(mouse_ego, font.size=8) +
  ggtitle("Mouse") +
  guides(fill=guide_legend(title="Adjusted P Value")) +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5))

cowplot::plot_grid(p1, p2, ncol=2)

combined_bar <- ggarrange(p1, p2, common.legend=TRUE, legend="right")

annotate_figure(plot, top = text_grob("Dive depths (m)", 
                                      color = "red", face = "bold", size = 14))

################
##  treeplot
#################

medox <- setReadable(mouse_ego, 'org.Mm.eg.db', 'ENTREZID')
medox2 <- pairwise_terxmsim(medox)
treeplot(medox2,font.size=3, showCategory = 300)

hedox <- setReadable(human_ego, 'org.Hs.eg.db', 'ENTREZID')
hedox2 <- pairwise_termsim(hedox)
treeplot(hedox2,font.size=2, showCategory = 201) + 
  ggtitle("Human Functional Enrichment")
cowplot::plot_grid(p1, p2, ncol=2)

topm <- mouse_ego@result %>%
  head(12) %>%
  select(Description, p.adjust, Count) %>%
  rename(Description=h_bp, p.adjust="h_p", Count="h_count")
