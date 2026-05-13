local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local lp = Players.LocalPlayer

-- ================= CONFIGURAÇÃO =================
local EMERALD_TAG = "FloatingEmerald"

local IDS_CATALOGO = {
    118163966966952,
}

local RING_ID = 16624478932

local ChaosEmeraldColors = {
    Color3.fromRGB(0, 255, 0),      -- Verde
    Color3.fromRGB(255, 0, 0),      -- Vermelha
    Color3.fromRGB(0, 128, 255),    -- Azul
    Color3.fromRGB(255, 255, 0),    -- Amarela
    Color3.fromRGB(128, 0, 128),    -- Roxa
    Color3.fromRGB(0, 255, 255),    -- Ciano
    Color3.fromRGB(255, 255, 255)   -- Branca
}

local SPAWN_SOUND_ID = "rbxassetid://850177790"
local DEATH_SOUND_ID = "rbxassetid://126581031883728"

local emeraldFolder = nil
local allEmeraldData = {}
local activeConnections = {}
local isOrbiting = false
local orbitStartTime = 0
local currentCharacter = nil

local currentSpeed = 1.0
local targetSpeed = 1.0
local NORMAL_SPEED = 1.0
local MIN_FAST_SPEED = 2.0
local MAX_FAST_SPEED = 3.5
local SPEED_TRANSITION = 1.5
local speedTweenConnection = nil

local spawnToOrbitProgress = 0
local SPAWN_TO_ORBIT_DURATION = 1.0
local spawnToOrbitStart = 0

local deathProcessed = false
local deathProcessing = false
local ringsAlreadySpawned = false
-- ================================================

local Camera = workspace.CurrentCamera

local function playSound(soundId, parent)
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 1
    sound.Parent = parent or workspace
    sound:Play()
    task.spawn(function()
        sound.Ended:Wait()
        sound:Destroy()
    end)
end

local function findMainPart(model)
    local handle = model:FindFirstChild("Handle")
    if handle and handle:IsA("BasePart") then return handle end
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("MeshPart") then return part end
    end
    return nil
end

local function setModelCFrame(model, mainPart, targetCFrame)
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("MeshPart") then
            local offset = mainPart.CFrame:ToObjectSpace(part.CFrame)
            part.CFrame = targetCFrame * offset
        end
    end
end

local function createHighlight(emeraldClone, color)
    local highlightClone = emeraldClone:Clone()
    highlightClone.Name = emeraldClone.Name .. "_Highlight"
    for _, part in ipairs(highlightClone:GetDescendants()) do
        pcall(function()
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                local h, s, v = color:ToHSV()
                local highlightColor = Color3.fromHSV(h, s * 0.6, math.min(v * 1.4, 1))
                part.Color = highlightColor
                part.Material = Enum.Material.Neon
                part.Transparency = 0.5
                part.CanCollide = false
                part.Anchored = true
                part.CastShadow = false
                if part:IsA("MeshPart") then part.DoubleSided = true end
                if part.Size then part.Size = part.Size * 1.15 end
            end
        end)
        pcall(function()
            if part:IsA("SpecialMesh") then
                local h, s, v = color:ToHSV()
                local highlightColor = Color3.fromHSV(h, s * 0.6, math.min(v * 1.4, 1))
                part.VertexColor = Vector3.new(highlightColor.R, highlightColor.G, highlightColor.B)
                if part.Scale then part.Scale = part.Scale * 1.15 end
            end
        end)
        pcall(function()
            if part:IsA("Decal") or part:IsA("Texture") or part:IsA("PointLight") or part:IsA("SpotLight") then
                part:Destroy()
            end
        end)
    end
    highlightClone:SetAttribute(EMERALD_TAG, true)
    return highlightClone
end

