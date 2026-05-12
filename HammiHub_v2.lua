-- ╔═══════════════════════════════════════════╗
-- ║   HAMMI HUB  –  Grid Edition  v2.0       ║
-- ║   Layout: Thumbnail Grid + Bottom Sheet  ║
-- ║   Anti-AFK │ Auto-Exec │ Mobile Toggle   ║
-- ╚═══════════════════════════════════════════╝

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
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ─────────────────────────────────────────────
--  AUTO-EXECUTE FILES
-- ─────────────────────────────────────────────
local AE_FILE      = "HammiAutoExec.txt"
local AE_NAME_FILE = "HammiAutoExecName.txt"

local function readAE()
    local ok, d = pcall(readfile, AE_FILE)
    return (ok and type(d)=="string" and #d>5) and d or nil
end
local function readAEName()
    local ok, d = pcall(readfile, AE_NAME_FILE)
    return (ok and type(d)=="string" and #d>0) and d or nil
end
local function saveAE(url, name)
    pcall(writefile, AE_FILE,      url  or "")
    pcall(writefile, AE_NAME_FILE, name or "")
end
local function clearAE()
    pcall(writefile, AE_FILE, "")
    pcall(writefile, AE_NAME_FILE, "")
end

local savedScript = readAE()
local savedName   = readAEName()
if savedScript then
    task.delay(1.5, function() pcall(function() loadstring(game:HttpGet(savedScript,true))() end) end)
end

-- ─────────────────────────────────────────────
--  CLEANUP
-- ─────────────────────────────────────────────
if CoreGui:FindFirstChild("HammiHub")    then CoreGui.HammiHub:Destroy()       end
if Lighting:FindFirstChild("HammiBlur") then Lighting.HammiBlur:Destroy()     end

-- ─────────────────────────────────────────────
--  BLUR
-- ─────────────────────────────────────────────
local Blur = Instance.new("BlurEffect")
Blur.Name = "HammiBlur"; Blur.Size = 0; Blur.Parent = Lighting
TweenService:Create(Blur, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Size=14}):Play()

-- ─────────────────────────────────────────────
--  HELPERS
-- ─────────────────────────────────────────────
local function T(obj, t, props, sty, dir)
    return TweenService:Create(obj, TweenInfo.new(t, sty or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
end
local function N(cls, props, parent)
    local i = Instance.new(cls)
    for k,v in pairs(props) do i[k]=v end
    if parent then i.Parent=parent end
    return i
end
local function Rnd(r,p)  return N("UICorner",{CornerRadius=UDim.new(0,r)},p) end
local function Brdr(c,t,p) return N("UIStroke",{Color=c,Thickness=t,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},p) end

-- ─────────────────────────────────────────────
--  PALETTE  –  Charcoal + Electric Lime
-- ─────────────────────────────────────────────
local C = {
    bg      = Color3.fromRGB(13, 14, 17),
    surface = Color3.fromRGB(19, 21, 26),
    card    = Color3.fromRGB(24, 27, 34),
    cardSel = Color3.fromRGB(30, 35, 44),
    lime    = Color3.fromRGB(163, 230,  53),   -- electric lime  (primary)
    lime2   = Color3.fromRGB( 74, 222, 128),   -- emerald green  (secondary)
    red     = Color3.fromRGB(239,  68,  68),
    amber   = Color3.fromRGB(251, 191,  36),
    border  = Color3.fromRGB( 36,  40,  52),
    txt     = Color3.fromRGB(226, 232, 240),
    txtDim  = Color3.fromRGB( 99, 110, 135),
    white   = Color3.fromRGB(255, 255, 255),
}

-- ─────────────────────────────────────────────
--  SCREEN GUI
-- ─────────────────────────────────────────────
local Gui = Instance.new("ScreenGui")
Gui.Name="HammiHub"; Gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
Gui.IgnoreGuiInset=true; Gui.Parent=CoreGui

local hubVisible = true

-- ─────────────────────────────────────────────
--  SHADOW / GLOW
-- ─────────────────────────────────────────────
local Shadow = N("Frame",{
    Size=UDim2.fromOffset(652,490),
    Position=UDim2.new(0.5,-326,0.5,-245),
    BackgroundColor3=C.lime,
    BackgroundTransparency=0.91,
    ZIndex=1,
},Gui)
Rnd(20,Shadow)

-- ─────────────────────────────────────────────
--  MAIN WINDOW  620 × 468
-- ─────────────────────────────────────────────
local WIN_W, WIN_H = 620, 468
local Main = N("CanvasGroup",{
    Name="Main",
    Size=UDim2.fromOffset(WIN_W, WIN_H),
    Position=UDim2.new(0.5,-WIN_W/2,0.5,-WIN_H/2),
    BackgroundColor3=C.bg,
    GroupTransparency=1,
    ZIndex=2,
},Gui)
Rnd(18,Main)
Brdr(C.border, 1.2, Main)

-- entrance
T(Main, 0.55, {GroupTransparency=0}, Enum.EasingStyle.Back):Play()

-- ─────────────────────────────────────────────
--  DRAG (main window)
-- ─────────────────────────────────────────────
local dragging, dragStart, winStart
Main.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true; dragStart=inp.Position; winStart=Main.Position
    end
end)
Main.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)
UserInputService.InputChanged:Connect(function(inp)
    if dragging and inp.UserInputType==Enum.UserInputType.MouseMovement then
        local d=inp.Position-dragStart
        Main.Position=UDim2.new(winStart.X.Scale,winStart.X.Offset+d.X,winStart.Y.Scale,winStart.Y.Offset+d.Y)
        Shadow.Position=UDim2.new(Main.Position.X.Scale,Main.Position.X.Offset-16,Main.Position.Y.Scale,Main.Position.Y.Offset-11)
    end
end)

-- ─────────────────────────────────────────────
--  TOP HEADER BAR  (height 52)
-- ─────────────────────────────────────────────
local Header = N("Frame",{
    Size=UDim2.new(1,0,0,52),
    BackgroundColor3=C.surface,
    ZIndex=5,
},Main)
Rnd(18,Header)
-- square bottom corners via cover frame
N("Frame",{Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,1,-18),BackgroundColor3=C.surface,BorderSizePixel=0,ZIndex=5},Header)

