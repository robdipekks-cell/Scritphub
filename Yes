-- [[ Script Hub by Oorbits - Cyber Edition v3.0 ]] --
-- Features: Mobile Toggle | Auto Execute | Built-in Anti-AFK

-- ─────────────────────────────────────────
--  BUILT-IN ANTI-AFK  (task.spawn so it never blocks the hub)
-- ─────────────────────────────────────────
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/evxncodes/mainroblox/main/anti-afk", true))()
    end)
end)

local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")
local Lighting         = game:GetService("Lighting")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ─────────────────────────────────────────
--  AUTO-EXECUTE FILE SYSTEM
-- ─────────────────────────────────────────
local AE_FILE      = "OorbitsAutoExec.txt"
local AE_NAME_FILE = "OorbitsAutoExecName.txt"

local function readAutoExec()
    local ok, data = pcall(readfile, AE_FILE)
    if ok and type(data) == "string" and #data > 5 then return data end
    return nil
end
local function readAutoExecName()
    local ok, data = pcall(readfile, AE_NAME_FILE)
    if ok and type(data) == "string" and #data > 0 then return data end
    return nil
end
local function saveAutoExec(url, name)
    pcall(writefile, AE_FILE,      url  or "")
    pcall(writefile, AE_NAME_FILE, name or "")
end
local function clearAutoExec()
    pcall(writefile, AE_FILE,      "")
    pcall(writefile, AE_NAME_FILE, "")
end

local savedAutoScript = readAutoExec()
local savedAutoName   = readAutoExecName()

-- Fire saved auto-execute on load (hub stays alive)
if savedAutoScript then
    task.delay(1.5, function()
        pcall(function()
            loadstring(game:HttpGet(savedAutoScript, true))()
        end)
    end)
end

-- ─────────────────────────────────────────
--  CLEANUP
-- ─────────────────────────────────────────
if CoreGui:FindFirstChild("OorbitsHub") then CoreGui.OorbitsHub:Destroy() end
if Lighting:FindFirstChild("HubBlur")   then Lighting.HubBlur:Destroy()  end

-- ─────────────────────────────────────────
--  BLUR
-- ─────────────────────────────────────────
local Blur = Instance.new("BlurEffect")
Blur.Name   = "HubBlur"
Blur.Size   = 0
Blur.Parent = Lighting
TweenService:Create(Blur, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Size = 18}):Play()

-- ─────────────────────────────────────────
--  SCREEN GUI
-- ─────────────────────────────────────────
local Gui = Instance.new("ScreenGui")
Gui.Name           = "OorbitsHub"
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.IgnoreGuiInset = true
Gui.Parent         = CoreGui

local hubVisible = true

-- ─────────────────────────────────────────
--  HELPERS
-- ─────────────────────────────────────────
local function Tween(obj, t, props, style, dir)
    style = style or Enum.EasingStyle.Quint
    dir   = dir   or Enum.EasingDirection.Out
    return TweenService:Create(obj, TweenInfo.new(t, style, dir), props)
end
local function New(cls, props, parent)
    local i = Instance.new(cls)
    for k, v in pairs(props) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end
local function Corner(r, p)
    return New("UICorner", {CornerRadius = UDim.new(0, r)}, p)
end
local function Stroke(c, t, p)
    return New("UIStroke", {Color = c, Thickness = t, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, p)
end
local function Gradient(a, b, rot, p)
    local g = New("UIGradient", {Rotation = rot or 90}, p)
    g.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, a), ColorSequenceKeypoint.new(1, b)}
    return g
end

-- ─────────────────────────────────────────
--  COLORS
-- ─────────────────────────────────────────
local C = {
    bg      = Color3.fromRGB(9,  10, 14),
    panel   = Color3.fromRGB(14, 15, 20),
    card    = Color3.fromRGB(18, 19, 26),
    cardHov = Color3.fromRGB(24, 25, 36),
    accent  = Color3.fromRGB(88, 166, 255),
    accent2 = Color3.fromRGB(140, 80, 255),
    green   = Color3.fromRGB(60, 220, 140),
    orange  = Color3.fromRGB(255, 165, 60),
    border  = Color3.fromRGB(40, 44, 60),
    txt     = Color3.fromRGB(220, 225, 240),
    txtDim  = Color3.fromRGB(100, 108, 130),
    white   = Color3.fromRGB(255, 255, 255),
    dark    = Color3.fromRGB(0,   0,   0),
}

-- ─────────────────────────────────────────
--  TOAST (defined early so all handlers can use it)
-- ─────────────────────────────────────────
local ShowToast  -- forward-declare
local toastQueue = {} -- so toasts don't overlap

