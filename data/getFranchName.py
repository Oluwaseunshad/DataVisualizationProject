import csv

writerFile = open('TeamFinal2.csv', mode='w')
fieldnames = ['year', 'teamid', 'teamname', 'salary', 'score', 'finalscore', 'lgid', 'franchname', 'divid', 'rank', 'w', 'l', 'divwin', 'wcwin', 'lgwin', 'wswin', 'r', 'hr']
writer = csv.DictWriter(writerFile, fieldnames=fieldnames)
writer.writeheader()

finalFile = open('TeamFinal.csv', 'r')
franchFile = open('TeamsFranchises.csv', 'r')

finalReader = csv.reader(finalFile, delimiter=',')
franchReader = csv.reader(franchFile, delimiter=',')

franchList = []

franchRow = franchReader.next()
for franchRow in franchReader:
  franchList.append([franchRow[0], franchRow[1]])

finalRow = finalReader.next()
for finalRow in finalReader:
  id = finalRow[7]
  for items in franchList:
    if items[0] == id:
      writer.writerow({'year': finalRow[0], 'teamid': finalRow[1], 'teamname': finalRow[2], 'salary': finalRow[3], 'score': finalRow[4], 'finalscore': finalRow[5], 'lgid': finalRow[6], 'franchname': items[1], 'divid': finalRow[8], 'rank': finalRow[9], 'w': finalRow[10], 'l': finalRow[11], 'divwin': finalRow[12], 'wcwin': finalRow[13], 'lgwin': finalRow[14], 'wswin': finalRow[15], 'r': finalRow[16], 'hr': finalRow[17]})
      break

writerFile.close()
