require 'cunn'
require 'cutorch'

words_mapping = {}
local mapping_f = io.open("mapping")
for each in mapping_f:lines() do
	for k,v in string.gmatch(each,"(%d+) (.+)") do
		words_mapping[k] = v
	end
end
type_mapping = {}
local mapping_f = io.open("type_mapping")
for each in mapping_f:lines() do
	for k,v in string.gmatch(each,"(%d+) (.+)") do
		type_mapping[k] = v
	end
end 
maxLen=50
length_distribute={}
lines = {}
r_lines={}
lineNumber = {}
local lines_f = io.open("lines")
targets_types = {}
local targets_f = io.open("type_lines")
local i=1
if_picked = {}
for each in lines_f:lines() do
	local line = {}
	local r_line={}
	local string_length = 0
	for k in string.gmatch(each,"(%d+)") do
		string_length=string_length+1
	end
	if string_length<=50 then
		local index=1
		for k in string.gmatch(each,"(%d+)") do	
			line[maxLen-string_length+index]=k
			r_line[maxLen-index+1]=k
			index=index+1
		end
		for i=1,maxLen-string_length,1 do
			line[i]=0
			r_line[i]=0
		end
		length_distribute[#line]=length_distribute[#line] or 0
		length_distribute[#line]=1+length_distribute[#line]
		lines[#lines+1] = line
		r_lines[#r_lines+1]=r_line
		lineNumber[#lineNumber+1]=i
		if_picked[i]=1
	end
	i=i+1
end
print (lines[1])
print (r_lines[1])
i=1
for each in targets_f:lines() do
	if if_picked[i] == 1 then
		for k in string.gmatch(each,"(%d+)") do
			targets_types[#targets_types+1] = k
		end
	end
	i=i+1
end  

ds={}
ds.size=#lines
ds.input=lines
ds.r_input=r_lines
ds.target=torch.CudaTensor(targets_types)
ds.lineNumber=lineNumber
ds.type_mapping=type_mapping
ds.words_mapping=words_mapping
torch.save("dataset.dat",ds)
