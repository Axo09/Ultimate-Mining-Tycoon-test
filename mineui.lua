setrobloxinput(true)

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Mouse = lp:GetMouse()
local workspace = game:GetService("Workspace")

-- Estado de la UI
local CurrentPickaxeStrength = 7
local CurrentMinValue = 100
local CurrentMaxDist = 100

local picksStrength = {
    ["Rusty"] = 7, ["Copper"] = 12, ["Iron"] = 20, ["Steel"] = 35, ["Platinum"] = 60,
    ["Titanium"] = 100, ["Infernum"] = 200, ["Diamond"] = 400, ["Mithril"] = 600,
    ["Adamantium"] = 800, ["Unobtainium"] = 1000
}

local ores = {
    ["Tin I"] = {v = 10, r = 6}, ["Iron"] = {v = 20, r = 6}, ["Lead"] = {v = 30, r = 7},
    ["Cobalt"] = {v = 50, r = 12}, ["Aluminium"] = {v = 65, r = 18}, ["Silver"] = {v = 150, r = 18},
    ["Uranium"] = {v = 180, r = 18}, ["Vanadium"] = {v = 240, r = 22}, ["Tungsten"] = {v = 300, r = 45},
    ["Gold"] = {v = 350, r = 22}, ["Titanium"] = {v = 400, r = 24}, ["Molybdenum"] = {v = 600, r = 75},
    ["Plutonium"] = {v = 1000, r = 99}, ["Palladium"] = {v = 1200, r = 120}, ["Mithril"] = {v = 2000, r = 200},
    ["Thorium"] = {v = 3200, r = 270}, ["Iridium"] = {v = 3700, r = 180}, ["Adamantium"] = {v = 4500, r = 300},
    ["Rhodium"] = {v = 15000, r = 300}, ["Unobtainium"] = {v = 30000, r = 340},
    ["Topaz"] = {v = 75, r = 6}, ["Emerald"] = {v = 200, r = 14}, ["Sapphire"] = {v = 250, r = 14},
    ["Ruby"] = {v = 300, r = 18}, ["Diamond"] = {v = 1500, r = 22}, ["Poudretteite"] = {v = 1700, r = 75},
    ["Zultanite"] = {v = 2300, r = 110}, ["Grandidierite"] = {v = 4500, r = 120}, ["Musgravite"] = {v = 5800, r = 150},
    ["Painite"] = {v = 12000, r = 200}
}

-- Teletransporte corregido para Matcha VM (3 argumentos)
local function TeleportTo(pos)
    local char = lp.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(pos.X, pos.Y, pos.Z)
        end
    end
end

---------------------------------------------------------------------------
-- UI DRAWING
---------------------------------------------------------------------------
local Main_window = Drawing.new("Square")
Main_window.Visible = true
Main_window.Filled = true
Main_window.Color = Color3.fromHex("#060b5b")
Main_window.Position = Vector2.new(32, 40)
Main_window.Size = Vector2.new(507, 334)
Main_window.ZIndex = 10

local Title_BG = Drawing.new("Square")
Title_BG.Visible = true
Title_BG.Filled = true
Title_BG.Color = Color3.fromHex("#250ecd")
Title_BG.Position = Main_window.Position
Title_BG.Size = Vector2.new(507, 23)
Title_BG.ZIndex = 20

local Title = Drawing.new("Text")
Title.Visible = true
Title.Text = "Ultimate Mining Tycoon Esp"
Title.Size = 22
Title.Color = Color3.new(1, 1, 1)
Title.Position = Main_window.Position + Vector2.new(94, 0)
Title.Outline = true
Title.ZIndex = 30

-- Botones Teleport
local Plot_Btn = Drawing.new("Square")
Plot_Btn.Visible = true
Plot_Btn.Filled = true
Plot_Btn.Color = Color3.fromHex("#250ecd")
Plot_Btn.Size = Vector2.new(104, 21)
Plot_Btn.Position = Main_window.Position + Vector2.new(180, 68)
Plot_Btn.ZIndex = 40

local Shop_Btn = Drawing.new("Square")
Shop_Btn.Visible = true
Shop_Btn.Filled = true
Shop_Btn.Color = Color3.fromHex("#250ecd")
Shop_Btn.Size = Vector2.new(104, 21)
Shop_Btn.Position = Main_window.Position + Vector2.new(396, 68)
Shop_Btn.ZIndex = 40

local Mine_Btn = Drawing.new("Square")
Mine_Btn.Visible = true
Mine_Btn.Filled = true
Mine_Btn.Color = Color3.fromHex("#250ecd")
Mine_Btn.Size = Vector2.new(104, 21)
Mine_Btn.Position = Main_window.Position + Vector2.new(288, 68)
Mine_Btn.ZIndex = 40

-- Sliders
local Slider_Val = Drawing.new("Square")
Slider_Val.Visible = true
Slider_Val.Filled = true
Slider_Val.Color = Color3.fromHex("#444444")
Slider_Val.Size = Vector2.new(464, 10)
Slider_Val.Position = Main_window.Position + Vector2.new(21, 162)
Slider_Val.ZIndex = 50

local Knob_Val = Drawing.new("Square")
Knob_Val.Visible = true
Knob_Val.Filled = true
Knob_Val.Color = Color3.fromHex("#2b00ff")
Knob_Val.Size = Vector2.new(20, 20)
Knob_Val.Position = Slider_Val.Position + Vector2.new(0, -5)
Knob_Val.ZIndex = 51

