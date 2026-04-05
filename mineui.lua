-- Optimizacion de entrada para Matcha
setrobloxinput(true)

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Mouse = lp:GetMouse()
local workspace = game:GetService("Workspace")

-- Configuración de Filtros (Se actualizan con la UI)
local CurrentPickaxeStrength = 7
local CurrentMinValue = 100
local CurrentMaxDist = 100

-- Tablas de Datos
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

-- Funciones de Utilidad
local function TeleportTo(pos)
    local char = lp.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(pos)
        end
    end
end

---------------------------------------------------------------------------
-- UI DRAWING (Matcha VM)
---------------------------------------------------------------------------
local Main_window = Drawing.new("Square")
Main_window.Visible = true
Main_window.Transparency = 1
Main_window.ZIndex = 10
Main_window.Color = Color3.fromHex("#060b5b")
Main_window.Position = Vector2.new(32, 40)
Main_window.Size = Vector2.new(507, 334)
Main_window.Filled = true

local Title_Background = Drawing.new("Square")
Title_Background.Visible = true
Title_Background.Transparency = 1
Title_Background.ZIndex = 20
Title_Background.Color = Color3.fromHex("#250ecd")
Title_Background.Position = Main_window.Position
Title_Background.Size = Vector2.new(507, 23)
Title_Background.Filled = true

local Title = Drawing.new("Text")
Title.Visible = true
Title.ZIndex = 30
Title.Color = Color3.new(1, 1, 1)
Title.Position = Main_window.Position + Vector2.new(94, 0)
Title.Text = "Ultimate Mining Tycoon Esp"
Title.Size = 22
Title.Outline = true
Title.Font = Drawing.Fonts.Monospace

-- [ SECCIÓN PICKAXE ]
local Pickaxe_Selection = Drawing.new("Square")
Pickaxe_Selection.Visible = true
Pickaxe_Selection.Color = Color3.fromHex("#250ecd")
Pickaxe_Selection.Filled = true
Pickaxe_Selection.Size = Vector2.new(134, 24)
Pickaxe_Selection.Position = Main_window.Position + Vector2.new(8, 67)
Pickaxe_Selection.ZIndex = 40

local Pickaxe_Selection_Text = Drawing.new("Text")
Pickaxe_Selection_Text.Visible = true
Pickaxe_Selection_Text.Text = "Rusty"
Pickaxe_Selection_Text.Size = 19
Pickaxe_Selection_Text.Color = Color3.new(1, 1, 1)
Pickaxe_Selection_Text.Position = Pickaxe_Selection.Position + Vector2.new(5, 2)
Pickaxe_Selection_Text.ZIndex = 42

-- [ SECCIÓN SLIDERS ]
local Min_Value_Slider = Drawing.new("Square")
Min_Value_Slider.Visible = true
Min_Value_Slider.Color = Color3.fromHex("#444444")
Min_Value_Slider.Filled = true
Min_Value_Slider.Size = Vector2.new(464, 10)
Min_Value_Slider.Position = Main_window.Position + Vector2.new(21, 162)
Min_Value_Slider.ZIndex = 60

local Min_Value_Knob = Drawing.new("Square")
Min_Value_Knob.Visible = true
Min_Value_Knob.Color = Color3.fromHex("#2b00ff")
Min_Value_Knob.Filled = true
Min_Value_Knob.Size = Vector2.new(20, 20)
Min_Value_Knob.Position = Min_Value_Slider.Position + Vector2.new(0, -5)
Min_Value_Knob.ZIndex = 61

local Render_Dist_Slider = Drawing.new("Square")
Render_Dist_Slider.Visible = true
Render_Dist_Slider.Color = Color3.fromHex("#444444")
Render_Dist_Slider.Filled = true
Render_Dist_Slider.Size = Vector2.new(464, 10)
Render_Dist_Slider.Position = Main_window.Position + Vector2.new(21, 267)
Render_Dist_Slider.ZIndex = 110

local Render_Dist_Knob = Drawing.new("Square")
Render_Dist_Knob.Visible = true
Render_Dist_Knob.Color = Color3.fromHex("#2b00ff")
Render_Dist_Knob.Filled = true
Render_Dist_Knob.Size = Vector2.new(20, 20)
Render_Dist_Knob.Position = Render_Dist_Slider.Position + Vector2.new(0, -5)
Render_Dist_Knob.ZIndex = 111

-- [ BOTONES TELEPORT ]
local Plot_Teleport = Drawing.new("Square")
Plot_Teleport.Visible = true
Plot_Teleport.Color = Color3.fromHex("#250ecd")
Plot_Teleport.Filled = true
Plot_Teleport.Size = Vector2.new(104, 21)
Plot_Teleport.Position = Main_window.Position + Vector2.new(180, 68)
Plot_Teleport.ZIndex = 120

local Plot_Text = Drawing.new("Text")
Plot_Text.Visible = true
Plot_Text.Text = "Your Plot"
Plot_Text.Size = 17
Plot_Text.Center = true
Plot_Text.Color = Color3.new(1, 1, 1)
Plot_Text.Position = Plot_Teleport.Position + Vector2.new(52, 2)
Plot_Text.ZIndex = 122

local Shop_Teleport = Drawing.new("Square")
Shop_Teleport.Visible = true
Shop_Teleport.Color = Color3.fromHex("#250ecd")
Shop_Teleport.Filled = true
Shop_Teleport.Size = Vector2.new(104, 21)
Shop_Teleport.Position = Main_window.Position + Vector2.new(396, 68)
Shop_Teleport.ZIndex = 130

