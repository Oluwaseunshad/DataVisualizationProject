import csv

writerFile = open('TeamPerformanceScore.csv', mode='w')
fieldnames = ['year', 'teamid', 'score']
writer = csv.DictWriter(writerFile, fieldnames=fieldnames)
writer.writeheader()

score = 0

with open('Teams.csv', 'r') as readFile:
  reader = csv.reader(readFile, delimiter=',')
  line_count = 0
  for row in reader:
    if line_count == 0 or int(row[0]) < 2000 or int(row[0]) == 2017:
      line_count += 1
    else:
      win = float(row[8])
      loss = float(row[9])
      divwin = row[10]
      wcwin = row[11]
      lgwin = row[12]
      wswin = row[13]

      score = win / loss
      if divwin == "Y":
        score += 1
      elif wcwin == "Y":
        score += 0.8
      if lgwin == "Y":
        score += 1.5
      if wswin == "Y":
        score += 1
      print "%f %f %s %s %s %s -> %f" % (win, loss, divwin, wcwin, lgwin, wswin, score)

      writer.writerow({'year': row[0], 'teamid': row[2], 'score': score})
      line_count += 1

  print "Processed %d lines." % line_count

writerFile.close()
