--[[
    3XT4SY LUNA STYLE UI LIBRARY
    Sidebar Navigation Design
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

local function Tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
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
        Primary = Color3.fromRGB(88, 101, 242),
        Background = Color3.fromRGB(35, 39, 42),
        Sidebar = Color3.fromRGB(47, 49, 54),
        Surface = Color3.fromRGB(47, 49, 54),
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
        Surface = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(0, 0, 0),
        TextDim = Color3.fromRGB(114, 118, 125),
        Accent = Color3.fromRGB(88, 101, 242),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Error = Color3.fromRGB(240, 71, 71),
    }
}

-- Main Library
function LunaUI:CreateWindow(config)
    config = config or {}
    local WindowName = config.Name or "Luna UI"
    local Theme = Themes[config.Theme or "Dark"]
    
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
    
    -- Main Container
    local MainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 700, 0, 450),
        Position = UDim2.new(0.5, -350, 0.5, -225),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = MainFrame,
    })
    
    -- Drop Shadow
    local Shadow = CreateInstance("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 30, 1, 30),
        Position = UDim2.new(0, -15, 0, -15),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = MainFrame,
        ZIndex = 0,
    })
    
    -- Top Bar
    local TopBar = CreateInstance("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = TopBar,
    })
    
    -- Bottom mask for TopBar
    local TopBarMask = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 1, -8),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = TopBar,
    })
    
    -- Menu Icon (3 lines)
    local MenuButton = CreateInstance("TextButton", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 5, 0, 0),
        BackgroundTransparency = 1,
        Text = "☰",
        TextColor3 = Theme.Text,
        TextSize = 20,
        Font = Enum.Font.GothamBold,
        Parent = TopBar,
    })
    
    -- Title
    local Title = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 50, 0, 0),
        BackgroundTransparency = 1,
        Text = WindowName,
        TextColor3 = Theme.Text,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = TopBar,
    })
    
    -- Close Button
    local CloseButton = CreateInstance("TextButton", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(1, -45, 0, 0),
        BackgroundTransparency = 1,
        Text = "×",
        TextColor3 = Theme.Text,
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        Parent = TopBar,
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Sidebar
    local Sidebar = CreateInstance("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 60, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })
    
    local SidebarList = CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = Sidebar,
    })
    
    CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        Parent = Sidebar,
    })
    
    -- Content Area
    local ContentArea = CreateInstance("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -60, 1, -40),
        Position = UDim2.new(0, 60, 0, 40),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = MainFrame,
    })
    
    CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 8),
        Parent = ContentArea,
    })
    
    -- Mask for ContentArea
    local ContentMask = CreateInstance("Frame", {
        Size = UDim2.new(0, 8, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = ContentArea,
    })
    
    -- Make draggable
    MakeDraggable(MainFrame, TopBar)
    
    -- Window object
    local Window = {
        Tabs = {},
        CurrentTab = nil,
        Theme = Theme,
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Sidebar = Sidebar,
        ContentArea = ContentArea,
    }
    
    -- Create Tab
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local TabName = tabConfig.Name or "Tab"
        local TabIcon = tabConfig.Icon or "?"
        
        -- Tab Button in Sidebar
        local TabButton = CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Theme.Sidebar,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Text = "",
            Parent = Sidebar,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = TabButton,
        })
        
        -- Icon
        local Icon = CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = TabIcon,
            TextColor3 = Theme.TextDim,
            TextSize = 20,
            Font = Enum.Font.GothamBold,
            Parent = TabButton,
        })
        
        -- Tab Content Container
        local TabContent = CreateInstance("ScrollingFrame", {
            Name = TabName .. "Content",
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.Primary,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = ContentArea,
        })
        
        local ContentList = CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8),
            Parent = TabContent,
        })
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab object
        local Tab = {
            Button = TabButton,
            Content = TabContent,
            Name = TabName,
        }
        
        -- Tab switching
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundTransparency = 0}, 0.2)
                tab.Button.Icon.TextColor3 = Theme.TextDim
            end
            
            TabContent.Visible = true
            Tween(TabButton, {BackgroundTransparency = 0.5}, 0.2)
            Icon.TextColor3 = Theme.Primary
            Window.CurrentTab = Tab
        end)
        
        -- Store icon reference
        TabButton.Icon = Icon
        
        table.insert(Window.Tabs, Tab)
        
        -- Auto-select first tab
        if #Window.Tabs == 1 then
            TabContent.Visible = true
            TabButton.BackgroundTransparency = 0.5
            Icon.TextColor3 = Theme.Primary
            Window.CurrentTab = Tab
        end
        
        -- Create Label
        function Tab:CreateLabel(text)
            local Label = CreateInstance("TextLabel", {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = text == "" and Theme.Background or Theme.TextDim,
                TextSize = 13,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = TabContent,
            })
            
            CreateInstance("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                Parent = Label,
            })
        end
        
        -- Create Button
        function Tab:CreateButton(btnConfig)
            btnConfig = btnConfig or {}
            local ButtonName = btnConfig.Name or "Button"
            local Callback = btnConfig.Callback or function() end
            
            local Button = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Text = "",
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = Button,
            })
            
            local ButtonText = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = ButtonName,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Button,
            })
            
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Primary}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Theme.Surface}, 0.2)
            end)
            
            Button.MouseButton1Click:Connect(Callback)
        end
        
        -- Create Toggle
        function Tab:CreateToggle(toggleConfig)
            toggleConfig = toggleConfig or {}
            local ToggleName = toggleConfig.Name or "Toggle"
            local Default = toggleConfig.Default or false
            local Callback = toggleConfig.Callback or function() end
            
            local ToggleFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = ToggleFrame,
            })
            
            local ToggleText = CreateInstance("TextLabel", {
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
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -50, 0.5, -10),
                BackgroundColor3 = Default and Theme.Success or Theme.TextDim,
                BorderSizePixel = 0,
                Text = "",
                Parent = ToggleFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = ToggleButton,
            })
            
            local ToggleIndicator = CreateInstance("Frame", {
                Size = UDim2.new(0, 16, 0, 16),
                Position = Default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
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
                Tween(ToggleIndicator, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}, 0.2)
            end)
        end
        
        -- Create Slider
        function Tab:CreateSlider(sliderConfig)
            sliderConfig = sliderConfig or {}
            local SliderName = sliderConfig.Name or "Slider"
            local Min = sliderConfig.Min or 0
            local Max = sliderConfig.Max or 100
            local Default = sliderConfig.Default or Min
            local Callback = sliderConfig.Callback or function() end
            
            local SliderFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 50),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = SliderFrame,
            })
            
            local SliderText = CreateInstance("TextLabel", {
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
            
            local ValueLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 50, 0, 20),
                Position = UDim2.new(1, -60, 0, 5),
                BackgroundTransparency = 1,
                Text = tostring(Default),
                TextColor3 = Theme.Primary,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                Parent = SliderFrame,
            })
            
            local SliderTrack = CreateInstance("Frame", {
                Size = UDim2.new(1, -20, 0, 4),
                Position = UDim2.new(0, 10, 1, -15),
                BackgroundColor3 = Theme.TextDim,
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
                    ValueLabel.Text = tostring(finalValue)
                    Callback(finalValue)
                end
            end)
        end
        
        -- Create Dropdown
        function Tab:CreateDropdown(dropdownConfig)
            dropdownConfig = dropdownConfig or {}
            local DropdownName = dropdownConfig.Name or "Dropdown"
            local Options = dropdownConfig.Options or {}
            local Default = dropdownConfig.Default or (Options[1] or "")
            local Callback = dropdownConfig.Callback or function() end
            
            local DropdownFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = DropdownFrame,
            })
            
            local DropdownButton = CreateInstance("TextButton", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                Parent = DropdownFrame,
            })
            
            local DropdownText = CreateInstance("TextLabel", {
                Size = UDim2.new(1, -40, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = DropdownName .. ": " .. Default,
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = DropdownFrame,
            })
            
            local Arrow = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 20, 1, 0),
                Position = UDim2.new(1, -30, 0, 0),
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
                Parent = DropdownFrame,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = DropdownContainer,
            })
            
            local OptionsList = CreateInstance("UIListLayout", {
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = DropdownContainer,
            })
            
            local isOpen = false
            
            for _, option in ipairs(Options) do
                local OptionButton = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Text = option,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    Parent = DropdownContainer,
                })
                
                OptionButton.MouseButton1Click:Connect(function()
                    DropdownText.Text = DropdownName .. ": " .. option
                    Callback(option)
                    
                    isOpen = false
                    Tween(DropdownContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    wait(0.2)
                    DropdownContainer.Visible = false
                    Arrow.Text = "▼"
                end)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    DropdownContainer.Visible = true
                    Tween(DropdownContainer, {Size = UDim2.new(1, 0, 0, OptionsList.AbsoluteContentSize.Y)}, 0.2)
                    Arrow.Text = "▲"
                else
                    Tween(DropdownContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    wait(0.2)
                    DropdownContainer.Visible = false
                    Arrow.Text = "▼"
                end
            end)
        end
        
        -- Create Input
        function Tab:CreateInput(inputConfig)
            inputConfig = inputConfig or {}
            local InputName = inputConfig.Name or "Input"
            local Placeholder = inputConfig.Placeholder or "Enter text..."
            local Callback = inputConfig.Callback or function() end
            
            local InputFrame = CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundColor3 = Theme.Surface,
                BorderSizePixel = 0,
                Parent = TabContent,
            })
            
            CreateInstance("UICorner", {
                CornerRadius = UDim.new(0, 6),
                Parent = InputFrame,
            })
            
            local InputLabel = CreateInstance("TextLabel", {
                Size = UDim2.new(0, 100, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = InputName .. ":",
                TextColor3 = Theme.Text,
                TextSize = 14,
                Font = Enum.Font.Gotham,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = InputFrame,
            })
            
            local InputBox = CreateInstance("TextBox", {
                Size = UDim2.new(1, -120, 1, -10),
                Position = UDim2.new(0, 110, 0, 5),
                BackgroundColor3 = Theme.Background,
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
                CornerRadius = UDim.new(0, 4),
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
        end
        
        return Tab
    end
    
    -- Notification System
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
            Size = UDim2.new(0, 300, 0, 70),
            Position = UDim2.new(1, -320, 1, -90),
            BackgroundColor3 = Theme.Surface,
            BorderSizePixel = 0,
            Parent = ScreenGui,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = NotifFrame,
        })
        
        local Accent = CreateInstance("Frame", {
            Size = UDim2.new(0, 4, 1, 0),
            BackgroundColor3 = typeColors[Type] or Theme.Primary,
            BorderSizePixel = 0,
            Parent = NotifFrame,
        })
        
        CreateInstance("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = Accent,
        })
        
        local NotifTitle = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -20, 0, 20),
            Position = UDim2.new(0, 15, 0, 10),
            BackgroundTransparency = 1,
            Text = Title,
            TextColor3 = Theme.Text,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = NotifFrame,
        })
        
        local NotifContent = CreateInstance("TextLabel", {
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 15, 0, 30),
            BackgroundTransparency = 1,
            Text = Content,
            TextColor3 = Theme.TextDim,
            TextSize = 12,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = NotifFrame,
        })
        
        Tween(NotifFrame, {Position = UDim2.new(1, -320, 1, -90 - (#ScreenGui:GetChildren() - 2) * 80)}, 0.3)
        
        task.wait(Duration)
        
        Tween(NotifFrame, {Position = UDim2.new(1, 20, 1, -90 - (#ScreenGui:GetChildren() - 2) * 80)}, 0.3)
        task.wait(0.3)
        NotifFrame:Destroy()
    end
    
    return Window
end

return LunaUI