-- ─────────────────────────────────────────
--  OUTER GLOW
-- ─────────────────────────────────────────
local Glow = New("Frame", {
    Size              = UDim2.fromOffset(700, 490),
    Position          = UDim2.new(0.5, -350, 0.5, -245),
    BackgroundColor3  = C.accent,
    BackgroundTransparency = 0.88,
    ZIndex            = 1,
}, Gui)
Corner(20, Glow)

-- ─────────────────────────────────────────
--  MAIN CANVAS
-- ─────────────────────────────────────────
local Main = New("CanvasGroup", {
    Name              = "Main",
    Size              = UDim2.fromOffset(680, 470),
    Position          = UDim2.new(0.5, -340, 0.5, -235),
    BackgroundColor3  = C.bg,
    GroupTransparency = 1,
    ZIndex            = 2,
}, Gui)
Corner(16, Main)
Stroke(C.border, 1.2, Main)

-- Shimmer border
local BorderShimmer = New("Frame", {
    Size             = UDim2.new(1, 0, 0, 2),
    BackgroundColor3 = C.white,
    ZIndex           = 10,
}, Main)
Corner(2, BorderShimmer)
local bsg = New("UIGradient", {Rotation = 0}, BorderShimmer)
bsg.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(0.3, C.accent),
    ColorSequenceKeypoint.new(0.5, C.white),
    ColorSequenceKeypoint.new(0.7, C.accent2),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,0,0)),
}
bsg.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0,   1),
    NumberSequenceKeypoint.new(0.3, 0),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(0.7, 0),
    NumberSequenceKeypoint.new(1,   1),
}
local shimmerOffset = 0
RunService.Heartbeat:Connect(function(dt)
    shimmerOffset = (shimmerOffset + dt * 0.18) % 1
    bsg.Offset = Vector2.new(shimmerOffset * 2 - 1, 0)
end)

-- Entrance tween
Tween(Main, 0.7, {GroupTransparency = 0}):Play()

-- ─────────────────────────────────────────
--  MOBILE TOGGLE BUTTON (lives in Gui, always visible)
-- ─────────────────────────────────────────
local ToggleWrap = New("Frame", {
    Size             = UDim2.fromOffset(52, 52),
    Position         = UDim2.new(1, -68, 0.5, -26),
    BackgroundColor3 = C.accent,
    ZIndex           = 100,
}, Gui)
Corner(14, ToggleWrap)

local togGrad = New("UIGradient", {
    Color    = ColorSequence.new(C.accent, C.accent2),
    Rotation = 135,
}, ToggleWrap)
local togStroke = Stroke(C.accent, 1.5, ToggleWrap)

-- Outer glow ring
local ToggleGlow = New("Frame", {
    Size             = UDim2.fromOffset(64, 64),
    Position         = UDim2.new(0.5, -32, 0.5, -32),
    BackgroundColor3 = C.accent,
    BackgroundTransparency = 0.75,
    ZIndex           = 99,
}, ToggleWrap)
Corner(50, ToggleGlow)

task.spawn(function()
    while ToggleWrap.Parent do
        Tween(ToggleGlow, 1.1, {BackgroundTransparency = 0.5}, Enum.EasingStyle.Sine):Play()
        task.wait(1.1)
        Tween(ToggleGlow, 1.1, {BackgroundTransparency = 0.8}, Enum.EasingStyle.Sine):Play()
        task.wait(1.1)
    end
end)

local ToggleBtn = New("TextButton", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text             = "",
    AutoButtonColor  = false,
    ZIndex           = 101,
}, ToggleWrap)

local ToggleIcon = New("TextLabel", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text             = "◉",
    TextColor3       = C.white,
    TextSize         = 22,
    Font             = Enum.Font.GothamBold,
    ZIndex           = 102,
}, ToggleWrap)

-- Drag support for toggle button
local togDragging, togDragStart, togStartPos, togHasMoved

ToggleBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch
    or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        togDragging  = true
        togHasMoved  = false
        togDragStart = inp.Position
        togStartPos  = ToggleWrap.Position
    end
end)
ToggleBtn.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch
    or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        if not togHasMoved then
            -- It was a tap/click, not a drag → toggle hub
            hubVisible = not hubVisible
            if hubVisible then
                Main.Visible = true
                Glow.Visible = true
                Tween(Main, 0.35, {GroupTransparency = 0}):Play()
                Tween(Blur, 0.35, {Size = 18}):Play()
                ToggleIcon.Text       = "◉"
                togGrad.Color         = ColorSequence.new(C.accent, C.accent2)
                togStroke.Color       = C.accent
            else
                Tween(Main, 0.35, {GroupTransparency = 1}):Play()
                Tween(Blur, 0.35, {Size = 0}):Play()
                task.delay(0.36, function()
                    Main.Visible = false
                    Glow.Visible = false
                end)
                ToggleIcon.Text       = "◎"
                togGrad.Color         = ColorSequence.new(C.border, C.border)
                togStroke.Color       = C.border
            end
        end
        togDragging = false
        togHasMoved = false
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if togDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
    or inp.UserInputType == Enum.UserInputType.Touch) then
        local d = inp.Position - togDragStart
        if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then
            togHasMoved = true
        end
        if togHasMoved then
            ToggleWrap.Position = UDim2.new(
                togStartPos.X.Scale, togStartPos.X.Offset + d.X,
                togStartPos.Y.Scale, togStartPos.Y.Offset + d.Y
            )
        end
    end