-- lime left accent stripe
local Stripe = N("Frame",{
    Size=UDim2.fromOffset(4,30),
    Position=UDim2.new(0,14,0.5,-15),
    BackgroundColor3=C.lime,
    ZIndex=6,
},Header)
Rnd(2,Stripe)
N("UIGradient",{Color=ColorSequence.new(C.lime,C.lime2),Rotation=90},Stripe)

-- Logo text
N("TextLabel",{
    Size=UDim2.fromOffset(80,52),
    Position=UDim2.new(0,26,0,0),
    BackgroundTransparency=1,
    Text="HAMMI",
    TextColor3=C.white,
    TextSize=17,
    Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=6,
},Header)
N("TextLabel",{
    Size=UDim2.fromOffset(76,52),
    Position=UDim2.new(0,26,0,22),
    BackgroundTransparency=1,
    Text="SCRIPT HUB",
    TextColor3=C.lime,
    TextSize=8,
    Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left,
    ZIndex=6,
},Header)

-- Search bar (center)
local SearchWrap = N("Frame",{
    Size=UDim2.fromOffset(200,30),
    Position=UDim2.new(0.5,-100,0.5,-15),
    BackgroundColor3=C.card,
    ZIndex=6,
},Header)
Rnd(30,SearchWrap)
Brdr(C.border,1,SearchWrap)

N("TextLabel",{
    Size=UDim2.fromOffset(24,30),Position=UDim2.new(0,8,0,0),
    BackgroundTransparency=1,Text="⌕",TextSize=14,TextColor3=C.txtDim,ZIndex=7,
},SearchWrap)
local SearchBox = N("TextBox",{
    Size=UDim2.new(1,-28,1,0),Position=UDim2.new(0,24,0,0),
    BackgroundTransparency=1,PlaceholderText="Search...",
    PlaceholderColor3=C.txtDim,Text="",TextColor3=C.txt,
    Font=Enum.Font.Gotham,TextSize=12,
    TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false,ZIndex=7,
},SearchWrap)

