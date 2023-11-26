import csv
variants = []
rs_ids = []

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

messed_up = []
for v in variants:
    if v['chromosome'] not in ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','X','x','Y','y']:
        messed_up.append(v['rs_id'])

print(len(messed_up))

new_variants = []
new_rs_ids = []
print

with open("/Users/sophiekearney/Desktop/efotraits_MONDO_0004975-associations-2023-06-20.tsv") as file:
    lines = file.readlines()
    header = (lines[0]).replace("\n", "")
    header = header.split(",")

    for l in lines[1:]:
        data = l.replace("\n", "")
        data = data.replace("'-","")
        data = data.split("\t")

        rs_id = data[0].split("-")[0]
        gene_symbol = data[7].replace(", ",'/')
        gene_symbol.replace("\"","")

        if gene_symbol.find(",") != -1:
            print(gene_symbol)

        if rs_id.find("rs") != -1 and (rs_id in messed_up) and (rs_id not in new_rs_ids):
            p_val = data[1]
            colon_ndx = data[12].find(":")
            chromosome = (data[12])[0:colon_ndx]
            location = (data[12])[colon_ndx + 1:]

            if chromosome in ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','X','x','Y','y','23']:
                new_rs_ids.append(rs_id)
                new_variants.append({"rs_id": rs_id, "p_val": p_val, "gene_symbol": gene_symbol, "chromosome": chromosome,
                             "location": location, "source": "GWASCatalog"})


print(len(new_variants))

with open("/Users/sophiekearney/Desktop/corrected_chromosome.csv", 'w') as f:
    writer = csv.writer(f)
    writer.writerow(['rs_id','p_val','gene_symbol','chromosome','location','source'])
    for dictionary in new_variants:
        writer.writerow(dictionary.values())