
go_to_genes = {}
go_to_description = {}
with open("/Users/sophiekearney/Desktop/graph/parsed_GO_pval/GO_mouse_rel.csv") as f:
    lines = f.readlines()

    for row in lines[1:]:
        data = row.replace("\n","").split(",")

        stats = [data[2],data[3],data[4],data[5]]

        if data[0] in go_to_genes.keys():
            go_to_genes[data[0]].append(stats)
        else:
            go_to_genes[data[0]] = [stats]

        if data[0] not in go_to_description.keys():
            go_to_description[data[0]] = data[1]

relationships = set()
data = {}
for go in list(go_to_genes.keys()):
    description = go_to_description[go]
    pairs = [(a, b) for idx, a in enumerate(go_to_genes[go]) for b in go_to_genes[go][idx + 1:]]
    for p in pairs:
        g1 = p[0]
        g2 = p[1]

        genes = (g1[0], g2[0])

        if genes not in data.keys():
            relationships.add(genes)

            print(go, g1, g2)

            avg_p = (float(g1[1]) + float(g2[1])) / 2
            avg_p_adj = (float(g1[2]) + float(g2[2])) / 2
            avg_q = (float(g1[3]) + float(g2[3])) / 2
            data[genes] = [go, description, avg_p, avg_p_adj, avg_q]


with open("/Users/sophiekearney/Desktop/graph/mm_vv_relationships.csv", "w", newline="") as f:
    f.write("GO_term,description,source,sink,avg_pvalue,avg_pvalue_adj,avg_qvalue\n")

    for rel in relationships:
        stat = data[rel]

        f.write(rel[0])
        f.write(",")
        f.write(rel[1])

        for i in stat:
            f.write(",")
            f.write(str(i))

        f.write("\n")

