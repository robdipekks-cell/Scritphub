local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

repeat task.wait() until game:IsLoaded()

-- ─────────────────────────────────────────
--  SERVICES & LOCALS
-- ─────────────────────────────────────────
local RS             = game:GetService("ReplicatedStorage")
local Players        = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService     = game:GetService("RunService")
local LocalPlayer    = Players.LocalPlayer
local Character      = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP            = Character:FindFirstChild("HumanoidRootPart")

-- Re-get HRP on respawn
LocalPlayer.CharacterAdded:Connect(function(c)
    Character = c
    HRP = c:WaitForChild("HumanoidRootPart")
end)

-- ─────────────────────────────────────────
--  TEAM ZONE HELPER
-- ─────────────────────────────────────────
local zoneMap = {
    black   = "BlackZone",
    green   = "CamoZone",
    magenta = "MagentaZone",
    yellow  = "New YellerZone",
    blue    = "Really blueZone",
    red     = "Really redZone",
    white   = "WhiteZone",
}
local function getPlayerZone(name)
    local p = Players:FindFirstChild(name)
    if p and p.Team and zoneMap[p.Team.Name] then
        return workspace:FindFirstChild(zoneMap[p.Team.Name])
    end
end

-- Equip tool helper
local function equipTool(toolName)
    if not Character:FindFirstChild(toolName) and LocalPlayer.Backpack:FindFirstChild(toolName) then
        LocalPlayer.Backpack[toolName].Parent = Character
    end
end

-- Build block data helper
local function getBlockData(name)
    local data = LocalPlayer:FindFirstChild("Data")
    if data then
        local block = data:FindFirstChild(name)
        if block then return block.Value, block.Used.Value end
    end
end

-- CFrame helper
local function toCFrame(pos, angle)
    return CFrame.new(pos) * CFrame.Angles(angle:ToEulerAnglesXYZ())
end

-- Get all team names
local teamNames = {}
for _, t in ipairs(workspace.Teams:GetChildren()) do
    table.insert(teamNames, t.Name)
end

-- Block names from ShopGui
local blockNames = {}
pcall(function()
    local scrollFrame = LocalPlayer.PlayerGui.ShopGui.MainFrame.TabFrame.ShopFrame.ScrollingFrameChests
    for _, frame in ipairs(scrollFrame:GetChildren()) do
        if frame:IsA("Frame") and not ({FrameEvent=1,Frame_001=1,Frame_002=1,Frame_003=1,Frame_018=1})[frame.Name] then
            for _, btn in ipairs(frame:GetChildren()) do
                if btn:IsA("ImageButton") and btn:FindFirstChild("TextLabel") then
                    local gi = btn.TextLabel:FindFirstChild("GoldImage")
                    if gi and gi.Image ~= "http://www.roblox.com/asset/?id=5471638266" then
                        table.insert(blockNames, btn.Name)
                    end
                end
            end
        end
    end
end)
if #blockNames == 0 then blockNames = {"(No blocks found)"} end

-- Robux items
local robuxItems = {
    ["Gold+"]              = 55535084,
    ["Gold++"]             = 55535112,
    ["Gold+++"]            = 55535174,
    ["Gold++++"]           = 1056486509,
    ["+100 Glass Blocks"]  = 139124094,
    ["+100 Wood Blocks"]   = 139124343,
    ["+100 Neon Blocks"]   = 507954328,
    ["+5 Mega Thrusters"]  = 139121474,
    ["+4 Huge Wheels"]     = 260358235,
    ["+5 Harpoons"]        = 315266520,
    ["+5 Golden Harpoons"] = 641075523,
    ["+5 Ultra Thrusters"] = 534134763,
    ["+3 Ultra Jetpacks"]  = 558757040,
    ["+3 Sonic Jet Turbines"] = 424770683,
    ["+4 Portals"]         = 811892987,
    ["+5 Dragon Harpoons"] = 1109792341,
    ["+5 Duel Harpoons"]   = 915766549,
    ["+4 Cookie Wheels"]   = 1126385328,
    ["+3 Egg Cannons"]     = 1161573715,
    ["+3 Ultra Boat Motors"] = 944487410,
    ["Double Gold"]        = 851864421,
    ["Fox Character"]      = 911518557,
    ["Penguin Character"]  = 911519585,
    ["Chicken Character"]  = 911521563,
}
local robuxNames = {}
for k in pairs(robuxItems) do table.insert(robuxNames, k) end

