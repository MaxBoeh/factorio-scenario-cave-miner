local index = {
"DE333","DE333_2","DE333_3","DE333_4","DE333_5","DE333_6","DE333_7","DE333_8","DE333_9","DE333_10",
"DE333_11","DE333_12","DE333_13","DE333_14","DE333_15","DE333_16","DE333_17","DE333_18","DE333_19","DE333_20",
"DE333_21","DE333_22","DE333_23","DE333_24","DE333_25","DE333_26","DE333_27","DE333_28","DE333_29","DE333_30",
"DE333_31","DE333_32","DE333_33","DE333_34"
 }

local data = {}
for _, i in pairs(index) do
	table.insert(data, require ("session_data." .. i))
end
return data
