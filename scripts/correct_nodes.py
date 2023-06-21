import csv

to_correct_nodes = []
to_correct_rs_id_chrom = {}

with open("/Users/sophiekearney/PycharmProjects/ADgraph/data/corrected_chromosome.csv") as f:
    lines = f.readlines()
    header_to = lines[0].replace("\n","").split(",")
    for l in lines[1:]:
        node = l.replace("\n","").split(",")
        pval = node[1].replace(" x 10", "e")
        pval = float(pval)
        to_correct_rs_id_chrom[node[0]] = [pval, node[2],node[3],node[4]]
        to_correct_nodes.append(node)


corrected_nodes = []
with open("/Users/sophiekearney/PycharmProjects/ADgraph/nodes.csv") as f:
    lines = f.readlines()
    header = lines[0].replace("\n","").split(",")
    corrected_nodes.append(header)

    for l in lines[1:]:
        node = l.replace("\n","").split(",")
        if node[4] in to_correct_rs_id_chrom.keys():
            # fix pval
            node[12] = to_correct_rs_id_chrom[node[4]][0]
            # fix gene symbol
            node[1] = to_correct_rs_id_chrom[node[4]][1]
            # fix chromosome
            node[6] = to_correct_rs_id_chrom[node[4]][2]
            # fix location
            node[9] = to_correct_rs_id_chrom[node[4]][3]

        if node[6] not in ['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','X','x','Y','y','']:
            print(node)
        corrected_nodes.append(node)


# with open("/Users/sophiekearney/PycharmProjects/ADgraph/corrected_nodes.csv", "w") as f:
#     writer = csv.writer(f)
#     writer.writerows(corrected_nodes)