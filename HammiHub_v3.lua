-- ╔════════════════════════════════════════════╗
-- ║    HAMMI HUB  –  Brown Edition  v3.0      ║
-- ║  Grid + Bottom Sheet │ Anti-AFK │ AutoExec║
-- ╚════════════════════════════════════════════╝

-- ─────────────────────────────────────────────
--  ANTI-AFK
-- ─────────────────────────────────────────────
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/evxncodes/mainroblox/main/anti-afk", true))()
    end)
end)

local CoreGui          = game:GetService("CoreGui")
local TweenService     = game:GetService("TweenService")
local Lighting         = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

-- ─────────────────────────────────────────────
--  AUTO-EXECUTE FILE SYSTEM
-- ─────────────────────────────────────────────
local AE_FILE      = "HammiAutoExec.txt"
local AE_NAME_FILE = "HammiAutoExecName.txt"

local function readAE()
    local ok, d = pcall(readfile, AE_FILE)
    return (ok and type(d) == "string" and #d > 5) and d or nil
end
local function readAEName()
    local ok, d = pcall(readfile, AE_NAME_FILE)
    return (ok and type(d) == "string" and #d > 0) and d or nil
end
local function saveAE(url, name)
    pcall(writefile, AE_FILE,      url  or "")
    pcall(writefile, AE_NAME_FILE, name or "")
end
local function clearAE()
    pcall(writefile, AE_FILE,      "")
    pcall(writefile, AE_NAME_FILE, "")
end

local savedScript = readAE()
local savedName   = readAEName()
if savedScript then
    task.delay(1.5, function()
        pcall(function() loadstring(game:HttpGet(savedScript, true))() end)
    end)
end

-- ─────────────────────────────────────────────
--  CLEANUP
-- ─────────────────────────────────────────────
if CoreGui:FindFirstChild("HammiHub")    then CoreGui.HammiHub:Destroy()   end
if Lighting:FindFirstChild("HammiBlur") then Lighting.HammiBlur:Destroy() end

-- ─────────────────────────────────────────────
--  BLUR
-- ─────────────────────────────────────────────
local Blur = Instance.new("BlurEffect")
Blur.Name = "HammiBlur"; Blur.Size = 0; Blur.Parent = Lighting
TweenService:Create(Blur, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Size = 14}):Play()

-- ─────────────────────────────────────────────
--  HELPERS
-- ─────────────────────────────────────────────
local function Tw(obj, t, props, sty, dir)
    return TweenService:Create(obj,
        TweenInfo.new(t, sty or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
end
local function New(cls, props, parent)
    local i = Instance.new(cls)
    for k, v in pairs(props) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end
local function Rnd(r, p)   return New("UICorner", {CornerRadius = UDim.new(0, r)}, p) end
local function Brd(c, t, p) return New("UIStroke", {Color = c, Thickness = t, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, p) end

-- ─────────────────────────────────────────────
--  PALETTE  ─  Warm Brown / Espresso
-- ─────────────────────────────────────────────
local C = {
    bg      = Color3.fromRGB( 14,  9,  6),   -- espresso black
    surface = Color3.fromRGB( 23, 16, 10),   -- dark bark
    card    = Color3.fromRGB( 34, 23, 14),   -- medium brown
    cardSel = Color3.fromRGB( 48, 33, 20),   -- lighter brown (selected)
    gold    = Color3.fromRGB(196, 140, 64),  -- warm gold (primary accent)
    gold2   = Color3.fromRGB(224, 176, 96),  -- lighter amber (secondary)
    green   = Color3.fromRGB( 80, 200, 120), -- status green
    red     = Color3.fromRGB(200,  70,  60),
    amber   = Color3.fromRGB(224, 156,  48), -- auto-exec orange-amber
    border  = Color3.fromRGB( 54,  37,  22), -- brown border
    txt     = Color3.fromRGB(234, 218, 198), -- warm cream
    txtDim  = Color3.fromRGB(126, 104,  80), -- dim tan
    white   = Color3.fromRGB(255, 248, 235), -- warm white
    dark    = Color3.fromRGB(  8,   5,   3), -- near black
}

-- ─────────────────────────────────────────────
--  LAYOUT CONSTANTS  (define once, use everywhere)
-- ─────────────────────────────────────────────
local WIN_W    = 620
local WIN_H    = 468
local HEAD_H   = 52     -- header bar
local STAT_H   = 26     -- status strip
local GRID_TOP = HEAD_H + STAT_H   -- 78
local SHEET_H  = 118    -- bottom sheet when open

-- grid heights
local GRID_FULL = WIN_H - GRID_TOP               -- 390  (sheet closed)
local GRID_TRIM = WIN_H - GRID_TOP - SHEET_H     -- 272  (sheet open, no overlap)

-- ─────────────────────────────────────────────
--  SCREEN GUI
-- ─────────────────────────────────────────────
local Gui = Instance.new("ScreenGui")
Gui.Name = "HammiHub"
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.IgnoreGuiInset = true
Gui.Parent = CoreGui

local hubVisible = true

-- ─────────────────────────────────────────────
--  OUTER SHADOW GLOW
-- ─────────────────────────────────────────────
local Shadow = New("Frame", {
    Size             = UDim2.fromOffset(WIN_W + 32, WIN_H + 24),
    Position         = UDim2.new(0.5, -(WIN_W/2 + 16), 0.5, -(WIN_H/2 + 12)),
    BackgroundColor3 = C.gold,
    BackgroundTransparency = 0.88,
    ZIndex           = 1,
}, Gui)
Rnd(22, Shadow)

-- glow breathe
task.spawn(function()
    while Shadow.Parent do
        Tw(Shadow, 2, {BackgroundTransparency = 0.82}, Enum.EasingStyle.Sine):Play()
        task.wait(2)
        Tw(Shadow, 2, {BackgroundTransparency = 0.90}, Enum.EasingStyle.Sine):Play()
        task.wait(2)
    end
end)

-- ─────────────────────────────────────────────
--  MAIN WINDOW
-- ─────────────────────────────────────────────
local Main = New("CanvasGroup", {
    Name             = "Main",
    Size             = UDim2.fromOffset(WIN_W, WIN_H),
    Position         = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
    BackgroundColor3 = C.bg,
    GroupTransparency = 1,
    ClipsDescendants = true,   -- prevents sheet from bleeding outside window
    ZIndex           = 2,
}, Gui)
Rnd(18, Main)
Brd(C.border, 1.4, Main)

-- entrance animation
Tw(Main, 0.5, {GroupTransparency = 0}, Enum.EasingStyle.Back):Play()

-- ─────────────────────────────────────────────
--  DRAG  (main window)
-- ─────────────────────────────────────────────
local dragging, dragStart, winStart
Main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging  = true
        dragStart = inp.Position
        winStart  = Main.Position
    end
end)
Main.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
        local d = inp.Position - dragStart
        Main.Position   = UDim2.new(winStart.X.Scale, winStart.X.Offset + d.X, winStart.Y.Scale, winStart.Y.Offset + d.Y)
        Shadow.Position = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset - 16, Main.Position.Y.Scale, Main.Position.Y.Offset - 12)
    end
end)

-- ─────────────────────────────────────────────
--  HEADER BAR  (top 52 px)
-- ─────────────────────────────────────────────
local Header = New("Frame", {
    Size             = UDim2.new(1, 0, 0, HEAD_H),
    Position         = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.surface,
    ZIndex           = 6,
}, Main)
Rnd(18, Header)
-- square off bottom corners with a fill strip
New("Frame", {
    Size             = UDim2.new(1, 0, 0, 18),
    Position         = UDim2.new(0, 0, 1, -18),
    BackgroundColor3 = C.surface,
    BorderSizePixel  = 0,
    ZIndex           = 6,
}, Header)

-- gold left stripe
local Stripe = New("Frame", {
    Size             = UDim2.fromOffset(4, 28),
    Position         = UDim2.new(0, 14, 0.5, -14),
    BackgroundColor3 = C.gold,
    ZIndex           = 7,
}, Header)
Rnd(2, Stripe)
New("UIGradient", {Color = ColorSequence.new(C.gold2, C.gold), Rotation = 90}, Stripe)

-- Logo
New("TextLabel", {
    Size             = UDim2.fromOffset(100, 26),
    Position         = UDim2.new(0, 26, 0, 10),
    BackgroundTransparency = 1,
    Text             = "HAMMI",
    TextColor3       = C.white,
    TextSize         = 17,
    Font             = Enum.Font.GothamBold,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 7,
}, Header)
New("TextLabel", {
    Size             = UDim2.fromOffset(100, 16),
    Position         = UDim2.new(0, 26, 0, 32),
    BackgroundTransparency = 1,
    Text             = "SCRIPT HUB",
    TextColor3       = C.gold,
    TextSize         = 11,
    Font             = Enum.Font.GothamBold,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 7,
}, Header)

-- Search bar (centered)
local SearchWrap = New("Frame", {
    Size             = UDim2.fromOffset(196, 28),
    Position         = UDim2.new(0.5, -98, 0.5, -14),
    BackgroundColor3 = C.card,
    ZIndex           = 7,
}, Header)
Rnd(28, SearchWrap)
Brd(C.border, 1, SearchWrap)

New("TextLabel", {
    Size             = UDim2.fromOffset(22, 28),
    Position         = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    Text             = "🔍",
    TextSize         = 9,
    TextColor3       = C.txtDim,
    ZIndex           = 8,
}, SearchWrap)

local SearchBox = New("TextBox", {
    Size             = UDim2.new(1, -28, 1, 0),
    Position         = UDim2.new(0, 24, 0, 0),
    BackgroundTransparency = 1,
    PlaceholderText  = "Search games...",
    PlaceholderColor3 = C.txtDim,
    Text             = "",
    TextColor3       = C.txt,
    Font             = Enum.Font.Gotham,
    TextSize         = 12,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    ZIndex           = 8,
}, SearchWrap)

-- Game count badge
local CountBadge = New("Frame", {
    Size             = UDim2.fromOffset(56, 22),
    Position         = UDim2.new(1, -116, 0.5, -11),
    BackgroundColor3 = C.gold,
    BackgroundTransparency = 0.80,
    ZIndex           = 7,
}, Header)
Rnd(11, CountBadge)
local CountLabel = New("TextLabel", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text             = "0 games",
    TextColor3       = C.gold2,
    TextSize         = 9,
    Font             = Enum.Font.GothamBold,
    ZIndex           = 8,
}, CountBadge)

