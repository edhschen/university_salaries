import mysql.connector

try:
    with mysql.connector.connect(
        host = "localhost",
        user = "root",
        password = "testpwd123",
        database = "ratingsdb"
    ) as connection:
        print(connection)
        #createTable("Sections", keys, keysTypes)
except mysql.connector.Error as e:
    print(e)

connection = mysql.connector.connect(
    host = "localhost",
    user = "root",
    password = "testpwd123",
    database = "ratingsdb"
)

def createDB():
    createDBQuery = "CREATE DATABASE ratingsdb"
    with connection.cursor() as cursor:
        cursor.execute(createDBQuery)

def createTable(reportType, keys, keysTypes):
    sqlDataTypes = {int: "INT", float: "FLOAT", str: "VARCHAR(100)"}
    #columns = (Column(name, Integer) for name in keys)

    try:
        createTableQuery = "CREATE TABLE by{0}(id INT AUTO_INCREMENT PRIMARY KEY)".format(reportType, keys)
        connection.cursor().execute(createTableQuery)
        connection.commit()
    except mysql.connector.Error as e:
        print(e)

    for i in range(0,len(keys)):
        addColumnQuery = "ALTER TABLE by{0} ADD COLUMN `{1}` {2}".format(reportType, keys[i], sqlDataTypes[keysTypes[i]])
        connection.cursor().execute(addColumnQuery)
        connection.commit()

def delTable(reportType):
    deleteDBQuery = "DROP TABLE IF EXISTS by{0}".format(reportType)
    with connection.cursor() as cursor:
        cursor.execute(deleteDBQuery)

def enterValuesDB(keys, entries, reportType):
    try:
        entries[0][1]
        formatEntries = list(map(tuple, entries))
        many = True
    except:
        formatEntries = tuple(entries)
        many = False
    attributeQuery = ""
    for i in range(0, len(keys)):
        attributeQuery += "`{0}`, ".format(keys[i])
    attributeQuery = attributeQuery[:-2]
    insertQuery = """
    INSERT INTO by{0}
    ({2})
    VALUES ({1})
    """.format(reportType, ("%s, " * len(keys))[:-2], attributeQuery)

    with connection.cursor() as cursor:
        print("pushing values")
        try:
            if many:
                cursor.executemany(insertQuery, formatEntries)
            else:
                cursor.execute(insertQuery, formatEntries)
            connection.commit()
            print(cursor.rowcount, "was inserted")
        except mysql.connector.Error as e:
            print(e)

    #return insertQuery

# cursor = connection.cursor()