-- Right side: count badge + close
local CountBadge = N("Frame",{
    Size=UDim2.fromOffset(44,22),
    Position=UDim2.new(1,-106,0.5,-11),
    BackgroundColor3=C.lime,
    BackgroundTransparency=0.82,
    ZIndex=6,
},Header)
Rnd(11,CountBadge)
local CountLabel = N("TextLabel",{
    Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
    Text="0 games",TextColor3=C.lime,TextSize=9,Font=Enum.Font.GothamBold,ZIndex=7,
},CountBadge)

local CloseBtn = N("TextButton",{
    Size=UDim2.fromOffset(30,30),
    Position=UDim2.new(1,-44,0.5,-15),
    BackgroundColor3=C.card,
    Text="✕",TextColor3=C.txtDim,TextSize=13,Font=Enum.Font.GothamBold,
    AutoButtonColor=false,ZIndex=6,
},Header)
Rnd(9,CloseBtn)
CloseBtn.MouseEnter:Connect(function() T(CloseBtn,0.15,{BackgroundColor3=C.red,TextColor3=C.white}):Play() end)
CloseBtn.MouseLeave:Connect(function() T(CloseBtn,0.15,{BackgroundColor3=C.card,TextColor3=C.txtDim}):Play() end)
CloseBtn.MouseButton1Click:Connect(function()
    hubVisible=false
    T(Main,0.35,{GroupTransparency=1}):Play()
    T(Blur,0.35,{Size=0}):Play()
    task.delay(0.36,function() Main.Visible=false; Shadow.Visible=false end)
end)

-- header bottom border
N("Frame",{
    Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),
    BackgroundColor3=C.border,BorderSizePixel=0,ZIndex=5,
},Header)

-- ─────────────────────────────────────────────
--  STATUS STRIP  (below header)
-- ─────────────────────────────────────────────
local StatusBar = N("Frame",{
    Size=UDim2.new(1,0,0,26),
    Position=UDim2.new(0,0,0,52),
    BackgroundColor3=C.surface,
    ZIndex=4,
},Main)
N("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=C.border,BorderSizePixel=0,ZIndex=5},StatusBar)

-- Anti-AFK dot
local AfkDot = N("Frame",{Size=UDim2.fromOffset(6,6),Position=UDim2.new(0,14,0.5,-3),BackgroundColor3=C.lime,ZIndex=5},StatusBar)
Rnd(50,AfkDot)
task.spawn(function()
    while AfkDot.Parent do
        T(AfkDot,0.8,{BackgroundTransparency=0.5},Enum.EasingStyle.Sine):Play(); task.wait(0.8)
        T(AfkDot,0.8,{BackgroundTransparency=0},Enum.EasingStyle.Sine):Play(); task.wait(0.8)
    end
end)
N("TextLabel",{
    Size=UDim2.fromOffset(100,26),Position=UDim2.new(0,26,0,0),
    BackgroundTransparency=1,Text="ANTI-AFK ON",TextColor3=C.lime,
    TextSize=8,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,
},StatusBar)

-- AE status in strip
local AEStripLabel = N("TextLabel",{
    Size=UDim2.new(1,-200,1,0),Position=UDim2.new(0,130,0,0),
    BackgroundTransparency=1,
    Text=savedName and ("⚡ AUTO-EXEC: "..savedName) or "⚡ AUTO-EXEC: OFF",
    TextColor3=savedName and C.amber or C.txtDim,
    TextSize=8,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5,
},StatusBar)

-- ─────────────────────────────────────────────
--  SCROLLABLE GRID AREA
-- ─────────────────────────────────────────────
local GRID_TOP    = 78          -- header(52) + status(26)
local SHEET_H     = 120         -- bottom sheet height when open
local GRID_H      = WIN_H - GRID_TOP - SHEET_H

local GridScroll = N("ScrollingFrame",{
    Size=UDim2.new(1,0,0,WIN_H - GRID_TOP),   -- will shrink when sheet opens
    Position=UDim2.new(0,0,0,GRID_TOP),
    BackgroundTransparency=1,
    ScrollBarThickness=3,
    ScrollBarImageColor3=C.lime,
    CanvasSize=UDim2.new(0,0,0,0),
    AutomaticCanvasSize=Enum.AutomaticSize.Y,
    ZIndex=3,
},Main)

local Grid = N("Frame",{
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    ZIndex=3,
},GridScroll)

local GridLayout = N("UIGridLayout",{
    CellSize=UDim2.fromOffset(176,132),
    CellPadding=UDim2.fromOffset(10,10),
    HorizontalAlignment=Enum.HorizontalAlignment.Center,
    SortOrder=Enum.SortOrder.LayoutOrder,
},Grid)
N("UIPadding",{PaddingTop=UDim.new(0,12),PaddingBottom=UDim.new(0,12),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10)},Grid)