end)

-- ─────────────────────────────────────────
--  DRAGGING (main window)
-- ─────────────────────────────────────────
local dragging, dragStart, startPos
Main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging  = true
        dragStart = inp.Position
        startPos  = Main.Position
    end
end)
Main.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local d = inp.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
        Glow.Position = UDim2.new(
            Main.Position.X.Scale, Main.Position.X.Offset - 10,
            Main.Position.Y.Scale, Main.Position.Y.Offset - 10
        )
    end
end)

-- ─────────────────────────────────────────
--  LEFT SIDEBAR
-- ─────────────────────────────────────────
local Sidebar = New("Frame", {
    Size             = UDim2.new(0, 210, 1, 0),
    BackgroundColor3 = C.panel,
    ZIndex           = 3,
}, Main)
Corner(16, Sidebar)
-- Square off right corners
New("Frame", {
    Size             = UDim2.new(0, 16, 1, 0),
    Position         = UDim2.new(1, -16, 0, 0),
    BackgroundColor3 = C.panel,
    ZIndex           = 3,
    BorderSizePixel  = 0,
}, Sidebar)

-- Logo area
local LogoArea = New("Frame", {
    Size             = UDim2.new(1, 0, 0, 70),
    BackgroundTransparency = 1,
    ZIndex           = 4,
}, Sidebar)

local Orb = New("Frame", {
    Size             = UDim2.fromOffset(32, 32),
    Position         = UDim2.new(0, 16, 0.5, -16),
    BackgroundColor3 = C.accent,
    ZIndex           = 5,
}, LogoArea)
Corner(50, Orb)
New("UIGradient", {Color = ColorSequence.new(C.accent, C.accent2), Rotation = 135}, Orb)

task.spawn(function()
    while Orb.Parent do
        Tween(Orb, 1.2, {BackgroundTransparency = 0.4}, Enum.EasingStyle.Sine):Play()
        task.wait(1.2)
        Tween(Orb, 1.2, {BackgroundTransparency = 0}, Enum.EasingStyle.Sine):Play()
        task.wait(1.2)
    end
end)

local OrbInner = New("Frame", {
    Size             = UDim2.fromOffset(10, 10),
    Position         = UDim2.new(0.5, -5, 0.5, -5),
    BackgroundColor3 = C.white,
    ZIndex           = 6,
}, Orb)
Corner(50, OrbInner)

New("TextLabel", {
    Size             = UDim2.new(1, -60, 1, 0),
    Position         = UDim2.new(0, 56, 0, 0),
    BackgroundTransparency = 1,
    Text             = "OORBITS",
    TextColor3       = C.white,
    TextSize         = 17,
    Font             = Enum.Font.GothamBold,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 5,
}, LogoArea)

New("TextLabel", {
    Size             = UDim2.new(1, -60, 0, 16),
    Position         = UDim2.new(0, 56, 0, 45),
    BackgroundTransparency = 1,
    Text             = "SCRIPT HUB",
    TextColor3       = C.accent,
    TextSize         = 9,
    Font             = Enum.Font.GothamBold,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 5,
}, LogoArea)

-- Sidebar divider
local SideDivider = New("Frame", {
    Size             = UDim2.new(1, -24, 0, 1),
    Position         = UDim2.new(0, 12, 0, 72),
    BackgroundColor3 = C.border,
    ZIndex           = 4,
}, Sidebar)
Gradient(C.accent, C.accent2, 0, SideDivider)

-- Search bar
local SearchWrap = New("Frame", {
    Size             = UDim2.new(1, -20, 0, 34),
    Position         = UDim2.new(0, 10, 0, 82),
    BackgroundColor3 = C.card,
    ZIndex           = 4,
}, Sidebar)
Corner(8, SearchWrap)
Stroke(C.border, 1, SearchWrap)

New("TextLabel", {
    Size             = UDim2.fromOffset(16, 34),
    Position         = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Text             = "🔍",
    TextSize         = 12,
    ZIndex           = 5,
}, SearchWrap)

local SearchBox = New("TextBox", {
    Size             = UDim2.new(1, -36, 1, 0),
    Position         = UDim2.new(0, 30, 0, 0),
    BackgroundTransparency = 1,
    PlaceholderText  = "Search games...",
    PlaceholderColor3 = C.txtDim,
    Text             = "",
    TextColor3       = C.txt,
    Font             = Enum.Font.Gotham,
    TextSize         = 13,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    ZIndex           = 5,
}, SearchWrap)

