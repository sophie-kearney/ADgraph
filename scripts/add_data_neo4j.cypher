// add mouse variants
LOAD CSV WITH HEADERS FROM 'file:///collapsed_w_attr/formatted_mouse_vcf.csv' AS row
MERGE (v:Variant {rs_id: row.rs_id, species:"Mus musculus"})
SET v.chromosome=row.chromosome, v.location=row.location, v.alleles=row.alleles, v.consequence=row.consequence, v.gene=row.gene, v.symbol=row.symbol, v.human_biotype=row.human_biotype, v.tissue=row.tissue
RETURN count(v);

// add human variants
LOAD CSV WITH HEADERS FROM 'file:///collapsed_w_attr/human_variants.csv' AS row
MERGE (v:Variant {rs_id: row.rs_id, species:"Homo sapiens"})
SET v.symbol=row.gene_symbol, v.chromosome=row.chromosome, v.location=row.location, v.score=row.score, v.consequence=row.consequence,
v.alleles=row.alleles, v.number_of_publications=row.number_of_publications, v.protein_change=row.protein_change, v.genome=row.genome, v.source=row.source, v.pval=row.p_val
RETURN count(v);

// connect human variants to human variants
:auto USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'file:///collapsed_w_attr/hh_vv_relationships.csv' AS row
MATCH (v1:Variant {symbol:row.source, species:'Homo sapiens'})
MATCH (v2:Variant {symbol:row.sink, species:'Homo sapiens'})
MERGE (v1)-[rel:GO {GO_term:row.GO_term, description:row.description, avg_pvalue:row.avg_pvalue,  avg_pvalue_adj:row.avg_pvalue_adj, avg_qvalue:row.avg_qvalue}]-(v2)
RETURN count(rel);

// connect mouse variants to mouse variants
:auto USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'file:///collapsed_w_attr/mm_vv_relationships.csv' AS row
MATCH (v1:Variant {symbol:row.source, species:'Mus musculus'})
MATCH (v2:Variant {symbol:row.sink, species:'Mus musculus'})
MERGE (v1)-[rel:GO {GO_term:row.GO_term, description:row.description, avg_pvalue:row.avg_pvalue,  avg_pvalue_adj:row.avg_pvalue_adj, avg_qvalue:row.avg_qvalue}]-(v2)
RETURN count(rel);

// connect human variants to mouse variants
:auto USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'file:///collapsed_w_attr/GO_relationships.csv' AS row
MATCH (vm:Variant {symbol:row.mouse_symbol, species:'Mus musculus'})
MATCH (vh:Variant {symbol:row.human_symbol, species:'Homo sapiens'})
MERGE (vm)-[rel:GO {GO_term:row.go_term, description:row.description, avg_pvalue:row.avg_pvalue,  avg_pvalue_adj:row.avg_pvalue_adj, avg_qvalue:row.avg_qvalue}]-(vh)
RETURN count(rel);