-- ─────────────────────────────────────────
--  WINDOW
-- ─────────────────────────────────────────
local Window = Fluent:CreateWindow({
    Title       = "Build a Boat",
    SubTitle    = "Hub by Oorbits",
    TabWidth    = 160,
    Size        = UDim2.fromOffset(620, 480),
    Acrylic     = true,
    Theme       = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

local Tabs = {
    Farm    = Window:AddTab({ Title = "Auto Farm",   Icon = "star" }),
    Build   = Window:AddTab({ Title = "Auto Build",  Icon = "layers" }),
    Shop    = Window:AddTab({ Title = "Shop",         Icon = "shopping-cart" }),
    Team    = Window:AddTab({ Title = "Team",         Icon = "users" }),
    Troll   = Window:AddTab({ Title = "Troll",        Icon = "zap" }),
    Events  = Window:AddTab({ Title = "Events",       Icon = "map-pin" }),
    Killer  = Window:AddTab({ Title = "Find Killer",  Icon = "eye" }),
}

-- ─────────────────────────────────────────
--  STATES
-- ─────────────────────────────────────────
local States = {
    farmSafe      = false,
    farmFast      = false,
    farmBlockFast = false,
    autoCrate     = false,
    autoBlock     = false,
    isolationLock = false,
    infGold       = false,
    loopColor     = false,
    loopDelete    = false,
    viewGrid      = false,
    findKiller    = false,
}

local instaLoad = false
local v34 = getrawmetatable(game)
pcall(function()
    setreadonly(v34, false)
    local orig = v34.__namecall
    v34.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "InvokeServer" and self.Name == "InstaLoadFunction" then
            instaLoad = true
        end
        return orig(self, ...)
    end)
end)

-- ─────────────────────────────────────────
--  AUTO FARM TAB
-- ─────────────────────────────────────────

Tabs.Farm:AddToggle("FarmSafe", {
    Title    = "Auto Farm Safe (Gold + Block)",
    Default  = false,
    Callback = function(v)
        States.farmSafe = v
        if v then
            task.spawn(function()
                local stages = workspace:WaitForChild("BoatStages"):WaitForChild("NormalStages")
                local lighting = game:GetService("Lighting")
                local function doRun()
                    local char = LocalPlayer.Character
                    for i = 1, 10 do
                        if not States.farmSafe then break end
                        local cave = stages["CaveStage" .. i]:FindFirstChild("DarknessPart")
                        if cave then
                            char.HumanoidRootPart.CFrame = cave.CFrame
                            local floor = Instance.new("Part", char)
                            floor.Anchored = true
                            floor.Transparency = 0.5
                            floor.Position = char.HumanoidRootPart.Position - Vector3.new(0, 6, 0)
                            task.wait(2)
                            floor:Destroy()
                        end
                    end
                    repeat
                        task.wait()
                        char.HumanoidRootPart.CFrame = stages.TheEnd.GoldenChest.Trigger.CFrame
                    until lighting.ClockTime ~= 14
                    local spawned = false
                    local conn
                    conn = LocalPlayer.CharacterAdded:Connect(function()
                        spawned = true
                        conn:Disconnect()
                    end)
                    repeat task.wait() until spawned
                    task.wait(5)
                end
                while States.farmSafe do
                    task.wait()
                    doRun()
                end
            end)
        end
    end
})

Tabs.Farm:AddToggle("FarmFast", {
    Title    = "Auto Gold (Fast)",
    Default  = false,
    Callback = function(v)
        States.farmFast = v
        if v then
            task.spawn(function()
                local stages = workspace:WaitForChild("BoatStages"):WaitForChild("NormalStages")
                repeat task.wait() until stages.CaveStage1.DarknessPart:FindFirstChild("Event")
                while States.farmFast do
                    for i = 1, 10 do
                        if not States.farmFast then break end
                        if i ~= 2 then
                            local cave = stages["CaveStage" .. i].DarknessPart
                            if cave then
                                local char = LocalPlayer.Character
                                char.HumanoidRootPart.CFrame = cave.CFrame
                                local floor = Instance.new("Part", char)
                                floor.Anchored = true
                                floor.Position = char.HumanoidRootPart.Position - Vector3.new(0, 6, 0)
                                task.delay(0.8, function()
                                    workspace.ClaimRiverResultsGold:FireServer()
                                end)
                                if i == 10 then
                                    local h = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):FindFirstChild("Humanoid")
                                    if h then h.Health = 0 end
                                else
                                    repeat task.wait()
                                    until LocalPlayer.OtherData["Stage" .. i].Value ~= "" or not States.farmFast
                                end
                            end
                        end
                    end
                    repeat task.wait() until instaLoad or not States.farmFast
                    instaLoad = false
                end
            end)
        end
    end
})

