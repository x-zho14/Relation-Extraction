import esm

'''
index = esm.Index()
index.enter("a d")
index.enter("abc")
index.fix()
a =  index.query("sdfdjslfjsdlfjlabd a dsdfjlka d")
for i in range(0, len(a)):
	print a[i][0][0],a[i][0][1]
'''

index = esm.Index()

f = open("entity.txt", "r")
i=0
for line in f:
	seg = line.strip()
	if (' ' in seg):
		index.enter(seg)
	i=i+1
	if (i%1000 == 0) :
		print i
f.close()
index.fix()

f = open("train.eng","r")
g = open("train.filter","w")
step = 0
for line in f:
	seg = line.strip()
	a = index.query(seg)
	j = 0
	n = len(a)
	s = ""
	for i in range(0, len(seg)):
		if j<n and i>=a[j][0][1]:
			j+=1
		if seg[i]==' ' and j<n and i>=a[j][0][0]:
			s+="_"
			continue
		s+=seg[i]
	step+=1
	if (step%10000==0):
		print step
	g.write(s+"\n")
f.close()
g.close()