-- ─────────────────────────────────────────────
--  BOTTOM SHEET  (slides up on select)
-- ─────────────────────────────────────────────
local Sheet = N("Frame",{
    Size=UDim2.new(1,0,0,SHEET_H),
    Position=UDim2.new(0,0,1,0),   -- starts hidden below
    BackgroundColor3=C.surface,
    ZIndex=8,
    ClipsDescendants=true,
},Main)
Rnd(18,Sheet)
N("Frame",{Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,0,0),BackgroundColor3=C.surface,BorderSizePixel=0,ZIndex=8},Sheet)
Brdr(C.border,1,Sheet)
N("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,0,0),BackgroundColor3=C.border,BorderSizePixel=0,ZIndex=9},Sheet)

-- Pill handle
local Handle = N("Frame",{
    Size=UDim2.fromOffset(36,4),
    Position=UDim2.new(0.5,-18,0,8),
    BackgroundColor3=C.border,
    ZIndex=9,
},Sheet)
Rnd(2,Handle)

-- Left: game name + tags
local SheetName = N("TextLabel",{
    Size=UDim2.new(0.55,0,0,36),
    Position=UDim2.new(0,16,0,18),
    BackgroundTransparency=1,
    Text="—",TextColor3=C.white,
    TextSize=16,Font=Enum.Font.GothamBold,
    TextXAlignment=Enum.TextXAlignment.Left,
    TextTruncate=Enum.TextTruncate.AtEnd,
    ZIndex=9,
},Sheet)

-- Tag row
local TagRow = N("Frame",{
    Size=UDim2.new(0.55,0,0,20),
    Position=UDim2.new(0,16,0,52),
    BackgroundTransparency=1,ZIndex=9,
},Sheet)
N("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,5)},TagRow)

local function MkTag(txt, col)
    local f=N("Frame",{Size=UDim2.fromOffset(0,18),AutomaticSize=Enum.AutomaticSize.X,
        BackgroundColor3=col,BackgroundTransparency=0.8,ZIndex=10},TagRow)
    Rnd(5,f)
    N("UIPadding",{PaddingLeft=UDim.new(0,6),PaddingRight=UDim.new(0,6),PaddingTop=UDim.new(0,1),PaddingBottom=UDim.new(0,1)},f)
    N("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=txt,
        TextColor3=col,TextSize=8,Font=Enum.Font.GothamBold,AutomaticSize=Enum.AutomaticSize.X,ZIndex=11},f)
end
MkTag("FREE",     C.lime)
MkTag("UPDATED",  C.lime2)
MkTag("SAFE",     C.amber)

-- Right side: AE button + Execute button
local AEBtn = N("TextButton",{
    Size=UDim2.fromOffset(78,34),
    Position=UDim2.new(1,-210,0.5,-17),
    BackgroundColor3=savedName and C.amber or C.card,
    Text=savedName and "⚡ CLEAR" or "⚡ SET AUTO",
    TextColor3=C.white,TextSize=9,Font=Enum.Font.GothamBold,
    AutoButtonColor=false,ZIndex=9,
},Sheet)
Rnd(10,AEBtn)
Brdr(savedName and C.amber or C.border,1,AEBtn)

-- Execute button
local ExecOuter = N("Frame",{
    Size=UDim2.fromOffset(118,44),
    Position=UDim2.new(1,-130,0.5,-22),
    BackgroundColor3=C.lime,
    ZIndex=9,
},Sheet)
Rnd(13,ExecOuter)
N("UIGradient",{Color=ColorSequence.new(C.lime,C.lime2),Rotation=135},ExecOuter)

-- glow behind exec button
local ExecGlow = N("Frame",{
    Size=UDim2.fromOffset(134,56),
    Position=UDim2.new(1,-136,0.5,-28),
    BackgroundColor3=C.lime,
    BackgroundTransparency=1,
    ZIndex=7,
},Sheet)
Rnd(16,ExecGlow)

local ExecBtn = N("TextButton",{
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,
    Text="",AutoButtonColor=false,ZIndex=10,
},ExecOuter)
N("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
    Text="▶  EXECUTE",TextColor3=C.bg,TextSize=13,Font=Enum.Font.GothamBold,ZIndex=11},ExecBtn)

