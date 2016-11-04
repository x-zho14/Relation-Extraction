require "base"
print("1")
local f = io.open("nyt.bin")
ds=torch.load("dataset.dat")
words_mapping=ds.words_mapping
vecs={}

cnt=0
l=1
has_vec=0
words={}
local f = io.open("nyt.bin")
for each in f:lines() do 
	print(l.."lines")
	if l~=1 then
		local vec = {} 
		cn=1
		local word = nil
		for w in string.gmatch(each, "%S+") do
			if cn ==1 then
				word=w
				break
			end
		end
		vecs[word]=1
	end
	l=l+1
	if l%100000 == 0 then
		for k, v in pairs(words_mapping) do 
			if vecs[v]~=nil then
				print("word "..v)
				words[v]=1
			end
		end
		vecs={}
		collectgarbage()
	end
end
for k, v in pairs(words_mapping) do 
	if vecs[v]~=nil then
		print("word "..v)
		words[v]=1
	end
end
local f = io.open("words_in_corpus.txt","w")
for k, v in pairs(words) do 
	f:write(k.."\n")
end