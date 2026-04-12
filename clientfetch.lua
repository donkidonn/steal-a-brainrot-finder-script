--[[
    Axion Hub - Steal a Brainrot Notifier
    Viewer GUI
]]

-- database and teleport info
local SUPABASE_URL = "https://ofclhcihedjtltiyjkvn.supabase.co"
local SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9mY2xoY2loZWRqdGx0aXlqa3ZuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU3OTQ2ODMsImV4cCI6MjA5MTM3MDY4M30.Sn4iT6lZghZnMGp4cBxDRfWs-ARoClk437qeEpqPAN0"
local SAB_PLACE_ID = 109983668079237

-- roblox utils
local Players     = game:GetService("Players")
local TeleportSvc = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local UserInput   = game:GetService("UserInputService")
local CoreGui     = game:GetService("CoreGui")
local player      = Players.LocalPlayer

-- get http function (supports multiple exploit APIs)
local function getHttp()
    return http_request or request or (http and http.request)
end

-- cleanup old
local old = CoreGui:FindFirstChild("AxionHub")
if old then old:Destroy() end


-- cplors used for gui
local BG        = Color3.fromRGB(245, 243, 255)
local HEADER_BG = Color3.fromRGB(238, 234, 255)
local BORDER    = Color3.fromRGB(218, 213, 245)
local DOT_COL   = Color3.fromRGB(124, 58, 237)
local TITLE_COL = Color3.fromRGB(30, 14, 92)
local SUB_COL   = Color3.fromRGB(168, 152, 212)
local BTN_BG    = Color3.fromRGB(221, 216, 248)
local BTN_BDR   = Color3.fromRGB(180, 168, 238)
local BTN_TXT   = Color3.fromRGB(109, 40, 217)
local TAB_OFF   = Color3.fromRGB(176, 164, 212)
local STAT_BG   = Color3.fromRGB(237, 234, 255)
local CARD_BG   = Color3.fromRGB(255, 255, 255)
local CARD_BDR  = Color3.fromRGB(237, 233, 255)
local STATUS_C  = Color3.fromRGB(196, 186, 224)
local FOOT_BG   = Color3.fromRGB(238, 234, 255)

--color for tier
local TIER = {
    low  = { label="LOW",  txt=Color3.fromRGB(55,90,200),  badge=Color3.fromRGB(225,230,255), acc=Color3.fromRGB(80,110,230)  },
    high = { label="HIGH", txt=Color3.fromRGB(150,50,170), badge=Color3.fromRGB(245,220,255), acc=Color3.fromRGB(180,70,210)  },
    big  = { label="BIG",  txt=Color3.fromRGB(170,30,90),  badge=Color3.fromRGB(255,220,235), acc=Color3.fromRGB(210,45,110)  },
}

--color when tab is on
local TAB_ON = {
    All  = { bg=Color3.fromRGB(228,223,255), txt=Color3.fromRGB(91,33,182)   },
    Low  = { bg=Color3.fromRGB(225,230,255), txt=Color3.fromRGB(55,90,200)   },
    High = { bg=Color3.fromRGB(245,220,255), txt=Color3.fromRGB(150,50,170)  },
    Big  = { bg=Color3.fromRGB(255,220,235), txt=Color3.fromRGB(170,30,90)   },
}

-- screen gui
local sg = Instance.new("ScreenGui")
sg.Name = "AxionHub"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = CoreGui

-- main window
local WIN_W = 370
local WIN_H = 470

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, WIN_W, 0, WIN_H)
main.Position = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2)
main.BackgroundColor3 = BG
main.BorderSizePixel = 0
main.ClipsDescendants = false
main.Parent = sg
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)
local ms = Instance.new("UIStroke", main)
ms.Color = BORDER
ms.Thickness = 1

-- gui header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 54)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = HEADER_BG
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local hdiv = Instance.new("Frame")
hdiv.Size = UDim2.new(1, 0, 0, 1)
hdiv.Position = UDim2.new(0, 0, 1, -1)
hdiv.BackgroundColor3 = BORDER
hdiv.BorderSizePixel = 0
hdiv.Parent = header

