:auto USING PERIODIC COMMIT 500
LOAD CSV WITH HEADERS FROM 'file:///human_variants.csv' AS row
WITH row.gene_symbol IS NOT NULL AND row.rs_id IS NOT NULL
MATCH (v:Variant {rs_id: row.rs_id})
MATCH (g:Gene {gene_symbol: row.gene_symbol})
MERGE (v)-[rel:VARIANT_OF]->(g)
RETURN count(rel);
