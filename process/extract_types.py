import re

f = open('TRAIN_FILE.TXT', 'r')
i=1
type_s = set([])
type_l = []
for line in f.readlines():
    if i%4 == 2:
        m1 = re.search(r"(.*)\r\n", line)
        line = m1.group(1)
        type_l.append(line)
        type_s.add(line)
    i=i+1
output3 = open('type_lines', 'w')
output4 = open('type_mapping', 'w')
type_d={}
count=1
for i in type_s:
    type_d[i]=count
    output4.write(str(count) + " " + i + "\n")
    count=count+1
for w in type_l:
    output3.write(str(type_d[w])+"\n")
