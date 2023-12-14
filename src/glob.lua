--[[
	I dont know what name to put here, but are functions
	and tables used globally
]]

-- Precompute angles
-- [!] Two structs (MATH_SIN[360], MATH_COS[360])
MATH_SIN = {}
for i = 0, 360 do
	MATH_SIN[i] = math.sin(math.rad(i))
end

MATH_COS = {}
for i = 0, 360 do
	MATH_COS[i] = math.cos(math.rad(i))
end


function partition(sectors, low, numSect)
	local pivot = sectors[numSect].d
	local i = low - 1

	for j = low, numSect - 1 do
		if sectors[j].d >= pivot then
			i = i + 1
			sectors[i], sectors[j] = sectors[j], sectors[i]
		end
	end

	sectors[i + 1], sectors[numSect] = sectors[numSect], sectors[i + 1]
	return i + 1
end

function quicksort(sectors, low, numSect)
	if low < numSect then
		local pivotIndex = partition(sectors, low, numSect)
		quicksort(sectors, low, pivotIndex - 1)
		quicksort(sectors, pivotIndex + 1, numSect)
	end
end

function bubblesort(sectors, numSect)
	for s = 0, numSect - 1 do
		for w = 0, numSect - s do
			if sectors[w].d < sectors[w + 1].d then
				local st = sectors[w]
				sectors[w] = sectors[w + 1]
				sectors[w + 1] = st
			end
		end
	end
end