-- Close button
local CloseBtn = New("TextButton", {
    Size             = UDim2.fromOffset(30, 30),
    Position         = UDim2.new(1, -44, 0.5, -15),
    BackgroundColor3 = C.card,
    Text             = "X",
    TextColor3       = C.txtDim,
    TextSize         = 12,
    Font             = Enum.Font.GothamBold,
    AutoButtonColor  = false,
    ZIndex           = 7,
}, Header)
Rnd(9, CloseBtn)
CloseBtn.MouseEnter:Connect(function() Tw(CloseBtn, 0.15, {BackgroundColor3 = C.red, TextColor3 = C.white}):Play() end)
CloseBtn.MouseLeave:Connect(function() Tw(CloseBtn, 0.15, {BackgroundColor3 = C.card, TextColor3 = C.txtDim}):Play() end)
CloseBtn.MouseButton1Click:Connect(function()
    hubVisible = false
    Tw(Main,   0.35, {GroupTransparency = 1}):Play()
    Tw(Blur,   0.35, {Size = 0}):Play()
    task.delay(0.36, function() Main.Visible = false; Shadow.Visible = false end)
end)

-- Header bottom border line
New("Frame", {
    Size             = UDim2.new(1, 0, 0, 1),
    Position         = UDim2.new(0, 0, 1, -1),
    BackgroundColor3 = C.border,
    BorderSizePixel  = 0,
    ZIndex           = 6,
}, Header)