-- Loading label (replaces execute text while loading)
local LoadLabel = N("TextLabel",{
    Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
    Text="",TextColor3=C.bg,TextSize=11,Font=Enum.Font.Gotham,
    ZIndex=11,Visible=false,
},ExecOuter)

ExecBtn.MouseEnter:Connect(function()
    T(ExecOuter,0.15,{Size=UDim2.fromOffset(122,46),Position=UDim2.new(1,-132,0.5,-23)}):Play()
    T(ExecGlow,0.25,{BackgroundTransparency=0.6}):Play()
end)
ExecBtn.MouseLeave:Connect(function()
    T(ExecOuter,0.15,{Size=UDim2.fromOffset(118,44),Position=UDim2.new(1,-130,0.5,-22)}):Play()
    T(ExecGlow,0.25,{BackgroundTransparency=1}):Play()
end)

-- Sheet open/close state
local sheetOpen = false

local function openSheet()
    if sheetOpen then return end
    sheetOpen = true
    T(Sheet,   0.38, {Position=UDim2.new(0,0,1,-SHEET_H)}, Enum.EasingStyle.Back):Play()
    T(GridScroll,0.3, {Size=UDim2.new(1,0,0,WIN_H-GRID_TOP-SHEET_H)}):Play()
end
local function closeSheet()
    if not sheetOpen then return end
    sheetOpen = false
    T(Sheet,     0.3,  {Position=UDim2.new(0,0,1,0)}):Play()
    T(GridScroll,0.3,  {Size=UDim2.new(1,0,0,WIN_H-GRID_TOP)}):Play()
end

-- ─────────────────────────────────────────────
--  TOAST
-- ─────────────────────────────────────────────
local ShowToast
ShowToast = function(msg, col)
    col = col or C.lime
    task.spawn(function()
        local T2 = N("Frame",{
            Size=UDim2.fromOffset(244,40),
            Position=UDim2.new(0.5,-122,0,-50),
            BackgroundColor3=C.card,ZIndex=30,
        },Main)
        Rnd(12,T2)
        Brdr(col,1.2,T2)
        local bar = N("Frame",{Size=UDim2.fromOffset(244,3),Position=UDim2.new(0,0,1,-3),BackgroundColor3=col,ZIndex=31},T2)
        Rnd(12,bar)
        N("TextLabel",{
            Size=UDim2.new(1,-16,1,0),Position=UDim2.new(0,10,0,0),
            BackgroundTransparency=1,Text=msg,TextColor3=C.txt,
            TextSize=11,Font=Enum.Font.GothamSemibold,ZIndex=32,
            TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,
        },T2)
        -- slides down from top
        TweenService:Create(T2,TweenInfo.new(0.4,Enum.EasingStyle.Back),{Position=UDim2.new(0.5,-122,0,8)}):Play()
        task.wait(2.5)
        TweenService:Create(T2,TweenInfo.new(0.3,Enum.EasingStyle.Quint),{Position=UDim2.new(0.5,-122,0,-50)}):Play()
        task.wait(0.35); T2:Destroy()
    end)
end

-- ─────────────────────────────────────────────
--  MOBILE TOGGLE BUTTON  (pill style, draggable)
-- ─────────────────────────────────────────────
local Pill = N("Frame",{
    Size=UDim2.fromOffset(72,32),
    Position=UDim2.new(0,12,1,-48),
    BackgroundColor3=C.lime,
    ZIndex=100,
},Gui)
Rnd(30,Pill)
N("UIGradient",{Color=ColorSequence.new(C.lime,C.lime2),Rotation=90},Pill)

