filepath = "allSections.json"

with open(filepath) as file:
  data = json.load(file)

[keys, keyTypes, ratings] = data
keyTypes = eval(keyTypes.replace("<class '", "").replace("'>",""))

#you will need to create the database first. do it in sql or run createDB() in python
createTable("Section", keys, keyTypes)
enterValuesDB(keys, ratings, "Section")
