local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ==================== CONFIGURAÇÕES DOS STANDS ====================
local scripts = {
    -- ========== DIO BRANDO / THE WORLD ==========
    {
        name = "THE WORLD",
        description = "DIO - Toki wo tomare!",
        url = "https://raw.githubusercontent.com/Loader-Tester/Loader/refs/heads/main/DioBrando.lua",
        color = Color3.fromRGB(255, 215, 0),
        color2 = Color3.fromRGB(180, 150, 0),
        icon = "⏱️",
        quote = "WRYYYYY!",
        tag = "STAND"
    },
    -- ========== THE HAND ==========
    {
        name = "THE HAND",
        description = "Okuyasu - Space Erasing!",
        url = "https://raw.githubusercontent.com/Loader-Tester/Loader/refs/heads/main/TheHand.lua",
        color = Color3.fromRGB(0, 150, 255),
        color2 = Color3.fromRGB(0, 80, 180),
        icon = "✋",
        quote = "Oi, Josuke!",
        tag = "STAND"
    },
    -- ========== VAZIOS ==========
    {
        name = "???",
        description = "Stand Desconhecido",
        url = "",
        color = Color3.fromRGB(60, 60, 60),
        color2 = Color3.fromRGB(30, 30, 30),
        icon = "❓",
        quote = "...",
        tag = "VAZIO"
    },
    {
        name = "???",
        description = "Stand Desconhecido",
        url = "",
        color = Color3.fromRGB(60, 60, 60),
        color2 = Color3.fromRGB(30, 30, 30),
        icon = "❓",
        quote = "...",
        tag = "VAZIO"
    },
    {
        name = "???",
        description = "Stand Desconhecido",
        url = "",
        color = Color3.fromRGB(60, 60, 60),
        color2 = Color3.fromRGB(30, 30, 30),
        icon = "❓",
        quote = "...",
        tag = "VAZIO"
    },
    {
        name = "???",
        description = "Stand Desconhecido",
        url = "",
        color = Color3.fromRGB(60, 60, 60),
        color2 = Color3.fromRGB(30, 30, 30),
        icon = "❓",
        quote = "...",
        tag = "VAZIO"
    },
    -- ========== INVENCIBLE / MARK GRAYSON (PENÚLTIMO) ==========
    {
        name = "INVENCIBLE",
        description = "Mark Grayson - Think, Mark!",
        url = "https://raw.githubusercontent.com/Loader-Tester/Loader/refs/heads/main/Invencibletest.lua",
        color = Color3.fromRGB(255, 200, 0),
        color2 = Color3.fromRGB(0, 100, 200),
        icon = "🦸",
        quote = "That's the neat part, you don't.",
        tag = "HERÓI"
    },
    -- ========== SANDEVISTAN (ÚLTIMO) ==========
    {
        name = "SANDEVISTAN",
        description = "David Martinez - Built Different!",
        url = "NADA",
        color = Color3.fromRGB(255, 80, 0),
        color2 = Color3.fromRGB(180, 30, 0),
        icon = "⚡",
        quote = "I'm built different...",
        tag = "BÔNUS"
    }
}

-- ==================== CRIAR GUI PRINCIPAL ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JojoScriptHub"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- ==================== BOTÃO TOGGLE (CANTO SUPERIOR ESQUERDO) ====================
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 55, 0, 55)
toggleButton.Position = UDim2.new(0.015, 0, 0.015, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
toggleButton.TextColor3 = Color3.fromRGB(255, 215, 0)
toggleButton.Text = "★"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 30
toggleButton.BorderSizePixel = 0
toggleButton.AutoButtonColor = false
toggleButton.ZIndex = 100
toggleButton.Parent = screenGui

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(255, 215, 0)
toggleStroke.Thickness = 2.5
toggleStroke.Parent = toggleButton

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleButton

local toggleShadow = Instance.new("ImageLabel")
toggleShadow.Size = UDim2.new(1.3, 0, 1.3, 0)
toggleShadow.Position = UDim2.new(-0.15, 0, -0.15, 0)
toggleShadow.BackgroundTransparency = 1
toggleShadow.Image = "rbxassetid://6815858079"
toggleShadow.ImageColor3 = Color3.fromRGB(255, 215, 0)
toggleShadow.ImageTransparency = 0.7
toggleShadow.ZIndex = 99
toggleShadow.Parent = toggleButton

-- ==================== MENU PRINCIPAL ====================
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 300, 0.80, 0)
menuFrame.Position = UDim2.new(0.015, 0, 0.015, 65)
menuFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
menuFrame.BorderSizePixel = 0
menuFrame.ClipsDescendants = true
menuFrame.Visible = false
menuFrame.ZIndex = 99
menuFrame.Parent = screenGui

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = Color3.fromRGB(255, 215, 0)
menuStroke.Thickness = 2
menuStroke.Parent = menuFrame

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 12)
menuCorner.Parent = menuFrame

