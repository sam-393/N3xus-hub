-- [[ NEXUS PROTOCOL: V6 LETHAL ARSENAL ]] --
-- [[ CREATOR: sam-393 ]] --

local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local ButtonHolder = Instance.new("ScrollingFrame", MainFrame)
local Title = Instance.new("TextLabel", MainFrame)

-- // UI STYLING
MainFrame.Size = UDim2.new(0, 280, 0, 500)
MainFrame.Position = UDim2.new(0.1, 0, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Thickness = 2
task.spawn(function() 
    while task.wait() do 
        Stroke.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1) 
    end 
end)

Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "NEXUS V6: LETHAL | sam-393"
Title.TextColor3 = Color3.new(0, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

ButtonHolder.Size = UDim2.new(1, -20, 1, -60)
ButtonHolder.Position = UDim2.new(0, 10, 0, 50)
ButtonHolder.BackgroundTransparency = 1
ButtonHolder.CanvasSize = UDim2.new(0, 0, 3, 0)
local UIList = Instance.new("UIListLayout", ButtonHolder)
UIList.Padding = UDim.new(0, 5)

-- // KILL LOGIC
local function MakeLethal(part)
    part.Touched:Connect(function(hit)
        if hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
            local target = hit.Parent.Humanoid
            if hit.Parent.Name ~= LP.Name then
                target.Health = 0 
            end
        end
    end)
end

-- // WEAPON SYSTEM
local currentWeapons = {}
local function ClearWeapons()
    for _, v in pairs(currentWeapons) do if v then v:Destroy() end end
    currentWeapons = {}
end

local function CreateEnergyPart(size, offset, parent)
    local p = Instance.new("Part")
    p.Size = size
    p.Color = Color3.fromRGB(0, 180, 255)
    p.Material = Enum.Material.Neon
    p.CanCollide = false
    p.Parent = LP.Character
    local w = Instance.new("Weld", p)
    w.Part0 = parent
    w.Part1 = p
    w.C0 = offset
    MakeLethal(p)
    table.insert(currentWeapons, p)
    return p
end

local Weapons = {
    ["Energy Spear"] = function()
        local r = LP.Character:FindFirstChild("Right Arm") or LP.Character:FindFirstChild("RightHand")
        CreateEnergyPart(Vector3.new(0.2, 0.2, 10), CFrame.new(0, -1, 0), r)
    end,
    ["Dual Energy Knives"] = function()
        local r = LP.Character:FindFirstChild("Right Arm") or LP.Character:FindFirstChild("RightHand")
        local l = LP.Character:FindFirstChild("Left Arm") or LP.Character:FindFirstChild("LeftHand")
        CreateEnergyPart(Vector3.new(0.1, 0.5, 3), CFrame.new(0, -1, -1), r)
        CreateEnergyPart(Vector3.new(0.1, 0.5, 3), CFrame.new(0, -1, -1), l)
    end,
    ["Energy Blade"] = function()
        local r = LP.Character:FindFirstChild("Right Arm") or LP.Character:FindFirstChild("RightHand")
        CreateEnergyPart(Vector3.new(0.2, 0.8, 5), CFrame.new(0, -1, -2), r)
    end,
    ["Energy Gun"] = function()
        local r = LP.Character:FindFirstChild("Right Arm") or LP.Character:FindFirstChild("RightHand")
        CreateEnergyPart(Vector3.new(0.5, 0.5, 4), CFrame.new(0, -1, -2), r)
    end
}

-- // FLASH STEP WITH AFTER-IMAGE (L-CTRL)
local function FlashStep()
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local folder = Instance.new("Folder", workspace); folder.Name = "NexusShadow"
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
                local p = v:Clone(); p.Parent = folder; p.Anchored = true; p.Material = "Neon"; p.Color = Color3.new(0,0.6,1); p.Transparency = 0.5
            end
        end
        task.delay(0.5, function() folder:Destroy() end)
        root.CFrame = root.CFrame * CFrame.new(0,0,-45)
    end
end

-- // UI BUTTONS
local function AddBtn(text, callback)
    local btn = Instance.new("TextButton", ButtonHolder)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

AddBtn("REMOVE WEAPONS", ClearWeapons)
for name, func in pairs(Weapons) do
    AddBtn("Manifest: " .. name, function() ClearWeapons() func() end)
end

AddBtn("ENABLE PLAYER ESP", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.new(0, 1, 1)
        end
    end
end)

-- // INPUT BINDINGS
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe then
        if input.KeyCode == Enum.KeyCode.LeftControl then FlashStep()
        elseif input.KeyCode == Enum.KeyCode.V then MainFrame.Visible = not MainFrame.Visible end
    end
end)
