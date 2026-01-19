--[[
    ██████╗ ██╗  ██╗████████╗██╗  ██╗███████╗██╗   ██╗
    ╚════██╗╚██╗██╔╝╚══██╔══╝██║  ██║██╔════╝╚██╗ ██╔╝
     █████╔╝ ╚███╔╝    ██║   ███████║███████╗ ╚████╔╝ 
     ╚═══██╗ ██╔██╗    ██║   ╚════██║╚════██║  ╚██╔╝  
    ██████╔╝██╔╝ ██╗   ██║        ██║███████║   ██║   
    ╚═════╝ ╚═╝  ╚═╝   ╚═╝        ╚═╝╚══════╝   ╚═╝   
    
    Modern UI Library for Roblox
    Version: 1.0.0
    
    Features:
    - Modern glassmorphic design
    - Smooth animations
    - Customizable themes
    - Multiple component types
    - Draggable windows
    - Notifications system
]]

local Extasy = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
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
        Primary = Color3.fromRGB(139, 92, 246),      -- Purple
        Secondary = Color3.fromRGB(99, 102, 241),    -- Indigo
        Background = Color3.fromRGB(17, 24, 39),     -- Dark gray
        Surface = Color3.fromRGB(31, 41, 55),        -- Slightly lighter
        Text = Color3.fromRGB(243, 244, 246),        -- Light gray
        TextSecondary = Color3.fromRGB(156, 163, 175), -- Muted gray
        Success = Color3.fromRGB(34, 197, 94),       -- Green
        Warning = Color3.fromRGB(234, 179, 8),       -- Yellow
        Error = Color3.fromRGB(239, 68, 68),         -- Red
        Accent = Color3.fromRGB(168, 85, 247),       -- Light purple
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
    },
    Neon = {
        Primary = Color3.fromRGB(0, 255, 255),       -- Cyan
        Secondary = Color3.fromRGB(255, 0, 255),     -- Magenta
        Background = Color3.fromRGB(10, 10, 20),     -- Very dark
        Surface = Color3.fromRGB(20, 20, 35),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(150, 150, 200),
        Success = Color3.fromRGB(0, 255, 127),
        Warning = Color3.fromRGB(255, 215, 0),
        Error = Color3.fromRGB(255, 20, 147),
        Accent = Color3.fromRGB(138, 43, 226),
    }
}

