import csv

writerFile = open('TeamRank.csv', mode='w')
fieldnames = ['year', 'teamid', 'salary', 'score', 'finalscore']
writer = csv.DictWriter(writerFile, fieldnames=fieldnames)
writer.writeheader()

file = open('TeamSalaryScore.csv', 'r')
reader = csv.reader(file, delimiter=',')

# maxSalary = 0

# row = reader.next()
# for row in reader:
#   if int(row[2]) > maxSalary:
#     maxSalary = int(row[2])

avgSalary = []
sumSalary = 0
count = 1

row = reader.next()
for row in reader:
  sumSalary += int(row[2])
  if count % 30 == 0:
    avgSalary.append(sumSalary / 30.0)
    sumSalary = 0
  count += 1

for s in avgSalary:
  print(s)



# print "maxSalary is %d" % maxSalary

line_count = 1
preYear = "" 
rowList = []

def sortByScore(elem):
  return elem[3]

file.seek(0)
row = reader.next()
for row in reader:
  if preYear == "":
    preYear = row[0]
    rowList = []
    rowList.append([row[1], row[2], row[3], (avgSalary[(line_count - 1) / 30] / float(row[2]) - 1) * 1.5 + float(row[3])])
    line_count += 1
  elif preYear != row[0]:
    rowList.sort(key=sortByScore, reverse=True)
    rowList = rowList[0:30]
    for items in rowList:
      writer.writerow({'year': preYear, 'teamid': items[0], 'salary': items[1], 'score': items[2], 'finalscore': items[3]})
    print rowList
    print ""

    preYear = row[0]
    rowList = []
    rowList.append([row[1], row[2], row[3], (avgSalary[(line_count - 1) / 30] / float(row[2]) - 1) * 1.5 + float(row[3])])
    line_count += 1
  else:
    rowList.append([row[1], row[2], row[3], (avgSalary[(line_count - 1) / 30] / float(row[2]) - 1) * 1.5 + float(row[3])])
    line_count += 1

rowList.sort(key=sortByScore, reverse=True)
rowList = rowList[0:30]
for items in rowList:
  writer.writerow({'year': preYear, 'teamid': items[0], 'salary': items[1], 'score': items[2], 'finalscore': items[3]})
print rowList
print ""
print "Processed %d lines." % line_count

writerFile.close()
