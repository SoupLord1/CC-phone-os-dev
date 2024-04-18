local util = {}

function util.tableMerge(table1, table2, result)
	for _, v in ipairs(table1) do
		table.insert(result, v)
	end
	for _, v in ipairs(table2) do
		table.insert(result, v)
	end
end

return util