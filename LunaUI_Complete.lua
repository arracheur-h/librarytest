--[[
    3XT4SY LUNA UI LIBRARY v2
    Complete Sidebar Navigation with Animations
]]

local LunaUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Utility Functions
local function CreateInstance(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties) do
        if property ~= "Parent" then
            instance[property] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function Tween(object, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragHandle = dragHandle or frame
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Extended Theme System
local Themes = {
    Dark = {
        Primary = Color3.fromRGB(88, 101, 242),
        Background = Color3.fromRGB(35, 39, 42),
        Sidebar = Color3.fromRGB(47, 49, 54),
        Surface = Color3.fromRGB(47, 49, 54),
        Hover = Color3.fromRGB(60, 63, 68),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(142, 146, 151),
        Accent = Color3.fromRGB(88, 101, 242),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Error = Color3.fromRGB(240, 71, 71),
    },
    Light = {
        Primary = Color3.fromRGB(88, 101, 242),
        Background = Color3.fromRGB(255, 255, 255),
        Sidebar = Color3.fromRGB(242, 243, 245),
        Surface = Color3.fromRGB(249, 249, 251),
        Hover = Color3.fromRGB(235, 236, 240),
        Text = Color3.fromRGB(0, 0, 0),
        TextDim = Color3.fromRGB(114, 118, 125),
        Accent = Color3.fromRGB(88, 101, 242),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Error = Color3.fromRGB(240, 71, 71),
    },
    Cyberpunk = {
        Primary = Color3.fromRGB(255, 0, 102),
        Background = Color3.fromRGB(15, 15, 25),
        Sidebar = Color3.fromRGB(25, 25, 40),
        Surface = Color3.fromRGB(30, 30, 45),
        Hover = Color3.fromRGB(40, 40, 55),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(180, 180, 220),
        Accent = Color3.fromRGB(0, 255, 255),
        Success = Color3.fromRGB(0, 255, 157),
        Warning = Color3.fromRGB(255, 191, 0),
        Error = Color3.fromRGB(255, 0, 102),
    },
    Ocean = {
        Primary = Color3.fromRGB(14, 165, 233),
        Background = Color3.fromRGB(12, 28, 51),
        Sidebar = Color3.fromRGB(20, 40, 70),
        Surface = Color3.fromRGB(25, 48, 80),
        Hover = Color3.fromRGB(35, 58, 90),
        Text = Color3.fromRGB(240, 249, 255),
        TextDim = Color3.fromRGB(148, 199, 236),
        Accent = Color3.fromRGB(6, 182, 212),
        Success = Color3.fromRGB(16, 185, 129),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(239, 68, 68),
    },
    Midnight = {
        Primary = Color3.fromRGB(124, 58, 237),
        Background = Color3.fromRGB(15, 23, 42),
        Sidebar = Color3.fromRGB(25, 35, 58),
        Surface = Color3.fromRGB(30, 41, 59),
        Hover = Color3.fromRGB(40, 51, 69),
        Text = Color3.fromRGB(248, 250, 252),
        TextDim = Color3.fromRGB(148, 163, 184),
        Accent = Color3.fromRGB(147, 51, 234),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(239, 68, 68),
    },
    Sunset = {
        Primary = Color3.fromRGB(251, 146, 60),
        Background = Color3.fromRGB(30, 20, 40),
        Sidebar = Color3.fromRGB(45, 30, 55),
        Surface = Color3.fromRGB(55, 35, 65),
        Hover = Color3.fromRGB(65, 45, 75),
        Text = Color3.fromRGB(254, 243, 199),
        TextDim = Color3.fromRGB(253, 186, 116),
        Accent = Color3.fromRGB(249, 115, 22),
        Success = Color3.fromRGB(132, 204, 22),
        Warning = Color3.fromRGB(234, 179, 8),
        Error = Color3.fromRGB(220, 38, 38),
    },
    Forest = {
        Primary = Color3.fromRGB(34, 197, 94),
        Background = Color3.fromRGB(20, 30, 25),
        Sidebar = Color3.fromRGB(30, 45, 35),
        Surface = Color3.fromRGB(35, 50, 40),
        Hover = Color3.fromRGB(45, 60, 50),
        Text = Color3.fromRGB(236, 253, 245),
        TextDim = Color3.fromRGB(167, 243, 208),
        Accent = Color3.fromRGB(22, 163, 74),
        Success = Color3.fromRGB(74, 222, 128),
        Warning = Color3.fromRGB(250, 204, 21),
        Error = Color3.fromRGB(239, 68, 68),
    },
    Tokyo = {
        Primary = Color3.fromRGB(236, 72, 153),
        Background = Color3.fromRGB(24, 24, 27),
        Sidebar = Color3.fromRGB(35, 35, 40),
        Surface = Color3.fromRGB(39, 39, 42),
        Hover = Color3.fromRGB(50, 50, 55),
        Text = Color3.fromRGB(250, 250, 250),
        TextDim = Color3.fromRGB(161, 161, 170),
        Accent = Color3.fromRGB(219, 39, 119),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(239, 68, 68),
    },
    Nord = {
        Primary = Color3.fromRGB(136, 192, 208),
        Background = Color3.fromRGB(46, 52, 64),
        Sidebar = Color3.fromRGB(55, 62, 76),
        Surface = Color3.fromRGB(59, 66, 82),
        Hover = Color3.fromRGB(67, 76, 94),
        Text = Color3.fromRGB(236, 239, 244),
        TextDim = Color3.fromRGB(216, 222, 233),
        Accent = Color3.fromRGB(129, 161, 193),
        Success = Color3.fromRGB(163, 190, 140),
        Warning = Color3.fromRGB(235, 203, 139),
        Error = Color3.fromRGB(191, 97, 106),
    },
    Dracula = {
        Primary = Color3.fromRGB(189, 147, 249),
        Background = Color3.fromRGB(40, 42, 54),
        Sidebar = Color3.fromRGB(50, 53, 66),
        Surface = Color3.fromRGB(68, 71, 90),
        Hover = Color3.fromRGB(80, 84, 105),
        Text = Color3.fromRGB(248, 248, 242),
        TextDim = Color3.fromRGB(98, 114, 164),
        Accent = Color3.fromRGB(255, 121, 198),
        Success = Color3.fromRGB(80, 250, 123),
        Warning = Color3.fromRGB(241, 250, 140),
        Error = Color3.fromRGB(255, 85, 85),
    },
    Monokai = {
        Primary = Color3.fromRGB(249, 38, 114),
        Background = Color3.fromRGB(39, 40, 34),
        Sidebar = Color3.fromRGB(50, 51, 45),
        Surface = Color3.fromRGB(73, 72, 62),
        Hover = Color3.fromRGB(90, 89, 75),
        Text = Color3.fromRGB(248, 248, 240),
        TextDim = Color3.fromRGB(117, 113, 94),
        Accent = Color3.fromRGB(174, 129, 255),
        Success = Color3.fromRGB(166, 226, 46),
        Warning = Color3.fromRGB(230, 219, 116),
        Error = Color3.fromRGB(249, 38, 114),
    },
    Gruvbox = {
        Primary = Color3.fromRGB(251, 73, 52),
        Background = Color3.fromRGB(40, 40, 40),
        Sidebar = Color3.fromRGB(50, 48, 47),
        Surface = Color3.fromRGB(60, 56, 54),
        Hover = Color3.fromRGB(80, 73, 69),
        Text = Color3.fromRGB(235, 219, 178),
        TextDim = Color3.fromRGB(168, 153, 132),
        Accent = Color3.fromRGB(250, 189, 47),
        Success = Color3.fromRGB(184, 187, 38),
        Warning = Color3.fromRGB(250, 189, 47),
        Error = Color3.fromRGB(251, 73, 52),
    },
    Matrix = {
        Primary = Color3.fromRGB(0, 255, 65),
        Background = Color3.fromRGB(0, 0, 0),
        Sidebar = Color3.fromRGB(5, 10, 5),
        Surface = Color3.fromRGB(10, 20, 10),
        Hover = Color3.fromRGB(15, 30, 15),
        Text = Color3.fromRGB(0, 255, 65),
        TextDim = Color3.fromRGB(0, 180, 45),
        Accent = Color3.fromRGB(0, 200, 50),
        Success = Color3.fromRGB(0, 255, 100),
        Warning = Color3.fromRGB(200, 255, 0),
        Error = Color3.fromRGB(255, 50, 50),
    },
    Crimson = {
        Primary = Color3.fromRGB(220, 20, 60),
        Background = Color3.fromRGB(25, 10, 15),
        Sidebar = Color3.fromRGB(35, 15, 22),
        Surface = Color3.fromRGB(45, 20, 30),
        Hover = Color3.fromRGB(60, 30, 40),
        Text = Color3.fromRGB(255, 240, 245),
        TextDim = Color3.fromRGB(200, 150, 170),
        Accent = Color3.fromRGB(178, 34, 34),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(220, 20, 60),
    },
    Royal = {
        Primary = Color3.fromRGB(75, 0, 130),
        Background = Color3.fromRGB(25, 15, 35),
        Sidebar = Color3.fromRGB(35, 20, 48),
        Surface = Color3.fromRGB(45, 30, 60),
        Hover = Color3.fromRGB(60, 40, 75),
        Text = Color3.fromRGB(230, 220, 250),
        TextDim = Color3.fromRGB(180, 160, 210),
        Accent = Color3.fromRGB(138, 43, 226),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(255, 215, 0),
        Error = Color3.fromRGB(220, 20, 60),
    }
}

-- Main Library
function LunaUI:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "Luna UI"
    local ThemeName = config.Theme or "Dark"
    local Theme = Themes[ThemeName]
    local ShowLogo = config.Logo ~= false
    
    -- Remove existing GUI
    if CoreGui:FindFirstChild("LunaUI") then
        CoreGui:FindFirstChild("LunaUI"):Destroy()
    end
    
    -- Main ScreenGui
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "LunaUI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
    })
    
    -- Loading Screen with Theme Colors
    local LoadingFrame = CreateInstance("Frame", {
        Name = "LoadingFrame",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ZIndex = 100,
        Parent = ScreenGui,
    })
    
    -- Animated particles background
    local ParticlesFrame = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = LoadingFrame,
    })
    
    -- Create animated particles
    for i = 1, 20 do
        local Particle = CreateInstance("Frame", {
            Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8)),
            Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0),
            BackgroundColor3 = Theme.Primary,
            BackgroundTransparency = math.random(30, 70) / 100,
            BorderSizePixel = 0,
            Parent = ParticlesFrame,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = Particle,
        })
        
        -- Animate particles
        spawn(function()
            while Particle.Parent do
                local randomX = math.random(-50, 50)
                local randomY = math.random(-50, 50)
                Tween(Particle, {
                    Position = Particle.Position + UDim2.new(0, randomX, 0, randomY),
                    BackgroundTransparency = math.random(30, 90) / 100
                }, math.random(20, 40) / 10, Enum.EasingStyle.Sine)
                wait(math.random(20, 40) / 10)
            end
        end)
    end
    
    -- Logo container
    local LogoContainer = CreateInstance("Frame", {
        Size = UDim2.new(0, 400, 0, 200),
        Position = UDim2.new(0.5, -200, 0.5, -100),
        BackgroundTransparency = 1,
        Parent = LoadingFrame,
    })
    
    -- Main logo text with shadow
    local LogoShadow = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 80),
        Position = UDim2.new(0, 3, 0, 3),
        BackgroundTransparency = 1,
        Text = "3XT4SY",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 64,
        Font = Enum.Font.GothamBold,
        TextTransparency = 0.7,
        ZIndex = 1,
        Parent = LogoContainer,
    })
    
    local LoadingLogo = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 80),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "3XT4SY",
        TextColor3 = Theme.Primary,
        TextSize = 0,
        Font = Enum.Font.GothamBold,
        ZIndex = 2,
        Parent = LogoContainer,
    })
    
    -- Gradient on logo
    local LogoGradient = CreateInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Primary),
            ColorSequenceKeypoint.new(1, Theme.Accent),
        }),
        Parent = LoadingLogo,
    })
    
    -- Subtitle
    local SubtitleText = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 90),
        BackgroundTransparency = 1,
        Text = "by 3xt4sy and 27azerty",
        TextColor3 = Theme.TextDim,
        TextSize = 16,
        Font = Enum.Font.Gotham,
        TextTransparency = 1,
        Parent = LogoContainer,
    })
    
    -- Loading bar background
    local LoadingBarBG = CreateInstance("Frame", {
        Size = UDim2.new(0, 300, 0, 4),
        Position = UDim2.new(0, 50, 0, 150),
        BackgroundColor3 = Theme.Surface,
        BorderSizePixel = 0,
        Parent = LogoContainer,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = LoadingBarBG,
    })
    
    -- Loading bar fill
    local LoadingBar = CreateInstance("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0,
        Parent = LoadingBarBG,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(1, 0),
        Parent = LoadingBar,
    })
    
    local LoadingBarGradient = CreateInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Primary),
            ColorSequenceKeypoint.new(1, Theme.Accent),
        }),
        Parent = LoadingBar,
    })
    
    -- Animate loading
    spawn(function()
        -- Logo bounce in
        Tween(LoadingLogo, {TextSize = 64}, 0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        wait(0.5)
        
        -- Fade in subtitle
        Tween(SubtitleText, {TextTransparency = 0}, 0.5, Enum.EasingStyle.Quad)
        
        wait(0.3)
        
        -- Animate loading bar
        Tween(LoadingBar, {Size = UDim2.new(1, 0, 1, 0)}, 1.2, Enum.EasingStyle.Quad)
        
        wait(1.2)
        
        -- Fade out
        Tween(LoadingFrame, {BackgroundTransparency = 1}, 0.4)
        Tween(LoadingLogo, {TextTransparency = 1}, 0.4)
        Tween(LogoShadow, {TextTransparency = 1}, 0.4)
        Tween(SubtitleText, {TextTransparency = 1}, 0.4)
        Tween(LoadingBar, {BackgroundTransparency = 1}, 0.4)
        Tween(LoadingBarBG, {BackgroundTransparency = 1}, 0.4)
        
        for _, particle in pairs(ParticlesFrame:GetChildren()) do
            Tween(particle, {BackgroundTransparency = 1}, 0.4)
        end
        
        wait(0.4)
        LoadingFrame:Destroy()
    end)
    
    -- Main Container with transparency
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = ScreenGui,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = MainFrame,
    })
    
    -- Animate window opening
    task.wait(2)
    Tween(MainFrame, {Size = UDim2.new(0, 750, 0, 500)}, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- K key to minimize
    local minimized = false
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.K then
            minimized = not minimized
            if minimized then
                Tween(MainFrame, {Size = UDim2.new(0, 750, 0, 45)}, 0.3, Enum.EasingStyle.Quad)
            else
                Tween(MainFrame, {Size = UDim2.new(0, 750, 0, 500)}, 0.3, Enum.EasingStyle.Quad)
            end
        end
    end)
    
    -- Drop Shadow
    local Shadow = CreateInstance("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = -1,
        Parent = MainFrame,
    })
    
    -- Top Bar
    local TopBar = CreateInstance("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = TopBar,
    })
    
    local TopBarMask = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = TopBar,
    })
    
    -- Logo/Icon
    local Logo = CreateInstance("ImageLabel", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 12, 0.5, -12),
        BackgroundTransparency = 1,
        Image = "rbxassetid://7733674731",
        ImageColor3 = Theme.Primary,
        Parent = TopBar,
    })
    
    -- Title
    local Title = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 45, 0, 0),
        BackgroundTransparency = 1,
        Text = WindowName,
        TextColor3 = Theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar,
    })
    
    -- Minimize Button
    local MinimizeButton = CreateInstance("TextButton", {
        Size = UDim2.new(0, 35, 0, 35),
        Position = UDim2.new(1, -80, 0.5, -17.5),
        BackgroundColor3 = Theme.Surface,
        Text = "─",
        TextColor3 = Theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        Parent = TopBar,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = MinimizeButton,
    })
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(MainFrame, {Size = UDim2.new(0, 750, 0, 45)}, 0.3)
            MinimizeButton.Text = "+"
        else
            Tween(MainFrame, {Size = UDim2.new(0, 750, 0, 500)}, 0.3)
            MinimizeButton.Text = "─"
        end
    end)
    
    -- Close Button
    local CloseButton = CreateInstance("TextButton", {
        Size = UDim2.new(0, 35, 0, 35),
        Position = UDim2.new(1, -40, 0.5, -17.5),
        BackgroundColor3 = Color3.fromRGB(240, 71, 71),
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = TopBar,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = CloseButton,
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.4)
        ScreenGui:Destroy()
    end)
    
    -- Sidebar
    local Sidebar = CreateInstance("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 70, 1, -45),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })
    
    local SidebarList = CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        Parent = Sidebar,
    })
    
    CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 15),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = Sidebar,
    })
    
    -- Content Area
    local ContentArea = CreateInstance("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -70, 1, -45),
        Position = UDim2.new(0, 70, 0, 45),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = MainFrame,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = ContentArea,
    })
    
    local ContentMask = CreateInstance("Frame", {
        Size = UDim2.new(0, 10, 1, 0),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = ContentArea,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = ContentArea,
    })
    
    -- Make draggable
    MakeDraggable(MainFrame, TopBar)
    
    -- Window object
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Theme = Theme,
        ThemeName = ThemeName,
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Sidebar = Sidebar,
        ContentArea = ContentArea,
    }
    
    -- Theme Changer
    function Window:SetTheme(themeName)
        if not Themes[themeName] then return end
        Theme = Themes[themeName]
        Window.Theme = Theme
        Window.ThemeName = themeName
        
        -- Update colors
        Tween(MainFrame, {BackgroundColor3 = Theme.Background}, 0.3)
        Tween(ContentArea, {BackgroundColor3 = Theme.Background}, 0.3)
        Tween(TopBar, {BackgroundColor3 = Theme.Sidebar}, 0.3)
        Tween(TopBarMask, {BackgroundColor3 = Theme.Sidebar}, 0.3)
        Tween(Sidebar, {BackgroundColor3 = Theme.Sidebar}, 0.3)
        Tween(ContentMask, {BackgroundColor3 = Theme.Background}, 0.3)
        Tween(Title, {TextColor3 = Theme.Text}, 0.3)
        Tween(Logo, {ImageColor3 = Theme.Primary}, 0.3)
        
        self:Notify({
            Title = "Theme Changed",
            Content = themeName .. " theme applied",
            Duration = 2,
            Type = "Success"
        })
    end
    
    -- Create Tab
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local TabName = tabConfig.Name or "Tab"
        local TabIcon = tabConfig.Icon or "rbxassetid://7733674731"
        
        -- Tab Button in Sidebar
        local TabButton = CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Theme.Surface,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = Sidebar,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = TabButton,
        })
        
        -- Icon (support both text and image)
        local Icon
        if TabIcon:find("rbxassetid://") then
            Icon = CreateInstance("ImageLabel", {
                Size = UDim2.new(0, 28, 0, 28),
                Position = UDim2.new(0.5, -14, 0.5, -14),
                BackgroundTransparency = 1,
                Image = TabIcon,
                ImageColor3 = Theme.TextDim,
                Parent = TabButton,
            })
        else
            Icon = CreateInstance("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = TabIcon,
                TextColor3 = Theme.TextDim,
                TextSize = 22,
                Font = Enum.Font.GothamBold,
                Parent = TabButton,
            })
        end
        
        -- Hover effect
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab and Window.CurrentTab.Button ~= TabButton then
                Tween(TabButton, {BackgroundTransparency = 0.7}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab and Window.CurrentTab.Button ~= TabButton then
                Tween(TabButton, {BackgroundTransparency = 1}, 0.2)
            end
        end)
        
        -- Tab Content Container
        local TabContent = CreateInstance("ScrollingFrame", {
            Name = TabName .. "Content",
            Size = UDim2.new(1, -30, 1, -30),
            Position = UDim2.new(0, 15, 0, 15),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 5,
            ScrollBarImageColor3 = Theme.Primary,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = ContentArea,
        })
        
        local ContentList = CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10),
            Parent = TabContent,
        })
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab object
        local Tab = {
            Button = TabButton,
            Content = TabContent,
            Icon = Icon,
            Name = TabName,
        }
        
        -- Tab switching with animation
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                Tween(tab.Content, {Position = UDim2.new(0, -50, 0, 15)}, 0.15)
                task.wait(0.15)
                tab.Content.Visible = false
                tab.Content.Position = UDim2.new(0, 50, 0, 15)
                Tween(tab.Button, {BackgroundTransparency = 1}, 0.2)
                if tab.Icon.ClassName == "ImageLabel" then
                    Tween(tab.Icon, {ImageColor3 = Theme.TextDim}, 0.2)
                else
                    Tween(tab.Icon, {TextColor3 = Theme.TextDim}, 0.2)
                end
            end
            
            TabContent.Visible = true
            Tween(TabContent, {Position = UDim2.new(0, 15, 0, 15)}, 0.3, Enum.EasingStyle.Quad)
            Tween(TabButton, {BackgroundTransparency = 0}, 0.2)
            if Icon.ClassName == "ImageLabel" then
                Tween(Icon, {ImageColor3 = Theme.Primary}, 0.2)
            else
                Tween(Icon, {TextColor3 = Theme.Primary}, 0.2)
            end
            Window.CurrentTab = Tab
        end)
        
        table.insert(Window.Tabs, Tab)
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            task.wait(2.6)
            TabContent.Visible = true
            TabButton.BackgroundTransparency = 0
            if Icon.ClassName == "ImageLabel" then
                Icon.ImageColor3 = Theme.Primary
            else
                Icon.TextColor3 = Theme.Primary
            end
            Window.CurrentTab = Tab
        end
        
        -- Components
        function Tab:CreateSection(text)
            local Section = CreateInstance("TextLabel", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.Text,
                TextSize = 16,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = TabContent,
            })
            
            CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 5),
                Parent = Section,
            })
            
            local Divider = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 2),
                Position = UDim2.new(0, 0, 1, -2),
                BackgroundColor3 = Theme.Primary,
                BorderSizePixel = 0,
                Parent = Section,
            })
        end
        
        function Tab:CreateLabel(text)
            local Label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, 0, 0, text == "" and 5 or 25),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.TextDim,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = TabContent,
            })
            
            CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                Parent = Label,
            })
        end
        
        function Tab:CreateButton(btnConfig)
            btnConfig = btnConfig or {}
            local ButtonName = btnConfig.Name or "Button"
            local Callback = btnConfig.Callback or function() end
            
            local Button = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = Button,
            })
            
            local ButtonText = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = ButtonName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Button,
            })
            
            local Arrow = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -25, 0, 0),
                BackgroundTransparency = 1,
                Text = "→",
                TextColor3 = Theme.Primary,
                TextSize = 16,
                Font = Enum.Font.GothamBold,
                Parent = Button,
            })
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Hover}, 0.2)
                Tween(Arrow, {Position = UDim2.new(1, -20, 0, 0)}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Surface}, 0.2)
                Tween(Arrow, {Position = UDim2.new(1, -25, 0, 0)}, 0.2)
            end)
            
            Button.MouseButton1Click:Connect(Callback)
        end
        
        function Tab:CreateToggle(toggleConfig)
            toggleConfig = toggleConfig or {}
            local ToggleName = toggleConfig.Name or "Toggle"
            local Default = toggleConfig.Default or false
            local Callback = toggleConfig.Callback or function() end
            
            local ToggleFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = ToggleFrame,
            })
            
            local ToggleText = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -70, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = ToggleName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame,
            })
            
            local ToggleButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 45, 0, 24),
                Position = UDim2.new(1, -55, 0.5, -12),
                BackgroundColor3 = Default and Theme.Success or Theme.TextDim,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = ToggleFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleButton,
            })
            
            local ToggleIndicator = CreateInstance("Frame", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = Default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Parent = ToggleButton,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleIndicator,
            })
            
            local toggled = Default
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                Callback(toggled)
                
                Tween(ToggleButton, {BackgroundColor3 = toggled and Theme.Success or Theme.TextDim}, 0.2)
                Tween(ToggleIndicator, {Position = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}, 0.25, Enum.EasingStyle.Back)
            end)
        end
        
        function Tab:CreateSlider(sliderConfig)
            sliderConfig = sliderConfig or {}
            local SliderName = sliderConfig.Name or "Slider"
            local Min = sliderConfig.Min or 0
            local Max = sliderConfig.Max or 100
            local Default = sliderConfig.Default or Min
            local Callback = sliderConfig.Callback or function() end
            
            local SliderFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 55),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = SliderFrame,
            })
            
            local SliderText = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -70, 0, 20),
                Position = UDim2.new(0, 15, 0, 8),
                BackgroundTransparency = 1,
                Text = SliderName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame,
            })
            
            local ValueLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 60, 0, 20),
                Position = UDim2.new(1, -65, 0, 8),
                BackgroundTransparency = 1,
                Text = tostring(Default),
                TextColor3 = Theme.Primary,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = SliderFrame,
            })
            
            local SliderTrack = CreateInstance("Frame", {
                Size = UDim2.new(1, -30, 0, 5),
                Position = UDim2.new(0, 15, 1, -18),
                BackgroundColor3 = Theme.Hover,
                BorderSizePixel = 0,
                Parent = SliderFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderTrack,
            })
            
            local SliderFill = CreateInstance("Frame", {
                Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
                BackgroundColor3 = Theme.Primary,
                BorderSizePixel = 0,
                Parent = SliderTrack,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderFill,
            })
            
            local SliderButton = CreateInstance("Frame", {
                Size = UDim2.new(0, 15, 0, 15),
                Position = UDim2.new((Default - Min) / (Max - Min), -7.5, 0.5, -7.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Parent = SliderTrack,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderButton,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Primary,
                Thickness = 3,
                Parent = SliderButton,
            })
            
            local dragging = false
            
            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            SliderTrack.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = input.Position.X
                    local sliderPos = SliderTrack.AbsolutePosition.X
                    local sliderSize = SliderTrack.AbsoluteSize.X
                    local value = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
                    local finalValue = math.floor(Min + (Max - Min) * value)
                    
                    SliderFill.Size = UDim2.new(value, 0, 1, 0)
                    SliderButton.Position = UDim2.new(value, -7.5, 0.5, -7.5)
                    ValueLabel.Text = tostring(finalValue)
                    Callback(finalValue)
                end
            end)
        end
        
        function Tab:CreateDropdown(dropdownConfig)
            dropdownConfig = dropdownConfig or {}
            local DropdownName = dropdownConfig.Name or "Dropdown"
            local Options = dropdownConfig.Options or {}
            local Default = dropdownConfig.Default or (Options[1] or "")
            local Callback = dropdownConfig.Callback or function() end
            
            local DropdownFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = DropdownFrame,
            })
            
            local DropdownButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = DropdownFrame,
            })
            
            local DropdownText = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -50, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = DropdownName .. ": " .. Default,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownFrame,
            })
            
            local Arrow = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 25, 1, 0),
                Position = UDim2.new(1, -35, 0, 0),
                BackgroundTransparency = 1,
                Text = "▼",
                TextColor3 = Theme.TextDim,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                Parent = DropdownFrame,
            })
            
            local DropdownContainer = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 5),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Visible = false,
                ZIndex = 10,
                Parent = DropdownFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = DropdownContainer,
            })
            
            CreateInstance("UIStroke", {
                Color = Theme.Primary,
                Thickness = 1,
                Parent = DropdownContainer,
            })
            
            local OptionsList = CreateInstance("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = DropdownContainer,
            })
            
            local isOpen = false
            
            for _, option in ipairs(Options) do
                local OptionButton = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundTransparency = 1,
                    Text = option,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    Parent = DropdownContainer,
                })
                
                OptionButton.MouseEnter:Connect(function()
                    Tween(OptionButton, {BackgroundTransparency = 0.9}, 0.1)
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    Tween(OptionButton, {BackgroundTransparency = 1}, 0.1)
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownText.Text = DropdownName .. ": " .. option
                    Callback(option)
                    
                    isOpen = false
                    Tween(DropdownContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    Tween(Arrow, {Rotation = 0}, 0.2)
                    wait(0.2)
                    DropdownContainer.Visible = false
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    DropdownContainer.Visible = true
                    Tween(DropdownContainer, {Size = UDim2.new(1, 0, 0, math.min(#Options * 35, 175))}, 0.3, Enum.EasingStyle.Quad)
                    Tween(Arrow, {Rotation = 180}, 0.2)
                else
                    Tween(DropdownContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    Tween(Arrow, {Rotation = 0}, 0.2)
                    wait(0.2)
                    DropdownContainer.Visible = false
                end
            end)
        end
        
        function Tab:CreateInput(inputConfig)
            inputConfig = inputConfig or {}
            local InputName = inputConfig.Name or "Input"
            local Placeholder = inputConfig.Placeholder or "Enter text..."
            local Callback = inputConfig.Callback or function() end
            
            local InputFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = InputFrame,
            })
            
            local InputLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 120, 1, 0),
                Position = UDim2.new(0, 15, 0, 0),
                BackgroundTransparency = 1,
                Text = InputName .. ":",
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamMedium,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = InputFrame,
            })
            
            local InputBox = CreateInstance("TextBox", {
                Size = UDim2.new(1, -145, 0, 28),
                Position = UDim2.new(0, 135, 0, 6),
                BackgroundColor3 = Theme.Hover,
                BorderSizePixel = 0,
                Text = "",
                PlaceholderText = Placeholder,
                TextColor3 = Theme.Text,
                PlaceholderColor3 = Theme.TextDim,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                Parent = InputFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = InputBox,
            })
            
            CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                Parent = InputBox,
            })
            
            InputBox.Focused:Connect(function()
                Tween(InputBox, {BackgroundColor3 = Theme.Primary}, 0.2)
            end)
            
            InputBox.FocusLost:Connect(function(enterPressed)
                Tween(InputBox, {BackgroundColor3 = Theme.Hover}, 0.2)
                if enterPressed then
                    Callback(InputBox.Text)
                end
            end)
        end
        
        function Tab:CreateImage(imageConfig)
            imageConfig = imageConfig or {}
            local ImageId = imageConfig.Image or "rbxassetid://7733674731"
            local ImageSize = imageConfig.Size or UDim2.new(1, 0, 0, 150)
            
            local ImageFrame = CreateInstance("Frame", {
                Size = ImageSize,
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = ImageFrame,
            })
            
            local Image = CreateInstance("ImageLabel", {
                Size = UDim2.new(1, -10, 1, -10),
                Position = UDim2.new(0, 5, 0, 5),
                BackgroundTransparency = 1,
                Image = ImageId,
                ScaleType = Enum.ScaleType.Fit,
                Parent = ImageFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = Image,
            })
        end
        
        return Tab
    end
    
    -- Notification System
    local notificationQueue = {}
    
    function Window:Notify(notifConfig)
        notifConfig = notifConfig or {}
        local Title = notifConfig.Title or "Notification"
        local Content = notifConfig.Content or ""
        local Duration = notifConfig.Duration or 3
        local Type = notifConfig.Type or "Info"
        
        local typeColors = {
            Info = Theme.Primary,
            Success = Theme.Success,
            Warning = Theme.Warning,
            Error = Theme.Error,
        }
        
        local NotifFrame = CreateInstance("Frame", {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(1, -20, 1, -100 - (#notificationQueue * 90)),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = Theme.Surface,
            BorderSizePixel = 0,
            Parent = ScreenGui,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = NotifFrame,
        })
        
        CreateInstance("UIStroke", {
            Color = typeColors[Type] or Theme.Primary,
            Thickness = 2,
            Parent = NotifFrame,
        })
        
        local Accent = CreateInstance("Frame", {
            Size = UDim2.new(0, 5, 1, 0),
            BackgroundColor3 = typeColors[Type] or Theme.Primary,
            BorderSizePixel = 0,
            Parent = NotifFrame,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = Accent,
        })
        
        local NotifTitle = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -25, 0, 22),
            Position = UDim2.new(0, 18, 0, 10),
            BackgroundTransparency = 1,
            Text = Title,
            TextColor3 = Theme.Text,
            TextSize = 15,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = NotifFrame,
        })
        
        local NotifContent = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -25, 0, 35),
            Position = UDim2.new(0, 18, 0, 32),
            BackgroundTransparency = 1,
            Text = Content,
            TextColor3 = Theme.TextDim,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = NotifFrame,
        })
        
        table.insert(notificationQueue, NotifFrame)
        
        -- Animate in
        Tween(NotifFrame, {Size = UDim2.new(0, 320, 0, 75)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        task.wait(Duration)
        
        -- Animate out
        Tween(NotifFrame, {Position = UDim2.new(1, 20, 1, -100 - (#notificationQueue * 90))}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.wait(0.3)
        NotifFrame:Destroy()
        
        for i, notif in ipairs(notificationQueue) do
            if notif == NotifFrame then
                table.remove(notificationQueue, i)
                break
            end
        end
    end
    
    return Window
end

return LunaUI