local PillGlow = N("Frame",{
    Size=UDim2.fromOffset(84,44),
    Position=UDim2.new(0.5,-42,0.5,-22),
    BackgroundColor3=C.lime,
    BackgroundTransparency=0.75,
    ZIndex=99,
},Pill)
Rnd(30,PillGlow)
task.spawn(function()
    while Pill.Parent do
        T(PillGlow,1,{BackgroundTransparency=0.5},Enum.EasingStyle.Sine):Play(); task.wait(1)
        T(PillGlow,1,{BackgroundTransparency=0.82},Enum.EasingStyle.Sine):Play(); task.wait(1)
    end
end)

local PillBtn = N("TextButton",{
    Size=UDim2.new(1,0,1,0),
    BackgroundTransparency=1,Text="",AutoButtonColor=false,ZIndex=101,
},Pill)
local PillIcon = N("TextLabel",{
    Size=UDim2.fromOffset(22,32),Position=UDim2.new(0,6,0,0),
    BackgroundTransparency=1,Text="◉",TextColor3=C.bg,
    TextSize=14,Font=Enum.Font.GothamBold,ZIndex=102,
},Pill)
local PillTxt = N("TextLabel",{
    Size=UDim2.fromOffset(40,32),Position=UDim2.new(0,24,0,0),
    BackgroundTransparency=1,Text="HUB",TextColor3=C.bg,
    TextSize=10,Font=Enum.Font.GothamBold,ZIndex=102,
},Pill)

-- Drag toggle
local pDrag,pDragStart,pStart,pMoved
PillBtn.InputBegan:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then
        pDrag=true; pMoved=false; pDragStart=inp.Position; pStart=Pill.Position
    end
end)
PillBtn.InputEnded:Connect(function(inp)
    if inp.UserInputType==Enum.UserInputType.Touch or inp.UserInputType==Enum.UserInputType.MouseButton1 then
        if not pMoved then
            hubVisible=not hubVisible
            if hubVisible then
                Main.Visible=true; Shadow.Visible=true
                T(Main,0.38,{GroupTransparency=0},Enum.EasingStyle.Back):Play()
                T(Blur,0.3,{Size=14}):Play()
                PillIcon.Text="◉"; PillTxt.Text="HUB"
                N("UIGradient",{Color=ColorSequence.new(C.lime,C.lime2),Rotation=90},Pill)
            else
                T(Main,0.3,{GroupTransparency=1}):Play()
                T(Blur,0.3,{Size=0}):Play()
                task.delay(0.31,function() Main.Visible=false; Shadow.Visible=false end)
                PillIcon.Text="○"; PillTxt.Text="OPEN"
            end
        end
        pDrag=false; pMoved=false
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if pDrag and (inp.UserInputType==Enum.UserInputType.MouseMovement or inp.UserInputType==Enum.UserInputType.Touch) then
        local d=inp.Position-pDragStart
        if math.abs(d.X)>5 or math.abs(d.Y)>5 then pMoved=true end
        if pMoved then
            Pill.Position=UDim2.new(pStart.X.Scale,pStart.X.Offset+d.X,pStart.Y.Scale,pStart.Y.Offset+d.Y)
        end
    end
end)

