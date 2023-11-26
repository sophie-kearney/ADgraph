rs_ids = []
data = {}

# get variants we have data on from vcf ensembl
with open("/Users/sophiekearney/Desktop/all_mouse_variants copy.vcf") as f:
    lines = f.readlines()
    for l in lines[5:]:

        row = (l.replace("\n","")).split("	")
        other_info = row[7].split("|")

        chrom = row[0]
        location = row[1]
        rs_id = row[2]
        alleles = row[3] + '/' + row[4]
        consequence = other_info[1]
        symbol = other_info[3]
        gene = other_info[4]


        info = [chrom, location, alleles, consequence, symbol, gene]
        # print(info)

        if rs_id not in data.keys():
            data[rs_id] = info

visited_rs_ids = []
# add in all the other variants we don't have extra data on
with open("/Users/sophiekearney/Desktop/AD/mouse_variants.csv") as f:
    lines = f.readlines()
    for l in lines[1:]:
        row = (l.replace("\n", "")).split(",")

        rs_id = row[6]
        symbol = row[2]
        gene = row[3]
        human_biotype = row[5]
        tissue = row[4]


        if rs_id not in data.keys():
            data[rs_id] = ['','','','','',symbol, gene, human_biotype, tissue]
        elif rs_id not in visited_rs_ids:
            # ensure that the names a symbols of genes match our data
            if data[rs_id][4] != symbol:
                data[rs_id][4] = symbol
            if data[rs_id][5] != gene:
                data[rs_id][5] = gene
            # add on extra data
            data[rs_id].append(human_biotype)
            data[rs_id].append(tissue)

            visited_rs_ids.append(rs_id)

with open("/Users/sophiekearney/Desktop/formatted_mouse_vcf.csv",'w') as f:
    f.write("rs_id,chromosome,location,alleles,consequence,symbol,gene,human_biotype,tissue\n")
    for rs_id in data.keys():
        line = rs_id

        for item in data[rs_id]:
            line = line + ',' + item

        line += '\n'
        f.write(line)