Tabs.Farm:AddToggle("FarmBlockFast", {
    Title    = "Auto Gold Block (Fast)",
    Default  = false,
    Callback = function(v)
        States.farmBlockFast = v
        if v then
            task.spawn(function()
                local stages = workspace:WaitForChild("BoatStages"):WaitForChild("NormalStages")
                while States.farmBlockFast do
                    task.wait()
                    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart")
                    if workspace.Gravity ~= 0 then workspace.Gravity = 0 end
                    hrp.CFrame = stages.CaveStage1.DarknessPart.CFrame
                    stages.CaveStage1.DarknessPart.Event:Fire()
                    repeat
                        task.wait()
                        hrp.CFrame = CFrame.new(hrp.CFrame.X - 10, hrp.CFrame.Y, hrp.CFrame.Z - 10)
                        task.wait(0.1)
                        hrp.CFrame = CFrame.new(hrp.CFrame.X + 10, hrp.CFrame.Y, hrp.CFrame.Z + 10)
                    until LocalPlayer.OtherData["Stage0"].Value ~= "" or not States.farmBlockFast
                    pcall(function()
                        firetouchinterest(hrp, stages.TheEnd.GoldenChest.Trigger, 1)
                        task.wait()
                        firetouchinterest(hrp, stages.TheEnd.GoldenChest.Trigger, 0)
                    end)
                    repeat task.wait() until instaLoad or not States.farmBlockFast
                    instaLoad = false
                    local c2 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local hrp2 = c2:WaitForChild("HumanoidRootPart")
                    workspace.ClaimRiverResultsGold:FireServer()
                    for i = 1, 10 do
                        repeat task.wait()
                        until LocalPlayer.OtherData["Stage" .. i - 1].Value == "" or not States.farmBlockFast
                    end
                end
                workspace.Gravity = 196.2
            end)
        end
    end
})

-- ─────────────────────────────────────────
--  AUTO BUILD TAB
-- ─────────────────────────────────────────

local teamToCopy = "white"
Tabs.Build:AddDropdown("BuildTeam", {
    Title    = "Select Team to Copy",
    Values   = {"white","black","blue","green","magenta","red","yellow"},
    Default  = "white",
    Callback = function(v) teamToCopy = v end,
})

local gridStuds = 1
Tabs.Build:AddSlider("GridStuds", {
    Title   = "Grid Studs (X/Y/Z)",
    Default = 1,
    Min     = 1,
    Max     = 100,
    Rounding = 0,
    Callback = function(v) gridStuds = v end,
})

-- Move grid helpers
local function moveGrid(offset)
    local folder = workspace:FindFirstChild("FolderGridLDSHUB")
    if folder then
        for _, model in ipairs(folder:GetChildren()) do
            if model:IsA("Model") then
                for _, part in ipairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CFrame = part.CFrame + offset
                    end
                end
            end
        end
    end
