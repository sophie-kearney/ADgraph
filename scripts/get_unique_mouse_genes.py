
data = []
syms = []

with open("/Users/sophiekearney/Library/Application Support/Neo4j Desktop/Application/relate-data/dbmss/dbms-2a952cd1-368a-4502-af81-53d382523afe/import/formatted_mouse_vcf.csv") as f:
    lines = f.readlines()
    for l in lines[1:]:
        row = (l.replace("\n", "")).split(",")
        symbol = row[5]
        ensembl_gene_id = row[6]
        chromosome = row[1]

        info = [symbol, chromosome, ensembl_gene_id]

        if symbol not in syms and info not in data and symbol!='' and "ENS" in ensembl_gene_id:
            data.append(info)
            syms.append(symbol)

print(len(data))

with open("/Users/sophiekearney/Desktop/mouse_genes.csv",'w') as f:
    f.write("gene_symbol,chromosome,ensembl\n")
    for row in data:
        line = row[0]

        for item in row[1:]:
            line = line + ',' + item

        line += '\n'
        f.write(line)
