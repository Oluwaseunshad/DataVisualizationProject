import csv

writerFile = open('TeamTotalSalary.csv', mode='w')
fieldnames = ['year', 'teamid', 'totalsalary']
writer = csv.DictWriter(writerFile, fieldnames=fieldnames)
writer.writeheader()

testOutput = 0
year = ""
pre = ""
total = 0

with open('Salaries.csv', 'r') as csv_file:
  reader = csv.reader(csv_file, delimiter=',')
  line_count = 0
  for row in reader:
    if line_count == 0 or int(row[0]) < 2000:
      line_count += 1
    else:
      if pre == "":
        year = row[0]
        pre = row[1]
        total = int(row[4])
      elif pre == row[1]:
        total += int(row[4])
      else:
        print "%s %s %d" % (year, pre, total) 
        writer.writerow({'year': year, 'teamid': pre, 'totalsalary': total})
        year = row[0]
        pre = row[1]
        total = int(row[4])
      line_count += 1
  print "%s %s %d" % (year, pre, total) 
  writer.writerow({'year': year, 'teamid': pre, 'totalsalary': total})
  print "Processed %d lines." % line_count

writerFile.close()