local function createBlackBorder(emeraldClone)
    local borderClone = emeraldClone:Clone()
    borderClone.Name = emeraldClone.Name .. "_Border"
    for _, part in ipairs(borderClone:GetDescendants()) do
        pcall(function()
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Color = Color3.fromRGB(0, 0, 0)
                part.Material = Enum.Material.Plastic
                part.Transparency = 0.3
                part.CanCollide = false
                part.Anchored = true
                part.CastShadow = false
                if part:IsA("MeshPart") then part.DoubleSided = true end
                if part.Size then part.Size = part.Size * 1.25 end
            end
        end)
        pcall(function()
            if part:IsA("SpecialMesh") then
                part.VertexColor = Vector3.new(0, 0, 0)
                if part.Scale then part.Scale = part.Scale * 1.25 end
            end
        end)
        pcall(function()
            if part:IsA("Decal") or part:IsA("Texture") or part:IsA("PointLight") or part:IsA("SpotLight") then
                part:Destroy()
            end
        end)
    end
    borderClone:SetAttribute(EMERALD_TAG, true)
    return borderClone
end

local function recolorModel(model, color)
    for _, part in ipairs(model:GetDescendants()) do
        pcall(function()
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Color = color
                part.Material = Enum.Material.Neon
                part.Transparency = 0.02
                part.CastShadow = false
                if part:IsA("MeshPart") then
                    part.TextureID = ""
                    part.DoubleSided = true
                end
            end
        end)
        pcall(function()
            if part:IsA("SpecialMesh") then
                part.VertexColor = Vector3.new(color.R, color.G, color.B)
                part.TextureId = ""
            end
        end)
    end
end

local function tweenModelColor(model, startColor, endColor, duration)
    local startTime = tick()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / duration, 1)
        local currentColor = startColor:Lerp(endColor, progress)
        for _, part in ipairs(model:GetDescendants()) do
            pcall(function()
                if part:IsA("BasePart") or part:IsA("MeshPart") then part.Color = currentColor end
            end)
            pcall(function()
                if part:IsA("SpecialMesh") then part.VertexColor = Vector3.new(currentColor.R, currentColor.G, currentColor.B) end
            end)
        end
        if progress >= 1 then connection:Disconnect() end
    end)
end

local function destroyAllEmeralds()
    isOrbiting = false
    if speedTweenConnection then speedTweenConnection:Disconnect(); speedTweenConnection = nil end
    for _, data in ipairs(allEmeraldData) do
        pcall(function()
            if data.emeraldClone then data.emeraldClone:Destroy() end
            if data.highlight then data.highlight:Destroy() end
            if data.border then data.border:Destroy() end
            if data.light then data.light:Destroy() end
        end)
    end
    allEmeraldData = {}
    if emeraldFolder and emeraldFolder.Parent then emeraldFolder:Destroy() end
    emeraldFolder = nil
end