-- Game count badge
local CountBadge = New("Frame", {
    Size             = UDim2.fromOffset(40, 18),
    Position         = UDim2.new(1, -50, 0, 122),
    BackgroundColor3 = C.accent,
    BackgroundTransparency = 0.75,
    ZIndex           = 4,
}, Sidebar)
Corner(9, CountBadge)

local CountLabel = New("TextLabel", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text             = "0",
    TextColor3       = C.accent,
    TextSize         = 10,
    Font             = Enum.Font.GothamBold,
    ZIndex           = 5,
}, CountBadge)

New("TextLabel", {
    Size             = UDim2.new(0, 60, 0, 18),
    Position         = UDim2.new(0, 10, 0, 122),
    BackgroundTransparency = 1,
    Text             = "GAMES",
    TextColor3       = C.txtDim,
    TextSize         = 9,
    Font             = Enum.Font.GothamBold,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 4,
}, Sidebar)

-- Script list
local ListFrame = New("ScrollingFrame", {
    Size                   = UDim2.new(1, -10, 1, -152),
    Position               = UDim2.new(0, 5, 0, 148),
    BackgroundTransparency = 1,
    ScrollBarThickness     = 2,
    ScrollBarImageColor3   = C.accent,
    CanvasSize             = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize    = Enum.AutomaticSize.Y,
    ZIndex                 = 4,
}, Sidebar)

New("UIListLayout", {
    Padding             = UDim.new(0, 5),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
}, ListFrame)

New("UIPadding", {
    PaddingTop    = UDim.new(0, 4),
    PaddingBottom = UDim.new(0, 8),
}, ListFrame)

-- ─────────────────────────────────────────
--  RIGHT PANEL
-- ─────────────────────────────────────────
local RightPanel = New("Frame", {
    Size             = UDim2.new(1, -218, 1, 0),
    Position         = UDim2.new(0, 218, 0, 0),
    BackgroundTransparency = 1,
    ZIndex           = 3,
}, Main)

-- Top bar
local TopBar = New("Frame", {
    Size             = UDim2.new(1, 0, 0, 50),
    BackgroundTransparency = 1,
    ZIndex           = 4,
}, RightPanel)

local Breadcrumb = New("TextLabel", {
    Size             = UDim2.new(1, -50, 1, 0),
    Position         = UDim2.new(0, 16, 0, 0),
    BackgroundTransparency = 1,
    Text             = "Select a game to preview",
    TextColor3       = C.txtDim,
    TextSize         = 13,
    Font             = Enum.Font.Gotham,
    TextXAlignment   = Enum.TextXAlignment.Left,
    Name             = "Breadcrumb",
    ZIndex           = 5,
}, TopBar)

-- Close button (hides hub, does NOT destroy it)
local CloseBtn = New("TextButton", {
    Size             = UDim2.fromOffset(28, 28),
    Position         = UDim2.new(1, -38, 0.5, -14),
    BackgroundColor3 = Color3.fromRGB(200, 60, 60),
    BackgroundTransparency = 0.3,
    Text             = "X",
    TextColor3       = C.white,
    TextSize         = 13,
    Font             = Enum.Font.GothamBold,
    ZIndex           = 5,
}, TopBar)
Corner(7, CloseBtn)

CloseBtn.MouseEnter:Connect(function()
    Tween(CloseBtn, 0.2, {BackgroundTransparency = 0, Size = UDim2.fromOffset(30,30), Position = UDim2.new(1,-39,0.5,-15)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    Tween(CloseBtn, 0.2, {BackgroundTransparency = 0.3, Size = UDim2.fromOffset(28,28), Position = UDim2.new(1,-38,0.5,-14)}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    -- Hide hub; toggle button stays visible
    hubVisible = false
    Tween(Main, 0.4, {GroupTransparency = 1}):Play()
    Tween(Blur, 0.4, {Size = 0}):Play()
    task.delay(0.41, function()
        Main.Visible = false
        Glow.Visible = false
    end)
    ToggleIcon.Text   = "◎"
    togGrad.Color     = ColorSequence.new(C.border, C.border)
    togStroke.Color   = C.border
end)

-- Top divider
New("Frame", {
    Size             = UDim2.new(1, -16, 0, 1),
    Position         = UDim2.new(0, 8, 0, 50),
    BackgroundColor3 = C.border,
    ZIndex           = 4,
}, RightPanel)

-- Preview card
local PreviewCard = New("Frame", {
    Size             = UDim2.new(1, -24, 0, 200),
    Position         = UDim2.new(0, 12, 0, 62),
    BackgroundColor3 = C.card,
    ZIndex           = 4,
}, RightPanel)
Corner(12, PreviewCard)
Stroke(C.border, 1, PreviewCard)

local ImgContainer = New("Frame", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = C.card,
    ZIndex           = 4,
    ClipsDescendants = true,
}, PreviewCard)
Corner(12, ImgContainer)

local DisplayImg = New("ImageLabel", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Image            = "",
    ScaleType        = Enum.ScaleType.Crop,
    ImageTransparency = 1,
    ZIndex           = 5,
}, ImgContainer)

local ImgPlaceholder = New("TextLabel", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text             = "🎮  No game selected",
    TextColor3       = C.txtDim,
    TextSize         = 14,
    Font             = Enum.Font.Gotham,
    ZIndex           = 5,
}, ImgContainer)

