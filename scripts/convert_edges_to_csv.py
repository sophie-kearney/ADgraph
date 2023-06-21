import json
import csv

edges = []
possible_properties = ['edge_id', 'source', 'sink', 'edge_type', 'GO_term', 'description', 'avg_qvalue', 'avg_pvalue', 'avg_pvalue_adj']

print(possible_properties)
with open("/Users/sophiekearney/PycharmProjects/ADgraph/edges.json", encoding='utf-8-sig') as f:
    data = json.load(f)
    for i in data:
        edge_id = i['r']['identity']
        source = i['r']['start']
        sink = i['r']['end']
        edge_type = i['r']['type']
        line = [edge_id, source, sink, edge_type]

        props = i['r']['properties']

        for p in possible_properties[4:]:
            if p in props.keys():
                line.append(props[p])
            else:
                line.append('')

        edges.append(line)

edges.insert(0, possible_properties)

with open("/Users/sophiekearney/PycharmProjects/ADgraph/edges.csv", "w") as f:
    writer = csv.writer(f)
    writer.writerows(edges)