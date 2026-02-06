

```lua
-- [[ NEXUS PROTOCOL: TERMINATION ]] --
-- [[ CREATOR: sam-393 ]] --
-- [[ UNIVERSAL SCRIPT HUB ]] --

local LP = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

-- // PROTOCOL SETTINGS
_G.CurrentTarget = nil
_G.MechActive = false
_G.Noclip = false
_G.Flying = false
_G.FlightSpeed = 100
local isGhost = false

-- // UI CONSTRUCTION
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local ButtonHolder = Instance.new("ScrollingFrame", MainFrame)
local Title = Instance.new("TextLabel", MainFrame)

MainFrame.Name = "NexusHub"
MainFrame.Size = UDim2.new(0, 280, 0, 560)
MainFrame.Position = UDim2.new(0, 50, 0.5, -280)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 12)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 160, 255)
Stroke.Thickness = 2

Title.Size = UDim2.new(1, 0, 0, 45)
Title.Text = "NEXUS PROTOCOL: sam-393"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.TextSize = 14

ButtonHolder.Size = UDim2.new(1, -20, 1, -70)
ButtonHolder.Position = UDim2.new(0, 10, 0, 55)
ButtonHolder.BackgroundTransparency = 1
ButtonHolder.ScrollBarThickness = 2
ButtonHolder.CanvasSize = UDim2.new(0, 0, 1.4, 0)
local UIList = Instance.new("UIListLayout", ButtonHolder)
UIList.Padding = UDim.new(0, 6)

local function AddBtn(text, color, callback)
    local btn = Instance.new("TextButton", ButtonHolder)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(callback)
end

-- // PROTOCOL LOGIC
local function GlobalAnnounce(msg)
    local final = "[NEXUS PROTOCOL]: " .. msg:upper()
    local sayRequest = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") and game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
    if sayRequest then
        sayRequest:FireServer(final, "All")
    else
        local channel = game:GetService("TextChatService"):FindFirstChild("TextChannels") and game:GetService("TextChatService").TextChannels:FindFirstChild("RBXGeneral")
        if channel then channel:SendAsync(final) end
    end
end

local function HealUser(amt)
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.Health = math.clamp(h.Health + amt, 0, h.MaxHealth) end
end

-- // GHOST STEALTH
local function StealthBlink()
    if isGhost then return end
    isGhost = true
    for _, v in pairs(LP.Character:GetDescendants()) do 
        if v:IsA("BasePart") then v.Transparency = 0.8 v.Color = Color3.fromRGB(0, 180, 255) end 
    end
    task.delay(3, function() 
        if LP.Character then
            for _, v in pairs(LP.Character:GetDescendants()) do 
                if v:IsA("BasePart") then v.Transparency = 0 v.Color = Color3.fromRGB(255, 255, 255) end 
            end 
        end
        isGhost = false 
    end)
end

-- // CONTROLS (L-CTRL / R-CTRL)
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if input.KeyCode == Enum.KeyCode.LeftControl then
        StealthBlink()
        if _G.CurrentTarget and _G.CurrentTarget.Parent then
            root.CFrame = _G.CurrentTarget.CFrame * CFrame.new(0, 0, 3)
            if char:FindFirstChildOfClass("Tool") then char:FindFirstChildOfClass("Tool"):Activate() end
        else
            root.CFrame = root.CFrame * CFrame.new(0, 0, -35)
        end
    elseif input.KeyCode == Enum.KeyCode.RightControl then
        GlobalAnnounce("OMEGA COLLAPSE INITIATED.")
        for _, v in pairs(workspace:GetChildren()) do
            if v.Name == "TERMINATION_DRONE" then
                Instance.new("Explosion", workspace).Position = v.HumanoidRootPart.Position
                v:Destroy()
                if _G.MechActive then HealUser(15) end
            end
        end
    elseif input.KeyCode == Enum.KeyCode.V then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- // NOCLIP UPDATE
RunService.Stepped:Connect(function()
    if _G.Noclip and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

-- // UI INPUTS
local TargetBox = Instance.new("TextBox", ButtonHolder)
TargetBox.Size = UDim2.new(1,0,0,32)
TargetBox.PlaceholderText = "Target Name..."
TargetBox.BackgroundColor3 = Color3.fromRGB(40,0,0)
TargetBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", TargetBox)
TargetBox.FocusLost:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Name:lower():find(TargetBox.Text:lower()) then _G.CurrentTarget = p.Character.HumanoidRootPart; TargetBox.Text = "LOCKED: "..p.Name; break end
    end
end)

local MsgBox = Instance.new("TextBox", ButtonHolder)
MsgBox.Size = UDim2.new(1,0,0,32)
MsgBox.PlaceholderText = "Announcement..."
MsgBox.BackgroundColor3 = Color3.fromRGB(0,20,40)
MsgBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", MsgBox)

-- // ACTION BUTTONS
AddBtn("ANNOUNCE TO SERVER", Color3.fromRGB(0, 100, 255), function() GlobalAnnounce(MsgBox.Text) end)

AddBtn("TOGGLE FLY & NOCLIP", Color3.fromRGB(0, 150, 255), function()
    _G.Flying = not _G.Flying
    _G.Noclip = not _G.Noclip
    if _G.Flying then
        local bv = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bv.Name = "FlyV"
        task.spawn(function()
            while _G.Flying do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * _G.FlightSpeed
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

AddBtn("SPAWN TRUBLU SQUAD", Color3.fromRGB(0, 60, 180), function()
    for i=1, 5 do
        local npc = Instance.new("Model", workspace); npc.Name = "TERMINATION_DRONE"
        local hrp = Instance.new("Part", npc); hrp.Name = "HumanoidRootPart"; hrp.Size = Vector3.new(2,2,1); hrp.Color = Color3.new(0,0,0)
        Instance.new("Humanoid", npc)
        local head = Instance.new("Part", npc); head.Size = Vector3.new(1,1,1); head.Color = Color3.new(0,1,1); head.Material = "Neon"
        local w = Instance.new("Weld", head); w.Part0 = hrp; w.Part1 = head; w.C0 = CFrame.new(0, 1.5, 0)
        hrp.CFrame = LP.Character.HumanoidRootPart.CFrame
        task.spawn(function() while npc.Parent do npc.Humanoid:MoveTo((_G.CurrentTarget or LP.Character.HumanoidRootPart).Position + Vector3.new(math.random(-5,5),0,math.random(-5,5))) task.wait(0.3) end end)
    end
end)

AddBtn("MANIFEST ENERGY BLADE", Color3.fromRGB(0, 200, 255), function()
    local tool = LP.Character:FindFirstChildOfClass("Tool")
    if not tool then return end
    local blade = Instance.new("Part", tool)
    blade.Name = "EnergyBlade"; blade.Size = Vector3.new(0.2, 5, 0.8); blade.Color = Color3.new(0,1,1); blade.Material = "Neon"
    local weld = Instance.new("Weld", blade)
    weld.Part0 = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("Part")
    weld.Part1 = blade; weld.C0 = CFrame.new(0,0,-2) * CFrame.Angles(math.rad(90),0,0)
end)

AddBtn("ORBITAL STRIKE", Color3.fromRGB(50, 255, 255), function()
    local m = LP:GetMouse()
    local b = Instance.new("Part", workspace)
    b.Size = Vector3.new(15,15,15); b.Shape = "Ball"; b.Position = m.Hit.p; b.Material = "Neon"; b.Color = Color3.new(0,1,1); b.Anchored = true; b.CanCollide = false
    task.spawn(function() for i=1,10 do b.Transparency = i/10 b.Size = b.Size + Vector3.new(3,3,3) task.wait(0.05) end b:Destroy() end)
end)

-- // MECH AUTO-EVOLUTION
task.spawn(function()
    while task.wait(0.5) do
        local h = LP.Character and LP.Character:FindFirstChild("Humanoid")
        if h and h.Health <= (h.MaxHealth * 0.1) and not _G.MechActive then
            _G.MechActive = true
            h.MaxHealth = 1000; h.Health = 500; h.WalkSpeed = 95
            local m = Instance.new("Part", LP.Character)
            m.Size = Vector3.new(7,9,6); m.Color = Color3.new(0,0,0); m.Material = "Metal"
            Instance.new("Weld", m).Part0 = LP.Character.HumanoidRootPart; m.Weld.Part1 = m
            GlobalAnnounce("MECH_PILOT_ACTIVE: sam-393 EVOLUTION")
        end
    end
end)

print("NEXUS HUB BY sam-393 LOADED")

```

---

**Next Step:** Once you save this as `Main.lua` in your repository, use your loadstring:

`loadstring(game:HttpGet("https://raw.githubusercontent.com/sam-393/Nexus-Hub/main/Main.lua"))()`

**Would you like me to help you write a script that makes the UI colors change (RGB Rainbow) automatically?**