-- ─────────────────────────────────────────────
--  GAME DATA  –  add yours here!
-- ─────────────────────────────────────────────
--[[
    HOW TO ADD A GAME:
    { Name="Game Name", ID="PLACE_ID", Script="https://raw.github..." },

    ID  = the number in the Roblox game URL  (used for thumbnail)
    Script = raw URL to your Lua script
]]
local Games = {
    {Name="Nuke Your City",              ID="113918641206373", Script="https://raw.githubusercontent.com/robdipekks-cell/Nuke/refs/heads/main/Nukes"},
    {Name="Oil Empire",                  ID="107095834793267", Script="https://raw.githubusercontent.com/robdipekks-cell/Oil/refs/heads/main/Oiled"},
    {Name="Be A Youtuber",               ID="120564326011184", Script="https://raw.githubusercontent.com/robdipekks-cell/Youtube/refs/heads/main/Ye"},
    {Name="Dont Get Caught",             ID="91350524990442",  Script="https://raw.githubusercontent.com/robdipekks-cell/As/refs/heads/main/FluentGUI%20(4).lua"},
    {Name="Be A Streamer",               ID="119126689474503", Script="https://raw.githubusercontent.com/robdipekks-cell/Be-a-streamer/refs/heads/main/A"},
    {Name="Fireball Training",           ID="129195078205390", Script="https://raw.githubusercontent.com/robdipekks-cell/Fireball-/refs/heads/main/A"},
    {Name="Roll An Anime",               ID="93999763241813",  Script="https://raw.githubusercontent.com/robdipekks-cell/Roll-anime/refs/heads/main/A"},
    {Name="Build A Store",               ID="123260699475631", Script="https://raw.githubusercontent.com/robdipekks-cell/Build-store/refs/heads/main/A"},
    {Name="Guess The Slapper",           ID="106683702021527", Script="https://raw.githubusercontent.com/robdipekks-cell/slap/refs/heads/main/A"},
    {Name="Field Trip Z",                ID="4954096313",      Script="https://raw.githubusercontent.com/robdipekks-cell/Field/refs/heads/main/A"},
    {Name="Dont Steal Brainrot",         ID="140711793067980", Script="https://raw.githubusercontent.com/robdipekks-cell/Dontstealabrainro/refs/heads/main/A"},
    {Name="Nuke For Brainrot",           ID="109908567838703", Script="https://raw.githubusercontent.com/robdipekks-cell/Nukeabrainror/refs/heads/main/AutoFarm%20(6).lua"},
    {Name="Be A Lucky Block",            ID="86264517332527",  Script="https://raw.githubusercontent.com/robdipekks-cell/Be-a-lucky/refs/heads/main/A"},
    {Name="Be Flash For Brainrots",      ID="136066387156306", Script="https://raw.githubusercontent.com/robdipekks-cell/Flash-brainrot/refs/heads/main/A"},
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
    local Card = N("TextButton",{
        Size=UDim2.fromOffset(176,132),
        BackgroundColor3=C.card,
        Text="",AutoButtonColor=false,
        LayoutOrder=i,ZIndex=4,
    },Grid)
    Rnd(12,Card)
    Brdr(C.border,1,Card)

    -- thumbnail image (fills card)
    local Thumb = N("ImageLabel",{
        Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1,
        Image="rbxthumb://type=Asset&id="..data.ID.."&w=420&h=420",
        ScaleType=Enum.ScaleType.Crop,
        ImageTransparency=0,
        ZIndex=4,
        ClipsDescendants=true,
    },Card)
    Rnd(12,Thumb)

    -- gradient overlay from bottom for readability
    local Overlay = N("Frame",{
        Size=UDim2.new(1,0,0.6,0),
        Position=UDim2.new(0,0,0.4,0),
        BackgroundColor3=Color3.fromRGB(0,0,0),
        ZIndex=5,
    },Card)
    Rnd(12,Overlay)
    local ovg = N("UIGradient",{Rotation=90},Overlay)
    ovg.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0,1),
        NumberSequenceKeypoint.new(1,0.15),
    }

    -- game name label at bottom
    N("TextLabel",{
        Size=UDim2.new(1,-12,0,32),
        Position=UDim2.new(0,6,1,-36),
        BackgroundTransparency=1,
        Text=data.Name,TextColor3=C.white,
        TextSize=11,Font=Enum.Font.GothamBold,
        TextXAlignment=Enum.TextXAlignment.Left,
        TextWrapped=true,ZIndex=6,
    },Card)

    -- number badge top-left
    local Num = N("Frame",{
        Size=UDim2.fromOffset(20,16),
        Position=UDim2.new(0,6,0,6),
        BackgroundColor3=Color3.fromRGB(0,0,0),
        BackgroundTransparency=0.4,
        ZIndex=6,
    },Card)
    Rnd(5,Num)
    N("TextLabel",{
        Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,
        Text=tostring(i),TextColor3=C.txt,TextSize=9,Font=Enum.Font.GothamBold,ZIndex=7,
    },Num)

    -- selected ring (hidden by default)
    local Ring = Brdr(C.lime, 0, Card)

    table.insert(allCards, {card=Card, ring=Ring, data=data})

    -- hover
    Card.MouseEnter:Connect(function()
        if selectedCard and selectedCard.card==Card then return end
        T(Card,0.15,{BackgroundColor3=C.cardSel}):Play()
    end)
    Card.MouseLeave:Connect(function()
        if selectedCard and selectedCard.card==Card then return end
        T(Card,0.15,{BackgroundColor3=C.card}):Play()
    end)

    Card.MouseButton1Click:Connect(function()
        -- deselect old
        if selectedCard then
            T(selectedCard.card,0.2,{BackgroundColor3=C.card}):Play()
            selectedCard.ring.Thickness=0
        end

        selectedCard = {card=Card, ring=Ring, data=data}
        T(Card,0.2,{BackgroundColor3=C.cardSel}):Play()
        Ring.Thickness = 2

        currentScript = data.Script
        currentName   = data.Name

        -- update sheet
        SheetName.Text = data.Name
        openSheet()
    end)
