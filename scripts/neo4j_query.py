from neo4j import GraphDatabase
import csv


class Neo4jConnection:

    def __init__(self, uri, user, pwd):
        self.__uri = uri
        self.__user = user
        self.__pwd = pwd
        self.__driver = None
        try:
            self.__driver = GraphDatabase.driver(self.__uri, auth=(self.__user, self.__pwd))
        except Exception as e:
            print("Failed to create the driver:", e)

    def close(self):
        if self.__driver is not None:
            self.__driver.close()

    def query(self, query, db=None):
        assert self.__driver is not None, "Driver not initialized!"
        session = None
        response = None
        try:
            session = self.__driver.session(database=db) if db is not None else self.__driver.session()
            response = list(session.run(query))
        except Exception as e:
            print("Query failed:", e)
        finally:
            if session is not None:
                session.close()
        return response

conn = Neo4jConnection(uri="bolt://localhost:7687", user="neo4j", pwd="Iris&Rose8")
q = conn.query('''MATCH (vh:Variant{species:"Homo sapiens"})--(gh:Gene{species:"Homo sapiens"})--(bp:GO_term)--(gm:Gene{species:"Mus musculus"})--(vm:Variant{species:"Mus musculus"}) RETURN vh.rs_id, vm.rs_id;''', db="neo4j")


with open("/Users/sophiekearney/Desktop/bp_v_to_v_new.csv",'w') as f:
    f.write("human_variant,human_gene,mouse_gene,mouse_variant\n")

    for row in q:
        line = ''
        info = row.data()

        f.write(info['vh.rs_id'])
        for k in list(info.keys())[1:]:
            f.write(',')
            f.write(info[k])
        f.write('\n')

