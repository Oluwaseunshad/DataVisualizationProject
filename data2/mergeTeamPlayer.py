import csv

writerFile = open('TeamPlayer.csv', mode='w')
fieldnames = ['playerID', 'year', 'team']
writer = csv.DictWriter(writerFile, fieldnames=fieldnames)
writer.writeheader()

bFile = open('Batting.csv', 'r')
fFile = open('Fielding.csv', 'r')
pFile = open('Pitching.csv', 'r')

bReader = csv.reader(bFile, delimiter=',')
fReader = csv.reader(fFile, delimiter=',')
pReader = csv.reader(pFile, delimiter=',')

year = "2000"
hm = {}

bRow = bReader.next()
fRow = fReader.next()
fRow = fReader.next()
pRow = pReader.next()
pRow = pReader.next()

for bRow in bReader:
  if bRow[1] == year:
    if bRow[3] not in hm:
      hm[bRow[3]] = set()
    hm[bRow[3]].add(bRow[0])
  else:
    while fRow[1] == year:
      if fRow[3] not in hm:
        hm[fRow[3]] = set()
      hm[fRow[3]].add(fRow[0])
      fRow = fReader.next()

    while pRow[1] == year:
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


if fRow[3] not in hm:
  hm[fRow[3]] = set()
hm[fRow[3]].add(fRow[0])
for fRow in fReader:
  if fRow[3] not in hm:
    hm[fRow[3]] = set()
  hm[fRow[3]].add(fRow[0])

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