local ImgOverlay = New("Frame", {
    Size             = UDim2.new(1, 0, 0.5, 0),
    Position         = UDim2.new(0, 0, 0.5, 0),
    BackgroundColor3 = C.card,
    ZIndex           = 6,
}, ImgContainer)
Corner(12, ImgOverlay)
local ovg = New("UIGradient", {Rotation = 90}, ImgOverlay)
ovg.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(1, 0),
}

-- Info section
local InfoSection = New("Frame", {
    Size             = UDim2.new(1, -24, 0, 70),
    Position         = UDim2.new(0, 12, 0, 274),
    BackgroundTransparency = 1,
    ZIndex           = 4,
}, RightPanel)

local GameTitleLabel = New("TextLabel", {
    Size             = UDim2.new(1, 0, 0, 28),
    BackgroundTransparency = 1,
    Text             = "—",
    TextColor3       = C.white,
    TextSize         = 20,
    Font             = Enum.Font.GothamBold,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 5,
}, InfoSection)

local StatusDot = New("Frame", {
    Size             = UDim2.fromOffset(7, 7),
    Position         = UDim2.new(0, 0, 0, 36),
    BackgroundColor3 = C.green,
    ZIndex           = 5,
}, InfoSection)
Corner(50, StatusDot)

New("TextLabel", {
    Size             = UDim2.new(1, -20, 0, 18),
    Position         = UDim2.new(0, 14, 0, 32),
    BackgroundTransparency = 1,
    Text             = "Ready to execute",
    TextColor3       = C.txtDim,
    TextSize         = 12,
    Font             = Enum.Font.Gotham,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 5,
}, InfoSection)

-- Tag badges
local TagFrame = New("Frame", {
    Size             = UDim2.new(1, -24, 0, 24),
    Position         = UDim2.new(0, 12, 0, 334),
    BackgroundTransparency = 1,
    ZIndex           = 4,
}, RightPanel)
New("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0,6)}, TagFrame)

local function MakeTag(text, color)
    local t = New("Frame", {
        Size             = UDim2.fromOffset(0, 22),
        AutomaticSize    = Enum.AutomaticSize.X,
        BackgroundColor3 = color,
        BackgroundTransparency = 0.8,
        ZIndex           = 5,
    }, TagFrame)
    Corner(6, t)
    New("UIPadding", {PaddingLeft=UDim.new(0,8), PaddingRight=UDim.new(0,8), PaddingTop=UDim.new(0,2), PaddingBottom=UDim.new(0,2)}, t)
    New("TextLabel", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text             = text,
        TextColor3       = color,
        TextSize         = 10,
        Font             = Enum.Font.GothamBold,
        ZIndex           = 6,
        AutomaticSize    = Enum.AutomaticSize.X,
    }, t)
end
MakeTag("FREE",       C.green)
MakeTag("UNDETECTED", C.accent)
MakeTag("UPDATED",    C.accent2)

-- ─────── AUTO-EXECUTE ROW ───────
local AEBar = New("Frame", {
    Size             = UDim2.new(1, -24, 0, 30),
    Position         = UDim2.new(0, 12, 0, 365),
    BackgroundColor3 = C.card,
    ZIndex           = 4,
}, RightPanel)
Corner(8, AEBar)
Stroke(C.border, 1, AEBar)

New("TextLabel", {
    Size             = UDim2.fromOffset(20, 30),
    Position         = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    Text             = "⚡",
    TextSize         = 13,
    ZIndex           = 5,
}, AEBar)

local AELabel = New("TextLabel", {
    Size             = UDim2.new(1, -90, 1, 0),
    Position         = UDim2.new(0, 28, 0, 0),
    BackgroundTransparency = 1,
    Text             = savedAutoName and ("AUTO: " .. savedAutoName) or "Auto Execute: OFF",
    TextColor3       = savedAutoName and C.orange or C.txtDim,
    TextSize         = 10,
    Font             = Enum.Font.GothamSemibold,
    TextXAlignment   = Enum.TextXAlignment.Left,
    TextTruncate     = Enum.TextTruncate.AtEnd,
    ZIndex           = 5,
}, AEBar)