-- ─────────────────────────────────────────────
--  STATUS STRIP  (below header, 26 px)
-- ─────────────────────────────────────────────
local StatusBar = New("Frame", {
    Size             = UDim2.new(1, 0, 0, STAT_H),
    Position         = UDim2.new(0, 0, 0, HEAD_H),
    BackgroundColor3 = C.surface,
    ZIndex           = 5,
}, Main)

New("Frame", {
    Size             = UDim2.new(1, 0, 0, 1),
    Position         = UDim2.new(0, 0, 1, -1),
    BackgroundColor3 = C.border,
    BorderSizePixel  = 0,
    ZIndex           = 5,
}, StatusBar)

-- Anti-AFK pulsing dot
local AfkDot = New("Frame", {
    Size             = UDim2.fromOffset(6, 6),
    Position         = UDim2.new(0, 14, 0.5, -3),
    BackgroundColor3 = C.green,
    ZIndex           = 6,
}, StatusBar)
Rnd(50, AfkDot)
task.spawn(function()
    while AfkDot.Parent do
        Tw(AfkDot, 0.9, {BackgroundTransparency = 0.5}, Enum.EasingStyle.Sine):Play(); task.wait(0.9)
        Tw(AfkDot, 0.9, {BackgroundTransparency = 0},   Enum.EasingStyle.Sine):Play(); task.wait(0.9)
    end
end)

