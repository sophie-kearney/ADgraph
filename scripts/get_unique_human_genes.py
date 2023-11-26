data = []
syms = []
with open("/Users/sophiekearney/Library/Application Support/Neo4j Desktop/Application/relate-data/dbmss/dbms-2a952cd1-368a-4502-af81-53d382523afe/import/human_variants.csv") as f:
    lines = f.readlines()
    for l in lines[1:]:
        row = (l.replace("\n", "")).split(",")
        symbol = row[1]
        symbol = symbol.split(";")[0]

        chromosome = row[2]
        source = row[10]
        info = [symbol, chromosome, source]

        if info not in data and symbol not in syms and symbol != "\"\"" and len(chromosome) < 4 and " " not in symbol and "[" not in symbol:
            syms.append(symbol)
            data.append(info)

with open("/Users/sophiekearney/Desktop/human_genes.csv",'w') as f:
    f.write("gene_symbol,chromosome,source\n")
    for row in data:
        line = row[0]

        for item in row[1:]:
            line = line + ',' + item

        line += '\n'
        f.write(line)