-- dot
local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 7, 0, 7)
dot.Position = UDim2.new(0, 14, 0, 15)
dot.BackgroundColor3 = DOT_COL
dot.BorderSizePixel = 0
dot.Parent = header
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

-- title
local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(0, 200, 0, 20)
titleLbl.Position = UDim2.new(0, 28, 0, 7)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Axion Hub"
titleLbl.TextColor3 = TITLE_COL
titleLbl.TextSize = 14
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.Parent = header

-- subtitle
local subLbl = Instance.new("TextLabel")
subLbl.Size = UDim2.new(0, 200, 0, 14)
subLbl.Position = UDim2.new(0, 28, 0, 30)
subLbl.BackgroundTransparency = 1
subLbl.Text = "Steal a Brainrot Notifier"
subLbl.TextColor3 = SUB_COL
subLbl.TextSize = 10
subLbl.Font = Enum.Font.Gotham
subLbl.TextXAlignment = Enum.TextXAlignment.Left
subLbl.Parent = header

-- buttons (absolute positioned, no layout)
local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 72, 0, 28)
refreshBtn.Position = UDim2.new(1, -112, 0.5, -14)
refreshBtn.BackgroundColor3 = BTN_BG
refreshBtn.Text = "Refresh"
refreshBtn.TextColor3 = BTN_TXT
refreshBtn.TextSize = 11
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.BorderSizePixel = 0
refreshBtn.Parent = header
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 7)
local rs = Instance.new("UIStroke", refreshBtn)
rs.Color = BTN_BDR rs.Thickness = 1

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -36, 0.5, -14)
minimizeBtn.BackgroundColor3 = BTN_BG
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = BTN_TXT
minimizeBtn.TextSize = 14
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = header
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 7)
local ms2 = Instance.new("UIStroke", minimizeBtn)
ms2.Color = BTN_BDR ms2.Thickness = 1

-- drag (header only)
local dragging, dragInput, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInput.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local d = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y
        )
    end
end)

-- content inside the gui
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -54)
content.Position = UDim2.new(0, 0, 0, 54)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ClipsDescendants = false
content.Visible = true
content.Parent = main


-- tab handler
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -24, 0, 30)
tabBar.Position = UDim2.new(0, 12, 0, 10)
tabBar.BackgroundColor3 = STAT_BG
tabBar.BorderSizePixel = 0
tabBar.Parent = content
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 8)

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 2)
local tp = Instance.new("UIPadding", tabBar)
tp.PaddingLeft = UDim.new(0,3) tp.PaddingRight = UDim.new(0,3)
tp.PaddingTop = UDim.new(0,3)  tp.PaddingBottom = UDim.new(0,3)

local TABS = {"All","Low","High","Big"}
local tabBtns = {}
local currentFilter = "All"

for i, name in ipairs(TABS) do
    local t = Instance.new("TextButton")
    t.Size = UDim2.new(0.25, -2, 1, 0)
    t.BackgroundColor3 = i==1 and TAB_ON[name].bg or STAT_BG
    t.BackgroundTransparency = i==1 and 0 or 1
    t.Text = name:upper()
    t.TextColor3 = i==1 and TAB_ON[name].txt or TAB_OFF
    t.TextSize = 11
    t.Font = Enum.Font.GothamBold
    t.BorderSizePixel = 0
    t.LayoutOrder = i
    t.Parent = tabBar
    Instance.new("UICorner", t).CornerRadius = UDim.new(0, 6)
    tabBtns[name] = t
end

-- stats row / handler
local statsRow = Instance.new("Frame")
statsRow.Size = UDim2.new(1, -24, 0, 42)
statsRow.Position = UDim2.new(0, 12, 0, 48)
statsRow.BackgroundTransparency = 1
statsRow.Parent = content

local sl = Instance.new("UIListLayout", statsRow)
sl.FillDirection = Enum.FillDirection.Horizontal
sl.SortOrder = Enum.SortOrder.LayoutOrder
sl.Padding = UDim.new(0, 5)

local SDEFS = {
    {key="total",lbl="TOTAL",col=Color3.fromRGB(109,40,217)},
    {key="low",  lbl="LOW",  col=Color3.fromRGB(55,90,200) },
    {key="high", lbl="HIGH", col=Color3.fromRGB(150,50,170)},
    {key="big",  lbl="BIG",  col=Color3.fromRGB(170,30,90) },
}
local statNums = {}

