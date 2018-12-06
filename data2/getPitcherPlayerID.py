import csv

writerFile = open('FAPitcher.csv', mode='w')
fieldnames = ['playerID', 'name', 'year', 'team']
writer = csv.DictWriter(writerFile, fieldnames=fieldnames)
writer.writeheader()

peopleFile = open('People.csv', 'r')
faFile = open('FreeAgentPitchers.csv', 'r')

peopleReader = csv.reader(peopleFile, delimiter=',')
faReader = csv.reader(faFile, delimiter=',')

faRow = faReader.next()
for faRow in faReader:
  found = False
  peopleFile.seek(1)
  for pRow in peopleReader:
    if pRow[13] + " " + pRow[14] == faRow[1]:
      writer.writerow({'playerID': pRow[0], 'name': faRow[1], 'year': faRow[2], 'team': faRow[4]})
      found = True;
      break
  if not found:
    print("%s not found" % faRow[1])

writerFile.close()