local Mine_Teleport = Drawing.new("Square")
Mine_Teleport.Visible = true
Mine_Teleport.Color = Color3.fromHex("#250ecd")
Mine_Teleport.Filled = true
Mine_Teleport.Size = Vector2.new(104, 21)
Mine_Teleport.Position = Main_window.Position + Vector2.new(288, 68)
Mine_Teleport.ZIndex = 140

---------------------------------------------------------------------------
-- LÓGICA DE ESP
---------------------------------------------------------------------------
local espCache = {}
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
                        local dist = (ore.Position - myPos).Magnitude
                        if dist <= CurrentMaxDist then
                            local mId = ore:GetAttribute("MineId")
                            local oreData = ores[mId]
                            
                            if oreData and oreData.v >= CurrentMinValue and CurrentPickaxeStrength >= oreData.r then
                                local pos, onScreen = WorldToScreen(ore.Position)
                                if onScreen then
                                    if not espCache[ore] then
                                        local t = Drawing.new("Text")
                                        t.Size = 14
                                        t.Center = true
                                        t.Outline = true
                                        espCache[ore] = t
                                    end
                                    local t = espCache[ore]
                                    t.Visible = true
                                    t.Position = pos
                                    t.Text = mId .. " [$" .. tostring(oreData.v) .. "]"
                                    t.Color = (oreData.r >= CurrentPickaxeStrength * 0.8) and Color3.new(1, 0, 0) or Color3.new(0, 1, 0)
                                    rendered[ore] = true
                                end
                            end
                        end
                    end
                end
            end
        end

        for obj, txt in pairs(espCache) do
            if not rendered[obj] then
                txt.Visible = false
                if not obj or not obj.Parent then
                    txt:Remove()
                    espCache[obj] = nil
                end
            end
        end
    end
end)

---------------------------------------------------------------------------
-- BUCLE PRINCIPAL (INPUT Y UI)
---------------------------------------------------------------------------
local dragging = nil
local dragStart = nil
local startPos = nil
local lastMouse1 = false

while true do
    task.wait(0.01)
    local mouse1 = ismouse1pressed()
    local mPos = Vector2.new(Mouse.X, Mouse.Y)

    if mouse1 and not lastMouse1 then
        -- Teleport Tienda
        if mPos.X >= Shop_Teleport.Position.X and mPos.X <= Shop_Teleport.Position.X + 104 and
           mPos.Y >= Shop_Teleport.Position.Y and mPos.Y <= Shop_Teleport.Position.Y + 21 then
            TeleportTo(Vector3.new(-1550, 10, 20))
        end

        -- Teleport Mina
        if mPos.X >= Mine_Teleport.Position.X and mPos.X <= Mine_Teleport.Position.X + 104 and
           mPos.Y >= Mine_Teleport.Position.Y and mPos.Y <= Mine_Teleport.Position.Y + 21 then
            TeleportTo(Vector3.new(-1889, 7, -193))
        end

        -- Teleport Plot Personalizado
        if mPos.X >= Plot_Teleport.Position.X and mPos.X <= Plot_Teleport.Position.X + 104 and
           mPos.Y >= Plot_Teleport.Position.Y and mPos.Y <= Plot_Teleport.Position.Y + 21 then
            local pId = tostring(lp:GetAttribute("PlotId"))
            local plots = workspace:FindFirstChild("Plots")
            if plots then
                local myPlot = plots:FindFirstChild(pId)
                if myPlot and myPlot:FindFirstChild("Centre") then
                    TeleportTo(myPlot.Centre.Position)
                end
            end
        end

        -- Iniciar Arrastre de Sliders
        if mPos.X >= Min_Value_Knob.Position.X and mPos.X <= Min_Value_Knob.Position.X + 20 and
           mPos.Y >= Min_Value_Knob.Position.Y and mPos.Y <= Min_Value_Knob.Position.Y + 20 then
            dragging = "MinVal"
        elseif mPos.X >= Render_Dist_Knob.Position.X and mPos.X <= Render_Dist_Knob.Position.X + 20 and
               mPos.Y >= Render_Dist_Knob.Position.Y and mPos.Y <= Render_Dist_Knob.Position.Y + 20 then
            dragging = "MaxDist"
        end
    end

    if not mouse1 then dragging = nil end

    -- Lógica de arrastre de Sliders
    if dragging == "MinVal" then
        local newX = math.clamp(mPos.X, Min_Value_Slider.Position.X, Min_Value_Slider.Position.X + 464)
        Min_Value_Knob.Position = Vector2.new(newX - 10, Min_Value_Slider.Position.Y - 5)
        local ratio = (newX - Min_Value_Slider.Position.X) / 464
        CurrentMinValue = math.floor(ratio * 15000)
    elseif dragging == "MaxDist" then
        local newX = math.clamp(mPos.X, Render_Dist_Slider.Position.X, Render_Dist_Slider.Position.X + 464)
        Render_Dist_Knob.Position = Vector2.new(newX - 10, Render_Dist_Slider.Position.Y - 5)
        local ratio = (newX - Render_Dist_Slider.Position.X) / 464
        CurrentMaxDist = math.floor(ratio * 30000)
    end

    lastMouse1 = mouse1
end
