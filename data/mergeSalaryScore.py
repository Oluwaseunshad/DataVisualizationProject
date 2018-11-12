import csv

writerFile = open('TeamSalaryScore.csv', mode='w')
fieldnames = ['year', 'teamid', 'salary', 'score']
writer = csv.DictWriter(writerFile, fieldnames=fieldnames)
writer.writeheader()

performanceFile = open('TeamPerformanceScore.csv', 'r')
salaryFile = open('TeamTotalSalary.csv', 'r')

pReader = csv.reader(performanceFile, delimiter=',')
sReader = csv.reader(salaryFile, delimiter=',')

line_count = 0

sRow = sReader.next()
for pRow in pReader:
  if line_count == 0:
    line_count += 1
    sRow = sReader.next()
  else:
    writer.writerow({'year': sRow[0], 'teamid': sRow[1], 'salary': sRow[2], 'score': pRow[2]})
    if sRow[0] != pRow[0] or sRow[1] != pRow[1]:
      print "%s %s %s %s" % (sRow[0], sRow[1], pRow[0], pRow[1])
    try:
      sRow = sReader.next()
    except:
      print ""
    line_count += 1

print "Processed %d lines." % line_count

writerFile.close()
