term.clear()

print("-Information-")
print("`autoMiner` created by `Xanthus58`")
print("Version: 1.1")
print(" ")
print("-Status-")
print(" ")
print("Mining...")

local collected = 0

local function collect()
    collected = collected + 1
    if math.fmod(collected, 1) == 0 then
        print("Mined " .. collected .. " items.")
    end
end

while turtle.detect() == true do
    turtle.dig()
    collect()
end

term.clear()
print("-Logs-")
print("Mined " .. collected .. " items")
print(" ")
print("`autoMiner` created by Xanthus58")
print("Version: 1.1")

--https://pastebin.com/Y7tsMdeY