require "base"
require 'cunn'
require 'cutorch'
print("1")
local f = io.open("nyt.bin")
vecSize=200
wordsNum=23193
ds=torch.load("dataset.dat")
words_mapping=ds.words_mapping
vecs={}

vec_mapping=torch.CudaTensor(wordsNum,vecSize)
--vec_mapping=torch.randn(22407,vecSize)
--vec_mapping:cuda()
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
			else
				vec[#vec+1]=w
			end
			cn=cn+1
		end
		vecs[word]=vec
	end
	l=l+1
	if l%100000 == 0 then
		for k, v in pairs(words_mapping) do 
			if vecs[v]~=nil then
				print("word "..v)
				vec_mapping[k]=torch.CudaTensor(vecs[v])
				has_vec=has_vec+1
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
		vec_mapping[k]=torch.CudaTensor(vecs[v])
		has_vec=has_vec+1
		words[v]=1
	end
end
print(has_vec.."words")
cn=1
for k,v in pairs(words_mapping) do 
	if words[v]~=1 then
		print("miss"..v)
		vec_mapping[k]=torch.randn(200)
		vec_mapping[k]:cuda()
		cn=cn+1
	end
end
print("miss"..cn.."words")
vecs={}
collectgarbage()
print(has_vec.."words")

input_vec=torch.CudaTensor(ds.size,50,vecSize)
r_input_vec=torch.CudaTensor(ds.size,50,vecSize)
for k1, v1 in pairs(ds.input) do
	for k2, v2 in pairs(v1) do
		if v2 == 0 then
			input_vec[k1][k2]:zero()
			input_vec[k1][k2]:cuda()
		else
			input_vec[k1][k2]=vec_mapping[v2]:clone()
			input_vec[k1][k2]:cuda()
		end
	end
end

for k1, v1 in pairs(ds.r_input) do
	for k2, v2 in pairs(v1) do
		if v2 == 0 then
			r_input_vec[k1][k2]:zero()
			r_input_vec[k1][k2]:cuda()
		else
			r_input_vec[k1][k2]=vec_mapping[v2]:clone()
			r_input_vec[k1][k2]:cuda()
		end
	end
end
ds.vec_mapping=vec_mapping
ds.input_vec=input_vec
ds.r_input_vec=r_input_vec
ds.input = torch.CudaTensor(ds.input)

torch.save("dataset.dat",ds)