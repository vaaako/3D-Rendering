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


function quicksort(sectors, low, high)
	if low < high then
		local pivotIndex = partition(sectors, low, high)
		quicksort(sectors, low, pivotIndex - 1)
		quicksort(sectors, pivotIndex + 1, high)
	end
end

function partition(sectors, low, high)
	-- Based on distance (get highest distance)
	local pivot = sectors[high].d -- [!] Remove -1
	local i = low - 1 -- Index of smaller element

	for j = low, high - 1 do
		if sectors[j].d >= pivot then
			i = i + 1
			sectors[i], sectors[j] = sectors[j], sectors[i]
		end
	end

	sectors[i + 1], sectors[high] = sectors[high], sectors[i + 1]
	return i + 1
end


function bubblesort(sectors, high)
	for s = 0, high - 1 do
		for w = 0, high - s - 1 do
			if sectors[w].d < sectors[w + 1].d then
				local st = sectors[w]
				sectors[w] = sectors[w + 1]
				sectors[w + 1] = st
			end
		end
	end
end