local numberetters = {}

local alphabet = "abcdefghijklmnopqrstuvwxyz"
local special = " 1234567890-=~`!@#$%^&*()_+[]{}\\|;:\'\",.<>/?"

local encoded = {{'s1', 'd2', 'f3', 'g4', 'h5'}, {'n1', 'm2'}, {'v1', 'b2', 'n3', 'm4'},      --a-c
{'f1', 'g2', 'h3', 'j4', 'k5'}, {'r1', 't2', 'y3', 'u4', 'i5'},              --d-e
{'g1', 'h2', 'j3', 'k4', 'l5'}, {'h1', 'j2', 'k3', 'l4'}, {'j1', 'k2', 'l3'},--f-h
{'o1', 'p2'}, {'k1', 'l2'}, {'l1'}, {'l0'}, {'m0'}, {'m1'}, {'p1'}, {'p0'},  --i-p
{'w1', 'e2', 'r3', 't4', 'y5'}, {'t1', 'y2', 'u3', 'i4', 'o5'},              --q-r
{'d1', 'f2', 'g3', 'h4', 'j5'}, {'y1', 'u2', 'i3', 'o4', 'p5'},              --s-t
{'i1', 'o2', 'p3'}, {'b1', 'n2', 'm3'}, {'e1', 'r2', 't3', 'y4', 'u5'},      --u-w
{'c1', 'v2', 'b3', 'n4', 'm5'}, {'u1', 'i2', 'o3', 'p4'},                    --v-y
{'x1', 'c2', 'v3', 'b4', 'n5'}}                                            --w-z

function numberetters.encoding(message)
    local enchars = {}
    local output = ''

    for i = 1, string.len(message) + 1 do
        local char = string.sub(message, i, i)
        local upper = false

        if char == string.upper(char) then
            upper = true
            char = string.lower(char)
        end

        for j = 1, string.len(alphabet) do
            local letter = string.sub(alphabet, j, j)

            if char == letter then
                if upper then
                    table.insert(enchars, string.upper(encoded[j][math.random(1, #encoded[j])]))
                else
                    table.insert(enchars, encoded[j][math.random(1, #encoded[j])])
                end
            end
		end

        if string.match(special, char) then
            table.insert(enchars, char)
        end
	end

    output = table.concat(enchars)

    return output
end

local function check_m2(i, message)
    local _ = string.sub(message, i+1, i+1)
    return true
end



function numberetters.decoding(message)
    local dechars = {}
    local output = ''
    local i = 1

    while i < string.len(message) + 1 do
        local upper = false
        local m1, m2 = string.sub(message, i, i), ""
        local err, status = pcall(check_m2(i, message))

        if status then
            m2 = string.sub(message, i+1, i+1)
        else
			m2 = ""
		end

        if m1 == string.upper(m1) then
            upper = true
            m1 = string.lower(m1)
        end

        if string.match(alphabet, m1) then
            for j = 1, #encoded do
                for k = 1, #encoded[j] do
                    if m1..m2 == encoded[j][k] then
                        if upper then
                            table.insert(dechars, string.upper(string.sub(alphabet, j, j)))
                        else
                            table.insert(dechars, string.sub(alphabet, j, j))
						end
                    end
                end
            end
            i = i + 2
        else
            table.insert(dechars, m1)
            i = i + 1
        end
    end
    output = table.concat(dechars)

    return output
end

return numberetters