import os, sys
import string
f = open("train.filter", "r")
g = open("train.format", "w")
for line in f:
	seg = line.strip()
	s = ""
	i=0
	while(i<len(seg)):
		if seg[i]=='<' and seg[i+3]=='>':
			s += " "
			s +=seg[i:i+4]
			s += " "
			i = i + 4
			continue
		if seg[i]=='<' and seg[i+4]=='>':
			s += " "
			s += seg[i:i + 5]
			s += " "
			i = i + 5
			continue
		if (seg[i] in string.punctuation and seg[i]!='_'):
			s += " "
		s += seg[i]
		if (seg[i] in string.punctuation and seg[i]!='_'):
			s += " "
		i=i+1
	g.write(s+"\n")
f.close()
g.close()


