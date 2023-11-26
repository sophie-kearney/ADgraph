var_pval = {}
var_comp = {}
final_info = []

with open("/Users/sophiekearney/Desktop/human_pval.csv") as f:
    lines = f.readlines()
    for row in lines[1:]:
        data = row.replace("\n","").split(",")

        if data[1].find(' x 10') != -1:
            parts_of_pval = data[1].split(' x 10')
            p_val = int(parts_of_pval[0]) * pow(10, int(parts_of_pval[1]))
            var_pval[data[0]] = p_val
        if data[1].isnumeric():
            var_pval[data[0]] = data[1]

with open("/Users/sophiekearney/Desktop/components.csv") as f:
    lines = f.readlines()
    for row in lines[1:]:
        data = row.replace("\n","").split(",")
        var_comp[data[0]] = data[1]

with open("/Users/sophiekearney/Desktop/all_collapsed_relationships.csv") as f:
    lines = f.readlines()
    for row in lines[1:]:
        data = row.replace("\n", "").split(",")
        comp_h = var_comp[data[0]]
        comp_m = var_comp[data[1]]
        assert(comp_h == comp_m)

        if data[0] in var_pval.keys():
            p_val = var_pval[data[0]]
        else:
            p_val = None

        current_info = [data[0], data[1], comp_h, p_val]
        final_info.append(current_info)

with open("/Users/sophiekearney/Desktop/collapsed_graph.csv", "w", newline="") as f:
    f.write("human_variant,mouse_variant,component,p_value\n")
    for r in final_info:
        f.write(r[0])
        for i in r[1:]:
            f.write(",")
            f.write(str(i))
        f.write("\n")