-- Main Library
function Extasy:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "Nexus UI"
    local Theme = Themes[config.Theme or "Dark"]
    local LoadingEnabled = config.LoadingEnabled ~= false
    local MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightControl
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Minimized = false
    Window.Notifications = {}
    
    -- Create ScreenGui
    local ScreenGui = CreateInstance("ScreenGui", {
        Name = "Extasy",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
    })
    
    -- Main Frame (Window Container)
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, -300, 0.5, -225),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui,
    })
    
    -- Animation d'ouverture
    if not LoadingEnabled then
        Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 450)}, 0.5, Enum.EasingStyle.Back)
    end
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = MainFrame,
    })
    
    -- Glassmorphic effect
    local Blur = CreateInstance("Frame", {
        Name = "Blur",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = Blur,
    })
    
    -- Glow effect
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
    
    -- Top Bar
    local TopBar = CreateInstance("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Theme.Surface,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = TopBar,
    })
    
    -- Title
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
    
    -- Accent line under top bar
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
    
    -- Close Button
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
    
    -- Minimize Button
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
    
    -- Tabs Container
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
    
    -- Content Container
    local ContentContainer = CreateInstance("Frame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -170, 1, -60),
        Position = UDim2.new(0, 165, 0, 55),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = MainFrame,
    })
    
    -- Make draggable
    MakeDraggable(MainFrame, TopBar)
    
    -- Minimize functionality
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
    
    -- Keybind for minimize
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == MinimizeKey then
            Window:Minimize()
        end
    end)
    
    -- Loading animation
    if LoadingEnabled then
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
        
        Tween(LoadingBar, {Size = UDim2.new(0, 200, 0, 4)}, 1.5, Enum.EasingStyle.Quad)
        wait(1.5)
        Tween(LoadingFrame, {BackgroundTransparency = 1}, 0.3)
        for _, child in pairs(LoadingFrame:GetChildren()) do
            if child:IsA("GuiObject") then
                Tween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
            end
        end
        wait(0.3)
        LoadingFrame:Destroy()
        Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 450)}, 0.5, Enum.EasingStyle.Back)
    end
    
    -- Create Tab
    function Window:CreateTab(config)
        config = config or {}
        local TabName = config.Name or "Tab"
        local TabIcon = config.Icon or "⚡"
        
        local Tab = {}
        Tab.Elements = {}
        
        -- Tab Button
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
            Text = TabIcon,
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
        
        -- Tab Content
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
        
        -- Tab selection
        TabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundTransparency = 0.7}, 0.2)
            end
            
            -- Show this tab
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
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            TabButton.MouseButton1Click:Fire()
        end
        
        -- Create Button
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
        
        -- Create Toggle
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
        
        -- Create Slider
        function Tab:CreateSlider(config)
            config = config or {}
            local SliderName = config.Name or "Slider"
            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or 50
            local Increment = config.Increment or 1
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
                    SliderValue = math.floor(((Max - Min) * value + Min) / Increment + 0.5) * Increment
                    SliderValue = math.clamp(SliderValue, Min, Max)
                    
                    SliderFill.Size = UDim2.new(value, 0, 1, 0)
                    SliderButton.Position = UDim2.new(value, -7, 0.5, -7)
                    SliderValueLabel.Text = tostring(SliderValue)
                    
                    Callback(SliderValue)
                end
            end)
            
            SliderFrame.MouseEnter:Connect(function()
                Tween(SliderFrame, {BackgroundTransparency = 0.3}, 0.2)
            end)
            
            SliderFrame.MouseLeave:Connect(function()
                Tween(SliderFrame, {BackgroundTransparency = 0.5}, 0.2)
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
        
        -- Create Dropdown
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
                Size = UDim2.new(1, -60, 1, 0),
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
            
            DropdownFrame.MouseEnter:Connect(function()
                Tween(DropdownFrame, {BackgroundTransparency = 0.3}, 0.2)
            end)
            
            DropdownFrame.MouseLeave:Connect(function()
                Tween(DropdownFrame, {BackgroundTransparency = 0.5}, 0.2)
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
        
        -- Create Input
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
            
            InputFrame.MouseEnter:Connect(function()
                Tween(InputFrame, {BackgroundTransparency = 0.3}, 0.2)
            end)
            
            InputFrame.MouseLeave:Connect(function()
                Tween(InputFrame, {BackgroundTransparency = 0.5}, 0.2)
            end)
            
            TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContent.UIListLayout.AbsoluteContentSize.Y)
            
            return InputBox
        end
        
        -- Create Label
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
        
        return Tab
    end
    
    -- Notification System
    function Window:Notify(config)
        config = config or {}
        local Title = config.Title or "Notification"
        local Content = config.Content or "This is a notification"
        local Duration = config.Duration or 3
        local Type = config.Type or "Info" -- Info, Success, Warning, Error
        
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

-- AUTO-EXECUTION
local Extasy = loadstring(game:HttpGet("URL_TO_YOUR_SCRIPT"))()

-- Créer une fenêtre
local Window = Extasy:CreateWindow({
    Name = "3xt4sy - Demo",
    Theme = "Dark", -- "Dark", "Light", ou "Neon"
    LoadingEnabled = true,
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Créer des notifications
Window:Notify({
    Title = "Bienvenue !",
    Content = "3xt4sy chargé avec succès",
    Duration = 5,
    Type = "Success" -- "Info", "Success", "Warning", "Error"
})

-- Créer le premier onglet - Main
local MainTab = Window:CreateTab({
    Name = "Principal",
    Icon = "🏠"
})

-- Bouton simple
MainTab:CreateButton({
    Name = "Cliquez-moi",
    Callback = function()
        Window:Notify({
            Title = "Bouton cliqué",
            Content = "Vous avez cliqué sur le bouton !",
            Duration = 3,
            Type = "Info"
        })
    end
})

-- Toggle (interrupteur)
local SpeedToggle = MainTab:CreateToggle({
    Name = "Speed Boost",
    Default = false,
    Callback = function(value)
        if value then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
            Window:Notify({
                Title = "Speed activé",
                Content = "Vitesse augmentée !",
                Duration = 2,
                Type = "Success"
            })
        else
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
            Window:Notify({
                Title = "Speed désactivé",
                Content = "Vitesse normale",
                Duration = 2,
                Type = "Info"
            })
        end
    end
})

-- Slider (curseur)
local FOVSlider = MainTab:CreateSlider({
    Name = "Field of View",
    Min = 70,
    Max = 120,
    Default = 70,
    Increment = 1,
    Callback = function(value)
        game.Workspace.CurrentCamera.FieldOfView = value
    end
})

-- Créer le deuxième onglet - Combat
local CombatTab = Window:CreateTab({
    Name = "Combat",
    Icon = "⚔️"
})

-- Dropdown (menu déroulant)
local WeaponDropdown = CombatTab:CreateDropdown({
    Name = "Sélectionner une arme",
    Options = {"Épée", "Arc", "Hache", "Lance"},
    Default = "Épée",
    Callback = function(option)
        Window:Notify({
            Title = "Arme changée",
            Content = "Vous avez sélectionné : " .. option,
            Duration = 3,
            Type = "Info"
        })
    end
})

-- Toggle pour l'aimbot
CombatTab:CreateToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(value)
        if value then
            Window:Notify({
                Title = "Aimbot activé",
                Content = "Attention à ne pas vous faire ban !",
                Duration = 3,
                Type = "Warning"
            })
        else
            Window:Notify({
                Title = "Aimbot désactivé",
                Content = "Mode de jeu normal",
                Duration = 2,
                Type = "Info"
            })
        end
    end
})

-- Label informatif
CombatTab:CreateLabel("⚠️ Utilisez ces fonctions à vos risques et périls")

-- Créer le troisième onglet - Paramètres
local SettingsTab = Window:CreateTab({
    Name = "Paramètres",
    Icon = "⚙️"
})

-- Input (champ de texte)
SettingsTab:CreateInput({
    Name = "Nom du joueur",
    Placeholder = "Entrez un nom...",
    Callback = function(text)
        Window:Notify({
            Title = "Nom sauvegardé",
            Content = "Votre nom : " .. text,
            Duration = 3,
            Type = "Success"
        })
    end
})

-- Slider pour le volume
SettingsTab:CreateSlider({
    Name = "Volume musique",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 5,
    Callback = function(value)
        print("Volume réglé sur : " .. value .. "%")
    end
})

-- Toggle pour le mode nuit
SettingsTab:CreateToggle({
    Name = "Mode nuit",
    Default = true,
    Callback = function(value)
        if value then
            game.Lighting.ClockTime = 0
            game.Lighting.Brightness = 1
        else
            game.Lighting.ClockTime = 12
            game.Lighting.Brightness = 2
        end
    end
})

SettingsTab:CreateLabel("━━━━━━━━━━━━━━━━━━━━")

-- Bouton pour détruire l'UI
SettingsTab:CreateButton({
    Name = "Fermer l'UI",
    Callback = function()
        Window:Notify({
            Title = "Au revoir !",
            Content = "L'UI va se fermer dans 2 secondes...",
            Duration = 2,
            Type = "Error"
        })
        wait(2)
        game:GetService("CoreGui").Extasy:Destroy()
    end
})

-- Créer un quatrième onglet - Info
local InfoTab = Window:CreateTab({
    Name = "Infos",
    Icon = "ℹ️"
})

InfoTab:CreateLabel("📋 3xt4sy Library v1.0.0")
InfoTab:CreateLabel("━━━━━━━━━━━━━━━━━━━━")
InfoTab:CreateLabel("Fonctionnalités :")
InfoTab:CreateLabel("✓ Interface moderne et élégante")
InfoTab:CreateLabel("✓ Animations fluides")
InfoTab:CreateLabel("✓ Système de notifications")
InfoTab:CreateLabel("✓ Multiple thèmes disponibles")
InfoTab:CreateLabel("✓ Fenêtre déplaçable")
InfoTab:CreateLabel("✓ Support de minimisation")
InfoTab:CreateLabel("━━━━━━━━━━━━━━━━━━━━")

-- Bouton pour tester les notifications
InfoTab:CreateButton({
    Name = "Test notification Info",
    Callback = function()
        Window:Notify({
            Title = "Information",
            Content = "Ceci est une notification de type Info",
            Duration = 3,
            Type = "Info"
        })
    end
})

InfoTab:CreateButton({
    Name = "Test notification Success",
    Callback = function()
        Window:Notify({
            Title = "Succès",
            Content = "Ceci est une notification de type Success",
            Duration = 3,
            Type = "Success"
        })
    end
})

InfoTab:CreateButton({
    Name = "Test notification Warning",
    Callback = function()
        Window:Notify({
            Title = "Avertissement",
            Content = "Ceci est une notification de type Warning",
            Duration = 3,
            Type = "Warning"
        })
    end
})

InfoTab:CreateButton({
    Name = "Test notification Error",
    Callback = function()
        Window:Notify({
            Title = "Erreur",
            Content = "Ceci est une notification de type Error",
            Duration = 3,
            Type = "Error"
        })
    end
})

-- Exemples d'utilisation avancée
--[[

    CHANGER LA VALEUR D'UN TOGGLE DEPUIS LE CODE :
    SpeedToggle:Set(true)  -- Active le toggle
    SpeedToggle:Set(false) -- Désactive le toggle

    CHANGER LA VALEUR D'UN SLIDER :
    FOVSlider:Set(100) -- Met le FOV à 100

    CHANGER LA VALEUR D'UN DROPDOWN :
    WeaponDropdown:Set("Arc") -- Sélectionne "Arc"
    
    CHANGER LE TEXTE D'UN LABEL :
    (Sauvegardez le label dans une variable d'abord)
    local MyLabel = InfoTab:CreateLabel("Texte initial")
    MyLabel:Set("Nouveau texte")

    MINIMISER/MAXIMISER LA FENÊTRE :
    Appuyez sur la touche RightControl (ou la touche configurée)
    
    CRÉER UNE FENÊTRE AVEC UN THÈME DIFFÉRENT :
    local Window = Extasy:CreateWindow({
        Name = "Ma fenêtre",
        Theme = "Neon", -- "Dark", "Light", ou "Neon"
        LoadingEnabled = true,
        MinimizeKey = Enum.KeyCode.RightShift
    })

]]