-- ================= SPAWN DE 2 ANÉIS =================
local function spawnRingsOnDeath(rootPart)
    if ringsAlreadySpawned then return end
    ringsAlreadySpawned = true
    if not rootPart then return end
    
    local bodyPosition = rootPart.Position
    
    for i = 1, 2 do
        task.spawn(function()
            local sucesso, ringModel = pcall(function()
                return game:GetObjects("rbxassetid://" .. RING_ID)
            end)
            
            if sucesso and ringModel and ringModel[1] then
                local ring = ringModel[1]:Clone()
                
                for _, obj in ipairs(ring:GetDescendants()) do
                    if obj:IsA("LuaSourceContainer") or obj:IsA("Weld") or obj:IsA("Motor6D") or obj:IsA("Attachment") or obj:IsA("Accessory") then
                        obj:Destroy()
                    end
                end
                
                local theta = math.random() * math.pi * 2
                local phi = math.random() * math.pi
                local force = 25 + math.random() * 15
                local direction = Vector3.new(
                    math.sin(phi) * math.cos(theta),
                    math.abs(math.cos(phi)) * 1.5,
                    math.sin(phi) * math.sin(theta)
                ).Unit
                local velocity = direction * force + Vector3.new(0, 18, 0)
                
                for _, part in ipairs(ring:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        part.Anchored = false
                        part.CanCollide = true
                        part.CFrame = CFrame.new(bodyPosition)
                        part.Size = part.Size * 0.5
                        part.Velocity = velocity
                        part.RotVelocity = Vector3.new(
                            math.random(-30, 30),
                            math.random(-30, 30),
                            math.random(-30, 30)
                        )
                    end
                end
                
                ring.Parent = workspace
                
                task.wait(2.0)
                for _, part in ipairs(ring:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        TweenService:Create(part, TweenInfo.new(0.5), {Transparency = 1}):Play()
                    end
                end
                task.wait(0.6)
                pcall(function() ring:Destroy() end)
                pcall(function() ringModel[1]:Destroy() end)
            end
        end)
        task.wait(0.06)
    end
end

-- ================= TWEEN DE VELOCIDADE =================
local function tweenSpeed(novaVelocidade)
    targetSpeed = novaVelocidade
    if speedTweenConnection then speedTweenConnection:Disconnect() end
    local startSpeed = currentSpeed
    local startTime = tick()
    speedTweenConnection = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / SPEED_TRANSITION, 1)
        local easedProgress
        if progress < 0.5 then
            easedProgress = 2 * progress * progress
        else
            easedProgress = 1 - (-2 * progress + 2) * (-2 * progress + 2) / 2
        end
        currentSpeed = startSpeed + (targetSpeed - startSpeed) * easedProgress
        if progress >= 1 then
            currentSpeed = targetSpeed
            speedTweenConnection:Disconnect()
            speedTweenConnection = nil
        end
    end)
end

-- ================= AGENDADOR DE ACELERAÇÃO =================
local function scheduleRandomSpeedBoost()
    task.spawn(function()
        while isOrbiting do
            local waitTime = math.random(50, 150) / 10
            task.wait(waitTime)
            if not isOrbiting then break end
            local randomFastSpeed = MIN_FAST_SPEED + math.random() * (MAX_FAST_SPEED - MIN_FAST_SPEED)
            tweenSpeed(randomFastSpeed)
            local boostDuration = math.random(20, 50) / 10
            task.wait(boostDuration)
            if not isOrbiting then break end
            tweenSpeed(NORMAL_SPEED)
        end
    end)
end

