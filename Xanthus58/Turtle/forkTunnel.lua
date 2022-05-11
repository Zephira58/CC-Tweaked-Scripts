term.clear()
beforeFuel = tonumber(0)
beforeFuel = turtle.getFuelLevel()

print("-Information-")
print("`forkTunnel` created by `Xanthus58`")
print("Version: 1.4")
print(" ")
print("-Status-")

if not turtle then
    printError("Requires a Turtle")
    return
end

local tArgs = { ... }

if #tArgs ~= 2 then
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage: " .. programName .. " <length> <skiptoo>")
    return
end

-- Mine in a quarry pattern until we hit something we can't dig

local length = tonumber(tArgs[1])
local skiptoo = tonumber(tArgs[2])
if length < 1 then
    print("Tunnel length must be positive")
    return
end

local collected = 0

local function collect()
    collected = collected + 1
    if math.fmod(collected, 25) == 0 then
        print("Mined " .. collected .. " items.")
    end
end

local function tryDig()
    while turtle.detect() do
        if turtle.dig() then
            collect()
            sleep(0.5)
        else
            return false
        end
    end
    return true
end

local function tryDigUp()
    while turtle.detectUp() do
        if turtle.digUp() then
            collect()
            sleep(0.5)
        else
            return false
        end
    end
    return true
end

local function tryDigDown()
    while turtle.detectDown() do
        if turtle.digDown() then
            collect()
            sleep(0.5)
        else
            return false
        end
    end
    return true
end

local function refuel()
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel == "unlimited" or fuelLevel > 0 then
        return
    end

    local function tryRefuel()
        for n = 1, 16 do
            if turtle.getItemCount(n) > 0 then
                turtle.select(n)
                if turtle.refuel(1) then
                    turtle.select(1)
                    return true
                end
            end
        end
        turtle.select(1)
        return false
    end

    if not tryRefuel() then
        print("Add more fuel to continue.")
        while not tryRefuel() do
            os.pullEvent("turtle_inventory")
        end
        print("Resuming Tunnel.")
    end
end

local function tryUp()
    refuel()
    while not turtle.up() do
        if turtle.detectUp() then
            if not tryDigUp() then
                return false
            end
        elseif turtle.attackUp() then
            collect()
        else
            sleep(0.5)
        end
    end
    return true
end

local function tryDown()
    refuel()
    while not turtle.down() do
        if turtle.detectDown() then
            if not tryDigDown() then
                return false
            end
        elseif turtle.attackDown() then
            collect()
        else
            sleep(0.5)
        end
    end
    return true
end

local function tryForward()
    refuel()
    while not turtle.forward() do
        depth = depth + 1
        if turtle.detect() then
            if not tryDig() then
                return false
            end
        elseif turtle.attack() then
            collect()
        else
            sleep(0.5)
        end
    end
    return true
end

homeskip = skiptoo
toaldist = length + skiptoo

torchdist = tonumber(7)
torchtotal = tonumber(0)
print("Mining...")
tryDig()
turtle.forward()
for n = 1, length do
    if skiptoo > 0 then
        print("Skipping " .. skiptoo .. " blocks...")
    end
        while skiptoo > 0 do
            tryDig()
            turtle.forward()
            skiptoo = skiptoo - 1
        end
    if torchdist > 8 then
        turtle.select(2)
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.forward()
        turtle.up()
        turtle.turnRight()
        turtle.place(2)
        print("Placing Torch...")
        turtle.down()
        turtle.turnRight()
        turtle.forward()
        torchdist = tonumber(0)
        torchtotal = torchtotal + 1
    end
    turtle.placeDown()
    tryDigUp()
    turtle.turnLeft()
    tryDig()
    tryUp()
    tryDig()
    turtle.turnRight()
    turtle.turnRight()
    tryDig()
    tryDown()
    tryDig()
    turtle.turnLeft()
    torchdist = torchdist + 1
    if n < length then
        tryDig()
        if not tryForward() then
            print("Aborting Tunnel.")
            break
        end
    else
        print("Tunnel complete.")
    end

end


print( "Returning to dock..." )

-- Return to where we started
turtle.turnLeft()
turtle.turnLeft()

turtle.forward()
while homeskip > 0 do
    tryDig()
    turtle.forward()
    homeskip = homeskip -1
end

while length > 1 do
    turtle.forward()
    length = length - 1
end

turtle.turnRight()
turtle.turnRight()

term.clear()

afterFuel = tonumber(0)
afterFuel = turtle.getFuelLevel()

coalFuel = beforeFuel - afterFuel
coalUse = coalFuel / 80

print("-Logs-")
print("Docked At Starting Postition")
print(" ")
print("Mined " .. collected .. " items total")
print(torchtotal .. " Torches Placed")
print(coalFuel .. " Fuel Used or " .. coalUse .. " coal")
print("Traveled " .. toaldist .. " blocks")
print(" ")
print("`forkTunnel` created by Xanthus58")
print("Version: 1.4")

-- https://pastebin.com/jpfRk9PK