New("TextLabel", {
    Size             = UDim2.fromOffset(110, STAT_H),
    Position         = UDim2.new(0, 26, 0, 0),
    BackgroundTransparency = 1,
    Text             = "ANTI-AFK ON",
    TextColor3       = C.green,
    TextSize         = 8,
    Font             = Enum.Font.GothamBold,
    TextXAlignment   = Enum.TextXAlignment.Left,
    ZIndex           = 6,
}, StatusBar)

-- Divider pip
New("Frame", {
    Size             = UDim2.fromOffset(1, 12),
    Position         = UDim2.new(0, 122, 0.5, -6),
    BackgroundColor3 = C.border,
    ZIndex           = 6,
}, StatusBar)

local AEStripLabel = New("TextLabel", {
    Size             = UDim2.new(1, -130, 1, 0),
    Position         = UDim2.new(0, 130, 0, 0),
    BackgroundTransparency = 1,
    Text             = savedName and ("⚡ AUTO: " .. savedName) or "⚡ AUTO-EXEC: OFF",
    TextColor3       = savedName and C.amber or C.txtDim,
    TextSize         = 8,
    Font             = Enum.Font.GothamBold,
    TextXAlignment   = Enum.TextXAlignment.Left,
    TextTruncate     = Enum.TextTruncate.AtEnd,
    ZIndex           = 6,
}, StatusBar)

-- ─────────────────────────────────────────────
--  GRID SCROLL  (sits between status strip and bottom sheet)
-- ─────────────────────────────────────────────
local GridScroll = New("ScrollingFrame", {
    Size                   = UDim2.new(1, 0, 0, GRID_FULL),
    Position               = UDim2.new(0, 0, 0, GRID_TOP),
    BackgroundTransparency = 1,
    ScrollBarThickness     = 3,
    ScrollBarImageColor3   = C.gold,
    CanvasSize             = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize    = Enum.AutomaticSize.Y,
    ZIndex                 = 3,
}, Main)

local Grid = New("Frame", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    ZIndex           = 3,
}, GridScroll)

New("UIGridLayout", {
    CellSize            = UDim2.fromOffset(176, 132),
    CellPadding         = UDim2.fromOffset(10, 10),
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    SortOrder           = Enum.SortOrder.LayoutOrder,
}, Grid)

New("UIPadding", {
    PaddingTop    = UDim.new(0, 12),
    PaddingBottom = UDim.new(0, 12),
    PaddingLeft   = UDim.new(0, 10),
    PaddingRight  = UDim.new(0, 10),
}, Grid)

-- ─────────────────────────────────────────────
--  BOTTOM SHEET  (slides up when game is selected)
-- ─────────────────────────────────────────────
-- Starts below the window (Position Y = 1,0 = bottom edge = hidden)
local Sheet = New("Frame", {
    Size             = UDim2.new(1, 0, 0, SHEET_H),
    Position         = UDim2.new(0, 0, 1, 0),    -- hidden below window
    BackgroundColor3 = C.surface,
    ZIndex           = 10,
}, Main)
Rnd(18, Sheet)
-- square top corners
New("Frame", {
    Size             = UDim2.new(1, 0, 0, 18),
    Position         = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.surface,
    BorderSizePixel  = 0,
    ZIndex           = 10,
}, Sheet)

-- top border line on sheet
New("Frame", {
    Size             = UDim2.new(1, 0, 0, 1),
    Position         = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = C.border,
    BorderSizePixel  = 0,
    ZIndex           = 11,
}, Sheet)

-- drag handle pill
local Handle = New("Frame", {
    Size             = UDim2.fromOffset(38, 4),
    Position         = UDim2.new(0.5, -19, 0, 8),
    BackgroundColor3 = C.border,
    ZIndex           = 11,
}, Sheet)
Rnd(2, Handle)

-- Game name (left side)
local SheetName = New("TextLabel", {
    Size             = UDim2.new(0.54, 0, 0, 32),
    Position         = UDim2.new(0, 16, 0, 18),
    BackgroundTransparency = 1,
    Text             = "—",
    TextColor3       = C.white,
    TextSize         = 15,
    Font             = Enum.Font.GothamBold,
    TextXAlignment   = Enum.TextXAlignment.Left,
    TextTruncate     = Enum.TextTruncate.AtEnd,
    ZIndex           = 11,
}, Sheet)

