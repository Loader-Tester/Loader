-- 🌇 RealisticGraphicsLite.lua
-- Efeitos realistas otimizados para celulares fracos
-- Client-side: coloque em StarterPlayer > StarterPlayerScripts

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ⚙️ Iluminação base (leve e suave)
Lighting.GlobalShadows = true
Lighting.EnvironmentDiffuseScale = 0.8
Lighting.EnvironmentSpecularScale = 0.8
Lighting.Brightness = 2
Lighting.ClockTime = 17.5
Lighting.FogStart = 120
Lighting.FogEnd = 800
Lighting.FogColor = Color3.fromRGB(85, 95, 110)
Lighting.Ambient = Color3.fromRGB(60, 65, 75)
Lighting.OutdoorAmbient = Color3.fromRGB(50, 55, 65)
Lighting.ExposureCompensation = 0.1

-- 🌫️ Atmosfera simples
local function make(parent, className, name)
	local obj = parent:FindFirstChild(name)
	if obj then return obj end
	obj = Instance.new(className)
	obj.Name = name
	obj.Parent = parent
	return obj
end

local atmosphere = make(Lighting, "Atmosphere", "LiteAtmosphere")
atmosphere.Density = 0.25
atmosphere.Color = Color3.fromRGB(100, 110, 125)
atmosphere.Decay = Color3.fromRGB(70, 75, 85)
atmosphere.Glare = 0.05
atmosphere.Haze = 0.25

-- 🌌 Céu leve (usa skybox padrão com cor corrigida)
local sky = make(Lighting, "Sky", "LiteSky")
sky.SkyboxBk = "rbxassetid://151165214"
sky.SkyboxDn = "rbxassetid://151165197"
sky.SkyboxFt = "rbxassetid://151165224"
sky.SkyboxLf = "rbxassetid://151165191"
sky.SkyboxRt = "rbxassetid://151165206"
sky.SkyboxUp = "rbxassetid://151165227"

-- ✨ Efeitos leves (baixo impacto no desempenho)
local bloom = make(Lighting, "BloomEffect", "LiteBloom")
bloom.Intensity = 0.4
bloom.Size = 12
bloom.Threshold = 1

local cc = make(Lighting, "ColorCorrectionEffect", "LiteColor")
cc.TintColor = Color3.fromRGB(230, 235, 250)
cc.Contrast = 0.1
cc.Saturation = -0.05
cc.Brightness = 0.02

-- (sem DOF, sem SunRays — muito leves mas removidos pra desempenho)

-- 💡 Luz ambiente exemplo (muito leve)
task.spawn(function()
	local workspace = game:GetService("Workspace")
	if not workspace:FindFirstChild("LiteLights") then
		local folder = Instance.new("Folder")
		folder.Name = "LiteLights"
		folder.Parent = workspace

		local part = Instance.new("Part")
		part.Name = "LiteLamp"
		part.Anchored = true
		part.CanCollide = false
		part.Transparency = 1
		part.Position = Vector3.new(0, 10, 0)
		part.Parent = folder

		local light = Instance.new("PointLight")
		light.Color = Color3.fromRGB(200, 210, 255)
		light.Range = 18
		light.Brightness = 2.2
		light.Shadows = false
		light.Parent = part
	end
end)

-- 🔘 Botão ON/OFF (mobile) e tecla K (PC)
local enabled = true
local function toggle(state)
	for _, v in pairs(Lighting:GetChildren()) do
		if v:IsA("PostEffect") or v:IsA("Atmosphere") then
			v.Enabled = state
		end
	end
	enabled = state
end

local function createButton()
	local gui = Instance.new("ScreenGui")
	gui.Name = "LiteToggle"
	gui.ResetOnSpawn = false
	gui.Parent = playerGui

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 120, 0, 40)
	button.Position = UDim2.new(0.03, 0, 0.83, 0)
	button.Text = "Shaders: ON"
	button.Font = Enum.Font.GothamSemibold
	button.TextSize = 18
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.TextColor3 = Color3.fromRGB(235, 235, 235)
	button.AutoButtonColor = false
	button.Parent = gui

	button.MouseButton1Click:Connect(function()
		enabled = not enabled
		toggle(enabled)
		button.Text = enabled and "Shaders: ON" or "Shaders: OFF"
	end)
end

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.K then
		enabled = not enabled
		toggle(enabled)
	end
end)

if UserInputService.TouchEnabled then
	createButton()
end
