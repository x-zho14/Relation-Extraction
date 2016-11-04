import re
f_words_in_corpus = open('words_in_corpus.txt','r')
words_in_corpus = {}
for line in f_words_in_corpus.readlines():
    line = line.strip()
    words_in_corpus[line]=1
print words_in_corpus
words_in_corpus["<e1>"]=1
words_in_corpus["</e1>"]=1
words_in_corpus["<e2>"]=1
words_in_corpus["</e2>"]=1

f = open('train.format', 'r')
i=1
s = set([])
l=[]
type_s = set([])
type_l = []
for line in f.readlines():
    templ = line.split()
    i = 0
    while(i<len(templ)):
        if not words_in_corpus.has_key(templ[i]):
            templ[i] = 'UNK'
        i = i+1
    l.append(templ)
for templ in l:
    s |= set(templ)

print(len(s))
output1 = open('lines', 'w')
output2 = open('mapping', 'w')
d = {}
r_d={}
count=1
for i in s:
    print(i)
    d[i]=count
    r_d[count]=i
    count=count+1
n = []
for templ in l:
    tempn = []
    for s in templ:
        tempn.append(d[s])
    n.append(tempn)
for tempn in n:
    for i in tempn:
        output1.write(str(i)+" ")
    output1.write("\n")
for w,i in d.items():
    output2.write(str(i)+" "+w+"\n")

