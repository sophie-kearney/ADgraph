library(tidyverse)
library(clusterProfiler)
library(org.Mm.eg.db)
library(enrichplot)
library(org.Hs.eg.db)
library(DOSE)
library(ggpubr)
library("patchwork")
library(cowplot)


mouse <- read.csv("mouse_variants.csv")

uniq <- mouse %>% group_by_all() %>% summarise(COUNT = n())

brain <- uniq[uniq$tissue=="striatum" | uniq$tissue=="hippocampus",]


human <- read.csv("human_variants.csv")
length(unique(human$gene_symbol))

######
# enrichment - not parsed
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

mres <- mouse_ego@result
hres <- human_ego@result

# mres_sep <- mres %>% 
#   dplyr::select(ID, Description, geneID, pvalue, p.adjust, qvalue) %>%
#   rename('geneID'='mouse_symbol', 'ID'='go_term', 'Description'='description',
#          'p.adjust'='pvalue_adjusted') %>%
#   separate_rows(mouse_symbol, sep="/")
# 
# 
# write.csv(mres_sep,"/Users/sophiekearney/Desktop/GO_mouse_rel.csv",row.names = FALSE, quote=FALSE)
# 
# 
# hres_sep <- hres %>% 
#   dplyr::select(ID, Description, geneID, pvalue, p.adjust, qvalue) %>%
#   rename('geneID'='human_symbol', 'ID'='go_term', 'Description'='description',
#          'p.adjust'='pvalue_adjusted') %>%
#   separate_rows(human_symbol, sep="/")
# 
# 
# write.csv(hres_sep,"/Users/sophiekearney/Desktop/GO_human_rel.csv",row.names = FALSE, quote=FALSE)
# 
# GO_relationships <- merge(mres_sep, hres_sep, by='go_term')
# View(GO_relationships)
# 
# write.csv(GO_relationships,"/Users/sophiekearney/Desktop/GO_relationships.csv",row.names = FALSE, quote=FALSE)
# 
# 
# GO_terms <- GO_relationships %>%
#   dplyr::select(go_term, description) %>%
#   distinct(go_term,description)
# 
# write.csv(GO_terms,"/Users/sophiekearney/Desktop/GO_terms.csv",row.names = FALSE,quote=FALSE)


###
# simplify
####

# simple_mouse <- simplify(mouse_ego)
# simple_mres <- simple_mouse@result
# 
# drop_mouse <- mouse_ego
# dropGO(drop_mouse,level=1)
# dropGO(drop_mouse,level=2)
# drop_mouse <- dropGO(drop_mouse,level=3)
# drop_mres <- drop_mouse@result
# 
# others <- subset(mres, !(mres$Description %in% drop_mres$Description))

#########
# test gene ratio
#########

# separate geneRatio
mres <- mres %>% separate(GeneRatio, c("#Genes","TotalGenes"))
mres$GeneRatio <- as.numeric(mres$`#Genes`) / as.numeric(mres$TotalGenes)
mres <- mres %>% relocate(GeneRatio, .after=TotalGenes)

hres <- hres %>% separate(GeneRatio, c("#Genes","TotalGenes"))
hres$GeneRatio <- as.numeric(hres$`#Genes`) / as.numeric(hres$TotalGenes)
hres <- hres %>% relocate(GeneRatio, .after=TotalGenes)

#plot geneRatio
# p1 <- ggplot(mres, aes(GeneRatio)) +
#   geom_histogram(aes(y=after_stat(density)), binwidth=.001, color="black", fill="white")+
#   geom_density(alpha=.2, fill="#FF6666") +
#   ggtitle("Mouse") + 
#   theme(plot.title = element_text(hjust = 0.5))
# p2 <- ggplot(hres, aes(GeneRatio)) +
#   geom_histogram(aes(y=after_stat(density)), binwidth=.001, color="black", fill="white")+
#   geom_density(alpha=.2, fill="#FF6666") +
#   ggtitle("Human") + 
#   theme(plot.title = element_text(hjust = 0.5))
# plot_grid(p1, p2)

# filter mres by geneRatio
mres_sub <- mres %>% filter(GeneRatio < .005)
hres_sub <- hres %>% filter(GeneRatio < .005)

# separate into gene->bp relationships
# mres_sep <- mres_sub %>% 
#   dplyr::select(ID, Description, geneID)
#   separate_rows(geneID, sep="/")
# hres_sep <- hres_sub %>% 
#   dplyr::select(ID, Description, geneID) %>%
#   separate_rows(geneID, sep="/")

mres_sep <- mres_sub %>% 
  dplyr::select(ID, Description, geneID, pvalue, p.adjust, qvalue) %>%
  plyr::rename(c('geneID'='mouse_symbol', 'ID'='go_term', 'Description'='description',
         'p.adjust'='pvalue_adjusted')) %>%
  mutate(description=gsub(",","",description)) %>%
  separate_rows(mouse_symbol, sep="/")


hres_sep <- hres_sub %>% 
  dplyr::select(ID, Description, geneID, pvalue, p.adjust, qvalue) %>%
  plyr::rename(c('geneID'='human_symbol', 'ID'='go_term', 'Description'='description',
         'p.adjust'='pvalue_adjusted')) %>%
  mutate(description=gsub(",","",description)) %>%
  separate_rows(human_symbol, sep="/")


write.csv(mres_sep,"/Users/sophiekearney/Desktop/GO_mouse_rel.csv",row.names = FALSE, quote=FALSE)
write.csv(hres_sep,"/Users/sophiekearney/Desktop/GO_human_rel.csv",row.names = FALSE, quote=FALSE)


GO_relationships <- merge(mres_sep, hres_sep, by='go_term')

GO_relationships <- GO_relationships %>%
  mutate(avg_pvalue=rowMeans(select(GO_relationships, c(pvalue.x,pvalue.y)), na.rm = TRUE),
         avg_pvalue_adj=rowMeans(select(GO_relationships, c(pvalue_adjusted.x,pvalue_adjusted.y)), na.rm = TRUE),
         avg_qvalue=rowMeans(select(GO_relationships, c(qvalue.x,qvalue.y)), na.rm = TRUE)) %>%
  dplyr::select(go_term, description.x, mouse_symbol, human_symbol, avg_pvalue, avg_pvalue_adj, avg_qvalue) %>%
  plyr::rename(c('description.x'='description'))

write.csv(GO_relationships,"/Users/sophiekearney/Desktop/GO_relationships.csv",row.names = FALSE, quote=FALSE)


# GO_terms <- GO_relationships %>%
#   dplyr::select(ID, Description.x) %>%
#   distinct(ID,Description.x)
# 
# write.csv(GO_terms,"/Users/sophiekearney/Desktop/GO_terms.csv",row.names = FALSE,quote=FALSE)