local menuGradient = Instance.new("UIGradient")
menuGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 18, 24)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
}
menuGradient.Rotation = 135
menuGradient.Parent = menuFrame

-- ==================== CABEÇALHO ====================
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 60)
headerFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
headerFrame.BorderSizePixel = 0
headerFrame.ZIndex = 100
headerFrame.Parent = menuFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = headerFrame

local headerGradient = Instance.new("UIGradient")
headerGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 150, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 60, 0))
}
headerGradient.Rotation = 90
headerGradient.Parent = headerFrame

local starIcon = Instance.new("TextLabel")
starIcon.Size = UDim2.new(0, 35, 0, 35)
starIcon.Position = UDim2.new(0.04, 0, 0.2, 0)
starIcon.Text = "★"
starIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
starIcon.BackgroundTransparency = 1
starIcon.Font = Enum.Font.GothamBold
starIcon.TextSize = 28
starIcon.ZIndex = 101
starIcon.Parent = headerFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
titleLabel.Position = UDim2.new(0.18, 0, 0, 0)
titleLabel.Text = "JOJO'S HUB\nDIO | THE HAND"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center
titleLabel.RichText = true
titleLabel.ZIndex = 101
titleLabel.Parent = headerFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0.85, 0, 0.25, 0)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16
closeButton.BorderSizePixel = 0
closeButton.AutoButtonColor = false
closeButton.ZIndex = 102
closeButton.Parent = headerFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeButton

-- ==================== SCROLLING FRAME ====================
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -6, 1, -70)
scrollFrame.Position = UDim2.new(0, 3, 0, 65)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #scripts * 70)
scrollFrame.ScrollingEnabled = true
scrollFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.ElasticBehavior = Enum.ElasticBehavior.Always
scrollFrame.ScrollBarImageTransparency = 0.6
scrollFrame.ClipsDescendants = true
scrollFrame.ZIndex = 99
scrollFrame.Parent = menuFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 6)
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = scrollFrame

local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingTop = UDim.new(0, 5)
uiPadding.PaddingBottom = UDim.new(0, 10)
uiPadding.Parent = scrollFrame

