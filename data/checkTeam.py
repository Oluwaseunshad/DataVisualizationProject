import csv

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
    if sRow[0] != pRow[0] or sRow[1] != pRow[1]:
      print "%s %s %s %s" % (sRow[0], sRow[1], pRow[0], pRow[1])
    try:
      sRow = sReader.next()
    except:
      print ""
    line_count += 1

print "Processed %d lines." % line_count
