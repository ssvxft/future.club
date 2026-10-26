--!native
--!optimize 2

--[[
    future.club | private luau build
    https://future.club
]]

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local SupportedGames = {
	[2788229376] = true,       -- Da Hood
	[92951962875133] = true,   -- Ders Hood
	[139031912939309] = true,  -- Des Hood
	[72285226303125] = true,   -- Das Hood
	[9825515356] = true,       -- Hood Customs
	[134196333708867] = true,  -- Da Strike
	[75882626617183] = true,   -- Dan FFA
	[113415569818535] = true,  -- Boom Hood
	[71324444457408] = true,   -- Da Uphill
	[139144803593140] = true,  -- Da Downhill
	[138014591158268] = true,  -- Zee Hood
}

if not SupportedGames[game.PlaceId] and not SupportedGames[game.GameId] then
	while true do end
end

pcall(function()
	local adonisThreads = {}
	if getreg then
		for _, item in getreg() do
			if typeof(item) == "thread" then
				local src = debug.info(item, 1, "s")
				if src and (src:match("%.Core%.Anti") or src:match("%.Plugins%.Anti_Cheat")) then
					table.insert(adonisThreads, item)
				end
			end
		end
		for _, th in ipairs(adonisThreads) do
			pcall(coroutine.close, th)
		end
	end

	local adonisTables = {}
	if filtergc then
		local found = filtergc("table", { Keys = { "Detected", "RLocked" } }, false)
		for _, t in ipairs(found) do
			if typeof(rawget(t, "Detected")) == "function" then
				table.insert(adonisTables, t)
			end
		end
	elseif getgc then
		for _, t in ipairs(getgc(true)) do
			if typeof(t) == "table" and rawget(t, "RLocked") and typeof(rawget(t, "Detected")) == "function" then
				table.insert(adonisTables, t)
			end
		end
	end

	if hookfunction and isfunctionhooked then
		for _, tbl in ipairs(adonisTables) do
			for _, func in pairs(tbl) do
				if typeof(func) == "function" and not isfunctionhooked(func) then
					hookfunction(func, function(...)
						coroutine.yield()
						return task.wait(9e9)
					end)
				end
			end
		end
	end
end)

if getgenv().FutureClubCleanup then
	pcall(getgenv().FutureClubCleanup)
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	pcall(function()
		LocalPlayer = Players:GetPlayers()[1]
	end)
end
if not LocalPlayer then
	task.spawn(function()
		pcall(function()
			LocalPlayer = Players.PlayerAdded:Wait()
		end)
	end)
end

local function getGuiContainer()
	local container = nil
	pcall(function()
		if gethui then
			container = gethui()
		end
	end)
	if not container then
		pcall(function()
			local test = Instance.new("Folder")
			test.Parent = CoreGui
			test:Destroy()
			container = CoreGui
		end)
	end
	if not container then
		pcall(function()
			local lp = Players.LocalPlayer or LocalPlayer
			if lp then
				container = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui", 3)
			end
		end)
	end
	if not container then
		pcall(function()
			container = CoreGui
		end)
	end
	return container
end

local FS = {
	hasFS = false,
	isfolder = function() return false end,
	makefolder = function() end,
	isfile = function() return false end,
	writefile = function() end,
	readfile = function() return "" end,
	delfile = function() end,
	listfiles = function() return {} end
}

pcall(function()
	if writefile and readfile then
		FS.hasFS = true
		FS.isfolder = isfolder or function() return false end
		FS.makefolder = makefolder or function() end
		FS.isfile = isfile or function() return false end
		FS.writefile = writefile
		FS.readfile = readfile
		FS.delfile = delfile or function() end
		FS.listfiles = listfiles or function() return {} end
	end
end)

local Icons = {
	combat = "rbxassetid://10734977012",
	player = "rbxassetid://10747373176",
	move = "rbxassetid://10734900011",
	visuals = "rbxassetid://10723346959",
	misc = "rbxassetid://10709810463",
	friends = "rbxassetid://10747372702",
	configs = "rbxassetid://10709806740",
	settings = "rbxassetid://10734963191",
	search = "rbxassetid://10734943674",
	gear = "rbxassetid://10734950309",
	chevron = "rbxassetid://10709790948",
	check = "rbxassetid://10709790644",
	close = "rbxassetid://10747384394",
	hourglass = "rbxassetid://10723407498"
}

local function resolveIcon(icon)
	if not icon or icon == "" then
		return Icons.combat
	end
	if string.sub(icon, 1, 13) == "rbxassetid://" or string.sub(icon, 1, 11) == "http://" or string.sub(icon, 1, 12) == "https://" then
		return icon
	end
	local lower = string.lower(icon)
	if Icons[lower] then
		return Icons[lower]
	end
	return Icons.combat
end

local function tween(object, properties, duration, style, direction)
	style = style or Enum.EasingStyle.Quad
	direction = direction or Enum.EasingDirection.Out
	duration = duration or 0.2
	local tweenInfo = TweenInfo.new(duration, style, direction)
	local anim = TweenService:Create(object, tweenInfo, properties)
	anim:Play()
	return anim
end

local function colorToHex(col)
	local r = math.clamp(math.floor(col.R * 255 + 0.5), 0, 255)
	local g = math.clamp(math.floor(col.G * 255 + 0.5), 0, 255)
	local b = math.clamp(math.floor(col.B * 255 + 0.5), 0, 255)
	return string.format("#%02X%02X%02X", r, g, b)
end

local function hexToColor(hex)
	hex = tostring(hex or ""):gsub("#", ""):gsub("%s+", "")
	if #hex == 3 then
		hex = hex:sub(1, 1):rep(2) .. hex:sub(2, 2):rep(2) .. hex:sub(3, 3):rep(2)
	end
	if #hex ~= 6 then
		return nil
	end
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)
	if not r or not g or not b then
		return nil
	end
	return Color3.fromRGB(r, g, b)
end

local function formatBrandRichText(rawTitle, col)
	rawTitle = tostring(rawTitle or "future.club")
	local hex = colorToHex(col)
	local dotPos = string.find(rawTitle, ".", 1, true)
	if dotPos then
		local prefix = string.sub(rawTitle, 1, dotPos - 1)
		local suffix = string.sub(rawTitle, dotPos)
		return string.format('<font color="#EAEAF2">%s</font><font color="%s">%s</font>', prefix, hex, suffix)
	end
	return string.format('<font color="%s">%s</font>', hex, rawTitle)
end

local function makeDraggable(frame, handles)
	if typeof(handles) ~= "table" then
		handles = {handles or frame}
	end
	local dragging = false
	local dragInput = nil
	local dragStart = nil
	local startPos = nil

	local function isGuiVisible(gui)
		local cur = gui
		while cur and cur:IsA("GuiObject") do
			if not cur.Visible then
				return false
			end
			cur = cur.Parent
		end
		return true
	end

	local function isInteractiveAt(pos)
		local foundInteractive = false
		pcall(function()
			local lp = Players.LocalPlayer or LocalPlayer
			local pgui = lp and (lp:FindFirstChildOfClass("PlayerGui") or lp:FindFirstChild("PlayerGui"))
			if pgui then
				local objs = pgui:GetGuiObjectsAtPosition(pos.X, pos.Y)
				if objs then
					for _, obj in ipairs(objs) do
						local cur = obj
						while cur and cur:IsA("GuiObject") do
							if cur:IsA("TextBox") or cur:IsA("TextButton") or cur:IsA("ImageButton") or cur.Name == "SearchBar" then
								foundInteractive = true
								return
							end
							cur = cur.Parent
						end
					end
				end
			end
		end)
		if foundInteractive then
			return true
		end
		for _, desc in ipairs(frame:GetDescendants()) do
			if desc:IsA("GuiObject") and desc.Visible then
				if desc:IsA("TextBox") or desc:IsA("TextButton") or desc:IsA("ImageButton") or desc.Name == "SearchBar" then
					local absPos = desc.AbsolutePosition
					local absSize = desc.AbsoluteSize
					if absSize.X > 0 and absSize.Y > 0 then
						if pos.X >= absPos.X and pos.X <= absPos.X + absSize.X and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y then
							if isGuiVisible(desc) then
								return true
							end
						end
					end
				end
			end
		end
		return false
	end

	for _, handle in ipairs(handles) do
		handle.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if isInteractiveAt(input.Position) then
					return
				end
				dragging = true
				dragInput = input
				dragStart = input.Position
				startPos = frame.Position
			end
		end)
	end

	UserInputService.InputChanged:Connect(function(input)
		if dragging then
			if input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				local delta = input.Position - dragStart
				frame.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
			dragInput = nil
		end
	end)
end

local Library = {
	Version = "2.0"
}
Library.__index = Library

function Library.CreateWindow(self, config)
	if type(self) == "table" and self ~= Library and config == nil then
		config = self
	end
	config = config or {}
	local titleText = config.Title or "future.club"
	local toggleKey = config.ToggleKey or Enum.KeyCode.P
	local accentColor = config.AccentColor or Color3.fromRGB(255, 75, 114)
	local configFolder = config.ConfigFolder or "future.club/configs"
	local showHourglass = config.SidebarHourglass
	if showHourglass == nil then
		showHourglass = true
	end
	local showMobileButton = config.MobileButton
	if showMobileButton == nil then
		showMobileButton = true
	end
	if UserInputService.TouchEnabled then
		showMobileButton = true
	end

	pcall(function()
		if FS.hasFS then
			if not FS.isfolder("future.club") then
				FS.makefolder("future.club")
			end
			if not FS.isfolder(configFolder) then
				FS.makefolder(configFolder)
			end
		end
	end)

	local container = getGuiContainer()

	if container then
		local existing = container:FindFirstChild("FutureClubGui")
		if existing then
			existing:Destroy()
		end
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FutureClubGui"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 9999

	local parentSuccess, _ = pcall(function()
		screenGui.Parent = container
	end)
	if not parentSuccess then
		pcall(function()
			local lp = Players.LocalPlayer or LocalPlayer
			if lp then
				screenGui.Parent = lp:FindFirstChildOfClass("PlayerGui") or lp:WaitForChild("PlayerGui", 5)
			end
		end)
	end

	local isMobileDevice = UserInputService.TouchEnabled
	local currentBaseScale = isMobileDevice and 0.62 or 1.0
	local pvScale

	local main = Instance.new("Frame")
	main.Name = "MainFrame"
	main.Size = UDim2.new(0, 810, 0, 550)
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	main.Parent = screenGui

	local mainScale = Instance.new("UIScale")
	mainScale.Scale = currentBaseScale
	mainScale.Parent = main

	local function updateResponsiveScale()
		local screenW = 1920
		local screenH = 1080
		local cam = workspace.CurrentCamera
		if screenGui.AbsoluteSize.X > 50 and screenGui.AbsoluteSize.Y > 50 then
			screenW = screenGui.AbsoluteSize.X
			screenH = screenGui.AbsoluteSize.Y
		elseif cam and cam.ViewportSize.X > 50 and cam.ViewportSize.Y > 50 then
			screenW = cam.ViewportSize.X
			screenH = cam.ViewportSize.Y
		end

		local isTouchOrSmall = isMobileDevice or screenH < 650 or screenW < 950
		if isTouchOrSmall then
			local maxW = screenW * 0.85
			local maxH = screenH * 0.82
			currentBaseScale = math.clamp(math.min(maxW / 810, maxH / 550), 0.58, 0.78)
		else
			local maxW = screenW * 0.85
			local maxH = screenH * 0.85
			currentBaseScale = math.clamp(math.min(maxW / 810, maxH / 550), 0.70, 1.0)
		end
		if mainScale then
			mainScale.Scale = currentBaseScale
		end
		if pvScale then
			pvScale.Scale = currentBaseScale
		end
	end

	screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateResponsiveScale)
	local function hookCamera()
		local cam = workspace.CurrentCamera
		if cam then
			cam:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsiveScale)
		end
	end
	hookCamera()
	workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(hookCamera)
	updateResponsiveScale()
	task.defer(updateResponsiveScale)
	task.delay(0.1, updateResponsiveScale)
	task.delay(0.4, updateResponsiveScale)

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 14)
	mainCorner.Parent = main

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = Color3.fromRGB(32, 32, 36)
	mainStroke.Thickness = 1
	mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	mainStroke.Parent = main

	local topWatermark = Instance.new("TextLabel")
	topWatermark.Name = "TopWatermark"
	topWatermark.Size = UDim2.new(0, 160, 0, 22)
	topWatermark.Position = UDim2.new(1, -22, 0, 22)
	topWatermark.AnchorPoint = Vector2.new(1, 0.5)
	topWatermark.BackgroundTransparency = 1
	topWatermark.Font = Enum.Font.GothamBold
	topWatermark.TextSize = 14
	topWatermark.RichText = true
	topWatermark.TextColor3 = Color3.fromRGB(234, 234, 242)
	topWatermark.TextXAlignment = Enum.TextXAlignment.Right
	topWatermark.TextYAlignment = Enum.TextYAlignment.Center
	topWatermark.Text = formatBrandRichText(titleText, accentColor)
	topWatermark.Parent = main

	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 196, 1, 0)
	sidebar.Position = UDim2.new(0, 0, 0, 0)
	sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
	sidebar.BorderSizePixel = 0
	sidebar.Parent = main

	local sidebarCorner = Instance.new("UICorner")
	sidebarCorner.CornerRadius = UDim.new(0, 14)
	sidebarCorner.Parent = sidebar

	local sidebarFix = Instance.new("Frame")
	sidebarFix.Name = "SidebarFix"
	sidebarFix.Size = UDim2.new(0, 14, 1, 0)
	sidebarFix.Position = UDim2.new(1, -14, 0, 0)
	sidebarFix.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
	sidebarFix.BorderSizePixel = 0
	sidebarFix.Parent = sidebar

	local sidebarDivider = Instance.new("Frame")
	sidebarDivider.Name = "Divider"
	sidebarDivider.Size = UDim2.new(0, 1, 1, -32)
	sidebarDivider.Position = UDim2.new(1, 0, 0, 16)
	sidebarDivider.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
	sidebarDivider.BorderSizePixel = 0
	sidebarDivider.Parent = sidebar

	if showHourglass then
		local hourglassWatermark = Instance.new("ImageLabel")
		hourglassWatermark.Name = "HourglassWatermark"
		hourglassWatermark.Size = UDim2.new(0, 154, 0, 154)
		hourglassWatermark.Position = UDim2.new(0.5, 0, 0, 241)
		hourglassWatermark.AnchorPoint = Vector2.new(0.5, 0.5)
		hourglassWatermark.BackgroundTransparency = 1
		hourglassWatermark.Image = config.HourglassImage or Icons.hourglass
		hourglassWatermark.ImageColor3 = Color3.fromRGB(48, 48, 54)
		hourglassWatermark.ImageTransparency = 0.55
		hourglassWatermark.ScaleType = Enum.ScaleType.Fit
		hourglassWatermark.ZIndex = 1
		hourglassWatermark.Parent = sidebar
	end

	local tabsHolder = Instance.new("ScrollingFrame")
	tabsHolder.Name = "TabsHolder"
	tabsHolder.Size = UDim2.new(1, -24, 1, -120)
	tabsHolder.Position = UDim2.new(0, 12, 0, 18)
	tabsHolder.BackgroundTransparency = 1
	tabsHolder.BorderSizePixel = 0
	tabsHolder.ScrollBarThickness = 4
	tabsHolder.ScrollBarImageColor3 = Color3.fromRGB(45, 45, 52)
	tabsHolder.ScrollingDirection = Enum.ScrollingDirection.Y
	tabsHolder.ElasticBehavior = Enum.ElasticBehavior.Always
	tabsHolder.Active = true
	tabsHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabsHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabsHolder.ZIndex = 2
	tabsHolder.Parent = sidebar

	local tabsLayout = Instance.new("UIListLayout")
	tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabsLayout.Padding = UDim.new(0, 6)
	tabsLayout.Parent = tabsHolder

	tabsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabsHolder.CanvasSize = UDim2.new(0, 0, 0, tabsLayout.AbsoluteContentSize.Y + 12)
	end)

	local searchBar = Instance.new("Frame")
	searchBar.Name = "SearchBar"
	searchBar.Size = UDim2.new(1, -24, 0, 34)
	searchBar.Position = UDim2.new(0, 12, 1, -94)
	searchBar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
	searchBar.BorderSizePixel = 0
	searchBar.ZIndex = 2
	searchBar.Parent = sidebar

	local searchCorner = Instance.new("UICorner")
	searchCorner.CornerRadius = UDim.new(0, 17)
	searchCorner.Parent = searchBar

	local searchStroke = Instance.new("UIStroke")
	searchStroke.Color = Color3.fromRGB(32, 32, 38)
	searchStroke.Thickness = 1
	searchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	searchStroke.Parent = searchBar

	local searchIcon = Instance.new("ImageLabel")
	searchIcon.Name = "Icon"
	searchIcon.Size = UDim2.new(0, 14, 0, 14)
	searchIcon.Position = UDim2.new(0, 12, 0.5, 0)
	searchIcon.AnchorPoint = Vector2.new(0, 0.5)
	searchIcon.BackgroundTransparency = 1
	searchIcon.Image = Icons.search
	searchIcon.ImageColor3 = Color3.fromRGB(95, 95, 105)
	searchIcon.ZIndex = 2
	searchIcon.Parent = searchBar

	local searchInput = Instance.new("TextBox")
	searchInput.Name = "Input"
	searchInput.Size = UDim2.new(1, -38, 1, 0)
	searchInput.Position = UDim2.new(0, 32, 0, 0)
	searchInput.BackgroundTransparency = 1
	searchInput.Font = Enum.Font.Gotham
	searchInput.TextSize = 12
	searchInput.TextColor3 = Color3.fromRGB(240, 240, 245)
	searchInput.PlaceholderText = "Search"
	searchInput.PlaceholderColor3 = Color3.fromRGB(95, 95, 105)
	searchInput.TextXAlignment = Enum.TextXAlignment.Left
	searchInput.ClearTextOnFocus = false
	searchInput.Text = ""
	searchInput.ZIndex = 2
	searchInput.Parent = searchBar

	local profileCard = Instance.new("Frame")
	profileCard.Name = "ProfileCard"
	profileCard.Size = UDim2.new(1, -24, 0, 42)
	profileCard.Position = UDim2.new(0, 12, 1, -50)
	profileCard.BackgroundTransparency = 1
	profileCard.ZIndex = 2
	profileCard.Parent = sidebar

	local avatarImage = Instance.new("ImageLabel")
	avatarImage.Name = "Avatar"
	avatarImage.Size = UDim2.new(0, 34, 0, 34)
	avatarImage.Position = UDim2.new(0, 0, 0.5, 0)
	avatarImage.AnchorPoint = Vector2.new(0, 0.5)
	avatarImage.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
	avatarImage.BorderSizePixel = 0
	avatarImage.ZIndex = 2
	avatarImage.Parent = profileCard

	local avatarCorner = Instance.new("UICorner")
	avatarCorner.CornerRadius = UDim.new(0, 7)
	avatarCorner.Parent = avatarImage

	local avatarStroke = Instance.new("UIStroke")
	avatarStroke.Color = Color3.fromRGB(34, 34, 40)
	avatarStroke.Thickness = 1
	avatarStroke.Parent = avatarImage

	local playerDisplay = "Player"
	local avatarUrl = Icons.player

	local lp = Players.LocalPlayer or LocalPlayer
	if lp then
		playerDisplay = (lp.DisplayName and lp.DisplayName ~= "") and lp.DisplayName or lp.Name
		if lp.UserId and lp.UserId > 0 then
			avatarUrl = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(lp.UserId) .. "&w=48&h=48"
			task.spawn(function()
				pcall(function()
					local content, isReady = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
					if isReady and content and content ~= "" then
						avatarImage.Image = content
					end
				end)
			end)
		end
	end
	if config.Username then
		playerDisplay = config.Username
	end
	avatarImage.Image = avatarUrl

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "Username"
	nameLabel.Size = UDim2.new(1, -44, 0, 20)
	nameLabel.Position = UDim2.new(0, 42, 0.5, 0)
	nameLabel.AnchorPoint = Vector2.new(0, 0.5)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 13
	nameLabel.TextColor3 = Color3.fromRGB(242, 242, 246)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	nameLabel.Text = playerDisplay
	nameLabel.ZIndex = 2
	nameLabel.Parent = profileCard

	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.Size = UDim2.new(1, -214, 1, -54)
	contentArea.Position = UDim2.new(0, 206, 0, 44)
	contentArea.BackgroundTransparency = 1
	contentArea.ClipsDescendants = true
	contentArea.Parent = main

	local notificationContainer = Instance.new("Frame")
	notificationContainer.Name = "NotificationContainer"
	notificationContainer.Size = UDim2.new(0, 310, 1, -40)
	notificationContainer.Position = UDim2.new(1, -20, 1, -20)
	notificationContainer.AnchorPoint = Vector2.new(1, 1)
	notificationContainer.BackgroundTransparency = 1
	notificationContainer.ZIndex = 10
	notificationContainer.Parent = screenGui

	local notifLayout = Instance.new("UIListLayout")
	notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
	notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	notifLayout.Padding = UDim.new(0, 8)
	notifLayout.Parent = notificationContainer

	local dragHeader = Instance.new("Frame")
	dragHeader.Name = "DragHeader"
	dragHeader.Size = UDim2.new(1, -196, 0, 44)
	dragHeader.Position = UDim2.new(0, 196, 0, 0)
	dragHeader.BackgroundTransparency = 1
	dragHeader.ZIndex = 3
	dragHeader.Parent = main

	makeDraggable(main, {dragHeader})

	local windowObj = {
		Gui = screenGui,
		Main = main,
		Tabs = {},
		AllModules = {},
		ModuleByName = {},
		ModuleCreateListeners = {},
		FloatingButtons = {},
		ButtonsLocked = false,
		PreviewEnabled = config.ShowPreviewWindow ~= false,
		PreviewMode = "ESP",
		ActiveTab = nil,
		SearchQuery = "",
		Keybinds = {},
		Flags = {},
		ConfigElements = {},
		ThemeRefreshers = {},
		AccentColor = accentColor,
		ToggleKey = toggleKey,
		ConfigFolder = configFolder,
		MemoryConfigs = {},
		ESPPreviewState = {
			Enabled = true,
			Boxes = true,
			BoxStyle = "Full",
			BoxFilled = false,
			BoxColor = accentColor,
			Names = true,
			NameColor = Color3.fromRGB(245, 245, 250),
			Health = true,
			HealthColor = Color3.fromRGB(90, 245, 140),
			Distance = true,
			DistanceColor = Color3.fromRGB(165, 165, 180),
			Weapon = true,
			Tracers = false,
			TracerColor = Color3.fromRGB(0, 210, 140),
			Chams = false,
			ChamsColor = accentColor,
			Bones = false,
			BoneColor = Color3.fromRGB(240, 240, 250),
			HeadDot = false,
			HeadDotColor = accentColor
		},
		ButtonDraft = {
			Feature = "Aim Assist",
			Label = "",
			Style = "Standard",
			Width = 116,
			Height = 42,
			CornerRadius = 10,
			Opacity = 88,
			PreviewActive = true
		}
	}

	local function registerThemeRefresher(fn)
		table.insert(windowObj.ThemeRefreshers, fn)
	end

	local mobileBtn = nil
	local mbStroke = nil
	local mbIcon = nil

	function windowObj:SetAccentColor(col)
		if typeof(col) ~= "Color3" then return end
		windowObj.AccentColor = col
		accentColor = col
		if mbStroke and main.Visible then
			mbStroke.Color = col
		end
		if mbIcon then
			mbIcon.ImageColor3 = col
		end
		for _, fn in ipairs(windowObj.ThemeRefreshers) do
			pcall(fn, col)
		end
	end

	function windowObj:SetToggleKey(key)
		if typeof(key) == "EnumItem" then
			toggleKey = key
			windowObj.ToggleKey = key
		end
	end

	local wmFrame = Instance.new("Frame")
	wmFrame.Name = "WatermarkHUD"
	wmFrame.Size = UDim2.new(0, 260, 0, 30)
	wmFrame.Position = UDim2.new(0, 18, 0, 18)
	wmFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
	wmFrame.BorderSizePixel = 0
	wmFrame.Visible = config.ShowWatermark == true
	wmFrame.ZIndex = 900
	wmFrame.Parent = screenGui

	local wmCorner = Instance.new("UICorner")
	wmCorner.CornerRadius = UDim.new(0, 8)
	wmCorner.Parent = wmFrame

	local wmStroke = Instance.new("UIStroke")
	wmStroke.Color = Color3.fromRGB(32, 32, 38)
	wmStroke.Thickness = 1
	wmStroke.Parent = wmFrame

	local wmAccent = Instance.new("Frame")
	wmAccent.Name = "Accent"
	wmAccent.Size = UDim2.new(0, 3, 1, -12)
	wmAccent.Position = UDim2.new(0, 6, 0.5, 0)
	wmAccent.AnchorPoint = Vector2.new(0, 0.5)
	wmAccent.BackgroundColor3 = accentColor
	wmAccent.BorderSizePixel = 0
	wmAccent.Parent = wmFrame

	local wmAccentCorner = Instance.new("UICorner")
	wmAccentCorner.CornerRadius = UDim.new(1, 0)
	wmAccentCorner.Parent = wmAccent

	local wmLabel = Instance.new("TextLabel")
	wmLabel.Name = "Text"
	wmLabel.Size = UDim2.new(1, -22, 1, 0)
	wmLabel.Position = UDim2.new(0, 16, 0, 0)
	wmLabel.BackgroundTransparency = 1
	wmLabel.Font = Enum.Font.GothamBold
	wmLabel.TextSize = 12
	wmLabel.RichText = true
	wmLabel.TextColor3 = Color3.fromRGB(235, 235, 242)
	wmLabel.TextXAlignment = Enum.TextXAlignment.Left
	wmLabel.Text = formatBrandRichText(titleText, accentColor) .. "  |  60 FPS  |  0 ms"
	wmLabel.Parent = wmFrame

	makeDraggable(wmFrame, {wmFrame})

	registerThemeRefresher(function(col)
		topWatermark.Text = formatBrandRichText(titleText, col)
		wmAccent.BackgroundColor3 = col
	end)

	local kbFrame = Instance.new("Frame")
	kbFrame.Name = "KeybindListHUD"
	kbFrame.Size = UDim2.new(0, 190, 0, 32)
	kbFrame.Position = UDim2.new(0, 18, 0.42, 0)
	kbFrame.BackgroundColor3 = Color3.fromRGB(16, 16, 19)
	kbFrame.BorderSizePixel = 0
	kbFrame.Visible = config.ShowKeybindList == true
	kbFrame.ZIndex = 900
	kbFrame.Parent = screenGui

	local kbCorner = Instance.new("UICorner")
	kbCorner.CornerRadius = UDim.new(0, 9)
	kbCorner.Parent = kbFrame

	local kbStroke = Instance.new("UIStroke")
	kbStroke.Color = Color3.fromRGB(32, 32, 38)
	kbStroke.Thickness = 1
	kbStroke.Parent = kbFrame

	local kbHeader = Instance.new("Frame")
	kbHeader.Name = "Header"
	kbHeader.Size = UDim2.new(1, 0, 0, 28)
	kbHeader.BackgroundTransparency = 1
	kbHeader.Parent = kbFrame

	local kbTitle = Instance.new("TextLabel")
	kbTitle.Name = "Title"
	kbTitle.Size = UDim2.new(1, -20, 1, 0)
	kbTitle.Position = UDim2.new(0, 10, 0, 0)
	kbTitle.BackgroundTransparency = 1
	kbTitle.Font = Enum.Font.GothamBold
	kbTitle.TextSize = 12
	kbTitle.TextColor3 = accentColor
	kbTitle.TextXAlignment = Enum.TextXAlignment.Left
	kbTitle.Text = "Keybinds"
	kbTitle.Parent = kbHeader

	local kbLine = Instance.new("Frame")
	kbLine.Name = "Line"
	kbLine.Size = UDim2.new(1, -16, 0, 1)
	kbLine.Position = UDim2.new(0, 8, 0, 28)
	kbLine.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
	kbLine.BorderSizePixel = 0
	kbLine.Parent = kbFrame

	local kbListHolder = Instance.new("Frame")
	kbListHolder.Name = "List"
	kbListHolder.Size = UDim2.new(1, -16, 0, 0)
	kbListHolder.Position = UDim2.new(0, 8, 0, 32)
	kbListHolder.BackgroundTransparency = 1
	kbListHolder.Parent = kbFrame

	local kbListLayout = Instance.new("UIListLayout")
	kbListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	kbListLayout.Padding = UDim.new(0, 4)
	kbListLayout.Parent = kbListHolder

	makeDraggable(kbFrame, {kbFrame, kbHeader})

	registerThemeRefresher(function(col)
		kbTitle.TextColor3 = col
	end)

	local function refreshKeybindHUD()
		if not kbFrame.Visible then return end
		for _, child in ipairs(kbListHolder:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end
		local count = 0
		for _, kbEntry in ipairs(windowObj.Keybinds) do
			local key = kbEntry.GetKey()
			if key and key ~= Enum.KeyCode.Unknown then
				count = count + 1
				local row = Instance.new("Frame")
				row.Name = "Bind_" .. tostring(count)
				row.Size = UDim2.new(1, 0, 0, 18)
				row.BackgroundTransparency = 1
				row.Parent = kbListHolder

				local isActive = kbEntry.IsActive()
				local nameL = Instance.new("TextLabel")
				nameL.Size = UDim2.new(1, -60, 1, 0)
				nameL.BackgroundTransparency = 1
				nameL.Font = Enum.Font.GothamMedium
				nameL.TextSize = 11
				nameL.TextColor3 = isActive and accentColor or Color3.fromRGB(165, 165, 175)
				nameL.TextXAlignment = Enum.TextXAlignment.Left
				nameL.TextTruncate = Enum.TextTruncate.AtEnd
				nameL.Text = kbEntry.Name
				nameL.Parent = row

				local keyL = Instance.new("TextLabel")
				keyL.Size = UDim2.new(0, 58, 1, 0)
				keyL.Position = UDim2.new(1, 0, 0, 0)
				keyL.AnchorPoint = Vector2.new(1, 0)
				keyL.BackgroundTransparency = 1
				keyL.Font = Enum.Font.GothamBold
				keyL.TextSize = 10
				keyL.TextColor3 = isActive and accentColor or Color3.fromRGB(115, 115, 125)
				keyL.TextXAlignment = Enum.TextXAlignment.Right
				local function formatHUDKey(k)
					if not k or k == Enum.KeyCode.Unknown then return "[-]"
					end
					if typeof(k) == "EnumItem" then
						if k.EnumType == Enum.UserInputType then
							if k == Enum.UserInputType.MouseButton1 then return "[M1]"
							elseif k == Enum.UserInputType.MouseButton2 then return "[M2]"
							elseif k == Enum.UserInputType.MouseButton3 then return "[M3]"
							end
							return "[" .. k.Name .. "]"
						elseif k.EnumType == Enum.KeyCode then
							local n = k.Name
							if n:sub(1, 6) == "Button" then return "[" .. n:sub(7) .. "]"
							end
							return "[" .. n .. "]"
						end
					end
					return "[-]"
				end
				keyL.Text = formatHUDKey(key)
				keyL.Parent = row
			end
		end
		local listH = count > 0 and (count * 22) or 4
		kbLine.Visible = count > 0
		kbFrame.Size = UDim2.new(0, 190, 0, 32 + listH)
	end

	function windowObj:SetWatermarkVisible(state)
		wmFrame.Visible = state == true
	end

	function windowObj:SetKeybindListVisible(state)
		kbFrame.Visible = state == true
		if state then
			refreshKeybindHUD()
		end
	end

	local previewWidth = 252
	local previewFrame = Instance.new("Frame")
	previewFrame.Name = "PreviewWindow"
	previewFrame.Size = UDim2.new(0, previewWidth, 0, 550)
	previewFrame.AnchorPoint = Vector2.new(0, 0)
	previewFrame.Position = UDim2.new(0.5, 417, 0.5, -275)
	previewFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
	previewFrame.BorderSizePixel = 0
	previewFrame.ClipsDescendants = true
	previewFrame.Visible = false
	previewFrame.ZIndex = 5
	previewFrame.Parent = screenGui

	pvScale = Instance.new("UIScale")
	pvScale.Scale = currentBaseScale
	pvScale.Parent = previewFrame

	local pvCorner = Instance.new("UICorner")
	pvCorner.CornerRadius = UDim.new(0, 14)
	pvCorner.Parent = previewFrame

	local pvStroke = Instance.new("UIStroke")
	pvStroke.Color = Color3.fromRGB(32, 32, 36)
	pvStroke.Thickness = 1
	pvStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	pvStroke.Parent = previewFrame

	local pvHeader = Instance.new("Frame")
	pvHeader.Name = "Header"
	pvHeader.Size = UDim2.new(1, 0, 0, 44)
	pvHeader.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
	pvHeader.BorderSizePixel = 0
	pvHeader.Parent = previewFrame

	local pvHeaderCorner = Instance.new("UICorner")
	pvHeaderCorner.CornerRadius = UDim.new(0, 14)
	pvHeaderCorner.Parent = pvHeader

	local pvHeaderFix = Instance.new("Frame")
	pvHeaderFix.Name = "BottomFix"
	pvHeaderFix.Size = UDim2.new(1, 0, 0, 14)
	pvHeaderFix.Position = UDim2.new(0, 0, 1, -14)
	pvHeaderFix.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
	pvHeaderFix.BorderSizePixel = 0
	pvHeaderFix.Parent = pvHeader

	local pvHeaderDivider = Instance.new("Frame")
	pvHeaderDivider.Name = "Divider"
	pvHeaderDivider.Size = UDim2.new(1, -24, 0, 1)
	pvHeaderDivider.Position = UDim2.new(0, 12, 1, 0)
	pvHeaderDivider.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
	pvHeaderDivider.BorderSizePixel = 0
	pvHeaderDivider.Parent = pvHeader

	makeDraggable(previewFrame, {pvHeader})

	local pvTitle = Instance.new("TextLabel")
	pvTitle.Name = "Title"
	pvTitle.Size = UDim2.new(1, -28, 1, 0)
	pvTitle.Position = UDim2.new(0, 14, 0, 0)
	pvTitle.BackgroundTransparency = 1
	pvTitle.Font = Enum.Font.GothamBold
	pvTitle.TextSize = 13
	pvTitle.TextColor3 = Color3.fromRGB(238, 238, 245)
	pvTitle.TextXAlignment = Enum.TextXAlignment.Left
	pvTitle.Text = "preview"
	pvTitle.Parent = pvHeader

	local espPreviewPage = Instance.new("Frame")
	espPreviewPage.Name = "ESPPreviewPage"
	espPreviewPage.Size = UDim2.new(1, 0, 1, -44)
	espPreviewPage.Position = UDim2.new(0, 0, 0, 44)
	espPreviewPage.BackgroundTransparency = 1
	espPreviewPage.Visible = true
	espPreviewPage.Parent = previewFrame

	local espStage = Instance.new("Frame")
	espStage.Name = "Stage"
	espStage.Size = UDim2.new(1, -24, 1, -24)
	espStage.Position = UDim2.new(0, 12, 0, 12)
	espStage.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
	espStage.BorderSizePixel = 0
	espStage.ClipsDescendants = true
	espStage.Parent = espPreviewPage

	local espStageCorner = Instance.new("UICorner")
	espStageCorner.CornerRadius = UDim.new(0, 10)
	espStageCorner.Parent = espStage

	local espStageStroke = Instance.new("UIStroke")
	espStageStroke.Color = Color3.fromRGB(28, 28, 34)
	espStageStroke.Thickness = 1
	espStageStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	espStageStroke.Parent = espStage

	for g = 1, 7 do
		local hLine = Instance.new("Frame")
		hLine.Size = UDim2.new(1, 0, 0, 1)
		hLine.Position = UDim2.new(0, 0, g / 8, 0)
		hLine.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
		hLine.BorderSizePixel = 0
		hLine.ZIndex = 1
		hLine.Parent = espStage
	end
	for g = 1, 4 do
		local vLine = Instance.new("Frame")
		vLine.Size = UDim2.new(0, 1, 1, 0)
		vLine.Position = UDim2.new(g / 5, 0, 0, 0)
		vLine.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
		vLine.BorderSizePixel = 0
		vLine.ZIndex = 1
		vLine.Parent = espStage
	end

	local espViewport = Instance.new("ViewportFrame")
	espViewport.Name = "AvatarViewport"
	espViewport.Size = UDim2.new(1, 0, 1, 0)
	espViewport.Position = UDim2.new(0, 0, 0, 0)
	espViewport.BackgroundTransparency = 1
	espViewport.Ambient = Color3.fromRGB(185, 185, 195)
	espViewport.LightColor = Color3.fromRGB(255, 255, 255)
	espViewport.LightDirection = Vector3.new(-1, -1, -1)
	espViewport.ZIndex = 2
	espViewport.Parent = espStage

	local vpCamera = Instance.new("Camera")
	vpCamera.FieldOfView = 32
	vpCamera.Parent = espViewport
	espViewport.CurrentCamera = vpCamera

	local vpWorldModel = nil
	pcall(function()
		vpWorldModel = Instance.new("WorldModel")
		vpWorldModel.Parent = espViewport
	end)

	local avatarFallbackImg = Instance.new("ImageLabel")
	avatarFallbackImg.Name = "AvatarFallback"
	avatarFallbackImg.Size = UDim2.new(0, 270, 0, 270)
	avatarFallbackImg.Position = UDim2.new(0.5, 0, 0.5, 0)
	avatarFallbackImg.AnchorPoint = Vector2.new(0.5, 0.5)
	avatarFallbackImg.BackgroundTransparency = 1
	avatarFallbackImg.ScaleType = Enum.ScaleType.Fit
	avatarFallbackImg.Image = "rbxthumb://type=Avatar&id=11195502927&w=420&h=420"
	avatarFallbackImg.ZIndex = 2
	avatarFallbackImg.Parent = espStage

	local rigBounds = Instance.new("Frame")
	rigBounds.Name = "RigBounds"
	rigBounds.Size = UDim2.new(0, 120, 0, 270)
	rigBounds.Position = UDim2.new(0.5, 0, 0.5, 0)
	rigBounds.AnchorPoint = Vector2.new(0.5, 0.5)
	rigBounds.BackgroundTransparency = 1
	rigBounds.ZIndex = 4
	rigBounds.Parent = espStage

	local chamsOverlay = Instance.new("Frame")
	chamsOverlay.Name = "ChamsOverlay"
	chamsOverlay.Size = UDim2.new(1, -16, 1, -12)
	chamsOverlay.Position = UDim2.new(0.5, 0, 0.5, 0)
	chamsOverlay.AnchorPoint = Vector2.new(0.5, 0.5)
	chamsOverlay.BackgroundColor3 = accentColor
	chamsOverlay.BackgroundTransparency = 1
	chamsOverlay.BorderSizePixel = 0
	chamsOverlay.ZIndex = 3
	chamsOverlay.Parent = rigBounds

	local chamsOverlayCorner = Instance.new("UICorner")
	chamsOverlayCorner.CornerRadius = UDim.new(0, 8)
	chamsOverlayCorner.Parent = chamsOverlay

	local chamsModelParts = {}
	local TARGET_AVATAR_USER_ID = 11195502927

	task.spawn(function()
		local loaded3D = false
		pcall(function()
			local rig = Players:CreateHumanoidModelFromUserId(TARGET_AVATAR_USER_ID)
			if rig then
				rig.Name = "6vxft"
				rig.Parent = vpWorldModel or espViewport
				local root = rig:FindFirstChild("HumanoidRootPart") or rig.PrimaryPart or rig:FindFirstChild("Torso") or rig:FindFirstChild("UpperTorso")
				if root then
					rig:PivotTo(CFrame.new(0, 0, 0))
					local bbCF, bbSize = rig:GetBoundingBox()
					local tanHalf = math.tan(math.rad(vpCamera.FieldOfView / 2))
					local function fitCamera()
						local viewH = espViewport.AbsoluteSize.Y
						if viewH < 50 then return end
						local targetPx = math.clamp(viewH * 0.62, 180, 300)
						local dist = (bbSize.Y * viewH) / (targetPx * 2 * tanHalf)
						local center = bbCF.Position
						vpCamera.CFrame = CFrame.lookAt(center + Vector3.new(0, 0, -dist), center)
						local pxPerStud = targetPx / bbSize.Y
						rigBounds.Size = UDim2.new(0, math.floor(bbSize.X * pxPerStud) + 8, 0, math.floor(targetPx) + 6)
						rigBounds.Position = UDim2.new(0.5, 0, 0.5, 0)
					end
					fitCamera()
					espViewport:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitCamera)
					task.delay(0.5, fitCamera)
					for _, desc in ipairs(rig:GetDescendants()) do
						if desc:IsA("BasePart") and desc.Name ~= "HumanoidRootPart" then
							table.insert(chamsModelParts, {
								Part = desc,
								OrigColor = desc.Color,
								OrigMaterial = desc.Material,
								OrigTrans = desc.Transparency
							})
						end
					end
					avatarFallbackImg.Visible = false
					loaded3D = true
				end
			end
		end)
		if not loaded3D then
			pcall(function()
				local content = Players:GetUserThumbnailAsync(TARGET_AVATAR_USER_ID, Enum.ThumbnailType.AvatarThumbnail, Enum.ThumbnailSize.Size420x420)
				if content and content ~= "" then
					avatarFallbackImg.Image = content
				end
			end)
		end
	end)

	local bonesHolder = Instance.new("Frame")
	bonesHolder.Name = "Bones"
	bonesHolder.Size = UDim2.new(1, 0, 1, 0)
	bonesHolder.BackgroundTransparency = 1
	bonesHolder.Visible = false
	bonesHolder.ZIndex = 6
	bonesHolder.Parent = rigBounds

	local boneLines = {}
	local function createBone(pos, size, rot)
		local b = Instance.new("Frame")
		b.Position = pos
		b.Size = size
		b.AnchorPoint = Vector2.new(0.5, 0.5)
		b.Rotation = rot or 0
		b.BackgroundColor3 = Color3.fromRGB(240, 240, 250)
		b.BorderSizePixel = 0
		b.ZIndex = 6
		b.Parent = bonesHolder
		table.insert(boneLines, b)
		return b
	end
	createBone(UDim2.new(0.5, 0, 0, 92), UDim2.new(0, 2, 0, 104), 0) -- Spine
	createBone(UDim2.new(0.5, 0, 0, 68), UDim2.new(0, 84, 0, 2), 0) -- Shoulders
	createBone(UDim2.new(0.5, -42, 0, 104), UDim2.new(0, 2, 0, 72), 0) -- L Arm
	createBone(UDim2.new(0.5, 42, 0, 104), UDim2.new(0, 2, 0, 72), 0) -- R Arm
	createBone(UDim2.new(0.5, 0, 0, 144), UDim2.new(0, 34, 0, 2), 0) -- Pelvis
	createBone(UDim2.new(0.5, -17, 0, 192), UDim2.new(0, 2, 0, 94), 0) -- L Leg
	createBone(UDim2.new(0.5, 17, 0, 192), UDim2.new(0, 2, 0, 94), 0) -- R Leg

	local espHeadDot = Instance.new("Frame")
	espHeadDot.Name = "HeadDot"
	espHeadDot.Size = UDim2.new(0, 10, 0, 10)
	espHeadDot.Position = UDim2.new(0.5, 0, 0, 34)
	espHeadDot.AnchorPoint = Vector2.new(0.5, 0.5)
	espHeadDot.BackgroundColor3 = accentColor
	espHeadDot.BorderSizePixel = 0
	espHeadDot.Visible = false
	espHeadDot.ZIndex = 7
	espHeadDot.Parent = rigBounds

	local hdCorner = Instance.new("UICorner")
	hdCorner.CornerRadius = UDim.new(1, 0)
	hdCorner.Parent = espHeadDot

	local hdStroke = Instance.new("UIStroke")
	hdStroke.Color = Color3.fromRGB(10, 10, 12)
	hdStroke.Thickness = 1.2
	hdStroke.Parent = espHeadDot

	local espBoxHolder = Instance.new("Frame")
	espBoxHolder.Name = "ESPBox"
	espBoxHolder.Size = UDim2.new(1, 0, 1, 0)
	espBoxHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
	espBoxHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	espBoxHolder.BackgroundColor3 = accentColor
	espBoxHolder.BackgroundTransparency = 1
	espBoxHolder.BorderSizePixel = 0
	espBoxHolder.ZIndex = 5
	espBoxHolder.Parent = rigBounds

	local espBoxOuterStroke = Instance.new("UIStroke")
	espBoxOuterStroke.Color = Color3.fromRGB(8, 8, 10)
	espBoxOuterStroke.Thickness = 2.5
	espBoxOuterStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	espBoxOuterStroke.Parent = espBoxHolder

	local espBoxInner = Instance.new("Frame")
	espBoxInner.Name = "InnerBox"
	espBoxInner.Size = UDim2.new(1, 0, 1, 0)
	espBoxInner.BackgroundTransparency = 1
	espBoxInner.ZIndex = 6
	espBoxInner.Parent = espBoxHolder

	local espBoxStroke = Instance.new("UIStroke")
	espBoxStroke.Color = accentColor
	espBoxStroke.Thickness = 1.4
	espBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	espBoxStroke.Parent = espBoxInner

	local cornerBoxContainer = Instance.new("Frame")
	cornerBoxContainer.Name = "CornerBox"
	cornerBoxContainer.Size = UDim2.new(1, 0, 1, 0)
	cornerBoxContainer.BackgroundTransparency = 1
	cornerBoxContainer.Visible = false
	cornerBoxContainer.ZIndex = 6
	cornerBoxContainer.Parent = espBoxHolder

	local cornerSegments = {}
	local function addCornerSeg(pos, anchor, size)
		local seg = Instance.new("Frame")
		seg.Position = pos
		seg.AnchorPoint = anchor
		seg.Size = size
		seg.BackgroundColor3 = accentColor
		seg.BorderSizePixel = 0
		seg.ZIndex = 6
		seg.Parent = cornerBoxContainer
		table.insert(cornerSegments, seg)
	end
	addCornerSeg(UDim2.new(0, 0, 0, 0), Vector2.new(0, 0), UDim2.new(0, 18, 0, 2))
	addCornerSeg(UDim2.new(0, 0, 0, 0), Vector2.new(0, 0), UDim2.new(0, 2, 0, 18))
	addCornerSeg(UDim2.new(1, 0, 0, 0), Vector2.new(1, 0), UDim2.new(0, 18, 0, 2))
	addCornerSeg(UDim2.new(1, 0, 0, 0), Vector2.new(1, 0), UDim2.new(0, 2, 0, 18))
	addCornerSeg(UDim2.new(0, 0, 1, 0), Vector2.new(0, 1), UDim2.new(0, 18, 0, 2))
	addCornerSeg(UDim2.new(0, 0, 1, 0), Vector2.new(0, 1), UDim2.new(0, 2, 0, 18))
	addCornerSeg(UDim2.new(1, 0, 1, 0), Vector2.new(1, 1), UDim2.new(0, 18, 0, 2))
	addCornerSeg(UDim2.new(1, 0, 1, 0), Vector2.new(1, 1), UDim2.new(0, 2, 0, 18))

	local espHealthBg = Instance.new("Frame")
	espHealthBg.Name = "HealthBar"
	espHealthBg.Size = UDim2.new(0, 4, 1, 0)
	espHealthBg.Position = UDim2.new(0, -8, 0.5, 0)
	espHealthBg.AnchorPoint = Vector2.new(1, 0.5)
	espHealthBg.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
	espHealthBg.BorderSizePixel = 0
	espHealthBg.ZIndex = 6
	espHealthBg.Parent = rigBounds

	local espHealthFill = Instance.new("Frame")
	espHealthFill.Name = "Fill"
	espHealthFill.Size = UDim2.new(1, 0, 0.86, 0)
	espHealthFill.Position = UDim2.new(0, 0, 1, 0)
	espHealthFill.AnchorPoint = Vector2.new(0, 1)
	espHealthFill.BackgroundColor3 = Color3.fromRGB(90, 245, 140)
	espHealthFill.BorderSizePixel = 0
	espHealthFill.ZIndex = 7
	espHealthFill.Parent = espHealthBg

	local espHealthText = Instance.new("TextLabel")
	espHealthText.Name = "HPText"
	espHealthText.Size = UDim2.new(0, 30, 0, 12)
	espHealthText.Position = UDim2.new(0, -4, 0.14, 0)
	espHealthText.AnchorPoint = Vector2.new(1, 0.5)
	espHealthText.BackgroundTransparency = 1
	espHealthText.Font = Enum.Font.GothamBold
	espHealthText.TextSize = 10
	espHealthText.TextColor3 = Color3.fromRGB(90, 245, 140)
	espHealthText.TextXAlignment = Enum.TextXAlignment.Right
	espHealthText.Text = "86"
	espHealthText.ZIndex = 7
	espHealthText.Parent = espHealthBg

	local espNameTag = Instance.new("TextLabel")
	espNameTag.Name = "NameTag"
	espNameTag.Size = UDim2.new(0, 160, 0, 16)
	espNameTag.Position = UDim2.new(0.5, 0, 0, -22)
	espNameTag.AnchorPoint = Vector2.new(0.5, 0)
	espNameTag.BackgroundTransparency = 1
	espNameTag.Font = Enum.Font.GothamBold
	espNameTag.TextSize = 12
	espNameTag.TextColor3 = Color3.fromRGB(245, 245, 250)
	espNameTag.Text = "6vxft"
	espNameTag.ZIndex = 7
	espNameTag.Parent = rigBounds

	local espWeaponTag = Instance.new("TextLabel")
	espWeaponTag.Name = "WeaponTag"
	espWeaponTag.Size = UDim2.new(0, 160, 0, 14)
	espWeaponTag.Position = UDim2.new(0.5, 0, 1, 6)
	espWeaponTag.AnchorPoint = Vector2.new(0.5, 0)
	espWeaponTag.BackgroundTransparency = 1
	espWeaponTag.Font = Enum.Font.GothamMedium
	espWeaponTag.TextSize = 10
	espWeaponTag.TextColor3 = Color3.fromRGB(205, 205, 218)
	espWeaponTag.Text = "[Double-Barrel SG]"
	espWeaponTag.ZIndex = 7
	espWeaponTag.Parent = rigBounds

	local espDistTag = Instance.new("TextLabel")
	espDistTag.Name = "DistanceTag"
	espDistTag.Size = UDim2.new(0, 160, 0, 14)
	espDistTag.Position = UDim2.new(0.5, 0, 1, 20)
	espDistTag.AnchorPoint = Vector2.new(0.5, 0)
	espDistTag.BackgroundTransparency = 1
	espDistTag.Font = Enum.Font.GothamMedium
	espDistTag.TextSize = 10
	espDistTag.TextColor3 = Color3.fromRGB(155, 155, 170)
	espDistTag.Text = "24 studs"
	espDistTag.ZIndex = 7
	espDistTag.Parent = rigBounds

	local espTracerLine = Instance.new("Frame")
	espTracerLine.Name = "Tracer"
	espTracerLine.Size = UDim2.new(0, 2, 0, 108)
	espTracerLine.Position = UDim2.new(0.5, 4, 1, -54)
	espTracerLine.AnchorPoint = Vector2.new(0.5, 0.5)
	espTracerLine.BackgroundColor3 = Color3.fromRGB(0, 210, 140)
	espTracerLine.BorderSizePixel = 0
	espTracerLine.Visible = false
	espTracerLine.ZIndex = 5
	espTracerLine.Parent = espStage

	local function refreshESPPreviewVisuals()
		local st = windowObj.ESPPreviewState
		local showBoxes = st.Boxes == true
		espBoxHolder.Visible = showBoxes
		espBoxHolder.BackgroundColor3 = st.BoxColor or accentColor
		local boxFilled = (st.BoxFilled == true) or (st.BoxFill == true)
		espBoxHolder.BackgroundTransparency = (showBoxes and boxFilled) and 0.84 or 1
		local isCorner = st.BoxStyle == "Corner"
		espBoxInner.Visible = showBoxes and not isCorner
		espBoxOuterStroke.Enabled = showBoxes and not isCorner
		cornerBoxContainer.Visible = showBoxes and isCorner
		espBoxStroke.Color = st.BoxColor or accentColor
		for _, seg in ipairs(cornerSegments) do
			seg.BackgroundColor3 = st.BoxColor or accentColor
		end

		espNameTag.Visible = st.Names == true
		espNameTag.TextColor3 = st.NameColor or Color3.fromRGB(245, 245, 250)

		local showHealth = (st.Health == true) or (st.HealthBar == true)
		espHealthBg.Visible = showHealth
		espHealthFill.BackgroundColor3 = st.HealthColor or Color3.fromRGB(90, 245, 140)
		espHealthText.TextColor3 = st.HealthColor or Color3.fromRGB(90, 245, 140)

		espWeaponTag.Visible = st.Weapon ~= false
		espDistTag.Visible = st.Distance == true
		espDistTag.TextColor3 = st.DistanceColor or Color3.fromRGB(165, 165, 180)
		espDistTag.Position = (st.Weapon ~= false) and UDim2.new(0.5, 0, 1, 20) or UDim2.new(0.5, 0, 1, 6)

		espTracerLine.Visible = st.Tracers == true
		espTracerLine.BackgroundColor3 = st.TracerColor or accentColor

		bonesHolder.Visible = st.Bones == true
		for _, b in ipairs(boneLines) do
			b.BackgroundColor3 = st.BoneColor or Color3.fromRGB(240, 240, 250)
		end

		espHeadDot.Visible = st.HeadDot == true
		espHeadDot.BackgroundColor3 = st.HeadDotColor or accentColor

		local chamsColor = st.ChamsColor or accentColor
		if #chamsModelParts > 0 then
			chamsOverlay.BackgroundTransparency = 1
			for _, item in ipairs(chamsModelParts) do
				if item.Part and item.Part.Parent then
					if st.Chams then
						item.Part.Color = chamsColor
						item.Part.Material = Enum.Material.Neon
						item.Part.Transparency = 0.25
					else
						item.Part.Color = item.OrigColor
						item.Part.Material = item.OrigMaterial
						item.Part.Transparency = item.OrigTrans
					end
				end
			end
		else
			chamsOverlay.BackgroundColor3 = chamsColor
			chamsOverlay.BackgroundTransparency = st.Chams and 0.65 or 1
			avatarFallbackImg.ImageColor3 = st.Chams and chamsColor or Color3.fromRGB(255, 255, 255)
		end
	end

	function windowObj:UpdateESPPreview(patch)
		if type(patch) == "table" then
			for k, v in pairs(patch) do
				if k == "BoxFill" then
					windowObj.ESPPreviewState.BoxFilled = v
				elseif k == "HealthBar" then
					windowObj.ESPPreviewState.Health = v
				end
				windowObj.ESPPreviewState[k] = v
			end
		end
		refreshESPPreviewVisuals()
	end

	local btnPreviewPage = Instance.new("Frame")
	btnPreviewPage.Name = "ButtonPreviewPage"
	btnPreviewPage.Size = UDim2.new(1, 0, 1, -44)
	btnPreviewPage.Position = UDim2.new(0, 0, 0, 44)
	btnPreviewPage.BackgroundTransparency = 1
	btnPreviewPage.Visible = false
	btnPreviewPage.Parent = previewFrame

	local btnStage = Instance.new("Frame")
	btnStage.Name = "ButtonStage"
	btnStage.Size = UDim2.new(1, -24, 0, 196)
	btnStage.Position = UDim2.new(0, 12, 0, 12)
	btnStage.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
	btnStage.BorderSizePixel = 0
	btnStage.ClipsDescendants = true
	btnStage.Parent = btnPreviewPage

	local btnStageCorner = Instance.new("UICorner")
	btnStageCorner.CornerRadius = UDim.new(0, 10)
	btnStageCorner.Parent = btnStage

	local btnStageStroke = Instance.new("UIStroke")
	btnStageStroke.Color = Color3.fromRGB(28, 28, 34)
	btnStageStroke.Thickness = 1
	btnStageStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	btnStageStroke.Parent = btnStage

	for g = 1, 4 do
		local hLine = Instance.new("Frame")
		hLine.Size = UDim2.new(1, 0, 0, 1)
		hLine.Position = UDim2.new(0, 0, g / 5, 0)
		hLine.BackgroundColor3 = Color3.fromRGB(21, 21, 25)
		hLine.BorderSizePixel = 0
		hLine.Parent = btnStage

		local vLine = Instance.new("Frame")
		vLine.Size = UDim2.new(0, 1, 1, 0)
		vLine.Position = UDim2.new(g / 5, 0, 0, 0)
		vLine.BackgroundColor3 = Color3.fromRGB(21, 21, 25)
		vLine.BorderSizePixel = 0
		vLine.Parent = btnStage
	end

	local stageTopLabel = Instance.new("TextLabel")
	stageTopLabel.Size = UDim2.new(1, -20, 0, 16)
	stageTopLabel.Position = UDim2.new(0, 10, 0, 8)
	stageTopLabel.BackgroundTransparency = 1
	stageTopLabel.Font = Enum.Font.GothamMedium
	stageTopLabel.TextSize = 10
	stageTopLabel.TextColor3 = Color3.fromRGB(120, 120, 132)
	stageTopLabel.TextXAlignment = Enum.TextXAlignment.Left
	stageTopLabel.Text = ""
	stageTopLabel.Visible = false
	stageTopLabel.ZIndex = 3
	stageTopLabel.Parent = btnStage

	local stageDimLabel = Instance.new("TextLabel")
	stageDimLabel.Size = UDim2.new(1, -20, 0, 16)
	stageDimLabel.Position = UDim2.new(0, 10, 1, -22)
	stageDimLabel.BackgroundTransparency = 1
	stageDimLabel.Font = Enum.Font.GothamBold
	stageDimLabel.TextSize = 10
	stageDimLabel.TextColor3 = Color3.fromRGB(145, 145, 158)
	stageDimLabel.TextXAlignment = Enum.TextXAlignment.Left
	stageDimLabel.Text = "116 × 42 px  •  Radius: 10px"
	stageDimLabel.ZIndex = 3
	stageDimLabel.Parent = btnStage

	local pvButtonCard = Instance.new("TextButton")
	pvButtonCard.Name = "PreviewButtonWidget"
	pvButtonCard.Size = UDim2.new(0, 116, 0, 42)
	pvButtonCard.Position = UDim2.new(0.5, 0, 0.5, 2)
	pvButtonCard.AnchorPoint = Vector2.new(0.5, 0.5)
	pvButtonCard.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	pvButtonCard.BackgroundTransparency = 0.12
	pvButtonCard.BorderSizePixel = 0
	pvButtonCard.AutoButtonColor = false
	pvButtonCard.Text = ""
	pvButtonCard.ZIndex = 4
	pvButtonCard.Parent = btnStage

	local pvBtnCorner = Instance.new("UICorner")
	pvBtnCorner.CornerRadius = UDim.new(0, 10)
	pvBtnCorner.Parent = pvButtonCard

	local pvBtnStroke = Instance.new("UIStroke")
	pvBtnStroke.Color = accentColor
	pvBtnStroke.Thickness = 1.5
	pvBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	pvBtnStroke.Parent = pvButtonCard

	local pvBtnDot = Instance.new("Frame")
	pvBtnDot.Name = "Dot"
	pvBtnDot.Size = UDim2.new(0, 8, 0, 8)
	pvBtnDot.Position = UDim2.new(0, 12, 0.5, 0)
	pvBtnDot.AnchorPoint = Vector2.new(0, 0.5)
	pvBtnDot.BackgroundColor3 = accentColor
	pvBtnDot.BorderSizePixel = 0
	pvBtnDot.ZIndex = 5
	pvBtnDot.Parent = pvButtonCard

	local pvBtnDotCorner = Instance.new("UICorner")
	pvBtnDotCorner.CornerRadius = UDim.new(1, 0)
	pvBtnDotCorner.Parent = pvBtnDot

	local pvBtnTitle = Instance.new("TextLabel")
	pvBtnTitle.Name = "Label"
	pvBtnTitle.Size = UDim2.new(1, -34, 0, 16)
	pvBtnTitle.Position = UDim2.new(0, 26, 0.5, -6)
	pvBtnTitle.AnchorPoint = Vector2.new(0, 0.5)
	pvBtnTitle.BackgroundTransparency = 1
	pvBtnTitle.Font = Enum.Font.GothamBold
	pvBtnTitle.TextSize = 12
	pvBtnTitle.TextColor3 = Color3.fromRGB(245, 245, 250)
	pvBtnTitle.TextXAlignment = Enum.TextXAlignment.Left
	pvBtnTitle.TextTruncate = Enum.TextTruncate.AtEnd
	pvBtnTitle.Text = "Aim Assist"
	pvBtnTitle.ZIndex = 5
	pvBtnTitle.Parent = pvButtonCard

	local pvBtnStateSub = Instance.new("TextLabel")
	pvBtnStateSub.Name = "SubState"
	pvBtnStateSub.Size = UDim2.new(1, -34, 0, 12)
	pvBtnStateSub.Position = UDim2.new(0, 26, 0.5, 8)
	pvBtnStateSub.AnchorPoint = Vector2.new(0, 0.5)
	pvBtnStateSub.BackgroundTransparency = 1
	pvBtnStateSub.Font = Enum.Font.GothamMedium
	pvBtnStateSub.TextSize = 9
	pvBtnStateSub.TextColor3 = accentColor
	pvBtnStateSub.TextXAlignment = Enum.TextXAlignment.Left
	pvBtnStateSub.Text = "ENABLED"
	pvBtnStateSub.ZIndex = 5
	pvBtnStateSub.Parent = pvButtonCard

	local pvResizeIndicator = Instance.new("TextLabel")
	pvResizeIndicator.Name = "ResizeCorner"
	pvResizeIndicator.Size = UDim2.new(0, 12, 0, 12)
	pvResizeIndicator.Position = UDim2.new(1, -2, 1, -2)
	pvResizeIndicator.AnchorPoint = Vector2.new(1, 1)
	pvResizeIndicator.BackgroundTransparency = 1
	pvResizeIndicator.Font = Enum.Font.GothamBold
	pvResizeIndicator.TextSize = 9
	pvResizeIndicator.TextColor3 = Color3.fromRGB(110, 110, 125)
	pvResizeIndicator.Text = "◢"
	pvResizeIndicator.ZIndex = 6
	pvResizeIndicator.Parent = pvButtonCard

	local activeBtnsCard = Instance.new("Frame")
	activeBtnsCard.Name = "ActiveButtonsCard"
	activeBtnsCard.Size = UDim2.new(1, -24, 1, -232)
	activeBtnsCard.Position = UDim2.new(0, 12, 0, 218)
	activeBtnsCard.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
	activeBtnsCard.BorderSizePixel = 0
	activeBtnsCard.Parent = btnPreviewPage

	local abcCorner = Instance.new("UICorner")
	abcCorner.CornerRadius = UDim.new(0, 10)
	abcCorner.Parent = activeBtnsCard

	local abcStroke = Instance.new("UIStroke")
	abcStroke.Color = Color3.fromRGB(28, 28, 34)
	abcStroke.Thickness = 1
	abcStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	abcStroke.Parent = activeBtnsCard

	local abcHeader = Instance.new("TextLabel")
	abcHeader.Name = "Header"
	abcHeader.Size = UDim2.new(1, -20, 0, 24)
	abcHeader.Position = UDim2.new(0, 12, 0, 6)
	abcHeader.BackgroundTransparency = 1
	abcHeader.Font = Enum.Font.GothamBold
	abcHeader.TextSize = 11
	abcHeader.TextColor3 = Color3.fromRGB(170, 170, 182)
	abcHeader.TextXAlignment = Enum.TextXAlignment.Left
	abcHeader.Text = "Buttons (0)"
	abcHeader.Parent = activeBtnsCard

	local abcList = Instance.new("ScrollingFrame")
	abcList.Name = "List"
	abcList.Size = UDim2.new(1, -16, 1, -36)
	abcList.Position = UDim2.new(0, 8, 0, 30)
	abcList.BackgroundTransparency = 1
	abcList.BorderSizePixel = 0
	abcList.ScrollBarThickness = 2
	abcList.ScrollBarImageColor3 = Color3.fromRGB(42, 42, 50)
	abcList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	abcList.CanvasSize = UDim2.new(0, 0, 0, 0)
	abcList.Parent = activeBtnsCard

	local abcLayout = Instance.new("UIListLayout")
	abcLayout.SortOrder = Enum.SortOrder.LayoutOrder
	abcLayout.Padding = UDim.new(0, 6)
	abcLayout.Parent = abcList

	local function applyStyleToButtonWidget(widget, dot, titleLbl, subLbl, stroke, corner, cfg, isActive)
		local w = math.clamp(tonumber(cfg.Width) or 116, 48, 220)
		local h = math.clamp(tonumber(cfg.Height) or 42, 28, 110)
		local rad = math.clamp(tonumber(cfg.CornerRadius) or 10, 2, 30)
		local opac = math.clamp(tonumber(cfg.Opacity) or 88, 10, 100)
		local style = cfg.Style or "Standard"
		local displayLabel = (cfg.Label and cfg.Label ~= "") and cfg.Label or cfg.Feature or "Toggle"

		widget.Size = UDim2.new(0, w, 0, h)
		corner.CornerRadius = UDim.new(0, rad)
		widget.BackgroundTransparency = 1 - (opac / 100)

		if style == "Outline" then
			widget.BackgroundColor3 = Color3.fromRGB(14, 14, 17)
			stroke.Thickness = 1.6
			stroke.Color = isActive and accentColor or Color3.fromRGB(48, 48, 56)
		elseif style == "Minimal" then
			widget.BackgroundColor3 = isActive and accentColor:Lerp(Color3.fromRGB(20, 20, 24), 0.78) or Color3.fromRGB(18, 18, 22)
			stroke.Thickness = 1
			stroke.Color = isActive and accentColor or Color3.fromRGB(32, 32, 38)
		else
			widget.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
			stroke.Thickness = 1.4
			stroke.Color = isActive and accentColor or Color3.fromRGB(38, 38, 45)
		end

		titleLbl.Text = displayLabel
		local textScale = math.clamp(math.floor(math.min(w / 9.2, h * 0.32)), 10, 15)
		titleLbl.TextSize = textScale

		if style == "Compact" or h < 36 or w < 86 then
			dot.Visible = false
			subLbl.Visible = false
			titleLbl.Size = UDim2.new(1, -12, 1, 0)
			titleLbl.Position = UDim2.new(0, 6, 0.5, 0)
			titleLbl.TextXAlignment = Enum.TextXAlignment.Center
			titleLbl.TextColor3 = isActive and accentColor or Color3.fromRGB(215, 215, 225)
		else
			dot.Visible = true
			dot.BackgroundColor3 = isActive and accentColor or Color3.fromRGB(72, 72, 82)
			subLbl.Visible = true
			subLbl.Text = isActive and "ON" or "OFF"
			subLbl.TextColor3 = isActive and accentColor or Color3.fromRGB(115, 115, 128)
			titleLbl.Size = UDim2.new(1, -32, 0, 15)
			titleLbl.Position = UDim2.new(0, 26, 0.5, -6)
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.TextColor3 = isActive and Color3.fromRGB(245, 245, 250) or Color3.fromRGB(190, 190, 202)
		end
	end

	local function refreshButtonPreviewWidget()
		local draft = windowObj.ButtonDraft
		local targetMod = windowObj.ModuleByName[draft.Feature]
		local isActive = targetMod and targetMod.Enabled or draft.PreviewActive
		applyStyleToButtonWidget(
			pvButtonCard,
			pvBtnDot,
			pvBtnTitle,
			pvBtnStateSub,
			pvBtnStroke,
			pvBtnCorner,
			draft,
			isActive
		)
		stageDimLabel.Text = string.format("%dx%d", draft.Width, draft.Height)
	end

	pvButtonCard.MouseButton1Click:Connect(function()
		local draft = windowObj.ButtonDraft
		local targetMod = windowObj.ModuleByName[draft.Feature]
		if targetMod then
			targetMod:Set(not targetMod.Enabled)
		else
			draft.PreviewActive = not draft.PreviewActive
		end
		refreshButtonPreviewWidget()
	end)

	local function isPreviewAllowedForActiveTab()
		if not windowObj.PreviewEnabled or not main.Visible or not windowObj.ActiveTab then
			return false
		end
		local lowerTab = string.lower(tostring(windowObj.ActiveTab.Name or ""))
		return lowerTab == "visuals" or lowerTab == "visual" or lowerTab == "settings"
	end

	function windowObj:SetPreviewMode(mode)
		mode = (mode == "Buttons") and "Buttons" or "ESP"
		windowObj.PreviewMode = mode
		if mode == "ESP" then
			espPreviewPage.Visible = true
			btnPreviewPage.Visible = false
			refreshESPPreviewVisuals()
		else
			espPreviewPage.Visible = false
			btnPreviewPage.Visible = true
			refreshButtonPreviewWidget()
		end
	end

	function windowObj:SetPreviewVisible(state)
		windowObj.PreviewEnabled = state == true
		previewFrame.Visible = isPreviewAllowedForActiveTab()
	end

	local function syncPreviewWindowDock()
		if not previewFrame or not main then return end
		local mainPos = main.AbsolutePosition
		local mainSize = main.AbsoluteSize
		local vpSize = screenGui.AbsoluteSize
		local s = mainScale and mainScale.Scale or 1
		local actualPvWidth = previewWidth * s
		local xPos = mainPos.X + mainSize.X + (8 * s)
		if vpSize.X > 0 and (xPos + actualPvWidth > vpSize.X - 4) then
			xPos = math.max(4, mainPos.X - actualPvWidth - (8 * s))
		end
		previewFrame.Position = UDim2.fromOffset(xPos, mainPos.Y)
		previewFrame.Size = UDim2.new(0, previewWidth, 0, 550)
		if pvScale then
			pvScale.Scale = s
		end
	end

	main:GetPropertyChangedSignal("AbsolutePosition"):Connect(syncPreviewWindowDock)
	main:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncPreviewWindowDock)
	task.defer(syncPreviewWindowDock)

	local floatingButtonsContainer = Instance.new("Folder")
	floatingButtonsContainer.Name = "FloatingToggleButtons"
	floatingButtonsContainer.Parent = screenGui

	local function refreshActiveButtonsListUI()
		for _, child in ipairs(abcList:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end
		local count = 0
		for featName, entry in pairs(windowObj.FloatingButtons) do
			count = count + 1
			local row = Instance.new("Frame")
			row.Name = "Row_" .. featName
			row.Size = UDim2.new(1, -4, 0, 32)
			row.BackgroundColor3 = Color3.fromRGB(21, 21, 25)
			row.BorderSizePixel = 0
			row.Parent = abcList

			local rc = Instance.new("UICorner")
			rc.CornerRadius = UDim.new(0, 6)
			rc.Parent = row

			local rst = Instance.new("UIStroke")
			rst.Color = Color3.fromRGB(30, 30, 36)
			rst.Thickness = 1
			rst.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			rst.Parent = row

			local selectRowBtn = Instance.new("TextButton")
			selectRowBtn.Size = UDim2.new(1, -34, 1, 0)
			selectRowBtn.Position = UDim2.new(0, 8, 0, 0)
			selectRowBtn.BackgroundTransparency = 1
			selectRowBtn.Font = Enum.Font.GothamMedium
			selectRowBtn.TextSize = 11
			selectRowBtn.TextColor3 = Color3.fromRGB(225, 225, 235)
			selectRowBtn.TextXAlignment = Enum.TextXAlignment.Left
			selectRowBtn.TextTruncate = Enum.TextTruncate.AtEnd
			selectRowBtn.Text = string.format("%s (%d×%d)", featName, entry.Config.Width, entry.Config.Height)
			selectRowBtn.Parent = row

			selectRowBtn.MouseButton1Click:Connect(function()
				if windowObj.OnSelectFloatingButtonInManager then
					pcall(windowObj.OnSelectFloatingButtonInManager, featName, entry.Config)
				end
			end)

			local delBtn = Instance.new("TextButton")
			delBtn.Size = UDim2.new(0, 22, 0, 22)
			delBtn.Position = UDim2.new(1, -6, 0.5, 0)
			delBtn.AnchorPoint = Vector2.new(1, 0.5)
			delBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
			delBtn.BorderSizePixel = 0
			delBtn.AutoButtonColor = false
			delBtn.Font = Enum.Font.GothamBold
			delBtn.TextSize = 12
			delBtn.TextColor3 = Color3.fromRGB(200, 90, 105)
			delBtn.Text = "×"
			delBtn.Parent = row

			local dc = Instance.new("UICorner")
			dc.CornerRadius = UDim.new(0, 5)
			dc.Parent = delBtn

			delBtn.MouseButton1Click:Connect(function()
				windowObj:RemoveFloatingButton(featName)
			end)
		end
		abcHeader.Text = string.format("Buttons (%d)", count)
	end

	function windowObj:RemoveFloatingButton(featureName)
		local existing = windowObj.FloatingButtons[featureName]
		if existing then
			if existing.Button and existing.Button.Parent then
				existing.Button:Destroy()
			end
			windowObj.FloatingButtons[featureName] = nil
			refreshActiveButtonsListUI()
			return true
		end
		return false
	end

	function windowObj:ClearFloatingButtons()
		local toRemove = {}
		for featName, _ in pairs(windowObj.FloatingButtons) do
			table.insert(toRemove, featName)
		end
		for _, featName in ipairs(toRemove) do
			windowObj:RemoveFloatingButton(featName)
		end
	end

	function windowObj:SetButtonsLocked(locked)
		windowObj.ButtonsLocked = locked == true
		for _, entry in pairs(windowObj.FloatingButtons) do
			if entry.ResizeGrip then
				entry.ResizeGrip.Visible = not windowObj.ButtonsLocked
			end
		end
	end

	function windowObj:CreateFloatingButton(btnConfig)
		btnConfig = btnConfig or {}
		local featureName = btnConfig.Feature or windowObj.ButtonDraft.Feature or "Aim Assist"
		local existing = windowObj.FloatingButtons[featureName]

		local posX = tonumber(btnConfig.PosX)
		local posY = tonumber(btnConfig.PosY)
		local scaleX = tonumber(btnConfig.ScaleX) or 0
		local scaleY = tonumber(btnConfig.ScaleY) or 0

		local cfg = {
			Feature = featureName,
			Label = btnConfig.Label ~= nil and btnConfig.Label or (existing and existing.Config.Label) or "",
			Style = btnConfig.Style or (existing and existing.Config.Style) or "Standard",
			Width = math.clamp(tonumber(btnConfig.Width) or (existing and existing.Config.Width) or 116, 48, 220),
			Height = math.clamp(tonumber(btnConfig.Height) or (existing and existing.Config.Height) or 42, 28, 110),
			CornerRadius = math.clamp(tonumber(btnConfig.CornerRadius) or (existing and existing.Config.CornerRadius) or 10, 2, 30),
			Opacity = math.clamp(tonumber(btnConfig.Opacity) or (existing and existing.Config.Opacity) or 88, 10, 100),
			PosX = posX,
			PosY = posY,
			ScaleX = scaleX,
			ScaleY = scaleY
		}

		if existing and existing.Button and existing.Button.Parent then
			existing.Config = cfg
			if cfg.PosX and cfg.PosY then
				existing.Button.Position = UDim2.new(cfg.ScaleX or 0, cfg.PosX, cfg.ScaleY or 0, cfg.PosY)
			end
			existing.Refresh()
			refreshActiveButtonsListUI()
			return existing
		end

		local count = 0
		for _ in pairs(windowObj.FloatingButtons) do count = count + 1 end
		local defaultX = posX or (90 + (count % 3) * 130)
		local defaultY = posY or (140 + math.floor(count / 3) * 56)

		local fBtn = Instance.new("TextButton")
		fBtn.Name = "FloatingToggle_" .. featureName
		fBtn.Size = UDim2.fromOffset(cfg.Width, cfg.Height)
		fBtn.Position = UDim2.new(scaleX, defaultX, scaleY, defaultY)
		fBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
		fBtn.BorderSizePixel = 0
		fBtn.AutoButtonColor = false
		fBtn.Text = ""
		fBtn.ZIndex = 950
		fBtn.Parent = floatingButtonsContainer

		local fCorner = Instance.new("UICorner")
		fCorner.CornerRadius = UDim.new(0, cfg.CornerRadius)
		fCorner.Parent = fBtn

		local fStroke = Instance.new("UIStroke")
		fStroke.Color = Color3.fromRGB(38, 38, 45)
		fStroke.Thickness = 1.4
		fStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		fStroke.Parent = fBtn

		local fDot = Instance.new("Frame")
		fDot.Name = "Dot"
		fDot.Size = UDim2.new(0, 8, 0, 8)
		fDot.Position = UDim2.new(0, 12, 0.5, 0)
		fDot.AnchorPoint = Vector2.new(0, 0.5)
		fDot.BackgroundColor3 = Color3.fromRGB(72, 72, 82)
		fDot.BorderSizePixel = 0
		fDot.ZIndex = 951
		fDot.Parent = fBtn

		local fDotCorner = Instance.new("UICorner")
		fDotCorner.CornerRadius = UDim.new(1, 0)
		fDotCorner.Parent = fDot

		local fTitle = Instance.new("TextLabel")
		fTitle.Name = "Label"
		fTitle.Size = UDim2.new(1, -34, 0, 15)
		fTitle.Position = UDim2.new(0, 26, 0.5, -6)
		fTitle.AnchorPoint = Vector2.new(0, 0.5)
		fTitle.BackgroundTransparency = 1
		fTitle.Font = Enum.Font.GothamBold
		fTitle.TextSize = 12
		fTitle.TextColor3 = Color3.fromRGB(240, 240, 246)
		fTitle.TextXAlignment = Enum.TextXAlignment.Left
		fTitle.TextTruncate = Enum.TextTruncate.AtEnd
		fTitle.Text = featureName
		fTitle.ZIndex = 951
		fTitle.Parent = fBtn

		local fSub = Instance.new("TextLabel")
		fSub.Name = "SubState"
		fSub.Size = UDim2.new(1, -34, 0, 12)
		fSub.Position = UDim2.new(0, 26, 0.5, 8)
		fSub.AnchorPoint = Vector2.new(0, 0.5)
		fSub.BackgroundTransparency = 1
		fSub.Font = Enum.Font.GothamMedium
		fSub.TextSize = 9
		fSub.TextColor3 = Color3.fromRGB(115, 115, 128)
		fSub.TextXAlignment = Enum.TextXAlignment.Left
		fSub.Text = "OFF"
		fSub.ZIndex = 951
		fSub.Parent = fBtn

		local resizeGrip = Instance.new("TextButton")
		resizeGrip.Name = "ResizeGrip"
		resizeGrip.Size = UDim2.new(0, 14, 0, 14)
		resizeGrip.Position = UDim2.new(1, -1, 1, -1)
		resizeGrip.AnchorPoint = Vector2.new(1, 1)
		resizeGrip.BackgroundTransparency = 1
		resizeGrip.AutoButtonColor = false
		resizeGrip.Font = Enum.Font.GothamBold
		resizeGrip.TextSize = 9
		resizeGrip.TextColor3 = Color3.fromRGB(115, 115, 130)
		resizeGrip.Text = "◢"
		resizeGrip.Visible = not windowObj.ButtonsLocked
		resizeGrip.ZIndex = 953
		resizeGrip.Parent = fBtn

		local entry = {
			Feature = featureName,
			Button = fBtn,
			ResizeGrip = resizeGrip,
			Config = cfg
		}

		local function refreshEntryVisuals()
			local targetMod = windowObj.ModuleByName[featureName]
			local isActive = targetMod and targetMod.Enabled or false
			applyStyleToButtonWidget(fBtn, fDot, fTitle, fSub, fStroke, fCorner, entry.Config, isActive)
		end

		entry.Refresh = refreshEntryVisuals
		refreshEntryVisuals()

		local draggingBtn = false
		local dragInput = nil
		local dragStart = nil
		local startOffset = nil
		local movedDist = 0

		local resizingBtn = false
		local resizeStart = nil
		local startSize = nil

		resizeGrip.InputBegan:Connect(function(input)
			if windowObj.ButtonsLocked then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				resizingBtn = true
				dragInput = input
				resizeStart = input.Position
				startSize = Vector2.new(entry.Config.Width, entry.Config.Height)
				tween(resizeGrip, { TextColor3 = accentColor }, 0.12)
			end
		end)

		fBtn.InputBegan:Connect(function(input)
			if resizingBtn then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				draggingBtn = true
				dragInput = input
				dragStart = input.Position
				startOffset = Vector2.new(fBtn.Position.X.Offset, fBtn.Position.Y.Offset)
				movedDist = 0
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				if resizingBtn and not windowObj.ButtonsLocked then
					local delta = input.Position - resizeStart
					entry.Config.Width = math.clamp(math.floor(startSize.X + delta.X + 0.5), 48, 220)
					entry.Config.Height = math.clamp(math.floor(startSize.Y + delta.Y + 0.5), 28, 110)
					refreshEntryVisuals()
					if windowObj.ButtonDraft.Feature == featureName then
						windowObj.ButtonDraft.Width = entry.Config.Width
						windowObj.ButtonDraft.Height = entry.Config.Height
						refreshButtonPreviewWidget()
						if windowObj.OnSyncButtonManagerSliders then
							pcall(windowObj.OnSyncButtonManagerSliders, entry.Config.Width, entry.Config.Height)
						end
					end
				elseif draggingBtn and not resizingBtn then
					local delta = input.Position - dragStart
					local d = math.sqrt(delta.X * delta.X + delta.Y * delta.Y)
					if d > movedDist then movedDist = d end
					if not windowObj.ButtonsLocked and movedDist >= 5 then
						local nx = startOffset.X + delta.X
						local ny = startOffset.Y + delta.Y
						fBtn.Position = UDim2.new(fBtn.Position.X.Scale, nx, fBtn.Position.Y.Scale, ny)
						entry.Config.PosX = nx
						entry.Config.PosY = ny
						entry.Config.ScaleX = fBtn.Position.X.Scale
						entry.Config.ScaleY = fBtn.Position.Y.Scale
					end
				end
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				if resizingBtn then
					resizingBtn = false
					tween(resizeGrip, { TextColor3 = Color3.fromRGB(115, 115, 130) }, 0.15)
					refreshActiveButtonsListUI()
				elseif draggingBtn then
					draggingBtn = false
					if movedDist < 6 then
						local targetMod = windowObj.ModuleByName[featureName]
						if targetMod then
							targetMod:Set(not targetMod.Enabled)
						end
						refreshEntryVisuals()
						if windowObj.ButtonDraft.Feature == featureName then
							refreshButtonPreviewWidget()
						end
					end
				end
			end
		end)

		windowObj.FloatingButtons[featureName] = entry
		refreshActiveButtonsListUI()
		return entry
	end

	registerThemeRefresher(function(col)
		refreshESPPreviewVisuals()
		refreshButtonPreviewWidget()
		for _, entry in pairs(windowObj.FloatingButtons) do
			if entry.Refresh then
				pcall(entry.Refresh)
			end
		end
	end)

	refreshESPPreviewVisuals()
	refreshButtonPreviewWidget()

	task.spawn(function()
		local fpsCount = 0
		local lastUpdate = tick()
		local currentFps = 60
		local hbConn
		hbConn = RunService.RenderStepped:Connect(function()
			if not screenGui or not screenGui.Parent then
				if hbConn then hbConn:Disconnect() end
				return
			end
			fpsCount = fpsCount + 1
			local now = tick()
			if now - lastUpdate >= 0.5 then
				currentFps = math.floor(fpsCount / (now - lastUpdate) + 0.5)
				fpsCount = 0
				lastUpdate = now
				if wmFrame.Visible then
					local ping = 0
					pcall(function()
						local stats = game:GetService("Stats")
						ping = math.floor(stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
					end)
					local text = string.format("%s  |  %d FPS  |  %d ms", formatBrandRichText(titleText, accentColor), currentFps, ping)
					wmLabel.Text = text
					wmFrame.Size = UDim2.new(0, math.max(210, wmLabel.TextBounds.X + 30), 0, 30)
				end
			end
		end)
	end)

	local isToggling = false
	function windowObj:Toggle(state)
		if state == nil then
			state = not main.Visible
		end
		if isToggling then return end
		isToggling = true
		task.delay(0.25, function()
			isToggling = false
		end)
		if state then
			updateResponsiveScale()
			main.Visible = true
			if isPreviewAllowedForActiveTab() then
				previewFrame.Visible = true
				previewFrame.BackgroundTransparency = 0.5
				tween(previewFrame, { BackgroundTransparency = 0 }, 0.2)
			else
				previewFrame.Visible = false
			end
			mainScale.Scale = currentBaseScale * 0.95
			if pvScale then pvScale.Scale = currentBaseScale * 0.95 end
			main.BackgroundTransparency = 0.5
			if mbStroke then
				tween(mbStroke, { Color = accentColor }, 0.2)
			end
			local anim = tween(main, {
				BackgroundTransparency = 0
			}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			tween(mainScale, {
				Scale = currentBaseScale
			}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			if pvScale then
				tween(pvScale, {
					Scale = currentBaseScale
				}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			end
			anim.Completed:Connect(function()
				syncPreviewWindowDock()
				isToggling = false
			end)
		else
			if mbStroke then
				tween(mbStroke, { Color = Color3.fromRGB(42, 42, 48) }, 0.2)
			end
			if previewFrame.Visible then
				tween(previewFrame, { BackgroundTransparency = 0.8 }, 0.15)
			end
			local anim = tween(main, {
				BackgroundTransparency = 0.8
			}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			tween(mainScale, {
				Scale = currentBaseScale * 0.95
			}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			if pvScale then
				tween(pvScale, {
					Scale = currentBaseScale * 0.95
				}, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			end
			anim.Completed:Connect(function()
				main.Visible = false
				previewFrame.Visible = false
				isToggling = false
			end)
		end
	end

	UserInputService.InputBegan:Connect(function(input, processed)
		local function matchesBindKey(inp, target)
			if not target or target == Enum.KeyCode.Unknown then return false end
			if typeof(target) == "EnumItem" then
				if target.EnumType == Enum.KeyCode then
					return inp.KeyCode == target
				elseif target.EnumType == Enum.UserInputType then
					return inp.UserInputType == target
				end
			end
			return false
		end
		if not processed and matchesBindKey(input, toggleKey) then
			windowObj:Toggle()
		end
	end)

	if showMobileButton then
		mobileBtn = Instance.new("Frame")
		mobileBtn.Name = "MobileToggleButton"
		mobileBtn.Size = UDim2.new(0, 48, 0, 48)
		mobileBtn.Position = config.MobileButtonPosition or UDim2.new(0, 48, 0.5, 0)
		mobileBtn.AnchorPoint = Vector2.new(0.5, 0.5)
		mobileBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
		mobileBtn.BorderSizePixel = 0
		mobileBtn.Active = true
		mobileBtn.ZIndex = 1000
		mobileBtn.Parent = screenGui

		local mbCorner = Instance.new("UICorner")
		mbCorner.CornerRadius = UDim.new(0, 14)
		mbCorner.Parent = mobileBtn

		mbStroke = Instance.new("UIStroke")
		mbStroke.Color = accentColor
		mbStroke.Thickness = 1.5
		mbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		mbStroke.Parent = mobileBtn

		mbIcon = Instance.new("ImageLabel")
		mbIcon.Name = "Icon"
		mbIcon.Size = UDim2.new(0, 26, 0, 26)
		mbIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
		mbIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		mbIcon.BackgroundTransparency = 1
		mbIcon.Image = config.HourglassImage or Icons.hourglass
		mbIcon.ImageColor3 = accentColor
		mbIcon.ScaleType = Enum.ScaleType.Fit
		mbIcon.ZIndex = 1001
		mbIcon.Parent = mobileBtn

		local mbDragging = false
		local mbDragInput = nil
		local mbDragStart = nil
		local mbStartPos = nil
		local mbTotalDist = 0

		mobileBtn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				mbDragging = true
				mbDragInput = input
				mbDragStart = input.Position
				mbStartPos = mobileBtn.Position
				mbTotalDist = 0
				tween(mobileBtn, { BackgroundColor3 = Color3.fromRGB(28, 28, 34) }, 0.15)
				tween(mbStroke, { Color = accentColor }, 0.15)
			end
		end)

		mobileBtn.MouseEnter:Connect(function()
			tween(mbStroke, { Color = accentColor }, 0.2)
			tween(mobileBtn, { BackgroundColor3 = Color3.fromRGB(26, 26, 32) }, 0.2)
		end)

		mobileBtn.MouseLeave:Connect(function()
			if not mbDragging then
				local strokeCol = main.Visible and accentColor or Color3.fromRGB(42, 42, 48)
				tween(mbStroke, { Color = strokeCol }, 0.2)
				tween(mobileBtn, { BackgroundColor3 = Color3.fromRGB(22, 22, 26) }, 0.2)
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if mbDragging then
				if input == mbDragInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
					local delta = input.Position - mbDragStart
					local dist = math.sqrt(delta.X * delta.X + delta.Y * delta.Y)
					if dist > mbTotalDist then
						mbTotalDist = dist
					end
					mobileBtn.Position = UDim2.new(
						mbStartPos.X.Scale,
						mbStartPos.X.Offset + delta.X,
						mbStartPos.Y.Scale,
						mbStartPos.Y.Offset + delta.Y
					)
				end
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if mbDragging and (input == mbDragInput or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				mbDragging = false
				mbDragInput = nil
				local strokeCol = main.Visible and accentColor or Color3.fromRGB(42, 42, 48)
				tween(mbStroke, { Color = strokeCol }, 0.2)
				tween(mobileBtn, { BackgroundColor3 = Color3.fromRGB(22, 22, 26) }, 0.2)
				if mbTotalDist < 14 then
					local origSize = UDim2.new(0, 48, 0, 48)
					tween(mobileBtn, { Size = UDim2.new(0, 42, 0, 42) }, 0.08)
					task.delay(0.08, function()
						if mobileBtn and mobileBtn.Parent then
							tween(mobileBtn, { Size = origSize }, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
						end
					end)
					windowObj:Toggle()
				end
			end
		end)

		windowObj.MobileButton = mobileBtn
	end

	function windowObj:Notify(notifConfig)
		notifConfig = notifConfig or {}
		local nTitle = tostring(notifConfig.Title or titleText)
		local nDesc = tostring(notifConfig.Description or "")
		local duration = tonumber(notifConfig.Duration) or 3

		local TextService = game:GetService("TextService")
		local maxTextWidth = 246
		local descBounds = Vector2.new(180, 16)
		pcall(function()
			descBounds = TextService:GetTextSize(nDesc, 12, Enum.Font.Gotham, Vector2.new(maxTextWidth, 200))
		end)
		local titleBounds = Vector2.new(100, 16)
		pcall(function()
			titleBounds = TextService:GetTextSize(nTitle, 13, Enum.Font.GothamBold, Vector2.new(maxTextWidth, 40))
		end)

		local contentWidth = math.clamp(math.max(descBounds.X, titleBounds.X) + 46, 230, 300)
		local descHeight = math.max(16, descBounds.Y)
		local cardHeight = math.max(58, 38 + descHeight + 10)

		local slot = Instance.new("Frame")
		slot.Name = "ToastSlot"
		slot.Size = UDim2.new(0, contentWidth, 0, cardHeight)
		slot.BackgroundTransparency = 1
		slot.BorderSizePixel = 0
		slot.Parent = notificationContainer

		local toast = Instance.new("Frame")
		toast.Name = "Toast"
		toast.Size = UDim2.new(1, 0, 1, 0)
		toast.Position = UDim2.new(1, 40, 0, 0)
		toast.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
		toast.BorderSizePixel = 0
		toast.BackgroundTransparency = 0.2
		toast.ClipsDescendants = true
		toast.Parent = slot

		local toastCorner = Instance.new("UICorner")
		toastCorner.CornerRadius = UDim.new(0, 10)
		toastCorner.Parent = toast

		local toastStroke = Instance.new("UIStroke")
		toastStroke.Color = Color3.fromRGB(36, 36, 44)
		toastStroke.Thickness = 1
		toastStroke.Transparency = 0.2
		toastStroke.Parent = toast

		local accentBar = Instance.new("Frame")
		accentBar.Name = "Accent"
		accentBar.Size = UDim2.new(0, 3, 1, -20)
		accentBar.Position = UDim2.new(0, 10, 0.5, -1)
		accentBar.AnchorPoint = Vector2.new(0, 0.5)
		accentBar.BackgroundColor3 = accentColor
		accentBar.BorderSizePixel = 0
		accentBar.Parent = toast

		local barCorner = Instance.new("UICorner")
		barCorner.CornerRadius = UDim.new(1, 0)
		barCorner.Parent = accentBar

		local tTitle = Instance.new("TextLabel")
		tTitle.Name = "Title"
		tTitle.Size = UDim2.new(1, -36, 0, 18)
		tTitle.Position = UDim2.new(0, 22, 0, 9)
		tTitle.BackgroundTransparency = 1
		tTitle.Font = Enum.Font.GothamBold
		tTitle.TextSize = 13
		tTitle.RichText = true
		tTitle.TextColor3 = Color3.fromRGB(240, 240, 246)
		tTitle.TextXAlignment = Enum.TextXAlignment.Left
		tTitle.TextYAlignment = Enum.TextYAlignment.Center
		if string.lower(nTitle) == string.lower(titleText) then
			tTitle.Text = formatBrandRichText(nTitle, accentColor)
		else
			tTitle.Text = nTitle
		end
		tTitle.Parent = toast

		local tDesc = Instance.new("TextLabel")
		tDesc.Name = "Desc"
		tDesc.Size = UDim2.new(1, -36, 0, descHeight)
		tDesc.Position = UDim2.new(0, 22, 0, 29)
		tDesc.BackgroundTransparency = 1
		tDesc.Font = Enum.Font.Gotham
		tDesc.TextSize = 12
		tDesc.TextColor3 = Color3.fromRGB(165, 165, 178)
		tDesc.TextXAlignment = Enum.TextXAlignment.Left
		tDesc.TextYAlignment = Enum.TextYAlignment.Top
		tDesc.TextWrapped = true
		tDesc.Text = nDesc
		tDesc.Parent = toast

		local progressTrack = Instance.new("Frame")
		progressTrack.Name = "ProgressTrack"
		progressTrack.Size = UDim2.new(1, -20, 0, 2)
		progressTrack.Position = UDim2.new(0, 10, 1, -4)
		progressTrack.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
		progressTrack.BorderSizePixel = 0
		progressTrack.Parent = toast

		local ptCorner = Instance.new("UICorner")
		ptCorner.CornerRadius = UDim.new(1, 0)
		ptCorner.Parent = progressTrack

		local progressFill = Instance.new("Frame")
		progressFill.Name = "Fill"
		progressFill.Size = UDim2.new(1, 0, 1, 0)
		progressFill.BackgroundColor3 = accentColor
		progressFill.BorderSizePixel = 0
		progressFill.Parent = progressTrack

		local pfCorner = Instance.new("UICorner")
		pfCorner.CornerRadius = UDim.new(1, 0)
		pfCorner.Parent = progressFill

		tween(toast, {
			Position = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 0
		}, 0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		tween(toastStroke, { Transparency = 0 }, 0.25)
		tween(progressFill, { Size = UDim2.new(0, 0, 1, 0) }, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

		task.delay(duration, function()
			if slot and slot.Parent then
				tween(toast, {
					Position = UDim2.new(1, 40, 0, 0),
					BackgroundTransparency = 1
				}, 0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
				tween(toastStroke, { Transparency = 1 }, 0.2)
				tween(accentBar, { BackgroundTransparency = 1 }, 0.2)
				tween(tTitle, { TextTransparency = 1 }, 0.2)
				tween(tDesc, { TextTransparency = 1 }, 0.2)
				tween(progressTrack, { BackgroundTransparency = 1 }, 0.2)
				tween(progressFill, { BackgroundTransparency = 1 }, 0.2)
				task.delay(0.18, function()
					if slot and slot.Parent then
						local collapse = tween(slot, { Size = UDim2.new(0, contentWidth, 0, 0) }, 0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						collapse.Completed:Connect(function()
							if slot and slot.Parent then
								slot:Destroy()
							end
						end)
					end
				end)
			end
		end)
	end

	function windowObj:GetConfigData()
		local floatingData = {}
		for featName, entry in pairs(windowObj.FloatingButtons) do
			local btn = entry.Button
			local pos = btn and btn.Position or UDim2.fromOffset(100, 140)
			local cfg = entry.Config or {}
			local curX = (cfg.PosX ~= nil and cfg.PosX) or pos.X.Offset
			local curY = (cfg.PosY ~= nil and cfg.PosY) or pos.Y.Offset
			local curScaleX = (cfg.ScaleX ~= nil and cfg.ScaleX) or pos.X.Scale or 0
			local curScaleY = (cfg.ScaleY ~= nil and cfg.ScaleY) or pos.Y.Scale or 0
			table.insert(floatingData, {
				Feature = featName,
				Label = cfg.Label or (entry.Label and entry.Label.Text) or "",
				Style = cfg.Style or "Standard",
				Width = cfg.Width or (btn and btn.Size.X.Offset) or 116,
				Height = cfg.Height or (btn and btn.Size.Y.Offset) or 42,
				CornerRadius = cfg.CornerRadius or 10,
				Opacity = cfg.Opacity or 88,
				PosX = curX,
				PosY = curY,
				ScaleX = curScaleX,
				ScaleY = curScaleY
			})
		end

		local mainPos = main and {
			ScaleX = main.Position.X.Scale,
			OffsetX = main.Position.X.Offset,
			ScaleY = main.Position.Y.Scale,
			OffsetY = main.Position.Y.Offset
		} or nil

		local mbPos = mobileBtn and {
			ScaleX = mobileBtn.Position.X.Scale,
			OffsetX = mobileBtn.Position.X.Offset,
			ScaleY = mobileBtn.Position.Y.Scale,
			OffsetY = mobileBtn.Position.Y.Offset
		} or nil

		local kbPos = kbFrame and {
			ScaleX = kbFrame.Position.X.Scale,
			OffsetX = kbFrame.Position.X.Offset,
			ScaleY = kbFrame.Position.Y.Scale,
			OffsetY = kbFrame.Position.Y.Offset
		} or nil

		local pvPos = pvFrame and {
			ScaleX = pvFrame.Position.X.Scale,
			OffsetX = pvFrame.Position.X.Offset,
			ScaleY = pvFrame.Position.Y.Scale,
			OffsetY = pvFrame.Position.Y.Offset
		} or nil

		local keybindsData = {}
		for flag, elem in pairs(windowObj.ConfigElements) do
			if elem.Type == "Keybind" then
				local ok, val = pcall(elem.Serialize)
				if ok and val ~= nil then
					keybindsData[flag] = val
				end
			end
		end
		for _, kbEntry in ipairs(windowObj.Keybinds) do
			local k = kbEntry.GetKey()
			if typeof(k) == "EnumItem" then
				keybindsData[kbEntry.Name] = k.EnumType.Name .. "." .. k.Name
			end
		end

		local data = {
			AccentColor = colorToHex(accentColor),
			ToggleKey = toggleKey.Name,
			ButtonsLocked = windowObj.ButtonsLocked,
			FloatingButtons = floatingData,
			Buttons = floatingData,
			Keybinds = keybindsData,
			UIPositions = {
				Main = mainPos,
				MobileButton = mbPos,
				KeybindHUD = kbPos,
				Preview = pvPos
			},
			Elements = {}
		}
		for flag, elem in pairs(windowObj.ConfigElements) do
			local ok, val = pcall(elem.Serialize)
			if ok and val ~= nil then
				data.Elements[flag] = val
			end
		end
		return data
	end

	function windowObj:ApplyConfigData(data)
		if type(data) ~= "table" then return false end
		if data.AccentColor then
			local col = hexToColor(data.AccentColor)
			if col then
				windowObj:SetAccentColor(col)
			end
		end
		if data.ToggleKey and Enum.KeyCode[data.ToggleKey] then
			windowObj:SetToggleKey(Enum.KeyCode[data.ToggleKey])
		end

		if type(data.UIPositions) == "table" then
			if data.UIPositions.Main and main then
				local p = data.UIPositions.Main
				main.Position = UDim2.new(p.ScaleX or 0.5, p.OffsetX or 0, p.ScaleY or 0.5, p.OffsetY or 0)
			end
			if data.UIPositions.MobileButton and mobileBtn then
				local p = data.UIPositions.MobileButton
				mobileBtn.Position = UDim2.new(p.ScaleX or 0, p.OffsetX or 48, p.ScaleY or 0.5, p.OffsetY or 0)
			end
			if data.UIPositions.KeybindHUD and kbFrame then
				local p = data.UIPositions.KeybindHUD
				kbFrame.Position = UDim2.new(p.ScaleX or 0, p.OffsetX or 18, p.ScaleY or 0.42, p.OffsetY or 0)
			end
			if data.UIPositions.Preview and pvFrame then
				local p = data.UIPositions.Preview
				pvFrame.Position = UDim2.new(p.ScaleX or 0.5, p.OffsetX or 0, p.ScaleY or 0.5, p.OffsetY or 0)
			end
		end

		if type(data.Elements) == "table" then
			for flag, val in pairs(data.Elements) do
				local elem = windowObj.ConfigElements[flag]
				if elem and elem.Deserialize then
					pcall(elem.Deserialize, val)
				end
			end
		end

		if type(data.Keybinds) == "table" then
			for keyIdentifier, val in pairs(data.Keybinds) do
				local elem = windowObj.ConfigElements[keyIdentifier]
				if elem and elem.Type == "Keybind" and elem.Deserialize then
					pcall(elem.Deserialize, val)
				else
					for flag, el in pairs(windowObj.ConfigElements) do
						if el.Type == "Keybind" and flag:find(keyIdentifier, 1, true) and el.Deserialize then
							pcall(el.Deserialize, val)
						end
					end
				end
			end
		end

		local btns = (type(data.Buttons) == "table" and data.Buttons) or (type(data.FloatingButtons) == "table" and data.FloatingButtons)
		if btns then
			windowObj:ClearFloatingButtons()
			for _, bcfg in ipairs(btns) do
				if type(bcfg) == "table" and bcfg.Feature then
					windowObj:CreateFloatingButton(bcfg)
				end
			end
		end

		if type(data.ButtonsLocked) == "boolean" then
			windowObj:SetButtonsLocked(data.ButtonsLocked)
		end
		refreshKeybindHUD()
		return true
	end

	function windowObj:ExportConfigJSON()
		local ok, json = pcall(function()
			return HttpService:JSONEncode(windowObj:GetConfigData())
		end)
		return ok and json or "{}"
	end

	function windowObj:ImportConfigJSON(jsonStr)
		local ok, decoded = pcall(function()
			return HttpService:JSONDecode(jsonStr)
		end)
		if not ok or type(decoded) ~= "table" then
			return false
		end
		return windowObj:ApplyConfigData(decoded)
	end

	function windowObj:SaveConfig(name)
		name = tostring(name or ""):gsub("[^%w%-%_ ]", ""):gsub("^%s+", ""):gsub("%s+$", "")
		if name == "" then
			return false, "Invalid config name"
		end
		local json = windowObj:ExportConfigJSON()
		windowObj.MemoryConfigs[name] = json
		if FS.hasFS then
			pcall(function()
				if not FS.isfolder("future.club") then FS.makefolder("future.club") end
				if not FS.isfolder(configFolder) then FS.makefolder(configFolder) end
				FS.writefile(configFolder .. "/" .. name .. ".json", json)
			end)
		end
		return true, name
	end

	local function forceResetPlayer()
		local lp = Players.LocalPlayer or LocalPlayer
		if lp and lp.Character then
			local hum = lp.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				hum.Health = 0
			end
			pcall(function() lp.Character:BreakJoints() end)
		end
	end

	function windowObj:LoadConfig(name)
		name = tostring(name or ""):gsub("%.json$", "")
		if name == "" then
			return false, "No config selected"
		end
		local json = nil
		if FS.hasFS then
			local path = configFolder .. "/" .. name .. ".json"
			local ok, exists = pcall(FS.isfile, path)
			if ok and exists then
				pcall(function()
					json = FS.readfile(path)
				end)
			end
		end
		if not json or json == "" then
			json = windowObj.MemoryConfigs[name]
		end
		if not json or json == "" then
			return false, "Config not found"
		end
		forceResetPlayer()
		local ok = windowObj:ImportConfigJSON(json)
		return ok, ok and name or "Failed to parse config"
	end

	function windowObj:DeleteConfig(name)
		name = tostring(name or ""):gsub("%.json$", "")
		if name == "" then return false end
		windowObj.MemoryConfigs[name] = nil
		if FS.hasFS then
			local path = configFolder .. "/" .. name .. ".json"
			pcall(function()
				if FS.isfile(path) then
					FS.delfile(path)
				end
			end)
		end
		return true
	end

	function windowObj:GetConfigs()
		local seen = {}
		local list = {}
		if FS.hasFS then
			pcall(function()
				if FS.isfolder(configFolder) then
					for _, file in ipairs(FS.listfiles(configFolder)) do
						local fileName = tostring(file):match("([^/\\]+)%.json$")
						if fileName and not seen[fileName] then
							seen[fileName] = true
							table.insert(list, fileName)
						end
					end
				end
			end)
		end
		for name, _ in pairs(windowObj.MemoryConfigs) do
			if not seen[name] then
				seen[name] = true
				table.insert(list, name)
			end
		end
		table.sort(list)
		if #list == 0 then
			windowObj:SaveConfig("default")
			table.insert(list, "default")
		end
		return list
	end

	local function filterModules(tabObj, query)
		if not tabObj then return end
		query = string.lower(tostring(query or ""))
		for _, module in ipairs(tabObj.Modules) do
			if query == "" then
				module.Card.Visible = true
			else
				local nameMatch = string.find(string.lower(tostring(module.Name or "")), query, 1, true) ~= nil
				local descMatch = string.find(string.lower(tostring(module.Description or "")), query, 1, true) ~= nil
				module.Card.Visible = nameMatch or descMatch
			end
		end
	end

	searchInput:GetPropertyChangedSignal("Text"):Connect(function()
		windowObj.SearchQuery = searchInput.Text
		if windowObj.ActiveTab then
			filterModules(windowObj.ActiveTab, windowObj.SearchQuery)
		end
	end)

	function windowObj:CreateTab(tabConfig)
		tabConfig = tabConfig or {}
		local tabName = tabConfig.Name or "Tab"
		local tabIcon = resolveIcon(tabConfig.Icon or tabName)

		local tabButton = Instance.new("TextButton")
		tabButton.Name = "Tab_" .. tabName
		tabButton.Size = UDim2.new(1, 0, 0, 36)
		tabButton.BackgroundColor3 = accentColor
		tabButton.BackgroundTransparency = 1
		tabButton.BorderSizePixel = 0
		tabButton.AutoButtonColor = false
		tabButton.Text = ""
		tabButton.ZIndex = 2
		tabButton.Parent = tabsHolder

		local tabCorner = Instance.new("UICorner")
		tabCorner.CornerRadius = UDim.new(0, 18)
		tabCorner.Parent = tabButton

		local iconImg = Instance.new("ImageLabel")
		iconImg.Name = "Icon"
		iconImg.Size = UDim2.new(0, 16, 0, 16)
		iconImg.Position = UDim2.new(0, 14, 0.5, 0)
		iconImg.AnchorPoint = Vector2.new(0, 0.5)
		iconImg.BackgroundTransparency = 1
		iconImg.Image = tabIcon
		iconImg.ImageColor3 = Color3.fromRGB(125, 125, 135)
		iconImg.ZIndex = 2
		iconImg.Parent = tabButton

		local nameLbl = Instance.new("TextLabel")
		nameLbl.Name = "Label"
		nameLbl.Size = UDim2.new(1, -44, 1, 0)
		nameLbl.Position = UDim2.new(0, 38, 0, 0)
		nameLbl.BackgroundTransparency = 1
		nameLbl.Font = Enum.Font.GothamBold
		nameLbl.TextSize = 13
		nameLbl.TextColor3 = Color3.fromRGB(125, 125, 135)
		nameLbl.TextXAlignment = Enum.TextXAlignment.Left
		nameLbl.Text = tabName
		nameLbl.ZIndex = 2
		nameLbl.Parent = tabButton

		local scrollPage = Instance.new("ScrollingFrame")
		scrollPage.Name = "Page_" .. tabName
		scrollPage.Size = UDim2.new(1, 0, 1, 0)
		scrollPage.Position = UDim2.new(0, 0, 0, 0)
		scrollPage.BackgroundTransparency = 1
		scrollPage.BorderSizePixel = 0
		scrollPage.ScrollBarThickness = 6
		scrollPage.ScrollBarImageColor3 = Color3.fromRGB(55, 55, 65)
		scrollPage.ScrollingDirection = Enum.ScrollingDirection.Y
		scrollPage.ElasticBehavior = Enum.ElasticBehavior.Always
		scrollPage.ScrollingEnabled = true
		scrollPage.Active = true
		scrollPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scrollPage.CanvasSize = UDim2.new(0, 0, 0, 0)
		scrollPage.Visible = false
		scrollPage.ClipsDescendants = true
		scrollPage.Parent = contentArea

		local pageLayout = Instance.new("UIListLayout")
		pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
		pageLayout.Padding = UDim.new(0, 10)
		pageLayout.Parent = scrollPage

		local function syncCanvas()
			local contentH = pageLayout.AbsoluteContentSize.Y
			scrollPage.CanvasSize = UDim2.new(0, 0, 0, contentH + 50)
		end
		pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(syncCanvas)

		local touchStartY = nil
		local canvasStartY = 0
		local isTouchDragging = false

		local function registerTouchScroll(gui)
			if not gui or not gui:IsA("GuiObject") then return end
			gui.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.Touch then
					touchStartY = input.Position.Y
					canvasStartY = scrollPage.CanvasPosition.Y
					isTouchDragging = false
				end
			end)
		end

		UserInputService.InputChanged:Connect(function(input)
			if touchStartY and input.UserInputType == Enum.UserInputType.Touch and scrollPage.Visible then
				local delta = touchStartY - input.Position.Y
				if math.abs(delta) > 5 then
					isTouchDragging = true
					local maxScroll = math.max(0, scrollPage.AbsoluteCanvasSize.Y - scrollPage.AbsoluteWindowSize.Y)
					scrollPage.CanvasPosition = Vector2.new(0, math.clamp(canvasStartY + delta, 0, maxScroll))
				end
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
				touchStartY = nil
				task.delay(0.08, function()
					isTouchDragging = false
				end)
			end
		end)

		registerTouchScroll(scrollPage)

		local pagePadding = Instance.new("UIPadding")
		pagePadding.PaddingTop = UDim.new(0, 4)
		pagePadding.PaddingBottom = UDim.new(0, 14)
		pagePadding.PaddingLeft = UDim.new(0, 2)
		pagePadding.PaddingRight = UDim.new(0, 14)
		pagePadding.Parent = scrollPage

		local tabObj = {
			Name = tabName,
			Button = tabButton,
			Page = scrollPage,
			Icon = iconImg,
			Label = nameLbl,
			Modules = {}
		}

		registerThemeRefresher(function(col)
			tabButton.BackgroundColor3 = col
		end)

		local function selectTab()
			for _, other in ipairs(windowObj.Tabs) do
				if other == tabObj then
					tween(other.Button, { BackgroundTransparency = 0 }, 0.18)
					tween(other.Icon, { ImageColor3 = Color3.fromRGB(18, 18, 22) }, 0.18)
					tween(other.Label, { TextColor3 = Color3.fromRGB(18, 18, 22) }, 0.18)
					other.Page.Visible = true
				else
					tween(other.Button, { BackgroundTransparency = 1 }, 0.18)
					tween(other.Icon, { ImageColor3 = Color3.fromRGB(125, 125, 135) }, 0.18)
					tween(other.Label, { TextColor3 = Color3.fromRGB(125, 125, 135) }, 0.18)
					other.Page.Visible = false
				end
			end
			windowObj.ActiveTab = tabObj
			filterModules(tabObj, windowObj.SearchQuery)
			local lowerTab = string.lower(tabName)
			if lowerTab == "visuals" or lowerTab == "visual" then
				windowObj:SetPreviewMode("ESP")
				previewFrame.Visible = isPreviewAllowedForActiveTab()
			elseif lowerTab == "settings" then
				windowObj:SetPreviewMode("Buttons")
				previewFrame.Visible = isPreviewAllowedForActiveTab()
			else
				previewFrame.Visible = false
			end
		end

		tabButton.MouseButton1Click:Connect(selectTab)

		tabButton.MouseEnter:Connect(function()
			if windowObj.ActiveTab ~= tabObj then
				tween(tabButton, { BackgroundTransparency = 0.88 }, 0.15)
				tween(iconImg, { ImageColor3 = Color3.fromRGB(185, 185, 195) }, 0.15)
				tween(nameLbl, { TextColor3 = Color3.fromRGB(185, 185, 195) }, 0.15)
			end
		end)

		tabButton.MouseLeave:Connect(function()
			if windowObj.ActiveTab ~= tabObj then
				tween(tabButton, { BackgroundTransparency = 1 }, 0.15)
				tween(iconImg, { ImageColor3 = Color3.fromRGB(125, 125, 135) }, 0.15)
				tween(nameLbl, { TextColor3 = Color3.fromRGB(125, 125, 135) }, 0.15)
			end
		end)

		function tabObj:CreateModule(modConfig)
			modConfig = modConfig or {}
			local modName = modConfig.Name or "Module"
			local modDesc = modConfig.Description or ""
			local modEnabled = modConfig.Default or false
			local modFlag = modConfig.Flag or ("Module_" .. tabName .. "_" .. modName)
			local modCallback = modConfig.Callback or function() end

			local hasDesc = modDesc ~= ""
			local headerH = hasDesc and 58 or 44

			local card = Instance.new("Frame")
			card.Name = "Module_" .. modName
			card.Size = UDim2.new(1, 0, 0, headerH)
			card.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
			card.BorderSizePixel = 0
			card.ClipsDescendants = true
			card.Parent = scrollPage

			local cardCorner = Instance.new("UICorner")
			cardCorner.CornerRadius = UDim.new(0, 10)
			cardCorner.Parent = card

			local cardStroke = Instance.new("UIStroke")
			cardStroke.Color = Color3.fromRGB(33, 33, 38)
			cardStroke.Thickness = 1
			cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			cardStroke.Parent = card

			local header = Instance.new("Frame")
			header.Name = "Header"
			header.Size = UDim2.new(1, 0, 0, headerH)
			header.BackgroundTransparency = 1
			header.Parent = card

			local title = Instance.new("TextLabel")
			title.Name = "Title"
			title.Size = UDim2.new(1, -120, 0, 18)
			title.Position = hasDesc and UDim2.new(0, 16, 0, 10) or UDim2.new(0, 16, 0.5, -9)
			title.BackgroundTransparency = 1
			title.Font = Enum.Font.GothamBold
			title.TextSize = 13
			title.TextColor3 = modEnabled and accentColor or Color3.fromRGB(245, 245, 250)
			title.TextXAlignment = Enum.TextXAlignment.Left
			title.Text = modName
			title.Parent = header

			if hasDesc then
				local desc = Instance.new("TextLabel")
				desc.Name = "Description"
				desc.Size = UDim2.new(1, -120, 0, 14)
				desc.Position = UDim2.new(0, 16, 0, 30)
				desc.BackgroundTransparency = 1
				desc.Font = Enum.Font.Gotham
				desc.TextSize = 11
				desc.TextColor3 = Color3.fromRGB(115, 115, 125)
				desc.TextXAlignment = Enum.TextXAlignment.Left
				desc.Text = modDesc
				desc.Parent = header
			end

			local controlsHolder = Instance.new("Frame")
			controlsHolder.Name = "Controls"
			controlsHolder.Size = UDim2.new(0, 80, 0, 24)
			controlsHolder.Position = UDim2.new(1, -16, 0.5, 0)
			controlsHolder.AnchorPoint = Vector2.new(1, 0.5)
			controlsHolder.BackgroundTransparency = 1
			controlsHolder.Parent = header

			local gearBtn = Instance.new("ImageButton")
			gearBtn.Name = "Gear"
			gearBtn.Size = UDim2.new(0, 20, 0, 20)
			gearBtn.Position = UDim2.new(0, 0, 0.5, 0)
			gearBtn.AnchorPoint = Vector2.new(0, 0.5)
			gearBtn.BackgroundTransparency = 1
			gearBtn.Image = Icons.gear
			gearBtn.ImageColor3 = Color3.fromRGB(110, 110, 120)
			gearBtn.Parent = controlsHolder

			local toggleTrack = Instance.new("TextButton")
			toggleTrack.Name = "Toggle"
			toggleTrack.Size = UDim2.new(0, 44, 0, 24)
			toggleTrack.Position = UDim2.new(0, 34, 0.5, 0)
			toggleTrack.AnchorPoint = Vector2.new(0, 0.5)
			toggleTrack.BackgroundColor3 = modEnabled and accentColor or Color3.fromRGB(38, 38, 44)
			toggleTrack.BorderSizePixel = 0
			toggleTrack.AutoButtonColor = false
			toggleTrack.Text = ""
			toggleTrack.Parent = controlsHolder

			local trackCorner = Instance.new("UICorner")
			trackCorner.CornerRadius = UDim.new(1, 0)
			trackCorner.Parent = toggleTrack

			local knob = Instance.new("Frame")
			knob.Name = "Knob"
			knob.Size = UDim2.new(0, 18, 0, 18)
			knob.Position = modEnabled and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
			knob.AnchorPoint = Vector2.new(0, 0.5)
			knob.BackgroundColor3 = modEnabled and Color3.fromRGB(22, 22, 26) or Color3.fromRGB(68, 68, 76)
			knob.BorderSizePixel = 0
			knob.Parent = toggleTrack

			local knobCorner = Instance.new("UICorner")
			knobCorner.CornerRadius = UDim.new(1, 0)
			knobCorner.Parent = knob

			local settingsTray = Instance.new("Frame")
			settingsTray.Name = "SettingsTray"
			settingsTray.Position = UDim2.new(0, 0, 0, headerH)
			settingsTray.Size = UDim2.new(1, 0, 0, 0)
			settingsTray.BackgroundTransparency = 1
			settingsTray.Visible = false
			settingsTray.Parent = card

			local trayDivider = Instance.new("Frame")
			trayDivider.Name = "Divider"
			trayDivider.Size = UDim2.new(1, -32, 0, 1)
			trayDivider.Position = UDim2.new(0, 16, 0, 0)
			trayDivider.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
			trayDivider.BorderSizePixel = 0
			trayDivider.Parent = settingsTray

			local settingsList = Instance.new("Frame")
			settingsList.Name = "List"
			settingsList.Size = UDim2.new(1, 0, 0, 0)
			settingsList.Position = UDim2.new(0, 0, 0, 8)
			settingsList.BackgroundTransparency = 1
			settingsList.Parent = settingsTray

			local settingsLayout = Instance.new("UIListLayout")
			settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
			settingsLayout.Padding = UDim.new(0, 8)
			settingsLayout.Parent = settingsList

			local settingsPadding = Instance.new("UIPadding")
			settingsPadding.PaddingLeft = UDim.new(0, 18)
			settingsPadding.PaddingRight = UDim.new(0, 18)
			settingsPadding.PaddingTop = UDim.new(0, 4)
			settingsPadding.PaddingBottom = UDim.new(0, 14)
			settingsPadding.Parent = settingsList

			registerTouchScroll(card)
			registerTouchScroll(header)
			registerTouchScroll(settingsTray)
			registerTouchScroll(settingsList)

			local settingsOpen = false
			local moduleObj = {
				Name = modName,
				Description = modDesc,
				Enabled = modEnabled,
				Flag = modFlag,
				Card = card,
				Elements = {}
			}

			windowObj.Flags[modFlag] = modEnabled

			local function updateTraySize()
				if settingsOpen then
					local totalContentHeight = settingsLayout.AbsoluteContentSize.Y + 20
					settingsTray.Size = UDim2.new(1, 0, 0, totalContentHeight)
					settingsList.Size = UDim2.new(1, 0, 0, settingsLayout.AbsoluteContentSize.Y + 12)
					tween(card, { Size = UDim2.new(1, 0, 0, headerH + totalContentHeight) }, 0.18)
				else
					local closeAnim = tween(card, { Size = UDim2.new(1, 0, 0, headerH) }, 0.18)
					closeAnim.Completed:Connect(function()
						if not settingsOpen then
							settingsTray.Visible = false
						end
						syncCanvas()
					end)
				end
				task.defer(syncCanvas)
				task.delay(0.2, syncCanvas)
			end

			settingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if settingsOpen then
					updateTraySize()
				end
				syncCanvas()
			end)

			local function setToggleState(state, suppressCallback)
				state = state == true
				moduleObj.Enabled = state
				windowObj.Flags[modFlag] = state
				if state then
					tween(toggleTrack, { BackgroundColor3 = accentColor }, 0.2)
					tween(knob, {
						Position = UDim2.new(1, -21, 0.5, 0),
						BackgroundColor3 = Color3.fromRGB(22, 22, 26)
					}, 0.2)
					tween(title, { TextColor3 = accentColor }, 0.2)
				else
					tween(toggleTrack, { BackgroundColor3 = Color3.fromRGB(38, 38, 44) }, 0.2)
					tween(knob, {
						Position = UDim2.new(0, 3, 0.5, 0),
						BackgroundColor3 = Color3.fromRGB(68, 68, 76)
					}, 0.2)
					tween(title, { TextColor3 = Color3.fromRGB(245, 245, 250) }, 0.2)
				end
				refreshKeybindHUD()
				if windowObj.FloatingButtons[modName] and windowObj.FloatingButtons[modName].Refresh then
					pcall(windowObj.FloatingButtons[modName].Refresh)
				end
				if windowObj.ButtonDraft and windowObj.ButtonDraft.Feature == modName then
					pcall(refreshButtonPreviewWidget)
				end
				if not suppressCallback then
					task.spawn(function()
						pcall(modCallback, state)
					end)
				end
			end

			registerThemeRefresher(function(col)
				if moduleObj.Enabled then
					toggleTrack.BackgroundColor3 = col
					title.TextColor3 = col
				end
				if settingsOpen then
					gearBtn.ImageColor3 = col
				end
			end)

			windowObj.ConfigElements[modFlag] = {
				Type = "Module",
				Serialize = function()
					return moduleObj.Enabled
				end,
				Deserialize = function(val)
					if type(val) == "boolean" then
						setToggleState(val, false)
					end
				end
			}

			toggleTrack.MouseButton1Click:Connect(function()
				if isTouchDragging then return end
				setToggleState(not moduleObj.Enabled)
			end)

			gearBtn.MouseButton1Click:Connect(function()
				if isTouchDragging then return end
				settingsOpen = not settingsOpen
				if settingsOpen then
					settingsTray.Visible = true
					tween(gearBtn, { Rotation = 90, ImageColor3 = accentColor }, 0.2)
					updateTraySize()
				else
					tween(gearBtn, { Rotation = 0, ImageColor3 = Color3.fromRGB(110, 110, 120) }, 0.2)
					updateTraySize()
				end
			end)

			gearBtn.MouseEnter:Connect(function()
				if not settingsOpen then
					tween(gearBtn, { ImageColor3 = Color3.fromRGB(190, 190, 200) }, 0.15)
				end
			end)

			gearBtn.MouseLeave:Connect(function()
				if not settingsOpen then
					tween(gearBtn, { ImageColor3 = Color3.fromRGB(110, 110, 120) }, 0.15)
				end
			end)

			function moduleObj:Set(state)
				setToggleState(state)
			end

			function moduleObj:Get()
				return moduleObj.Enabled
			end

			function moduleObj:CreateSlider(sliderConfig)
				sliderConfig = sliderConfig or {}
				local sName = sliderConfig.Name or "Slider"
				local min = sliderConfig.Min or 0
				local max = sliderConfig.Max or 100
				local default = sliderConfig.Default or min
				local precision = sliderConfig.Precision or 1
				local unit = sliderConfig.Unit or ""
				local flag = sliderConfig.Flag or (modFlag .. "_" .. sName)
				local callback = sliderConfig.Callback or function() end

				local currentValue = math.clamp(default, min, max)
				windowObj.Flags[flag] = currentValue

				local sFrame = Instance.new("Frame")
				sFrame.Name = "Slider_" .. sName
				sFrame.Size = UDim2.new(1, 0, 0, 42)
				sFrame.BackgroundColor3 = Color3.fromRGB(19, 19, 22)
				sFrame.BorderSizePixel = 0
				sFrame.Parent = settingsList

				local sCorner = Instance.new("UICorner")
				sCorner.CornerRadius = UDim.new(0, 8)
				sCorner.Parent = sFrame

				local sStroke = Instance.new("UIStroke")
				sStroke.Color = Color3.fromRGB(30, 30, 35)
				sStroke.Thickness = 1
				sStroke.Parent = sFrame

				local sLabel = Instance.new("TextLabel")
				sLabel.Name = "Label"
				sLabel.Size = UDim2.new(1, -80, 0, 16)
				sLabel.Position = UDim2.new(0, 12, 0, 7)
				sLabel.BackgroundTransparency = 1
				sLabel.Font = Enum.Font.Gotham
				sLabel.TextSize = 12
				sLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
				sLabel.TextXAlignment = Enum.TextXAlignment.Left
				sLabel.Text = sName
				sLabel.Parent = sFrame

				local sValLabel = Instance.new("TextLabel")
				sValLabel.Name = "Value"
				sValLabel.Size = UDim2.new(0, 70, 0, 16)
				sValLabel.Position = UDim2.new(1, -12, 0, 7)
				sValLabel.AnchorPoint = Vector2.new(1, 0)
				sValLabel.BackgroundTransparency = 1
				sValLabel.Font = Enum.Font.GothamBold
				sValLabel.TextSize = 12
				sValLabel.TextColor3 = accentColor
				sValLabel.TextXAlignment = Enum.TextXAlignment.Right
				sValLabel.Text = tostring(currentValue) .. unit
				sValLabel.Parent = sFrame

				local track = Instance.new("TextButton")
				track.Name = "Track"
				track.Size = UDim2.new(1, -24, 0, 6)
				track.Position = UDim2.new(0, 12, 0, 27)
				track.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
				track.BorderSizePixel = 0
				track.AutoButtonColor = false
				track.Text = ""
				track.Parent = sFrame

				local trackCorner = Instance.new("UICorner")
				trackCorner.CornerRadius = UDim.new(1, 0)
				trackCorner.Parent = track

				local fill = Instance.new("Frame")
				fill.Name = "Fill"
				local initialPercent = (max > min) and math.clamp((currentValue - min) / (max - min), 0, 1) or 0
				fill.Size = UDim2.new(initialPercent, 0, 1, 0)
				fill.BackgroundColor3 = accentColor
				fill.BorderSizePixel = 0
				fill.Parent = track

				local fillCorner = Instance.new("UICorner")
				fillCorner.CornerRadius = UDim.new(1, 0)
				fillCorner.Parent = fill

				local sKnob = Instance.new("Frame")
				sKnob.Name = "Knob"
				sKnob.Size = UDim2.new(0, 12, 0, 12)
				sKnob.Position = UDim2.new(1, 0, 0.5, 0)
				sKnob.AnchorPoint = Vector2.new(0.5, 0.5)
				sKnob.BackgroundColor3 = Color3.fromRGB(250, 250, 255)
				sKnob.BorderSizePixel = 0
				sKnob.Parent = fill

				local sKnobCorner = Instance.new("UICorner")
				sKnobCorner.CornerRadius = UDim.new(1, 0)
				sKnobCorner.Parent = sKnob

				registerThemeRefresher(function(col)
					sValLabel.TextColor3 = col
					fill.BackgroundColor3 = col
				end)

				local dragging = false

				local function applyValue(val, suppress)
					val = tonumber(val) or min

					local step = precision
					local decimals = 0

					if precision >= 1 and (max - min) < precision then
						decimals = math.floor(precision)
						step = 10 ^ (-decimals)
					elseif precision < 1 then
						decimals = math.max(1, math.floor(-math.log10(precision) + 0.5))
						step = precision
					else
						step = precision
						decimals = 0
					end

					if step > 0 then
						val = math.floor(val / step + 0.5) * step
					end

					if decimals > 0 then
						val = tonumber(string.format("%." .. tostring(decimals) .. "f", val)) or val
					end

					val = math.clamp(val, min, max)

					currentValue = val
					windowObj.Flags[flag] = val

					local range = max - min
					local percent = range > 0 and math.clamp((val - min) / range, 0, 1) or 0
					fill.Size = UDim2.new(percent, 0, 1, 0)

					local displayStr
					if decimals > 0 then
						displayStr = string.format("%." .. tostring(decimals) .. "f", val)
					else
						displayStr = tostring(math.floor(val + 0.5))
					end
					sValLabel.Text = displayStr .. unit

					if not suppress then
						task.spawn(function()
							pcall(callback, val)
						end)
					end
				end

				applyValue(currentValue, true)

				windowObj.ConfigElements[flag] = {
					Type = "Slider",
					Serialize = function()
						return currentValue
					end,
					Deserialize = function(val)
						if type(val) == "number" then
							applyValue(val, false)
						end
					end
				}

				local function updateFromInput(input)
					local barSize = track.AbsoluteSize.X
					if barSize <= 0 then return end
					local barPos = track.AbsolutePosition.X
					local mousePos = (input and input.Position and input.Position.X) or UserInputService:GetMouseLocation().X
					if input and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.MouseButton1) then
						mousePos = UserInputService:GetMouseLocation().X
					end
					local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
					local calculated = min + (max - min) * percent
					applyValue(calculated)
				end

				track.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						updateFromInput(input)
					end
				end)

				sFrame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						if input.Position.Y >= track.AbsolutePosition.Y - 8 and input.Position.Y <= track.AbsolutePosition.Y + 14 then
							dragging = true
							updateFromInput(input)
						end
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						updateFromInput(input)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)

				local sliderController = {}
				function sliderController:Set(val)
					applyValue(val)
				end
				function sliderController:Get()
					return currentValue
				end
				return sliderController
			end

			function moduleObj:CreateToggle(subConfig)
				subConfig = subConfig or {}
				local tName = subConfig.Name or "Toggle"
				local tState = subConfig.Default or false
				local flag = subConfig.Flag or (modFlag .. "_" .. tName)
				local tCallback = subConfig.Callback or function() end

				windowObj.Flags[flag] = tState

				local tRow = Instance.new("Frame")
				tRow.Name = "Toggle_" .. tName
				tRow.Size = UDim2.new(1, 0, 0, 34)
				tRow.BackgroundColor3 = Color3.fromRGB(19, 19, 22)
				tRow.BorderSizePixel = 0
				tRow.Parent = settingsList

				local tCorner = Instance.new("UICorner")
				tCorner.CornerRadius = UDim.new(0, 8)
				tCorner.Parent = tRow

				local tStroke = Instance.new("UIStroke")
				tStroke.Color = Color3.fromRGB(30, 30, 35)
				tStroke.Thickness = 1
				tStroke.Parent = tRow

				local tLabel = Instance.new("TextLabel")
				tLabel.Name = "Label"
				tLabel.Size = UDim2.new(1, -60, 1, 0)
				tLabel.Position = UDim2.new(0, 12, 0, 0)
				tLabel.BackgroundTransparency = 1
				tLabel.Font = Enum.Font.Gotham
				tLabel.TextSize = 12
				tLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
				tLabel.TextXAlignment = Enum.TextXAlignment.Left
				tLabel.Text = tName
				tLabel.Parent = tRow

				local subTrack = Instance.new("TextButton")
				subTrack.Name = "SubTrack"
				subTrack.Size = UDim2.new(0, 36, 0, 20)
				subTrack.Position = UDim2.new(1, -12, 0.5, 0)
				subTrack.AnchorPoint = Vector2.new(1, 0.5)
				subTrack.BackgroundColor3 = tState and accentColor or Color3.fromRGB(38, 38, 44)
				subTrack.BorderSizePixel = 0
				subTrack.AutoButtonColor = false
				subTrack.Text = ""
				subTrack.Parent = tRow

				local subCorner = Instance.new("UICorner")
				subCorner.CornerRadius = UDim.new(1, 0)
				subCorner.Parent = subTrack

				local subKnob = Instance.new("Frame")
				subKnob.Name = "SubKnob"
				subKnob.Size = UDim2.new(0, 14, 0, 14)
				subKnob.Position = tState and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
				subKnob.AnchorPoint = Vector2.new(0, 0.5)
				subKnob.BackgroundColor3 = tState and Color3.fromRGB(22, 22, 26) or Color3.fromRGB(68, 68, 76)
				subKnob.BorderSizePixel = 0
				subKnob.Parent = subTrack

				local subKnobCorner = Instance.new("UICorner")
				subKnobCorner.CornerRadius = UDim.new(1, 0)
				subKnobCorner.Parent = subKnob

				registerThemeRefresher(function(col)
					if tState then
						subTrack.BackgroundColor3 = col
					end
				end)

				local function setSub(state, suppress)
					state = state == true
					tState = state
					windowObj.Flags[flag] = state
					if state then
						tween(subTrack, { BackgroundColor3 = accentColor }, 0.2)
						tween(subKnob, {
							Position = UDim2.new(1, -17, 0.5, 0),
							BackgroundColor3 = Color3.fromRGB(22, 22, 26)
						}, 0.2)
					else
						tween(subTrack, { BackgroundColor3 = Color3.fromRGB(38, 38, 44) }, 0.2)
						tween(subKnob, {
							Position = UDim2.new(0, 3, 0.5, 0),
							BackgroundColor3 = Color3.fromRGB(68, 68, 76)
						}, 0.2)
					end
					if not suppress then
						task.spawn(function()
							pcall(tCallback, state)
						end)
					end
				end

				windowObj.ConfigElements[flag] = {
					Type = "Toggle",
					Serialize = function()
						return tState
					end,
					Deserialize = function(val)
						if type(val) == "boolean" then
							setSub(val, false)
						end
					end
				}

				subTrack.MouseButton1Click:Connect(function()
					setSub(not tState)
				end)

				local subController = {}
				function subController:Set(v)
					setSub(v)
				end
				function subController:Get()
					return tState
				end
				return subController
			end

			function moduleObj:CreateDropdown(dropConfig)
				dropConfig = dropConfig or {}
				local dName = dropConfig.Name or "Dropdown"
				local options = dropConfig.Options or {}
				local multi = dropConfig.Multi == true
				local default = dropConfig.Default
				local flag = dropConfig.Flag or (modFlag .. "_" .. dName)
				local callback = dropConfig.Callback or function() end

				local selected = nil
				if multi then
					selected = {}
					if type(default) == "table" then
						for k, v in pairs(default) do
							if type(k) == "number" then
								selected[tostring(v)] = true
							elseif v == true then
								selected[tostring(k)] = true
							end
						end
					elseif type(default) == "string" and default ~= "" then
						selected[default] = true
					end
				else
					selected = default or options[1] or ""
				end

				windowObj.Flags[flag] = selected
				local open = false

				local dContainer = Instance.new("Frame")
				dContainer.Name = "Dropdown_" .. dName
				dContainer.Size = UDim2.new(1, 0, 0, 36)
				dContainer.BackgroundColor3 = Color3.fromRGB(19, 19, 22)
				dContainer.BorderSizePixel = 0
				dContainer.ClipsDescendants = true
				dContainer.Parent = settingsList

				local dCorner = Instance.new("UICorner")
				dCorner.CornerRadius = UDim.new(0, 8)
				dCorner.Parent = dContainer

				local dStroke = Instance.new("UIStroke")
				dStroke.Color = Color3.fromRGB(30, 30, 35)
				dStroke.Thickness = 1
				dStroke.Parent = dContainer

				local dHeader = Instance.new("Frame")
				dHeader.Name = "Header"
				dHeader.Size = UDim2.new(1, 0, 0, 36)
				dHeader.BackgroundTransparency = 1
				dHeader.Parent = dContainer

				local dLabel = Instance.new("TextLabel")
				dLabel.Name = "Label"
				dLabel.Size = UDim2.new(0.48, 0, 1, 0)
				dLabel.Position = UDim2.new(0, 12, 0, 0)
				dLabel.BackgroundTransparency = 1
				dLabel.Font = Enum.Font.Gotham
				dLabel.TextSize = 12
				dLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
				dLabel.TextXAlignment = Enum.TextXAlignment.Left
				dLabel.Text = dName
				dLabel.Parent = dHeader

				local selectorBtn = Instance.new("TextButton")
				selectorBtn.Name = "Selector"
				selectorBtn.Size = UDim2.new(0.48, -12, 0, 26)
				selectorBtn.Position = UDim2.new(1, -12, 0.5, 0)
				selectorBtn.AnchorPoint = Vector2.new(1, 0.5)
				selectorBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 31)
				selectorBtn.BorderSizePixel = 0
				selectorBtn.AutoButtonColor = false
				selectorBtn.Text = ""
				selectorBtn.Parent = dHeader

				local selCorner = Instance.new("UICorner")
				selCorner.CornerRadius = UDim.new(0, 6)
				selCorner.Parent = selectorBtn

				local selStroke = Instance.new("UIStroke")
				selStroke.Color = Color3.fromRGB(36, 36, 42)
				selStroke.Thickness = 1
				selStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				selStroke.Parent = selectorBtn

				local function getDisplayString()
					if not multi then
						return tostring(selected ~= "" and selected or "None")
					end
					local chosen = {}
					for _, opt in ipairs(options) do
						if selected[tostring(opt)] then
							table.insert(chosen, tostring(opt))
						end
					end
					if #chosen == 0 then
						return "None"
					end
					return table.concat(chosen, ", ")
				end

				local selText = Instance.new("TextLabel")
				selText.Name = "Text"
				selText.Size = UDim2.new(1, -28, 1, 0)
				selText.Position = UDim2.new(0, 8, 0, 0)
				selText.BackgroundTransparency = 1
				selText.Font = Enum.Font.GothamMedium
				selText.TextSize = 11
				selText.TextColor3 = Color3.fromRGB(240, 240, 245)
				selText.TextXAlignment = Enum.TextXAlignment.Left
				selText.TextTruncate = Enum.TextTruncate.AtEnd
				selText.Text = getDisplayString()
				selText.Parent = selectorBtn

				local chevron = Instance.new("ImageLabel")
				chevron.Name = "Chevron"
				chevron.Size = UDim2.new(0, 14, 0, 14)
				chevron.Position = UDim2.new(1, -8, 0.5, 0)
				chevron.AnchorPoint = Vector2.new(1, 0.5)
				chevron.BackgroundTransparency = 1
				chevron.Image = Icons.chevron
				chevron.ImageColor3 = Color3.fromRGB(120, 120, 130)
				chevron.Parent = selectorBtn

				local optionsFrame = Instance.new("ScrollingFrame")
				optionsFrame.Name = "Options"
				optionsFrame.Size = UDim2.new(1, -24, 0, 0)
				optionsFrame.Position = UDim2.new(0, 12, 0, 38)
				optionsFrame.BackgroundTransparency = 1
				optionsFrame.BorderSizePixel = 0
				optionsFrame.ScrollBarThickness = 4
				optionsFrame.ScrollBarImageColor3 = Color3.fromRGB(55, 55, 65)
				optionsFrame.ScrollingDirection = Enum.ScrollingDirection.Y
				optionsFrame.ElasticBehavior = Enum.ElasticBehavior.Always
				optionsFrame.Active = true
				optionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
				optionsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
				optionsFrame.Parent = dContainer

				local optLayout = Instance.new("UIListLayout")
				optLayout.SortOrder = Enum.SortOrder.LayoutOrder
				optLayout.Padding = UDim.new(0, 4)
				optLayout.Parent = optionsFrame

				optLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					optionsFrame.CanvasSize = UDim2.new(0, 0, 0, optLayout.AbsoluteContentSize.Y + 8)
				end)

				local function updateDropdownSize()
					if open then
						local listHeight = math.max(1, #options) * 28
						local clampedList = math.min(listHeight, 140)
						optionsFrame.Size = UDim2.new(1, -24, 0, clampedList)
						tween(dContainer, { Size = UDim2.new(1, 0, 0, 44 + clampedList) }, 0.2)
						tween(chevron, { Rotation = 180 }, 0.2)
					else
						tween(dContainer, { Size = UDim2.new(1, 0, 0, 36) }, 0.2)
						tween(chevron, { Rotation = 0 }, 0.2)
					end
					task.delay(0.22, updateTraySize)
				end

				local function isOptSelected(opt)
					if multi then
						return selected[tostring(opt)] == true
					else
						return selected == opt
					end
				end

				local function refreshOptionColors()
					selText.Text = getDisplayString()
					for _, optBtn in ipairs(optionsFrame:GetChildren()) do
						if optBtn:IsA("TextButton") then
							local optVal = optBtn:GetAttribute("OptionValue")
							local active = isOptSelected(optVal)
							optBtn.TextColor3 = active and accentColor or Color3.fromRGB(150, 150, 160)
						end
					end
				end

				registerThemeRefresher(function()
					refreshOptionColors()
				end)

				local function selectOption(val, suppress)
					if multi then
						if type(val) == "table" then
							selected = {}
							for k, v in pairs(val) do
								if type(k) == "number" then
									selected[tostring(v)] = true
								elseif v == true then
									selected[tostring(k)] = true
								end
							end
						else
							local key = tostring(val)
							selected[key] = not selected[key]
						end
					else
						selected = val
					end
					windowObj.Flags[flag] = selected
					refreshOptionColors()
					if not suppress then
						task.spawn(function()
							pcall(callback, selected)
						end)
					end
				end

				local function renderOptions()
					for _, child in ipairs(optionsFrame:GetChildren()) do
						if child:IsA("TextButton") then
							child:Destroy()
						end
					end
					for _, opt in ipairs(options) do
						local optBtn = Instance.new("TextButton")
						optBtn.Name = "Opt_" .. tostring(opt)
						optBtn:SetAttribute("OptionValue", tostring(opt))
						optBtn.Size = UDim2.new(1, 0, 0, 24)
						optBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
						optBtn.BorderSizePixel = 0
						optBtn.Font = Enum.Font.Gotham
						optBtn.TextSize = 11
						optBtn.TextColor3 = isOptSelected(opt) and accentColor or Color3.fromRGB(150, 150, 160)
						optBtn.TextXAlignment = Enum.TextXAlignment.Left
						optBtn.Text = "  " .. tostring(opt)
						optBtn.AutoButtonColor = false
						optBtn.Parent = optionsFrame

						local optCorner = Instance.new("UICorner")
						optCorner.CornerRadius = UDim.new(0, 5)
						optCorner.Parent = optBtn

						optBtn.MouseButton1Click:Connect(function()
							selectOption(opt)
							if not multi then
								open = false
								updateDropdownSize()
							end
						end)

						optBtn.MouseEnter:Connect(function()
							if not isOptSelected(opt) then
								tween(optBtn, { TextColor3 = Color3.fromRGB(230, 230, 235) }, 0.15)
							end
						end)

						optBtn.MouseLeave:Connect(function()
							if not isOptSelected(opt) then
								tween(optBtn, { TextColor3 = Color3.fromRGB(150, 150, 160) }, 0.15)
							end
						end)
					end
				end

				renderOptions()

				windowObj.ConfigElements[flag] = {
					Type = "Dropdown",
					Serialize = function()
						if multi then
							local arr = {}
							for k, v in pairs(selected) do
								if v then table.insert(arr, k) end
							end
							return arr
						end
						return selected
					end,
					Deserialize = function(val)
						selectOption(val, false)
					end
				}

				selectorBtn.MouseButton1Click:Connect(function()
					open = not open
					updateDropdownSize()
				end)

				local dropController = {}
				function dropController:Set(val)
					selectOption(val)
				end
				function dropController:Refresh(newOptions, keepSelection)
					options = newOptions or {}
					if not keepSelection and not multi then
						if not table.find(options, selected) then
							selected = options[1] or ""
						end
					end
					renderOptions()
					refreshOptionColors()
					if open then
						updateDropdownSize()
					end
				end
				function dropController:Get()
					return selected
				end
				return dropController
			end

			function moduleObj:CreateKeybind(keyConfig)
				keyConfig = keyConfig or {}
				local kName = keyConfig.Name or "Keybind"
				local currentKey = keyConfig.Default or Enum.KeyCode.Unknown
				local mode = keyConfig.Mode or "Toggle"
				local bindModule = keyConfig.BindModule
				if bindModule == nil then
					bindModule = true
				end
				local flag = keyConfig.Flag or (modFlag .. "_" .. kName)
				local callback = keyConfig.Callback or function() end

				local function formatKeyText(k)
					if not k or k == Enum.KeyCode.Unknown then return "[ NONE ]" end
					if typeof(k) == "EnumItem" then
						if k.EnumType == Enum.UserInputType then
							if k == Enum.UserInputType.MouseButton1 then return "[ M1 ]"
							elseif k == Enum.UserInputType.MouseButton2 then return "[ M2 ]"
							elseif k == Enum.UserInputType.MouseButton3 then return "[ M3 ]"
							end
							return "[ " .. k.Name .. " ]"
						elseif k.EnumType == Enum.KeyCode then
							local n = k.Name
							if n:sub(1, 6) == "Button" then return "[ " .. n:sub(7) .. " ]" end
							return "[ " .. n .. " ]"
						end
					end
					return "[ NONE ]"
				end

				local function matchesKey(inp, target)
					if not target or target == Enum.KeyCode.Unknown then return false end
					if typeof(target) == "EnumItem" then
						if target.EnumType == Enum.KeyCode then
							return inp.KeyCode == target
						elseif target.EnumType == Enum.UserInputType then
							return inp.UserInputType == target
						end
					end
					return false
				end

				windowObj.Flags[flag] = currentKey
				local listening = false
				local listenStartTime = 0

				local kRow = Instance.new("Frame")
				kRow.Name = "Keybind_" .. kName
				kRow.Size = UDim2.new(1, 0, 0, 34)
				kRow.BackgroundColor3 = Color3.fromRGB(19, 19, 22)
				kRow.BorderSizePixel = 0
				kRow.Parent = settingsList

				local kCorner = Instance.new("UICorner")
				kCorner.CornerRadius = UDim.new(0, 8)
				kCorner.Parent = kRow

				local kStroke = Instance.new("UIStroke")
				kStroke.Color = Color3.fromRGB(30, 30, 35)
				kStroke.Thickness = 1
				kStroke.Parent = kRow

				local kLabel = Instance.new("TextLabel")
				kLabel.Name = "Label"
				kLabel.Size = UDim2.new(1, -90, 1, 0)
				kLabel.Position = UDim2.new(0, 12, 0, 0)
				kLabel.BackgroundTransparency = 1
				kLabel.Font = Enum.Font.Gotham
				kLabel.TextSize = 12
				kLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
				kLabel.TextXAlignment = Enum.TextXAlignment.Left
				kLabel.Text = kName
				kLabel.Parent = kRow

				local kBtn = Instance.new("TextButton")
				kBtn.Name = "KeyBtn"
				kBtn.Size = UDim2.new(0, 72, 0, 22)
				kBtn.Position = UDim2.new(1, -12, 0.5, 0)
				kBtn.AnchorPoint = Vector2.new(1, 0.5)
				kBtn.BackgroundColor3 = Color3.fromRGB(26, 26, 31)
				kBtn.BorderSizePixel = 0
				kBtn.AutoButtonColor = false
				kBtn.Font = Enum.Font.GothamBold
				kBtn.TextSize = 11
				kBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
				kBtn.Text = formatKeyText(currentKey)
				kBtn.Parent = kRow

				local btnCorner = Instance.new("UICorner")
				btnCorner.CornerRadius = UDim.new(0, 6)
				btnCorner.Parent = kBtn

				local btnStroke = Instance.new("UIStroke")
				btnStroke.Color = Color3.fromRGB(36, 36, 42)
				btnStroke.Thickness = 1
				btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				btnStroke.Parent = kBtn

				table.insert(windowObj.Keybinds, {
					Name = modName,
					GetKey = function()
						return currentKey
					end,
					IsActive = function()
						return moduleObj.Enabled
					end
				})
				refreshKeybindHUD()

				kBtn.MouseButton1Click:Connect(function()
					listening = true
					listenStartTime = tick()
					kBtn.Text = "[ ... ]"
					tween(btnStroke, { Color = accentColor }, 0.15)
				end)

				UserInputService.InputBegan:Connect(function(input, processed)
					if listening then
						local now = tick()
						local captured = nil
						if input.UserInputType == Enum.UserInputType.Keyboard then
							if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then
								captured = Enum.KeyCode.Unknown
							else
								captured = input.KeyCode
							end
						elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
							if input.UserInputType ~= Enum.UserInputType.MouseButton1 or (now - listenStartTime > 0.25) then
								captured = input.UserInputType
							end
						elseif tostring(input.UserInputType.Name):find("Gamepad") then
							if input.KeyCode ~= Enum.KeyCode.Unknown then
								captured = input.KeyCode
							end
						end

						if captured ~= nil then
							currentKey = captured
							windowObj.Flags[flag] = currentKey
							kBtn.Text = formatKeyText(currentKey)
							listening = false
							tween(btnStroke, { Color = Color3.fromRGB(36, 36, 42) }, 0.15)
							refreshKeybindHUD()
							task.spawn(function()
								pcall(callback, currentKey, true)
							end)
						end
					elseif not processed and matchesKey(input, currentKey) then
						if bindModule then
							if mode == "Toggle" then
								setToggleState(not moduleObj.Enabled)
							elseif mode == "Hold" then
								setToggleState(true)
							end
						end
						refreshKeybindHUD()
						task.spawn(function()
							pcall(callback, currentKey, false)
						end)
					end
				end)

				if mode == "Hold" and bindModule then
					UserInputService.InputEnded:Connect(function(input)
						if not listening and matchesKey(input, currentKey) then
							setToggleState(false)
							refreshKeybindHUD()
						end
					end)
				end

				windowObj.ConfigElements[flag] = {
					Type = "Keybind",
					Serialize = function()
						if typeof(currentKey) == "EnumItem" then
							return currentKey.EnumType.Name .. "." .. currentKey.Name
						end
						return "KeyCode.Unknown"
					end,
					Deserialize = function(val)
						if type(val) == "string" then
							local eType, eName = val:match("^(%w+)%.(%w+)$")
							if eType == "KeyCode" and Enum.KeyCode[eName] then
								currentKey = Enum.KeyCode[eName]
							elseif eType == "UserInputType" and Enum.UserInputType[eName] then
								currentKey = Enum.UserInputType[eName]
							elseif Enum.KeyCode[val] then
								currentKey = Enum.KeyCode[val]
							elseif Enum.UserInputType[val] then
								currentKey = Enum.UserInputType[val]
							end
							windowObj.Flags[flag] = currentKey
							kBtn.Text = formatKeyText(currentKey)
							refreshKeybindHUD()
							pcall(callback, currentKey, false)
						end
					end
				}

				local keyController = {}
				function keyController:Set(key)
					currentKey = key or Enum.KeyCode.Unknown
					windowObj.Flags[flag] = currentKey
					kBtn.Text = formatKeyText(currentKey)
					refreshKeybindHUD()
					task.spawn(function()
						pcall(callback, currentKey, false)
					end)
				end
				function keyController:Get()
					return currentKey
				end
				return keyController
			end

			function moduleObj:CreateTextBox(tbConfig)
				tbConfig = tbConfig or {}
				local tbName = tbConfig.Name or "TextBox"
				local placeholder = tbConfig.Placeholder or "Enter text..."
				local default = tbConfig.Default or ""
				local flag = tbConfig.Flag or (modFlag .. "_" .. tbName)
				local callback = tbConfig.Callback or function() end

				windowObj.Flags[flag] = default

				local tbRow = Instance.new("Frame")
				tbRow.Name = "TextBox_" .. tbName
				tbRow.Size = UDim2.new(1, 0, 0, 36)
				tbRow.BackgroundColor3 = Color3.fromRGB(19, 19, 22)
				tbRow.BorderSizePixel = 0
				tbRow.Parent = settingsList

				local tbCorner = Instance.new("UICorner")
				tbCorner.CornerRadius = UDim.new(0, 8)
				tbCorner.Parent = tbRow

				local tbStroke = Instance.new("UIStroke")
				tbStroke.Color = Color3.fromRGB(30, 30, 35)
				tbStroke.Thickness = 1
				tbStroke.Parent = tbRow

				local tbLabel = Instance.new("TextLabel")
				tbLabel.Name = "Label"
				tbLabel.Size = UDim2.new(0.48, 0, 1, 0)
				tbLabel.Position = UDim2.new(0, 12, 0, 0)
				tbLabel.BackgroundTransparency = 1
				tbLabel.Font = Enum.Font.Gotham
				tbLabel.TextSize = 12
				tbLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
				tbLabel.TextXAlignment = Enum.TextXAlignment.Left
				tbLabel.Text = tbName
				tbLabel.Parent = tbRow

				local boxHolder = Instance.new("Frame")
				boxHolder.Name = "BoxHolder"
				boxHolder.Size = UDim2.new(0.48, -12, 0, 26)
				boxHolder.Position = UDim2.new(1, -12, 0.5, 0)
				boxHolder.AnchorPoint = Vector2.new(1, 0.5)
				boxHolder.BackgroundColor3 = Color3.fromRGB(26, 26, 31)
				boxHolder.BorderSizePixel = 0
				boxHolder.Parent = tbRow

				local bhCorner = Instance.new("UICorner")
				bhCorner.CornerRadius = UDim.new(0, 6)
				bhCorner.Parent = boxHolder

				local bhStroke = Instance.new("UIStroke")
				bhStroke.Color = Color3.fromRGB(36, 36, 42)
				bhStroke.Thickness = 1
				bhStroke.Parent = boxHolder

				local boxInput = Instance.new("TextBox")
				boxInput.Name = "Input"
				boxInput.Size = UDim2.new(1, -16, 1, 0)
				boxInput.Position = UDim2.new(0, 8, 0, 0)
				boxInput.BackgroundTransparency = 1
				boxInput.Font = Enum.Font.Gotham
				boxInput.TextSize = 11
				boxInput.TextColor3 = Color3.fromRGB(240, 240, 245)
				boxInput.PlaceholderText = placeholder
				boxInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
				boxInput.Text = default
				boxInput.ClearTextOnFocus = tbConfig.ClearOnFocus or false
				boxInput.Parent = boxHolder

				boxInput.Focused:Connect(function()
					tween(bhStroke, { Color = accentColor }, 0.15)
				end)

				boxInput.FocusLost:Connect(function(enterPressed)
					tween(bhStroke, { Color = Color3.fromRGB(36, 36, 42) }, 0.15)
					windowObj.Flags[flag] = boxInput.Text
					task.spawn(function()
						pcall(callback, boxInput.Text, enterPressed)
					end)
				end)

				windowObj.ConfigElements[flag] = {
					Type = "TextBox",
					Serialize = function()
						return boxInput.Text
					end,
					Deserialize = function(val)
						if type(val) == "string" then
							boxInput.Text = val
							windowObj.Flags[flag] = val
							task.spawn(function()
								pcall(callback, val, false)
							end)
						end
					end
				}

				local tbController = {}
				function tbController:Set(text)
					boxInput.Text = tostring(text)
					windowObj.Flags[flag] = boxInput.Text
				end
				function tbController:Get()
					return boxInput.Text
				end
				return tbController
			end

			function moduleObj:CreateButton(btnConfig)
				btnConfig = btnConfig or {}
				local bName = btnConfig.Name or "Button"
				local callback = btnConfig.Callback or function() end
				local isHovering = false

				local bBtn = Instance.new("TextButton")
				bBtn.Name = "Button_" .. bName
				bBtn.Size = UDim2.new(1, 0, 0, 34)
				bBtn.BackgroundColor3 = Color3.fromRGB(19, 19, 22)
				bBtn.BorderSizePixel = 0
				bBtn.AutoButtonColor = false
				bBtn.Font = Enum.Font.GothamMedium
				bBtn.TextSize = 12
				bBtn.TextColor3 = Color3.fromRGB(210, 210, 220)
				bBtn.Text = bName
				bBtn.Parent = settingsList

				local btnCorner = Instance.new("UICorner")
				btnCorner.CornerRadius = UDim.new(0, 8)
				btnCorner.Parent = bBtn

				local btnStroke = Instance.new("UIStroke")
				btnStroke.Color = Color3.fromRGB(30, 30, 35)
				btnStroke.Thickness = 1
				btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				btnStroke.Parent = bBtn

				bBtn.MouseButton1Click:Connect(function()
					tween(bBtn, { BackgroundColor3 = Color3.fromRGB(30, 30, 36) }, 0.08)
					tween(btnStroke, { Color = accentColor }, 0.08)
					task.delay(0.12, function()
						if isHovering then
							tween(bBtn, { BackgroundColor3 = Color3.fromRGB(24, 24, 29) }, 0.16)
							tween(btnStroke, { Color = Color3.fromRGB(46, 46, 54) }, 0.16)
						else
							tween(bBtn, { BackgroundColor3 = Color3.fromRGB(19, 19, 22) }, 0.16)
							tween(btnStroke, { Color = Color3.fromRGB(30, 30, 35) }, 0.16)
						end
					end)
					task.spawn(function()
						pcall(callback)
					end)
				end)

				bBtn.MouseEnter:Connect(function()
					isHovering = true
					tween(bBtn, {
						BackgroundColor3 = Color3.fromRGB(24, 24, 29),
						TextColor3 = Color3.fromRGB(245, 245, 250)
					}, 0.15)
					tween(btnStroke, { Color = Color3.fromRGB(46, 46, 54) }, 0.15)
				end)

				bBtn.MouseLeave:Connect(function()
					isHovering = false
					tween(bBtn, {
						BackgroundColor3 = Color3.fromRGB(19, 19, 22),
						TextColor3 = Color3.fromRGB(210, 210, 220)
					}, 0.15)
					tween(btnStroke, { Color = Color3.fromRGB(30, 30, 35) }, 0.15)
				end)

				local btnController = {}
				function btnController:SetText(txt)
					bBtn.Text = tostring(txt)
				end
				return btnController
			end

			function moduleObj:CreateColorPicker(colorConfig)
				colorConfig = colorConfig or {}
				local cpName = colorConfig.Name or "Color Picker"
				local currentColor = colorConfig.Default or accentColor
				local flag = colorConfig.Flag or (modFlag .. "_" .. cpName)
				local callback = colorConfig.Callback or function() end

				local h, s, v = Color3.toHSV(currentColor)
				local pickerOpen = false
				windowObj.Flags[flag] = currentColor

				local cpContainer = Instance.new("Frame")
				cpContainer.Name = "ColorPicker_" .. cpName
				cpContainer.Size = UDim2.new(1, 0, 0, 34)
				cpContainer.BackgroundColor3 = Color3.fromRGB(19, 19, 22)
				cpContainer.BorderSizePixel = 0
				cpContainer.ClipsDescendants = true
				cpContainer.Parent = settingsList

				local cpCorner = Instance.new("UICorner")
				cpCorner.CornerRadius = UDim.new(0, 8)
				cpCorner.Parent = cpContainer

				local cpStroke = Instance.new("UIStroke")
				cpStroke.Color = Color3.fromRGB(30, 30, 35)
				cpStroke.Thickness = 1
				cpStroke.Parent = cpContainer

				local cpHeader = Instance.new("Frame")
				cpHeader.Name = "Header"
				cpHeader.Size = UDim2.new(1, 0, 0, 34)
				cpHeader.BackgroundTransparency = 1
				cpHeader.Parent = cpContainer

				local cpLabel = Instance.new("TextLabel")
				cpLabel.Name = "Label"
				cpLabel.Size = UDim2.new(1, -120, 1, 0)
				cpLabel.Position = UDim2.new(0, 12, 0, 0)
				cpLabel.BackgroundTransparency = 1
				cpLabel.Font = Enum.Font.Gotham
				cpLabel.TextSize = 12
				cpLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
				cpLabel.TextXAlignment = Enum.TextXAlignment.Left
				cpLabel.Text = cpName
				cpLabel.Parent = cpHeader

				local hexBadge = Instance.new("TextLabel")
				hexBadge.Name = "HexBadge"
				hexBadge.Size = UDim2.new(0, 62, 0, 18)
				hexBadge.Position = UDim2.new(1, -50, 0.5, 0)
				hexBadge.AnchorPoint = Vector2.new(1, 0.5)
				hexBadge.BackgroundTransparency = 1
				hexBadge.Font = Enum.Font.GothamMedium
				hexBadge.TextSize = 11
				hexBadge.TextColor3 = Color3.fromRGB(130, 130, 142)
				hexBadge.TextXAlignment = Enum.TextXAlignment.Right
				hexBadge.Text = colorToHex(currentColor)
				hexBadge.Parent = cpHeader

				local previewBtn = Instance.new("TextButton")
				previewBtn.Name = "Preview"
				previewBtn.Size = UDim2.new(0, 32, 0, 18)
				previewBtn.Position = UDim2.new(1, -12, 0.5, 0)
				previewBtn.AnchorPoint = Vector2.new(1, 0.5)
				previewBtn.BackgroundColor3 = currentColor
				previewBtn.BorderSizePixel = 0
				previewBtn.AutoButtonColor = false
				previewBtn.Text = ""
				previewBtn.Parent = cpHeader

				local pCorner = Instance.new("UICorner")
				pCorner.CornerRadius = UDim.new(0, 5)
				pCorner.Parent = previewBtn

				local pStroke = Instance.new("UIStroke")
				pStroke.Color = Color3.fromRGB(45, 45, 52)
				pStroke.Thickness = 1
				pStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				pStroke.Parent = previewBtn

				local drawer = Instance.new("Frame")
				drawer.Name = "Drawer"
				drawer.Size = UDim2.new(1, -24, 0, 146)
				drawer.Position = UDim2.new(0, 12, 0, 38)
				drawer.BackgroundTransparency = 1
				drawer.Parent = cpContainer

				local svCanvas = Instance.new("TextButton")
				svCanvas.Name = "SVCanvas"
				svCanvas.Size = UDim2.new(1, -120, 0, 108)
				svCanvas.Position = UDim2.new(0, 0, 0, 0)
				svCanvas.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
				svCanvas.BorderSizePixel = 0
				svCanvas.AutoButtonColor = false
				svCanvas.Text = ""
				svCanvas.ClipsDescendants = true
				svCanvas.Parent = drawer

				local svCorner = Instance.new("UICorner")
				svCorner.CornerRadius = UDim.new(0, 6)
				svCorner.Parent = svCanvas

				local svStroke = Instance.new("UIStroke")
				svStroke.Color = Color3.fromRGB(38, 38, 45)
				svStroke.Thickness = 1
				svStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				svStroke.Parent = svCanvas

				local satOverlay = Instance.new("Frame")
				satOverlay.Name = "SatOverlay"
				satOverlay.Size = UDim2.new(1, 0, 1, 0)
				satOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				satOverlay.BorderSizePixel = 0
				satOverlay.Parent = svCanvas

				local satOverlayCorner = Instance.new("UICorner")
				satOverlayCorner.CornerRadius = UDim.new(0, 6)
				satOverlayCorner.Parent = satOverlay

				local satGrad = Instance.new("UIGradient")
				satGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
				satGrad.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
				satGrad.Rotation = 0
				satGrad.Parent = satOverlay

				local valOverlay = Instance.new("Frame")
				valOverlay.Name = "ValOverlay"
				valOverlay.Size = UDim2.new(1, 0, 1, 0)
				valOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				valOverlay.BorderSizePixel = 0
				valOverlay.ZIndex = 2
				valOverlay.Parent = svCanvas

				local valOverlayCorner = Instance.new("UICorner")
				valOverlayCorner.CornerRadius = UDim.new(0, 6)
				valOverlayCorner.Parent = valOverlay

				local valGrad = Instance.new("UIGradient")
				valGrad.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0))
				valGrad.Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0)
				})
				valGrad.Rotation = 90
				valGrad.Parent = valOverlay

				local svCursor = Instance.new("Frame")
				svCursor.Name = "Cursor"
				svCursor.Size = UDim2.new(0, 10, 0, 10)
				svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
				svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
				svCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				svCursor.BorderSizePixel = 0
				svCursor.ZIndex = 4
				svCursor.Parent = svCanvas

				local svCursorCorner = Instance.new("UICorner")
				svCursorCorner.CornerRadius = UDim.new(1, 0)
				svCursorCorner.Parent = svCursor

				local svCursorStroke = Instance.new("UIStroke")
				svCursorStroke.Color = Color3.fromRGB(15, 15, 18)
				svCursorStroke.Thickness = 1.5
				svCursorStroke.Parent = svCursor

				local hueBar = Instance.new("TextButton")
				hueBar.Name = "HueBar"
				hueBar.Size = UDim2.new(1, -120, 0, 12)
				hueBar.Position = UDim2.new(0, 0, 0, 118)
				hueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				hueBar.BorderSizePixel = 0
				hueBar.AutoButtonColor = false
				hueBar.Text = ""
				hueBar.Parent = drawer

				local hueCorner = Instance.new("UICorner")
				hueCorner.CornerRadius = UDim.new(1, 0)
				hueCorner.Parent = hueBar

				local hueStroke = Instance.new("UIStroke")
				hueStroke.Color = Color3.fromRGB(38, 38, 45)
				hueStroke.Thickness = 1
				hueStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
				hueStroke.Parent = hueBar

				local hueGrad = Instance.new("UIGradient")
				hueGrad.Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
					ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
					ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
					ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
					ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
					ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
					ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
				})
				hueGrad.Parent = hueBar

				local hueKnob = Instance.new("Frame")
				hueKnob.Name = "HueKnob"
				hueKnob.Size = UDim2.new(0, 8, 1, 4)
				hueKnob.AnchorPoint = Vector2.new(0.5, 0.5)
				hueKnob.Position = UDim2.new(h, 0, 0.5, 0)
				hueKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				hueKnob.BorderSizePixel = 0
				hueKnob.ZIndex = 3
				hueKnob.Parent = hueBar

				local hueKnobCorner = Instance.new("UICorner")
				hueKnobCorner.CornerRadius = UDim.new(1, 0)
				hueKnobCorner.Parent = hueKnob

				local hueKnobStroke = Instance.new("UIStroke")
				hueKnobStroke.Color = Color3.fromRGB(18, 18, 22)
				hueKnobStroke.Thickness = 1.5
				hueKnobStroke.Parent = hueKnob

				local sidePanel = Instance.new("Frame")
				sidePanel.Name = "SidePanel"
				sidePanel.Size = UDim2.new(0, 110, 0, 130)
				sidePanel.Position = UDim2.new(1, -110, 0, 0)
				sidePanel.BackgroundTransparency = 1
				sidePanel.Parent = drawer

				local hexInputBg = Instance.new("Frame")
				hexInputBg.Name = "HexBg"
				hexInputBg.Size = UDim2.new(1, 0, 0, 24)
				hexInputBg.Position = UDim2.new(0, 0, 0, 0)
				hexInputBg.BackgroundColor3 = Color3.fromRGB(26, 26, 31)
				hexInputBg.BorderSizePixel = 0
				hexInputBg.Parent = sidePanel

				local hexCorner = Instance.new("UICorner")
				hexCorner.CornerRadius = UDim.new(0, 6)
				hexCorner.Parent = hexInputBg

				local hexStroke = Instance.new("UIStroke")
				hexStroke.Color = Color3.fromRGB(36, 36, 42)
				hexStroke.Thickness = 1
				hexStroke.Parent = hexInputBg

				local hexBox = Instance.new("TextBox")
				hexBox.Name = "HexInput"
				hexBox.Size = UDim2.new(1, -12, 1, 0)
				hexBox.Position = UDim2.new(0, 6, 0, 0)
				hexBox.BackgroundTransparency = 1
				hexBox.Font = Enum.Font.GothamBold
				hexBox.TextSize = 11
				hexBox.TextColor3 = Color3.fromRGB(240, 240, 245)
				hexBox.PlaceholderText = "#RRGGBB"
				hexBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
				hexBox.Text = colorToHex(currentColor)
				hexBox.ClearTextOnFocus = false
				hexBox.Parent = hexInputBg

				local rgbRow = Instance.new("Frame")
				rgbRow.Name = "RGBRow"
				rgbRow.Size = UDim2.new(1, 0, 0, 24)
				rgbRow.Position = UDim2.new(0, 0, 0, 30)
				rgbRow.BackgroundTransparency = 1
				rgbRow.Parent = sidePanel

				local function createChannelInput(name, xScale)
					local holder = Instance.new("Frame")
					holder.Name = name
					holder.Size = UDim2.new(0.31, 0, 1, 0)
					holder.Position = UDim2.new(xScale, 0, 0, 0)
					holder.BackgroundColor3 = Color3.fromRGB(26, 26, 31)
					holder.BorderSizePixel = 0
					holder.Parent = rgbRow

					local c = Instance.new("UICorner")
					c.CornerRadius = UDim.new(0, 5)
					c.Parent = holder

					local st = Instance.new("UIStroke")
					st.Color = Color3.fromRGB(36, 36, 42)
					st.Thickness = 1
					st.Parent = holder

					local tb = Instance.new("TextBox")
					tb.Size = UDim2.new(1, 0, 1, 0)
					tb.BackgroundTransparency = 1
					tb.Font = Enum.Font.GothamMedium
					tb.TextSize = 10
					tb.TextColor3 = Color3.fromRGB(230, 230, 238)
					tb.ClearTextOnFocus = false
					tb.Text = "255"
					tb.Parent = holder
					return tb
				end

				local rBox = createChannelInput("R", 0)
				local gBox = createChannelInput("G", 0.345)
				local bBox = createChannelInput("B", 0.69)

				local swatchFrame = Instance.new("Frame")
				swatchFrame.Name = "Swatches"
				swatchFrame.Size = UDim2.new(1, 0, 0, 68)
				swatchFrame.Position = UDim2.new(0, 0, 0, 62)
				swatchFrame.BackgroundTransparency = 1
				swatchFrame.Parent = sidePanel

				local swatchGrid = Instance.new("UIGridLayout")
				swatchGrid.CellSize = UDim2.new(0, 23, 0, 20)
				swatchGrid.CellPadding = UDim2.new(0, 6, 0, 6)
				swatchGrid.SortOrder = Enum.SortOrder.LayoutOrder
				swatchGrid.Parent = swatchFrame

				local swatches = {
					Color3.fromRGB(255, 75, 114),
					Color3.fromRGB(100, 120, 255),
					Color3.fromRGB(0, 210, 140),
					Color3.fromRGB(255, 170, 0),
					Color3.fromRGB(185, 85, 255),
					Color3.fromRGB(255, 65, 65),
					Color3.fromRGB(70, 215, 255),
					Color3.fromRGB(255, 255, 255)
				}

				local function updateVisualsFromHSV(suppress)
					currentColor = Color3.fromHSV(h, s, v)
					windowObj.Flags[flag] = currentColor
					previewBtn.BackgroundColor3 = currentColor
					svCanvas.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
					svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
					hueKnob.Position = UDim2.new(h, 0, 0.5, 0)
					local hex = colorToHex(currentColor)
					hexBadge.Text = hex
					if not hexBox:IsFocused() then
						hexBox.Text = hex
					end
					if not rBox:IsFocused() then
						rBox.Text = tostring(math.floor(currentColor.R * 255 + 0.5))
					end
					if not gBox:IsFocused() then
						gBox.Text = tostring(math.floor(currentColor.G * 255 + 0.5))
					end
					if not bBox:IsFocused() then
						bBox.Text = tostring(math.floor(currentColor.B * 255 + 0.5))
					end
					if not suppress then
						task.spawn(function()
							pcall(callback, currentColor)
						end)
					end
				end

				local function setColorDirect(col, suppress)
					if typeof(col) ~= "Color3" then return end
					local nh, ns, nv = Color3.toHSV(col)
					h, s, v = nh, ns, nv
					updateVisualsFromHSV(suppress)
				end

				updateVisualsFromHSV(true)

				for idx, swCol in ipairs(swatches) do
					local swBtn = Instance.new("TextButton")
					swBtn.Name = "Swatch_" .. tostring(idx)
					swBtn.BackgroundColor3 = swCol
					swBtn.BorderSizePixel = 0
					swBtn.AutoButtonColor = false
					swBtn.Text = ""
					swBtn.Parent = swatchFrame

					local swCorner = Instance.new("UICorner")
					swCorner.CornerRadius = UDim.new(0, 4)
					swCorner.Parent = swBtn

					local swStroke = Instance.new("UIStroke")
					swStroke.Color = Color3.fromRGB(40, 40, 48)
					swStroke.Thickness = 1
					swStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					swStroke.Parent = swBtn

					swBtn.MouseButton1Click:Connect(function()
						setColorDirect(swCol, false)
					end)
				end

				local draggingSV = false
				local draggingHue = false

				local function updateSVFromInput(input)
					local size = svCanvas.AbsoluteSize
					if size.X <= 0 or size.Y <= 0 then return end
					local pos = svCanvas.AbsolutePosition
					s = math.clamp((input.Position.X - pos.X) / size.X, 0, 1)
					v = 1 - math.clamp((input.Position.Y - pos.Y) / size.Y, 0, 1)
					updateVisualsFromHSV(false)
				end

				local function updateHueFromInput(input)
					local sizeX = hueBar.AbsoluteSize.X
					if sizeX <= 0 then return end
					local posX = hueBar.AbsolutePosition.X
					h = math.clamp((input.Position.X - posX) / sizeX, 0, 1)
					updateVisualsFromHSV(false)
				end

				svCanvas.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						draggingSV = true
						updateSVFromInput(input)
					end
				end)

				hueBar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						draggingHue = true
						updateHueFromInput(input)
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						if draggingSV then
							updateSVFromInput(input)
						elseif draggingHue then
							updateHueFromInput(input)
						end
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						draggingSV = false
						draggingHue = false
					end
				end)

				hexBox.FocusLost:Connect(function()
					local parsed = hexToColor(hexBox.Text)
					if parsed then
						setColorDirect(parsed, false)
					else
						hexBox.Text = colorToHex(currentColor)
					end
				end)

				local function onRGBFocusLost()
					local r = math.clamp(tonumber(rBox.Text) or math.floor(currentColor.R * 255 + 0.5), 0, 255)
					local g = math.clamp(tonumber(gBox.Text) or math.floor(currentColor.G * 255 + 0.5), 0, 255)
					local b = math.clamp(tonumber(bBox.Text) or math.floor(currentColor.B * 255 + 0.5), 0, 255)
					setColorDirect(Color3.fromRGB(r, g, b), false)
				end

				rBox.FocusLost:Connect(onRGBFocusLost)
				gBox.FocusLost:Connect(onRGBFocusLost)
				bBox.FocusLost:Connect(onRGBFocusLost)

				local function togglePicker()
					pickerOpen = not pickerOpen
					if pickerOpen then
						tween(cpContainer, { Size = UDim2.new(1, 0, 0, 178) }, 0.2)
						tween(pStroke, { Color = accentColor }, 0.2)
					else
						tween(cpContainer, { Size = UDim2.new(1, 0, 0, 34) }, 0.2)
						tween(pStroke, { Color = Color3.fromRGB(45, 45, 52) }, 0.2)
					end
					task.delay(0.22, updateTraySize)
				end

				previewBtn.MouseButton1Click:Connect(togglePicker)

				windowObj.ConfigElements[flag] = {
					Type = "ColorPicker",
					Serialize = function()
						return colorToHex(currentColor)
					end,
					Deserialize = function(val)
						local parsed = hexToColor(val)
						if parsed then
							setColorDirect(parsed, false)
						end
					end
				}

				local colorController = {}
				function colorController:Set(col)
					setColorDirect(col, false)
				end
				function colorController:Get()
					return currentColor
				end
				return colorController
			end

			table.insert(tabObj.Modules, moduleObj)
			if not tostring(modFlag):match("^Internal_") then
				windowObj.ModuleByName[modName] = moduleObj
				local exists = false
				for _, m in ipairs(windowObj.AllModules) do
					if m.Name == modName then
						exists = true
						break
					end
				end
				if not exists then
					table.insert(windowObj.AllModules, moduleObj)
				end
				for _, listener in ipairs(windowObj.ModuleCreateListeners) do
					pcall(listener, moduleObj)
				end
			end
			return moduleObj
		end

		function tabObj:CreateConfigSystem()
			local selectedProfile = "default"
			local profileNameInput = "default"

			local managerMod = tabObj:CreateModule({
				Name = "Config Manager",
				Default = true,
				Flag = "Internal_ConfigManager"
			})
			windowObj.ConfigElements["Internal_ConfigManager"] = nil

			local profileDropdown = managerMod:CreateDropdown({
				Name = "Selected Profile",
				Options = windowObj:GetConfigs(),
				Default = "default",
				Flag = "Internal_SelectedProfile",
				Callback = function(val)
					selectedProfile = val
				end
			})
			windowObj.ConfigElements["Internal_SelectedProfile"] = nil

			local nameBox = managerMod:CreateTextBox({
				Name = "Profile Name",
				Placeholder = "Enter config name...",
				Default = "default",
				Flag = "Internal_ProfileName",
				Callback = function(txt)
					profileNameInput = txt
				end
			})
			windowObj.ConfigElements["Internal_ProfileName"] = nil

			local function refreshProfiles(selectName)
				local list = windowObj:GetConfigs()
				if selectName and table.find(list, selectName) then
					selectedProfile = selectName
				elseif not table.find(list, selectedProfile) then
					selectedProfile = list[1] or "default"
				end
				profileDropdown:Refresh(list, true)
				profileDropdown:Set(selectedProfile)
			end

			managerMod:CreateButton({
				Name = "Save Profile",
				Callback = function()
					local target = (nameBox:Get() ~= "" and nameBox:Get()) or selectedProfile
					local ok, msg = windowObj:SaveConfig(target)
					if ok then
						refreshProfiles(msg)
						windowObj:Notify({
							Title = "Config Saved",
							Description = "Saved profile '" .. tostring(msg) .. "'",
							Duration = 2.5
						})
					else
						windowObj:Notify({
							Title = "Config Error",
							Description = tostring(msg),
							Duration = 2.5
						})
					end
				end
			})

			managerMod:CreateButton({
				Name = "Load Profile",
				Callback = function()
					local target = profileDropdown:Get()
					local ok, msg = windowObj:LoadConfig(target)
					if ok then
						windowObj:Notify({
							Title = "Config Loaded",
							Description = "Loaded profile '" .. tostring(msg) .. "'",
							Duration = 2.5
						})
					else
						windowObj:Notify({
							Title = "Config Error",
							Description = tostring(msg),
							Duration = 2.5
						})
					end
				end
			})

			managerMod:CreateButton({
				Name = "Overwrite Profile",
				Callback = function()
					local target = profileDropdown:Get()
					local ok, msg = windowObj:SaveConfig(target)
					if ok then
						refreshProfiles(msg)
						windowObj:Notify({
							Title = "Config Updated",
							Description = "Overwrote profile '" .. tostring(msg) .. "'",
							Duration = 2.5
						})
					end
				end
			})

			managerMod:CreateButton({
				Name = "Delete Profile",
				Callback = function()
					local target = profileDropdown:Get()
					if windowObj:DeleteConfig(target) then
						refreshProfiles()
						windowObj:Notify({
							Title = "Config Deleted",
							Description = "Deleted profile '" .. tostring(target) .. "'",
							Duration = 2.5
						})
					end
				end
			})

			managerMod:CreateButton({
				Name = "Refresh List",
				Callback = function()
					refreshProfiles()
					windowObj:Notify({
						Title = "Configs",
						Description = "Profile list refreshed",
						Duration = 2
					})
				end
			})

			local shareMod = tabObj:CreateModule({
				Name = "Cloud / Clipboard Config",
				Default = true,
				Flag = "Internal_CloudConfig"
			})
			windowObj.ConfigElements["Internal_CloudConfig"] = nil

			local importBox = shareMod:CreateTextBox({
				Name = "Config JSON Data",
				Placeholder = "Paste config JSON here...",
				Default = "",
				Flag = "Internal_ImportJSON"
			})
			windowObj.ConfigElements["Internal_ImportJSON"] = nil

			shareMod:CreateButton({
				Name = "Export Current Config to Clipboard",
				Callback = function()
					local json = windowObj:ExportConfigJSON()
					local copied = false
					pcall(function()
						local clip = setclipboard or toclipboard
						if clip then
							clip(json)
							copied = true
						end
					end)
					importBox:Set(json)
					windowObj:Notify({
						Title = "Config Exported",
						Description = copied and "Copied JSON config to clipboard" or "Exported JSON to text box",
						Duration = 2.5
					})
				end
			})

			shareMod:CreateButton({
				Name = "Import Config from JSON Box",
				Callback = function()
					local raw = importBox:Get()
					if windowObj:ImportConfigJSON(raw) then
						windowObj:Notify({
							Title = "Config Imported",
							Description = "Applied configuration from JSON",
							Duration = 2.5
						})
					else
						windowObj:Notify({
							Title = "Import Failed",
							Description = "Invalid config JSON string",
							Duration = 2.5
						})
					end
				end
			})

			return managerMod
		end

		function tabObj:CreateButtonManager()
			local btnMod = tabObj:CreateModule({
				Name = "Button Manager",
				Default = true,
				Flag = "Internal_ButtonManager"
			})
			windowObj.ConfigElements["Internal_ButtonManager"] = nil

			local function getFeatureList()
				local names = {}
				for _, m in ipairs(windowObj.AllModules) do
					if m.Name and m.Name ~= "UI Preferences" and m.Name ~= "Button Manager" then
						table.insert(names, m.Name)
					end
				end
				if #names == 0 then
					names = {"Aim Assist", "Silent Aim", "Auto Clicker", "Player ESP"}
				end
				return names
			end

			local initialList = getFeatureList()
			local defaultFeat = windowObj.ButtonDraft.Feature or initialList[1] or "Aim Assist"
			windowObj.ButtonDraft.Feature = defaultFeat

			local suppressDraftSync = false
			local featureDropdown, labelInput, styleDropdown, widthSlider, heightSlider, cornerSlider, opacitySlider

			local function syncLiveFloatingIfPresent()
				local feat = windowObj.ButtonDraft.Feature
				local existing = windowObj.FloatingButtons[feat]
				if existing and existing.Config then
					existing.Config.Label = windowObj.ButtonDraft.Label
					existing.Config.Style = windowObj.ButtonDraft.Style
					existing.Config.Width = windowObj.ButtonDraft.Width
					existing.Config.Height = windowObj.ButtonDraft.Height
					existing.Config.CornerRadius = windowObj.ButtonDraft.CornerRadius
					existing.Config.Opacity = windowObj.ButtonDraft.Opacity
					if existing.Refresh then
						existing.Refresh()
					end
					refreshActiveButtonsListUI()
				end
			end

			local function loadFeatureIntoDraft(featName)
				suppressDraftSync = true
				windowObj.ButtonDraft.Feature = featName
				local existing = windowObj.FloatingButtons[featName]
				if existing and existing.Config then
					windowObj.ButtonDraft.Label = existing.Config.Label or ""
					windowObj.ButtonDraft.Style = existing.Config.Style or "Standard"
					windowObj.ButtonDraft.Width = existing.Config.Width or 116
					windowObj.ButtonDraft.Height = existing.Config.Height or 42
					windowObj.ButtonDraft.CornerRadius = existing.Config.CornerRadius or 10
					windowObj.ButtonDraft.Opacity = existing.Config.Opacity or 88
				end
				if labelInput then labelInput:Set(windowObj.ButtonDraft.Label or "") end
				if styleDropdown then styleDropdown:Set(windowObj.ButtonDraft.Style or "Standard") end
				if widthSlider then widthSlider:Set(windowObj.ButtonDraft.Width or 116) end
				if heightSlider then heightSlider:Set(windowObj.ButtonDraft.Height or 42) end
				if cornerSlider then cornerSlider:Set(windowObj.ButtonDraft.CornerRadius or 10) end
				if opacitySlider then opacitySlider:Set(windowObj.ButtonDraft.Opacity or 88) end
				suppressDraftSync = false
				refreshButtonPreviewWidget()
			end

			featureDropdown = btnMod:CreateDropdown({
				Name = "Feature",
				Options = initialList,
				Default = defaultFeat,
				Flag = "Internal_BM_Feature",
				Callback = function(val)
					if suppressDraftSync then return end
					windowObj:SetPreviewMode("Buttons")
					loadFeatureIntoDraft(val)
				end
			})
			windowObj.ConfigElements["Internal_BM_Feature"] = nil

			table.insert(windowObj.ModuleCreateListeners, function()
				local updated = getFeatureList()
				featureDropdown:Refresh(updated, true)
			end)

			labelInput = btnMod:CreateTextBox({
				Name = "Label",
				Placeholder = "feature name",
				Default = "",
				Flag = "Internal_BM_Label",
				Callback = function(txt)
					if suppressDraftSync then return end
					windowObj.ButtonDraft.Label = txt
					windowObj:SetPreviewMode("Buttons")
					refreshButtonPreviewWidget()
					syncLiveFloatingIfPresent()
				end
			})
			windowObj.ConfigElements["Internal_BM_Label"] = nil

			styleDropdown = btnMod:CreateDropdown({
				Name = "Button Style",
				Options = {"Standard", "Compact", "Minimal", "Outline"},
				Default = "Standard",
				Flag = "Internal_BM_Style",
				Callback = function(val)
					if suppressDraftSync then return end
					windowObj.ButtonDraft.Style = val
					windowObj:SetPreviewMode("Buttons")
					refreshButtonPreviewWidget()
					syncLiveFloatingIfPresent()
				end
			})
			windowObj.ConfigElements["Internal_BM_Style"] = nil

			widthSlider = btnMod:CreateSlider({
				Name = "Button Width",
				Min = 48,
				Max = 220,
				Default = 116,
				Precision = 2,
				Unit = "px",
				Flag = "Internal_BM_Width",
				Callback = function(val)
					if suppressDraftSync then return end
					windowObj.ButtonDraft.Width = val
					windowObj:SetPreviewMode("Buttons")
					refreshButtonPreviewWidget()
					syncLiveFloatingIfPresent()
				end
			})
			windowObj.ConfigElements["Internal_BM_Width"] = nil

			heightSlider = btnMod:CreateSlider({
				Name = "Button Height",
				Min = 28,
				Max = 110,
				Default = 42,
				Precision = 2,
				Unit = "px",
				Flag = "Internal_BM_Height",
				Callback = function(val)
					if suppressDraftSync then return end
					windowObj.ButtonDraft.Height = val
					windowObj:SetPreviewMode("Buttons")
					refreshButtonPreviewWidget()
					syncLiveFloatingIfPresent()
				end
			})
			windowObj.ConfigElements["Internal_BM_Height"] = nil

			cornerSlider = btnMod:CreateSlider({
				Name = "Corner Radius",
				Min = 2,
				Max = 30,
				Default = 10,
				Precision = 1,
				Unit = "px",
				Flag = "Internal_BM_Corner",
				Callback = function(val)
					if suppressDraftSync then return end
					windowObj.ButtonDraft.CornerRadius = val
					windowObj:SetPreviewMode("Buttons")
					refreshButtonPreviewWidget()
					syncLiveFloatingIfPresent()
				end
			})
			windowObj.ConfigElements["Internal_BM_Corner"] = nil

			opacitySlider = btnMod:CreateSlider({
				Name = "Opacity",
				Min = 10,
				Max = 100,
				Default = 88,
				Precision = 2,
				Unit = "%",
				Flag = "Internal_BM_Opacity",
				Callback = function(val)
					if suppressDraftSync then return end
					windowObj.ButtonDraft.Opacity = val
					windowObj:SetPreviewMode("Buttons")
					refreshButtonPreviewWidget()
					syncLiveFloatingIfPresent()
				end
			})
			windowObj.ConfigElements["Internal_BM_Opacity"] = nil

			windowObj.OnSyncButtonManagerSliders = function(w, h)
				suppressDraftSync = true
				if widthSlider then widthSlider:Set(w) end
				if heightSlider then heightSlider:Set(h) end
				suppressDraftSync = false
			end

			windowObj.OnSelectFloatingButtonInManager = function(featName, cfg)
				suppressDraftSync = true
				featureDropdown:Set(featName)
				suppressDraftSync = false
				loadFeatureIntoDraft(featName)
			end

			btnMod:CreateButton({
				Name = "Add Button",
				Callback = function()
					local feat = featureDropdown:Get() or windowObj.ButtonDraft.Feature
					windowObj:CreateFloatingButton({
						Feature = feat,
						Label = labelInput:Get(),
						Style = styleDropdown:Get(),
						Width = widthSlider:Get(),
						Height = heightSlider:Get(),
						CornerRadius = cornerSlider:Get(),
						Opacity = opacitySlider:Get()
					})
					windowObj:SetPreviewMode("Buttons")
					windowObj:Notify({
						Title = "Button Manager",
						Description = tostring(feat) .. " button added",
						Duration = 2.5
					})
				end
			})

			btnMod:CreateButton({
				Name = "Remove Button",
				Callback = function()
					local feat = featureDropdown:Get() or windowObj.ButtonDraft.Feature
					if windowObj:RemoveFloatingButton(feat) then
						windowObj:Notify({
							Title = "Button Manager",
							Description = "Removed button for '" .. tostring(feat) .. "'",
							Duration = 2
						})
					else
						windowObj:Notify({
							Title = "Button Manager",
							Description = "No active button found for '" .. tostring(feat) .. "'",
							Duration = 2
						})
					end
				end
			})

			btnMod:CreateButton({
				Name = "Clear All",
				Callback = function()
					windowObj:ClearFloatingButtons()
					windowObj:Notify({
						Title = "Button Manager",
						Description = "Cleared all on-screen toggle buttons",
						Duration = 2
					})
				end
			})

			btnMod:CreateToggle({
				Name = "Lock Buttons",
				Default = windowObj.ButtonsLocked,
				Flag = "UI_LockFloatingButtons",
				Callback = function(state)
					windowObj:SetButtonsLocked(state)
				end
			})

			return btnMod
		end

		function tabObj:CreateSettingsSystem()
			local uiMod = tabObj:CreateModule({
				Name = "UI Preferences",
				Default = true,
				Flag = "UI_Preferences"
			})

			uiMod:CreateColorPicker({
				Name = "Accent Color",
				Default = accentColor,
				Flag = "UI_AccentColor",
				Callback = function(col)
					windowObj:SetAccentColor(col)
				end
			})

			uiMod:CreateKeybind({
				Name = "Menu Keybind",
				Default = toggleKey,
				Mode = "Toggle",
				BindModule = false,
				Flag = "UI_ToggleKey",
				Callback = function(newKey, wasRebound)
					if newKey and newKey ~= Enum.KeyCode.Unknown then
						windowObj:SetToggleKey(newKey)
						if wasRebound then
							windowObj:Notify({
								Title = "Menu Keybind",
								Description = "Bound menu toggle to [" .. newKey.Name .. "]",
								Duration = 2
							})
						end
					end
				end
			})

			uiMod:CreateToggle({
				Name = "Preview Window",
				Default = windowObj.PreviewEnabled,
				Flag = "UI_ShowPreviewWindow",
				Callback = function(state)
					windowObj:SetPreviewVisible(state)
				end
			})

			uiMod:CreateToggle({
				Name = "Watermark",
				Default = wmFrame.Visible,
				Flag = "UI_Watermark",
				Callback = function(state)
					windowObj:SetWatermarkVisible(state)
				end
			})

			uiMod:CreateToggle({
				Name = "Keybind List",
				Default = kbFrame.Visible,
				Flag = "UI_KeybindList",
				Callback = function(state)
					windowObj:SetKeybindListVisible(state)
				end
			})

			uiMod:CreateToggle({
				Name = "Mobile Button",
				Default = mobileBtn ~= nil and mobileBtn.Visible or false,
				Flag = "UI_MobileButton",
				Callback = function(state)
					if mobileBtn then
						mobileBtn.Visible = state
					end
				end
			})

			uiMod:CreateSlider({
				Name = "UI Scale",
				Min = 0.35,
				Max = 1.1,
				Default = currentBaseScale,
				Precision = 0.05,
				Flag = "UI_MainScale",
				Callback = function(val)
					currentBaseScale = val
					if mainScale then
						mainScale.Scale = val
					end
				end
			})

			uiMod:CreateButton({
				Name = "Unload",
				Callback = function()
					windowObj:Destroy()
				end
			})

			tabObj:CreateButtonManager()

			return uiMod
		end

		table.insert(windowObj.Tabs, tabObj)
		if #windowObj.Tabs == 1 then
			selectTab()
		end

		return tabObj
	end

	function windowObj:Destroy()
		screenGui:Destroy()
	end

	return windowObj
end

Library.new = Library.CreateWindow

pcall(function()
	if getgenv then
		getgenv().FutureClub = Library
	end
end)

local FutureClub = Library
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local v2New = Vector2.new
local v3New = Vector3.new
local v3Zero = Vector3.zero
local cfNew = CFrame.new
local cfLookAt = CFrame.lookAt
local cfAngles = CFrame.Angles
local c3Rgb = Color3.fromRGB
local mathClamp = math.clamp
local mathRandom = math.random
local mathRad = math.rad
local mathFloor = math.floor
local tblInsert = table.insert
local tblClear = table.clear

local Window;
local cleanupTasks = {}
local function registerCleanup(item)
	tblInsert(cleanupTasks, item)
	return item
end

getgenv().FutureClubCleanup = function()
	for _, item in ipairs(cleanupTasks) do
		if typeof(item) == "RBXScriptConnection" then
			pcall(function() item:Disconnect() end)
		elseif type(item) == "function" then
			pcall(item)
		elseif typeof(item) == "Instance" then
			pcall(function() item:Destroy() end)
		elseif type(item) == "table" and item.Remove then
			pcall(function() item:Remove() end)
		end
	end
	tblClear(cleanupTasks)
end

local function matchesKey(inp, target)
	if not target or target == Enum.KeyCode.Unknown then return false end
	if typeof(target) == "EnumItem" then
		if target.EnumType == Enum.KeyCode then
			return inp.KeyCode == target
		elseif target.EnumType == Enum.UserInputType then
			return inp.UserInputType == target
		end
	end
	return false
end

local State = {
	Aiming = {
		Camlock = {
			Enabled = false,
			Method = "CFrame",
			Keybind = Enum.KeyCode.C,
			Mode = "Toggle",
			Active = false,
			TargetPart = "Head",
			FOVOrigin = "Mouse",
			Prediction = "Off",
			PredictionAmount = 0.138,
			PredictionX_Right = 0.138,
			PredictionX_Left = 0.138,
			PredictionY_Up = 0.138,
			PredictionY_Down = 0.138,
			PredictionZ = 0.138,
			Resolver = false,
			ResolverMode = "Recalculation",
			UnlockUponDeath = false,
			Smoothness = 0.20,
			Shake = false,
			ShakeAmount = 15,
			WallCheck = false,
			KOCheck = false,
			GrabbedCheck = false,
			FriendCheck = false,
			CrewCheck = false,
			ShowFOV = false,
			FOVRadius = 120,
			FOVColor = c3Rgb(255, 75, 114),
			StickyAim = false,
			ForceFieldCheck = false
		},
		Silent = {
			Enabled = false,
			Mode = "Always On",
			Keybind = Enum.KeyCode.Unknown,
			Active = true,
			FOVOrigin = "Mouse",
			TargetPart = "Closest Part",
			HitChance = 100,
			WallCheck = false,
			KOCheck = false,
			GrabbedCheck = false,
			FriendCheck = false,
			CrewCheck = false,
			ShotgunSpread = 6,
			SpreadModEnabled = false,
			SpreadAmount = 0,
			SpreadSpecificOnly = true,
			SyncFOV = true,
			ShowFOV = false,
			FOVRadius = 150,
			FOVColor = c3Rgb(255, 75, 114),
			TargetCamlockOnly = false,
			TargetTracer = false,
			TracerOrigin = "Bottom",
			TracerColor = c3Rgb(255, 75, 114),
			TracerThickness = 1.5,
			ForceFieldCheck = false
		},
		Triggerbot = {
			Enabled = false,
			Keybind = Enum.KeyCode.Unknown,
			Active = false,
			Method = "tool:Activate()",
			Delay = 50,
			TolerancePX = 0,
			OnlyWhenSilent = false,
			OnlyWhenLock = false,
			FireOnSilentTarget = false,
			WallCheck = false,
			KOCheck = false,
			GrabbedCheck = false,
			FriendCheck = false,
			CrewCheck = false,
			TeamCheck = false,
			ForceFieldCheck = false
		}
	},
	Visuals = {
		ESP = {
			Enabled = false,
			Boxes = false,
			BoxStyle = "Corner",
			BoxFill = false,
			Names = false,
			HealthBar = false,
			Distance = false,
			Weapon = false,
			Tracers = false,
			TracerOrigin = "Bottom",
			Chams = false,
			Bones = false,
			HeadDot = false,
			TeamCheck = false,
			MaxDistance = 1000,
			Colors = {
				Box = c3Rgb(255, 75, 114),
				Name = c3Rgb(245, 245, 250),
				Health = c3Rgb(90, 245, 140),
				Distance = c3Rgb(165, 165, 180),
				Weapon = c3Rgb(205, 205, 218),
				Tracer = c3Rgb(0, 210, 140),
				Chams = c3Rgb(255, 75, 114),
				Bone = c3Rgb(240, 240, 250),
				HeadDot = c3Rgb(255, 75, 114)
			}
		},
		World = {
			Fullbright = false,
			RemoveFog = false,
			Crosshair = false,
			CrosshairColor = c3Rgb(255, 255, 255),
			CrosshairSize = 10,
			CrosshairGap = 4
		}
	},
	Client = {
		Noclip = false,
		AnimationChanger = false,
		SelectedAnimation = "Default",
		HitSounds = false,
		HitSoundPreset = "Rust",
		HitSoundVolume = 80,
		CustomHitSoundId = "",
		DamageNumbers = false,
		HitNotifications = false,
		DamageNumbersColor = c3Rgb(255, 75, 114),
		DamageDuration = 1.0
	},
	Movement = {
		WalkSpeedEnabled = false,
		WalkSpeedValue = 16,
		JumpPowerEnabled = false,
		JumpPowerValue = 50,
		InfiniteJump = false,
		FakeMacro = false,
		MacroKey = Enum.KeyCode.Q,
		MacroMode = "Toggle",
		MacroSpeedMode = "Fixed",
		MacroSpeed = 120,
		MacroSpeedMin = 200,
		MacroSpeedMax = 300,
		MacroRampStart = 60,
		MacroRampMax = 280,
		MacroRampDuration = 1.0,
		MacroActive = false
	},
	Targeting = {
		SelectedPlayer = nil,
		Priority = {},
		Friends = {}
	}
}

local currentSpeed = 16
local currentJump = 50
local defaultSpeed = 16
local defaultJump = 50
local currentHumanoid = nil

local function updateWalkspeed()
	if currentHumanoid and currentHumanoid:IsDescendantOf(game) then
		currentHumanoid.WalkSpeed = State.Movement.WalkSpeedEnabled and currentSpeed or defaultSpeed
	end
end

local function updateJumpPower()
	if currentHumanoid and currentHumanoid:IsDescendantOf(game) then
		currentHumanoid.JumpPower = State.Movement.JumpPowerEnabled and currentJump or defaultJump
	end
end

local function onCharacterAddedSpeedJump(char)
	currentHumanoid = char:WaitForChild("Humanoid", 5)
	if currentHumanoid then
		updateWalkspeed()
		updateJumpPower()
		currentHumanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			if State.Movement.WalkSpeedEnabled and currentHumanoid.WalkSpeed ~= currentSpeed then
				currentHumanoid.WalkSpeed = currentSpeed
			end
		end)
		currentHumanoid:GetPropertyChangedSignal("JumpPower"):Connect(function()
			if State.Movement.JumpPowerEnabled and currentHumanoid.JumpPower ~= currentJump then
				currentHumanoid.JumpPower = currentJump
			end
		end)
	end
end


local activeMacroTrack = nil
local macroRunning = false
local cachedMacroAnim = nil
local cachedMacroAnimId = nil

local function findMeleeTool()
	local char = LocalPlayer.Character
	local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
	local search = {}
	if char then
		for _, item in ipairs(char:GetChildren()) do
			if item:IsA("Tool") then tblInsert(search, item) end
		end
	end
	if bp then
		for _, item in ipairs(bp:GetChildren()) do
			if item:IsA("Tool") then tblInsert(search, item) end
		end
	end
	for _, t in ipairs(search) do
		local n = t.Name:lower()
		if n:find("knife") or n:find("blade") or n:find("combat") or n:find("fist") or n:find("katana") or n:find("sword") or n:find("machete") then
			return t
		end
	end
	return search[1]
end

local function getMacroAnimation()
	if cachedMacroAnim then return cachedMacroAnim end
	local ok, res = pcall(function()
		return game:GetObjects("rbxassetid://15610015346")
	end)
	if ok and res and #res > 0 then
		local obj = res[1]
		if obj:IsA("Animation") then
			cachedMacroAnim = obj
			cachedMacroAnimId = obj.AnimationId
			return cachedMacroAnim
		end
		local nested = obj:FindFirstChildWhichIsA("Animation", true)
		if nested then
			cachedMacroAnim = nested
			cachedMacroAnimId = nested.AnimationId
			return cachedMacroAnim
		end
	end
	local fallback = Instance.new("Animation")
	fallback.AnimationId = cachedMacroAnimId or "rbxassetid://15610015346"
	cachedMacroAnim = fallback
	return cachedMacroAnim
end

local macroRampConn = nil

local function playMacroEmote(hum)
	if not hum then return nil end
	local animator = hum:FindFirstChildOfClass("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = hum
	end

	local anim = getMacroAnimation()
	pcall(function() anim.Parent = hum end)
	local track = nil

	local ok = pcall(function()
		track = animator:LoadAnimation(anim)
	end)
	if not ok or not track then
		pcall(function()
			track = hum:LoadAnimation(anim)
		end)
	end

	if track then
		track.Priority = Enum.AnimationPriority.Action4
		track.Looped = true
		track:Play(0.05, 1, 1)
	end
	return track
end

local function startFakeMacro()
	if macroRunning then return end
	macroRunning = true
	task.spawn(function()
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not char or not hum or not root then macroRunning = false; return end

		if activeMacroTrack then
			pcall(function() activeMacroTrack:Stop(0.05) end)
			activeMacroTrack = nil
		end
		if macroRampConn then
			macroRampConn:Disconnect()
			macroRampConn = nil
		end

		currentSpeed = 0
		State.Movement.WalkSpeedEnabled = true
		updateWalkspeed()
		pcall(function()
			root.AssemblyLinearVelocity = v3Zero
			hum:Move(v3Zero, false)
		end)

		local melee = findMeleeTool()
		if melee and melee.Parent ~= char then
			hum:EquipTool(melee)
			task.wait(0.05)
		end

		if not macroRunning then return end

		for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
			if t.Priority == Enum.AnimationPriority.Movement or t.Priority == Enum.AnimationPriority.Idle then
				pcall(function() t:Stop(0) end)
			end
		end

		local track = playMacroEmote(hum)
		if track then
			activeMacroTrack = track
		end

		task.wait(0.7)
		if not macroRunning then
			if activeMacroTrack then
				pcall(function() activeMacroTrack:Stop(0.05) end)
				activeMacroTrack = nil
			end
			return
		end

		if activeMacroTrack then
			pcall(function() activeMacroTrack:Stop(0.05) end)
			activeMacroTrack = nil
		end

		if State.Movement.MacroSpeedMode == "Fixed" then
			currentSpeed = State.Movement.MacroSpeed
			State.Movement.WalkSpeedEnabled = true
			updateWalkspeed()
		elseif State.Movement.MacroSpeedMode == "Random" then
			currentSpeed = mathRandom(State.Movement.MacroSpeedMin, State.Movement.MacroSpeedMax)
			State.Movement.WalkSpeedEnabled = true
			updateWalkspeed()
			macroRampConn = RunService.Heartbeat:Connect(function()
				if not macroRunning then return end
				currentSpeed = mathRandom(State.Movement.MacroSpeedMin, State.Movement.MacroSpeedMax)
				updateWalkspeed()
			end)
		elseif State.Movement.MacroSpeedMode == "Ramp Up" then
			local startSpeed = State.Movement.MacroRampStart
			local maxSpeed = State.Movement.MacroRampMax
			local dur = math.max(0.1, State.Movement.MacroRampDuration)
			local startTime = tick()
			currentSpeed = startSpeed
			State.Movement.WalkSpeedEnabled = true
			updateWalkspeed()
			macroRampConn = RunService.Heartbeat:Connect(function()
				if not macroRunning then return end
				local alpha = mathClamp((tick() - startTime) / dur, 0, 1)
				currentSpeed = mathFloor(startSpeed + (maxSpeed - startSpeed) * alpha)
				updateWalkspeed()
				if alpha >= 1 and macroRampConn then
					macroRampConn:Disconnect()
					macroRampConn = nil
				end
			end)
		end
	end)
end

local function stopFakeMacro()
	macroRunning = false
	if macroRampConn then
		macroRampConn:Disconnect()
		macroRampConn = nil
	end
	if activeMacroTrack then
		pcall(function() activeMacroTrack:Stop(0.05) end)
		activeMacroTrack = nil
	end
	currentSpeed = State.Movement.WalkSpeedValue
	State.Movement.WalkSpeedEnabled = (currentSpeed ~= 16)
	updateWalkspeed()
end

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true

local function isKnocked(char)
	if not char then return true end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then return true end
	local be = char:FindFirstChild("BodyEffects")
	if be then
		local ko = be:FindFirstChild("K.O") or be:FindFirstChild("KO")
		if ko and ko.Value then return true end
	end
	return false
end

local function isGrabbed(char)
	if not char then return true end
	if char:FindFirstChild("GRABBING_CONSTRAINT") then return true end
	local be = char:FindFirstChild("BodyEffects")
	if be then
		local gr = be:FindFirstChild("Grabbed")
		if gr and gr.Value then return true end
	end
	return false
end

local function isFriend(plr)
	if not plr then return false end
	if State.Targeting.Friends[plr.UserId] then return true end
	local ok, res = pcall(function() return LocalPlayer:IsFriendsWith(plr.UserId) end)
	return ok and res == true
end

local function isCrew(plr)
	if not plr then return false end
	if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return true end
	local c1 = LocalPlayer.Character
	local c2 = plr.Character
	if c1 and c2 then
		local t1 = c1:FindFirstChild("CrewTitle") or c1:FindFirstChild("[CREW]")
		local t2 = c2:FindFirstChild("CrewTitle") or c2:FindFirstChild("[CREW]")
		if t1 and t2 and t1.Value == t2.Value and t1.Value ~= "" then
			return true
		end
	end
	return false
end

local function hasForceField(char)
	if not char then return false end
	return char:FindFirstChildOfClass("ForceField") ~= nil
end

local function isVisible(part, origin)
	if not part then return false end
	rayParams.FilterDescendantsInstances = { Camera, LocalPlayer.Character }
	local dir = part.Position - origin
	local res = Workspace:Raycast(origin, dir, rayParams)
	if not res then return true end
	return res.Instance:IsDescendantOf(part.Parent)
end

local function getTargetPart(char, partSetting)
	if not char then return nil end
	if partSetting == "Closest Part" then
		local mousePos = UserInputService:GetMouseLocation()
		local bestDist = math.huge
		local bestPart = nil
		for _, desc in ipairs(char:GetChildren()) do
			if desc:IsA("BasePart") then
				local sp, onScreen = Camera:WorldToViewportPoint(desc.Position)
				if onScreen then
					local dist = (v2New(sp.X, sp.Y) - mousePos).Magnitude
					if dist < bestDist then
						bestDist = dist
						bestPart = desc
					end
				end
			end
		end
		return bestPart or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
	end
	return char:FindFirstChild(partSetting) or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
end

local function getToolRange(tool)
	if not tool then return nil end
	local rObj = tool:FindFirstChild("Range", true)
	if rObj and (rObj:IsA("NumberValue") or rObj:IsA("IntValue")) then
		local num = tonumber(rObj.Value)
		if num and num > 0 then
			return num
		end
	end
	local attr = tool:GetAttribute("Range")
	if type(attr) == "number" and attr > 0 then
		return attr
	end
	local config = tool:FindFirstChild("Configuration") or tool:FindFirstChild("Settings") or tool:FindFirstChild("GunConfig")
	if config then
		local r = config:FindFirstChild("Range")
		if r and (r:IsA("NumberValue") or r:IsA("IntValue")) and tonumber(r.Value) and r.Value > 0 then
			return tonumber(r.Value)
		end
	end
	return nil
end

local silentTarget = { Player = nil, Part = nil }
local camlockTarget = { Player = nil, Part = nil }
local equippedToolName = "None"
local silentFovRadius = 150
local velocityTracker = {}

local function updateVelocityTracker(dt)
	if not dt or dt <= 0 or dt > 0.5 then return end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local hrp = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Head")
			if hrp and hrp:IsA("BasePart") then
				local data = velocityTracker[plr]
				if not data then
					velocityTracker[plr] = {
						lastChar = plr.Character,
						lastPos = hrp.Position,
						velocity = v3Zero
					}
				elseif data.lastChar ~= plr.Character then
					data.lastChar = plr.Character
					data.lastPos = hrp.Position
					data.velocity = v3Zero
				else
					local displacement = hrp.Position - data.lastPos
					if displacement.Magnitude > 300 then
						data.velocity = v3Zero
					else
						data.velocity = displacement / dt
					end
					data.lastPos = hrp.Position
				end
			end
		end
	end
end

registerCleanup(Players.PlayerRemoving:Connect(function(plr)
	velocityTracker[plr] = nil
end))

registerCleanup(RunService.Heartbeat:Connect(function(dt)
	updateVelocityTracker(dt)
end))

local function getEffectiveVelocity(plr, part, useResolver, resolverMode, useRecalc)
	local rawVel = (part and (part.AssemblyLinearVelocity or part.Velocity)) or v3Zero
	if not plr or not plr.Character then
		return rawVel
	end

	local char = plr.Character
	local hum = char:FindFirstChildOfClass("Humanoid")
	local track = velocityTracker[plr]
	local recalcVel = (track and track.velocity) or rawVel

	if useRecalc then
		return recalcVel
	end

	if useResolver then
		local mode = resolverMode or "Recalculation"
		if mode == "Recalculation" then
			return recalcVel
		elseif mode == "MoveDirection" and hum then
			if hum.MoveDirection.Magnitude > 0.01 then
				local speed = (hum.WalkSpeed > 0 and hum.WalkSpeed) or 16
				local yVel = (recalcVel.Y > -100 and recalcVel.Y < 100) and recalcVel.Y or 0
				return v3New(hum.MoveDirection.X * speed, yVel, hum.MoveDirection.Z * speed)
			else
				return v3New(0, (recalcVel.Y > -100 and recalcVel.Y < 100) and recalcVel.Y or 0, 0)
			end
		elseif mode == "LookVector" and part then
			local isMoving = (hum and hum.MoveDirection.Magnitude > 0.01) or (recalcVel.Magnitude >= 1)
			if not isMoving then
				local yVel = (recalcVel.Y > -100 and recalcVel.Y < 100) and recalcVel.Y or 0
				return v3New(0, yVel, 0)
			end
			local speed = recalcVel.Magnitude
			if speed < 1 or speed > 100 then
				speed = (hum and hum.WalkSpeed > 0 and hum.WalkSpeed) or 16
			end
			local yVel = (recalcVel.Y > -100 and recalcVel.Y < 100) and recalcVel.Y or 0
			local look = part.CFrame.LookVector
			return v3New(look.X * speed, yVel, look.Z * speed)
		end
		return recalcVel
	end

	if rawVel.Magnitude > 100 or rawVel.Y < -100 or rawVel.Y > 100 then
		if track and track.velocity and track.velocity.Magnitude < 100 then
			return track.velocity
		end
	end

	return rawVel
end

local function isShotgun(name)
	if not name or name == "None" then return false end
	local n = tostring(name):lower()
	return n:find("double") or n:find("db") or n:find("tactical") or n:find("tac") or n:find("shotgun")
end

local function isSilentAimActive()
	if not State.Aiming.Silent.Enabled then return false end
	if State.Aiming.Silent.Mode == "Always On" then return true end
	if State.Aiming.Silent.Keybind == Enum.KeyCode.Unknown then return true end
	return State.Aiming.Silent.Active == true
end

local function getClosestSilentTarget()
	if not isSilentAimActive() then return nil, nil end
	local syncWithCamlock = State.Aiming.Silent.SyncFOV and State.Aiming.Camlock.Enabled
	local minRadius = syncWithCamlock and (State.Aiming.Camlock.FOVRadius or 120) or (State.Aiming.Silent.FOVRadius or 150)
	local screenCenter = Camera.ViewportSize / 2
	local mouseBehavior = UserInputService.MouseBehavior
	local isMouseLocked = (mouseBehavior == Enum.MouseBehavior.LockCenter or mouseBehavior == Enum.MouseBehavior.LockCurrentPosition)
	local originPref = syncWithCamlock and State.Aiming.Camlock.FOVOrigin or State.Aiming.Silent.FOVOrigin
	local center = (originPref == "Screen Center" or isMouseLocked) and screenCenter or UserInputService:GetMouseLocation()
	local targetPartPref = State.Aiming.Silent.TargetPart or "Closest Part"

	if State.Aiming.Silent.TargetCamlockOnly then
		if camlockTarget.Player and camlockTarget.Player.Character and camlockTarget.Part then
			local cPlr = camlockTarget.Player
			local cChar = cPlr.Character
			local hum = cChar:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health > 0 then
				local part = nil
				if targetPartPref == "Closest Part" then
					part = camlockTarget.Part
				else
					part = cChar:FindFirstChild(targetPartPref) or (targetPartPref:find("Torso") and cChar:FindFirstChild("Torso")) or cChar:FindFirstChild("HumanoidRootPart") or cChar:FindFirstChild("Head")
				end
				if part and part:IsA("BasePart") then
					return cPlr, part
				end
			end
		end
		return nil, nil
	end

	local bestPlr, bestPart = nil, nil

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
			local char = plr.Character
			if (not State.Aiming.Silent.KOCheck or not isKnocked(char)) and
			   (not State.Aiming.Silent.GrabbedCheck or not isGrabbed(char)) and
			   (not State.Aiming.Silent.FriendCheck or not isFriend(plr)) and
			   (not State.Aiming.Silent.CrewCheck or not isCrew(plr)) and
			   (not State.Aiming.Silent.ForceFieldCheck or not hasForceField(char)) then
				if targetPartPref == "Closest Part" then
					for _, part in ipairs(char:GetChildren()) do
						if part:IsA("BasePart") then
							if not State.Aiming.Silent.WallCheck or isVisible(part, Camera.CFrame.Position) then
								local sp, onScreen = Camera:WorldToScreenPoint(part.Position)
								if onScreen then
									local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
									if dist < minRadius then
										minRadius = dist
										bestPlr = plr
										bestPart = part
									end
								end
							end
						end
					end
				else
					local part = char:FindFirstChild(targetPartPref) or (targetPartPref:find("Torso") and char:FindFirstChild("Torso")) or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
					if part and part:IsA("BasePart") then
						if not State.Aiming.Silent.WallCheck or isVisible(part, Camera.CFrame.Position) then
							local sp, onScreen = Camera:WorldToScreenPoint(part.Position)
							if onScreen then
								local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
								if dist < minRadius then
									minRadius = dist
									bestPlr = plr
									bestPart = part
								end
							end
						end
					end
				end
			end
		end
	end
	return bestPlr, bestPart
end

local function calculateSpreadDirection(origin, targetPos, spreadAmount)
	local dir = (targetPos - origin).Unit
	if spreadAmount and spreadAmount > 0 then
		local spreadRad = spreadAmount * ((targetPos - origin).Magnitude / 100)
		dir = (targetPos + Vector3.new(
			mathRandom(-spreadRad * 1000, spreadRad * 1000) / 1000,
			mathRandom(-spreadRad * 1000, spreadRad * 1000) / 1000,
			mathRandom(-spreadRad * 1000, spreadRad * 1000) / 1000
		) - origin).Unit
	end
	return dir * 1000
end

local function bindToolTracking(char)
	if not char then return end
	for _, child in ipairs(char:GetChildren()) do
		if child:IsA("Tool") then equippedToolName = child.Name end
	end
	char.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then equippedToolName = child.Name end
	end)
	char.ChildRemoved:Connect(function(child)
		if child:IsA("Tool") then equippedToolName = "None" end
	end)
end

local oldNamecall;
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	local method = getnamecallmethod()
	local args = {...}
	if not checkcaller() and State.Aiming.Silent.Enabled and isSilentAimActive() and silentTarget.Part then
		if (State.Aiming.Silent.HitChance or 100) < 100 and mathRandom(1, 100) > (State.Aiming.Silent.HitChance or 100) then
			return oldNamecall(self, ...)
		end
		local targetPart = silentTarget.Part
		local spread = 0
		local isSg = isShotgun(equippedToolName)
		local allowSpread = not State.Aiming.Silent.SpreadSpecificOnly or isSg
		if allowSpread then
			local baseSpread = State.Aiming.Silent.ShotgunSpread or 6
			if State.Aiming.Silent.SpreadModEnabled then
				spread = baseSpread * ((State.Aiming.Silent.SpreadAmount or 0) / 100)
			else
				spread = baseSpread
			end
		end
		if method == "Raycast" and (self == Workspace or self == workspace) and #args >= 2 and typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
			args[2] = calculateSpreadDirection(args[1], targetPart.Position, spread)
			return oldNamecall(self, unpack(args))
		end
		if method:find("FindPartOnRay") and typeof(args[1]) == "Ray" then
			local ray = args[1]
			args[1] = Ray.new(ray.Origin, calculateSpreadDirection(ray.Origin, targetPart.Position, spread))
			return oldNamecall(self, unpack(args))
		end
	end
	return oldNamecall(self, ...)
end))

local oldIndex;
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
	if not checkcaller() and State.Aiming.Silent.Enabled and isSilentAimActive() and silentTarget.Part and self == Mouse then
		if (State.Aiming.Silent.HitChance or 100) < 100 and mathRandom(1, 100) > (State.Aiming.Silent.HitChance or 100) then
			return oldIndex(self, key)
		end
		local targetPart = silentTarget.Part
		if key == "Hit" then
			return CFrame.new(targetPart.Position)
		elseif key == "Target" then
			return targetPart
		end
	end
	return oldIndex(self, key)
end))

local function resolveCamlockTarget()
	if not State.Aiming.Camlock.Enabled or not State.Aiming.Camlock.Active then
		camlockTarget.Player = nil
		camlockTarget.Part = nil
		return
	end

	local radius = State.Aiming.Camlock.FOVRadius
	local screenCenter = Camera.ViewportSize / 2
	local mouseBehavior = UserInputService.MouseBehavior
	local isMouseLocked = (mouseBehavior == Enum.MouseBehavior.LockCenter or mouseBehavior == Enum.MouseBehavior.LockCurrentPosition)
	local centerPos = (State.Aiming.Camlock.FOVOrigin == "Screen Center" or isMouseLocked) and screenCenter or UserInputService:GetMouseLocation()

	if camlockTarget.Player and camlockTarget.Player.Character and camlockTarget.Part and camlockTarget.Part.Parent then
		local char = camlockTarget.Player.Character
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then
			camlockTarget.Player = nil
			camlockTarget.Part = nil
			if State.Aiming.Camlock.UnlockUponDeath then
				State.Aiming.Camlock.Active = false
				return
			end
		elseif (not State.Aiming.Camlock.KOCheck or not isKnocked(char)) and
			   (not State.Aiming.Camlock.GrabbedCheck or not isGrabbed(char)) and
			   (not State.Aiming.Camlock.FriendCheck or not isFriend(camlockTarget.Player)) and
			   (not State.Aiming.Camlock.CrewCheck or not isCrew(camlockTarget.Player)) and
			   (not State.Aiming.Camlock.ForceFieldCheck or not hasForceField(char)) then
			if not State.Aiming.Camlock.WallCheck or isVisible(camlockTarget.Part, Camera.CFrame.Position) then
				if State.Aiming.Camlock.StickyAim then
					return
				else
					local sp, onScreen = Camera:WorldToViewportPoint(camlockTarget.Part.Position)
					if onScreen then
						local dist = (v2New(sp.X, sp.Y) - centerPos).Magnitude
						local scDist = (v2New(sp.X, sp.Y) - screenCenter).Magnitude
						if dist <= radius or scDist <= radius then
							return
						end
					end
				end
			end
		else
			camlockTarget.Player = nil
			camlockTarget.Part = nil
		end
	elseif camlockTarget.Player then
		camlockTarget.Player = nil
		camlockTarget.Part = nil
		if State.Aiming.Camlock.UnlockUponDeath then
			State.Aiming.Camlock.Active = false
			return
		end
	end

	local bestDist = radius
	local bestPlr = nil
	local bestPart = nil

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local char = plr.Character
			local hum = char:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health > 0 then
				if (not State.Aiming.Camlock.KOCheck or not isKnocked(char)) and
				   (not State.Aiming.Camlock.GrabbedCheck or not isGrabbed(char)) and
				   (not State.Aiming.Camlock.FriendCheck or not isFriend(plr)) and
				   (not State.Aiming.Camlock.CrewCheck or not isCrew(plr)) and
				   (not State.Aiming.Camlock.ForceFieldCheck or not hasForceField(char)) then
					local part = getTargetPart(char, State.Aiming.Camlock.TargetPart)
					if part then
						local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
						if onScreen then
							local dist = (v2New(sp.X, sp.Y) - centerPos).Magnitude
							local scDist = (v2New(sp.X, sp.Y) - screenCenter).Magnitude
							local checkDist = math.min(dist, scDist)
							if checkDist < bestDist and (not State.Aiming.Camlock.WallCheck or isVisible(part, Camera.CFrame.Position)) then
								bestDist = checkDist
								bestPlr = plr
								bestPart = part
							end
						end
					end
				end
			end
		end
	end

	camlockTarget.Player = bestPlr
	camlockTarget.Part = bestPart
end

local camFovCircle = nil
local silentFovCircle = nil
local targetTracer = nil

pcall(function()
	if Drawing then
		camFovCircle = Drawing.new("Circle")
		camFovCircle.Thickness = 1.5
		camFovCircle.NumSides = 64
		camFovCircle.Filled = false
		camFovCircle.Visible = false
		camFovCircle.Transparency = 1
		registerCleanup(function() pcall(function() camFovCircle:Remove() end) end)

		silentFovCircle = Drawing.new("Circle")
		silentFovCircle.Thickness = 1.5
		silentFovCircle.NumSides = 64
		silentFovCircle.Filled = false
		silentFovCircle.Visible = false
		silentFovCircle.Transparency = 1
		registerCleanup(function() pcall(function() silentFovCircle:Remove() end) end)

		targetTracer = Drawing.new("Line")
		targetTracer.Thickness = 1.5
		targetTracer.Visible = false
		targetTracer.Transparency = 1
		targetTracer.Color = c3Rgb(255, 75, 114)
		registerCleanup(function() pcall(function() targetTracer:Remove() end) end)
	end
end)

if not targetTracer then
	pcall(function()
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "FutureTracerOverlay"
		screenGui.ResetOnSpawn = false
		screenGui.DisplayOrder = 1000
		pcall(function()
			if syn and syn.protect_gui then
				syn.protect_gui(screenGui)
				screenGui.Parent = game:GetService("CoreGui")
			elseif gethui then
				screenGui.Parent = gethui()
			else
				screenGui.Parent = game:GetService("CoreGui")
			end
		end)
		if not screenGui.Parent then
			screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
		end

		local lineFrame = Instance.new("Frame")
		lineFrame.Name = "Line"
		lineFrame.AnchorPoint = Vector2.new(0, 0.5)
		lineFrame.BorderSizePixel = 0
		lineFrame.Visible = false
		lineFrame.Parent = screenGui

		local lineProxy = {
			_gui = screenGui,
			_frame = lineFrame,
			Visible = false,
			From = Vector2.zero,
			To = Vector2.zero,
			Color = Color3.fromRGB(255, 75, 114),
			Thickness = 1.5,
			Transparency = 1
		}

		local mt = {}
		mt.__newindex = function(t, k, v)
			rawset(t, k, v)
			if k == "Visible" then
				lineFrame.Visible = v
			elseif k == "Color" then
				lineFrame.BackgroundColor3 = v
			elseif k == "Thickness" then
				lineFrame.Size = UDim2.new(0, lineFrame.AbsoluteSize.X, 0, v)
			elseif k == "From" or k == "To" then
				local p1 = rawget(t, "From") or Vector2.zero
				local p2 = rawget(t, "To") or Vector2.zero
				local diff = p2 - p1
				local dist = diff.Magnitude
				local angle = math.deg(math.atan2(diff.Y, diff.X))
				lineFrame.Position = UDim2.new(0, p1.X, 0, p1.Y)
				lineFrame.Size = UDim2.new(0, dist, 0, rawget(t, "Thickness") or 1.5)
				lineFrame.Rotation = angle
			end
		end
		setmetatable(lineProxy, mt)
		function lineProxy:Remove()
			pcall(function() screenGui:Destroy() end)
		end
		targetTracer = lineProxy
		registerCleanup(function() pcall(function() targetTracer:Remove() end) end)
	end)
end

local chLines = {}
pcall(function()
	if Drawing then
		for i = 1, 4 do
			local l = Drawing.new("Line")
			l.Thickness = 1.5
			l.Visible = false
			tblInsert(chLines, l)
		end
		registerCleanup(function()
			for _, l in ipairs(chLines) do pcall(function() l:Remove() end) end
		end)
	end
end)

local function updateWorldCrosshair()
	if #chLines == 4 then
		if State.Visuals.World.Crosshair then
			local cx = Camera.ViewportSize.X / 2
			local cy = Camera.ViewportSize.Y / 2
			local sz = State.Visuals.World.CrosshairSize
			local gap = State.Visuals.World.CrosshairGap
			local col = State.Visuals.World.CrosshairColor

			chLines[1].From = v2New(cx - gap - sz, cy); chLines[1].To = v2New(cx - gap, cy); chLines[1].Color = col; chLines[1].Visible = true
			chLines[2].From = v2New(cx + gap, cy); chLines[2].To = v2New(cx + gap + sz, cy); chLines[2].Color = col; chLines[2].Visible = true
			chLines[3].From = v2New(cx, cy - gap - sz); chLines[3].To = v2New(cx, cy - gap); chLines[3].Color = col; chLines[3].Visible = true
			chLines[4].From = v2New(cx, cy + gap); chLines[4].To = v2New(cx, cy + gap + sz); chLines[4].Color = col; chLines[4].Visible = true
		else
			for _, l in ipairs(chLines) do l.Visible = false end
		end
	end
end

do
if getgenv().ESP and getgenv().ESP.Unload then
	pcall(getgenv().ESP.Unload)
end

local cloneref = cloneref or function(o) return o end
local gethui = gethui or function() return game:GetService("CoreGui") end
local getexecutorname = getexecutorname or function() return "Unknown" end
local getcustomasset = getcustomasset or getsynasset

local Service = function(Name)
	return cloneref(game:GetService(Name))
end

local Instance_new = Instance.new
local Color3_fromRGB, Color3_new, Color3_fromHSV, Color3_fromHex = Color3.fromRGB, Color3.new, Color3.fromHSV, Color3.fromHex
local table_clear, table_insert, table_remove, table_unpack, table_find, table_sort, table_concat = table.clear, table.insert, table.remove, table.unpack, table.find, table.sort, table.concat
local string_find, string_match, string_format, string_gsub, string_lower, string_upper, string_sub = string.find, string.match, string.format, string.gsub, string.lower, string.upper, string.sub
local task_wait, task_spawn, task_delay, task_defer = task.wait, task.spawn, task.delay, task.defer
local coroutine_wrap, coroutine_close, coroutine_create, coroutine_resume = coroutine.wrap, coroutine.close, coroutine.create, coroutine.resume
local os_clock, os_date = os.clock, os.date
local Vector2_new, Vector3_new, Vector3_one, Vector3_zero = Vector2.new, Vector3.new, Vector3.one, Vector3.zero
local UDim2_new, UDim2_fromScale, UDim2_fromOffset, UDim_new = UDim2.new, UDim2.fromScale, UDim2.fromOffset, UDim.new
local CFrame_Angles, CFrame_new = CFrame.Angles, CFrame.new
local math_clamp, math_round, math_floor, math_huge, math_sin, math_cos, math_pi, math_min, math_deg, math_max, math_random, math_abs = math.clamp, math.round, math.floor, math.huge, math.sin, math.cos, math.pi, math.min, math.deg, math.max, math.random, math.abs
local Drawing_new, Rect_new, Font_new, ColorSequence_new, ColorSequenceKeypoint_new, TweenInfo_new, NumberSequence_new, NumberSequenceKeypoint_new = Drawing and Drawing.new or nil, Rect.new, Font and Font.new or nil, ColorSequence.new, ColorSequenceKeypoint.new, TweenInfo.new, NumberSequence.new, NumberSequenceKeypoint.new
local FindFirstChild, GetChildren, GetDescendants, WaitForChild, FindFirstChildWhichIsA, IsA = game.FindFirstChild, game.GetChildren, game.GetDescendants, game.WaitForChild, game.FindFirstChildWhichIsA, game.IsA

getgenv().ESP = {
	Settings = {
		Players = {
			Enabled = false,
			LocalPlayer = false,

			Font = "Tahoma",
			FontSize = 12,
			FontType = "lowercase",

			MaxDistance = 1000,
			RefreshRate = 60,

			BoundingBox = {
				Enabled = false,
				DynamicBox = true,
				IncludeAccessories = false,
				Type = "Corner",
				
				Rotation = 90,
				Color = {Color3_fromRGB(255, 75, 114), Color3_fromRGB(255, 75, 114)},
				Transparency = {0, 0},

				Glow = {
					Enabled = false,
					Rotation = 90,
					Color = {Color3_fromRGB(255, 75, 114), Color3_fromRGB(255, 75, 114)},
					Transparency = {0.75, 0.75},
				},

				Fill = {
					Enabled = false,
					Rotation = 90,
					Color = {Color3_fromRGB(255, 75, 114), Color3_fromRGB(255, 75, 114)},
					Transparency = {1, 0.5},
				},
			},

			Bars = {
				HealthBar = {
					Enabled = false,
					Position = "Left",
					Color = {Color3_fromRGB(131, 245, 78), Color3_fromRGB(255, 255, 0), Color3_fromRGB(252, 71, 77)},

					Type = function(Player, CharacterObjects)
						if not IsA(Player, "Player") then return 1 end
						local Humanoid = CharacterObjects.Humanoid
						if not Humanoid or Humanoid.MaxHealth <= 0 then return 1 end
						return math_clamp(Humanoid.Health / Humanoid.MaxHealth, 0, 1)
					end,

					Text = {
						Enabled = false,
						FollowBar = true,
						Ending = "",
						Position = "Left",
						Color = Color3_fromRGB(255, 255, 255),
						Transparency = 0,

						Type = function(Player, CharacterObjects)
							if not IsA(Player, "Player") then return 100, false end
							local Humanoid = CharacterObjects.Humanoid
							if not Humanoid then return 100, false end
							return Humanoid.Health, Humanoid.Health ~= Humanoid.MaxHealth
						end,
					},
				},

				ArmorBar = {
					Enabled = false,
					Position = "Bottom",
					Color = {Color3_fromRGB(52, 131, 235), Color3_fromRGB(52, 131, 235), Color3_fromRGB(52, 131, 235)},

					Type = function(Player, CharacterObjects)
						if not IsA(Player, "Player") then return 0 end
						local char = CharacterObjects.Character
						local be = char and char:FindFirstChild("BodyEffects")
						local armor = be and be:FindFirstChild("Armor")
						if armor then
							return math_clamp(armor.Value / 100, 0, 1)
						end
						return 0
					end,

					Text = {
						Enabled = false,
						FollowBar = true,
						Ending = "%",
						Position = "Bottom",
						Color = Color3_fromRGB(255, 255, 255),
						Transparency = 0,

						Type = function(Player, CharacterObjects)
							local char = CharacterObjects.Character
							local be = char and char:FindFirstChild("BodyEffects")
							local armor = be and be:FindFirstChild("Armor")
							if armor and armor.Value > 0 then
								return armor.Value, true
							end
							return 0, false
						end,
					},
				},
			},

			Chams = {
				Enabled = false,
				DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
				Fill = {Color3_fromRGB(255, 75, 114), 0.5},
				Outline = {Color3_fromRGB(0, 0, 0), 0.5},
			},

			Name = {
				Enabled = false,
				UseDisplay = true,
				Position = "Top",
				Color = Color3_fromRGB(255, 255, 255),
				Transparency = 0,
			},

			Distance = {
				Enabled = false,
				Ending = "m",
				Position = "Bottom",
				Color = Color3_fromRGB(255, 255, 255),
				Transparency = 0,
			},

			Weapon = {
				Enabled = false,
				Position = "Bottom",
				Color = Color3_fromRGB(255, 255, 255),
				Transparency = 0,
			},

			Flags = {
				Enabled = false,
				Position = "Right",
				Color = Color3_fromRGB(255, 255, 255),
				Transparency = 0,

				Type = function(Player, CharacterObjects)
					local Flags = {}
					if not IsA(Player, "Player") then return Flags end
					local char = CharacterObjects.Character
					local Humanoid = CharacterObjects.Humanoid
					if not Humanoid then return Flags end

					if Humanoid.MoveDirection.Magnitude > 0 then
						table_insert(Flags, "moving")
					end
					if Humanoid.Jump then
						table_insert(Flags, "jumping")
					end
					if isKnocked and isKnocked(char) then
						table_insert(Flags, "KO")
					end
					if isGrabbed and isGrabbed(char) then
						table_insert(Flags, "grabbed")
					end
					return Flags
				end
			},
		},
	},

	Connections = {},
	Errors = {},
	Objects = {},
	Targets = {},
	Folder = "ESP",
	Font = nil,
	Holder = nil,
}

local Client = Players.LocalPlayer
local Camera = Workspace.CurrentCamera or FindFirstChildWhichIsA(Workspace, "Camera")
local Viewport = Camera.ViewportSize
local ConnectionsTable = ESP.Connections
local ObjectsTable = ESP.Objects
local DrawingsTable = ESP.Drawings
local FolderLocation = ESP.Folder
local ESPErrors = ESP.Errors
local ESPSettings = ESP.Settings
local WorldToViewportPoint = Camera.WorldToViewportPoint
local ExecutorName = getexecutorname()

local function P(p)
	return p:gsub("\\", "/")
end

do 
	pcall(function()
		local baseFolder = P(FolderLocation)
		local fontsFolder = P(FolderLocation .. "/Fonts")

		if isfolder and makefolder then
			if not isfolder(baseFolder) then
				makefolder(baseFolder)
			end
			if not isfolder(fontsFolder) then
				makefolder(fontsFolder)
			end
		end
	end)
end

local FontsToDownload = {
	["Tahoma"] = {Link = "https://github.com/LuckyHub1/LuckyHub/raw/main/zekton_rg.ttf"},
	["Minecraftia"] = {Link = "https://github.com/LuckyHub1/LuckyHub/raw/refs/heads/main/Minecraftia.ttf"},
	["Silkscreen"] = {Link = "https://github.com/LuckyHub1/LuckyHub/raw/refs/heads/main/Silkscreen.ttf"},
}

do -- Fonts
	pcall(function()
		local fontsFolder = P(FolderLocation .. "/Fonts")

		if writefile and isfile and getcustomasset and game.HttpGet then
			for Name, Table in pairs(FontsToDownload) do
				local ttfPath  = P(fontsFolder .. "/" .. Name .. ".ttf")
				local fontPath = P(fontsFolder .. "/" .. Name .. ".font")

				if not isfile(ttfPath) then
					pcall(writefile, ttfPath, game:HttpGet(Table.Link))
				end
				
				if not isfile(fontPath) or ExecutorName == "Potassium" then
					local Config = {
						name = Name,
						faces = {{
							name = "Regular",
							weight = 9e9,
							style = "normal",
							assetId = getcustomasset(ttfPath)
						}}
					}
					pcall(writefile, fontPath, HttpService:JSONEncode(Config))
				end
			end
		end

		if not getgenv().Fonts then
			getgenv().Fonts = {
				Loaded = {}
			}

			if listfiles and isfolder and isfolder(fontsFolder) and getcustomasset then
				for _, FontPath in ipairs(listfiles(fontsFolder)) do
					FontPath = P(FontPath)
					local Name = string_match(FontPath, fontsFolder .. "/(.+)%.font")
					if Name then
						local ok, asset = pcall(getcustomasset, FontPath)
						if ok and asset and Font_new then
							Fonts.Loaded[Name] = Font_new(asset, Enum.FontWeight.Regular)
						else
							if Font and Font.fromEnum then
								Fonts.Loaded[Name] = Font.fromEnum(Enum.Font.SourceSans)
							end
						end
					end
				end
			end
		end
	end)
end

local Utility = {}; do
	function Utility.AddConnection(Signal, Function)
		local Connection = Signal:Connect(function(...)
			local Args = {...}
			local Success, Message = pcall(function() coroutine_wrap(Function)(table_unpack(Args)) end)
			if not Success and not ESPErrors[Message] then
				ESPErrors[Message] = Message
				if ConnectionsTable[Connection] then
					ConnectionsTable[Connection] = nil
				end
				return Connection and Connection:Disconnect()
			end
		end)
		if Connection and ConnectionsTable then
			table_insert(ConnectionsTable, Connection)
		end
		return Connection
	end

	function Utility.CreateObject(Type, Properties, Hidden)
		local Object = Instance_new(Type)
		for Index, Value in pairs(Properties) do
			Object[Index] = Value
		end
		table_insert(ObjectsTable, Object)
		return Object
	end

	function Utility.CalculateBox(ESPSettings, Target, RootPart, Character)
		if not RootPart then return 0, 0, 0, 0, false end
		local rootPos = RootPart.Position
		local isPlayer = IsA(Target, "Player")

		local topY = isPlayer and 2.6 or (RootPart.Size.Y * 0.5)
		local botY = isPlayer and 3.2 or (RootPart.Size.Y * 0.5)

		local topScreen, topVis = WorldToViewportPoint(Camera, rootPos + Vector3_new(0, topY, 0))
		local botScreen, botVis = WorldToViewportPoint(Camera, rootPos - Vector3_new(0, botY, 0))

		if not topVis and not botVis then
			return 0, 0, 0, 0, false
		end

		local boxHeight = math_abs(botScreen.Y - topScreen.Y)
		local boxWidth = math_floor(boxHeight * 0.62)
		local minX = math_floor(topScreen.X - (boxWidth * 0.5))
		local minY = math_floor(math_min(topScreen.Y, botScreen.Y))

		return boxWidth, math_floor(boxHeight), minX, minY, true
	end

	function Utility.GetFontType(ESPSettings, Text)
		local FontType = string_lower(tostring(ESPSettings.FontType or "none"))
		if FontType == "uppercase" then
			return string_upper(Text)
		elseif FontType == "lowercase" then
			return string_lower(Text)
		else
			return Text
		end
	end
end

local PlayerHelper = {}; do
	function PlayerHelper.GetCharacter(Player)
		if not Player then return nil end
		return Player.Character
	end

	function PlayerHelper.GetChildren(Character)
		if not Character then return {} end
		return Character:GetChildren()
	end

	function PlayerHelper.GetDescendants(Character)
		if not Character then return {} end
		return Character:GetDescendants()
	end

	function PlayerHelper.GetTool(Player)
		if not Player then return nil end
		return nil
	end
end

do -- Functions
	local TextAlignments = {
		["Left"] = Enum.TextXAlignment.Right,
		["Right"] = Enum.TextXAlignment.Left,
		["Top"] = Enum.TextXAlignment.Center,
		["Bottom"] = Enum.TextXAlignment.Center,
	}

	local BAR_ANCHORS = {
		Top = Vector2_new(0, 0),
		Bottom = Vector2_new(0, 0),
		Left = Vector2_new(0, 1),
		Right = Vector2_new(0, 1)
	}
	local BAR_POSITIONS = {
		Top = UDim2_new(0, 0, 0, 0),
		Bottom = UDim2_new(0, 0, 0, 0),
		Left = UDim2_new(0, 0, 1, 0),
		Right = UDim2_new(0, 0, 1, 0)
	}
	local TEXT_ANCHORS = {
		Top = Vector2_new(0, 0.5),
		Bottom = Vector2_new(0, 0.5),
		Left = Vector2_new(0.5, 0),
		Right = Vector2_new(0.5, 0)
	}
	local TEXT_ALIGNMENTS = {
		Top = Enum.TextXAlignment.Right,
		Bottom = Enum.TextXAlignment.Right,
		Left = Enum.TextXAlignment.Center,
		Right = Enum.TextXAlignment.Center
	}

	local Layout = {
		{UDim2_new(0, -1, 0, -1), UDim2_new(0.3, 0, 0, 1), Vector2_new(0, 0), 0},
		{UDim2_new(0, -1, 0, -1), UDim2_new(0, 1, 0.3, 0), Vector2_new(0, 0), 180},

		{UDim2_new(1, 1, 0, -1), UDim2_new(0.3, 0, 0, 1), Vector2_new(1, 0), 0},
		{UDim2_new(1, 1, 0, -1), UDim2_new(0, 1, 0.3, 0), Vector2_new(1, 0), 180},

		{UDim2_new(0, -1, 1, 1), UDim2_new(0.3, 0, 0, 1), Vector2_new(0, 1), 0},
		{UDim2_new(0, -1, 1, 1), UDim2_new(0, 1, 0.3, 0), Vector2_new(0, 1), -180},

		{UDim2_new(1, 1, 1, 1), UDim2_new(0.3, 0, 0, 1), Vector2_new(1, 1), 0},
		{UDim2_new(1, 1, 1, 1), UDim2_new(0, 1, 0.3, 0), Vector2_new(1, 1), -180},
	}

	ESP.Holder = Utility.CreateObject("ScreenGui", {
		Name = "DualESPHolder",
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		ZIndexBehavior = Enum.ZIndexBehavior.Global,
		ResetOnSpawn = false,
		DisplayOrder = 10000,
		IgnoreGuiInset = true,
		Parent = gethui()
	})

	function ESP.AddTarget(Target, Type)
		if Target == nil then return end
		if not ESP.Targets[Type] then ESP.Targets[Type] = {} end
		if ESP.Targets[Type][Target] then return end

		local TargetInfo = {
			Objects = {},
			CharacterObjects = {},
			CharacterConnection = nil,
			ToolConnection = {Added = nil, Removed = nil},
			CurrentTool = "none",
			LastTick = os_clock()
		}

		local IsPlayer = IsA(Target, "Player")
		local IsBasePart = IsA(Target, "BasePart")
		local Objects = TargetInfo.Objects
		local LastTick = TargetInfo.LastTick
		local ToolConnection = TargetInfo.ToolConnection
		local CharacterObjects = TargetInfo.CharacterObjects
		local ESPSettings = ESPSettings[Type]
		local ESPFont = (getgenv().Fonts and getgenv().Fonts.Loaded and getgenv().Fonts.Loaded[ESPSettings.Font]) or (Font and Font.fromEnum and Font.fromEnum(Enum.Font.Gotham)) or (Font_new and Font_new(Enum.Font.SourceSans, Enum.FontWeight.Regular))
		local ESPFontSize = ESPSettings.FontSize
		local ESPHolder = ESP.Holder

		CharacterObjects.Character = if IsPlayer then (PlayerHelper.GetCharacter(Target)) else Target
		CharacterObjects.Children = PlayerHelper.GetChildren(CharacterObjects.Character)
		CharacterObjects.Descendants = PlayerHelper.GetDescendants(CharacterObjects.Character)

		if IsPlayer and CharacterObjects.Character then
			CharacterObjects.HumanoidRootPart = CharacterObjects.Character:FindFirstChild("HumanoidRootPart")
			CharacterObjects.Humanoid = CharacterObjects.Character:FindFirstChildWhichIsA("Humanoid")
		end

		do -- Functions
			function TargetInfo.Init()
				if #Objects > 0 then return end

				if IsPlayer then
					TargetInfo.CharacterConnection = Utility.AddConnection(Target.CharacterAdded, function(Character)
						CharacterObjects.Character = Character
						CharacterObjects.HumanoidRootPart = WaitForChild(Character, "HumanoidRootPart", 10)
						CharacterObjects.Humanoid = WaitForChild(Character, "Humanoid", 10)
						CharacterObjects.Children = PlayerHelper.GetChildren(Character)
						CharacterObjects.Descendants = PlayerHelper.GetDescendants(Character)

						local Highlight = Objects["Highlight"]
						if Highlight then
							Highlight.Adornee = CharacterObjects.Character
							Highlight.Enabled = false
						end
					end)

					if CharacterObjects.Character then
						ToolConnection.Added = Utility.AddConnection(CharacterObjects.Character.ChildAdded, function(Child)
							if IsA(Child, "Tool") then 
								TargetInfo.CurrentTool = Child.Name
							end 
						end)
						
						ToolConnection.Removed = Utility.AddConnection(CharacterObjects.Character.ChildRemoved, function(Child)
							if IsA(Child, "Tool") then 
								TargetInfo.CurrentTool = "none"
							end 
						end)

						for _, child in ipairs(CharacterObjects.Character:GetChildren()) do
							if IsA(child, "Tool") then
								TargetInfo.CurrentTool = child.Name
								break
							end
						end
					end
				end

				Objects["Highlight"] = Utility.CreateObject("Highlight", {
					Parent = CharacterObjects.Character or ESPHolder,
					Adornee = CharacterObjects.Character,
					Enabled = false,
					FillColor = Color3_fromRGB(255, 75, 114),
					FillTransparency = 1,
					OutlineColor = Color3_fromRGB(0, 0, 0),
					OutlineTransparency = 1
				})
				Objects["TargetHolder"] = Utility.CreateObject("Frame", {Parent = ESPHolder, Visible = false, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
				Objects["TopHolder"] = Utility.CreateObject("Frame", {Parent = Objects["TargetHolder"], AutomaticSize = Enum.AutomaticSize.Y, Visible = true, BackgroundTransparency = 1, AnchorPoint = Vector2_new(0, 1), Position = UDim2_new(0, -2, 0, -5), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 4, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
				Objects["BottomHolder"] = Utility.CreateObject("Frame", {Parent = Objects["TargetHolder"], AutomaticSize = Enum.AutomaticSize.Y, Visible = true, BackgroundTransparency = 1, Position = UDim2_new(0, -2, 1, 3), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 4, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
				Objects["LeftHolder"] = Utility.CreateObject("Frame", {Parent = Objects["TargetHolder"], AutomaticSize = Enum.AutomaticSize.X, Visible = true, BackgroundTransparency = 1, AnchorPoint = Vector2_new(1, 0), Position = UDim2_new(0, -4, 0, -2), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 1, 4), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
				Objects["RightHolder"] = Utility.CreateObject("Frame", {Parent = Objects["TargetHolder"], AutomaticSize = Enum.AutomaticSize.X, Visible = true, BackgroundTransparency = 1, Position = UDim2_new(1, 8, 0, -2), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 1, 4), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
				
				do -- Text Holders
					Objects["TopTextHolder"] = Utility.CreateObject("Frame", {Parent = Objects["TopHolder"], AutomaticSize = Enum.AutomaticSize.Y, Visible = true, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
					Utility.CreateObject("UIListLayout", {Parent = Objects["TopTextHolder"], VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim_new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder})
					Utility.CreateObject("UIPadding", {Parent = Objects["TopTextHolder"], PaddingBottom = UDim_new(0, 2)})

					Objects["BottomTextHolder"] = Utility.CreateObject("Frame", {Parent = Objects["BottomHolder"], LayoutOrder = 2, AutomaticSize = Enum.AutomaticSize.Y, Visible = true, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
					Utility.CreateObject("UIListLayout", {Parent = Objects["BottomTextHolder"], HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim_new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder})
					Utility.CreateObject("UIPadding", {Parent = Objects["BottomTextHolder"], PaddingTop = UDim_new(0, 2)})

					Objects["LeftTextHolder"] = Utility.CreateObject("Frame", {Parent = Objects["LeftHolder"], AutomaticSize = Enum.AutomaticSize.XY, Visible = true, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
					Utility.CreateObject("UIListLayout", {Parent = Objects["LeftTextHolder"], HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim_new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder})
					Utility.CreateObject("UIPadding", {Parent = Objects["LeftTextHolder"], PaddingTop = UDim_new(0, -3)})

					Objects["RightTextHolder"] = Utility.CreateObject("Frame", {Parent = Objects["RightHolder"], LayoutOrder = 2, AutomaticSize = Enum.AutomaticSize.XY, Visible = true, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
					Utility.CreateObject("UIListLayout", {Parent = Objects["RightTextHolder"], HorizontalAlignment = Enum.HorizontalAlignment.Left, Padding = UDim_new(0, 0), SortOrder = Enum.SortOrder.LayoutOrder})
					Utility.CreateObject("UIPadding", {Parent = Objects["RightTextHolder"], PaddingTop = UDim_new(0, -3)})
				end

				do -- Bar Holders
					Objects["TopBarHolder"] = Utility.CreateObject("Frame", {Visible = false, Parent = Objects["TopHolder"], AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
					Utility.CreateObject("UIListLayout", {Parent = Objects["TopBarHolder"], HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim_new(0, 1), VerticalAlignment = Enum.VerticalAlignment.Bottom, SortOrder = Enum.SortOrder.LayoutOrder})

					Objects["BottomBarHolder"] = Utility.CreateObject("Frame", {Visible = false, Parent = Objects["BottomHolder"], AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
					Utility.CreateObject("UIListLayout", {Parent = Objects["BottomBarHolder"], HorizontalAlignment = Enum.HorizontalAlignment.Center, Padding = UDim_new(0, 1), VerticalAlignment = Enum.VerticalAlignment.Bottom, SortOrder = Enum.SortOrder.LayoutOrder})
					Utility.CreateObject("UIPadding", {Parent = Objects["BottomBarHolder"], PaddingTop = UDim_new(0, 2)})

					Objects["LeftBarHolder"] = Utility.CreateObject("Frame", {Visible = false, Parent = Objects["LeftHolder"], AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 1, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
					Utility.CreateObject("UIListLayout", {Parent = Objects["LeftBarHolder"], FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim_new(0, 1), SortOrder = Enum.SortOrder.LayoutOrder})
					Utility.CreateObject("UIPadding", {Parent = Objects["LeftBarHolder"], PaddingRight = UDim_new(0, 1)})

					Objects["RightBarHolder"] = Utility.CreateObject("Frame", {Visible = false, Parent = Objects["RightHolder"], AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 1, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
					Utility.CreateObject("UIListLayout", {Parent = Objects["RightBarHolder"], FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Left, Padding = UDim_new(0, 1), SortOrder = Enum.SortOrder.LayoutOrder})
					Utility.CreateObject("UIPadding", {Parent = Objects["RightBarHolder"], PaddingLeft = UDim_new(0, -3)})
				end
				
				do -- List Layouts
					Utility.CreateObject("UIListLayout", {Parent = Objects["TopHolder"], VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim_new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder})
					Utility.CreateObject("UIListLayout", {Parent = Objects["BottomHolder"], Padding = UDim_new(0, 1), SortOrder = Enum.SortOrder.LayoutOrder})
					Utility.CreateObject("UIPadding", {Parent = Objects["LeftHolder"], PaddingRight = UDim_new(0, 1)})
					Utility.CreateObject("UIListLayout", {Parent = Objects["LeftHolder"], FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Left, Padding = UDim_new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder})
					Utility.CreateObject("UIListLayout", {Parent = Objects["RightHolder"], FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Left, Padding = UDim_new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder})
				end

				do -- Box
					Objects["BoxGlow"] = Utility.CreateObject("ImageLabel", {Parent = Objects["TargetHolder"], Image = "rbxassetid://110204605000367", ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect_new(Vector2_new(21, 21), Vector2_new(79, 79)), AutomaticSize = Enum.AutomaticSize.XY, ImageTransparency = 0.65, ResampleMode = Enum.ResamplerMode.Pixelated, Visible = true, BackgroundTransparency = 1, Position = UDim2_new(0, -21, 0, -21), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
					Objects["BoxGlowGradient"] = Utility.CreateObject("UIGradient", {Parent = Objects["BoxGlow"], Rotation = 90, Color = ColorSequence_new{ColorSequenceKeypoint_new(0, Color3_fromRGB(0, 0, 0)), ColorSequenceKeypoint_new(1, Color3_fromRGB(0, 0, 0))}, Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, 0), NumberSequenceKeypoint_new(1, 0)}})
					Utility.CreateObject("UIPadding", {Parent = Objects["BoxGlow"], PaddingTop = UDim_new(0, 21), PaddingBottom = UDim_new(0, 20), PaddingLeft = UDim_new(0, 21), PaddingRight = UDim_new(0, 20)})

					Objects["BoxOutlineHolder"] = Utility.CreateObject("Frame", {Parent = Objects["BoxGlow"], Visible = false, BackgroundTransparency = 1, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
					Objects["BoxOutline"] = Utility.CreateObject("UIStroke", {Parent = Objects["BoxOutlineHolder"], Thickness = 3, LineJoinMode = Enum.LineJoinMode.Miter})
					Objects["BoxOutlineGradient"] = Utility.CreateObject("UIGradient", {Parent = Objects["BoxOutline"], Rotation = 90, Color = ColorSequence_new{ColorSequenceKeypoint_new(0, Color3_fromRGB(0, 0, 0)), ColorSequenceKeypoint_new(1, Color3_fromRGB(0, 0, 0))}, Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, 0), NumberSequenceKeypoint_new(1, 0)}})

					Objects["BoxInlineHolder"] = Utility.CreateObject("Frame", {Parent = Objects["BoxGlow"], Visible = false, BackgroundTransparency = 1, Position = UDim2_new(0, -1, 0, -1), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
					Objects["BoxInline"] = Utility.CreateObject("UIStroke", {Parent = Objects["BoxInlineHolder"], Color = Color3_fromRGB(255, 255, 255), LineJoinMode = Enum.LineJoinMode.Miter})
					Objects["BoxInlineGradient"] = Utility.CreateObject("UIGradient", {Parent = Objects["BoxInline"], Rotation = 90, Color = ColorSequence_new{ColorSequenceKeypoint_new(0, Color3_fromRGB(0, 0, 0)), ColorSequenceKeypoint_new(1, Color3_fromRGB(255, 255, 255))}, Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, 0), NumberSequenceKeypoint_new(1, 0)}})

					Objects["BoxFill"] = Utility.CreateObject("Frame", {Parent = Objects["BoxGlow"], Visible = false, BackgroundTransparency = 0, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
					Objects["BoxFillGradient"] = Utility.CreateObject("UIGradient", {Parent = Objects["BoxFill"], Rotation = 90, Color = ColorSequence_new{ColorSequenceKeypoint_new(0, Color3_fromRGB(0, 0, 0)), ColorSequenceKeypoint_new(1, Color3_fromRGB(255, 255, 255))}, Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, 1), NumberSequenceKeypoint_new(1, 1)}})
				end

				do -- CornerBox
					Objects["CornerHolder"] = Utility.CreateObject("Frame", {Parent = Objects["BoxGlow"], Visible = false, BackgroundTransparency = 1, Position = UDim2_new(0, -1, 0, -1), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(0, 0, 0, 0), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})

					for i = 1, 8 do
						local lp = Layout[i]
						Objects["Line_" .. i] = Utility.CreateObject("Frame", {
							Parent = Objects["CornerHolder"],
							Visible = false,
							BackgroundTransparency = 0,
							Position = lp[1],
							Size = lp[2],
							AnchorPoint = lp[3],
							Rotation = lp[4],
							BorderColor3 = Color3_fromRGB(0, 0, 0),
							BorderSizePixel = 0,
							BackgroundColor3 = Color3_fromRGB(255, 255, 255)
						})
						Utility.CreateObject("UIStroke", {Parent = Objects["Line_" .. i], Thickness = 1, LineJoinMode = Enum.LineJoinMode.Miter})
					end
				end

				do -- Bars
					for BarName, Bar in pairs(ESPSettings.Bars) do
						Objects[BarName .. "Outline"] = Utility.CreateObject("Frame", {Parent = Objects[Bar.Position .. "BarHolder"], ZIndex = 5, LayoutOrder = 0, Visible = true, BackgroundTransparency = 0, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 0, 0, 1), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(0, 0, 0)})
						Utility.CreateObject("UIStroke", {Parent = Objects[BarName .. "Outline"], Thickness = 1, LineJoinMode = Enum.LineJoinMode.Miter})

						Objects[BarName] = Utility.CreateObject("Frame", {Parent = Objects[BarName .. "Outline"], ZIndex = 6, LayoutOrder = 0, Visible = true, BackgroundTransparency = 0, Position = UDim2_new(0, 0, 0, 0), BorderColor3 = Color3_fromRGB(0, 0, 0), Size = UDim2_new(1, 0, 0, 1), BorderSizePixel = 0, BackgroundColor3 = Color3_fromRGB(255, 255, 255)})
						Objects[BarName .. "Gradient"] = Utility.CreateObject("UIGradient", {Parent = Objects[BarName], Rotation = 90, Color = ColorSequence_new{ColorSequenceKeypoint_new(0, Color3_fromRGB(0, 0, 0)), ColorSequenceKeypoint_new(0, Color3_fromRGB(0, 0, 0)), ColorSequenceKeypoint_new(1, Color3_fromRGB(255, 255, 255))}, Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, 0), NumberSequenceKeypoint_new(1, 0)}})
					
						local bText = Utility.CreateObject("TextLabel", {
							Parent = Objects[Bar.Position .. "TextHolder"],
							TextSize = ESPFontSize,
							LayoutOrder = 2,
							TextColor3 = Color3_fromRGB(255, 255, 255),
							Text = "",
							AnchorPoint = Vector2_new(0, 1),
							BorderSizePixel = 0,
							Visible = false,
							BackgroundTransparency = 1,
							ZIndex = 5,
							AutomaticSize = Enum.AutomaticSize.Y,
							Size = UDim2_new(1, 0, 0, 0)
						})
						if ESPFont then pcall(function() bText.FontFace = ESPFont end) end
						Objects[BarName .. "Text"] = bText
						Utility.CreateObject("UIStroke", {Parent = Objects[BarName .. "Text"], Color = Color3_fromRGB(0, 0, 0), LineJoinMode = Enum.LineJoinMode.Miter})
					end
				end

				do -- Texts
					local targetNameLbl = Utility.CreateObject("TextLabel", {
						Parent = Objects["TopTextHolder"],
						TextSize = ESPFontSize,
						LayoutOrder = 2,
						TextColor3 = Color3_fromRGB(255, 255, 255),
						Text = "",
						AnchorPoint = Vector2_new(0, 1),
						BorderSizePixel = 0,
						Visible = false,
						BackgroundTransparency = 1,
						ZIndex = 5,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2_new(1, 0, 0, 0)
					})
					if ESPFont then pcall(function() targetNameLbl.FontFace = ESPFont end) end
					Objects["TargetName"] = targetNameLbl
					Utility.CreateObject("UIStroke", {Parent = Objects["TargetName"], Color = Color3_fromRGB(0, 0, 0), LineJoinMode = Enum.LineJoinMode.Miter})

					local distLbl = Utility.CreateObject("TextLabel", {
						Parent = Objects["BottomTextHolder"],
						TextSize = ESPFontSize,
						LayoutOrder = 2,
						TextColor3 = Color3_fromRGB(255, 255, 255),
						Text = "",
						AnchorPoint = Vector2_new(0, 1),
						BorderSizePixel = 0,
						Visible = false,
						BackgroundTransparency = 1,
						ZIndex = 5,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2_new(1, 0, 0, 0)
					})
					if ESPFont then pcall(function() distLbl.FontFace = ESPFont end) end
					Objects["Distance"] = distLbl
					Utility.CreateObject("UIStroke", {Parent = Objects["Distance"], Color = Color3_fromRGB(0, 0, 0), LineJoinMode = Enum.LineJoinMode.Miter})

					local flagsLbl = Utility.CreateObject("TextLabel", {
						Parent = Objects["RightTextHolder"],
						TextSize = ESPFontSize,
						LayoutOrder = 2,
						TextColor3 = Color3_fromRGB(255, 255, 255),
						Text = "",
						AnchorPoint = Vector2_new(0, 1),
						BorderSizePixel = 0,
						Visible = false,
						BackgroundTransparency = 1,
						ZIndex = 5,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2_new(1, 0, 0, 0)
					})
					if ESPFont then pcall(function() flagsLbl.FontFace = ESPFont end) end
					Objects["Flags"] = flagsLbl
					Utility.CreateObject("UIStroke", {Parent = Objects["Flags"], Color = Color3_fromRGB(0, 0, 0), LineJoinMode = Enum.LineJoinMode.Miter})

					local wepLbl = Utility.CreateObject("TextLabel", {
						Parent = Objects["BottomTextHolder"],
						TextSize = ESPFontSize,
						LayoutOrder = 2,
						TextColor3 = Color3_fromRGB(255, 255, 255),
						Text = "none",
						AnchorPoint = Vector2_new(0, 1),
						BorderSizePixel = 0,
						Visible = false,
						BackgroundTransparency = 1,
						ZIndex = 5,
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2_new(1, 0, 0, 0)
					})
					if ESPFont then pcall(function() wepLbl.FontFace = ESPFont end) end
					Objects["Weapon"] = wepLbl
					Utility.CreateObject("UIStroke", {Parent = Objects["Weapon"], Color = Color3_fromRGB(0, 0, 0), LineJoinMode = Enum.LineJoinMode.Miter})
				end

				if Objects["Highlight"] then
					Objects["Highlight"].Enabled = false
				end
				ESP.Targets[Type][Target] = TargetInfo
			end

			function TargetInfo.Update()
				if not ESPSettings.Enabled then
					Objects["TargetHolder"].Visible = false
					Objects["Highlight"].Enabled = false
					return
				end

				local now = os_clock()
				if (now - LastTick) < (1 / ESPSettings.RefreshRate) then return end
				LastTick = now

				if (not ESPSettings.LocalPlayer) and Target == Client then
					Objects["TargetHolder"].Visible = false
					Objects["Highlight"].Enabled = false
					return
				end
				if not CharacterObjects.Character then
					Objects["TargetHolder"].Visible = false
					Objects["Highlight"].Enabled = false
					return
				end

				if State.Visuals.ESP.TeamCheck and Target ~= Client and Target.Team and Client.Team and Target.Team == Client.Team then
					Objects["TargetHolder"].Visible = false
					Objects["Highlight"].Enabled = false
					return
				end

				if IsPlayer then
					if not CharacterObjects.HumanoidRootPart or not CharacterObjects.HumanoidRootPart.Parent then
						if CharacterObjects.Character then
							CharacterObjects.HumanoidRootPart = FindFirstChild(CharacterObjects.Character, "HumanoidRootPart")
						end
						if not CharacterObjects.HumanoidRootPart then
							Objects["TargetHolder"].Visible = false
							Objects["Highlight"].Enabled = false
							return
						end
					end
					
					if not CharacterObjects.Humanoid or not CharacterObjects.Humanoid.Parent then
						if CharacterObjects.Character then
							CharacterObjects.Humanoid = FindFirstChildWhichIsA(CharacterObjects.Character, "Humanoid")
						end
						if not CharacterObjects.Humanoid or CharacterObjects.Humanoid.Health <= 0 then
							Objects["TargetHolder"].Visible = false
							Objects["Highlight"].Enabled = false
							return
						end
					elseif CharacterObjects.Humanoid.Health <= 0 then
						Objects["TargetHolder"].Visible = false
						Objects["Highlight"].Enabled = false
						return
					end
				else
					if not CharacterObjects.HumanoidRootPart then
						if IsA(Target, "BasePart") then
							CharacterObjects.HumanoidRootPart = Target
						elseif CharacterObjects.Character and CharacterObjects.Character.PrimaryPart then
							CharacterObjects.HumanoidRootPart = CharacterObjects.Character.PrimaryPart
						end
						if not CharacterObjects.HumanoidRootPart then
							Objects["TargetHolder"].Visible = false
							Objects["Highlight"].Enabled = false
							return
						end
					end
				end

				local Distance = (Camera.CFrame.Position - CharacterObjects.HumanoidRootPart.Position).Magnitude
				if Distance > ESPSettings.MaxDistance then
					Objects["TargetHolder"].Visible = false
					Objects["Highlight"].Enabled = false
					return
				end

				local BoxWidth, BoxHeight, BoxPositionX, BoxPositionY, OnScreen = Utility.CalculateBox(ESPSettings, Target, CharacterObjects.HumanoidRootPart, CharacterObjects.Character)
				
				if not OnScreen then
					Objects["TargetHolder"].Visible = false
					Objects["Highlight"].Enabled = false
					return
				end

				local isPriority = State.Targeting.Priority[Target.UserId] == true
				local isFriendPlr = State.Targeting.Friends[Target.UserId] == true

				local BoxSize, BoxPosition = UDim2_fromOffset(math_floor(BoxWidth), math_floor(BoxHeight)), UDim2_fromOffset(math_floor(BoxPositionX), math_floor(BoxPositionY))
				local TargetHolder = Objects["TargetHolder"]
				TargetHolder.Visible = true
				if TargetHolder.Position ~= BoxPosition then TargetHolder.Position = BoxPosition end
				if TargetHolder.Size ~= BoxSize then TargetHolder.Size = BoxSize end

				local BoxOutline, BoxInline, BoxFill, BoxGlow = Objects["BoxOutline"], Objects["BoxInline"], Objects["BoxFill"], Objects["BoxGlow"]
				local BoxEnabled, BoxColor, BoxTransparency, BoxRotation, BoxType = ESPSettings.BoundingBox.Enabled, ESPSettings.BoundingBox.Color, ESPSettings.BoundingBox.Transparency, ESPSettings.BoundingBox.Rotation, ESPSettings.BoundingBox.Type

				local activeBoxColor1 = isPriority and Color3_fromRGB(255, 215, 0) or (isFriendPlr and Color3_fromRGB(0, 230, 180) or BoxColor[1])
				local activeBoxColor2 = isPriority and Color3_fromRGB(255, 215, 0) or (isFriendPlr and Color3_fromRGB(0, 230, 180) or BoxColor[2])

				if BoxEnabled then
					local BoxGlowGradient = Objects["BoxGlowGradient"]
					local BoxGlowEnabled, BoxGlowColor, BoxGlowTransparency, BoxGlowRotation = ESPSettings.BoundingBox.Glow.Enabled, ESPSettings.BoundingBox.Glow.Color, ESPSettings.BoundingBox.Glow.Transparency, ESPSettings.BoundingBox.Glow.Rotation

					if BoxGlowEnabled then
						BoxGlow.ImageTransparency = 0
						BoxGlowGradient.Rotation = BoxGlowRotation
						BoxGlowGradient.Color = ColorSequence_new{ColorSequenceKeypoint_new(0, activeBoxColor1), ColorSequenceKeypoint_new(1, activeBoxColor2)}
						BoxGlowGradient.Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, BoxGlowTransparency[1]), NumberSequenceKeypoint_new(1, BoxGlowTransparency[2])}
					else
						BoxGlow.ImageTransparency = 1
					end

					if BoxType == "2D" then
						BoxOutline.Parent.Visible = true
						BoxOutline.Parent.Size = UDim2_fromOffset(BoxWidth, BoxHeight)
						BoxInline.Parent.Visible = true
						BoxInline.Parent.Size = UDim2_fromOffset(BoxWidth + 2, BoxHeight + 2)

						local BoxInlineGradient, BoxOutlineGradient = Objects["BoxInlineGradient"], Objects["BoxOutlineGradient"]
						BoxInlineGradient.Color = ColorSequence_new{ColorSequenceKeypoint_new(0, activeBoxColor1), ColorSequenceKeypoint_new(1, activeBoxColor2)}
						BoxInlineGradient.Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, BoxTransparency[1]), NumberSequenceKeypoint_new(1, BoxTransparency[2])}
						BoxInlineGradient.Rotation = BoxRotation

						BoxOutlineGradient.Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, BoxTransparency[1]), NumberSequenceKeypoint_new(1, BoxTransparency[2])}
						BoxOutlineGradient.Rotation = BoxRotation

						local BoxFillGradient = Objects["BoxFillGradient"]
						local BoxFillColor, BoxFillTransparency, BoxFillRotation = ESPSettings.BoundingBox.Fill.Color, ESPSettings.BoundingBox.Fill.Transparency, ESPSettings.BoundingBox.Fill.Rotation

						BoxFill.Visible = ESPSettings.BoundingBox.Fill.Enabled
						BoxFill.Size = UDim2_fromOffset(BoxWidth, BoxHeight)
						BoxFillGradient.Rotation = BoxFillRotation
						BoxFillGradient.Color = ColorSequence_new{ColorSequenceKeypoint_new(0, activeBoxColor1), ColorSequenceKeypoint_new(1, activeBoxColor2)}
						BoxFillGradient.Transparency = NumberSequence_new{NumberSequenceKeypoint_new(0, BoxFillTransparency[1]), NumberSequenceKeypoint_new(1, BoxFillTransparency[2])}
						if Objects["CornerHolder"] then Objects["CornerHolder"].Visible = false end
					else
						BoxOutline.Parent.Visible = false
						BoxInline.Parent.Visible = false
						BoxFill.Visible = false

						local CornerHolder = Objects["CornerHolder"]
						CornerHolder.Visible = true
						CornerHolder.Size = UDim2_fromOffset(BoxWidth + 2, BoxHeight + 2)

						for i = 1, 8 do
							local Line = Objects["Line_" .. i]
							Line.UIStroke.Transparency = BoxTransparency[1]
							Line.BackgroundColor3 = activeBoxColor1
							Line.BackgroundTransparency = BoxTransparency[1]
							Line.Visible = true
						end
					end
				else
					BoxGlow.ImageTransparency = 1
					BoxOutline.Parent.Visible = false
					BoxInline.Parent.Visible = false
					BoxFill.Visible = false
					if Objects["CornerHolder"] then Objects["CornerHolder"].Visible = false end

					for i = 1, 8 do
						local Line = Objects["Line_" .. i]
						Line.Visible = false
					end
				end

				for BarName, BarInfo in pairs(ESPSettings.Bars) do
					local Bar, BarOutline, BarGradient = Objects[BarName], Objects[BarName .. "Outline"], Objects[BarName .. "Gradient"]
					local BarEnabled, BarColor = BarInfo.Enabled, BarInfo.Color
					local pos = BarInfo.Position or "Left"
					local NewParent = Objects[pos .. "BarHolder"]

					if BarEnabled and IsPlayer then
						local BarValue = BarInfo.Type(Target, CharacterObjects)
						NewParent.Visible = true

						Bar.AnchorPoint = BAR_ANCHORS[pos] or Vector2_new(0, 1)
						Bar.Position = BAR_POSITIONS[pos] or UDim2_new(0, 0, 1, 0)

						if pos == "Left" or pos == "Right" then
							Bar.Size = UDim2_new(0, 1, BarValue, 0)
							BarOutline.Size = UDim2_new(0, 1, 1, 0)
							BarGradient.Rotation = 90
							BarGradient.Offset = Vector2_new(0, BarValue - 1)
						else
							Bar.Size = UDim2_new(BarValue, 0, 0, 1)
							BarOutline.Size = UDim2_new(1, 0, 0, 1)
							BarGradient.Rotation = -180
							BarGradient.Offset = Vector2_new(1 - BarValue, 0)
						end

						if BarOutline.Parent ~= NewParent then
							BarOutline.Parent = NewParent
						end
						BarGradient.Color = ColorSequence_new{ColorSequenceKeypoint_new(0, BarColor[1]), ColorSequenceKeypoint_new(0.5, BarColor[2]), ColorSequenceKeypoint_new(1, BarColor[3])}
					else
						NewParent.Visible = false
					end

					local BarText = Objects[BarName .. "Text"]
					local BarTextEnabled, BarTextColor, BarTextTransparency = BarInfo.Text.Enabled, BarInfo.Text.Color, BarInfo.Text.Transparency

					if BarTextEnabled and IsPlayer then
						local TextValue, TextVisible = BarInfo.Text.Type(Target, CharacterObjects)

						BarText.Text = tostring(math_floor(TextValue)) .. tostring(BarInfo.Text.Ending)
						BarText.TextColor3 = BarTextColor
						BarText.TextTransparency = BarTextTransparency
						BarText.UIStroke.Transparency = BarTextTransparency

						if BarInfo.Text.FollowBar then
							BarText.Visible = TextVisible
							if BarText.Parent ~= Bar then
								BarText.Parent = Bar
							end
							BarText.ZIndex = 10
							BarText.TextXAlignment = TEXT_ALIGNMENTS[pos] or Enum.TextXAlignment.Center
							BarText.AnchorPoint = TEXT_ANCHORS[pos] or Vector2_new(0.5, 0)
						else
							BarText.Visible = true
							local textHolder = Objects[BarInfo.Text.Position .. "TextHolder"]
							if BarText.Parent ~= textHolder then
								BarText.Parent = textHolder
							end
							BarText.TextXAlignment = TextAlignments[BarInfo.Text.Position]
							BarText.AnchorPoint = Vector2_new(0, 0)
						end
					else
						BarText.Visible = false
					end
				end

				local Chams = Objects["Highlight"]
				local ChamsEnabled, ChamsFill, ChamsOutline = ESPSettings.Chams.Enabled, ESPSettings.Chams.Fill, ESPSettings.Chams.Outline
				
				if ChamsEnabled then
					Chams.Enabled = true
					Chams.DepthMode = ESPSettings.Chams.DepthMode
					Chams.FillColor = isPriority and Color3_fromRGB(255, 215, 0) or (isFriendPlr and Color3_fromRGB(0, 230, 180) or ChamsFill[1])
					Chams.FillTransparency = ChamsFill[2]
					Chams.OutlineColor = ChamsOutline[1]
					Chams.OutlineTransparency = ChamsOutline[2]
				else
					Chams.Enabled = false
				end

				local NameText = Objects["TargetName"]
				local NameEnabled, NameColor, NameTransparency = ESPSettings.Name.Enabled, ESPSettings.Name.Color, ESPSettings.Name.Transparency
				
				if NameEnabled then
					local TargetName = if ESPSettings.Name.UseDisplay then (IsPlayer and Target.DisplayName or Target.Name) else Target.Name

					NameText.Visible = true
					NameText.Text = Utility.GetFontType(ESPSettings, TargetName)
					NameText.TextXAlignment = TextAlignments[ESPSettings.Name.Position]
					NameText.Parent = Objects[ESPSettings.Name.Position .. "TextHolder"]
					NameText.TextColor3 = isPriority and Color3_fromRGB(255, 215, 0) or (isFriendPlr and Color3_fromRGB(0, 230, 180) or NameColor)
					NameText.TextTransparency = NameTransparency
					NameText.UIStroke.Transparency = NameTransparency
				else
					NameText.Visible = false
				end

				local DistanceText = Objects["Distance"]
				local DistanceEnabled, DistanceColor, DistanceTransparency = ESPSettings.Distance.Enabled, ESPSettings.Distance.Color, ESPSettings.Distance.Transparency
				
				if DistanceEnabled then
					DistanceText.Visible = true
					DistanceText.TextXAlignment = TextAlignments[ESPSettings.Distance.Position]
					DistanceText.Parent = Objects[ESPSettings.Distance.Position .. "TextHolder"]
					DistanceText.TextColor3 = DistanceColor
					DistanceText.TextTransparency = DistanceTransparency
					DistanceText.UIStroke.Transparency = DistanceTransparency
					DistanceText.Text = Utility.GetFontType(ESPSettings, tostring(math_floor(Distance)) .. tostring(ESPSettings.Distance.Ending))
				else
					DistanceText.Visible = false
				end

				local WeaponText = Objects["Weapon"]
				local WeaponEnabled, WeaponColor, WeaponTransparency = ESPSettings.Weapon.Enabled, ESPSettings.Weapon.Color, ESPSettings.Weapon.Transparency
				
				if IsPlayer and WeaponEnabled then
					local Tool = PlayerHelper.GetTool(Target) or TargetInfo.CurrentTool

					WeaponText.Visible = true
					WeaponText.TextXAlignment = TextAlignments[ESPSettings.Weapon.Position]
					WeaponText.Parent = Objects[ESPSettings.Weapon.Position .. "TextHolder"]
					WeaponText.TextColor3 = WeaponColor
					WeaponText.TextTransparency = WeaponTransparency
					WeaponText.UIStroke.Transparency = WeaponTransparency
					WeaponText.Text = Utility.GetFontType(ESPSettings, Tool)
				else
					WeaponText.Visible = false
				end

				local FlagsText = Objects["Flags"]
				local FlagsEnabled, FlagsColor, FlagsTransparency = ESPSettings.Flags.Enabled, ESPSettings.Flags.Color, ESPSettings.Flags.Transparency
				
				if FlagsEnabled then
					local Flags = ESPSettings.Flags.Type(Target, CharacterObjects)
					FlagsText.Visible = true
					FlagsText.TextXAlignment = TextAlignments[ESPSettings.Flags.Position]
					FlagsText.Parent = Objects[ESPSettings.Flags.Position .. "TextHolder"]
					FlagsText.TextColor3 = FlagsColor
					FlagsText.TextTransparency = FlagsTransparency
					FlagsText.UIStroke.Transparency = FlagsTransparency
					FlagsText.Text = table_concat(Flags, "\n")
				else
					FlagsText.Visible = false
				end
			end

			function TargetInfo.Remove()
				for _, Object in pairs(Objects) do
					pcall(function() Object:Destroy() end)
				end

				if TargetInfo.CharacterConnection then
					pcall(function() TargetInfo.CharacterConnection:Disconnect() end)
					TargetInfo.CharacterConnection = nil
				end

				if ToolConnection.Added then
					pcall(function() ToolConnection.Added:Disconnect() end)
					ToolConnection.Added = nil
				end

				if ToolConnection.Removed then
					pcall(function() ToolConnection.Removed:Disconnect() end)
					ToolConnection.Removed = nil
				end

				ESP.Targets[Type][Target] = nil
			end
		end

		TargetInfo.Init()
		if TargetInfo.Objects["Highlight"] then
			TargetInfo.Objects["Highlight"].Enabled = false
		end
		if TargetInfo.Objects["TargetHolder"] then
			TargetInfo.Objects["TargetHolder"].Visible = false
		end
	end
	
	function ESP.RemoveTarget(NewTarget, Type)
		for tName, _ in pairs(ESP.Settings) do
			if ESP.Targets[tName] then
				for Target, TargetInfo in pairs(ESP.Targets[tName]) do
					if Target == NewTarget then
						TargetInfo.Remove()
					end
				end
			end
		end
	end

	function ESP.Init()
		for Type, _ in pairs(ESPSettings) do
			if not ESP.Targets[Type] then ESP.Targets[Type] = {} end
		end
	end

	function ESP.Unload()
		for _, Connection in ipairs(ConnectionsTable) do
			pcall(function() Connection:Disconnect() end)
		end
		table_clear(ConnectionsTable)

		for _, Object in ipairs(ObjectsTable) do
			pcall(function() Object:Destroy() end)
		end
		table_clear(ObjectsTable)

		if ESP.Holder then
			pcall(function() ESP.Holder:Destroy() end)
		end

		getgenv().Fonts = nil
	end
end

do -- Connections
	ESP.Init()

	for _, Player in ipairs(Players:GetPlayers()) do
		ESP.AddTarget(Player, "Players")
	end

	Utility.AddConnection(Players.PlayerAdded, function(Player)
		pcall(function() Player.CharacterAdded:Wait() end)
		ESP.AddTarget(Player, "Players")
	end)

	Utility.AddConnection(Players.PlayerRemoving, function(Player)
		ESP.RemoveTarget(Player, "Players")
	end)

	local renderSignal = RunService.PreRender or RunService.RenderStepped
	local playerTargets = ESP.Targets["Players"]
	Utility.AddConnection(renderSignal, function()
		local espSettings = ESPSettings.Players
		if not espSettings or not espSettings.Enabled then return end
		if not playerTargets then
			playerTargets = ESP.Targets["Players"]
			if not playerTargets then return end
		end
		for _, TargetInfo in pairs(playerTargets) do
			TargetInfo.Update()
		end
	end)

	registerCleanup(function()
		if getgenv().ESP and getgenv().ESP.Unload then
			pcall(getgenv().ESP.Unload)
		end
	end)
end
end


local ANIM_DATA = {
	["Zombie"]    = { idle1="10921344533", idle2="10921345304", run="616163682", walk="616168032", jump="616161997", fall="616157476" },
	["Ninja"]     = { idle1="656117400",   idle2="656118341",   run="616118852", walk="656121766", jump="656117878", fall="656115606" },
	["Robot"]     = { idle1="616136790",   idle2="616138447",   run="616140816", walk="616146177", jump="616139451", fall="616134815" },
	["Levitate"]  = { idle1="616006778",   idle2="616008087",   run="616010382", walk="616013216", jump="616008936", fall="616005863" },
	["Cartoony"]  = { idle1="742637544",   idle2="742638445",   run="742638842", walk="742640026", jump="742637942", fall="742637151" },
	["Super Hero"]= { idle1="616111295",   idle2="616113536",   run="616117076", walk="616122287", jump="616115533", fall="616118211" },
	["Elder"]     = { idle1="845397899",   idle2="845400520",   run="845386501", walk="845403856", jump="845398858", fall="845396048" },
	["Toy"]       = { idle1="782841498",   idle2="782845736",   run="782842708", walk="782843345", jump="782847020", fall="782846423" },
	["Old School"]= { idle1="5319828216",  idle2="5319831086",  run="5319844329",walk="5319847204",jump="5319841935",fall="5319839762" },
	["Stylish"]   = { idle1="616136790",   idle2="616138447",   run="616140816", walk="616146177", jump="616139451", fall="616134815" },
	["Default"]   = { idle1="507766388",   idle2="507766666",   run="507767714", walk="507777826", jump="507765000", fall="507767968" }
}

local function applyAnimationPreset(presetName)
	local char = LocalPlayer.Character
	if not char then return end
	local anim = char:FindFirstChild("Animate")
	if not anim then return end
	local pack = ANIM_DATA[presetName] or ANIM_DATA["Default"]

	local function setTrack(path, id)
		local node = anim
		for _, seg in ipairs(path) do
			node = node and node:FindFirstChild(seg)
		end
		if node and node:IsA("Animation") then
			node.AnimationId = "rbxassetid://" .. id
		end
	end

	setTrack({"idle", "Animation1"}, pack.idle1)
	setTrack({"idle", "Animation2"}, pack.idle2)
	setTrack({"run", "RunAnim"}, pack.run)
	setTrack({"walk", "WalkAnim"}, pack.walk)
	setTrack({"jump", "JumpAnim"}, pack.jump)
	setTrack({"fall", "FallAnim"}, pack.fall)

	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
			pcall(function() track:Stop(0) end)
		end
	end
	pcall(function()
		anim.Disabled = true
		task.wait()
		anim.Disabled = false
	end)
end
local function setupAnimationRespawn(char)
	if not char then return end
	task.spawn(function()
		local anim = char:WaitForChild("Animate", 6)
		local hum = char:WaitForChild("Humanoid", 6)
		if anim and hum and State.Client.AnimationChanger and State.Client.SelectedAnimation and State.Client.SelectedAnimation ~= "Default" then
			task.wait(0.2)
			applyAnimationPreset(State.Client.SelectedAnimation)
		end
	end)
end


local lastShotTime = 0
local lastShotTarget = nil

local HIT_SOUND_PRESETS = {
	Rust = "rbxassetid://1255040462",
	Neverlose = "rbxassetid://6534947240",
	Skeet = "rbxassetid://4817809188",
	Bubble = "rbxassetid://6534947588",
	Bell = "rbxassetid://6534947869",
	Hitmarker = "rbxassetid://160432334"
}

local function playHitSound()
	if not State.Client.HitSounds then return end
	local soundId = HIT_SOUND_PRESETS[State.Client.HitSoundPreset]
	if (not soundId or soundId == "") and State.Client.CustomHitSoundId and State.Client.CustomHitSoundId ~= "" then
		soundId = State.Client.CustomHitSoundId
	end
	if not soundId or soundId == "" then soundId = HIT_SOUND_PRESETS.Rust end
	if not soundId:find("rbxassetid://") and tonumber(soundId) then
		soundId = "rbxassetid://" .. soundId
	end

	local s = Instance.new("Sound")
	s.Name = "FutureHitSound"
	s.SoundId = soundId
	s.Volume = (State.Client.HitSoundVolume or 80) / 100
	s.Parent = game:GetService("SoundService")
	s:Play()
	s.Ended:Connect(function()
		s:Destroy()
	end)
	task.delay(2.5, function()
		if s and s.Parent then s:Destroy() end
	end)
end

local function spawnDamageNumber(targetChar, dmg)
	if not State.Client.DamageNumbers or not targetChar then return end
	local anchorPart = targetChar:FindFirstChild("Head") or targetChar:FindFirstChild("HumanoidRootPart")
	if not anchorPart then return end

	local bb = Instance.new("BillboardGui")
	bb.Name = "DamageIndicator"
	bb.Adornee = anchorPart
	bb.Size = UDim2.new(0, 100, 0, 40)
	bb.StudsOffset = v3New(mathRandom(-15, 15) / 10, 2 + mathRandom(0, 10) / 10, mathRandom(-15, 15) / 10)
	bb.AlwaysOnTop = true
	bb.ResetOnSpawn = false

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamBlack
	lbl.TextSize = 20
	lbl.TextColor3 = State.Client.DamageNumbersColor or c3Rgb(255, 75, 114)
	lbl.TextStrokeTransparency = 0
	lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	lbl.Text = "-" .. tostring(dmg)
	lbl.Parent = bb

	local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if playerGui then
		bb.Parent = playerGui
	else
		bb.Parent = Workspace
	end

	local dur = State.Client.DamageDuration or 1.0
	local twService = game:GetService("TweenService")
	local twInfo = TweenInfo.new(dur, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweenOffset = twService:Create(bb, twInfo, { StudsOffset = bb.StudsOffset + v3New(0, 3, 0) })
	local tweenFade = twService:Create(lbl, twInfo, { TextTransparency = 1, TextStrokeTransparency = 1 })

	tweenOffset:Play()
	tweenFade:Play()
	task.delay(dur, function()
		bb:Destroy()
	end)
end

local function onEnemyHitRegistered(plr, dmg, char)
	playHitSound()
	spawnDamageNumber(char, dmg)
	if State.Client.HitNotifications then
		Window:Notify({
			Title = "Hit Confirmed",
			Description = (plr and plr.Name or "Enemy") .. " hit for -" .. tostring(dmg) .. " HP",
			Duration = 1.5
		})
	end
end

local enemyHealthMap = {}
local function trackEnemyHealth(plr)
	if plr == LocalPlayer then return end
	local function onChar(char)
		if not char then return end
		local hum = char:WaitForChild("Humanoid", 5)
		if not hum then return end
		enemyHealthMap[plr] = hum.Health
		hum.HealthChanged:Connect(function(newHealth)
			local oldHealth = enemyHealthMap[plr] or hum.MaxHealth
			enemyHealthMap[plr] = newHealth
			local delta = oldHealth - newHealth
			if delta > 0.5 then
				local timeSinceShot = tick() - lastShotTime
				local isTarget = (lastShotTarget == plr) or (silentTarget.Player == plr) or (camlockTarget.Player == plr)
				if isTarget and timeSinceShot < 0.65 then
					onEnemyHitRegistered(plr, mathFloor(delta + 0.5), char)
				elseif timeSinceShot < 0.3 then
					onEnemyHitRegistered(plr, mathFloor(delta + 0.5), char)
				end
			end
		end)
	end
	if plr.Character then onChar(plr.Character) end
	plr.CharacterAdded:Connect(onChar)
end

for _, p in ipairs(Players:GetPlayers()) do
	trackEnemyHealth(p)
end
Players.PlayerAdded:Connect(trackEnemyHealth)

local function hookLocalTools(char)
	if not char then return end
	for _, child in ipairs(char:GetChildren()) do
		if child:IsA("Tool") then
			child.Activated:Connect(function()
				lastShotTime = tick()
				if silentTarget.Player then lastShotTarget = silentTarget.Player end
			end)
		end
	end
	char.ChildAdded:Connect(function(child)
		if child:IsA("Tool") then
			child.Activated:Connect(function()
				lastShotTime = tick()
				if silentTarget.Player then lastShotTarget = silentTarget.Player end
			end)
		end
	end)
end

local function onCharacterSpawn(char)
	if not char then return end
	onCharacterAddedSpeedJump(char)
	stopFakeMacro()
	bindToolTracking(char)
	setupAnimationRespawn(char)
	hookLocalTools(char)
end

registerCleanup(LocalPlayer.CharacterAdded:Connect(onCharacterSpawn))
if LocalPlayer.Character then
	task.spawn(function()
		onCharacterSpawn(LocalPlayer.Character)
	end)
end


local lastTriggerTime = 0

registerCleanup(RunService.RenderStepped:Connect(function()
	resolveCamlockTarget()

	if isSilentAimActive() then
		local targetPlr, targetPart = getClosestSilentTarget()
		if targetPlr and targetPart then
			silentTarget.Player = targetPlr
			silentTarget.Part = targetPart
		else
			silentTarget.Player = nil
			silentTarget.Part = nil
		end
	else
		silentTarget.Player = nil
		silentTarget.Part = nil
	end

	if State.Aiming.Camlock.Enabled and State.Aiming.Camlock.Active and camlockTarget.Part then
		local part = camlockTarget.Part
		local cPred = State.Aiming.Camlock.Prediction
		local cPredActive = (cPred and cPred ~= "Off" and cPred ~= false)

		local useRecalc = (State.Aiming.Camlock.Resolver and State.Aiming.Camlock.ResolverMode == "Recalculation")
		local vel = getEffectiveVelocity(camlockTarget.Player, camlockTarget.Part, State.Aiming.Camlock.Resolver, State.Aiming.Camlock.ResolverMode, useRecalc)

		local predOffset = v3Zero
		if cPredActive then
			local pAmt = State.Aiming.Camlock.PredictionAmount or 0.138
			if cPred == "Directional" then
				local predX = (vel.X > 0) and (State.Aiming.Camlock.PredictionX_Right or pAmt)
				              or (State.Aiming.Camlock.PredictionX_Left or pAmt)
				local predY = (vel.Y > 0) and (State.Aiming.Camlock.PredictionY_Up or pAmt)
				              or (State.Aiming.Camlock.PredictionY_Down or pAmt)
				local predZ = State.Aiming.Camlock.PredictionZ or pAmt
				predOffset = v3New(vel.X * predX, vel.Y * predY, vel.Z * predZ)
			elseif cPred == "Auto" then
				local ping = 50
				pcall(function()
					local statsItem = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
					if statsItem then
						local str = statsItem:GetValueString()
						local val = tonumber(string.match(str, "%d+"))
						if val then ping = val end
					end
				end)
				local autoPred = mathClamp(ping * 0.0016, 0.05, 0.28)
				predOffset = vel * autoPred
			else
				predOffset = vel * pAmt
			end
		end
		local targetPos = part.Position + predOffset

		if State.Aiming.Camlock.Shake then
			local sAmt = State.Aiming.Camlock.ShakeAmount / 100
			targetPos = targetPos + v3New(mathRandom(-10, 10), mathRandom(-10, 10), mathRandom(-10, 10)) * sAmt
		end

		local smooth = mathClamp(State.Aiming.Camlock.Smoothness or 1, 0.01, 1)

		if State.Aiming.Camlock.Method == "CFrame" then
			if smooth >= 1 then
				Camera.CFrame = cfLookAt(Camera.CFrame.Position, targetPos)
			else
				Camera.CFrame = Camera.CFrame:Lerp(cfLookAt(Camera.CFrame.Position, targetPos), smooth)
			end
		elseif State.Aiming.Camlock.Method == "mousemoverel" and mousemoverel then
			local sp, onScreen = Camera:WorldToViewportPoint(targetPos)
			if onScreen then
				local mPos = UserInputService:GetMouseLocation()
				local dx = (sp.X - mPos.X) * smooth
				local dy = (sp.Y - mPos.Y) * smooth
				mousemoverel(dx, dy)
			end
		end
	end
	local mPos = UserInputService:GetMouseLocation()
	local screenCenter = Camera.ViewportSize / 2
	local mouseBehavior = UserInputService.MouseBehavior
	local isMouseLocked = (mouseBehavior == Enum.MouseBehavior.LockCenter or mouseBehavior == Enum.MouseBehavior.LockCurrentPosition)

	if camFovCircle then
		camFovCircle.Visible = State.Aiming.Camlock.Enabled and State.Aiming.Camlock.ShowFOV
		camFovCircle.Radius = State.Aiming.Camlock.FOVRadius
		local camPos = (State.Aiming.Camlock.FOVOrigin == "Screen Center" or isMouseLocked) and screenCenter or mPos
		camFovCircle.Position = camPos
		camFovCircle.Color = State.Aiming.Camlock.FOVColor
	end
	if silentFovCircle then
		local syncWithCamlock = State.Aiming.Silent.SyncFOV and State.Aiming.Camlock.Enabled
		local sRadius = syncWithCamlock and State.Aiming.Camlock.FOVRadius or State.Aiming.Silent.FOVRadius
		local sVis = State.Aiming.Silent.Enabled and State.Aiming.Silent.ShowFOV and (not syncWithCamlock or not (State.Aiming.Camlock.Enabled and State.Aiming.Camlock.ShowFOV))
		silentFovCircle.Visible = sVis
		silentFovCircle.Radius = sRadius
		local originPref = syncWithCamlock and State.Aiming.Camlock.FOVOrigin or State.Aiming.Silent.FOVOrigin
		local sPos = (originPref == "Screen Center" or isMouseLocked) and screenCenter or mPos
		silentFovCircle.Position = sPos
		silentFovCircle.Color = State.Aiming.Silent.FOVColor
	end

	if targetTracer then
		local silentPart = (isSilentAimActive() and silentTarget.Part) or nil
		local shouldShowTracer = State.Aiming.Silent.TargetTracer and silentPart ~= nil
		if shouldShowTracer then
			local sp, onScreen = Camera:WorldToViewportPoint(silentPart.Position)
			if onScreen then
				local origin = State.Aiming.Silent.TracerOrigin or "Bottom"
				local fromPos
				if origin == "Screen Center" then
					fromPos = Camera.ViewportSize / 2
				elseif origin == "Mouse" then
					fromPos = mPos
				else
					fromPos = v2New(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
				end
				targetTracer.From = fromPos
				targetTracer.To = v2New(sp.X, sp.Y)
				targetTracer.Color = State.Aiming.Silent.TracerColor or c3Rgb(255, 75, 114)
				targetTracer.Thickness = State.Aiming.Silent.TracerThickness or 1.5
				targetTracer.Visible = true
			else
				targetTracer.Visible = false
			end
		else
			targetTracer.Visible = false
		end
	end

	if State.Aiming.Triggerbot.Enabled and (State.Aiming.Triggerbot.Keybind == Enum.KeyCode.Unknown or State.Aiming.Triggerbot.Active) then
		local onlySilent = State.Aiming.Triggerbot.OnlyWhenSilent
		local onlyLock = State.Aiming.Triggerbot.OnlyWhenLock
		local hasSilent = State.Aiming.Silent.Enabled and silentTarget.Player and silentTarget.Part
		local hasLock = State.Aiming.Camlock.Enabled and State.Aiming.Camlock.Active and camlockTarget.Player and camlockTarget.Part

		local allowTrigger = true
		if onlySilent and onlyLock then
			if not hasSilent and not hasLock then allowTrigger = false end
		elseif onlySilent then
			if not hasSilent then allowTrigger = false end
		elseif onlyLock then
			if not hasLock then allowTrigger = false end
		end

		if allowTrigger and (tick() - lastTriggerTime) >= (State.Aiming.Triggerbot.Delay / 1000) then
			local currentTool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
			local toolRange = getToolRange(currentTool)
			local effectiveRange = toolRange or 1000

			local shouldFire = false
			local hitTargetPlr = nil

			local function isTriggerTargetValid(plr, char, part)
				if not plr or not char or plr == LocalPlayer then return false end
				local hum = char:FindFirstChildOfClass("Humanoid")
				if not hum or hum.Health <= 0 then return false end
				if State.Aiming.Triggerbot.KOCheck and isKnocked(char) then return false end
				if State.Aiming.Triggerbot.GrabbedCheck and isGrabbed(char) then return false end
				if State.Aiming.Triggerbot.FriendCheck and isFriend(plr) then return false end
				if State.Aiming.Triggerbot.CrewCheck and isCrew(plr) then return false end
				if State.Aiming.Triggerbot.TeamCheck and (plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team) then return false end
				if State.Aiming.Triggerbot.ForceFieldCheck and hasForceField(char) then return false end
				if State.Aiming.Triggerbot.WallCheck and part and not isVisible(part, Camera.CFrame.Position) then return false end
				return true
			end

			if hasSilent and (onlySilent or State.Aiming.Triggerbot.FireOnSilentTarget) then
				local sPlr = silentTarget.Player
				local sChar = sPlr.Character
				if isTriggerTargetValid(sPlr, sChar, silentTarget.Part) then
					local dist3D = (silentTarget.Part.Position - Camera.CFrame.Position).Magnitude
					if dist3D <= effectiveRange then
						shouldFire = true
						hitTargetPlr = sPlr
					end
				end
			end

			if not shouldFire and hasLock and onlyLock then
				local lPlr = camlockTarget.Player
				local lChar = lPlr.Character
				if isTriggerTargetValid(lPlr, lChar, camlockTarget.Part) then
					local dist3D = (camlockTarget.Part.Position - Camera.CFrame.Position).Magnitude
					if dist3D <= effectiveRange then
						shouldFire = true
						hitTargetPlr = lPlr
					end
				end
			end

			if not shouldFire and not onlySilent and not onlyLock then
				local unitRay = Camera:ViewportPointToRay(mPos.X, mPos.Y)
				rayParams.FilterDescendantsInstances = { Camera, LocalPlayer.Character }
				local res = Workspace:Raycast(unitRay.Origin, unitRay.Direction * effectiveRange, rayParams)
				if res and res.Instance then
					local charRoot = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Head"))
					local originPos = charRoot and charRoot.Position or unitRay.Origin
					local hitDist = (res.Position - originPos).Magnitude
					if hitDist <= effectiveRange then
						local hitChar = res.Instance:FindFirstAncestorOfClass("Model")
						local hitPlr = hitChar and Players:GetPlayerFromCharacter(hitChar)
						if hitPlr and isTriggerTargetValid(hitPlr, hitChar, res.Instance) then
							shouldFire = true
							hitTargetPlr = hitPlr
						end
					end
				end
			end

			if not shouldFire and not onlySilent and not onlyLock and State.Aiming.Triggerbot.TolerancePX and State.Aiming.Triggerbot.TolerancePX > 0 then
				local tol = State.Aiming.Triggerbot.TolerancePX
				local closestDist = tol
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= LocalPlayer and plr.Character then
						local char = plr.Character
						if isTriggerTargetValid(plr, char, nil) then
							local parts = {char:FindFirstChild("Head"), char:FindFirstChild("HumanoidRootPart"), char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")}
							for _, p in ipairs(parts) do
								if p and p:IsA("BasePart") then
									local dist3D = (p.Position - Camera.CFrame.Position).Magnitude
									if dist3D <= effectiveRange then
										local sp, onScreen = Camera:WorldToViewportPoint(p.Position)
										if onScreen then
											local screenDist = (v2New(sp.X, sp.Y) - mPos).Magnitude
											if screenDist <= closestDist then
												if not State.Aiming.Triggerbot.WallCheck or isVisible(p, Camera.CFrame.Position) then
													closestDist = screenDist
													shouldFire = true
													hitTargetPlr = plr
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end

			if shouldFire then
				lastTriggerTime = tick()
				lastShotTime = tick()
				lastShotTarget = hitTargetPlr
				if State.Aiming.Triggerbot.Method == "tool:Activate()" then
					if currentTool then currentTool:Activate() end
				elseif mouse1click then
					mouse1click()
				end
			end
		end
	end

	updateWorldCrosshair()
end))

RunService.Stepped:Connect(function()
	if State.Client.Noclip then
		local char = LocalPlayer.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide then
					part.CanCollide = false
				end
			end
		end
	end
end)

UserInputService.JumpRequest:Connect(function()
	if State.Movement.InfiniteJump then
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then return end
	if State.Aiming.Camlock.Enabled and matchesKey(input, State.Aiming.Camlock.Keybind) then
		if State.Aiming.Camlock.Mode == "Toggle" then
			State.Aiming.Camlock.Active = not State.Aiming.Camlock.Active
		elseif State.Aiming.Camlock.Mode == "Hold" then
			State.Aiming.Camlock.Active = true
		end
	end
	if State.Aiming.Silent.Enabled and matchesKey(input, State.Aiming.Silent.Keybind) then
		if State.Aiming.Silent.Mode == "Toggle" then
			State.Aiming.Silent.Active = not State.Aiming.Silent.Active
		elseif State.Aiming.Silent.Mode == "Hold" then
			State.Aiming.Silent.Active = true
		end
	end
	if State.Aiming.Triggerbot.Enabled and matchesKey(input, State.Aiming.Triggerbot.Keybind) then
		State.Aiming.Triggerbot.Active = true
	end
	if State.Movement.FakeMacro and matchesKey(input, State.Movement.MacroKey) then
		if State.Movement.MacroMode == "Toggle" then
			if macroRunning then
				stopFakeMacro()
			else
				startFakeMacro()
			end
		else
			startFakeMacro()
			end
	end

end)

UserInputService.InputEnded:Connect(function(input, processed)
	if State.Aiming.Camlock.Enabled and matchesKey(input, State.Aiming.Camlock.Keybind) and State.Aiming.Camlock.Mode == "Hold" then
		State.Aiming.Camlock.Active = false
	end
	if State.Aiming.Silent.Enabled and matchesKey(input, State.Aiming.Silent.Keybind) and State.Aiming.Silent.Mode == "Hold" then
		State.Aiming.Silent.Active = false
	end
	if State.Movement.FakeMacro and matchesKey(input, State.Movement.MacroKey) and State.Movement.MacroMode ~= "Toggle" then
		stopFakeMacro()
	end
	if State.Aiming.Triggerbot.Enabled and matchesKey(input, State.Aiming.Triggerbot.Keybind) then
		State.Aiming.Triggerbot.Active = false
	end

end)

Window = FutureClub:CreateWindow({
	Title = "future.club",
	ToggleKey = Enum.KeyCode.P,
	SidebarHourglass = true,
	MobileButton = true,
	ShowWatermark = true,
	ShowKeybindList = false
})

local AimingTab = Window:CreateTab({ Name = "Aiming", Icon = "combat" })
local VisualsTab = Window:CreateTab({ Name = "Visuals", Icon = "visuals" })
local ClientTab = Window:CreateTab({ Name = "Client", Icon = "player" })
local MovementTab = Window:CreateTab({ Name = "Movement", Icon = "move" })
local TargetingTab = Window:CreateTab({ Name = "Targeting", Icon = "friends" })
local ConfigsTab = Window:CreateTab({ Name = "Configs", Icon = "configs" })
local SettingsTab = Window:CreateTab({ Name = "Settings", Icon = "settings" })

do
local camlockMod = AimingTab:CreateModule({
	Name = "Camlock",
	Default = false,
	Callback = function(val)
		State.Aiming.Camlock.Enabled = val
		if not val then State.Aiming.Camlock.Active = false end
	end
})

camlockMod:CreateDropdown({
	Name = "Method",
	Options = {"CFrame", "mousemoverel"},
	Default = "CFrame",
	Callback = function(val) State.Aiming.Camlock.Method = val end
})

camlockMod:CreateDropdown({
	Name = "Mode",
	Options = {"Toggle", "Hold"},
	Default = "Toggle",
	Callback = function(val) State.Aiming.Camlock.Mode = val end
})

camlockMod:CreateKeybind({
	Name = "Keybind",
	Default = Enum.KeyCode.C,
	Mode = "Toggle",
	BindModule = false,
	Callback = function(key) State.Aiming.Camlock.Keybind = key end
})

camlockMod:CreateDropdown({
	Name = "Target Part",
	Options = {"Head", "HumanoidRootPart", "UpperTorso", "Closest Part"},
	Default = "Head",
	Callback = function(val) State.Aiming.Camlock.TargetPart = val end
})

camlockMod:CreateDropdown({
	Name = "FOV Origin",
	Options = {"Mouse Location", "Screen Center"},
	Default = "Mouse Location",
	Callback = function(val)
		State.Aiming.Camlock.FOVOrigin = (val == "Screen Center" and "Screen Center" or "Mouse")
	end
})

camlockMod:CreateDropdown({
	Name = "Prediction",
	Options = {"Off", "Static", "Directional", "Auto"},
	Default = "Off",
	Callback = function(val) State.Aiming.Camlock.Prediction = val end
})

camlockMod:CreateSlider({
	Name = "Prediction Amount",
	Min = 0.01,
	Max = 0.35,
	Default = 0.138,
	Precision = 0.001,
	Callback = function(val) State.Aiming.Camlock.PredictionAmount = val end
})

camlockMod:CreateSlider({
	Name = "Prediction X (Right)",
	Min = 0.05,
	Max = 0.35,
	Default = 0.138,
	Precision = 0.001,
	Callback = function(val) State.Aiming.Camlock.PredictionX_Right = val end
})

camlockMod:CreateSlider({
	Name = "Prediction X (Left)",
	Min = 0.05,
	Max = 0.35,
	Default = 0.138,
	Precision = 0.001,
	Callback = function(val) State.Aiming.Camlock.PredictionX_Left = val end
})

camlockMod:CreateSlider({
	Name = "Prediction Y (Up)",
	Min = 0.05,
	Max = 0.35,
	Default = 0.138,
	Precision = 0.001,
	Callback = function(val) State.Aiming.Camlock.PredictionY_Up = val end
})

camlockMod:CreateSlider({
	Name = "Prediction Y (Down)",
	Min = 0.05,
	Max = 0.35,
	Default = 0.138,
	Precision = 0.001,
	Callback = function(val) State.Aiming.Camlock.PredictionY_Down = val end
})

camlockMod:CreateSlider({
	Name = "Prediction Z",
	Min = 0.05,
	Max = 0.35,
	Default = 0.138,
	Precision = 0.001,
	Callback = function(val) State.Aiming.Camlock.PredictionZ = val end
})

camlockMod:CreateToggle({
	Name = "Resolver",
	Default = false,
	Callback = function(val) State.Aiming.Camlock.Resolver = val end
})

camlockMod:CreateDropdown({
	Name = "Resolver Mode",
	Options = {"Recalculation", "MoveDirection", "LookVector"},
	Default = "Recalculation",
	Callback = function(val) State.Aiming.Camlock.ResolverMode = val end
})

camlockMod:CreateToggle({
	Name = "Unlock Upon Death",
	Default = false,
	Callback = function(val) State.Aiming.Camlock.UnlockUponDeath = val end
})

camlockMod:CreateSlider({
	Name = "Smoothness",
	Min = 0.01,
	Max = 1.00,
	Default = 0.20,
	Precision = 0.01,
	Callback = function(val) State.Aiming.Camlock.Smoothness = val end
})

camlockMod:CreateToggle({
	Name = "Shake",
	Default = false,
	Callback = function(val) State.Aiming.Camlock.Shake = val end
})

camlockMod:CreateSlider({
	Name = "Shake Amount",
	Min = 1,
	Max = 50,
	Default = 15,
	Precision = 1,
	Callback = function(val) State.Aiming.Camlock.ShakeAmount = val end
})

camlockMod:CreateToggle({
	Name = "Wall Check",
	Default = false,
	Callback = function(val) State.Aiming.Camlock.WallCheck = val end
})

camlockMod:CreateToggle({
	Name = "KO Check",
	Default = false,
	Callback = function(val) State.Aiming.Camlock.KOCheck = val end
})

camlockMod:CreateToggle({
	Name = "Grabbed Check",
	Default = false,
	Callback = function(val) State.Aiming.Camlock.GrabbedCheck = val end
})

camlockMod:CreateToggle({
	Name = "Friend Check",
	Default = false,
	Callback = function(val) State.Aiming.Camlock.FriendCheck = val end
})

camlockMod:CreateToggle({
	Name = "Crew Check",
	Default = false,
	Callback = function(val) State.Aiming.Camlock.CrewCheck = val end
})

camlockMod:CreateToggle({
	Name = "Forcefield Check",
	Default = false,
	Callback = function(val) State.Aiming.Camlock.ForceFieldCheck = val end
})

camlockMod:CreateToggle({
	Name = "Show FOV",
	Default = false,
	Callback = function(val) State.Aiming.Camlock.ShowFOV = val end
})

camlockMod:CreateSlider({
	Name = "FOV Radius",
	Min = 20,
	Max = 400,
	Default = 120,
	Precision = 5,
	Unit = "px",
	Callback = function(val) State.Aiming.Camlock.FOVRadius = val end
})

camlockMod:CreateColorPicker({
	Name = "FOV Color",
	Default = c3Rgb(255, 75, 114),
	Callback = function(col) State.Aiming.Camlock.FOVColor = col end
})

camlockMod:CreateToggle({
	Name = "Sticky Aim",
	Default = false,
	Callback = function(val) State.Aiming.Camlock.StickyAim = val end
})

end

do
local silentMod = AimingTab:CreateModule({
	Name = "Silent Aim",
	Default = false,
	Callback = function(val) State.Aiming.Silent.Enabled = val end
})

silentMod:CreateDropdown({
	Name = "Mode",
	Options = {"Always On", "Toggle", "Hold"},
	Default = "Always On",
	Callback = function(val) State.Aiming.Silent.Mode = val end
})

silentMod:CreateKeybind({
	Name = "Keybind",
	Default = Enum.KeyCode.Unknown,
	Mode = "Hold",
	BindModule = false,
	Callback = function(key) State.Aiming.Silent.Keybind = key end
})

silentMod:CreateDropdown({
	Name = "Target Part",
	Options = {"Closest Part", "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
	Default = "Closest Part",
	Callback = function(val) State.Aiming.Silent.TargetPart = val end
})

silentMod:CreateDropdown({
	Name = "FOV Origin",
	Options = {"Mouse", "Screen Center"},
	Default = "Mouse",
	Callback = function(val) State.Aiming.Silent.FOVOrigin = val end
})

silentMod:CreateSlider({
	Name = "Hit Chance",
	Min = 0,
	Max = 100,
	Default = 100,
	Precision = 1,
	Unit = "%",
	Callback = function(val) State.Aiming.Silent.HitChance = val end
})

silentMod:CreateToggle({
	Name = "Wall Check",
	Default = false,
	Callback = function(val) State.Aiming.Silent.WallCheck = val end
})

silentMod:CreateToggle({
	Name = "K.O. Check",
	Default = false,
	Callback = function(val) State.Aiming.Silent.KOCheck = val end
})

silentMod:CreateToggle({
	Name = "Grabbed Check",
	Default = false,
	Callback = function(val) State.Aiming.Silent.GrabbedCheck = val end
})

silentMod:CreateToggle({
	Name = "Friend Check",
	Default = false,
	Callback = function(val) State.Aiming.Silent.FriendCheck = val end
})

silentMod:CreateToggle({
	Name = "Crew Check",
	Default = false,
	Callback = function(val) State.Aiming.Silent.CrewCheck = val end
})

silentMod:CreateToggle({
	Name = "Forcefield Check",
	Default = false,
	Callback = function(val) State.Aiming.Silent.ForceFieldCheck = val end
})

silentMod:CreateSlider({
	Name = "Shotgun Spread",
	Min = 0,
	Max = 25,
	Default = 6,
	Precision = 1,
	Unit = " deg",
	Callback = function(val) State.Aiming.Silent.ShotgunSpread = val end
})

silentMod:CreateToggle({
	Name = "Spread Modifier",
	Default = false,
	Callback = function(val) State.Aiming.Silent.SpreadModEnabled = val end
})

silentMod:CreateSlider({
	Name = "Spread Amount",
	Min = 0,
	Max = 100,
	Default = 0,
	Precision = 1,
	Unit = "%",
	Callback = function(val) State.Aiming.Silent.SpreadAmount = val end
})

silentMod:CreateToggle({
	Name = "Shotguns Only",
	Default = true,
	Callback = function(val) State.Aiming.Silent.SpreadSpecificOnly = val end
})

silentMod:CreateToggle({
	Name = "Sync FOV",
	Default = true,
	Callback = function(val) State.Aiming.Silent.SyncFOV = val end
})

silentMod:CreateToggle({
	Name = "Show FOV",
	Default = false,
	Callback = function(val) State.Aiming.Silent.ShowFOV = val end
})

silentMod:CreateSlider({
	Name = "FOV Radius",
	Min = 20,
	Max = 400,
	Default = 150,
	Precision = 5,
	Unit = "px",
	Callback = function(val) State.Aiming.Silent.FOVRadius = val end
})

silentMod:CreateColorPicker({
	Name = "FOV Color",
	Default = c3Rgb(255, 75, 114),
	Callback = function(col) State.Aiming.Silent.FOVColor = col end
})

silentMod:CreateToggle({
	Name = "Camlock Target Only",
	Default = false,
	Callback = function(val) State.Aiming.Silent.TargetCamlockOnly = val end
})

silentMod:CreateToggle({
	Name = "Tracer",
	Default = false,
	Callback = function(val) State.Aiming.Silent.TargetTracer = val end
})

silentMod:CreateDropdown({
	Name = "Tracer Origin",
	Options = {"Bottom", "Screen Center", "Mouse"},
	Default = "Bottom",
	Callback = function(val) State.Aiming.Silent.TracerOrigin = val end
})

silentMod:CreateColorPicker({
	Name = "Tracer Color",
	Default = c3Rgb(255, 75, 114),
	Callback = function(col) State.Aiming.Silent.TracerColor = col end
})

silentMod:CreateSlider({
	Name = "Tracer Thickness",
	Min = 1,
	Max = 5,
	Default = 1.5,
	Precision = 0.5,
	Unit = "px",
	Callback = function(val) State.Aiming.Silent.TracerThickness = val end
})

end

do
local triggerMod = AimingTab:CreateModule({
	Name = "Triggerbot",
	Default = false,
	Callback = function(val) State.Aiming.Triggerbot.Enabled = val end
})

triggerMod:CreateDropdown({
	Name = "Method",
	Options = {"tool:Activate()", "mouse1click"},
	Default = "tool:Activate()",
	Callback = function(val) State.Aiming.Triggerbot.Method = val end
})

triggerMod:CreateSlider({
	Name = "Fire Delay",
	Min = 10,
	Max = 300,
	Default = 50,
	Precision = 5,
	Unit = "ms",
	Callback = function(val) State.Aiming.Triggerbot.Delay = val end
})

triggerMod:CreateSlider({
	Name = "Pixel Tolerance",
	Min = 0,
	Max = 150,
	Default = 0,
	Precision = 5,
	Unit = "px",
	Callback = function(val) State.Aiming.Triggerbot.TolerancePX = val end
})

triggerMod:CreateToggle({
	Name = "Only When Silent",
	Default = false,
	Callback = function(val) State.Aiming.Triggerbot.OnlyWhenSilent = val end
})

triggerMod:CreateToggle({
	Name = "Only When Lock",
	Default = false,
	Callback = function(val) State.Aiming.Triggerbot.OnlyWhenLock = val end
})

triggerMod:CreateToggle({
	Name = "Fire on Silent",
	Default = false,
	Callback = function(val) State.Aiming.Triggerbot.FireOnSilentTarget = val end
})

triggerMod:CreateKeybind({
	Name = "Keybind",
	Default = Enum.KeyCode.Unknown,
	Mode = "Hold",
	Callback = function(key) State.Aiming.Triggerbot.Keybind = key end
})

triggerMod:CreateToggle({
	Name = "Wall Check",
	Default = false,
	Callback = function(val) State.Aiming.Triggerbot.WallCheck = val end
})

triggerMod:CreateToggle({
	Name = "KO Check",
	Default = false,
	Callback = function(val) State.Aiming.Triggerbot.KOCheck = val end
})

triggerMod:CreateToggle({
	Name = "Grabbed Check",
	Default = false,
	Callback = function(val) State.Aiming.Triggerbot.GrabbedCheck = val end
})

triggerMod:CreateToggle({
	Name = "Friend Check",
	Default = false,
	Callback = function(val) State.Aiming.Triggerbot.FriendCheck = val end
})

triggerMod:CreateToggle({
	Name = "Crew Check",
	Default = false,
	Callback = function(val) State.Aiming.Triggerbot.CrewCheck = val end
})

triggerMod:CreateToggle({
	Name = "Team Check",
	Default = false,
	Callback = function(val) State.Aiming.Triggerbot.TeamCheck = val end
})

triggerMod:CreateToggle({
	Name = "Forcefield Check",
	Default = false,
	Callback = function(val) State.Aiming.Triggerbot.ForceFieldCheck = val end
})

end

do
local espMod = VisualsTab:CreateModule({
	Name = "Player ESP",
	Default = false,
	Callback = function(val)
		State.Visuals.ESP.Enabled = val
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.Enabled = val
		end
		if not val and getgenv().ESP and getgenv().ESP.Targets and getgenv().ESP.Targets.Players then
			for _, t in pairs(getgenv().ESP.Targets.Players) do
				if t.Objects then
					if t.Objects["TargetHolder"] then t.Objects["TargetHolder"].Visible = false end
					if t.Objects["Highlight"] then t.Objects["Highlight"].Enabled = false end
				end
			end
		end
		Window:UpdateESPPreview({ Boxes = State.Visuals.ESP.Boxes })
	end
})

espMod:CreateToggle({
	Name = "Boxes",
	Default = false,
	Callback = function(val)
		State.Visuals.ESP.Boxes = val
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.BoundingBox.Enabled = val
		end
		Window:UpdateESPPreview({ Boxes = val })
	end
})

espMod:CreateDropdown({
	Name = "Box Style",
	Options = {"Corner", "2D"},
	Default = "Corner",
	Callback = function(val)
		State.Visuals.ESP.BoxStyle = val
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.BoundingBox.Type = val
		end
		Window:UpdateESPPreview({ BoxStyle = (val == "2D" and "Full" or "Corner") })
	end
})

espMod:CreateToggle({
	Name = "Box Fill",
	Default = false,
	Callback = function(val)
		State.Visuals.ESP.BoxFill = val
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.BoundingBox.Fill.Enabled = val
		end
		Window:UpdateESPPreview({ BoxFill = val })
	end
})

espMod:CreateToggle({
	Name = "Box Glow",
	Default = false,
	Callback = function(val)
		State.Visuals.ESP.BoxGlow = val
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.BoundingBox.Glow.Enabled = val
		end
	end
})

espMod:CreateToggle({
	Name = "Names",
	Default = false,
	Callback = function(val)
		State.Visuals.ESP.Names = val
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.Name.Enabled = val
		end
		Window:UpdateESPPreview({ Names = val })
	end
})

espMod:CreateToggle({
	Name = "Health Bar",
	Default = false,
	Callback = function(val)
		State.Visuals.ESP.HealthBar = val
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.Bars.HealthBar.Enabled = val
			getgenv().ESP.Settings.Players.Bars.HealthBar.Text.Enabled = val
		end
		Window:UpdateESPPreview({ HealthBar = val })
	end
})

espMod:CreateToggle({
	Name = "Armor Bar",
	Default = false,
	Callback = function(val)
		State.Visuals.ESP.ArmorBar = val
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.Bars.ArmorBar.Enabled = val
			getgenv().ESP.Settings.Players.Bars.ArmorBar.Text.Enabled = val
		end
	end
})

espMod:CreateToggle({
	Name = "Distance",
	Default = false,
	Callback = function(val)
		State.Visuals.ESP.Distance = val
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.Distance.Enabled = val
		end
		Window:UpdateESPPreview({ Distance = val })
	end
})

espMod:CreateToggle({
	Name = "Weapon",
	Default = false,
	Callback = function(val)
		State.Visuals.ESP.Weapon = val
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.Weapon.Enabled = val
		end
		Window:UpdateESPPreview({ Weapon = val })
	end
})

espMod:CreateToggle({
	Name = "Flags",
	Default = false,
	Callback = function(val)
		State.Visuals.ESP.Flags = val
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.Flags.Enabled = val
		end
	end
})

espMod:CreateToggle({
	Name = "Chams",
	Default = false,
	Callback = function(val)
		State.Visuals.ESP.Chams = val
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.Chams.Enabled = val
		end
		if not val and getgenv().ESP and getgenv().ESP.Targets and getgenv().ESP.Targets.Players then
			for _, t in pairs(getgenv().ESP.Targets.Players) do
				if t.Objects and t.Objects["Highlight"] then
					t.Objects["Highlight"].Enabled = false
				end
			end
		end
		Window:UpdateESPPreview({ Chams = val })
	end
})

espMod:CreateToggle({
	Name = "Team Check",
	Default = false,
	Callback = function(val)
		State.Visuals.ESP.TeamCheck = val
	end
})

espMod:CreateSlider({
	Name = "Max Distance",
	Min = 100,
	Max = 3000,
	Default = 1000,
	Precision = 50,
	Unit = " studs",
	Callback = function(val)
		State.Visuals.ESP.MaxDistance = val
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.MaxDistance = val
		end
	end
})

espMod:CreateColorPicker({
	Name = "Box Color",
	Default = c3Rgb(255, 75, 114),
	Callback = function(col)
		State.Visuals.ESP.Colors.Box = col
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.BoundingBox.Color = {col, col}
			getgenv().ESP.Settings.Players.BoundingBox.Fill.Color = {col, col}
			getgenv().ESP.Settings.Players.BoundingBox.Glow.Color = {col, col}
		end
		Window:UpdateESPPreview({ BoxColor = col })
	end
})

espMod:CreateColorPicker({
	Name = "Name Color",
	Default = c3Rgb(245, 245, 250),
	Callback = function(col)
		State.Visuals.ESP.Colors.Name = col
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.Name.Color = col
		end
		Window:UpdateESPPreview({ NameColor = col })
	end
})

espMod:CreateColorPicker({
	Name = "Chams Color",
	Default = c3Rgb(255, 75, 114),
	Callback = function(col)
		State.Visuals.ESP.Colors.Chams = col
		if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
			getgenv().ESP.Settings.Players.Chams.Fill = {col, 0.5}
		end
		Window:UpdateESPPreview({ ChamsColor = col })
	end
})

end

do
local origLighting = {
	Ambient = Lighting.Ambient,
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd
}

local worldMod = VisualsTab:CreateModule({
	Name = "World Visuals",
	Default = false,
	Callback = function(val) end
})

worldMod:CreateToggle({
	Name = "Fullbright",
	Default = false,
	Callback = function(val)
		State.Visuals.World.Fullbright = val
		if val then
			Lighting.Ambient = c3Rgb(255, 255, 255)
			Lighting.Brightness = 2
			Lighting.ClockTime = 14
		else
			Lighting.Ambient = origLighting.Ambient
			Lighting.Brightness = origLighting.Brightness
			Lighting.ClockTime = origLighting.ClockTime
		end
	end
})

worldMod:CreateToggle({
	Name = "Remove Fog",
	Default = false,
	Callback = function(val)
		State.Visuals.World.RemoveFog = val
		Lighting.FogEnd = val and 9e9 or origLighting.FogEnd
	end
})

worldMod:CreateToggle({
	Name = "Crosshair",
	Default = false,
	Callback = function(val) State.Visuals.World.Crosshair = val end
})

worldMod:CreateColorPicker({
	Name = "Crosshair Color",
	Default = c3Rgb(255, 255, 255),
	Callback = function(col) State.Visuals.World.CrosshairColor = col end
})

worldMod:CreateSlider({
	Name = "Crosshair Size",
	Min = 4,
	Max = 30,
	Default = 10,
	Precision = 1,
	Unit = "px",
	Callback = function(val) State.Visuals.World.CrosshairSize = val end
})

worldMod:CreateSlider({
	Name = "Crosshair Gap",
	Min = 1,
	Max = 15,
	Default = 4,
	Precision = 1,
	Unit = "px",
	Callback = function(val) State.Visuals.World.CrosshairGap = val end
})

end

do
local noclipMod = ClientTab:CreateModule({
	Name = "Noclip",
	Default = false,
	Callback = function(val)
		State.Client.Noclip = val
		if not val then
			local char = LocalPlayer.Character
			if char then
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = true end
				end
			end
		end
	end
})

end

do
local animMod = ClientTab:CreateModule({
	Name = "Animation Changer",
	Default = false,
	Callback = function(val)
		State.Client.AnimationChanger = val
		applyAnimationPreset(val and State.Client.SelectedAnimation or "Default")
	end
})

animMod:CreateDropdown({
	Name = "Animation Preset",
	Options = {"Default", "Zombie", "Ninja", "Robot", "Levitate", "Cartoony", "Super Hero", "Elder", "Toy", "Old School", "Stylish"},
	Default = "Default",
	Callback = function(val)
		State.Client.SelectedAnimation = val
		if State.Client.AnimationChanger then
			applyAnimationPreset(val)
		end
	end
})

end

do
local hitSoundMod = ClientTab:CreateModule({
	Name = "Hit Sounds",
	Default = false,
	Callback = function(val) State.Client.HitSounds = val end
})

hitSoundMod:CreateDropdown({
	Name = "Sound Preset",
	Options = {"Rust", "Neverlose", "Skeet", "Bubble", "Bell", "Hitmarker"},
	Default = "Rust",
	Callback = function(val) State.Client.HitSoundPreset = val end
})

hitSoundMod:CreateSlider({
	Name = "Sound Volume",
	Min = 10,
	Max = 100,
	Default = 80,
	Precision = 5,
	Unit = "%",
	Callback = function(val) State.Client.HitSoundVolume = val end
})

hitSoundMod:CreateTextBox({
	Name = "Custom Sound ID",
	Default = "",
	Placeholder = "rbxassetid://...",
	Callback = function(val) State.Client.CustomHitSoundId = val end
})

end

do
local damageMod = ClientTab:CreateModule({
	Name = "Damage Indicators",
	Default = false,
	Callback = function(val) State.Client.DamageNumbers = val end
})

damageMod:CreateToggle({
	Name = "Hit Notifications",
	Default = false,
	Callback = function(val) State.Client.HitNotifications = val end
})

damageMod:CreateColorPicker({
	Name = "Number Color",
	Default = c3Rgb(255, 75, 114),
	Callback = function(col) State.Client.DamageNumbersColor = col end
})

damageMod:CreateSlider({
	Name = "Display Duration",
	Min = 0.5,
	Max = 2.5,
	Default = 1.0,
	Precision = 0.1,
	Unit = "s",
	Callback = function(val) State.Client.DamageDuration = val end
})

end

do
local wsMod = MovementTab:CreateModule({
	Name = "WalkSpeed",
	Default = false,
	Callback = function(val)
		State.Movement.WalkSpeedEnabled = val
		updateWalkspeed()
	end
})

wsMod:CreateSlider({
	Name = "Speed Value",
	Min = 16,
	Max = 250,
	Default = 32,
	Precision = 1,
	Unit = " ws",
	Callback = function(val)
		State.Movement.WalkSpeedValue = val
		if not macroRunning then
			currentSpeed = val
			updateWalkspeed()
		end
	end
})

end

do
local jpMod = MovementTab:CreateModule({
	Name = "JumpPower",
	Default = false,
	Callback = function(val)
		State.Movement.JumpPowerEnabled = val
		updateJumpPower()
	end
})

jpMod:CreateSlider({
	Name = "Jump Value",
	Min = 50,
	Max = 300,
	Default = 100,
	Precision = 5,
	Unit = " jp",
	Callback = function(val)
		State.Movement.JumpPowerValue = val
		currentJump = val
		updateJumpPower()
	end
})

jpMod:CreateToggle({
	Name = "Infinite Jump",
	Default = false,
	Callback = function(val)
		State.Movement.InfiniteJump = val
	end
})

end

do
local macroMod = MovementTab:CreateModule({
	Name = "Fake Macro",
	Default = false,
	Callback = function(val)
		State.Movement.FakeMacro = val
		if not val and macroRunning then
			stopFakeMacro()
		end
	end
})

macroMod:CreateDropdown({
	Name = "Mode",
	Options = {"Toggle", "Hold"},
	Default = "Toggle",
	Callback = function(val) State.Movement.MacroMode = val end
})

macroMod:CreateKeybind({
	Name = "Keybind",
	Default = Enum.KeyCode.Q,
	Mode = "Toggle",
	Callback = function(key) State.Movement.MacroKey = key end
})

macroMod:CreateDropdown({
	Name = "Speed Mode",
	Options = {"Fixed", "Random", "Ramp Up"},
	Default = "Fixed",
	Callback = function(val) State.Movement.MacroSpeedMode = val end
})

macroMod:CreateSlider({
	Name = "Fixed Speed",
	Min = 50,
	Max = 350,
	Default = 120,
	Precision = 5,
	Unit = " ws",
	Callback = function(val)
		State.Movement.MacroSpeed = val
		if macroRunning and State.Movement.MacroSpeedMode == "Fixed" then
			currentSpeed = val
			updateWalkspeed()
		end
	end
})

macroMod:CreateSlider({
	Name = "Min Speed",
	Min = 50,
	Max = 350,
	Default = 200,
	Precision = 5,
	Unit = " ws",
	Callback = function(val) State.Movement.MacroSpeedMin = val end
})

macroMod:CreateSlider({
	Name = "Max Speed",
	Min = 50,
	Max = 400,
	Default = 300,
	Precision = 5,
	Unit = " ws",
	Callback = function(val) State.Movement.MacroSpeedMax = val end
})

macroMod:CreateSlider({
	Name = "Start Speed",
	Min = 16,
	Max = 200,
	Default = 60,
	Precision = 5,
	Unit = " ws",
	Callback = function(val) State.Movement.MacroRampStart = val end
})

macroMod:CreateSlider({
	Name = "Max Speed",
	Min = 100,
	Max = 400,
	Default = 280,
	Precision = 5,
	Unit = " ws",
	Callback = function(val) State.Movement.MacroRampMax = val end
})

macroMod:CreateSlider({
	Name = "Duration",
	Min = 0.5,
	Max = 3.0,
	Default = 1.0,
	Precision = 0.1,
	Unit = "s",
	Callback = function(val) State.Movement.MacroRampDuration = val end
})

end

do
local function getPlayerNameList()
	local names = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			tblInsert(names, p.Name)
		end
	end
	if #names == 0 then tblInsert(names, "None") end
	return names
end

local targetMod = TargetingTab:CreateModule({
	Name = "Player Targeting",
	Default = false,
	Callback = function(val) end
})

local playerDropdown = targetMod:CreateDropdown({
	Name = "Select Player",
	Options = getPlayerNameList(),
	Default = getPlayerNameList()[1] or "None",
	Callback = function(val)
		State.Targeting.SelectedPlayer = Players:FindFirstChild(val)
	end
})

Players.PlayerAdded:Connect(function()
	playerDropdown:Refresh(getPlayerNameList(), true)
end)
Players.PlayerRemoving:Connect(function()
	task.delay(0.2, function() playerDropdown:Refresh(getPlayerNameList(), true) end)
end)

targetMod:CreateButton({
	Name = "Add Priority",
	Callback = function()
		local p = State.Targeting.SelectedPlayer or Players:FindFirstChild(playerDropdown:Get())
		if p then
			State.Targeting.Priority[p.UserId] = true
			Window:Notify({
				Title = "Priority Added",
				Description = p.Name .. " set as high-priority target",
				Duration = 2
			})
		end
	end
})

targetMod:CreateButton({
	Name = "Add Friend",
	Callback = function()
		local p = State.Targeting.SelectedPlayer or Players:FindFirstChild(playerDropdown:Get())
		if p then
			State.Targeting.Friends[p.UserId] = true
			Window:Notify({
				Title = "Friend Added",
				Description = p.Name .. " added to safe list",
				Duration = 2
			})
		end
	end
})

targetMod:CreateButton({
	Name = "Remove Target",
	Callback = function()
		local p = State.Targeting.SelectedPlayer or Players:FindFirstChild(playerDropdown:Get())
		if p then
			State.Targeting.Priority[p.UserId] = nil
			State.Targeting.Friends[p.UserId] = nil
			Window:Notify({
				Title = "List Updated" .. p.Name .. " from priority & safe lists",
				Duration = 2
			})
		end
	end
})

targetMod:CreateToggle({
	Name = "Spectate",
	Default = false,
	Callback = function(val)
		if val then
			local p = State.Targeting.SelectedPlayer or Players:FindFirstChild(playerDropdown:Get())
			local hum = p and p.Character and p.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				Camera.CameraSubject = hum
			end
		else
			local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then
				Camera.CameraSubject = hum
			end
		end
	end
})

targetMod:CreateButton({
	Name = "Teleport",
	Callback = function()
		local p = State.Targeting.SelectedPlayer or Players:FindFirstChild(playerDropdown:Get())
		local root = p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
		local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root and myRoot then
			myRoot.CFrame = root.CFrame * cfNew(0, 0, 3)
			Window:Notify({
				Title = "Teleported" .. p.Name,
				Duration = 2
			})
		end
	end
})

end

ConfigsTab:CreateConfigSystem()
SettingsTab:CreateSettingsSystem()

Window:Notify({
	Title = "future.club",
	Duration = 3.5
})