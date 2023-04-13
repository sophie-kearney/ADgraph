## AD Collapsed Graph

This repository contains intermediate files used to create the collapsed heterogeneous knowledge graph of Human Variants associated with Alzheimer's Disease linked to related mouse variants through evolutionary conservation.

Notes about graph:
- Nodes represent genetic variants either from mice (Mus musculus), or humans (Homo sapiens)
- Edges represent a shared Gene Ontology function between the connected genetic variants
- Orthologous edges are not included in the current version of the graph, although they can be added
- many of the node attributes may be unhelpful, so ignore if necessary

---

**collapsed.graphml** = exported neo4j graph in graphml format
**edges.json** = contains data for the edges between nodes in json format, same information as what is in collapsed graph
**nodes.json** = contains data of the nodes in json format, same information as what is in collapsed graph

**data directory** = contains intermediate data files that hold edge and node data
**scripts directory** = contains scripts used to parse data

---

Node attributes:
- pval = p-value for the relationship between that variant and Alzheimer's disease. This is the attribute we are trying to predict in the mouse variants
- symbol = Gene symbol, identifier for the gene that variant is sourced from
- gene = Gene ID, identifier for the gene that variant is sourced from but specific to a gene database. Same information as the gene symbol, just a different identifier
- consequence = category of variant, explains the biological consequence of that nucleotide being altered
- rs_id = Identifier for the genetic variant that is used across biology when referencing that identifier. Should be unique within a species, but there could be duplicates between human and mouse variants, I am not sure.
- species = Species that the variant is associated with, either mice (Mus musculus) or human (Homo sapiens)
- chromosome = chromosome that the gene is found on. Senteny analysis has not been performed on this yet, but I am working on this so we can compare between mouse and human chromosomes. There are some non-numerical chromosomes like the X and Y chromosomes.
- human_biotype = very similar to the consequence attribute, just called different things in different databases
- tissue = only for mouse variants, denotes the tissue that this variant impacts (ex: liver, bone)
- location = location of variant within a chromosome, denotes the number of bases along a chromosome that this variant occurs
- alleles = denotes the change in base that the variant causes (ex: G/T means that in the original DNA there was a G, but with the variant, it is now a T)
- source = This is for the human variants, it shows the database that the human variant was found linked to Alzheimer's

Edge attributes:
- average_pvalue = Takes the average of each variant's pvalue related to the GO term that links them. This is a way to score their relatedness to the GO term
- average_pvalue_adjusted = Takes the average of each variant's pvalue related to the GO term that links them. This is the pvalue but FDR adjusted to account the false positive rate
- average_qvalue = Takes the average of each variant's qvalue related to the GO term that links them. This may be the same as the p-value adjusted so it might need to be ignored
- GO_term = the GO id for the term that links the two nodes
- description = description of what the GO term is (ex:positive regulation of dendrite extension)

---