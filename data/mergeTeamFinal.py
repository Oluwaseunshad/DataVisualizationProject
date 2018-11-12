import csv

writerFile = open('TeamFinal.csv', mode='w')
fieldnames = ['year', 'teamid', 'teamname', 'salary', 'score', 'finalscore', 'lgid', 'franchid', 'divid', 'rank', 'w', 'l', 'divwin', 'wcwin', 'lgwin', 'wswin', 'r', 'hr']
writer = csv.DictWriter(writerFile, fieldnames=fieldnames)
writer.writeheader()

teamFile = open('Teams.csv', 'r')
rankFile = open('TeamRank.csv', 'r')

tReader = csv.reader(teamFile, delimiter=',')
rReader = csv.reader(rankFile, delimiter=',')

year = ""
teamList = []

tRow = tReader.next()
rRow = rReader.next()

for tRow in tReader:
  if int(tRow[0]) < 2000 or int(tRow[0]) > 2016:
    continue

  elif year == "":
    year = tRow[0]
    teamList.append([tRow[2], tRow[40], tRow[1], tRow[3], tRow[4], tRow[5], tRow[8], tRow[9], tRow[10], tRow[11], tRow[12], tRow[13], tRow[14], tRow[19]])

  elif year == tRow[0]:
    teamList.append([tRow[2], tRow[40], tRow[1], tRow[3], tRow[4], tRow[5], tRow[8], tRow[9], tRow[10], tRow[11], tRow[12], tRow[13], tRow[14], tRow[19]])

  else:
    for i in range(0, 10):
      rRow = rReader.next()
      for items in teamList:
        if rRow[1] == items[0]:
          writer.writerow({'year': year, 'teamid': items[0], 'teamname': items[1], 'salary': rRow[2], 'score': rRow[3], 'finalscore': rRow[4], 'lgid': items[2], 'franchid': items[3], 'divid': items[4], 'rank': items[5], 'w': items[6], 'l': items[7], 'divwin': items[8], 'wcwin': items[9], 'lgwin': items[10], 'wswin': items[11], 'r': items[12], 'hr': items[13]})
          break
    year = tRow[0]
    teamList = []
    teamList.append([tRow[2], tRow[40], tRow[1], tRow[3], tRow[4], tRow[5], tRow[8], tRow[9], tRow[10], tRow[11], tRow[12], tRow[13], tRow[14], tRow[19]])

for i in range(0, 10):
  rRow = rReader.next()
  for items in teamList:
    if rRow[1] == items[0]:
      writer.writerow({'year': year, 'teamid': items[0], 'teamname': items[1], 'salary': rRow[2], 'score': rRow[3], 'finalscore': rRow[4], 'lgid': items[2], 'franchid': items[3], 'divid': items[4], 'rank': items[5], 'w': items[6], 'l': items[7], 'divwin': items[8], 'wcwin': items[9], 'lgwin': items[10], 'wswin': items[11], 'r': items[12], 'hr': items[13]})
      break

writerFile.close()
