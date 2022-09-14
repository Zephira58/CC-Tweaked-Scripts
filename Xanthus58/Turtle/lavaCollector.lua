term.clear()
beforeFuel = tonumber(0)
beforeFuel = turtle.getFuelLevel()
computerLabel = os.getComputerLabel()

print("-Information-")
print("`Lava Collector` created by `Xanthus58`")
print("Version: 1.0.0")
print("")
print("-Instructions-")
print("Ensure slot 1 is full of coal")
print("Ensure slot 2 is full of buckets")
os.setComputerLabel("Waiting...")
print("\nPress any key once your ready...")
os.pullEvent("key")
term.clear()
print("-Status-")

traveledBlocks = 0
totalTraveld = 0
if not turtle then
    printError("Requires a Turtle")
    return
end

local tArgs = { ... }

if #tArgs ~= 1 then
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage: " .. programName .. " <length>")
    return
end
local length = tonumber(tArgs[1])
local return_dist = 0
local back_dist = 0

local function goBack() 
    for x = 1, back_dist do
        turtle.forward()
    end
end

local function return_home()
    turtle.turnLeft()
    turtle.turnLeft()
    for i = 1, return_dist do
        back_dist = back_dist + 1
    end
    if fullDetect == true then
        turtle.forward()
    end
    turtle.turnRight()
    turtle.turnRight() 
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

local function invcheck()
    local fullDetect = true
    for n = 2,16 do
        slotCount = turtle.getItemCount(n)
        if slotCount == 0 then
            fullDetect = false
        end
    end
    if fullDetect then
        print("No empty slots left...")
        return_home()
        os.setComputerLabel("Inventory Full...")
        print("Press any key to continue mining")
        os.pullEvent("key")
        goBack()
    end
end



turtle.select(2)
-- Main program body
for n = 1, length do
    refuel()
    turtle.forward()
    turtle.placeDown()
    invcheck()
    length = length - 1
    return_dist = return_dist + 1
end
if length == 0 then
    return_home()
end

term.clear()

afterFuel = turtle.getFuelLevel()
coalFuel = beforeFuel - afterFuel
coalUse = coalFuel / 80

print("-Logs-")
print(coalFuel .. " Fuel used or " .. coalUse .. " coal.")
print("`Lava Collector` created by Xanthus58")
print("Version: 1.0.0")

-- https://pastebin.com/jpfRk9PK