-- Tags row
local TagRow = New("Frame", {
    Size             = UDim2.new(0.54, 0, 0, 18),
    Position         = UDim2.new(0, 16, 0, 52),
    BackgroundTransparency = 1,
    ZIndex           = 11,
}, Sheet)
New("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5)}, TagRow)

local function MkTag(txt, col)
    local f = New("Frame", {
        Size          = UDim2.fromOffset(0, 16),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = col,
        BackgroundTransparency = 0.78,
        ZIndex        = 12,
    }, TagRow)
    Rnd(5, f)
    New("UIPadding", {PaddingLeft=UDim.new(0,6), PaddingRight=UDim.new(0,6), PaddingTop=UDim.new(0,1), PaddingBottom=UDim.new(0,1)}, f)
    New("TextLabel", {
        Size          = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text          = txt,
        TextColor3    = col,
        TextSize      = 8,
        Font          = Enum.Font.GothamBold,
        AutomaticSize = Enum.AutomaticSize.X,
        ZIndex        = 13,
    }, f)
end
MkTag("FREE",     C.gold2)
MkTag("UPDATED",  C.green)
MkTag("SAFE",     C.amber)

-- ── Auto-Execute button (right side) ──
local AEBtn = New("TextButton", {
    Size             = UDim2.fromOffset(82, 32),
    Position         = UDim2.new(1, -214, 0.5, -16),
    BackgroundColor3 = savedName and C.amber or C.card,
    Text             = savedName and "⚡ CLEAR" or "⚡ SET AUTO",
    TextColor3       = C.white,
    TextSize         = 9,
    Font             = Enum.Font.GothamBold,
    AutoButtonColor  = false,
    ZIndex           = 11,
}, Sheet)
Rnd(9, AEBtn)
Brd(savedName and C.amber or C.border, 1, AEBtn)

-- ── Execute button ──
local ExecOuter = New("Frame", {
    Size             = UDim2.fromOffset(118, 42),
    Position         = UDim2.new(1, -130, 0.5, -21),
    BackgroundColor3 = C.gold,
    ZIndex           = 11,
}, Sheet)
Rnd(12, ExecOuter)
New("UIGradient", {Color = ColorSequence.new(C.gold2, C.gold), Rotation = 135}, ExecOuter)

local ExecGlow = New("Frame", {
    Size             = UDim2.fromOffset(136, 54),
    Position         = UDim2.new(1, -137, 0.5, -27),
    BackgroundColor3 = C.gold,
    BackgroundTransparency = 1,
    ZIndex           = 9,
}, Sheet)
Rnd(16, ExecGlow)

local ExecBtn = New("TextButton", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text             = "",
    AutoButtonColor  = false,
    ZIndex           = 12,
}, ExecOuter)
New("TextLabel", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text             = "▶  EXECUTE",
    TextColor3       = C.dark,
    TextSize         = 13,
    Font             = Enum.Font.GothamBold,
    ZIndex           = 13,
}, ExecBtn)

local LoadLabel = New("TextLabel", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text             = "",
    TextColor3       = C.dark,
    TextSize         = 11,
    Font             = Enum.Font.Gotham,
    ZIndex           = 13,
    Visible          = false,
}, ExecOuter)

ExecBtn.MouseEnter:Connect(function()
    Tw(ExecOuter, 0.15, {Size = UDim2.fromOffset(122, 44), Position = UDim2.new(1, -132, 0.5, -22)}):Play()
    Tw(ExecGlow,  0.25, {BackgroundTransparency = 0.6}):Play()
end)
ExecBtn.MouseLeave:Connect(function()
    Tw(ExecOuter, 0.15, {Size = UDim2.fromOffset(118, 42), Position = UDim2.new(1, -130, 0.5, -21)}):Play()
    Tw(ExecGlow,  0.25, {BackgroundTransparency = 1}):Play()
end)

-- ── Sheet slide logic ──
local sheetOpen = false

local function openSheet()
    if sheetOpen then return end
    sheetOpen = true
    -- slide sheet up so its top is at WIN_H - SHEET_H = 350
    Tw(Sheet,      0.38, {Position = UDim2.new(0, 0, 1, -SHEET_H)}, Enum.EasingStyle.Back):Play()
    -- shrink grid so it ends at 350, no overlap
    Tw(GridScroll, 0.3,  {Size = UDim2.new(1, 0, 0, GRID_TRIM)}):Play()