local AEPill = New("TextButton", {
    Size             = UDim2.fromOffset(52, 20),
    Position         = UDim2.new(1, -58, 0.5, -10),
    BackgroundColor3 = savedAutoName and C.orange or C.border,
    Text             = savedAutoName and "CLEAR" or "SET",
    TextColor3       = C.white,
    TextSize         = 9,
    Font             = Enum.Font.GothamBold,
    AutoButtonColor  = false,
    ZIndex           = 5,
}, AEBar)
Corner(6, AEPill)

-- ─────── EXECUTE BUTTON ───────
local ExecWrap = New("Frame", {
    Size             = UDim2.new(1, -24, 0, 44),
    Position         = UDim2.new(0, 12, 1, -56),
    BackgroundColor3 = C.accent,
    ZIndex           = 4,
}, RightPanel)
Corner(12, ExecWrap)
New("UIGradient", {Color = ColorSequence.new(C.accent, C.accent2), Rotation = 90}, ExecWrap)

local ExecGlow = New("Frame", {
    Size             = UDim2.new(1, 20, 1, 10),
    Position         = UDim2.new(0, -10, 0, -10),
    BackgroundColor3 = C.accent,
    BackgroundTransparency = 1,
    ZIndex           = 3,
}, ExecWrap)
Corner(16, ExecGlow)

local ExecBtn = New("TextButton", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text             = "",
    ZIndex           = 5,
    Visible          = false,
}, ExecWrap)

local ExecInner = New("Frame", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex           = 6,
}, ExecBtn)
New("UIListLayout", {
    FillDirection       = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment   = Enum.VerticalAlignment.Center,
    Padding             = UDim.new(0, 8),
}, ExecInner)
New("TextLabel", {Size=UDim2.fromOffset(20,44), BackgroundTransparency=1, Text="▶", TextColor3=C.white, TextSize=16, Font=Enum.Font.GothamBold, ZIndex=7}, ExecInner)
New("TextLabel", {Size=UDim2.fromOffset(120,44), BackgroundTransparency=1, Text="EXECUTE SCRIPT", TextColor3=C.white, TextSize=15, Font=Enum.Font.GothamBold, ZIndex=7}, ExecInner)

local NoSelectLabel = New("TextLabel", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text             = "Select a game first",
    TextColor3       = C.white,
    TextTransparency = 0.5,
    TextSize         = 14,
    Font             = Enum.Font.Gotham,
    ZIndex           = 5,
    Visible          = true,
}, ExecWrap)

ExecWrap.BackgroundTransparency = 0.5

ExecBtn.MouseEnter:Connect(function()
    Tween(ExecWrap, 0.15, {BackgroundTransparency = 0, Size = UDim2.new(1,-20,0,46), Position = UDim2.new(0,14,1,-57)}):Play()
    Tween(ExecGlow, 0.3,  {BackgroundTransparency = 0.6}):Play()
end)
ExecBtn.MouseLeave:Connect(function()
    Tween(ExecWrap, 0.15, {BackgroundTransparency = 0, Size = UDim2.new(1,-24,0,44), Position = UDim2.new(0,12,1,-56)}):Play()
    Tween(ExecGlow, 0.3,  {BackgroundTransparency = 0.7}):Play()
end)

-- ─────────────────────────────────────────
--  GAME DATA
-- ─────────────────────────────────────────
local Games = {
    {Name = "Nuke Your City",              ID = "113918641206373", Script = "https://raw.githubusercontent.com/robdipekks-cell/Nuke/refs/heads/main/Nukes"},
    {Name = "Oil Empire",                  ID = "107095834793267", Script = "https://raw.githubusercontent.com/robdipekks-cell/Oil/refs/heads/main/Oiled"},
    {Name = "Be A Youtuber",               ID = "120564326011184", Script = "https://raw.githubusercontent.com/robdipekks-cell/Youtube/refs/heads/main/Ye"},
    {Name = "Dont Get Caught For Hackers", ID = "91350524990442",  Script = "https://raw.githubusercontent.com/robdipekks-cell/As/refs/heads/main/FluentGUI%20(4).lua"},
    {Name = "Be A Streamer",               ID = "119126689474503", Script = "https://raw.githubusercontent.com/robdipekks-cell/Be-a-streamer/refs/heads/main/A"},
    {Name = "Fireball Training",           ID = "129195078205390", Script = "https://raw.githubusercontent.com/robdipekks-cell/Fireball-/refs/heads/main/A"},
    {Name = "Roll An Anime",               ID = "93999763241813",  Script = "https://raw.githubusercontent.com/robdipekks-cell/Roll-anime/refs/heads/main/A"},
    {Name = "Build A Store",               ID = "123260699475631", Script = "https://raw.githubusercontent.com/robdipekks-cell/Build-store/refs/heads/main/A"},
}

