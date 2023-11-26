library(dplyr)

mouse_variants <- read.csv("/Users/sophiekearney/Desktop/AD/mouse_variants.csv",header=TRUE)

human_variants <- read.csv("/Users/sophiekearney/Desktop/AD/human_variants.csv")

View(human_variants)

hgene_to_pval <- human_variants[,c(2,12)]
hgene_to_pval <- na.omit(hgene_to_pval)
hgene_to_pval <- hgene_to_pval[hgene_to_pval$gene_symbol!="" &
                               hgene_to_pval$p_val!="",]
names(hgene_to_pval)[1] <- "human_symbol"

mouse_w_pval <- merge(hgene_to_pval, mouse_variants, by="human_symbol", all=FALSE)
class(mouse_w_pval$p_val)

mouse_w_pval$p_val <- gsub(" x 10-","e-", mouse_w_pval$p_val)
mouse_w_pval$p_val <- as.numeric(mouse_w_pval$p_val)
mouse_w_pval <- mouse_w_pval[order(mouse_w_pval$p_val),]


selected_variants <- mouse_w_pval[(!is.na(mouse_w_pval$p_val) &
                                   (mouse_w_pval$tissue=="striatum" |
                                    mouse_w_pval$tissue=="hippocampus")),]
                                
selected_variants <- distinct(selected_variants)


#######
## expression data
#######
library(clusterProfiler)
library(org.Mm.eg.db)
library(enrichplot)


ego <- enrichGO(gene  = t,
                       OrgDb         = "org.Mm.eg.db",
                       ont           = "BP",
                       pAdjustMethod = "none",
                       pvalueCutoff  = 0.01,
                       qvalueCutoff  = 0.05,
                       readable      = TRUE)

revigo <- ego@result
revigo <- revigo[,c(1,5)]
revigo2 <- revigo[revigo$pvalue<.05,]
write.csv(revigo, "revigo.csv",row.names=FALSE)

barplot(ego)
dotplot(ego)
edox <- setReadable(ego, 'org.Mm.eg.db', 'ENTREZID')
cnetplot(edox,colorEdge = TRUE)

cnetplot(edox, circular = TRUE, colorEdge = TRUE)          

heatplot(edox, showCategory=5)

edox2 <- pairwise_termsim(edox)
treeplot(edox2)
emapplot(edox2)