end

local function rotateGrid(angle)
    local folder = workspace:FindFirstChild("FolderGridLDSHUB")
    if not folder then return end
    local center = Vector3.new(0,0,0)
    local count  = 0
    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") then
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    center = center + part.Position
                    count  = count + 1
                end
            end
        end
    end
    if count == 0 then return end
    center = center / count
    local rot = CFrame.new(center) * CFrame.fromEulerAnglesXYZ(0, angle, 0) * CFrame.new(-center.X,-center.Y,-center.Z)
    for _, model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") then
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CFrame = rot * part.CFrame
                end
            end
        end
    end
end

Tabs.Build:AddButton({ Title = "Move -X", Callback = function() moveGrid(Vector3.new(-gridStuds, 0, 0)) end })
Tabs.Build:AddButton({ Title = "Move +X", Callback = function() moveGrid(Vector3.new( gridStuds, 0, 0)) end })
Tabs.Build:AddButton({ Title = "Move -Y", Callback = function() moveGrid(Vector3.new(0, -gridStuds, 0)) end })
Tabs.Build:AddButton({ Title = "Move +Y", Callback = function() moveGrid(Vector3.new(0,  gridStuds, 0)) end })
Tabs.Build:AddButton({ Title = "Move -Z", Callback = function() moveGrid(Vector3.new(0, 0, -gridStuds)) end })
Tabs.Build:AddButton({ Title = "Move +Z", Callback = function() moveGrid(Vector3.new(0, 0,  gridStuds)) end })
Tabs.Build:AddButton({ Title = "Rotate -90°", Callback = function() rotateGrid(math.rad(-90)) end })
Tabs.Build:AddButton({ Title = "Rotate +90°", Callback = function() rotateGrid(math.rad( 90)) end })

Tabs.Build:AddToggle("ViewGrid", {
    Title    = "View Grid (Selected Team)",
    Default  = false,
    Callback = function(v)
        States.viewGrid = v
        if v then
            local folder = workspace:FindFirstChild("FolderGridLDSHUB")
            if not folder then
                folder = Instance.new("Folder")
                folder.Name = "FolderGridLDSHUB"
                folder.Parent = workspace
            end
            for _, plr in ipairs(Players:GetChildren()) do
                if plr.Team and plr.Team.Name == teamToCopy then
                    local blocks = workspace.Blocks:FindFirstChild(plr.Name)
                    if blocks then
                        for _, model in ipairs(blocks:GetChildren()) do
                            if model:IsA("Model") and model:FindFirstChild("PPart") then
                                model:Clone().Parent = folder
                            end
                        end
                    end
                end
            end
        else
            local f = workspace:FindFirstChild("FolderGridLDSHUB")
            if f then f:Destroy() end
        end
    end
})

Tabs.Build:AddButton({
    Title    = "Build (Sync)",
    Callback = function()
        local folder = workspace:FindFirstChild("FolderGridLDSHUB")
        if not folder then Fluent:Notify({Title="Error", Content="View grid first!", Duration=3}) return end
        for _, model in ipairs(folder:GetChildren()) do
            if model:IsA("Model") and model:FindFirstChild("PPart") then
                local ppart = model.PPart
                local data, _ = getBlockData(model.Name)
                if data then
                    equipTool("BuildingTool")
                    Character.BuildingTool.RF:InvokeServer(model.Name, data, false, ppart.CFrame, ppart.Anchored, ppart.CFrame, false)
                    task.wait(0.1)
                    equipTool("ScalingTool")
                    Character.ScalingTool.RF:InvokeServer(model, ppart.Size, ppart.CFrame)
                    equipTool("PaintingTool")
                    Character.PaintingTool.RF:InvokeServer({{model, ppart.Color}, {model, ppart.Color}})
                end
            end
        end
        folder:Destroy()
        Fluent:Notify({Title="Build Done!", Content="Your build is complete.", Duration=4})
    end
})

