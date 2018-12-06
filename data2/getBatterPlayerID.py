import csv

writerFile = open('FABatter.csv', mode='w')
fieldnames = ['playerID', 'name', 'year', 'team']
writer = csv.DictWriter(writerFile, fieldnames=fieldnames)
writer.writeheader()

peopleFile = open('People.csv', 'r')
faFile = open('FA-Batters.csv', 'r')

peopleReader = csv.reader(peopleFile, delimiter=',')
faReader = csv.reader(faFile, delimiter=',')

faRow = faReader.next()
for faRow in faReader:
  found = False
  peopleFile.seek(1)
  for pRow in peopleReader:
    if pRow[13] + " " + pRow[14] == faRow[0]:
      writer.writerow({'playerID': pRow[0], 'name': faRow[0], 'year': faRow[1], 'team': faRow[3]})
      found = True;
      break
  if not found:
    print("%s not found" % faRow[0])

writerFile.close()