for i, s in ipairs(SDEFS) do
    local c = Instance.new("Frame")
    c.Size = UDim2.new(0.25, -4, 1, 0)
    c.BackgroundColor3 = STAT_BG
    c.BorderSizePixel = 0
    c.LayoutOrder = i
    c.Parent = statsRow
    Instance.new("UICorner", c).CornerRadius = UDim.new(0, 8)

    local n = Instance.new("TextLabel", c)
    n.Size = UDim2.new(1,0,0,22)
    n.Position = UDim2.new(0,0,0,4)
    n.BackgroundTransparency = 1
    n.Text = "0"
    n.TextColor3 = s.col
    n.TextSize = 15
    n.Font = Enum.Font.GothamBold
    statNums[s.key] = n

    local l = Instance.new("TextLabel", c)
    l.Size = UDim2.new(1,0,0,12)
    l.Position = UDim2.new(0,0,0,27)
    l.BackgroundTransparency = 1
    l.Text = s.lbl
    l.TextColor3 = SUB_COL
    l.TextSize = 9
    l.Font = Enum.Font.GothamBold
end

-- search handler
local searchFrame = Instance.new("Frame")
searchFrame.Size = UDim2.new(1, -24, 0, 28)
searchFrame.Position = UDim2.new(0, 12, 0, 98)
searchFrame.BackgroundColor3 = CARD_BG
searchFrame.BorderSizePixel = 0
searchFrame.Parent = content
Instance.new("UICorner", searchFrame).CornerRadius = UDim.new(0, 8)
local ss = Instance.new("UIStroke", searchFrame)
ss.Color = CARD_BDR
ss.Thickness = 1

local searchIcon = Instance.new("TextLabel", searchFrame)
searchIcon.Size = UDim2.new(0, 24, 1, 0)
searchIcon.Position = UDim2.new(0, 4, 0, 0)
searchIcon.BackgroundTransparency = 1
searchIcon.Text = "⌕"
searchIcon.TextColor3 = SUB_COL
searchIcon.TextSize = 13
searchIcon.Font = Enum.Font.GothamBold

local searchBox = Instance.new("TextBox", searchFrame)
searchBox.Size = UDim2.new(1, -32, 1, 0)
searchBox.Position = UDim2.new(0, 26, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.Text = ""
searchBox.PlaceholderText = "search brainrots..."
searchBox.PlaceholderColor3 = SUB_COL
searchBox.TextColor3 = TITLE_COL
searchBox.TextSize = 11
searchBox.Font = Enum.Font.Gotham
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus = false

local currentSearch = ""

-- scroll lists for results
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -24, 1, -156)
scroll.Position = UDim2.new(0, 12, 0, 134)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = DOT_COL
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = content

local ll = Instance.new("UIListLayout", scroll)
ll.SortOrder = Enum.SortOrder.LayoutOrder
ll.Padding = UDim.new(0, 5)

local scrollPad = Instance.new("UIPadding", scroll)
scrollPad.PaddingBottom = UDim.new(0, 8)
scrollPad.PaddingTop = UDim.new(0, 2)

-- simple footer with status text and resize handle
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, 24)
footer.Position = UDim2.new(0, 0, 1, -24)
footer.BackgroundColor3 = FOOT_BG
footer.BorderSizePixel = 0
footer.Parent = content
Instance.new("UICorner", footer).CornerRadius = UDim.new(0, 14)

