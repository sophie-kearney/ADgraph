library(simplifyEnrichment)
library(rrvgo)

###
# load data
###
mouse_entrez <- mapIds(org.Mm.eg.db, mouse$mouse_symbol, 'ENTREZID', 'SYMBOL')
mouse_ego <- enrichGO(gene  = mouse_entrez,
                      OrgDb         = "org.Mm.eg.db",
                      ont           = "BP",
                      pAdjustMethod = "BH",
                      readable=TRUE)

mres <- mouse_ego@result

###
# correlation matrix manually
###

test_ids <- unique(mres$ID)[5975:length(unique(mres$ID))]

sim_mat <- matrix(, nrow=length(test_ids),ncol=length(test_ids),
                  dimnames=list(test_ids, test_ids))


for (x_term in test_ids){
  ndx <- which(test_ids==x_term)
  for (y_term in test_ids[ndx:length(test_ids)]){
    x_parent_terms <- (GOfuncR::get_parent_nodes(x_term))$parent_go_id
    y_parent_terms <- (GOfuncR::get_parent_nodes(y_term))$parent_go_id
    int <- length(intersect(x_parent_terms, y_parent_terms))
    un <- length(union(x_parent_terms, y_parent_terms))
    sim <- int/un
    
    sim_mat[x_term, y_term] <- sim
  }
}

###
# correlation matrix manually
###

# sim <- GO_similarity(unique(mres$ID), "BP", db = 'org.Mm.eg.db', measure = "Wang")

simMatrix <- calculateSimMatrix(unique(mres$ID),
                                orgdb="org.Mm.eg.db",
                                ont="BP",
                                method="Rel")

write.csv(simMatrix, "sim_matrix.csv")