local currentScript  = nil
local currentName    = nil
local selectedButton = nil
local allButtons     = {}

CountLabel.Text = tostring(#Games)

-- ─────────────────────────────────────────
--  BUILD GAME BUTTONS
-- ─────────────────────────────────────────
for i, data in ipairs(Games) do
    local Card = New("TextButton", {
        Size             = UDim2.new(1, -10, 0, 48),
        BackgroundColor3 = C.card,
        Text             = "",
        AutoButtonColor  = false,
        ZIndex           = 5,
    }, ListFrame)
    Corner(10, Card)

    local AccentBar = New("Frame", {
        Size             = UDim2.fromOffset(3, 28),
        Position         = UDim2.new(0, 6, 0.5, -14),
        BackgroundColor3 = C.accent,
        BackgroundTransparency = 1,
        ZIndex           = 6,
    }, Card)
    Corner(4, AccentBar)

    local NumBadge = New("Frame", {
        Size             = UDim2.fromOffset(22, 22),
        Position         = UDim2.new(0, 14, 0.5, -11),
        BackgroundColor3 = C.border,
        ZIndex           = 6,
    }, Card)
    Corner(6, NumBadge)
    New("TextLabel", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text             = tostring(i),
        TextColor3       = C.txtDim,
        TextSize         = 10,
        Font             = Enum.Font.GothamBold,
        ZIndex           = 7,
    }, NumBadge)

    New("TextLabel", {
        Size             = UDim2.new(1, -50, 1, 0),
        Position         = UDim2.new(0, 44, 0, 0),
        BackgroundTransparency = 1,
        Text             = data.Name,
        TextColor3       = C.txtDim,
        TextSize         = 13,
        Font             = Enum.Font.GothamSemibold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextTruncate     = Enum.TextTruncate.AtEnd,
        Name             = "Label",
        ZIndex           = 6,
    }, Card)

    local Arrow = New("TextLabel", {
        Size             = UDim2.fromOffset(20, 48),
        Position         = UDim2.new(1, -22, 0, 0),
        BackgroundTransparency = 1,
        Text             = "›",
        TextColor3       = C.txtDim,
        TextSize         = 18,
        Font             = Enum.Font.GothamBold,
        TextTransparency = 1,
        ZIndex           = 6,
    }, Card)

    table.insert(allButtons, {card=Card, data=data, accent=AccentBar, arrow=Arrow, numBadge=NumBadge})

    local function selectCard()
        if selectedButton then
            local old = selectedButton
            Tween(old.card,     0.25, {BackgroundColor3 = C.card}):Play()
            Tween(old.accent,   0.25, {BackgroundTransparency = 1}):Play()
            Tween(old.arrow,    0.25, {TextTransparency = 1}):Play()
            Tween(old.numBadge, 0.25, {BackgroundColor3 = C.border}):Play()
            old.card:FindFirstChild("Label").TextColor3 = C.txtDim
        end
        selectedButton = {card=Card, data=data, accent=AccentBar, arrow=Arrow, numBadge=NumBadge}

        Tween(Card,      0.25, {BackgroundColor3 = C.cardHov}):Play()
        Tween(AccentBar, 0.25, {BackgroundTransparency = 0}):Play()
        Tween(Arrow,     0.25, {TextTransparency = 0}):Play()
        Tween(NumBadge,  0.25, {BackgroundColor3 = C.accent}):Play()
        Card:FindFirstChild("Label").TextColor3 = C.white

        currentScript = data.Script
        currentName   = data.Name
        Breadcrumb.Text     = "🎮  " .. data.Name
        GameTitleLabel.Text = data.Name

        DisplayImg.ImageTransparency = 1
        ImgPlaceholder.Visible       = false
        DisplayImg.Image = "rbxthumb://type=Asset&id=" .. data.ID .. "&w=420&h=420"
        Tween(DisplayImg, 0.5, {ImageTransparency = 0}):Play()

        ExecBtn.Visible       = true
        NoSelectLabel.Visible = false
        ExecWrap.BackgroundTransparency = 0
        Tween(ExecGlow, 0.4, {BackgroundTransparency = 0.7}):Play()
    end

    Card.MouseEnter:Connect(function()
        if selectedButton and selectedButton.card == Card then return end
        Tween(Card,  0.2, {BackgroundColor3 = Color3.fromRGB(22,23,32)}):Play()
        Tween(Arrow, 0.2, {TextTransparency = 0.4}):Play()
    end)
    Card.MouseLeave:Connect(function()
        if selectedButton and selectedButton.card == Card then return end
        Tween(Card,  0.2, {BackgroundColor3 = C.card}):Play()
        Tween(Arrow, 0.2, {TextTransparency = 1}):Play()
    end)
    Card.MouseButton1Click:Connect(selectCard)
