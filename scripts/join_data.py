import psycopg2

conn = psycopg2.connect(
    database="alzheimer_genes",
    user='postgres',
    password='Iris&Rose8',
    host='localhost',
    port='5432'
)
cursor = conn.cursor()

variants = []
rs_ids = []

####
# GWAS
####

with open("/Users/sophiekearney/Desktop/AD/human_variants/GWAS.csv") as file:
    lines = file.readlines()
    header = (lines[0]).replace("\n", "")
    header = header.split(",")

    for l in lines[1:]:
        data = l.replace("\n", "")
        data = data.replace("'-","")
        data = data.split(",")

        rs_id = data[0]
        gene_symbol = data[7]
        if rs_id.find("rs") != -1 and (rs_id not in rs_ids):
            p_val = data[1]
            colon_ndx = data[12].find(":")
            chromosome = (data[12])[0:colon_ndx]
            location = (data[12])[colon_ndx + 1:]

            rs_ids.append(rs_id)
            variants.append({"rs_id": rs_id, "p_val": p_val, "gene_symbol": gene_symbol, "chromosome": chromosome,
                             "location": location, "source": "GWASCatalog"})

####
# DisGeNET
####

with open("/Users/sophiekearney/Desktop/AD/human_variants/disgenet.tsv") as file:
    lines = file.readlines()

    for l in lines[1:]:
        data = l.replace("\n", "")
        data = data.split("\t")

        rs_id = data[2]
        gene_symbol = data[3]
        chromosome = data[8]
        location = data[9]
        consequence = data[10]
        alleles = data[12]
        score = data[17]
        number_of_publications = data[19]

        if rs_id not in rs_ids:
            rs_ids.append(rs_id)
            variants.append({"rs_id": rs_id, "gene_symbol": gene_symbol, "chromosome": chromosome, "location": location,
                             "consequence": consequence, "alleles": alleles, "score": score,
                             "number_of_publications": number_of_publications, "source": "DisGeNET"})

####
# ClinVar
####

with open("/Users/sophiekearney/Desktop/AD/human_variants/clinvar.tsv") as file:
    lines = file.readlines()

    for l in lines[1:]:
        data = l.replace("\n", "")
        data = data.split("\t")

        gene_symbol = data[1]
        protein_change = data[2]
        genome = "GRCh38"
        chromosome = data[9]
        location = data[10]
        rs_id = data[13]

        if rs_id != "" and gene_symbol != "" and rs_id not in rs_ids:
            rs_ids.append(rs_id)
            variants.append({"rs_id": rs_id, "gene_symbol": gene_symbol, "genome": genome, "chromosome": chromosome,
                             "location": location, "protein_change": protein_change, "source": "ClinVar"})

####
# Ensembl
####

with open("/Users/sophiekearney/Desktop/AD/human_variants/ensembl.csv") as file:
    lines = file.readlines()
    header = (lines[0]).split(",")

    for l in lines[1:]:
        data = l.replace("\n", "")
        data = data.split(",")

        rs_id = data[0]
        colon_ndx = data[1].find(":")
        chromosome = (data[1])[0:colon_ndx]
        location = (data[1])[colon_ndx + 1:]
        gene_symbol = data[2]

        if rs_id not in rs_ids:
            rs_ids.append(rs_id)
            variants.append({"rs_id": rs_id, "chromosome": chromosome, "location": location, "gene_symbol": gene_symbol,
                             "source": "Ensembl"})

####
# BioMart - dbSNP
####

with open("/Users/sophiekearney/Desktop/AD/human_variants/ensembl_biomart.csv") as file:
    lines = file.readlines()
    header = (lines[0]).split(",")
    data = (lines[1]).split(",")

    for l in lines[1:]:
        data = l.split(",")

        genome = "GRCh38"
        rs_id = data[0]
        source = data[1]
        chromosome = data[2]
        location = data[3]

        if rs_id not in rs_ids:
            rs_ids.append(rs_id)
            variants.append({"rs_id": rs_id, "genome": genome, "source": source, "chromosome": chromosome,
                             "location": location})



####
# add the variant data to the database
####

for v in variants:
    source = v["source"]

    if source == "GWASCatalog":
        sql = f'''INSERT INTO human_variants (rs_id, p_val, gene_symbol, chromosome, location, source)
                  VALUES ('{v['rs_id']}', '{v['p_val']}', '{v['gene_symbol']}', '{v['chromosome']}',
                        '{v['location']}', 'GWASCatalog');'''
        cursor.execute(sql)

    elif source == "DisGeNET":
        sql = f'''INSERT INTO human_variants (rs_id, gene_symbol, chromosome, location, consequence, alleles, score,
                                              number_of_publications, source)
                  VALUES ('{v['rs_id']}', '{v['gene_symbol']}', '{v['chromosome']}', '{v['location']}',
                          '{v['consequence']}', '{v['alleles']}', '{v['score']}', '{v['number_of_publications']}',
                          'DisGeNET');'''
        cursor.execute(sql)

    elif source == "Ensembl":
        sql = f'''INSERT INTO human_variants (rs_id, gene_symbol, chromosome, location, source)
                  VALUES ('{v['rs_id']}', '{v['gene_symbol']}', '{v['chromosome']}', '{v['location']}', 'Ensembl');'''
        cursor.execute(sql)

    elif source == "ClinVar":
        sql = f'''INSERT INTO human_variants (rs_id, gene_symbol, chromosome, location, genome, protein_change, source)
                  VALUES ('{v['rs_id']}', '{v['gene_symbol']}', '{v['chromosome']}', '{v['location']}', 
                          '{v['genome']}', '{v['protein_change']}', 'ClinVar');'''
        cursor.execute(sql)

conn.commit()
conn.close()