local Slider_Dist = Drawing.new("Square")
Slider_Dist.Visible = true
Slider_Dist.Filled = true
Slider_Dist.Color = Color3.fromHex("#444444")
Slider_Dist.Size = Vector2.new(464, 10)
Slider_Dist.Position = Main_window.Position + Vector2.new(21, 267)
Slider_Dist.ZIndex = 50

local Knob_Dist = Drawing.new("Square")
Knob_Dist.Visible = true
Knob_Dist.Filled = true
Knob_Dist.Color = Color3.fromHex("#2b00ff")
Knob_Dist.Size = Vector2.new(20, 20)
Knob_Dist.Position = Slider_Dist.Position + Vector2.new(0, -5)
Knob_Dist.ZIndex = 51

---------------------------------------------------------------------------
-- LÓGICA ESP
---------------------------------------------------------------------------
local cache = {}
task.spawn(function()
    while true do
        task.wait(0.01)
        local rendered = {}
        local char = lp.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local myPos = char.HumanoidRootPart.Position
            local folder = workspace:FindFirstChild("PlacedOre")
            if folder then
                for _, ore in pairs(folder:GetChildren()) do
                    if ore:IsA("MeshPart") then
                        local d = (ore.Position - myPos).Magnitude
                        if d <= CurrentMaxDist then
                            local mId = ore:GetAttribute("MineId")
                            local info = ores[mId]
                            if info and info.v >= CurrentMinValue and CurrentPickaxeStrength >= info.r then
                                local sPos, onScreen = WorldToScreen(ore.Position)
                                if onScreen then
                                    if not cache[ore] then
                                        local t = Drawing.new("Text")
                                        t.Size = 14
                                        t.Center = true
                                        t.Outline = true
                                        cache[ore] = t
                                    end
                                    local t = cache[ore]
                                    t.Visible = true
                                    t.Position = sPos
                                    t.Text = mId .. " [$" .. tostring(info.v) .. "]"
                                    t.Color = (info.r >= CurrentPickaxeStrength * 0.8) and Color3.new(1,0,0) or Color3.new(0,1,0)
                                    rendered[ore] = true
                                end
                            end
                        end
                    end
                end
            end
        end
        for o, t in pairs(cache) do
            if not rendered[o] then
                t.Visible = false
                if not o or not o.Parent then t:Remove() cache[o] = nil end
            end
        end
    end
end)

---------------------------------------------------------------------------
-- INPUT LOOP
---------------------------------------------------------------------------
local dragging = nil
local lastM1 = false

while true do
    task.wait(0.01)
    local m1 = ismouse1pressed()
    local mPos = Vector2.new(Mouse.X, Mouse.Y)

    if m1 and not lastM1 then
        -- Shop
        if mPos.X >= Shop_Btn.Position.X and mPos.X <= Shop_Btn.Position.X + 104 and
           mPos.Y >= Shop_Btn.Position.Y and mPos.Y <= Shop_Btn.Position.Y + 21 then
            TeleportTo(Vector3.new(-1550, 10, 20))
        end
        -- Mine
        if mPos.X >= Mine_Btn.Position.X and mPos.X <= Mine_Btn.Position.X + 104 and
           mPos.Y >= Mine_Btn.Position.Y and mPos.Y <= Mine_Btn.Position.Y + 21 then
            TeleportTo(Vector3.new(-1889, 7, -193))
        end
        -- Plot
        if mPos.X >= Plot_Btn.Position.X and mPos.X <= Plot_Btn.Position.X + 104 and
           mPos.Y >= Plot_Btn.Position.Y and mPos.Y <= Plot_Btn.Position.Y + 21 then
            local pId = tostring(lp:GetAttribute("PlotId"))
            local plots = workspace:FindFirstChild("Plots")
            if plots then
                local myPlot = plots:FindFirstChild(pId)
                if myPlot and myPlot:FindFirstChild("Centre") then
                    TeleportTo(myPlot.Centre.Position)
                end
            end
        end
        -- Drag Knobs
        if mPos.X >= Knob_Val.Position.X and mPos.X <= Knob_Val.Position.X + 20 and mPos.Y >= Knob_Val.Position.Y and mPos.Y <= Knob_Val.Position.Y + 20 then
            dragging = "Val"
        elseif mPos.X >= Knob_Dist.Position.X and mPos.X <= Knob_Dist.Position.X + 20 and mPos.Y >= Knob_Dist.Position.Y and mPos.Y <= Knob_Dist.Position.Y + 20 then
            dragging = "Dist"
        end
    end

    if not m1 then dragging = nil end

    if dragging == "Val" then
        local x = math.clamp(mPos.X, Slider_Val.Position.X, Slider_Val.Position.X + 464)
        Knob_Val.Position = Vector2.new(x - 10, Slider_Val.Position.Y - 5)
        CurrentMinValue = ((x - Slider_Val.Position.X) / 464) * 15000
    elseif dragging == "Dist" then
        local x = math.clamp(mPos.X, Slider_Dist.Position.X, Slider_Dist.Position.X + 464)
        Knob_Dist.Position = Vector2.new(x - 10, Slider_Dist.Position.Y - 5)
        CurrentMaxDist = ((x - Slider_Dist.Position.X) / 464) * 30000
    end

    lastM1 = m1
end
