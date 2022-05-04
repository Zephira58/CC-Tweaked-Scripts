term.clear()
beforeFuel = tonumber(0)
beforeFuel = turtle.getFuelLevel()

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

afterFuel = tonumber(0)
afterFuel = turtle.getFuelLevel()

coalFuel = beforeFuel - afterFuel
coalUse = coalFuel / 80
term.clear()
print("-Logs-")
print("Mined " .. collected .. " items total")
print(coalFuel .. " Fuel Used or " .. coalUse .. " coal")
print(" ")
print("`forkTunnel` created by Xanthus58")
