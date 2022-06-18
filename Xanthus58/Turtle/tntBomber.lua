term.clear()

local tArgs = { ... }

if #tArgs ~= 1 then
    local programName = arg[0] or fs.getName(shell.getRunningProgram())
    print("Usage: " .. programName .. " <height>")
    return
end
height = tonumber(tArgs[1])
if height < 1 then
    print("Tunnel height must be above 0")
    return
end

print("-Information-")
print("`tntBomber` created by `Xanthus58`")
print("Version: 1.0.0")
print("")
print("-Instructions-")
print("Ensure slot 1 has a flint and steel")
print("Ensure slot 2 is full of tnt")
sleep(5)
print(" ")
print("-Status-")



while height > 0 do
    turtle.up()
    skyhigh = true
    print("Going up ".. height .. " Blocks")
    height = height -1
end

height = tonumber(tArgs[1])

if skyhigh == true then
    print("Skyhigh has been reached")
    turtle.select(2)
    turtle.place()
    print("Placing tnt..")
    turtle.select(1)
    turtle.up()
    turtle.place()
    print("Lighting tnt...")
    sleep(7)
    turtle.down()
    while height > 0 do
        print("Going down "..height.." blocks")
        turtle.down()
        landed = true
        height = height -1
    end
end
term.clear()