end

-- ─────────────────────────────────────────────
--  SEARCH
-- ─────────────────────────────────────────────
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SearchBox.Text:lower()
    for _, e in ipairs(allCards) do
        e.card.Visible = e.data.Name:lower():find(q,1,true)~=nil
    end
end)

-- ─────────────────────────────────────────────
--  AUTO-EXECUTE BUTTON
-- ─────────────────────────────────────────────
AEBtn.MouseButton1Click:Connect(function()
    if savedName then
        clearAE()
        savedScript=nil; savedName=nil
        AEBtn.Text="⚡ SET AUTO"
        T(AEBtn,0.2,{BackgroundColor3=C.card}):Play()
        Brdr(C.border,1,AEBtn)
        AEStripLabel.Text="⚡ AUTO-EXEC: OFF"
        AEStripLabel.TextColor3=C.txtDim
        ShowToast("Auto Execute cleared",C.txtDim)
    else
        if not currentScript then ShowToast("⚠  Select a game first!",C.amber); return end
        saveAE(currentScript,currentName)
        savedScript=currentScript; savedName=currentName
        AEBtn.Text="⚡ CLEAR"
        T(AEBtn,0.2,{BackgroundColor3=C.amber}):Play()
        AEStripLabel.Text="⚡ AUTO-EXEC: "..currentName
        AEStripLabel.TextColor3=C.amber
        ShowToast("Auto Execute → "..currentName, C.amber)
    end
end)

-- ─────────────────────────────────────────────
--  EXECUTE
-- ─────────────────────────────────────────────
ExecBtn.MouseButton1Click:Connect(function()
    if not currentScript then return end

    -- loading state
    ExecBtn.Visible=false
    LoadLabel.Text="⏳ Loading..."
    LoadLabel.Visible=true
    T(ExecGlow,0.1,{BackgroundTransparency=0.3}):Play()
    task.wait(0.2)
    T(ExecGlow,0.3,{BackgroundTransparency=1}):Play()

    -- hide hub
    hubVisible=false
    T(Main,0.4,{GroupTransparency=1},Enum.EasingStyle.Back,Enum.EasingDirection.In):Play()
    T(Blur,0.4,{Size=0}):Play()
    task.delay(0.41,function() Main.Visible=false; Shadow.Visible=false end)
    PillIcon.Text="○"; PillTxt.Text="OPEN"

    task.wait(0.5)
    loadstring(game:HttpGet(currentScript,true))()

    task.delay(0.6,function()
        LoadLabel.Visible=false
        LoadLabel.Text=""
        ExecBtn.Visible=true
    end)
end)

-- ─────────────────────────────────────────────
--  STARTUP TOASTS
-- ─────────────────────────────────────────────
task.delay(0.7,  function() ShowToast("✦ Hammi Hub  –  "..#Games.." scripts ready", C.lime) end)
task.delay(2.2,  function()
    if savedName then ShowToast("⚡ Auto-exec armed: "..savedName, C.amber) end
end)