Tabs.Build:AddButton({
    Title    = "Build (Fast)",
    Callback = function()
        local folder = workspace:FindFirstChild("FolderGridLDSHUB")
        if not folder then Fluent:Notify({Title="Error", Content="View grid first!", Duration=3}) return end
        local models = folder:GetChildren()
        for _, model in ipairs(models) do
            task.spawn(function()
                if model:IsA("Model") and model:FindFirstChild("PPart") then
                    local ppart = model.PPart
                    local data, _ = getBlockData(model.Name)
                    if data then
                        equipTool("BuildingTool")
                        Character.BuildingTool.RF:InvokeServer(model.Name, data, false, ppart.CFrame, ppart.Anchored, ppart.CFrame, false)
                    end
                end
            end)
            task.wait(0.05)
        end
        task.wait(0.5)
        folder:Destroy()
        Fluent:Notify({Title="Build Done!", Content="Fast build complete.", Duration=4})
    end
})

-- ─────────────────────────────────────────
--  SHOP TAB
-- ─────────────────────────────────────────

local selectedCrate = "Common Chest"
Tabs.Shop:AddDropdown("CratePick", {
    Title    = "Select Crate",
    Values   = {"Common Chest","Uncommon Chest","Rare Chest","Epic Chest","Legendary Chest"},
    Default  = "Common Chest",
    Callback = function(v) selectedCrate = v end,
})

local crateAmount = "1"
Tabs.Shop:AddInput("CrateAmount", {
    Title    = "Crate Amount",
    Default  = "1",
    Callback = function(v) crateAmount = v end,
})

Tabs.Shop:AddButton({
    Title    = "Buy Crate (Once)",
    Callback = function()
        workspace.ItemBoughtFromShop:InvokeServer(selectedCrate, tonumber(crateAmount) or 1)
    end
})

Tabs.Shop:AddToggle("AutoCrate", {
    Title    = "Auto Buy Crate",
    Default  = false,
    Callback = function(v)
        States.autoCrate = v
        if v then
            task.spawn(function()
                while States.autoCrate do
                    workspace.ItemBoughtFromShop:InvokeServer(selectedCrate, tonumber(crateAmount) or 1)
                    task.wait()
                end
            end)
        end
    end
})

local selectedBlock = blockNames[1] or "(No blocks found)"
Tabs.Shop:AddDropdown("BlockPick", {
    Title    = "Select Block",
    Values   = blockNames,
    Default  = blockNames[1] or "(No blocks found)",
    Callback = function(v) selectedBlock = v end,
})

local blockAmount = "1"
Tabs.Shop:AddInput("BlockAmount", {
    Title    = "Block Amount",
    Default  = "1",
    Callback = function(v) blockAmount = v end,
})

Tabs.Shop:AddButton({
    Title    = "Buy Block (Once)",
    Callback = function()
        workspace.ItemBoughtFromShop:InvokeServer(selectedBlock, tonumber(blockAmount) or 1)
    end
})

Tabs.Shop:AddToggle("AutoBlock", {
    Title    = "Auto Buy Block",
    Default  = false,
    Callback = function(v)
        States.autoBlock = v
        if v then
            task.spawn(function()
                while States.autoBlock do
                    workspace.ItemBoughtFromShop:InvokeServer(selectedBlock, tonumber(blockAmount) or 1)
                    task.wait()
                end
            end)
        end
    end
})

Tabs.Shop:AddButton({
    Title    = "Buy Pine Tree (80 Gold)",
    Callback = function()
        workspace.ItemBoughtFromShop:InvokeServer("PineTree", tonumber(blockAmount) or 1)
    end
})

local selectedRobux = robuxNames[1]
Tabs.Shop:AddDropdown("RobuxPick", {
    Title    = "Select Robux Item",
    Values   = robuxNames,
    Default  = robuxNames[1],
    Callback = function(v) selectedRobux = v end,
})

