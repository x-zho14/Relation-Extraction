import re

f = open('TRAIN_FILE.TXT', 'r')
i=1
output1 = open('train.eng', 'w')

for line in f.readlines():
    if i%4==1:
        m1 = re.search(r"\"(.*)\"", line)
        line=m1.group(1)
        output1.write(line+"\n")
    i=i+1
print i
