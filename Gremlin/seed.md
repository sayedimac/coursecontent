## Create vertices (people)
g.addV('person').property('userid', '1').property('name', 'Alice')

g.addV('person').property('userid', '2').property('name', 'Bob')

g.addV('person').property('userid', '3').property('name', 'Charlie')

g.addV('person').property('userid', '4').property('name', 'David')

g.addV('person').property('userid', '5').property('name', 'Eve')

## Create edges (relationships)

g.V().has('userid', '1').addE('knows').to(g.V().has('userid', '2'))

g.V().has('userid', '2').addE('knows').to(g.V().has('userid', '3'))

g.V().has('userid', '3').addE('knows').to(g.V().has('userid', '4'))

g.V().has('userid', '4').addE('knows').to(g.V().has('userid', '5'))

g.V().has('userid', '1').addE('knows').to(g.V().has('userid', '3'))

g.V().has('userid', '2').addE('knows').to(g.V().has('userid', '4'))

g.V().has('userid', '3').addE('knows').to(g.V().has('userid', '5'))
