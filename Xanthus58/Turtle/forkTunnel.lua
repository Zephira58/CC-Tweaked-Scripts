term.clear()
beforeFuel = tonumber(0)
beforeFuel = turtle.getFuelLevel()
computerLabel = os.getComputerLabel()

print("-Information-")
print("`forkTunnel` created by `Xanthus58`")
print("Version: 1.6.0")
print("")
print("-Instructions-")
print("Ensure slot 1 is full of coal")
print("Ensure slot 2 is full of torches")
os.setComputerLabel("Waiting...")
print("\nPress any key once your ready...")
os.pullEvent("key")
term.clear()
print("-Status-")

traveledBlocks = 0
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
local skipedblocks = skiptoo
if length < 0 then
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
local function torchPlaceUpgraded()
    if torchdist > 8 then turtle.select(2)
        turtle.place()
        if turtle.detect() == false then
            torch_error = torch_error + 1
        else
            os.setComputerLabel("Placing torch...")
            print("Placing torch...")
            torchtotal = torchtotal + 1
        torchdist = 0
        end
    end
end

blocks_placed = 0
local function bridge()
    if turtle.detectDown() == false then
        for n = 3, 16 do
            turtle.select(n)
            if turtle.detectDown() == false then
                if turtle.getItemCount(n) > 1 then
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
        end
    end
end

local function returnHome()
    os.setComputerLabel("Returning...")
    print( "Returning to dock..." )
    turtle.turnLeft()
    turtle.turnLeft()
    if length == 0 then 
        turtle.forward()
    end
    return_dist = traveledBlocks
    while return_dist > 0 do
        refuel()
        tryDig()
        bridge()
        turtle.forward()
        return_dist = return_dist - 1
    end
    turtle.turnRight()
    turtle.turnRight()
    if skiptoo > 0 then
        turtle.forward()
    end
end

--local unloaded = 0
--local function unload(_bKeepOneFuelStack)
--    print("Unloading items...")
--    for n = 3, 16 do
--        local nCount = turtle.getItemCount(n)
--        if nCount > 0 then
--            turtle.select(n)
--            local bDrop = true
--            if _bKeepOneFuelStack and turtle.refuel(0) then
--                bDrop = false
--                _bKeepOneFuelStack = false
--            end
--            if bDrop then
--                turtle.drop()
--                unloaded = unloaded + nCount
--            end
--        end
--    end
--    collected = 0
--    turtle.select(1)
--    print("All items unloaded...")
--end

local function goBack()
    print("Returning to mine...")
    os.setComputerLabel("Returning to mine...")
    goback = traveledBlocks
    while goback > 0 do
        turtle.forward()
        goback = goback -1
    end
    os.setComputerLabel("Mining...")
end

local function invcheck()
    local fullDetect = true
    for n = 3,16 do
        slotCount = turtle.getItemCount(n)
        if slotCount == 0 then
            fullDetect = false
        end
    end
    if fullDetect then
        print("No empty slots left...")
        returnHome()
        os.setComputerLabel("Inventory Full...")
        print("Press any key to continue mining")
        os.pullEvent("key")
        goBack()
    end
end 

torchdist = tonumber(7)
torchtotal = tonumber(0)

if skiptoo > 0 then
    print("Skipping " .. skiptoo .. " blocks...")
    os.setComputerLabel("Skipping...")
end

while skiptoo > 0 do
    refuel()
    tryDig()
    bridge()
    turtle.forward()
    skiptoo = skiptoo - 1
    traveledBlocks = traveledBlocks + 1
end

print("Mining...")
os.setComputerLabel("Mining...")
tryDig()
turtle.forward()
for n = 1, length do
    refuel()
    tryDigUp()
    turtle.turnLeft()
    tryDig()
    tryUp()
    tryDig()
    torchPlaceUpgraded()
    turtle.turnRight()
    turtle.turnRight()
    tryDig()
    tryDown()
    tryDig()
    turtle.turnLeft()
    bridge()
    torchdist = torchdist + 1
    traveledBlocks = traveledBlocks + 1
    invcheck()
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

returnHome()

os.setComputerLabel(computerLabel)

term.clear()

afterFuel = turtle.getFuelLevel()
coalFuel = beforeFuel - afterFuel
coalUse = coalFuel / 80

print("-Logs-")
print("Docked at starting postition.\n")
print(collected .. " Mined items.")
print(blocks_placed .. " Blocks placed.")
print(torch_error .. " Torches failed to place.")
print(torchtotal .. " Torches placed.")
print(coalFuel .. " Fuel used or " .. coalUse .. " coal.")
print(traveledBlocks .. " Blocks traveled.\n")
print("`forkTunnel` created by Xanthus58")
print("Version: 1.6.0")

-- https://pastebin.com/jpfRk9PK