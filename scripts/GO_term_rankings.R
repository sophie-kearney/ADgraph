BiocManager::install("GOfuncR")

go <- read_tsv("gene_association.tsv", col_names=FALSE,
               col_types=cols(.default = "c"))
names(go) <- c("db","MGI_acc_ID", "mouse_marker","NOT_des",
               "GO_term_id","MGI_ref_ass_ID","GO_evidence_code",
               "inferred_from","ontology","mouse_marker_name",
               "mouse_marker_syn",
               "mouse_marker_type","taxon","mod_date","assigned_by",
               "ann_ext","gene_prod")

bp <- go %>% filter(ontology=="P")
View(bp)

GOfuncR::get_parent_nodes(c("GO:0045860"))