local statusLbl = Instance.new("TextLabel", footer)
statusLbl.Size = UDim2.new(1, -24, 1, 0)
statusLbl.Position = UDim2.new(0, 12, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "press Refresh to load"
statusLbl.TextColor3 = STATUS_C
statusLbl.TextSize = 10
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- create card for each fetch data item
local allData = {}

local function createCard(data, index)
    local t = TIER[data.tier] or TIER.low

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 72)
    card.BackgroundColor3 = CARD_BG
    card.BorderSizePixel = 0
    card.LayoutOrder = index
    card.Name = "Card"
    card.Parent = scroll
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 9)
    local cs = Instance.new("UIStroke", card)
    cs.Color = CARD_BDR
    cs.Thickness = 1

    -- accent bar
    local acc = Instance.new("Frame")
    acc.Size = UDim2.new(0, 3, 0.6, 0)
    acc.Position = UDim2.new(0, 0, 0.2, 0)
    acc.BackgroundColor3 = t.acc
    acc.BorderSizePixel = 0
    acc.Parent = card
    Instance.new("UICorner", acc).CornerRadius = UDim.new(0, 3)

    -- badge
    local bdg = Instance.new("Frame")
    bdg.Size = UDim2.new(0, 32, 0, 15)
    bdg.Position = UDim2.new(0, 11, 0, 10)
    bdg.BackgroundColor3 = t.badge
    bdg.BorderSizePixel = 0
    bdg.Parent = card
    Instance.new("UICorner", bdg).CornerRadius = UDim.new(0, 4)

    local btxt = Instance.new("TextLabel", bdg)
    btxt.Size = UDim2.new(1,0,1,0)
    btxt.BackgroundTransparency = 1
    btxt.Text = t.label
    btxt.TextColor3 = t.txt
    btxt.TextSize = 8
    btxt.Font = Enum.Font.GothamBold

    -- name
    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(0, 200, 0, 18)
    nameLbl.Position = UDim2.new(0, 11, 0, 28)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = data.name or "Unknown"
    nameLbl.TextColor3 = TITLE_COL
    nameLbl.TextSize = 12
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.Parent = card

    -- value
    local valLbl = Instance.new("TextLabel")
    valLbl.Size = UDim2.new(0, 200, 0, 14)
    valLbl.Position = UDim2.new(0, 11, 0, 50)
    valLbl.BackgroundTransparency = 1
    valLbl.Text = data.raw_value or "?"
    valLbl.TextColor3 = SUB_COL
    valLbl.TextSize = 10
    valLbl.Font = Enum.Font.Gotham
    valLbl.TextXAlignment = Enum.TextXAlignment.Left
    valLbl.Parent = card

    -- join server btn
    local tb = Instance.new("TextButton")
    tb.Size = UDim2.new(0, 90, 0, 28)
    tb.Position = UDim2.new(1, -102, 0.5, -14)
    tb.BackgroundColor3 = STAT_BG
    tb.Text = "JOIN SERVER"
    tb.TextColor3 = BTN_TXT
    tb.TextSize = 9
    tb.Font = Enum.Font.GothamBold
    tb.BorderSizePixel = 0
    tb.Parent = card
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 7)

    tb.MouseButton1Click:Connect(function()
        if data.server_id then
            tb.Text = "JOINING..."
            tb.TextColor3 = Color3.fromRGB(150, 50, 170)
            local ok = pcall(function()
                TeleportSvc:TeleportToPlaceInstance(SAB_PLACE_ID, data.server_id, player)
            end)
            if not ok then
                tb.Text = "FAILED!"
                tb.TextColor3 = Color3.fromRGB(200, 40, 80)
                task.wait(2)
                tb.Text = "JOIN SERVER"
                tb.TextColor3 = BTN_TXT
            end
        else
            tb.Text = "NO ID!"
            task.wait(1.5)
            tb.Text = "JOIN SERVER"
        end
    end)
end

-- rendering data and handling search/filtering
local function clearCards()
    for _, c in pairs(scroll:GetChildren()) do
        if c:IsA("Frame") and c.Name == "Card" then c:Destroy() end
    end
end

local function renderCards(filter)
    clearCards()
    local query = currentSearch:lower()
    local count = 0
    for i, d in ipairs(allData) do
        local okTier = filter == "All" or d.tier == filter:lower()
        local okSearch = query == "" or (d.name and d.name:lower():find(query, 1, true))
        if okTier and okSearch then
            createCard(d, i)
            count = count + 1
        end
    end
    statusLbl.Text = count > 0 and (count .. " brainrot(s) shown") or "none found"
    statusLbl.TextColor3 = STATUS_C
end