-- ==================== CRIAR BOTÕES (TEXTOS CORRIGIDOS) ====================
for i, scriptData in ipairs(scripts) do
    local isVazio = scriptData.tag == "VAZIO"
    local isBonus = scriptData.tag == "BÔNUS" or scriptData.tag == "HERÓI"
    
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(0.94, 0, 0, 62)
    buttonFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    buttonFrame.BorderSizePixel = 0
    buttonFrame.LayoutOrder = i
    buttonFrame.ClipsDescendants = true
    buttonFrame.ZIndex = 99
    buttonFrame.Parent = scrollFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = buttonFrame
    
    local bgGradient = Instance.new("UIGradient")
    if isVazio then
        bgGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 40)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 30))
        }
    elseif isBonus then
        bgGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 25, 10)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 15, 5))
        }
    else
        bgGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 38)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 26))
        }
    end
    bgGradient.Rotation = 45
    bgGradient.Parent = buttonFrame
    
    -- Barra lateral colorida
    local colorBar = Instance.new("Frame")
    colorBar.Size = UDim2.new(0, 5, 0.75, 0)
    colorBar.Position = UDim2.new(0, 6, 0.125, 0)
    colorBar.BackgroundColor3 = scriptData.color
    colorBar.BorderSizePixel = 0
    colorBar.ZIndex = 100
    colorBar.Parent = buttonFrame
    
    local barGradient = Instance.new("UIGradient")
    barGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, scriptData.color2),
        ColorSequenceKeypoint.new(0.5, scriptData.color),
        ColorSequenceKeypoint.new(1, scriptData.color2)
    }
    barGradient.Parent = colorBar
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = colorBar
    
    -- Ícone (centralizado verticalmente)
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 40, 0, 40)
    iconLabel.Position = UDim2.new(0.02, 0, 0.5, -20)
    iconLabel.Text = scriptData.icon or "★"
    iconLabel.TextColor3 = scriptData.color
    iconLabel.BackgroundTransparency = 1
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.TextSize = 26
    iconLabel.ZIndex = 100
    iconLabel.Parent = buttonFrame
    
    -- Tag (canto superior esquerdo da área de texto)
    local tagLabel = Instance.new("TextLabel")
    tagLabel.Size = UDim2.new(0, 55, 0, 14)
    tagLabel.Position = UDim2.new(0.18, 0, 0.08, 0)
    tagLabel.Text = scriptData.tag or ""
    tagLabel.TextColor3 = scriptData.color
    tagLabel.BackgroundTransparency = 1
    tagLabel.Font = Enum.Font.GothamBold
    tagLabel.TextSize = 8
    tagLabel.TextXAlignment = Enum.TextXAlignment.Left
    tagLabel.ZIndex = 100
    tagLabel.Parent = buttonFrame
    
    -- Nome (ajustado para não sobrepor tag)
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.38, 0, 0, 18)
    nameLabel.Position = UDim2.new(0.18, 0, 0.2, 0)
    nameLabel.Text = scriptData.name
    nameLabel.TextColor3 = isVazio and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(255, 255, 255)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextYAlignment = Enum.TextYAlignment.Center
    nameLabel.ZIndex = 100
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Parent = buttonFrame
    
    -- Descrição (ajustado)
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(0.38, 0, 0, 16)
    descLabel.Position = UDim2.new(0.18, 0, 0.48, 0)
    descLabel.Text = scriptData.description
    descLabel.TextColor3 = isVazio and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(160, 160, 170)
    descLabel.BackgroundTransparency = 1
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 10
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextYAlignment = Enum.TextYAlignment.Center
    descLabel.ZIndex = 100
    descLabel.TextTruncate = Enum.TextTruncate.AtEnd
    descLabel.Parent = buttonFrame
    
    -- Citação (ajustado para caber)
    local quoteLabel = Instance.new("TextLabel")
    quoteLabel.Size = UDim2.new(0.38, 0, 0, 14)
    quoteLabel.Position = UDim2.new(0.18, 0, 0.72, 0)
    quoteLabel.Text = "\"" .. (scriptData.quote or "") .. "\""
    quoteLabel.TextColor3 = scriptData.color:Lerp(Color3.fromRGB(255, 255, 255), 0.5)
    quoteLabel.BackgroundTransparency = 1
    quoteLabel.Font = Enum.Font.Gotham
    quoteLabel.TextSize = 8
    quoteLabel.TextXAlignment = Enum.TextXAlignment.Left
    quoteLabel.TextYAlignment = Enum.TextYAlignment.Center
    quoteLabel.ZIndex = 100
    quoteLabel.TextTruncate = Enum.TextTruncate.AtEnd
    quoteLabel.Parent = buttonFrame
    
    -- Botão EXECUTAR (posição fixa)
    local executeButton = Instance.new("TextButton")
    executeButton.Size = UDim2.new(0, 65, 0, 28)
    executeButton.Position = UDim2.new(1, -73, 0.5, -14)
    executeButton.Text = isVazio and "🔒 BREVE" or (isBonus and "⚡ LOAD" or "▶ LOAD")
    executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeButton.BackgroundColor3 = scriptData.color
    executeButton.Font = Enum.Font.GothamBold
    executeButton.TextSize = 10
    executeButton.BorderSizePixel = 0
    executeButton.AutoButtonColor = false
    executeButton.ZIndex = 101
    executeButton.Parent = buttonFrame
    
    local execGradient = Instance.new("UIGradient")
    execGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, scriptData.color),
        ColorSequenceKeypoint.new(1, scriptData.color2)
    }
    execGradient.Parent = executeButton
    
    local executeCorner = Instance.new("UICorner")
    executeCorner.CornerRadius = UDim.new(0, 5)
    executeCorner.Parent = executeButton
    
    -- ==================== EFEITOS HOVER ====================
    if not isVazio then
        buttonFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
                    BackgroundColor3 = isBonus and Color3.fromRGB(45, 25, 10) or Color3.fromRGB(38, 38, 48)
                }):Play()
            end
        end)
        
        buttonFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                TweenService:Create(buttonFrame, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(25, 25, 32)
                }):Play()
            end
        end)
    end
    
    -- ==================== EXECUÇÃO ====================
    local isExecuting = false
    
    executeButton.MouseButton1Click:Connect(function()
        if isVazio then
            TweenService:Create(executeButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            }):Play()
            wait(0.3)
            TweenService:Create(executeButton, TweenInfo.new(0.2), {
                BackgroundColor3 = scriptData.color
            }):Play()
            return
        end
        
        if isExecuting then return end
        isExecuting = true
        
        executeButton.Text = "⏳"
        executeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        
        TweenService:Create(iconLabel, TweenInfo.new(0.3), {
            Rotation = 360
        }):Play()
        
        spawn(function()
            local success, result = pcall(function()
                return loadstring(game:HttpGet(scriptData.url))()
            end)
            
            if success then
                executeButton.Text = "✓"
                execGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 0))
                }
            else
                executeButton.Text = "✗"
                execGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 0))
                }
                warn("Erro:", result)
            end
            
            wait(2)
            
            executeButton.Text = isBonus and "⚡ LOAD" or "▶ LOAD"
            execGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, scriptData.color),
                ColorSequenceKeypoint.new(1, scriptData.color2)
            }
            TweenService:Create(iconLabel, TweenInfo.new(0.3), {
                Rotation = 0
            }):Play()
            
            isExecuting = false
        end)
    end)