end

-- ─────────────────────────────────────────
--  SEARCH
-- ─────────────────────────────────────────
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SearchBox.Text:lower()
    for _, e in ipairs(allButtons) do
        e.card.Visible = e.data.Name:lower():find(q, 1, true) ~= nil
    end
end)

-- ─────────────────────────────────────────
--  TOAST (now fully defined)
-- ─────────────────────────────────────────
ShowToast = function(msg, color)
    color = color or C.accent
    task.spawn(function()
        local Toast = New("Frame", {
            Size             = UDim2.fromOffset(240, 42),
            Position         = UDim2.new(1, 260, 0, 20),
            BackgroundColor3 = C.card,
            ZIndex           = 20,
        }, Main)
        Corner(10, Toast)
        Stroke(color, 1.2, Toast)
        New("Frame", {Size=UDim2.fromOffset(3,42), BackgroundColor3=color, ZIndex=21}, Toast)
        Corner(10, Toast:FindFirstChildWhichIsA("Frame"))
        New("TextLabel", {
            Size=UDim2.new(1,-16,1,0), Position=UDim2.new(0,12,0,0),
            BackgroundTransparency=1, Text=msg, TextColor3=C.txt,
            TextSize=12, Font=Enum.Font.Gotham,
            TextXAlignment=Enum.TextXAlignment.Left, ZIndex=22, TextWrapped=true,
        }, Toast)
        Tween(Toast, 0.4, {Position = UDim2.new(1,-252,0,20)}, Enum.EasingStyle.Back):Play()
        task.wait(2.5)
        Tween(Toast, 0.35, {Position = UDim2.new(1,260,0,20)}):Play()
        task.wait(0.4)
        Toast:Destroy()
    end)
end

-- ─────────────────────────────────────────
--  AUTO-EXECUTE PILL LOGIC
-- ─────────────────────────────────────────
AEPill.MouseButton1Click:Connect(function()
    if savedAutoName then
        clearAutoExec()
        savedAutoScript = nil
        savedAutoName   = nil
        AEPill.Text             = "SET"
        AEPill.BackgroundColor3 = C.border
        AELabel.Text            = "Auto Execute: OFF"
        AELabel.TextColor3      = C.txtDim
        ShowToast("⚡  Auto Execute cleared", C.txtDim)
    else
        if not currentScript then
            ShowToast("⚠  Select a game first!", C.orange)
            return
        end
        saveAutoExec(currentScript, currentName)
        savedAutoScript         = currentScript
        savedAutoName           = currentName
        AEPill.Text             = "CLEAR"
        AEPill.BackgroundColor3 = C.orange
        AELabel.Text            = "AUTO: " .. currentName
        AELabel.TextColor3      = C.orange
        ShowToast("⚡  Auto Execute set: " .. currentName, C.orange)
    end
end)

-- ─────────────────────────────────────────
--  EXECUTE LOGIC
-- ─────────────────────────────────────────
ExecBtn.MouseButton1Click:Connect(function()
    if not currentScript then return end

    ExecBtn.Visible        = false
    NoSelectLabel.Text     = "⏳  Loading..."
    NoSelectLabel.Visible  = true
    NoSelectLabel.TextTransparency = 0

    Tween(ExecGlow, 0.1, {BackgroundTransparency = 0.2}):Play()
    task.wait(0.15)
    Tween(ExecGlow, 0.3, {BackgroundTransparency = 0.9}):Play()
    task.wait(0.3)

    -- Hide hub (toggle button stays visible)
    hubVisible = false
    Tween(Main, 0.45, {GroupTransparency = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
    Tween(Glow, 0.45, {BackgroundTransparency = 1}):Play()
    Tween(Blur, 0.45, {Size = 0}):Play()
    ToggleIcon.Text   = "◎"
    togGrad.Color     = ColorSequence.new(C.border, C.border)
    togStroke.Color   = C.border
    task.delay(0.46, function()
        Main.Visible = false
        Glow.Visible = false
    end)

    task.wait(0.5)
    loadstring(game:HttpGet(currentScript, true))()

    -- Reset label for next time
    task.delay(0.5, function()
        NoSelectLabel.Text         = "Select a game first"
        NoSelectLabel.TextTransparency = 0.5
    end)
end)

-- ─────────────────────────────────────────
--  STARTUP NOTIFICATIONS
-- ─────────────────────────────────────────
task.delay(0.8, function()
    ShowToast("✦  Hub loaded — " .. #Games .. " games available", C.accent)
end)
task.delay(2.2, function()
    if savedAutoName then
        ShowToast("⚡  Auto Execute armed: " .. savedAutoName, C.orange)
    end
end)