local function updateStats()
    local c = {total=#allData, low=0, high=0, big=0}
    for _, d in ipairs(allData) do
        if c[d.tier] then c[d.tier] = c[d.tier] + 1 end
    end
    for k, lbl in pairs(statNums) do
        lbl.Text = tostring(c[k] or 0)
    end
end

local function fetchData()
    statusLbl.Text = "fetching..."
    statusLbl.TextColor3 = DOT_COL
    local http = getHttp()
    if not http then statusLbl.Text = "no http found!" return end

    local ok, result = pcall(function()
        return http({
            Url = SUPABASE_URL .. "/rest/v1/brainrots?select=*&order=created_at.desc&limit=100",
            Method = "GET",
            Headers = {
                ["apikey"] = SUPABASE_KEY,
                ["Authorization"] = "Bearer " .. SUPABASE_KEY,
                ["Content-Type"] = "application/json"
            }
        })
    end)

    if ok and result then
        local body = result.Body or result.body or ""
        local pok, data = pcall(function() return HttpService:JSONDecode(body) end)
        if pok and type(data) == "table" then
            allData = data
            updateStats()
            renderCards(currentFilter)
            statusLbl.Text = #allData .. " brainrot(s) loaded"
            statusLbl.TextColor3 = Color3.fromRGB(55, 90, 200)        else
            statusLbl.Text = "parse error"
            statusLbl.TextColor3 = Color3.fromRGB(200, 40, 80)
        end
    else
        statusLbl.Text = "fetch failed"
        statusLbl.TextColor3 = Color3.fromRGB(200, 40, 80)
    end
end

-- tab logic
for _, name in ipairs(TABS) do
    tabBtns[name].MouseButton1Click:Connect(function()
        currentFilter = name
        for _, n in ipairs(TABS) do
            tabBtns[n].BackgroundTransparency = 1
            tabBtns[n].TextColor3 = TAB_OFF
        end
        tabBtns[name].BackgroundColor3 = TAB_ON[name].bg
        tabBtns[name].BackgroundTransparency = 0
        tabBtns[name].TextColor3 = TAB_ON[name].txt
        renderCards(currentFilter)
    end)
end

-- search logic
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    currentSearch = searchBox.Text
    renderCards(currentFilter)
end)

-- resize logic (drag the bottom right corner)
local rh = Instance.new("TextButton")
rh.Size = UDim2.new(0, 16, 0, 16)
rh.Position = UDim2.new(1, -16, 0, 4)
rh.BackgroundColor3 = BORDER
rh.Text = ""
rh.BorderSizePixel = 0
rh.ZIndex = 2
rh.Parent = footer
Instance.new("UICorner", rh).CornerRadius = UDim.new(0, 4)

for r = 1, 2 do
    for c2 = 1, 2 do
        local d = Instance.new("Frame", rh)
        d.Size = UDim2.new(0, 2, 0, 2)
        d.Position = UDim2.new(0, 2+(c2-1)*5, 0, 2+(r-1)*5)
        d.BackgroundColor3 = SUB_COL
        d.BorderSizePixel = 0
        Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
    end
end

local resizing, resizeStart, resizeStartSize = false, nil, nil
rh.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStart = input.Position
        resizeStartSize = main.Size
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then resizing = false end
        end)
    end
end)
UserInput.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - resizeStart
        local nw = math.max(300, resizeStartSize.X.Offset + delta.X)
        local nh = math.max(300, resizeStartSize.Y.Offset + delta.Y)
        WIN_W = nw
        WIN_H = nh
        main.Size = UDim2.new(0, nw, 0, nh)
    end
end)

-- handle minimize (just hides content and shrinks window, doesn't actually minimize)
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        content.Visible = false
        main.Size = UDim2.new(0, WIN_W, 0, 54)
        minimizeBtn.Text = "+"
        subLbl.Text = #allData > 0 and (#allData .. " loaded") or "Steal a Brainrot Notifier"
        rh.Visible = false
    else
        content.Visible = true
        main.Size = UDim2.new(0, WIN_W, 0, WIN_H)
        minimizeBtn.Text = "—"
        subLbl.Text = "Steal a Brainrot Notifier"
        rh.Visible = true
    end
end)

-- refresh handler (re-fetch data from server)
refreshBtn.MouseButton1Click:Connect(fetchData)

-- auto load on start
fetchData()