--[[ 🌈 SHADER RTX HD (FOCO FORTE + CORES VIVAS)
Autor: ChatGPT | Executa automaticamente (client side)
Coloque como LocalScript em StarterPlayerScripts
--]]

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- 🧹 Limpa efeitos antigos
for _, v in pairs(Lighting:GetChildren()) do
	if v:IsA("PostEffect") or v:IsA("Atmosphere") then
		v:Destroy()
	end
end

-- ☀️ LUZ BASE REALISTA
Lighting.GlobalShadows = true
Lighting.Brightness = 1.35
Lighting.ExposureCompensation = 0.1
Lighting.EnvironmentDiffuseScale = 0.9
Lighting.EnvironmentSpecularScale = 1
Lighting.ClockTime = 15
Lighting.GeographicLatitude = 45
Lighting.Ambient = Color3.fromRGB(100, 100, 110)
Lighting.OutdoorAmbient = Color3.fromRGB(135, 140, 145)
Lighting.FogColor = Color3.fromRGB(180, 190, 205)
Lighting.FogStart = 70
Lighting.FogEnd = 700

-- ☁️ ATMOSFERA SUAVE
local atmosphere = Instance.new("Atmosphere", Lighting)
atmosphere.Density = 0.32
atmosphere.Offset = 0.15
atmosphere.Color = Color3.fromRGB(205, 210, 225)
atmosphere.Decay = Color3.fromRGB(95, 100, 110)
atmosphere.Glare = 0.25
atmosphere.Haze = 2.8

-- 🎨 COR MAIS FORTE E CONTRASTE
local color = Instance.new("ColorCorrectionEffect", Lighting)
color.Brightness = 0.05
color.Contrast = 0.55   -- contraste reforçado
color.Saturation = 0.45 -- cores mais vivas
color.TintColor = Color3.fromRGB(255, 245, 230)
color.Parent = Lighting

-- 💫 BLOOM EQUILIBRADO (brilho controlado)
local bloom = Instance.new("BloomEffect", Lighting)
bloom.Intensity = 0.25
bloom.Size = 25
bloom.Threshold = 0.9
bloom.Parent = Lighting

-- 🌞 RAIOS DE SOL NATURAIS
local sunrays = Instance.new("SunRaysEffect", Lighting)
sunrays.Intensity = 0.07
sunrays.Spread = 0.85
sunrays.Parent = Lighting

-- 🪞 SHARPNESS EXTRA (textura HD)
local sharpness = Instance.new("ColorCorrectionEffect", Lighting)
sharpness.Contrast = 0.25
sharpness.Saturation = 0.2
sharpness.TintColor = Color3.fromRGB(255, 255, 245)
sharpness.Parent = Lighting

-- 🎥 FOCO CINEMATOGRÁFICO (FORTEMENTE REALISTA)
local depth = Instance.new("DepthOfFieldEffect", Lighting)
depth.InFocusRadius = 12
depth.NearIntensity = 0.25
depth.FarIntensity = 0.6
depth.FocusDistance = 25
depth.Parent = Lighting

-- 🔁 Atualiza o foco conforme a distância da câmera
RunService.RenderStepped:Connect(function()
	if Camera and Player.Character and Player.Character:FindFirstChild("Head") then
		local head = Player.Character.Head
		local dist = (Camera.CFrame.Position - head.Position).Magnitude
		depth.FocusDistance = math.clamp(dist, 10, 60)
	end
end)

Lighting.ShadowSoftness = 0.25

print("✅ Shader RTX HD com FOCO FORTE + CORES VIVAS carregado!")
