class GraphQLParser:
    def __init__(self, query):
        self.query = query
        self.index = 0

    def parse(self):
        self.query = self.query.strip()
        if not self.query:
            raise ValueError("Invalid query")
        return self.parse_query()

    def parse_query(self):
        query = {}
        while self.index < len(self.query):
            if self.query[self.index] == "{":
                self.index += 1
                query = self.parse_object(query)
            elif self.query[self.index] == "}":
                self.index += 1
                return query
            else:
                self.index += 1
        return query

    def parse_object(self, parent):
        obj = parent
        while self.index < len(self.query):
            if self.query[self.index] == "}":
                self.index += 1
                return obj
            elif self.query[self.index] == ",":
                self.index += 1
            else:
                key = self.parse_key()
                value = self.parse_value()
                obj[key] = value
        return obj

    def parse_key(self):
        key = ""
        while self.index < len(self.query) and self.query[self.index] != ":":
            key += self.query[self.index]
            self.index += 1
        self.index += 1
        return key.strip()

    def parse_value(self):
        if self.query[self.index] == "{":
            return self.parse_object({})
        elif self.query[self.index] == "[":
            return self.parse_array()
        else:
            value = ""
            while self.index < len(self.query) and self.query[self.index] not in [",", "}", "]"]:
                value += self.query[self.index]
                self.index += 1
            self.index += 1
            if value.isdigit():
                return int(value)
            elif value.replace(".", "", 1).isdigit():
                return float(value)
            else:
                return value.strip()

    def parse_array(self):
        arr = []
        self.index += 1
        while self.index < len(self.query) and self.query[self.index] != "]":
            if self.query[self.index] == ",":
                self.index += 1
            else:
                arr.append(self.parse_value())
        self.index += 1
        return arr

def execute_query(query):
    parser = GraphQLParser(query)
    return parser.parse()

query = "{ user { id, name, email } }"
print(execute_query(query))

query = "{ users { id, name, email } }"
print(execute_query(query))

query = "{ user(id: 1) { name, email } }"
print(execute_query(query))

query = "{ users { id, name, email, address { street, city, country } } }"
print(execute_query(query))