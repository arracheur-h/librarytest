--[[
    ██████╗ ██╗  ██╗████████╗██╗  ██╗███████╗██╗   ██╗
    ╚════██╗╚██╗██╔╝╚══██╔══╝██║  ██║██╔════╝╚██╗ ██╔╝
     █████╔╝ ╚███╔╝    ██║   ███████║███████╗ ╚████╔╝ 
     ╚═══██╗ ██╔██╗    ██║   ╚════██║╚════██║  ╚██╔╝  
    ██████╔╝██╔╝ ██╗   ██║        ██║███████║   ██║   
    ╚═════╝ ╚═╝  ╚═╝   ╚═╝        ╚═╝╚══════╝   ╚═╝   
    
    3xt4sy - Modern UI Library for Roblox
    Version: 1.0.0
]]

local Extasy = {}
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

local function Tween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out
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
            Tween(frame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.1)
        end
    end)
end

-- Theme System
local Themes = {
    Dark = {
        Primary = Color3.fromRGB(139, 92, 246),
        Secondary = Color3.fromRGB(99, 102, 241),
        Background = Color3.fromRGB(17, 24, 39),
        Surface = Color3.fromRGB(31, 41, 55),
        Text = Color3.fromRGB(243, 244, 246),
        TextSecondary = Color3.fromRGB(156, 163, 175),
        Success = Color3.fromRGB(34, 197, 94),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
        Error = Color3.fromRGB(239, 68, 68),
        Accent = Color3.fromRGB(168, 85, 247),
        BackgroundTransparency = 0.1,
        SurfaceTransparency = 0.3,
    },
    Light = {
        Primary = Color3.fromRGB(139, 92, 246),
        Secondary = Color3.fromRGB(99, 102, 241),
        Background = Color3.fromRGB(249, 250, 251),
        Surface = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(17, 24, 39),
        TextSecondary = Color3.fromRGB(107, 114, 128),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(234, 179, 8),
        Error = Color3.fromRGB(239, 68, 68),
        Accent = Color3.fromRGB(168, 85, 247),
        BackgroundTransparency = 0.05,
        SurfaceTransparency = 0.1,
    },
    Cyberpunk = {
        Primary = Color3.fromRGB(255, 0, 102),
        Secondary = Color3.fromRGB(0, 255, 255),
        Background = Color3.fromRGB(15, 15, 25),
        Surface = Color3.fromRGB(25, 25, 40),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 220),
        Success = Color3.fromRGB(0, 255, 157),
        Warning = Color3.fromRGB(255, 191, 0),
        Error = Color3.fromRGB(255, 0, 102),
        Accent = Color3.fromRGB(138, 43, 255),
        BackgroundTransparency = 0.2,
        SurfaceTransparency = 0.4,
    },
    Ocean = {
        Primary = Color3.fromRGB(14, 165, 233),
        Secondary = Color3.fromRGB(6, 182, 212),
        Background = Color3.fromRGB(12, 28, 51),
        Surface = Color3.fromRGB(30, 58, 88),
        Text = Color3.fromRGB(240, 249, 255),
        TextSecondary = Color3.fromRGB(148, 199, 236),
        Success = Color3.fromRGB(16, 185, 129),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(239, 68, 68),
        Accent = Color3.fromRGB(59, 130, 246),
        BackgroundTransparency = 0.15,
        SurfaceTransparency = 0.35,
    },
    Sunset = {
        Primary = Color3.fromRGB(251, 146, 60),
        Secondary = Color3.fromRGB(249, 115, 22),
        Background = Color3.fromRGB(30, 20, 40),
        Surface = Color3.fromRGB(55, 35, 65),
        Text = Color3.fromRGB(254, 243, 199),
        TextSecondary = Color3.fromRGB(253, 186, 116),
        Success = Color3.fromRGB(132, 204, 22),
        Warning = Color3.fromRGB(234, 179, 8),
        Error = Color3.fromRGB(220, 38, 38),
        Accent = Color3.fromRGB(236, 72, 153),
        BackgroundTransparency = 0.15,
        SurfaceTransparency = 0.35,
    },
    Forest = {
        Primary = Color3.fromRGB(34, 197, 94),
        Secondary = Color3.fromRGB(22, 163, 74),
        Background = Color3.fromRGB(20, 30, 25),
        Surface = Color3.fromRGB(35, 50, 40),
        Text = Color3.fromRGB(236, 253, 245),
        TextSecondary = Color3.fromRGB(167, 243, 208),
        Success = Color3.fromRGB(74, 222, 128),
        Warning = Color3.fromRGB(250, 204, 21),
        Error = Color3.fromRGB(239, 68, 68),
        Accent = Color3.fromRGB(52, 211, 153),
        BackgroundTransparency = 0.15,
        SurfaceTransparency = 0.35,
    },
    Midnight = {
        Primary = Color3.fromRGB(124, 58, 237),
        Secondary = Color3.fromRGB(99, 102, 241),
        Background = Color3.fromRGB(15, 23, 42),
        Surface = Color3.fromRGB(30, 41, 59),
        Text = Color3.fromRGB(248, 250, 252),
        TextSecondary = Color3.fromRGB(148, 163, 184),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(239, 68, 68),
        Accent = Color3.fromRGB(147, 51, 234),
        BackgroundTransparency = 0.1,
        SurfaceTransparency = 0.3,
    },
    Tokyo = {
        Primary = Color3.fromRGB(236, 72, 153),
        Secondary = Color3.fromRGB(219, 39, 119),
        Background = Color3.fromRGB(24, 24, 27),
        Surface = Color3.fromRGB(39, 39, 42),
        Text = Color3.fromRGB(250, 250, 250),
        TextSecondary = Color3.fromRGB(161, 161, 170),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(251, 191, 36),
        Error = Color3.fromRGB(239, 68, 68),
        Accent = Color3.fromRGB(244, 114, 182),
        BackgroundTransparency = 0.15,
        SurfaceTransparency = 0.35,
    },
    Nord = {
        Primary = Color3.fromRGB(136, 192, 208),
        Secondary = Color3.fromRGB(129, 161, 193),
        Background = Color3.fromRGB(46, 52, 64),
        Surface = Color3.fromRGB(59, 66, 82),
        Text = Color3.fromRGB(236, 239, 244),
        TextSecondary = Color3.fromRGB(216, 222, 233),
        Success = Color3.fromRGB(163, 190, 140),
        Warning = Color3.fromRGB(235, 203, 139),
        Error = Color3.fromRGB(191, 97, 106),
        Accent = Color3.fromRGB(143, 188, 187),
        BackgroundTransparency = 0.1,
        SurfaceTransparency = 0.3,
    },
    Dracula = {
        Primary = Color3.fromRGB(189, 147, 249),
        Secondary = Color3.fromRGB(255, 121, 198),
        Background = Color3.fromRGB(40, 42, 54),
        Surface = Color3.fromRGB(68, 71, 90),
        Text = Color3.fromRGB(248, 248, 242),
        TextSecondary = Color3.fromRGB(98, 114, 164),
        Success = Color3.fromRGB(80, 250, 123),
        Warning = Color3.fromRGB(241, 250, 140),
        Error = Color3.fromRGB(255, 85, 85),
        Accent = Color3.fromRGB(139, 233, 253),
        BackgroundTransparency = 0.15,
        SurfaceTransparency = 0.35,
    },
    Monokai = {
        Primary = Color3.fromRGB(249, 38, 114),
        Secondary = Color3.fromRGB(174, 129, 255),
        Background = Color3.fromRGB(39, 40, 34),
        Surface = Color3.fromRGB(73, 72, 62),
        Text = Color3.fromRGB(248, 248, 240),
        TextSecondary = Color3.fromRGB(117, 113, 94),
        Success = Color3.fromRGB(166, 226, 46),
        Warning = Color3.fromRGB(230, 219, 116),
        Error = Color3.fromRGB(249, 38, 114),
        Accent = Color3.fromRGB(102, 217, 239),
        BackgroundTransparency = 0.15,
        SurfaceTransparency = 0.35,
    },
    Gruvbox = {
        Primary = Color3.fromRGB(251, 73, 52),
        Secondary = Color3.fromRGB(250, 189, 47),
        Background = Color3.fromRGB(40, 40, 40),
        Surface = Color3.fromRGB(60, 56, 54),
        Text = Color3.fromRGB(235, 219, 178),
        TextSecondary = Color3.fromRGB(168, 153, 132),
        Success = Color3.fromRGB(184, 187, 38),
        Warning = Color3.fromRGB(250, 189, 47),
        Error = Color3.fromRGB(251, 73, 52),
        Accent = Color3.fromRGB(254, 128, 25),
        BackgroundTransparency = 0.1,
        SurfaceTransparency = 0.3,
    },
    Matrix = {
        Primary = Color3.fromRGB(0, 255, 65),
        Secondary = Color3.fromRGB(0, 200, 50),
        Background = Color3.fromRGB(0, 0, 0),
        Surface = Color3.fromRGB(10, 20, 10),
        Text = Color3.fromRGB(0, 255, 65),
        TextSecondary = Color3.fromRGB(0, 180, 45),
        Success = Color3.fromRGB(0, 255, 100),
        Warning = Color3.fromRGB(200, 255, 0),
        Error = Color3.fromRGB(255, 50, 50),
        Accent = Color3.fromRGB(0, 230, 60),
        BackgroundTransparency = 0.05,
        SurfaceTransparency = 0.25,
    },
    Neon = {
        Primary = Color3.fromRGB(57, 255, 20),
        Secondary = Color3.fromRGB(255, 20, 147),
        Background = Color3.fromRGB(10, 10, 15),
        Surface = Color3.fromRGB(20, 20, 30),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 200),
        Success = Color3.fromRGB(57, 255, 20),
        Warning = Color3.fromRGB(255, 255, 0),
        Error = Color3.fromRGB(255, 0, 100),
        Accent = Color3.fromRGB(0, 255, 255),
        BackgroundTransparency = 0.2,
        SurfaceTransparency = 0.4,
    },
    Crimson = {
        Primary = Color3.fromRGB(220, 20, 60),
        Secondary = Color3.fromRGB(178, 34, 34),
        Background = Color3.fromRGB(25, 10, 15),
        Surface = Color3.fromRGB(45, 20, 30),
        Text = Color3.fromRGB(255, 240, 245),
        TextSecondary = Color3.fromRGB(200, 150, 170),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(220, 20, 60),
        Accent = Color3.fromRGB(255, 20, 147),
        BackgroundTransparency = 0.15,
        SurfaceTransparency = 0.35,
    },
    Royal = {
        Primary = Color3.fromRGB(75, 0, 130),
        Secondary = Color3.fromRGB(138, 43, 226),
        Background = Color3.fromRGB(25, 15, 35),
        Surface = Color3.fromRGB(45, 30, 60),
        Text = Color3.fromRGB(230, 220, 250),
        TextSecondary = Color3.fromRGB(180, 160, 210),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(255, 215, 0),
        Error = Color3.fromRGB(220, 20, 60),
        Accent = Color3.fromRGB(147, 51, 234),
        BackgroundTransparency = 0.15,
        SurfaceTransparency = 0.35,
    },
    Arctic = {
        Primary = Color3.fromRGB(100, 200, 255),
        Secondary = Color3.fromRGB(135, 206, 235),
        Background = Color3.fromRGB(240, 248, 255),
        Surface = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(30, 50, 70),
        TextSecondary = Color3.fromRGB(100, 130, 160),
        Success = Color3.fromRGB(34, 197, 94),
        Warning = Color3.fromRGB(255, 193, 7),
        Error = Color3.fromRGB(220, 53, 69),
        Accent = Color3.fromRGB(70, 170, 255),
        BackgroundTransparency = 0.05,
        SurfaceTransparency = 0.1,
    }
}

