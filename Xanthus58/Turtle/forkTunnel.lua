term.clear()
beforeFuel = tonumber(0)
beforeFuel = turtle.getFuelLevel()

print("-Information-")
print("`forkTunnel` created by `Xanthus58`")
print("Version: 1.5")
print("")
print("-Instructions-")
print("Ensure slot 1 is full of coal")
print("Ensure slot 2 is full of torches")
print("Ensure slot 4-5 is empty")
sleep(5)
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

torch_error = 0
local function torchPlace()
    if torchdist > 8 then
        turtle.select(2)
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.forward()
        turtle.up()
        turtle.turnRight()
        turtle.forward()
        if turtle.detect() == false then
            print("Invalid surface to place torch. Skipping...")
            turtle.turnRight()
            turtle.turnRight()
            turtle.forward()
            turtle.turnLeft()
            turtle.down()
            turtle.forward()
            torch_error = torch_error + 1
        else
            turtle.turnRight()
            turtle.turnRight()
            turtle.forward()
            turtle.turnLeft()
            turtle.turnLeft()
            turtle.place(2)
            print("Placing Torch...")
            turtle.down()
            turtle.turnRight()
            turtle.forward()
            torchtotal = torchtotal + 1
        end
        torchdist = tonumber(0)
    end
end

blocks_placed = 0
local function detectCave()
    if turtle.detectDown() == false then
        turtle.select(3)
        if turtle.getItemCount(3) == 0 then
            turtle.select(4)
        end
        turtle.placeDown()
        turtle.turnRight()
        turtle.forward()
        turtle.placeDown()
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.forward()
        turtle.forward()
        turtle.placeDown()
        turtle.turnRight()
        turtle.turnRight()
        turtle.forward()
        turtle.turnLeft()
        blocks_placed = blocks_placed + 3
    end
end

homeskip = skiptoo
toaldist = length + skiptoo

torchdist = tonumber(7)
torchtotal = tonumber(0)

print("Mining...")
tryDig()
turtle.forward()
for n = 1, length do
    refuel()
    if skiptoo > 0 then
        print("Skipping " .. skiptoo .. " blocks...")
    end
    while skiptoo > 0 do
        tryDig()
        detectCave()
        turtle.forward()
        skiptoo = skiptoo - 1
    end
    torchPlace()
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
    detectCave()
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
    detectCave()
    turtle.forward()
    homeskip = homeskip -1
end

while length > 1 do
    tryDig()
    detectCave()
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
print("Docked at starting postition.")
print(" ")
print(collected .. " Mined items.")
print(blocks_placed .. " Blocks placed.")
print(torch_error .. " Torches failed to place.")
print(torchtotal .. " Torches placed.")
print(coalFuel .. " Fuel used or " .. coalUse .. " coal.")
print(toaldist .. " Blocks traveled.")
print(" ")
print("`forkTunnel` created by Xanthus58")
print("Version: 1.5")

-- https://pastebin.com/jpfRk9PK