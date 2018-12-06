import csv

writerFile = open('FAPlayer.csv', mode='w')
fieldnames = ['playerID', 'year', 'team']
writer = csv.DictWriter(writerFile, fieldnames=fieldnames)
writer.writeheader()

bFile = open('FABatter.csv', 'r')
pFile = open('FAPitcher.csv', 'r')

bReader = csv.reader(bFile, delimiter=',')
pReader = csv.reader(pFile, delimiter=',')

year = "2000"
hm = {}

bRow = bReader.next()
pRow = pReader.next()
pRow = pReader.next()
for bRow in bReader:
  if bRow[2] == year:
    if bRow[3] not in hm:
      hm[bRow[3]] = set()
    hm[bRow[3]].add(bRow[0])
  else:
    while pRow[2] == year:
      if pRow[3] not in hm:
        hm[pRow[3]] = set()
      hm[pRow[3]].add(pRow[0])
      pRow = pReader.next()
    for team, playerIds in hm.items():
      for playerId in playerIds:
        writer.writerow({'playerID': playerId, 'year': year, 'team': team})
    year = str(int(year) + 1)
    hm = {}
    hm[bRow[3]] = set()
    hm[bRow[3]].add(bRow[0])


if pRow[3] not in hm:
  hm[pRow[3]] = set()
hm[pRow[3]].add(pRow[0])
for pRow in pReader:
  if pRow[3] not in hm:
    hm[pRow[3]] = set()
  hm[pRow[3]].add(pRow[0])
for team, playerIds in hm.items():
  for playerId in playerIds:
    writer.writerow({'playerID': playerId, 'year': year, 'team': team})

writerFile.close()
