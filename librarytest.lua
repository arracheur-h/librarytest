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
        Warning = Color3.fromRGB(234, 179, 8),
        Error = Color3.fromRGB(239, 68, 68),
        Accent = Color3.fromRGB(168, 85, 247),
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
        Primary = Color3.fromRGB(0, 255, 255),
        Secondary = Color3.fromRGB(255, 0, 255),
        Background = Color3.fromRGB(10, 10, 20),
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
        BackgroundTransparency = 0.3,
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
        BackgroundTransparency = 0.5,
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
        Tween(LoadingFrame, {BackgroundTransparency = 1}, 0.3)
        for _, child in pairs(LoadingFrame:GetChildren()) do
            if child:IsA("GuiObject") then
                Tween(child, {BackgroundTransparency = 1, TextTransparency = 1}, 0.3)
            end
        end
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
            TabButton.MouseButton1Click:Fire()
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
