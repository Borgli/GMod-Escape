
resource.AddWorkshop("156921981") -- Dementor Playermodel: http://steamcommunity.com/sharedfiles/filedetails/?id=156921981
resource.AddWorkshop("400762901") -- Arkham Origins Joker NPC/Playermodel: http://steamcommunity.com/sharedfiles/filedetails/?id=400762901
resource.AddWorkshop("448581592") -- Han Solo and Chewbacca Playermodels: http://steamcommunity.com/sharedfiles/filedetails/?id=448581592
resource.AddWorkshop("112806637") -- GMod Legs: http://steamcommunity.com/sharedfiles/filedetails/?id=112806637
resource.AddWorkshop("144982052") -- M9K Specialties: http://steamcommunity.com/sharedfiles/filedetails/?id=144982052
resource.AddWorkshop("244540803") -- Customizable Flashlight: http://steamcommunity.com/sharedfiles/filedetails/?id=244540803
--resource.AddFile("models/player/bobert/joker.mdl")
resource.AddFile("sound/wilhelm.wav") -- Wilhelm Death Sound
resource.AddFile("sound/he/lull-01-lullnotnull.mp3") -- Creepy ambience
resource.AddFile("models/weapons/c_flashlight_zm.mdl")

--[[function AddDir(dir)

    local list = file.FindDir("../"..dir.."/*")

    for _, fdir in pairs(list) do

        if fdir ~= ".svn" then

        AddDir(dir.."/"..fdir)

        end

    end

    for k,v in pairs(file.Find(dir.."/*", true)) do

        resource.AddFile(dir.."/"..v)

    end

end]]--

--[[ Add directory containing multiple files ]]--
--[[
AddDir("materials/effects/flashlight")
AddDir("materials/weapons")
AddDir("materials/models/weapons/flashlight_zm")
--]]