end

local function closeSheet()
    if not sheetOpen then return end
    sheetOpen = false
    Tw(Sheet,      0.3, {Position = UDim2.new(0, 0, 1, 0)}):Play()
    Tw(GridScroll, 0.3, {Size = UDim2.new(1, 0, 0, GRID_FULL)}):Play()
end

-- ─────────────────────────────────────────────
--  TOAST NOTIFICATION  (slides down from top-center)
-- ─────────────────────────────────────────────
local ShowToast
ShowToast = function(msg, col)
    col = col or C.gold
    task.spawn(function()
        local Toast = New("Frame", {
            Size             = UDim2.fromOffset(250, 38),
            Position         = UDim2.new(0.5, -125, 0, -48),
            BackgroundColor3 = C.card,
            ZIndex           = 30,
        }, Main)
        Rnd(11, Toast)
        Brd(col, 1.2, Toast)
        -- coloured bottom bar
        local bar = New("Frame", {
            Size             = UDim2.new(1, 0, 0, 3),
            Position         = UDim2.new(0, 0, 1, -3),
            BackgroundColor3 = col,
            ZIndex           = 31,
        }, Toast)
        Rnd(11, bar)
        New("TextLabel", {
            Size             = UDim2.new(1, -14, 1, 0),
            Position         = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text             = msg,
            TextColor3       = C.txt,
            TextSize         = 11,
            Font             = Enum.Font.GothamSemibold,
            TextXAlignment   = Enum.TextXAlignment.Left,
            TextWrapped      = true,
            ZIndex           = 32,
        }, Toast)
        TweenService:Create(Toast, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -125, 0, 6)}):Play()
        task.wait(2.6)
        TweenService:Create(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0.5, -125, 0, -48)}):Play()
        task.wait(0.32)
        Toast:Destroy()
    end)
end

-- ─────────────────────────────────────────────
--  MOBILE TOGGLE BUTTON  (custom image, draggable)
--  Image ID: 2881948982
-- ─────────────────────────────────────────────
local ToggleSize = 54

local ToggleGlow = New("Frame", {
    Size             = UDim2.fromOffset(ToggleSize + 16, ToggleSize + 16),
    Position         = UDim2.new(0, 12, 1, -(ToggleSize + 28)),
    BackgroundColor3 = C.gold,
    BackgroundTransparency = 0.75,
    ZIndex           = 98,
}, Gui)
Rnd(50, ToggleGlow)

-- pulse glow ring
task.spawn(function()
    while ToggleGlow.Parent do
        Tw(ToggleGlow, 1, {BackgroundTransparency = 0.5},  Enum.EasingStyle.Sine):Play(); task.wait(1)
        Tw(ToggleGlow, 1, {BackgroundTransparency = 0.82}, Enum.EasingStyle.Sine):Play(); task.wait(1)
    end
end)

local ToggleWrap = New("Frame", {
    Size             = UDim2.fromOffset(ToggleSize, ToggleSize),
    Position         = UDim2.new(0, 12, 1, -(ToggleSize + 20)),
    BackgroundColor3 = C.surface,
    ZIndex           = 99,
}, Gui)
Rnd(50, ToggleWrap)
Brd(C.gold, 1.8, ToggleWrap)

-- custom image on the toggle
local ToggleImg = New("TextButton", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text             = "🐹",
    Font             = Enum.Font.SourceSansBold,
    TextSize         = 20,
    TextColor3       = Color3.fromRGB(101, 67, 33), 
    ZIndex           = 100,
    AutoButtonColor  = false,
}, ToggleWrap)
Rnd(50, ToggleImg)

-- dim overlay when hub is hidden
local ToggleDim = New("Frame", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = C.dark,
    BackgroundTransparency = 1,
    ZIndex           = 101,
}, ToggleWrap)
Rnd(50, ToggleDim)

-- drag + tap logic
local tDrag, tDragStart, tStartWrap, tStartGlow, tMoved

local function syncGlowPos()
    ToggleGlow.Position = UDim2.new(
        ToggleWrap.Position.X.Scale, ToggleWrap.Position.X.Offset - 8,
        ToggleWrap.Position.Y.Scale, ToggleWrap.Position.Y.Offset - 8
    )
end