-- Main Library
function Extasy:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "3xt4sy"
    local CurrentTheme = config.Theme or "Dark"
    local Theme = Themes[CurrentTheme]
    local LoadingEnabled = config.LoadingEnabled ~= false
    local MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightControl
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Minimized = false
    Window.Notifications = {}
    Window.CurrentTheme = CurrentTheme
    
    -- Create ScreenGui
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "Extasy",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
    })
    
    -- Main Frame
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, -300, 0.5, -225),
        BackgroundColor3 = Theme.Background,
        BackgroundTransparency = Theme.BackgroundTransparency or 0.1,
        BorderSizePixel = 0,
        Parent = ScreenGui,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = MainFrame,
    })
    
    local Blur = CreateInstance("Frame", {
        Name = "Blur",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = Theme.SurfaceTransparency or 0.3,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = Blur,
    })
    
    local Glow = CreateInstance("ImageLabel", {
        Name = "Glow",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0, -20, 0, -20),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = Theme.Primary,
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(24, 24, 276, 276),
        Parent = MainFrame,
        ZIndex = 0,
    })
    
    local TopBar = CreateInstance("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = Theme.SurfaceTransparency or 0.5,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = TopBar,
    })
    
    local Title = CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0.5, -80, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        Text = WindowName,
        TextColor3 = Theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar,
    })
    
    local AccentLine = CreateInstance("Frame", {
        Name = "AccentLine",
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Primary,
        BorderSizePixel = 0,
        Parent = TopBar,
    })
    
    CreateInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Theme.Primary),
            ColorSequenceKeypoint.new(0.5, Theme.Accent),
            ColorSequenceKeypoint.new(1, Theme.Secondary),
        }),
        Parent = AccentLine,
    })
    
    local CloseButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 35, 0, 35),
        Position = UDim2.new(1, -45, 0, 7.5),
        BackgroundColor3 = Theme.Error,
        BackgroundTransparency = 0.8,
        Text = "✕",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = TopBar,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = CloseButton,
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundTransparency = 0.5}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundTransparency = 0.8}, 0.2)
    end)
    
    local MinimizeButton = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 35, 0, 35),
        Position = UDim2.new(1, -90, 0, 7.5),
        BackgroundColor3 = Theme.Warning,
        BackgroundTransparency = 0.8,
        Text = "−",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0,
        Parent = TopBar,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = MinimizeButton,
    })
    
    MinimizeButton.MouseButton1Click:Connect(function()
        Window:Minimize()
    end)
    
    MinimizeButton.MouseEnter:Connect(function()
        Tween(MinimizeButton, {BackgroundTransparency = 0.5}, 0.2)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        Tween(MinimizeButton, {BackgroundTransparency = 0.8}, 0.2)
    end)
    
    local TabsContainer = CreateInstance("Frame", {
        Name = "TabsContainer",
        Size = UDim2.new(0, 150, 1, -60),
        Position = UDim2.new(0, 10, 0, 55),
        BackgroundTransparency = 1,
        Parent = MainFrame,
    })
    
    CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = TabsContainer,
    })
    
    local ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -170, 1, -60),
        Position = UDim2.new(0, 165, 0, 55),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = MainFrame,
    })
    
    MakeDraggable(MainFrame, TopBar)
    
    function Window:Minimize()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 50)}, 0.3)
            MinimizeButton.Text = "+"
            TabsContainer.Visible = false
            ContentContainer.Visible = false
        else
            Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 450)}, 0.3)
            MinimizeButton.Text = "−"
            TabsContainer.Visible = true
            ContentContainer.Visible = true
        end
    end
    
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == MinimizeKey then
            Window:Minimize()
        end
    end)
    
    -- Change Theme Function
    function Window:SetTheme(themeName)
        if not Themes[themeName] then return end
        
        Window.CurrentTheme = themeName
        Theme = Themes[themeName]
        
        Tween(MainFrame, {BackgroundColor3 = Theme.Background}, 0.3)
        Tween(Blur, {BackgroundColor3 = Theme.Surface}, 0.3)
        Tween(Glow, {ImageColor3 = Theme.Primary}, 0.3)
        Tween(TopBar, {BackgroundColor3 = Theme.Surface}, 0.3)
        Tween(Title, {TextColor3 = Theme.Text}, 0.3)
        Tween(AccentLine, {BackgroundColor3 = Theme.Primary}, 0.3)
        
        Window:Notify({
            Title = "Thème changé",
            Content = "Thème " .. themeName .. " appliqué !",
            Duration = 2,
            Type = "Success"
        })
    end
    
    if not LoadingEnabled then
        Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 450)}, 0.5, Enum.EasingStyle.Back)
    else
        local LoadingFrame = CreateInstance("Frame", {
            Name = "LoadingFrame",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Theme.Background,
            BorderSizePixel = 0,
            Parent = MainFrame,
            ZIndex = 10,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 12),
            Parent = LoadingFrame,
        })
        
        local LoadingText = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 200, 0, 50),
            Position = UDim2.new(0.5, -100, 0.5, -25),
            BackgroundTransparency = 1,
            Text = "Loading...",
            TextColor3 = Theme.Text,
            TextSize = 24,
            Font = Enum.Font.GothamBold,
            Parent = LoadingFrame,
        })
        
        local LoadingBar = CreateInstance("Frame", {
            Size = UDim2.new(0, 0, 0, 4),
            Position = UDim2.new(0.5, -100, 0.5, 30),
            BackgroundColor3 = Theme.Primary,
            BorderSizePixel = 0,
            Parent = LoadingFrame,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = LoadingBar,
        })
        
        MainFrame.Size = UDim2.new(0, 600, 0, 450)
        
        Tween(LoadingBar, {Size = UDim2.new(0, 200, 0, 4)}, 1.5, Enum.EasingStyle.Quad)
        wait(1.5)
        
        -- Properly fade out all loading elements
        Tween(LoadingFrame, {BackgroundTransparency = 1}, 0.3)
        Tween(LoadingText, {TextTransparency = 1}, 0.3)
        Tween(LoadingBar, {BackgroundTransparency = 1}, 0.3)
        
        wait(0.3)
        LoadingFrame:Destroy()
    end
    
    function Window:CreateTab(config)
        config = config or {}
        local TabName = config.Name or "Tab"
        local TabIconText = config.Icon or "⚡"
        
        local Tab = {}
        Tab.Elements = {}
        
        local TabButton = CreateInstance("TextButton", {
            Name = TabName,
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Theme.Surface,
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0,
            Text = "",
            Parent = TabsContainer,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = TabButton,
        })
        
        local TabIcon = CreateInstance("TextLabel", {
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 1,
            Text = TabIconText,
            TextColor3 = Theme.Text,
            TextSize = 18,
            Font = Enum.Font.GothamBold,
            Parent = TabButton,
        })
        
        local TabLabel = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 40, 0, 0),
            BackgroundTransparency = 1,
            Text = TabName,
            TextColor3 = Theme.Text,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabButton,
        })
        
        local TabContent = CreateInstance("ScrollingFrame", {
            Name = TabName .. "Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.Primary,
            BorderSizePixel = 0,
            Visible = false,
            Parent = ContentContainer,
        })
        
        CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = TabContent,
        })
        
        CreateInstance("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5),
            PaddingLeft = UDim.new(0, 5),
            PaddingRight = UDim.new(0, 10),
            Parent = TabContent,
        })
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundTransparency = 0.7}, 0.2)
            end
            TabContent.Visible = true
            Tween(TabButton, {BackgroundTransparency = 0.3}, 0.2)
            Window.CurrentTab = Tab
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 0.5}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 0.7}, 0.2)
            end
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            -- Auto-select first tab without using Fire()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundTransparency = 0.7}, 0.2)
            end
            TabContent.Visible = true
            Tween(TabButton, {BackgroundTransparency = 0.3}, 0.2)
            Window.CurrentTab = Tab
        end
        
        function Tab:CreateButton(config)
            config = config or {}
            local ButtonName = config.Name or "Button"
            local Callback = config.Callback or function() end
            
            local ButtonFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 40),
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = ButtonFrame,
            })
            
            local Button = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = ButtonName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                Parent = ButtonFrame,
            })
            
            Button.MouseButton1Click:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Theme.Primary}, 0.1)
                wait(0.1)
                Tween(ButtonFrame, {BackgroundColor3 = Theme.Surface}, 0.1)
                Callback()
            end)
            
            Button.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundTransparency = 0.3}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundTransparency = 0.5}, 0.2)
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y)
            
            return Button
        end
        
        function Tab:CreateLabel(text)
            text = text or "Label"
            
            local LabelFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 30),
                BackgroundTransparency = 1,
                Parent = TabContent,
            })
            
            local Label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Theme.TextSecondary,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                Parent = LabelFrame,
            })
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y)
            
            local LabelObject = {}
            function LabelObject:Set(newText)
                Label.Text = newText
            end
            
            return LabelObject
        end
        
        function Tab:CreateToggle(config)
            config = config or {}
            local ToggleName = config.Name or "Toggle"
            local Default = config.Default or false
            local Callback = config.Callback or function() end
            
            local ToggleState = Default
            
            local ToggleFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 40),
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = ToggleFrame,
            })
            
            local ToggleLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -60, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = ToggleName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ToggleFrame,
            })
            
            local ToggleButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 50, 0, 25),
                Position = UDim2.new(1, -55, 0.5, -12.5),
                BackgroundColor3 = Default and Theme.Success or Theme.TextSecondary,
                Text = "",
                BorderSizePixel = 0,
                Parent = ToggleFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleButton,
            })
            
            local ToggleCircle = CreateInstance("Frame", {
                Size = UDim2.new(0, 19, 0, 19),
                Position = Default and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Parent = ToggleButton,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleCircle,
            })
            
            ToggleButton.MouseButton1Click:Connect(function()
                ToggleState = not ToggleState
                
                if ToggleState then
                    Tween(ToggleButton, {BackgroundColor3 = Theme.Success}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -22, 0.5, -9.5)}, 0.2)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Theme.TextSecondary}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -9.5)}, 0.2)
                end
                
                Callback(ToggleState)
            end)
            
            ToggleFrame.MouseEnter:Connect(function()
                Tween(ToggleFrame, {BackgroundTransparency = 0.3}, 0.2)
            end)
            
            ToggleFrame.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundTransparency = 0.5}, 0.2)
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y)
            
            local ToggleObject = {}
            function ToggleObject:Set(value)
                ToggleState = value
                if ToggleState then
                    Tween(ToggleButton, {BackgroundColor3 = Theme.Success}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -22, 0.5, -9.5)}, 0.2)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Theme.TextSecondary}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -9.5)}, 0.2)
                end
                Callback(ToggleState)
            end
            
            return ToggleObject
        end
        
        function Tab:CreateSlider(config)
            config = config or {}
            local SliderName = config.Name or "Slider"
            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or 50
            local Callback = config.Callback or function() end
            
            local SliderValue = Default
            
            local SliderFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 50),
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = SliderFrame,
            })
            
            local SliderLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -60, 0, 20),
                Position = UDim2.new(0, 10, 0, 5),
                BackgroundTransparency = 1,
                Text = SliderName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = SliderFrame,
            })
            
            local SliderValueLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -55, 0, 5),
                BackgroundTransparency = 1,
                Text = tostring(Default),
                TextColor3 = Theme.Primary,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = SliderFrame,
            })
            
            local SliderBackground = CreateInstance("Frame", {
                Size = UDim2.new(1, -20, 0, 6),
                Position = UDim2.new(0, 10, 1, -15),
                BackgroundColor3 = Theme.TextSecondary,
                BackgroundTransparency = 0.7,
                BorderSizePixel = 0,
                Parent = SliderFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderBackground,
            })
            
            local SliderFill = CreateInstance("Frame", {
                Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
                BackgroundColor3 = Theme.Primary,
                BorderSizePixel = 0,
                Parent = SliderBackground,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderFill,
            })
            
            local SliderButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new((Default - Min) / (Max - Min), -7, 0.5, -7),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Text = "",
                Parent = SliderBackground,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = SliderButton,
            })
            
            local dragging = false
            
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mousePos = UserInputService:GetMouseLocation().X
                    local sliderPos = SliderBackground.AbsolutePosition.X
                    local sliderSize = SliderBackground.AbsoluteSize.X
                    
                    local value = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
                    SliderValue = math.floor(((Max - Min) * value + Min))
                    SliderValue = math.clamp(SliderValue, Min, Max)
                    
                    SliderFill.Size = UDim2.new(value, 0, 1, 0)
                    SliderButton.Position = UDim2.new(value, -7, 0.5, -7)
                    SliderValueLabel.Text = tostring(SliderValue)
                    
                    Callback(SliderValue)
                end
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y)
            
            local SliderObject = {}
            function SliderObject:Set(value)
                value = math.clamp(value, Min, Max)
                SliderValue = value
                local percent = (value - Min) / (Max - Min)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                SliderButton.Position = UDim2.new(percent, -7, 0.5, -7)
                SliderValueLabel.Text = tostring(value)
                Callback(value)
            end
            
            return SliderObject
        end
        
        function Tab:CreateDropdown(config)
            config = config or {}
            local DropdownName = config.Name or "Dropdown"
            local Options = config.Options or {"Option 1", "Option 2"}
            local Default = config.Default or Options[1]
            local Callback = config.Callback or function() end
            
            local DropdownValue = Default
            local DropdownOpen = false
            
            local DropdownFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 40),
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = DropdownFrame,
            })
            
            local DropdownLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -130, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = DropdownName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownFrame,
            })
            
            local DropdownButton = CreateInstance("TextButton", {
                Size = UDim2.new(0, 120, 0, 30),
                Position = UDim2.new(1, -125, 0, 5),
                BackgroundColor3 = Theme.Primary,
                BackgroundTransparency = 0.7,
                Text = Default,
                TextColor3 = Theme.Text,
                TextSize = 12,
                Font = Enum.Font.Gotham,
                BorderSizePixel = 0,
                Parent = DropdownFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = DropdownButton,
            })
            
            local DropdownContainer = CreateInstance("Frame", {
                Size = UDim2.new(0, 120, 0, 0),
                Position = UDim2.new(1, -125, 0, 40),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Visible = false,
                Parent = DropdownFrame,
                ZIndex = 5,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = DropdownContainer,
            })
            
            CreateInstance("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 2),
                Parent = DropdownContainer,
            })
            
            CreateInstance("UIPadding", {
                PaddingTop = UDim.new(0, 5),
                PaddingBottom = UDim.new(0, 5),
                PaddingLeft = UDim.new(0, 5),
                PaddingRight = UDim.new(0, 5),
                Parent = DropdownContainer,
            })
            
            for _, option in pairs(Options) do
                local OptionButton = CreateInstance("TextButton", {
                    Size = UDim2.new(1, -10, 0, 25),
                    BackgroundColor3 = Theme.Primary,
                    BackgroundTransparency = 0.8,
                    Text = option,
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    BorderSizePixel = 0,
                    Parent = DropdownContainer,
                })
                
                CreateInstance("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = OptionButton,
                })
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownValue = option
                    DropdownButton.Text = option
                    DropdownOpen = false
                    Tween(DropdownContainer, {Size = UDim2.new(0, 120, 0, 0)}, 0.2)
                    wait(0.2)
                    DropdownContainer.Visible = false
                    Callback(option)
                end)
                
                OptionButton.MouseEnter:Connect(function()
                    Tween(OptionButton, {BackgroundTransparency = 0.5}, 0.2)
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    Tween(OptionButton, {BackgroundTransparency = 0.8}, 0.2)
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                DropdownOpen = not DropdownOpen
                if DropdownOpen then
                    DropdownContainer.Visible = true
                    local contentSize = DropdownContainer.UIListLayout.AbsoluteContentSize.Y + 10
                    Tween(DropdownContainer, {Size = UDim2.new(0, 120, 0, contentSize)}, 0.2)
                else
                    Tween(DropdownContainer, {Size = UDim2.new(0, 120, 0, 0)}, 0.2)
                    wait(0.2)
                    DropdownContainer.Visible = false
                end
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y)
            
            local DropdownObject = {}
            function DropdownObject:Set(value)
                DropdownValue = value
                DropdownButton.Text = value
                Callback(value)
            end
            
            return DropdownObject
        end
        
        function Tab:CreateInput(config)
            config = config or {}
            local InputName = config.Name or "Input"
            local Placeholder = config.Placeholder or "Enter text..."
            local Callback = config.Callback or function() end
            
            local InputFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, -5, 0, 40),
                BackgroundColor3 = Theme.Surface,
                BackgroundTransparency = 0.5,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 8),
                Parent = InputFrame,
            })
            
            local InputLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0.4, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = InputName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = InputFrame,
            })
            
            local InputBox = CreateInstance("TextBox", {
                Size = UDim2.new(0.6, -20, 0, 30),
                Position = UDim2.new(0.4, 0, 0, 5),
                BackgroundColor3 = Theme.Primary,
                BackgroundTransparency = 0.8,
                PlaceholderText = Placeholder,
                PlaceholderColor3 = Theme.TextSecondary,
                Text = "",
                TextColor3 = Theme.Text,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                BorderSizePixel = 0,
                ClearTextOnFocus = false,
                Parent = InputFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = InputBox,
            })
            
            CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = InputBox,
            })
            
            InputBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    Callback(InputBox.Text)
                end
            end)
            
            InputBox.Focused:Connect(function()
                Tween(InputBox, {BackgroundTransparency = 0.5}, 0.2)
            end)
            
            InputBox.FocusLost:Connect(function()
                Tween(InputBox, {BackgroundTransparency = 0.8}, 0.2)
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y)
            
            return InputBox
        end
        
        return Tab
    end
    
    function Window:Notify(config)
        config = config or {}
        local Title = config.Title or "Notification"
        local Content = config.Content or "This is a notification"
        local Duration = config.Duration or 3
        local Type = config.Type or "Info"
        
        local NotificationColor = Theme.Primary
        if Type == "Success" then
            NotificationColor = Theme.Success
        elseif Type == "Warning" then
            NotificationColor = Theme.Warning
        elseif Type == "Error" then
            NotificationColor = Theme.Error
        end
        
        local NotificationFrame = CreateInstance("Frame", {
            Size = UDim2.new(0, 0, 0, 80),
            Position = UDim2.new(1, -320, 1, -100 - (#Window.Notifications * 90)),
            BackgroundColor3 = Theme.Surface,
            BorderSizePixel = 0,
            Parent = ScreenGui,
            ClipsDescendants = true,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 10),
            Parent = NotificationFrame,
        })
        
        local AccentBar = CreateInstance("Frame", {
            Size = UDim2.new(0, 4, 1, 0),
            BackgroundColor3 = NotificationColor,
            BorderSizePixel = 0,
            Parent = NotificationFrame,
        })
        
        local NotificationTitle = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -50, 0, 25),
            Position = UDim2.new(0, 15, 0, 10),
            BackgroundTransparency = 1,
            Text = Title,
            TextColor3 = Theme.Text,
            TextSize = 15,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = NotificationFrame,
        })
        
        local NotificationContent = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -50, 0, 40),
            Position = UDim2.new(0, 15, 0, 35),
            BackgroundTransparency = 1,
            Text = Content,
            TextColor3 = Theme.TextSecondary,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = NotificationFrame,
        })
        
        local CloseBtn = CreateInstance("TextButton", {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -30, 0, 10),
            BackgroundTransparency = 1,
            Text = "✕",
            TextColor3 = Theme.TextSecondary,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Parent = NotificationFrame,
        })
        
        table.insert(Window.Notifications, NotificationFrame)
        
        Tween(NotificationFrame, {Size = UDim2.new(0, 300, 0, 80)}, 0.3, Enum.EasingStyle.Back)
        
        CloseBtn.MouseButton1Click:Connect(function()
            Tween(NotificationFrame, {Size = UDim2.new(0, 0, 0, 80)}, 0.2)
            wait(0.2)
            NotificationFrame:Destroy()
            for i, notif in pairs(Window.Notifications) do
                if notif == NotificationFrame then
                    table.remove(Window.Notifications, i)
                    break
                end
            end
        end)
        
        spawn(function()
            wait(Duration)
            Tween(NotificationFrame, {Size = UDim2.new(0, 0, 0, 80)}, 0.2)
            wait(0.2)
            NotificationFrame:Destroy()
            for i, notif in pairs(Window.Notifications) do
                if notif == NotificationFrame then
                    table.remove(Window.Notifications, i)
                    break
                end
            end
        end)
    end
    
    return Window
end

return Extasy