-- ================= ANIMAÇÃO DE SPAWN =================
local function playSpawnAnimation(emeraldData, character)
    local root = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    playSound(SPAWN_SOUND_ID, root)
    
    ringsAlreadySpawned = false
    deathProcessed = false
    deathProcessing = false
    
    local oldWalkSpeed = humanoid.WalkSpeed
    local oldJumpPower = humanoid.JumpPower
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    
    for i, data in ipairs(emeraldData) do
        if data.emeraldClone and data.emeraldClone.Parent then
            local angle = (i - 1) * (math.pi * 2 / 7)
            local groundPos = root.CFrame * CFrame.new(math.cos(angle) * 4.5, -3, math.sin(angle) * 4.5) * CFrame.Angles(math.rad(90), 0, 0)
            setModelCFrame(data.emeraldClone, data.mainPart, groundPos)
            setModelCFrame(data.highlight, data.emeraldHighlightMain, groundPos)
            local dirCamera = (Camera.CFrame.Position - groundPos.Position).Unit
            setModelCFrame(data.border, data.emeraldBorderMain, CFrame.new(groundPos.Position - dirCamera * 0.008) * groundPos.Rotation)
            
            for _, part in ipairs(data.emeraldClone:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("MeshPart") then
                    data._originalSize = part.Size
                    part.Size = part.Size * 0.1
                    part.Transparency = 1
                end
            end
            for _, part in ipairs(data.highlight:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("MeshPart") then part.Transparency = 1 end
            end
            for _, part in ipairs(data.border:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("MeshPart") then part.Transparency = 1 end
            end
            if data.light then data.light.Brightness = 0 end
        end
    end
    
    for i, data in ipairs(emeraldData) do
        if data.emeraldClone and data.emeraldClone.Parent then
            for _, part in ipairs(data.emeraldClone:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("MeshPart") then
                    TweenService:Create(part, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Transparency = 0.02, Size = data._originalSize or part.Size
                    }):Play()
                end
            end
            for _, part in ipairs(data.highlight:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("MeshPart") then TweenService:Create(part, TweenInfo.new(0.3), {Transparency = 0.5}):Play() end
            end
            for _, part in ipairs(data.border:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("MeshPart") then TweenService:Create(part, TweenInfo.new(0.3), {Transparency = 0.3}):Play() end
            end
            if data.light then TweenService:Create(data.light, TweenInfo.new(0.3), {Brightness = 1.1}):Play() end
        end
        task.wait(0.12)
    end
    
    task.wait(0.5)
    humanoid.WalkSpeed = oldWalkSpeed
    humanoid.JumpPower = oldJumpPower
    
    task.wait(0.3)
    
    isOrbiting = true
    orbitStartTime = tick()
    spawnToOrbitProgress = 0
    spawnToOrbitStart = tick()
    currentSpeed = 1.0
    targetSpeed = 1.0
    scheduleRandomSpeedBoost()
end

-- ================= ÓRBITA COM TRANSIÇÃO SUAVE =================
local function updateOrbita(data, i, root, currentTime)
    if not data.emeraldClone or not data.emeraldClone.Parent then return end
    if not data.mainPart or not data.mainPart.Parent then return end
    
    if spawnToOrbitProgress < 1 then
        local elapsed = tick() - spawnToOrbitStart
        spawnToOrbitProgress = math.min(elapsed / SPAWN_TO_ORBIT_DURATION, 1)
    end
    
    local radius = 4.0
    local baseSpeed = 0.35 * currentSpeed
    
    local fixedAngle = (i - 1) * (math.pi * 2 / 7)
    local angle = fixedAngle + currentTime * baseSpeed * (1 + i * 0.05)
    
    local heights = {-1.8, -0.9, 0.0, 0.9, 1.8, -0.3, 1.2}
    local targetY = heights[i] + math.sin(currentTime * 0.6 + i * 0.3) * 0.5
    local targetX = math.cos(angle) * radius
    local targetZ = math.sin(angle) * radius
    
    local groundX = math.cos(fixedAngle) * 4.5
    local groundZ = math.sin(fixedAngle) * 4.5
    local groundY = -3
    
    local t = spawnToOrbitProgress
    local easedT = 1 - (1 - t) * (1 - t)
    
    local finalX = groundX + (targetX - groundX) * easedT
    local finalY = groundY + (targetY - groundY) * easedT
    local finalZ = groundZ + (targetZ - groundZ) * easedT
    
    local baseCFrame = root.CFrame * CFrame.new(finalX, finalY, finalZ) * CFrame.Angles(math.rad(90), 0, 0)
    
    setModelCFrame(data.emeraldClone, data.mainPart, baseCFrame)
    
    if data.highlight and data.highlight.Parent then
        setModelCFrame(data.highlight, data.emeraldHighlightMain, baseCFrame)
        local pulseIntensity = 1 + (currentSpeed - 1) * 0.3
        local pulse = 1 + math.sin(currentTime * (2.5 + currentSpeed * 0.5) + i) * (0.02 * pulseIntensity)
        for _, part in ipairs(data.highlight:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                if part.Size then part.Size = part.Size * pulse end
                part.Transparency = 0.5 + math.sin(currentTime * (3 + currentSpeed * 0.5) + i) * (0.12 * pulseIntensity)
            end
        end
    end
    
    if data.border and data.border.Parent then
        local dirCamera = (Camera.CFrame.Position - baseCFrame.Position).Unit
        local bordaCFrame = CFrame.new(baseCFrame.Position - dirCamera * 0.008) * baseCFrame.Rotation
        setModelCFrame(data.border, data.emeraldBorderMain, bordaCFrame)
    end
    
    if data.light and data.light.Parent then
        data.light.Brightness = 1.1
    end
end

-- ================= MORTE =================
local function onDeath(character)
    if deathProcessing or deathProcessed then return end
    deathProcessing = true
    
    if #allEmeraldData == 0 then
        deathProcessing = false
        return
    end
    
    isOrbiting = false
    if speedTweenConnection then speedTweenConnection:Disconnect(); speedTweenConnection = nil end
    
    local root = character:FindFirstChild("HumanoidRootPart")
    if root then playSound(DEATH_SOUND_ID, root) end
    
    spawnRingsOnDeath(root)
    
    local deathData = {}
    for _, data in ipairs(allEmeraldData) do table.insert(deathData, data) end
    allEmeraldData = {}
    
    for i, data in ipairs(deathData) do
        if data.emeraldClone and data.emeraldClone.Parent then
            task.spawn(function()
                if not data.emeraldClone or not data.emeraldClone.Parent then return end
                
                local corOriginal = data.color
                local corApagada = Color3.fromRGB(80, 80, 80)
                local corFinal = Color3.fromRGB(30, 30, 30)
                
                local sharedVelocity = Vector3.new(math.random(-8, 8), math.random(-3, 2), math.random(-8, 8))
                local sharedRotVelocity = Vector3.new(math.random(-15, 15), math.random(-15, 15), math.random(-15, 15))
                
                local function applyPhysics(model)
                    for _, part in ipairs(model:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("MeshPart") then
                            part.Anchored = false
                            part.CanCollide = (model == data.emeraldClone)
                            part.Velocity = sharedVelocity
                            part.RotVelocity = sharedRotVelocity
                        end
                    end
                end
                
                applyPhysics(data.emeraldClone)
                if data.highlight and data.highlight.Parent then applyPhysics(data.highlight) end
                if data.border and data.border.Parent then applyPhysics(data.border) end
                
                if data.light and data.light.Parent then
                    for _ = 1, 2 do
                        if not data.light or not data.light.Parent then break end
                        TweenService:Create(data.light, TweenInfo.new(0.15), {Brightness = 2.5, Range = 12}):Play()
                        task.wait(0.15)
                        if not data.light or not data.light.Parent then break end
                        TweenService:Create(data.light, TweenInfo.new(0.15), {Brightness = 0.3, Range = 6}):Play()
                        task.wait(0.15)
                    end
                    if data.light and data.light.Parent then
                        TweenService:Create(data.light, TweenInfo.new(0.8), {Brightness = 0, Range = 2}):Play()
                    end
                end
                
                tweenModelColor(data.emeraldClone, corOriginal, corApagada, 0.5)
                
                if data.highlight and data.highlight.Parent then
                    for _, part in ipairs(data.highlight:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("MeshPart") then
                            TweenService:Create(part, TweenInfo.new(0.6), {Transparency = 1}):Play()
                        end
                    end
                end
                if data.border and data.border.Parent then
                    for _, part in ipairs(data.border:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("MeshPart") then
                            TweenService:Create(part, TweenInfo.new(0.6), {Transparency = 1}):Play()
                        end
                    end
                end
                
                task.wait(0.8)
                if not data.emeraldClone or not data.emeraldClone.Parent then return end
                
                for _, part in ipairs(data.emeraldClone:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then part.Material = Enum.Material.Slate end
                end
                
                tweenModelColor(data.emeraldClone, corApagada, corFinal, 0.8)
                
                for _, part in ipairs(data.emeraldClone:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        TweenService:Create(part, TweenInfo.new(0.8), {Transparency = 0.5}):Play()
                    end
                end
                
                task.wait(0.9)
                if not data.emeraldClone or not data.emeraldClone.Parent then return end
                
                for _, part in ipairs(data.emeraldClone:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        TweenService:Create(part, TweenInfo.new(1.2), {Transparency = 1}):Play()
                    end
                end
                
                task.wait(1.5)
                pcall(function()
                    if data.emeraldClone then data.emeraldClone:Destroy() end
                    if data.highlight then data.highlight:Destroy() end
                    if data.border then data.border:Destroy() end
                    if data.light then data.light:Destroy() end
                end)
            end)
        end
    end
    
    deathProcessed = true
    deathProcessing = false
end

-- ================= CRIAR ESMERALDAS =================
local function createFloatingEmeralds(character, assetModel)
    local root = character:WaitForChild("HumanoidRootPart")
    destroyAllEmeralds()
    
    emeraldFolder = Instance.new("Folder")
    emeraldFolder.Name = "FloatingEmeralds"
    emeraldFolder:SetAttribute(EMERALD_TAG, true)
    emeraldFolder.Parent = workspace
    
    allEmeraldData = {}
    isOrbiting = false
    orbitStartTime = 0
    currentCharacter = character
    currentSpeed = 1.0
    targetSpeed = 1.0
    spawnToOrbitProgress = 0
    
    for i = 1, 7 do
        local emeraldClone = assetModel:Clone()
        emeraldClone.Name = "ChaosEmerald_"..i
        
        for _, obj in ipairs(emeraldClone:GetDescendants()) do
            if obj:IsA("LuaSourceContainer") or obj:IsA("Weld") or obj:IsA("Motor6D") or obj:IsA("Attachment") or obj:IsA("Accessory") then
                obj:Destroy()
            end
        end
        
        local mainPart = findMainPart(emeraldClone)
        if not mainPart then continue end
        
        for _, part in ipairs(emeraldClone:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Anchored = true; part.CanCollide = false; part.Massless = true
            end
        end
        
        recolorModel(emeraldClone, ChaosEmeraldColors[i])
        emeraldClone:SetAttribute(EMERALD_TAG, true)
        emeraldClone.Parent = emeraldFolder
        
        local highlight = createHighlight(emeraldClone, ChaosEmeraldColors[i])
        highlight.Parent = emeraldFolder
        
        local border = createBlackBorder(emeraldClone)
        border.Parent = emeraldFolder
        
        local light = nil
        if mainPart then
            light = Instance.new("PointLight")
            light.Brightness = 0
            light.Color = ChaosEmeraldColors[i]
            light.Range = 8
            light.Parent = mainPart
        end
        
        local highlightMain = findMainPart(highlight)
        local borderMain = findMainPart(border)
        
        table.insert(allEmeraldData, {
            emeraldClone = emeraldClone,
            highlight = highlight,
            border = border,
            light = light,
            mainPart = mainPart,
            emeraldHighlightMain = highlightMain or mainPart,
            emeraldBorderMain = borderMain or mainPart,
            color = ChaosEmeraldColors[i]
        })
    end
    
    task.spawn(function()
        while true do
            if isOrbiting then
                if not character or not character.Parent or character ~= currentCharacter then break end
                local root = character:FindFirstChild("HumanoidRootPart")
                if not root then break end
                
                local currentTime = tick() - orbitStartTime
                
                for i, data in ipairs(allEmeraldData) do
                    updateOrbita(data, i, root, currentTime)
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)
    
    playSpawnAnimation(allEmeraldData, character)
end

local function connectCharacterEvents(character)
    local humanoid = character:WaitForChild("Humanoid")
    if activeConnections[character] then
        for _, conn in ipairs(activeConnections[character]) do conn:Disconnect() end
    end
    local deathConn = humanoid.Died:Connect(function() onDeath(character) end)
    activeConnections[character] = {deathConn}
end

local function CarregarEsmeraldas()
    local character = lp.Character or lp.CharacterAdded:Wait()
    destroyAllEmeralds()
    connectCharacterEvents(character)
    for _, id in pairs(IDS_CATALOGO) do
        task.spawn(function()
            local sucesso, objects = pcall(function() return game:GetObjects("rbxassetid://" .. id) end)
            if sucesso and objects and objects[1] then
                local assetModel = objects[1]:Clone()
                for _, v in pairs(assetModel:GetDescendants()) do
                    if v:IsA("LuaSourceContainer") then v:Destroy() end
                end
                task.wait(0.5)
                createFloatingEmeralds(character, assetModel)
                assetModel:Destroy()
                objects[1]:Destroy()
            end
        end)
    end
end

CarregarEsmeraldas()

lp.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    connectCharacterEvents(character)
    CarregarEsmeraldas()
end)

-- ╔══════════════════════════════════════════════════╗
-- ║     CHAOS EMERALDS • SCRIPT CARREGADO          ║
-- ║     By MyNameIs909                             ║
-- ╚══════════════════════════════════════════════════╝

task.wait(1)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChaosEmeraldNotification"
screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true -- Ignora as bordas da tela

-- ═══════════════════════════════════════════════
-- OVERLAY GIGANTE (cobre toda tela + 5000px extra)
-- ═══════════════════════════════════════════════
local overlay = Instance.new("Frame")
overlay.Name = "Overlay"
overlay.Size = UDim2.new(0, 5000, 0, 5000) -- MUITO maior que a tela
overlay.Position = UDim2.new(0.5, -2500, 0.5, -2500) -- Centralizado
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 1 -- Começa transparente
overlay.BorderSizePixel = 0
overlay.ZIndex = 1000 -- Prioridade máxima
overlay.Parent = screenGui

-- ═══════════════════════════════════════════════
-- CONTEÚDO (centralizado na tela)
-- ═══════════════════════════════════════════════
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, 0, 1, 0)
contentFrame.Position = UDim2.new(0, 0, 0, 0)
contentFrame.BackgroundTransparency = 1
contentFrame.ZIndex = 1001
contentFrame.Parent = overlay

-- Anel dourado no centro
local ringFrame = Instance.new("Frame")
ringFrame.Name = "RingFrame"
ringFrame.Size = UDim2.new(0, 150, 0, 150)
ringFrame.Position = UDim2.new(0.5, -75, 0.35, -75)
ringFrame.BackgroundTransparency = 1
ringFrame.BorderSizePixel = 0
ringFrame.ZIndex = 1001
ringFrame.Parent = contentFrame

local ring = Instance.new("ImageLabel")
ring.Name = "Ring"
ring.Size = UDim2.new(1, 0, 1, 0)
ring.Position = UDim2.new(0, 0, 0, 0)
ring.BackgroundTransparency = 1
ring.Image = "rbxassetid://16624478932"
ring.ImageColor3 = Color3.fromRGB(255, 215, 0)
ring.ZIndex = 1001
ring.Parent = ringFrame

-- 7 Esmeraldas orbitando
local emeraldColors = {
    Color3.fromRGB(0, 255, 0),
    Color3.fromRGB(255, 0, 0),
    Color3.fromRGB(0, 128, 255),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(128, 0, 128),
    Color3.fromRGB(0, 255, 255),
    Color3.fromRGB(255, 255, 255),
}

local emeraldDots = {}
for i = 1, 7 do
    local dot = Instance.new("Frame")
    dot.Name = "EmeraldDot_"..i
    dot.Size = UDim2.new(0, 20, 0, 20)
    dot.BackgroundColor3 = emeraldColors[i]
    dot.BorderSizePixel = 0
    dot.ZIndex = 1002
    
    local dotStroke = Instance.new("UIStroke")
    dotStroke.Color = emeraldColors[i]
    dotStroke.Thickness = 3
    dotStroke.Transparency = 0.3
    dotStroke.Parent = dot
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    
    dot.Parent = contentFrame
    table.insert(emeraldDots, dot)
end

-- Título
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(0.9, 0, 0, 80)
title.Position = UDim2.new(0.05, 0, 0.48, 0)
title.BackgroundTransparency = 1
title.Text = "CHAOS EMERALDS"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.TextSize = 56
title.Font = Enum.Font.SciFi
title.TextStrokeTransparency = 0.2
title.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
title.ZIndex = 1001
title.Parent = contentFrame

-- Subtítulo
local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(0.9, 0, 0, 40)
subtitle.Position = UDim2.new(0.05, 0, 0.58, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Script By MyNameIs909"
subtitle.TextColor3 = Color3.fromRGB(180, 200, 255)
subtitle.TextSize = 30
subtitle.Font = Enum.Font.GothamBold
subtitle.TextStrokeTransparency = 0.4
subtitle.ZIndex = 1001
subtitle.Parent = contentFrame

-- Partículas de fundo
for i = 1, 50 do
    local particle = Instance.new("Frame")
    particle.Name = "Particle_"..i
    particle.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    particle.BackgroundTransparency = math.random(40, 80) / 100
    particle.BorderSizePixel = 0
    particle.ZIndex = 1000
    
    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(1, 0)
    pCorner.Parent = particle
    
    particle.Parent = contentFrame
end

-- ═══════════════════════════════════════════════
-- ANIMAÇÕES
-- ═══════════════════════════════════════════════

-- Anel girando
task.spawn(function()
    while ringFrame and ringFrame.Parent do
        ringFrame.Rotation = (ringFrame.Rotation + 4) % 360
        RunService.Heartbeat:Wait()
    end
end)

-- Anel pulsando
task.spawn(function()
    while ring and ring.Parent do
        for s = 1, 1.15, 0.015 do
            ring.Size = UDim2.new(s, 0, s, 0)
            RunService.Heartbeat:Wait()
        end
        for s = 1.15, 1, -0.015 do
            ring.Size = UDim2.new(s, 0, s, 0)
            RunService.Heartbeat:Wait()
        end
    end
end)

-- Esmeraldas orbitando ao redor do anel
task.spawn(function()
    local cx, cy = 0.5, 0.35
    local radius = 0.18
    local time = 0
    while emeraldDots[1] and emeraldDots[1].Parent do
        time = time + 0.04
        for i, dot in ipairs(emeraldDots) do
            if dot and dot.Parent then
                local angle = (i - 1) * (math.pi * 2 / 7) + time * 2.5
                local x = cx + math.cos(angle) * radius
                local y = cy + math.sin(angle) * radius
                dot.Position = UDim2.new(x, -10, y, -10)
                dot.BackgroundTransparency = 0.2 + math.sin(time * 4 + i) * 0.4
            end
        end
        RunService.Heartbeat:Wait()
    end
end)

-- Título digitando
local fullTitle = "CHAOS EMERALDS"
title.Text = ""
task.spawn(function()
    for i = 1, #fullTitle do
        title.Text = string.sub(fullTitle, 1, i)
        task.wait(0.06)
    end
end)

-- Subtítulo fade in
subtitle.TextTransparency = 1
task.delay(1.2, function()
    TweenService:Create(subtitle, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
end)

-- ═══════════════════════════════════════════════
-- FADE IN (0.5s)
-- ═══════════════════════════════════════════════
TweenService:Create(overlay, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0.85
}):Play()

-- ═══════════════════════════════════════════════
-- ESPERA 3 SEGUNDOS E FADE OUT (0.5s)
-- ═══════════════════════════════════════════════
task.delay(3.0, function()
    if overlay and overlay.Parent then
        local fadeOutOverlay = TweenService:Create(overlay, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        })
        fadeOutOverlay:Play()
        fadeOutOverlay.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end
end)

print("💎 CHAOS EMERALDS • Script By MyNameIs909 • Carregado!")
