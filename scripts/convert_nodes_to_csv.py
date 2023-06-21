import json
import csv

nodes = []
possible_properties = ['id', 'symbol', 'consequence', 'gene', 'rs_id', 'species', 'chromosome', 'human_biotype', 'tissue', 'location', 'alleles', 'source', 'pval', 'protein_change','genome', 'number_of_publications', 'score', 'jaccard_similarity']

with open("/Users/sophiekearney/PycharmProjects/ADgraph/nodes.json", encoding='utf-8-sig') as f:
    data = json.load(f)
    for i in data:
        id = i['v']['identity']
        props = i['v']['properties']

        line = [id]

        for p in possible_properties[1:]:
            if p in props.keys():
                if p == "pval" and props[p].find(" x ") != -1:
                    pval = props[p].replace(" x 10", "e")
                    pval = float(pval)
                    line.append(pval)
                else:
                    line.append(props[p])
            else:
                line.append('')
        nodes.append(line)

nodes.insert(0, possible_properties)

# print(nodes[0])

with open("/Users/sophiekearney/PycharmProjects/ADgraph/nodes.csv", "w") as f:
    writer = csv.writer(f)
    writer.writerows(nodes)