ToggleImg.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch
    or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        tDrag      = true
        tMoved     = false
        tDragStart = inp.Position
        tStartWrap = ToggleWrap.Position
        tStartGlow = ToggleGlow.Position
    end
end)

ToggleImg.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Touch
    or inp.UserInputType == Enum.UserInputType.MouseButton1 then
        if not tMoved then
            -- tap = toggle hub visibility
            hubVisible = not hubVisible
            if hubVisible then
                Main.Visible   = true
                Shadow.Visible = true
                Tw(Main,   0.38, {GroupTransparency = 0}, Enum.EasingStyle.Back):Play()
                Tw(Blur,   0.3,  {Size = 14}):Play()
                Tw(ToggleDim, 0.2, {BackgroundTransparency = 1}):Play()
                Brd(C.gold, 1.8, ToggleWrap)
            else
                Tw(Main,   0.3,  {GroupTransparency = 1}):Play()
                Tw(Blur,   0.3,  {Size = 0}):Play()
                task.delay(0.31, function() Main.Visible = false; Shadow.Visible = false end)
                Tw(ToggleDim, 0.2, {BackgroundTransparency = 0.55}):Play()
            end
        end
        tDrag  = false
        tMoved = false
    end
end)

UserInputService.InputChanged:Connect(function(inp)
    if tDrag and (inp.UserInputType == Enum.UserInputType.MouseMovement
    or inp.UserInputType == Enum.UserInputType.Touch) then
        local d = inp.Position - tDragStart
        if math.abs(d.X) > 5 or math.abs(d.Y) > 5 then tMoved = true end
        if tMoved then
            ToggleWrap.Position = UDim2.new(tStartWrap.X.Scale, tStartWrap.X.Offset + d.X, tStartWrap.Y.Scale, tStartWrap.Y.Offset + d.Y)
            syncGlowPos()
        end
    end
end)

-- ─────────────────────────────────────────────
--  GAME DATA
--  Add your games below. Each entry needs:
--    Name   = display name
--    ID     = Roblox place ID (for the thumbnail image)
--    Script = raw URL to your script
-- ─────────────────────────────────────────────
local Games = {
    {Name = "Find Who Slapped",         ID = "72167803024670", Script = "https://raw.githubusercontent.com/jdiejdwkor-source/Findtheslape/refs/heads/main/output.lua"},
}

CountLabel.Text = #Games .. " games"

local currentScript = nil
local currentName   = nil
local allCards      = {}
local selectedCard  = nil

-- ─────────────────────────────────────────────
--  BUILD THUMBNAIL GRID CARDS
-- ─────────────────────────────────────────────
for i, data in ipairs(Games) do

    local Card = New("TextButton", {
        Size             = UDim2.fromOffset(176, 132),
        BackgroundColor3 = C.card,
        Text             = "",
        AutoButtonColor  = false,
        LayoutOrder      = i,
        ZIndex           = 4,
    }, Grid)
    Rnd(12, Card)
    local CardBorder = Brd(C.border, 1, Card)

    -- game thumbnail (fills the card)
    local Thumb = New("ImageLabel", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Image            = "rbxthumb://type=Asset&id=" .. data.ID .. "&w=420&h=420",
        ScaleType        = Enum.ScaleType.Crop,
        ZIndex           = 4,
    }, Card)
    Rnd(12, Thumb)

    -- dark gradient from bottom for text legibility
    local Overlay = New("Frame", {
        Size             = UDim2.new(1, 0, 0.65, 0),
        Position         = UDim2.new(0, 0, 0.35, 0),
        BackgroundColor3 = C.dark,
        ZIndex           = 5,
    }, Card)
    Rnd(12, Overlay)
    local ovg = New("UIGradient", {Rotation = 90}, Overlay)
    ovg.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0.1),
    }

    -- game name at card bottom
    New("TextLabel", {
        Size             = UDim2.new(1, -14, 0, 34),
        Position         = UDim2.new(0, 7, 1, -38),
        BackgroundTransparency = 1,
        Text             = data.Name,
        TextColor3       = C.white,
        TextSize         = 11,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextWrapped      = true,
        ZIndex           = 6,
    }, Card)

    -- number badge top-left
    local NumBg = New("Frame", {
        Size             = UDim2.fromOffset(20, 16),
        Position         = UDim2.new(0, 6, 0, 6),
        BackgroundColor3 = C.dark,
        BackgroundTransparency = 0.35,
        ZIndex           = 6,
    }, Card)
    Rnd(5, NumBg)
    New("TextLabel", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text             = tostring(i),
        TextColor3       = C.gold2,
        TextSize         = 9,
        Font             = Enum.Font.GothamBold,
        ZIndex           = 7,
    }, NumBg)

    -- selection ring (starts invisible)
    local Ring = Brd(C.gold, 0, Card)

    table.insert(allCards, {card = Card, ring = Ring, border = CardBorder, data = data})

    -- hover
    Card.MouseEnter:Connect(function()
        if selectedCard and selectedCard.card == Card then return end
        Tw(Card, 0.15, {BackgroundColor3 = C.cardSel}):Play()
    end)
    Card.MouseLeave:Connect(function()
        if selectedCard and selectedCard.card == Card then return end
        Tw(Card, 0.15, {BackgroundColor3 = C.card}):Play()
    end)

    Card.MouseButton1Click:Connect(function()
        -- deselect previous
        if selectedCard then
            Tw(selectedCard.card, 0.2, {BackgroundColor3 = C.card}):Play()
            selectedCard.ring.Thickness = 0
        end

        selectedCard = {card = Card, ring = Ring, data = data}
        Tw(Card, 0.2, {BackgroundColor3 = C.cardSel}):Play()
        Ring.Thickness = 2.5

        currentScript  = data.Script
        currentName    = data.Name
        SheetName.Text = data.Name

        openSheet()
    end)