Tabs.Shop:AddButton({
    Title    = "Prompt Robux Item",
    Callback = function()
        workspace.PromptRobuxEvent:InvokeServer(robuxItems[selectedRobux], "Product")
    end
})

-- ─────────────────────────────────────────
--  TEAM TAB
-- ─────────────────────────────────────────

local selectedTeam = teamNames[1] or "white"
Tabs.Team:AddDropdown("TeamPick", {
    Title    = "Select Team",
    Values   = teamNames,
    Default  = teamNames[1] or "white",
    Callback = function(v) selectedTeam = v end,
})

Tabs.Team:AddButton({
    Title    = "Teleport to Team",
    Callback = function()
        local spawns = workspace.Teams[selectedTeam].Spawns:GetChildren()
        if #spawns > 0 then
            local cf = spawns[math.random(1, #spawns)].CFrame * CFrame.new(0, 5, 0)
            LocalPlayer.Character:SetPrimaryPartCFrame(cf)
        end
    end
})

Tabs.Team:AddButton({
    Title    = "Force Share Mode",
    Callback = function()
        workspace.SettingFunction:InvokeServer("ShareBlocks", true)
    end
})

Tabs.Team:AddToggle("IsolationLock", {
    Title    = "Remove Isolation Lock (All Teams)",
    Default  = false,
    Callback = function(v)
        States.isolationLock = v
        if v then
            task.spawn(function()
                local zones = {"BlackZone","CamoZone","MagentaZone","New YellerZone","Really blueZone","Really redZone","WhiteZone"}
                while States.isolationLock do
                    task.wait()
                    for _, zoneName in ipairs(zones) do
                        local zone = workspace:FindFirstChild(zoneName)
                        if zone then
                            local lock = zone:FindFirstChild("Lock")
                            if lock then lock:Destroy() end
                        end
                    end
                end
            end)
        end
    end
})

-- ─────────────────────────────────────────
--  TROLL TAB
-- ─────────────────────────────────────────

Tabs.Troll:AddToggle("InfGold", {
    Title    = "Infinite Gold (Visual)",
    Default  = false,
    Callback = function(v)
        States.infGold = v
        if v then
            task.spawn(function()
                for i = LocalPlayer.Data.Gold.Value, 100000000000 do
                    if not States.infGold then break end
                    LocalPlayer.Data.Gold.Value = LocalPlayer.Data.Gold.Value + i
                    task.wait(0.2)
                end
            end)
        end
    end
})

Tabs.Troll:AddToggle("LoopColor", {
    Title    = "Loop Color All Your Blocks",
    Default  = false,
    Callback = function(v)
        States.loopColor = v
        if v then
            task.spawn(function()
                while States.loopColor do
                    task.wait()
                    local teamName  = LocalPlayer.Team.Name
                    local leader    = game:GetService("Teams")[teamName].TeamLeader.Value
                    local myBlocks  = workspace.Blocks:FindFirstChild(leader)
                    if myBlocks then
                        local batch = {}
                        for _, block in ipairs(myBlocks:GetChildren()) do
                            table.insert(batch, {block, Color3.new(math.random(), math.random(), math.random())})
                            if #batch >= 10000 then
                                LocalPlayer.Backpack.PaintingTool.RF:InvokeServer(batch)
                                batch = {}
                            end
                        end
                        if #batch > 0 then
                            LocalPlayer.Backpack.PaintingTool.RF:InvokeServer(batch)
                        end
                    end
                end
            end)
        end
    end
})

Tabs.Troll:AddToggle("LoopDelete", {
    Title    = "Loop Delete All Blocks",
    Default  = false,
    Callback = function(v)
        States.loopDelete = v
        if v then
            task.spawn(function()
                while States.loopDelete do
                    task.wait()
                    workspace.ClearAllPlayersBoatParts:FireServer()
                end
            end)
        end
    end
})

Tabs.Troll:AddButton({
    Title    = "Delete All Blocks (Once)",
    Callback = function()
        workspace.ClearAllPlayersBoatParts:FireServer()
    end
})

-- ─────────────────────────────────────────
--  EVENTS TAB
-- ─────────────────────────────────────────

Tabs.Events:AddButton({
    Title    = "Teleport to Christmas",
    Callback = function() TeleportService:Teleport(1930866268, LocalPlayer) end
})

Tabs.Events:AddButton({
    Title    = "Teleport to Inner Cloud",
    Callback = function() TeleportService:Teleport(1930863474, LocalPlayer) end
})

Tabs.Events:AddButton({
    Title    = "Teleport to Halloween",
    Callback = function() TeleportService:Teleport(1930665568, LocalPlayer) end
})

-- ─────────────────────────────────────────
--  FIND KILLER TAB
-- ─────────────────────────────────────────

-- ESP helper: apply red highlight to a character
local espHighlights = {}

local function removeESP(name)
    if espHighlights[name] then
        espHighlights[name]:Destroy()
        espHighlights[name] = nil
    end
end

local function applyESP(character, name)
    removeESP(name)
    local highlight = Instance.new("Highlight")
    highlight.Name          = "KillerESP_" .. name
    highlight.FillColor     = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor  = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency    = 0.4
    highlight.OutlineTransparency = 0
    highlight.Adornee       = character
    highlight.Parent        = character
    espHighlights[name]     = highlight
end

local function clearAllESP()
    for name, hl in pairs(espHighlights) do
        pcall(function() hl:Destroy() end)
        espHighlights[name] = nil
    end
end

-- Info label
Tabs.Killer:AddInput("KillerFolderPath", {
    Title    = "Killer Folder Path (in workspace)",
    Default  = "KillerFolder",
    Callback = function() end, -- read live in toggle
})

Tabs.Killer:AddToggle("FindKiller", {
    Title    = "Find Killer (ESP Red)",
    Default  = false,
    Callback = function(v)
        States.findKiller = v
        if not v then
            clearAllESP()
            return
        end
        task.spawn(function()
            while States.findKiller do
                -- Read the folder path from input (default KillerFolder)
                local folderName = "KillerFolder"
                pcall(function()
                    local inp = Fluent.Options["KillerFolderPath"]
                    if inp and inp.Value and inp.Value ~= "" then
                        folderName = inp.Value
                    end
                end)

                local killerFolder = workspace:FindFirstChild(folderName)

                -- Remove ESP for players no longer in the folder
                for name in pairs(espHighlights) do
                    if not (killerFolder and killerFolder:FindFirstChild(name)) then
                        removeESP(name)
                    end
                end

                if killerFolder then
                    for _, item in ipairs(killerFolder:GetChildren()) do
                        local killerName = item.Name
                        local plr = Players:FindFirstChild(killerName)
                        if plr then
                            local char = plr.Character
                            if char then
                                -- Apply or refresh ESP
                                if not espHighlights[killerName] or not espHighlights[killerName].Parent then
                                    applyESP(char, killerName)
                                end
                                -- Notify once
                                if not espHighlights[killerName .. "_notified"] then
                                    espHighlights[killerName .. "_notified"] = true
                                    Fluent:Notify({
                                        Title   = "🔴 Killer Found!",
                                        Content = killerName .. " is the killer!",
                                        Duration = 6,
                                    })
                                end
                            end
                        else
                            -- Player not in server, remove stale
                            removeESP(killerName)
                        end
                    end
                end

                task.wait(0.5)
            end
        end)
    end
})

Tabs.Killer:AddButton({
    Title    = "Clear All ESP",
    Callback = function()
        clearAllESP()
        Fluent:Notify({Title="ESP Cleared", Content="All highlights removed.", Duration=3})
    end
})

-- ─────────────────────────────────────────
--  FINISH
-- ─────────────────────────────────────────

Window:SelectTab(1)

Fluent:Notify({
    Title    = "Hub Loaded",
    Content  = "Welcome, " .. LocalPlayer.Name .. "!",
    Duration = 5,
})