end

-- Atualizar CanvasSize
local function updateCanvasSize()
    local totalHeight = #scripts * 68 + 10
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end
updateCanvasSize()

-- ==================== ANIMAÇÕES DO MENU ====================
local menuOpen = false
local isAnimating = false

local function openMenu()
    if isAnimating then return end
    isAnimating = true
    
    menuFrame.Visible = true
    menuFrame.Size = UDim2.new(0, 300, 0, 0)
    menuFrame.BackgroundTransparency = 1
    
    local expandTween = TweenService:Create(menuFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0.80, 0),
        BackgroundTransparency = 0
    })
    expandTween:Play()
    
    TweenService:Create(toggleButton, TweenInfo.new(0.3), {
        Rotation = 180
    }):Play()
    toggleButton.Text = "✕"
    toggleStroke.Color = Color3.fromRGB(255, 100, 100)
    
    expandTween.Completed:Connect(function()
        isAnimating = false
    end)
    
    menuOpen = true
end

local function closeMenu()
    if isAnimating then return end
    isAnimating = true
    
    local collapseTween = TweenService:Create(menuFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 300, 0, 0),
        BackgroundTransparency = 1
    })
    collapseTween:Play()
    
    TweenService:Create(toggleButton, TweenInfo.new(0.3), {
        Rotation = 0
    }):Play()
    toggleButton.Text = "★"
    toggleStroke.Color = Color3.fromRGB(255, 215, 0)
    
    collapseTween.Completed:Connect(function()
        menuFrame.Visible = false
        isAnimating = false
    end)
    
    menuOpen = false
end

-- ==================== EVENTOS ====================
toggleButton.MouseButton1Click:Connect(function()
    if menuOpen then
        closeMenu()
    else
        openMenu()
    end
end)

closeButton.MouseButton1Click:Connect(function()
    closeMenu()
end)

-- ==================== EFEITO DE PULSAÇÃO ====================
spawn(function()
    while true do
        if not menuOpen then
            TweenService:Create(toggleShadow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.5,
                Size = UDim2.new(1.6, 0, 1.6, 0)
            }):Play()
            wait(1.5)
            TweenService:Create(toggleShadow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                ImageTransparency = 0.7,
                Size = UDim2.new(1.3, 0, 1.3, 0)
            }):Play()
            wait(1.5)
        else
            wait(1)
        end
    end
end)

-- ==================== TECLA DE ATALHO (END) ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.End then
        if menuOpen then
            closeMenu()
        else
            openMenu()
        end
    end
end)