end

-- ─────────────────────────────────────────────
--  SEARCH FILTER
-- ─────────────────────────────────────────────
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SearchBox.Text:lower()
    for _, e in ipairs(allCards) do
        e.card.Visible = e.data.Name:lower():find(q, 1, true) ~= nil
    end
end)

-- ─────────────────────────────────────────────
--  AUTO-EXECUTE BUTTON LOGIC
-- ─────────────────────────────────────────────
AEBtn.MouseButton1Click:Connect(function()
    if savedName then
        clearAE()
        savedScript             = nil
        savedName               = nil
        AEBtn.Text              = "⚡ SET AUTO"
        Tw(AEBtn, 0.2, {BackgroundColor3 = C.card}):Play()
        AEStripLabel.Text       = "⚡ AUTO-EXEC: OFF"
        AEStripLabel.TextColor3 = C.txtDim
        ShowToast("Auto Execute cleared", C.txtDim)
    else
        if not currentScript then
            ShowToast("⚠  Select a game first!", C.amber)
            return
        end
        saveAE(currentScript, currentName)
        savedScript             = currentScript
        savedName               = currentName
        AEBtn.Text              = "⚡ CLEAR"
        Tw(AEBtn, 0.2, {BackgroundColor3 = C.amber}):Play()
        AEStripLabel.Text       = "⚡ AUTO: " .. currentName
        AEStripLabel.TextColor3 = C.amber
        ShowToast("Auto Execute → " .. currentName, C.amber)
    end
end)

-- ─────────────────────────────────────────────
--  EXECUTE BUTTON LOGIC
-- ─────────────────────────────────────────────
ExecBtn.MouseButton1Click:Connect(function()
    if not currentScript then return end

    ExecBtn.Visible    = false
    LoadLabel.Text     = "⏳  Loading..."
    LoadLabel.Visible  = true

    Tw(ExecGlow, 0.1, {BackgroundTransparency = 0.3}):Play()
    task.wait(0.2)
    Tw(ExecGlow, 0.3, {BackgroundTransparency = 1}):Play()

    -- hide hub, keep toggle visible
    hubVisible = false
    Tw(Main,   0.4, {GroupTransparency = 1}, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
    Tw(Blur,   0.4, {Size = 0}):Play()
    task.delay(0.41, function() Main.Visible = false; Shadow.Visible = false end)
    Tw(ToggleDim, 0.2, {BackgroundTransparency = 0.55}):Play()

    task.wait(0.5)
    loadstring(game:HttpGet(currentScript, true))()

    task.delay(0.6, function()
        LoadLabel.Visible = false
        LoadLabel.Text    = ""
        ExecBtn.Visible   = true
    end)
end)

-- ─────────────────────────────────────────────
--  STARTUP TOASTS
-- ─────────────────────────────────────────────
task.delay(0.7, function()
    ShowToast("✦  Hammi Hub — " .. #Games .. " scripts ready", C.gold)
end)
task.delay(2.3, function()
    if savedName then
        ShowToast("⚡ Auto-exec armed: " .. savedName, C.amber)
    end
end)
