
if not game:IsLoaded()then
game.Loaded:Wait()
end

pcall(function()
local a={}
if getreg then
for b,c in getreg()do
if typeof(c)=="thread"then
local d=debug.info(c,1,"s")
if d and(d:match"%.Core%.Anti"or d:match"%.Plugins%.Anti_Cheat")then
table.insert(a,c)
end
end
end
for b,c in ipairs(a)do
pcall(coroutine.close,c)
end
end

local b={}
if filtergc then
local c=filtergc("table",{Keys={"Detected","RLocked"}},false)
for d,e in ipairs(c)do
if typeof(rawget(e,"Detected"))=="function"then
table.insert(b,e)
end
end
elseif getgc then
for c,d in ipairs(getgc(true))do
if typeof(d)=="table"and rawget(d,"RLocked")and typeof(rawget(d,"Detected"))=="function"then
table.insert(b,d)
end
end
end

if hookfunction and isfunctionhooked then
for c,d in ipairs(b)do
for e,f in pairs(d)do
if typeof(f)=="function"and not isfunctionhooked(f)then
hookfunction(f,function(...)
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

local a=game:GetService"TweenService"
local b=game:GetService"UserInputService"
local c=game:GetService"Players"
local d=game:GetService"CoreGui"
local e=game:GetService"RunService"
local f=game:GetService"HttpService"

local g=c.LocalPlayer
if not g then
pcall(function()
g=c:GetPlayers()[1]
end)
end
if not g then
task.spawn(function()
pcall(function()
g=c.PlayerAdded:Wait()
end)
end)
end

local function getGuiContainer()
local h
pcall(function()
if gethui then
h=gethui()
end
end)
if not h then
pcall(function()
local i=Instance.new"Folder"
i.Parent=d
i:Destroy()
h=d
end)
end
if not h then
pcall(function()
local i=c.LocalPlayer or g
if i then
h=i:FindFirstChildOfClass"PlayerGui"or i:WaitForChild("PlayerGui",3)
end
end)
end
if not h then
pcall(function()
h=d
end)
end
return h
end

local h={
hasFS=false,
isfolder=function()return false end,
makefolder=function()end,
isfile=function()return false end,
writefile=function()end,
readfile=function()return""end,
delfile=function()end,
listfiles=function()return{}end
}

pcall(function()
local function resolveGlobal(i)
if typeof(getgenv)=="function"then
local j=getgenv()
if j and j[i]then return j[i]end
end
if typeof(_G)=="table"and rawget(_G,i)then return _G[i]end
local j=(typeof(getfenv)=="function"and getfenv())or nil
if j and j[i]then return j[i]end
return nil
end

local i=writefile or resolveGlobal"writefile"
local j=readfile or resolveGlobal"readfile"
if typeof(i)=="function"and typeof(j)=="function"then
h.hasFS=true
h.writefile=i
h.readfile=j
local k=isfolder or resolveGlobal"isfolder"
if typeof(k)=="function"then h.isfolder=k end
local l=makefolder or resolveGlobal"makefolder"
if typeof(l)=="function"then h.makefolder=l end
local m=isfile or resolveGlobal"isfile"
if typeof(m)=="function"then h.isfile=m end
local n=delfile or resolveGlobal"delfile"or deletefile or resolveGlobal"deletefile"
if typeof(n)=="function"then h.delfile=n end
local o=listfiles or resolveGlobal"listfiles"
if typeof(o)=="function"then h.listfiles=o end
end
end)

local i={
combat="rbxassetid://10734977012",
player="rbxassetid://10747373176",
move="rbxassetid://10734900011",
visuals="rbxassetid://10723346959",
misc="rbxassetid://10709810463",
friends="rbxassetid://10747372702",
configs="rbxassetid://10709806740",
settings="rbxassetid://10734963191",
search="rbxassetid://10734943674",
gear="rbxassetid://10734950309",
chevron="rbxassetid://10709790948",
check="rbxassetid://10709790644",
close="rbxassetid://10747384394",
hourglass="rbxassetid://10723407498"
}

local function resolveIcon(j)
if not j or j==""then
return i.combat
end
if string.sub(j,1,13)=="rbxassetid://"or string.sub(j,1,11)=="http://"or string.sub(j,1,12)=="https://"then
return j
end
local k=string.lower(j)
if i[k]then
return i[k]
end
return i.combat
end

local function tween(j,k,l,m,n)
m=m or Enum.EasingStyle.Quad
n=n or Enum.EasingDirection.Out
l=l or 0.2
local o=TweenInfo.new(l,m,n)
local p=a:Create(j,o,k)
p:Play()
return p
end

local function colorToHex(j)
local k=math.clamp(math.floor(j.R*255+0.5),0,255)
local l=math.clamp(math.floor(j.G*255+0.5),0,255)
local m=math.clamp(math.floor(j.B*255+0.5),0,255)
return string.format("#%02X%02X%02X",k,l,m)
end

local function hexToColor(j)
j=tostring(j or""):gsub("#",""):gsub("%s+","")
if#j==3 then
j=j:sub(1,1):rep(2)..j:sub(2,2):rep(2)..j:sub(3,3):rep(2)
end
if#j~=6 then
return nil
end
local k=tonumber(j:sub(1,2),16)
local l=tonumber(j:sub(3,4),16)
local m=tonumber(j:sub(5,6),16)
if not k or not l or not m then
return nil
end
return Color3.fromRGB(k,l,m)
end

local function formatBrandRichText(j,k)
j=tostring(j or"future.club")
local l=colorToHex(k)
local m=string.find(j,".",1,true)
if m then
local n=string.sub(j,1,m-1)
local o=string.sub(j,m)
return string.format('<font color="#EAEAF2">%s</font><font color="%s">%s</font>',n,l,o)
end
return string.format('<font color="%s">%s</font>',l,j)
end

local function makeDraggable(j,k)
if typeof(k)~="table"then
k={k or j}
end
local l=false
local m
local n
local o

local function isGuiVisible(p)
local q=p
while q and q:IsA"GuiObject"do
if not q.Visible then
return false
end
q=q.Parent
end
return true
end

local function isInteractiveAt(p)
local q=false
pcall(function()
local r=c.LocalPlayer or g
local s=r and(r:FindFirstChildOfClass"PlayerGui"or r:FindFirstChild"PlayerGui")
if s then
local t=s:GetGuiObjectsAtPosition(p.X,p.Y)
if t then
for u,v in ipairs(t)do
local w=v
while w and w:IsA"GuiObject"do
if w:IsA"TextBox"or w:IsA"TextButton"or w:IsA"ImageButton"or w.Name=="SearchBar"then
q=true
return
end
w=w.Parent
end
end
end
end
end)
if q then
return true
end
for r,s in ipairs(j:GetDescendants())do
if s:IsA"GuiObject"and s.Visible then
if s:IsA"TextBox"or s:IsA"TextButton"or s:IsA"ImageButton"or s.Name=="SearchBar"then
local t=s.AbsolutePosition
local u=s.AbsoluteSize
if u.X>0 and u.Y>0 then
if p.X>=t.X and p.X<=t.X+u.X and p.Y>=t.Y and p.Y<=t.Y+u.Y then
if isGuiVisible(s)then
return true
end
end
end
end
end
end
return false
end

for p,q in ipairs(k)do
q.InputBegan:Connect(function(r)
if r.UserInputType==Enum.UserInputType.MouseButton1 or r.UserInputType==Enum.UserInputType.Touch then
if isInteractiveAt(r.Position)then
return
end
l=true
m=r
n=r.Position
o=j.Position
end
end)
end

b.InputChanged:Connect(function(p)
if l then
if p==m or p.UserInputType==Enum.UserInputType.MouseMovement or p.UserInputType==Enum.UserInputType.Touch then
local q=p.Position-n
j.Position=UDim2.new(
o.X.Scale,
o.X.Offset+q.X,
o.Y.Scale,
o.Y.Offset+q.Y
)
end
end
end)

b.InputEnded:Connect(function(p)
if l and(p==m or p.UserInputType==Enum.UserInputType.MouseButton1 or p.UserInputType==Enum.UserInputType.Touch)then
l=false
m=nil
end
end)
end

local j={
Version="2.0"
}
j.__index=j

function j.CreateWindow(k,l)
if type(k)=="table"and k~=j and l==nil then
l=k
end
l=l or{}
local m=l.Title or"future.club"
local n=l.ToggleKey or Enum.KeyCode.P
local o=l.AccentColor or Color3.fromRGB(255,75,114)
local p=l.ConfigFolder or"future.club/configs"
local q=l.SidebarHourglass
if q==nil then
q=true
end
local r=l.MobileButton
if r==nil then
r=true
end
if b.TouchEnabled then
r=true
end

pcall(function()
if h.hasFS then
if not h.isfolder"future.club"then
h.makefolder"future.club"
end
if not h.isfolder(p)then
h.makefolder(p)
end
end
end)

local s=getGuiContainer()

if s then
local t=s:FindFirstChild"FutureClubGui"
if t then
t:Destroy()
end
end

local t=Instance.new"ScreenGui"
t.Name="FutureClubGui"
t.ResetOnSpawn=false
t.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
t.DisplayOrder=9999 local

u=pcall(function()
t.Parent=s
end)
if not u then
pcall(function()
local v=c.LocalPlayer or g
if v then
t.Parent=v:FindFirstChildOfClass"PlayerGui"or v:WaitForChild("PlayerGui",5)
end
end)
end

local v=b.TouchEnabled
local w=v and 0.62 or 1.0
local x

local y=Instance.new"Frame"
y.Name="MainFrame"
y.Size=UDim2.new(0,810,0,550)
y.Position=UDim2.new(0.5,0,0.5,0)
y.AnchorPoint=Vector2.new(0.5,0.5)
y.BackgroundColor3=Color3.fromRGB(18,18,20)
y.BorderSizePixel=0
y.ClipsDescendants=true
y.Parent=t

local z=Instance.new"UIScale"
z.Scale=w
z.Parent=y

local function updateResponsiveScale()
local A=1920
local B=1080
local C=workspace.CurrentCamera
if t.AbsoluteSize.X>50 and t.AbsoluteSize.Y>50 then
A=t.AbsoluteSize.X
B=t.AbsoluteSize.Y
elseif C and C.ViewportSize.X>50 and C.ViewportSize.Y>50 then
A=C.ViewportSize.X
B=C.ViewportSize.Y
end

local D=v or B<650 or A<950
if D then
local E=A*0.85
local F=B*0.82
w=math.clamp(math.min(E/810,F/550),0.58,0.78)
else
local E=A*0.85
local F=B*0.85
w=math.clamp(math.min(E/810,F/550),0.70,1.0)
end
if z then
z.Scale=w
end
if x then
x.Scale=w
end
end

t:GetPropertyChangedSignal"AbsoluteSize":Connect(updateResponsiveScale)
local function hookCamera()
local A=workspace.CurrentCamera
if A then
A:GetPropertyChangedSignal"ViewportSize":Connect(updateResponsiveScale)
end
end
hookCamera()
workspace:GetPropertyChangedSignal"CurrentCamera":Connect(hookCamera)
updateResponsiveScale()
task.defer(updateResponsiveScale)
task.delay(0.1,updateResponsiveScale)
task.delay(0.4,updateResponsiveScale)

local A=Instance.new"UICorner"
A.CornerRadius=UDim.new(0,14)
A.Parent=y

local B=Instance.new"UIStroke"
B.Color=Color3.fromRGB(32,32,36)
B.Thickness=1
B.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
B.Parent=y

local C=Instance.new"TextLabel"
C.Name="TopWatermark"
C.Size=UDim2.new(0,160,0,22)
C.Position=UDim2.new(1,-22,0,22)
C.AnchorPoint=Vector2.new(1,0.5)
C.BackgroundTransparency=1
C.Font=Enum.Font.GothamBold
C.TextSize=14
C.RichText=true
C.TextColor3=Color3.fromRGB(234,234,242)
C.TextXAlignment=Enum.TextXAlignment.Right
C.TextYAlignment=Enum.TextYAlignment.Center
C.Text=formatBrandRichText(m,o)
C.Parent=y

local D=Instance.new"Frame"
D.Name="Sidebar"
D.Size=UDim2.new(0,196,1,0)
D.Position=UDim2.new(0,0,0,0)
D.BackgroundColor3=Color3.fromRGB(15,15,17)
D.BorderSizePixel=0
D.Parent=y

local E=Instance.new"UICorner"
E.CornerRadius=UDim.new(0,14)
E.Parent=D

local F=Instance.new"Frame"
F.Name="SidebarFix"
F.Size=UDim2.new(0,14,1,0)
F.Position=UDim2.new(1,-14,0,0)
F.BackgroundColor3=Color3.fromRGB(15,15,17)
F.BorderSizePixel=0
F.Parent=D

local G=Instance.new"Frame"
G.Name="Divider"
G.Size=UDim2.new(0,1,1,-32)
G.Position=UDim2.new(1,0,0,16)
G.BackgroundColor3=Color3.fromRGB(28,28,32)
G.BorderSizePixel=0
G.Parent=D

if q then
local H=Instance.new"ImageLabel"
H.Name="HourglassWatermark"
H.Size=UDim2.new(0,154,0,154)
H.Position=UDim2.new(0.5,0,0,241)
H.AnchorPoint=Vector2.new(0.5,0.5)
H.BackgroundTransparency=1
H.Image=l.HourglassImage or i.hourglass
H.ImageColor3=Color3.fromRGB(48,48,54)
H.ImageTransparency=0.55
H.ScaleType=Enum.ScaleType.Fit
H.ZIndex=1
H.Parent=D
end

local H=Instance.new"ScrollingFrame"
H.Name="TabsHolder"
H.Size=UDim2.new(1,-24,1,-120)
H.Position=UDim2.new(0,12,0,18)
H.BackgroundTransparency=1
H.BorderSizePixel=0
H.ScrollBarThickness=4
H.ScrollBarImageColor3=Color3.fromRGB(45,45,52)
H.ScrollingDirection=Enum.ScrollingDirection.Y
H.ElasticBehavior=Enum.ElasticBehavior.Always
H.Active=true
H.CanvasSize=UDim2.new(0,0,0,0)
H.AutomaticCanvasSize=Enum.AutomaticSize.Y
H.ZIndex=2
H.Parent=D

local I=Instance.new"UIListLayout"
I.SortOrder=Enum.SortOrder.LayoutOrder
I.Padding=UDim.new(0,6)
I.Parent=H

I:GetPropertyChangedSignal"AbsoluteContentSize":Connect(function()
H.CanvasSize=UDim2.new(0,0,0,I.AbsoluteContentSize.Y+12)
end)

local J=Instance.new"Frame"
J.Name="SearchBar"
J.Size=UDim2.new(1,-24,0,34)
J.Position=UDim2.new(0,12,1,-94)
J.BackgroundColor3=Color3.fromRGB(22,22,26)
J.BorderSizePixel=0
J.ZIndex=2
J.Parent=D

local K=Instance.new"UICorner"
K.CornerRadius=UDim.new(0,17)
K.Parent=J

local L=Instance.new"UIStroke"
L.Color=Color3.fromRGB(32,32,38)
L.Thickness=1
L.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
L.Parent=J

local M=Instance.new"ImageLabel"
M.Name="Icon"
M.Size=UDim2.new(0,14,0,14)
M.Position=UDim2.new(0,12,0.5,0)
M.AnchorPoint=Vector2.new(0,0.5)
M.BackgroundTransparency=1
M.Image=i.search
M.ImageColor3=Color3.fromRGB(95,95,105)
M.ZIndex=2
M.Parent=J

local N=Instance.new"TextBox"
N.Name="Input"
N.Size=UDim2.new(1,-38,1,0)
N.Position=UDim2.new(0,32,0,0)
N.BackgroundTransparency=1
N.Font=Enum.Font.Gotham
N.TextSize=12
N.TextColor3=Color3.fromRGB(240,240,245)
N.PlaceholderText="Search"
N.PlaceholderColor3=Color3.fromRGB(95,95,105)
N.TextXAlignment=Enum.TextXAlignment.Left
N.ClearTextOnFocus=false
N.Text=""
N.ZIndex=2
N.Parent=J

local O=Instance.new"Frame"
O.Name="ProfileCard"
O.Size=UDim2.new(1,-24,0,42)
O.Position=UDim2.new(0,12,1,-50)
O.BackgroundTransparency=1
O.ZIndex=2
O.Parent=D

local Q=Instance.new"ImageLabel"
Q.Name="Avatar"
Q.Size=UDim2.new(0,34,0,34)
Q.Position=UDim2.new(0,0,0.5,0)
Q.AnchorPoint=Vector2.new(0,0.5)
Q.BackgroundColor3=Color3.fromRGB(24,24,28)
Q.BorderSizePixel=0
Q.ZIndex=2
Q.Parent=O

local R=Instance.new"UICorner"
R.CornerRadius=UDim.new(0,7)
R.Parent=Q

local S=Instance.new"UIStroke"
S.Color=Color3.fromRGB(34,34,40)
S.Thickness=1
S.Parent=Q

local T="Player"
local U=i.player

local V=c.LocalPlayer or g
if V then
T=(V.DisplayName and V.DisplayName~="")and V.DisplayName or V.Name
if V.UserId and V.UserId>0 then
U="rbxthumb://type=AvatarHeadShot&id="..tostring(V.UserId).."&w=48&h=48"
task.spawn(function()
pcall(function()
local W,X=c:GetUserThumbnailAsync(V.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size48x48)
if X and W and W~=""then
Q.Image=W
end
end)
end)
end
end
if l.Username then
T=l.Username
end
Q.Image=U

local W=Instance.new"TextLabel"
W.Name="Username"
W.Size=UDim2.new(1,-44,0,20)
W.Position=UDim2.new(0,42,0.5,0)
W.AnchorPoint=Vector2.new(0,0.5)
W.BackgroundTransparency=1
W.Font=Enum.Font.GothamBold
W.TextSize=13
W.TextColor3=Color3.fromRGB(242,242,246)
W.TextXAlignment=Enum.TextXAlignment.Left
W.TextYAlignment=Enum.TextYAlignment.Center
W.TextTruncate=Enum.TextTruncate.AtEnd
W.Text=T
W.ZIndex=2
W.Parent=O

local X=Instance.new"Frame"
X.Name="ContentArea"
X.Size=UDim2.new(1,-214,1,-54)
X.Position=UDim2.new(0,206,0,44)
X.BackgroundTransparency=1
X.ClipsDescendants=true
X.Parent=y

local Y=Instance.new"Frame"
Y.Name="NotificationContainer"
Y.Size=UDim2.new(0,310,1,-40)
Y.Position=UDim2.new(1,-20,1,-20)
Y.AnchorPoint=Vector2.new(1,1)
Y.BackgroundTransparency=1
Y.ZIndex=10
Y.Parent=t

local Z=Instance.new"UIListLayout"
Z.SortOrder=Enum.SortOrder.LayoutOrder
Z.HorizontalAlignment=Enum.HorizontalAlignment.Right
Z.VerticalAlignment=Enum.VerticalAlignment.Bottom
Z.Padding=UDim.new(0,8)
Z.Parent=Y

local _=Instance.new"Frame"
_.Name="DragHeader"
_.Size=UDim2.new(1,-196,0,44)
_.Position=UDim2.new(0,196,0,0)
_.BackgroundTransparency=1
_.ZIndex=3
_.Parent=y

makeDraggable(y,{_})

local aa={
Gui=t,
Main=y,
Tabs={},
AllModules={},
ModuleByName={},
ModuleCreateListeners={},
FloatingButtons={},
ButtonsLocked=false,
PreviewEnabled=l.ShowPreviewWindow~=false,
PreviewMode="ESP",
ActiveTab=nil,
SearchQuery="",
Keybinds={},
Flags={},
ConfigElements={},
ThemeRefreshers={},
AccentColor=o,
ToggleKey=n,
ConfigFolder=p,
MemoryConfigs={},
ESPPreviewState={
Enabled=true,
Boxes=true,
BoxStyle="Full",
BoxFilled=false,
BoxColor=o,
Names=true,
NameColor=Color3.fromRGB(245,245,250),
Health=true,
HealthColor=Color3.fromRGB(90,245,140),
Distance=true,
DistanceColor=Color3.fromRGB(165,165,180),
Weapon=true,
Tracers=false,
TracerColor=Color3.fromRGB(0,210,140),
Chams=false,
ChamsColor=o,
Bones=false,
BoneColor=Color3.fromRGB(240,240,250),
HeadDot=false,
HeadDotColor=o
},
ButtonDraft={
Feature="Aim Assist",
Label="",
Style="Standard",
Width=116,
Height=42,
CornerRadius=10,
Opacity=88,
PreviewActive=true
}
}

local function registerThemeRefresher(ab)
table.insert(aa.ThemeRefreshers,ab)
end

local ab
local ac
local ad

function aa.SetAccentColor(ae,af)
if typeof(af)~="Color3"then return end
aa.AccentColor=af
o=af
if ac and y.Visible then
ac.Color=af
end
if ad then
ad.ImageColor3=af
end
for ag,ah in ipairs(aa.ThemeRefreshers)do
pcall(ah,af)
end
end

function aa.SetToggleKey(ae,af)
if typeof(af)=="EnumItem"then
n=af
aa.ToggleKey=af
end
end

local ae=Instance.new"Frame"
ae.Name="WatermarkHUD"
ae.Size=UDim2.new(0,260,0,30)
ae.Position=UDim2.new(0,18,0,18)
ae.BackgroundColor3=Color3.fromRGB(16,16,19)
ae.BorderSizePixel=0
ae.Visible=l.ShowWatermark==true
ae.ZIndex=900
ae.Parent=t

local af=Instance.new"UICorner"
af.CornerRadius=UDim.new(0,8)
af.Parent=ae

local ag=Instance.new"UIStroke"
ag.Color=Color3.fromRGB(32,32,38)
ag.Thickness=1
ag.Parent=ae

local ah=Instance.new"Frame"
ah.Name="Accent"
ah.Size=UDim2.new(0,3,1,-12)
ah.Position=UDim2.new(0,6,0.5,0)
ah.AnchorPoint=Vector2.new(0,0.5)
ah.BackgroundColor3=o
ah.BorderSizePixel=0
ah.Parent=ae

local ai=Instance.new"UICorner"
ai.CornerRadius=UDim.new(1,0)
ai.Parent=ah

local aj=Instance.new"TextLabel"
aj.Name="Text"
aj.Size=UDim2.new(1,-22,1,0)
aj.Position=UDim2.new(0,16,0,0)
aj.BackgroundTransparency=1
aj.Font=Enum.Font.GothamBold
aj.TextSize=12
aj.RichText=true
aj.TextColor3=Color3.fromRGB(235,235,242)
aj.TextXAlignment=Enum.TextXAlignment.Left
aj.Text=formatBrandRichText(m,o).."  |  60 FPS  |  0 ms"
aj.Parent=ae

makeDraggable(ae,{ae})

registerThemeRefresher(function(ak)
C.Text=formatBrandRichText(m,ak)
ah.BackgroundColor3=ak
end)

local ak=Instance.new"Frame"
ak.Name="KeybindListHUD"
ak.Size=UDim2.new(0,190,0,32)
ak.Position=UDim2.new(0,18,0.42,0)
ak.BackgroundColor3=Color3.fromRGB(16,16,19)
ak.BorderSizePixel=0
ak.Visible=l.ShowKeybindList==true
ak.ZIndex=900
ak.Parent=t

local al=Instance.new"UICorner"
al.CornerRadius=UDim.new(0,9)
al.Parent=ak

local am=Instance.new"UIStroke"
am.Color=Color3.fromRGB(32,32,38)
am.Thickness=1
am.Parent=ak

local an=Instance.new"Frame"
an.Name="Header"
an.Size=UDim2.new(1,0,0,28)
an.BackgroundTransparency=1
an.Parent=ak

local ao=Instance.new"TextLabel"
ao.Name="Title"
ao.Size=UDim2.new(1,-20,1,0)
ao.Position=UDim2.new(0,10,0,0)
ao.BackgroundTransparency=1
ao.Font=Enum.Font.GothamBold
ao.TextSize=12
ao.TextColor3=o
ao.TextXAlignment=Enum.TextXAlignment.Left
ao.Text="Keybinds"
ao.Parent=an

local ap=Instance.new"Frame"
ap.Name="Line"
ap.Size=UDim2.new(1,-16,0,1)
ap.Position=UDim2.new(0,8,0,28)
ap.BackgroundColor3=Color3.fromRGB(28,28,34)
ap.BorderSizePixel=0
ap.Parent=ak

local aq=Instance.new"Frame"
aq.Name="List"
aq.Size=UDim2.new(1,-16,0,0)
aq.Position=UDim2.new(0,8,0,32)
aq.BackgroundTransparency=1
aq.Parent=ak

local ar=Instance.new"UIListLayout"
ar.SortOrder=Enum.SortOrder.LayoutOrder
ar.Padding=UDim.new(0,4)
ar.Parent=aq

makeDraggable(ak,{ak,an})

registerThemeRefresher(function(as)
ao.TextColor3=as
end)

local function refreshKeybindHUD()
if not ak.Visible then return end
for as,at in ipairs(aq:GetChildren())do
if at:IsA"Frame"then
at:Destroy()
end
end
local as=0
for at,au in ipairs(aa.Keybinds)do
local av=au.GetKey()
if av and av~=Enum.KeyCode.Unknown then
as=as+1
local aw=Instance.new"Frame"
aw.Name="Bind_"..tostring(as)
aw.Size=UDim2.new(1,0,0,18)
aw.BackgroundTransparency=1
aw.Parent=aq

local ax=au.IsActive()
local ay=Instance.new"TextLabel"
ay.Size=UDim2.new(1,-60,1,0)
ay.BackgroundTransparency=1
ay.Font=Enum.Font.GothamMedium
ay.TextSize=11
ay.TextColor3=ax and o or Color3.fromRGB(165,165,175)
ay.TextXAlignment=Enum.TextXAlignment.Left
ay.TextTruncate=Enum.TextTruncate.AtEnd
ay.Text=au.Name
ay.Parent=aw

local az=Instance.new"TextLabel"
az.Size=UDim2.new(0,58,1,0)
az.Position=UDim2.new(1,0,0,0)
az.AnchorPoint=Vector2.new(1,0)
az.BackgroundTransparency=1
az.Font=Enum.Font.GothamBold
az.TextSize=10
az.TextColor3=ax and o or Color3.fromRGB(115,115,125)
az.TextXAlignment=Enum.TextXAlignment.Right
local function formatHUDKey(aA)
if not aA or aA==Enum.KeyCode.Unknown then return"[-]"
end
if typeof(aA)=="EnumItem"then
if aA.EnumType==Enum.UserInputType then
if aA==Enum.UserInputType.MouseButton1 then return"[M1]"
elseif aA==Enum.UserInputType.MouseButton2 then return"[M2]"
elseif aA==Enum.UserInputType.MouseButton3 then return"[M3]"
end
return"["..aA.Name.."]"
elseif aA.EnumType==Enum.KeyCode then
local aB=aA.Name
if aB:sub(1,6)=="Button"then return"["..aB:sub(7).."]"
end
return"["..aB.."]"
end
end
return"[-]"
end
az.Text=formatHUDKey(av)
az.Parent=aw
end
end
local at=as>0 and(as*22)or 4
ap.Visible=as>0
ak.Size=UDim2.new(0,190,0,32+at)
end

function aa.SetWatermarkVisible(as,at)
ae.Visible=at==true
end

function aa.SetKeybindListVisible(as,at)
ak.Visible=at==true
if at then
refreshKeybindHUD()
end
end

local as=252
local at=Instance.new"Frame"
at.Name="PreviewWindow"
at.Size=UDim2.new(0,as,0,550)
at.AnchorPoint=Vector2.new(0,0)
at.Position=UDim2.new(0.5,417,0.5,-275)
at.BackgroundColor3=Color3.fromRGB(18,18,20)
at.BorderSizePixel=0
at.ClipsDescendants=true
at.Visible=false
at.ZIndex=5
at.Parent=t

x=Instance.new"UIScale"
x.Scale=w
x.Parent=at

local au=Instance.new"UICorner"
au.CornerRadius=UDim.new(0,14)
au.Parent=at

local av=Instance.new"UIStroke"
av.Color=Color3.fromRGB(32,32,36)
av.Thickness=1
av.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
av.Parent=at

local aw=Instance.new"Frame"
aw.Name="Header"
aw.Size=UDim2.new(1,0,0,44)
aw.BackgroundColor3=Color3.fromRGB(15,15,17)
aw.BorderSizePixel=0
aw.Parent=at

local ax=Instance.new"UICorner"
ax.CornerRadius=UDim.new(0,14)
ax.Parent=aw

local ay=Instance.new"Frame"
ay.Name="BottomFix"
ay.Size=UDim2.new(1,0,0,14)
ay.Position=UDim2.new(0,0,1,-14)
ay.BackgroundColor3=Color3.fromRGB(15,15,17)
ay.BorderSizePixel=0
ay.Parent=aw

local az=Instance.new"Frame"
az.Name="Divider"
az.Size=UDim2.new(1,-24,0,1)
az.Position=UDim2.new(0,12,1,0)
az.BackgroundColor3=Color3.fromRGB(28,28,32)
az.BorderSizePixel=0
az.Parent=aw

makeDraggable(at,{aw})

local aA=Instance.new"TextLabel"
aA.Name="Title"
aA.Size=UDim2.new(1,-28,1,0)
aA.Position=UDim2.new(0,14,0,0)
aA.BackgroundTransparency=1
aA.Font=Enum.Font.GothamBold
aA.TextSize=13
aA.TextColor3=Color3.fromRGB(238,238,245)
aA.TextXAlignment=Enum.TextXAlignment.Left
aA.Text="preview"
aA.Parent=aw

local aB=Instance.new"Frame"
aB.Name="ESPPreviewPage"
aB.Size=UDim2.new(1,0,1,-44)
aB.Position=UDim2.new(0,0,0,44)
aB.BackgroundTransparency=1
aB.Visible=true
aB.Parent=at

local aC=Instance.new"Frame"
aC.Name="Stage"
aC.Size=UDim2.new(1,-24,1,-24)
aC.Position=UDim2.new(0,12,0,12)
aC.BackgroundColor3=Color3.fromRGB(14,14,16)
aC.BorderSizePixel=0
aC.ClipsDescendants=true
aC.Parent=aB

local aD=Instance.new"UICorner"
aD.CornerRadius=UDim.new(0,10)
aD.Parent=aC

local aE=Instance.new"UIStroke"
aE.Color=Color3.fromRGB(28,28,34)
aE.Thickness=1
aE.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
aE.Parent=aC

for aF=1,7 do
local aG=Instance.new"Frame"
aG.Size=UDim2.new(1,0,0,1)
aG.Position=UDim2.new(0,0,aF/8,0)
aG.BackgroundColor3=Color3.fromRGB(22,22,26)
aG.BorderSizePixel=0
aG.ZIndex=1
aG.Parent=aC
end
for aF=1,4 do
local aG=Instance.new"Frame"
aG.Size=UDim2.new(0,1,1,0)
aG.Position=UDim2.new(aF/5,0,0,0)
aG.BackgroundColor3=Color3.fromRGB(22,22,26)
aG.BorderSizePixel=0
aG.ZIndex=1
aG.Parent=aC
end

local aF=Instance.new"ViewportFrame"
aF.Name="AvatarViewport"
aF.Size=UDim2.new(1,0,1,0)
aF.Position=UDim2.new(0,0,0,0)
aF.BackgroundTransparency=1
aF.Ambient=Color3.fromRGB(185,185,195)
aF.LightColor=Color3.fromRGB(255,255,255)
aF.LightDirection=Vector3.new(-1,-1,-1)
aF.ZIndex=2
aF.Parent=aC

local aG=Instance.new"Camera"
aG.FieldOfView=32
aG.Parent=aF
aF.CurrentCamera=aG

local aH
pcall(function()
aH=Instance.new"WorldModel"
aH.Parent=aF
end)

local aI=Instance.new"ImageLabel"
aI.Name="AvatarFallback"
aI.Size=UDim2.new(0,270,0,270)
aI.Position=UDim2.new(0.5,0,0.5,0)
aI.AnchorPoint=Vector2.new(0.5,0.5)
aI.BackgroundTransparency=1
aI.ScaleType=Enum.ScaleType.Fit
aI.Image="rbxthumb://type=Avatar&id=11195502927&w=420&h=420"
aI.ZIndex=2
aI.Parent=aC

local aJ=Instance.new"Frame"
aJ.Name="RigBounds"
aJ.Size=UDim2.new(0,120,0,270)
aJ.Position=UDim2.new(0.5,0,0.5,0)
aJ.AnchorPoint=Vector2.new(0.5,0.5)
aJ.BackgroundTransparency=1
aJ.ZIndex=4
aJ.Parent=aC

local aK=Instance.new"Frame"
aK.Name="ChamsOverlay"
aK.Size=UDim2.new(1,-16,1,-12)
aK.Position=UDim2.new(0.5,0,0.5,0)
aK.AnchorPoint=Vector2.new(0.5,0.5)
aK.BackgroundColor3=o
aK.BackgroundTransparency=1
aK.BorderSizePixel=0
aK.ZIndex=3
aK.Parent=aJ

local aL=Instance.new"UICorner"
aL.CornerRadius=UDim.new(0,8)
aL.Parent=aK

local aM={}
local aN=11195502927

task.spawn(function()
local aO=false
pcall(function()
local aP=c:CreateHumanoidModelFromUserId(aN)
if aP then
aP.Name="6vxft"
aP.Parent=aH or aF
local aQ=aP:FindFirstChild"HumanoidRootPart"or aP.PrimaryPart or aP:FindFirstChild"Torso"or aP:FindFirstChild"UpperTorso"
if aQ then
aP:PivotTo(CFrame.new(0,0,0))
local aR,aS=aP:GetBoundingBox()
local aT=math.tan(math.rad(aG.FieldOfView/2))
local function fitCamera()
local aU=aF.AbsoluteSize.Y
if aU<50 then return end
local aV=math.clamp(aU*0.62,180,300)
local aW=(aS.Y*aU)/(aV*2*aT)
local aX=aR.Position
aG.CFrame=CFrame.lookAt(aX+Vector3.new(0,0,-aW),aX)
local aY=aV/aS.Y
aJ.Size=UDim2.new(0,math.floor(aS.X*aY)+8,0,math.floor(aV)+6)
aJ.Position=UDim2.new(0.5,0,0.5,0)
end
fitCamera()
aF:GetPropertyChangedSignal"AbsoluteSize":Connect(fitCamera)
task.delay(0.5,fitCamera)
for aU,aV in ipairs(aP:GetDescendants())do
if aV:IsA"BasePart"and aV.Name~="HumanoidRootPart"then
table.insert(aM,{
Part=aV,
OrigColor=aV.Color,
OrigMaterial=aV.Material,
OrigTrans=aV.Transparency
})
end
end
aI.Visible=false
aO=true
end
end
end)
if not aO then
pcall(function()
local aP=c:GetUserThumbnailAsync(aN,Enum.ThumbnailType.AvatarThumbnail,Enum.ThumbnailSize.Size420x420)
if aP and aP~=""then
aI.Image=aP
end
end)
end
end)

local aO=Instance.new"Frame"
aO.Name="Bones"
aO.Size=UDim2.new(1,0,1,0)
aO.BackgroundTransparency=1
aO.Visible=false
aO.ZIndex=6
aO.Parent=aJ

local aP={}
local function createBone(aQ,aR,aS)
local aT=Instance.new"Frame"
aT.Position=aQ
aT.Size=aR
aT.AnchorPoint=Vector2.new(0.5,0.5)
aT.Rotation=aS or 0
aT.BackgroundColor3=Color3.fromRGB(240,240,250)
aT.BorderSizePixel=0
aT.ZIndex=6
aT.Parent=aO
table.insert(aP,aT)
return aT
end
createBone(UDim2.new(0.5,0,0,92),UDim2.new(0,2,0,104),0)
createBone(UDim2.new(0.5,0,0,68),UDim2.new(0,84,0,2),0)
createBone(UDim2.new(0.5,-42,0,104),UDim2.new(0,2,0,72),0)
createBone(UDim2.new(0.5,42,0,104),UDim2.new(0,2,0,72),0)
createBone(UDim2.new(0.5,0,0,144),UDim2.new(0,34,0,2),0)
createBone(UDim2.new(0.5,-17,0,192),UDim2.new(0,2,0,94),0)
createBone(UDim2.new(0.5,17,0,192),UDim2.new(0,2,0,94),0)

local aQ=Instance.new"Frame"
aQ.Name="HeadDot"
aQ.Size=UDim2.new(0,10,0,10)
aQ.Position=UDim2.new(0.5,0,0,34)
aQ.AnchorPoint=Vector2.new(0.5,0.5)
aQ.BackgroundColor3=o
aQ.BorderSizePixel=0
aQ.Visible=false
aQ.ZIndex=7
aQ.Parent=aJ

local aR=Instance.new"UICorner"
aR.CornerRadius=UDim.new(1,0)
aR.Parent=aQ

local aS=Instance.new"UIStroke"
aS.Color=Color3.fromRGB(10,10,12)
aS.Thickness=1.2
aS.Parent=aQ

local aT=Instance.new"Frame"
aT.Name="ESPBox"
aT.Size=UDim2.new(1,0,1,0)
aT.Position=UDim2.new(0.5,0,0.5,0)
aT.AnchorPoint=Vector2.new(0.5,0.5)
aT.BackgroundColor3=o
aT.BackgroundTransparency=1
aT.BorderSizePixel=0
aT.ZIndex=5
aT.Parent=aJ

local aU=Instance.new"UIStroke"
aU.Color=Color3.fromRGB(8,8,10)
aU.Thickness=2.5
aU.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
aU.Parent=aT

local aV=Instance.new"Frame"
aV.Name="InnerBox"
aV.Size=UDim2.new(1,0,1,0)
aV.BackgroundTransparency=1
aV.ZIndex=6
aV.Parent=aT

local aW=Instance.new"UIStroke"
aW.Color=o
aW.Thickness=1.4
aW.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
aW.Parent=aV

local aX=Instance.new"Frame"
aX.Name="CornerBox"
aX.Size=UDim2.new(1,0,1,0)
aX.BackgroundTransparency=1
aX.Visible=false
aX.ZIndex=6
aX.Parent=aT

local aY={}
local function addCornerSeg(aZ,a_,a0)
local a1=Instance.new"Frame"
a1.Position=aZ
a1.AnchorPoint=a_
a1.Size=a0
a1.BackgroundColor3=o
a1.BorderSizePixel=0
a1.ZIndex=6
a1.Parent=aX
table.insert(aY,a1)
end
addCornerSeg(UDim2.new(0,0,0,0),Vector2.new(0,0),UDim2.new(0,18,0,2))
addCornerSeg(UDim2.new(0,0,0,0),Vector2.new(0,0),UDim2.new(0,2,0,18))
addCornerSeg(UDim2.new(1,0,0,0),Vector2.new(1,0),UDim2.new(0,18,0,2))
addCornerSeg(UDim2.new(1,0,0,0),Vector2.new(1,0),UDim2.new(0,2,0,18))
addCornerSeg(UDim2.new(0,0,1,0),Vector2.new(0,1),UDim2.new(0,18,0,2))
addCornerSeg(UDim2.new(0,0,1,0),Vector2.new(0,1),UDim2.new(0,2,0,18))
addCornerSeg(UDim2.new(1,0,1,0),Vector2.new(1,1),UDim2.new(0,18,0,2))
addCornerSeg(UDim2.new(1,0,1,0),Vector2.new(1,1),UDim2.new(0,2,0,18))

local aZ=Instance.new"Frame"
aZ.Name="HealthBar"
aZ.Size=UDim2.new(0,4,1,0)
aZ.Position=UDim2.new(0,-8,0.5,0)
aZ.AnchorPoint=Vector2.new(1,0.5)
aZ.BackgroundColor3=Color3.fromRGB(12,12,14)
aZ.BorderSizePixel=0
aZ.ZIndex=6
aZ.Parent=aJ

local a_=Instance.new"Frame"
a_.Name="Fill"
a_.Size=UDim2.new(1,0,0.86,0)
a_.Position=UDim2.new(0,0,1,0)
a_.AnchorPoint=Vector2.new(0,1)
a_.BackgroundColor3=Color3.fromRGB(90,245,140)
a_.BorderSizePixel=0
a_.ZIndex=7
a_.Parent=aZ

local a0=Instance.new"TextLabel"
a0.Name="HPText"
a0.Size=UDim2.new(0,30,0,12)
a0.Position=UDim2.new(0,-4,0.14,0)
a0.AnchorPoint=Vector2.new(1,0.5)
a0.BackgroundTransparency=1
a0.Font=Enum.Font.GothamBold
a0.TextSize=10
a0.TextColor3=Color3.fromRGB(90,245,140)
a0.TextXAlignment=Enum.TextXAlignment.Right
a0.Text="86"
a0.ZIndex=7
a0.Parent=aZ

local a1=Instance.new"TextLabel"
a1.Name="NameTag"
a1.Size=UDim2.new(0,160,0,16)
a1.Position=UDim2.new(0.5,0,0,-22)
a1.AnchorPoint=Vector2.new(0.5,0)
a1.BackgroundTransparency=1
a1.Font=Enum.Font.GothamBold
a1.TextSize=12
a1.TextColor3=Color3.fromRGB(245,245,250)
a1.Text="6vxft"
a1.ZIndex=7
a1.Parent=aJ

local a2=Instance.new"TextLabel"
a2.Name="WeaponTag"
a2.Size=UDim2.new(0,160,0,14)
a2.Position=UDim2.new(0.5,0,1,6)
a2.AnchorPoint=Vector2.new(0.5,0)
a2.BackgroundTransparency=1
a2.Font=Enum.Font.GothamMedium
a2.TextSize=10
a2.TextColor3=Color3.fromRGB(205,205,218)
a2.Text="[Double-Barrel SG]"
a2.ZIndex=7
a2.Parent=aJ

local a3=Instance.new"TextLabel"
a3.Name="DistanceTag"
a3.Size=UDim2.new(0,160,0,14)
a3.Position=UDim2.new(0.5,0,1,20)
a3.AnchorPoint=Vector2.new(0.5,0)
a3.BackgroundTransparency=1
a3.Font=Enum.Font.GothamMedium
a3.TextSize=10
a3.TextColor3=Color3.fromRGB(155,155,170)
a3.Text="24 studs"
a3.ZIndex=7
a3.Parent=aJ

local a4=Instance.new"Frame"
a4.Name="Tracer"
a4.Size=UDim2.new(0,2,0,108)
a4.Position=UDim2.new(0.5,4,1,-54)
a4.AnchorPoint=Vector2.new(0.5,0.5)
a4.BackgroundColor3=Color3.fromRGB(0,210,140)
a4.BorderSizePixel=0
a4.Visible=false
a4.ZIndex=5
a4.Parent=aC

local function refreshESPPreviewVisuals()
local a5=aa.ESPPreviewState
local a6=a5.Boxes==true
aT.Visible=a6
aT.BackgroundColor3=a5.BoxColor or o
local a7=(a5.BoxFilled==true)or(a5.BoxFill==true)
aT.BackgroundTransparency=(a6 and a7)and 0.84 or 1
local a8=a5.BoxStyle=="Corner"
aV.Visible=a6 and not a8
aU.Enabled=a6 and not a8
aX.Visible=a6 and a8
aW.Color=a5.BoxColor or o
for a9,ba in ipairs(aY)do
ba.BackgroundColor3=a5.BoxColor or o
end

a1.Visible=a5.Names==true
a1.TextColor3=a5.NameColor or Color3.fromRGB(245,245,250)

local a9=(a5.Health==true)or(a5.HealthBar==true)
aZ.Visible=a9
a_.BackgroundColor3=a5.HealthColor or Color3.fromRGB(90,245,140)
a0.TextColor3=a5.HealthColor or Color3.fromRGB(90,245,140)

a2.Visible=a5.Weapon~=false
a3.Visible=a5.Distance==true
a3.TextColor3=a5.DistanceColor or Color3.fromRGB(165,165,180)
a3.Position=(a5.Weapon~=false)and UDim2.new(0.5,0,1,20)or UDim2.new(0.5,0,1,6)

a4.Visible=a5.Tracers==true
a4.BackgroundColor3=a5.TracerColor or o

aO.Visible=a5.Bones==true
for ba,bb in ipairs(aP)do
bb.BackgroundColor3=a5.BoneColor or Color3.fromRGB(240,240,250)
end

aQ.Visible=a5.HeadDot==true
aQ.BackgroundColor3=a5.HeadDotColor or o

local ba=a5.ChamsColor or o
if#aM>0 then
aK.BackgroundTransparency=1
for bb,bc in ipairs(aM)do
if bc.Part and bc.Part.Parent then
if a5.Chams then
bc.Part.Color=ba
bc.Part.Material=Enum.Material.Neon
bc.Part.Transparency=0.25
else
bc.Part.Color=bc.OrigColor
bc.Part.Material=bc.OrigMaterial
bc.Part.Transparency=bc.OrigTrans
end
end
end
else
aK.BackgroundColor3=ba
aK.BackgroundTransparency=a5.Chams and 0.65 or 1
aI.ImageColor3=a5.Chams and ba or Color3.fromRGB(255,255,255)
end
end

function aa.UpdateESPPreview(a5,a6)
if type(a6)=="table"then
for a7,a8 in pairs(a6)do
if a7=="BoxFill"then
aa.ESPPreviewState.BoxFilled=a8
elseif a7=="HealthBar"then
aa.ESPPreviewState.Health=a8
end
aa.ESPPreviewState[a7]=a8
end
end
refreshESPPreviewVisuals()
end

local a5=Instance.new"Frame"
a5.Name="ButtonPreviewPage"
a5.Size=UDim2.new(1,0,1,-44)
a5.Position=UDim2.new(0,0,0,44)
a5.BackgroundTransparency=1
a5.Visible=false
a5.Parent=at

local a6=Instance.new"Frame"
a6.Name="ButtonStage"
a6.Size=UDim2.new(1,-24,0,196)
a6.Position=UDim2.new(0,12,0,12)
a6.BackgroundColor3=Color3.fromRGB(14,14,16)
a6.BorderSizePixel=0
a6.ClipsDescendants=true
a6.Parent=a5

local a7=Instance.new"UICorner"
a7.CornerRadius=UDim.new(0,10)
a7.Parent=a6

local a8=Instance.new"UIStroke"
a8.Color=Color3.fromRGB(28,28,34)
a8.Thickness=1
a8.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
a8.Parent=a6

for a9=1,4 do
local ba=Instance.new"Frame"
ba.Size=UDim2.new(1,0,0,1)
ba.Position=UDim2.new(0,0,a9/5,0)
ba.BackgroundColor3=Color3.fromRGB(21,21,25)
ba.BorderSizePixel=0
ba.Parent=a6

local bb=Instance.new"Frame"
bb.Size=UDim2.new(0,1,1,0)
bb.Position=UDim2.new(a9/5,0,0,0)
bb.BackgroundColor3=Color3.fromRGB(21,21,25)
bb.BorderSizePixel=0
bb.Parent=a6
end

local a9=Instance.new"TextLabel"
a9.Size=UDim2.new(1,-20,0,16)
a9.Position=UDim2.new(0,10,0,8)
a9.BackgroundTransparency=1
a9.Font=Enum.Font.GothamMedium
a9.TextSize=10
a9.TextColor3=Color3.fromRGB(120,120,132)
a9.TextXAlignment=Enum.TextXAlignment.Left
a9.Text=""
a9.Visible=false
a9.ZIndex=3
a9.Parent=a6

local ba=Instance.new"TextLabel"
ba.Size=UDim2.new(1,-20,0,16)
ba.Position=UDim2.new(0,10,1,-22)
ba.BackgroundTransparency=1
ba.Font=Enum.Font.GothamBold
ba.TextSize=10
ba.TextColor3=Color3.fromRGB(145,145,158)
ba.TextXAlignment=Enum.TextXAlignment.Left
ba.Text="116 × 42 px  •  Radius: 10px"
ba.ZIndex=3
ba.Parent=a6

local bb=Instance.new"TextButton"
bb.Name="PreviewButtonWidget"
bb.Size=UDim2.new(0,116,0,42)
bb.Position=UDim2.new(0.5,0,0.5,2)
bb.AnchorPoint=Vector2.new(0.5,0.5)
bb.BackgroundColor3=Color3.fromRGB(20,20,24)
bb.BackgroundTransparency=0.12
bb.BorderSizePixel=0
bb.AutoButtonColor=false
bb.Text=""
bb.ZIndex=4
bb.Parent=a6

local bc=Instance.new"UICorner"
bc.CornerRadius=UDim.new(0,10)
bc.Parent=bb

local bd=Instance.new"UIStroke"
bd.Color=o
bd.Thickness=1.5
bd.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
bd.Parent=bb

local be=Instance.new"Frame"
be.Name="Dot"
be.Size=UDim2.new(0,8,0,8)
be.Position=UDim2.new(0,12,0.5,0)
be.AnchorPoint=Vector2.new(0,0.5)
be.BackgroundColor3=o
be.BorderSizePixel=0
be.ZIndex=5
be.Parent=bb

local bf=Instance.new"UICorner"
bf.CornerRadius=UDim.new(1,0)
bf.Parent=be

local bg=Instance.new"TextLabel"
bg.Name="Label"
bg.Size=UDim2.new(1,-34,0,16)
bg.Position=UDim2.new(0,26,0.5,-6)
bg.AnchorPoint=Vector2.new(0,0.5)
bg.BackgroundTransparency=1
bg.Font=Enum.Font.GothamBold
bg.TextSize=12
bg.TextColor3=Color3.fromRGB(245,245,250)
bg.TextXAlignment=Enum.TextXAlignment.Left
bg.TextTruncate=Enum.TextTruncate.AtEnd
bg.Text="Aim Assist"
bg.ZIndex=5
bg.Parent=bb

local bh=Instance.new"TextLabel"
bh.Name="SubState"
bh.Size=UDim2.new(1,-34,0,12)
bh.Position=UDim2.new(0,26,0.5,8)
bh.AnchorPoint=Vector2.new(0,0.5)
bh.BackgroundTransparency=1
bh.Font=Enum.Font.GothamMedium
bh.TextSize=9
bh.TextColor3=o
bh.TextXAlignment=Enum.TextXAlignment.Left
bh.Text="ENABLED"
bh.ZIndex=5
bh.Parent=bb

local bi=Instance.new"TextLabel"
bi.Name="ResizeCorner"
bi.Size=UDim2.new(0,12,0,12)
bi.Position=UDim2.new(1,-2,1,-2)
bi.AnchorPoint=Vector2.new(1,1)
bi.BackgroundTransparency=1
bi.Font=Enum.Font.GothamBold
bi.TextSize=9
bi.TextColor3=Color3.fromRGB(110,110,125)
bi.Text="◢"
bi.ZIndex=6
bi.Parent=bb

local bj=Instance.new"Frame"
bj.Name="ActiveButtonsCard"
bj.Size=UDim2.new(1,-24,1,-232)
bj.Position=UDim2.new(0,12,0,218)
bj.BackgroundColor3=Color3.fromRGB(15,15,17)
bj.BorderSizePixel=0
bj.Parent=a5

local bk=Instance.new"UICorner"
bk.CornerRadius=UDim.new(0,10)
bk.Parent=bj

local bl=Instance.new"UIStroke"
bl.Color=Color3.fromRGB(28,28,34)
bl.Thickness=1
bl.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
bl.Parent=bj

local bm=Instance.new"TextLabel"
bm.Name="Header"
bm.Size=UDim2.new(1,-20,0,24)
bm.Position=UDim2.new(0,12,0,6)
bm.BackgroundTransparency=1
bm.Font=Enum.Font.GothamBold
bm.TextSize=11
bm.TextColor3=Color3.fromRGB(170,170,182)
bm.TextXAlignment=Enum.TextXAlignment.Left
bm.Text="Buttons (0)"
bm.Parent=bj

local bn=Instance.new"ScrollingFrame"
bn.Name="List"
bn.Size=UDim2.new(1,-16,1,-36)
bn.Position=UDim2.new(0,8,0,30)
bn.BackgroundTransparency=1
bn.BorderSizePixel=0
bn.ScrollBarThickness=2
bn.ScrollBarImageColor3=Color3.fromRGB(42,42,50)
bn.AutomaticCanvasSize=Enum.AutomaticSize.Y
bn.CanvasSize=UDim2.new(0,0,0,0)
bn.Parent=bj

local bo=Instance.new"UIListLayout"
bo.SortOrder=Enum.SortOrder.LayoutOrder
bo.Padding=UDim.new(0,6)
bo.Parent=bn

local function applyStyleToButtonWidget(bp,bq,br,bs,bt,bu,bv,bw)
local bx=math.clamp(tonumber(bv.Width)or 116,48,220)
local by=math.clamp(tonumber(bv.Height)or 42,28,110)
local bz=math.clamp(tonumber(bv.CornerRadius)or 10,2,30)
local bA=math.clamp(tonumber(bv.Opacity)or 88,10,100)
local bB=bv.Style or"Standard"
local bC=(bv.Label and bv.Label~="")and bv.Label or bv.Feature or"Toggle"

bp.Size=UDim2.new(0,bx,0,by)
bu.CornerRadius=UDim.new(0,bz)
bp.BackgroundTransparency=1-(bA/100)

if bB=="Outline"then
bp.BackgroundColor3=Color3.fromRGB(14,14,17)
bt.Thickness=1.6
bt.Color=bw and o or Color3.fromRGB(48,48,56)
elseif bB=="Minimal"then
bp.BackgroundColor3=bw and o:Lerp(Color3.fromRGB(20,20,24),0.78)or Color3.fromRGB(18,18,22)
bt.Thickness=1
bt.Color=bw and o or Color3.fromRGB(32,32,38)
else
bp.BackgroundColor3=Color3.fromRGB(20,20,24)
bt.Thickness=1.4
bt.Color=bw and o or Color3.fromRGB(38,38,45)
end

br.Text=bC
local bD=math.clamp(math.floor(math.min(bx/9.2,by*0.32)),10,15)
br.TextSize=bD

if bB=="Compact"or by<36 or bx<86 then
bq.Visible=false
bs.Visible=false
br.Size=UDim2.new(1,-12,1,0)
br.Position=UDim2.new(0,6,0.5,0)
br.TextXAlignment=Enum.TextXAlignment.Center
br.TextColor3=bw and o or Color3.fromRGB(215,215,225)
else
bq.Visible=true
bq.BackgroundColor3=bw and o or Color3.fromRGB(72,72,82)
bs.Visible=true
bs.Text=bw and"ON"or"OFF"
bs.TextColor3=bw and o or Color3.fromRGB(115,115,128)
br.Size=UDim2.new(1,-32,0,15)
br.Position=UDim2.new(0,26,0.5,-6)
br.TextXAlignment=Enum.TextXAlignment.Left
br.TextColor3=bw and Color3.fromRGB(245,245,250)or Color3.fromRGB(190,190,202)
end
end

local function refreshButtonPreviewWidget()
local bp=aa.ButtonDraft
local bq=aa.ModuleByName[bp.Feature]
local br=bq and bq.Enabled or bp.PreviewActive
applyStyleToButtonWidget(
bb,
be,
bg,
bh,
bd,
bc,
bp,
br
)
ba.Text=string.format("%dx%d",bp.Width,bp.Height)
end

bb.MouseButton1Click:Connect(function()
if isTouchDragging then return end
local bp=aa.ButtonDraft
local bq=aa.ModuleByName[bp.Feature]
if bq then
bq:Set(not bq.Enabled)
else
bp.PreviewActive=not bp.PreviewActive
end
refreshButtonPreviewWidget()
end)

local function isPreviewAllowedForActiveTab()
if not aa.PreviewEnabled or not y.Visible or not aa.ActiveTab then
return false
end
local bp=string.lower(tostring(aa.ActiveTab.Name or""))
return bp=="visuals"or bp=="visual"or bp=="settings"
end

function aa.SetPreviewMode(bp,bq)
bq=(bq=="Buttons")and"Buttons"or"ESP"
aa.PreviewMode=bq
if bq=="ESP"then
aB.Visible=true
a5.Visible=false
refreshESPPreviewVisuals()
else
aB.Visible=false
a5.Visible=true
refreshButtonPreviewWidget()
end
end

function aa.SetPreviewVisible(bp,bq)
aa.PreviewEnabled=bq==true
at.Visible=isPreviewAllowedForActiveTab()
end

local function syncPreviewWindowDock()
if not at or not y then return end
local bp=y.AbsolutePosition
local bq=y.AbsoluteSize
local br=t.AbsoluteSize
local bs=z and z.Scale or 1
local bt=as*bs
local bu=bp.X+bq.X+(8*bs)
if br.X>0 and(bu+bt>br.X-4)then
bu=math.max(4,bp.X-bt-(8*bs))
end
at.Position=UDim2.fromOffset(bu,bp.Y)
at.Size=UDim2.new(0,as,0,550)
if x then
x.Scale=bs
end
end

y:GetPropertyChangedSignal"AbsolutePosition":Connect(syncPreviewWindowDock)
y:GetPropertyChangedSignal"AbsoluteSize":Connect(syncPreviewWindowDock)
task.defer(syncPreviewWindowDock)

local bp=Instance.new"Folder"
bp.Name="FloatingToggleButtons"
bp.Parent=t

local function refreshActiveButtonsListUI()
for bq,br in ipairs(bn:GetChildren())do
if br:IsA"Frame"then
br:Destroy()
end
end
local bq=0
for br,bs in pairs(aa.FloatingButtons)do
bq=bq+1
local bt=Instance.new"Frame"
bt.Name="Row_"..br
bt.Size=UDim2.new(1,-4,0,32)
bt.BackgroundColor3=Color3.fromRGB(21,21,25)
bt.BorderSizePixel=0
bt.Parent=bn

local bu=Instance.new"UICorner"
bu.CornerRadius=UDim.new(0,6)
bu.Parent=bt

local bv=Instance.new"UIStroke"
bv.Color=Color3.fromRGB(30,30,36)
bv.Thickness=1
bv.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
bv.Parent=bt

local bw=Instance.new"TextButton"
bw.Size=UDim2.new(1,-34,1,0)
bw.Position=UDim2.new(0,8,0,0)
bw.BackgroundTransparency=1
bw.Font=Enum.Font.GothamMedium
bw.TextSize=11
bw.TextColor3=Color3.fromRGB(225,225,235)
bw.TextXAlignment=Enum.TextXAlignment.Left
bw.TextTruncate=Enum.TextTruncate.AtEnd
bw.Text=string.format("%s (%d×%d)",br,bs.Config.Width,bs.Config.Height)
bw.Parent=bt

bw.MouseButton1Click:Connect(function()
if isTouchDragging then return end
if aa.OnSelectFloatingButtonInManager then
pcall(aa.OnSelectFloatingButtonInManager,br,bs.Config)
end
end)

local bx=Instance.new"TextButton"
bx.Size=UDim2.new(0,22,0,22)
bx.Position=UDim2.new(1,-6,0.5,0)
bx.AnchorPoint=Vector2.new(1,0.5)
bx.BackgroundColor3=Color3.fromRGB(28,28,34)
bx.BorderSizePixel=0
bx.AutoButtonColor=false
bx.Font=Enum.Font.GothamBold
bx.TextSize=12
bx.TextColor3=Color3.fromRGB(200,90,105)
bx.Text="×"
bx.Parent=bt

local by=Instance.new"UICorner"
by.CornerRadius=UDim.new(0,5)
by.Parent=bx

bx.MouseButton1Click:Connect(function()
if isTouchDragging then return end
aa:RemoveFloatingButton(br)
end)
end
bm.Text=string.format("Buttons (%d)",bq)
end

function aa.RemoveFloatingButton(bq,br)
local bs=aa.FloatingButtons[br]
if bs then
if bs.Button and bs.Button.Parent then
bs.Button:Destroy()
end
aa.FloatingButtons[br]=nil
refreshActiveButtonsListUI()
return true
end
return false
end

function aa.ClearFloatingButtons(bq)
local br={}
for bs,bt in pairs(aa.FloatingButtons)do
table.insert(br,bs)
end
for bs,bt in ipairs(br)do
aa:RemoveFloatingButton(bt)
end
end

function aa.SetButtonsLocked(bq,br)
aa.ButtonsLocked=br==true
for bs,bt in pairs(aa.FloatingButtons)do
if bt.ResizeGrip then
bt.ResizeGrip.Visible=not aa.ButtonsLocked
end
end
end

function aa.CreateFloatingButton(bq,br)
br=br or{}
local bs=br.Feature or aa.ButtonDraft.Feature or"Aim Assist"
local bt=aa.FloatingButtons[bs]

local bu=tonumber(br.PosX)
local bv=tonumber(br.PosY)
local bw=tonumber(br.ScaleX)or 0
local bx=tonumber(br.ScaleY)or 0

local by={
Feature=bs,
Label=br.Label~=nil and br.Label or(bt and bt.Config.Label)or"",
Style=br.Style or(bt and bt.Config.Style)or"Standard",
Width=math.clamp(tonumber(br.Width)or(bt and bt.Config.Width)or 116,48,220),
Height=math.clamp(tonumber(br.Height)or(bt and bt.Config.Height)or 42,28,110),
CornerRadius=math.clamp(tonumber(br.CornerRadius)or(bt and bt.Config.CornerRadius)or 10,2,30),
Opacity=math.clamp(tonumber(br.Opacity)or(bt and bt.Config.Opacity)or 88,10,100),
PosX=bu,
PosY=bv,
ScaleX=bw,
ScaleY=bx
}

if bt and bt.Button and bt.Button.Parent then
bt.Config=by
if by.PosX and by.PosY then
bt.Button.Position=UDim2.new(by.ScaleX or 0,by.PosX,by.ScaleY or 0,by.PosY)
end
bt.Refresh()
refreshActiveButtonsListUI()
return bt
end

local bz=0
for bA in pairs(aa.FloatingButtons)do bz=bz+1 end
local bA=bu or(90+(bz%3)*130)
local bB=bv or(140+math.floor(bz/3)*56)

local bC=Instance.new"TextButton"
bC.Name="FloatingToggle_"..bs
bC.Size=UDim2.fromOffset(by.Width,by.Height)
bC.Position=UDim2.new(bw,bA,bx,bB)
bC.BackgroundColor3=Color3.fromRGB(20,20,24)
bC.BorderSizePixel=0
bC.AutoButtonColor=false
bC.Text=""
bC.ZIndex=950
bC.Parent=bp

local bD=Instance.new"UICorner"
bD.CornerRadius=UDim.new(0,by.CornerRadius)
bD.Parent=bC

local bE=Instance.new"UIStroke"
bE.Color=Color3.fromRGB(38,38,45)
bE.Thickness=1.4
bE.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
bE.Parent=bC

local bF=Instance.new"Frame"
bF.Name="Dot"
bF.Size=UDim2.new(0,8,0,8)
bF.Position=UDim2.new(0,12,0.5,0)
bF.AnchorPoint=Vector2.new(0,0.5)
bF.BackgroundColor3=Color3.fromRGB(72,72,82)
bF.BorderSizePixel=0
bF.ZIndex=951
bF.Parent=bC

local bG=Instance.new"UICorner"
bG.CornerRadius=UDim.new(1,0)
bG.Parent=bF

local bH=Instance.new"TextLabel"
bH.Name="Label"
bH.Size=UDim2.new(1,-34,0,15)
bH.Position=UDim2.new(0,26,0.5,-6)
bH.AnchorPoint=Vector2.new(0,0.5)
bH.BackgroundTransparency=1
bH.Font=Enum.Font.GothamBold
bH.TextSize=12
bH.TextColor3=Color3.fromRGB(240,240,246)
bH.TextXAlignment=Enum.TextXAlignment.Left
bH.TextTruncate=Enum.TextTruncate.AtEnd
bH.Text=bs
bH.ZIndex=951
bH.Parent=bC

local bI=Instance.new"TextLabel"
bI.Name="SubState"
bI.Size=UDim2.new(1,-34,0,12)
bI.Position=UDim2.new(0,26,0.5,8)
bI.AnchorPoint=Vector2.new(0,0.5)
bI.BackgroundTransparency=1
bI.Font=Enum.Font.GothamMedium
bI.TextSize=9
bI.TextColor3=Color3.fromRGB(115,115,128)
bI.TextXAlignment=Enum.TextXAlignment.Left
bI.Text="OFF"
bI.ZIndex=951
bI.Parent=bC

local bJ=Instance.new"TextButton"
bJ.Name="ResizeGrip"
bJ.Size=UDim2.new(0,14,0,14)
bJ.Position=UDim2.new(1,-1,1,-1)
bJ.AnchorPoint=Vector2.new(1,1)
bJ.BackgroundTransparency=1
bJ.AutoButtonColor=false
bJ.Font=Enum.Font.GothamBold
bJ.TextSize=9
bJ.TextColor3=Color3.fromRGB(115,115,130)
bJ.Text="◢"
bJ.Visible=not aa.ButtonsLocked
bJ.ZIndex=953
bJ.Parent=bC

local bK={
Feature=bs,
Button=bC,
ResizeGrip=bJ,
Config=by
}

local function refreshEntryVisuals()
local bL=aa.ModuleByName[bs]
local bM=bL and bL.Enabled or false
applyStyleToButtonWidget(bC,bF,bH,bI,bE,bD,bK.Config,bM)
end

bK.Refresh=refreshEntryVisuals
refreshEntryVisuals()

local bL=false
local bM
local bN
local bO
local bP=0

local bQ=false
local bR
local bS

bJ.InputBegan:Connect(function(bT)
if aa.ButtonsLocked then return end
if bT.UserInputType==Enum.UserInputType.MouseButton1 or bT.UserInputType==Enum.UserInputType.Touch then
bQ=true
bM=bT
bR=bT.Position
bS=Vector2.new(bK.Config.Width,bK.Config.Height)
tween(bJ,{TextColor3=o},0.12)
end
end)

bC.InputBegan:Connect(function(bT)
if bQ then return end
if bT.UserInputType==Enum.UserInputType.MouseButton1 or bT.UserInputType==Enum.UserInputType.Touch then
bL=true
bM=bT
bN=bT.Position
bO=Vector2.new(bC.Position.X.Offset,bC.Position.Y.Offset)
bP=0
end
end)

b.InputChanged:Connect(function(bT)
if bT.UserInputType==Enum.UserInputType.MouseMovement or bT.UserInputType==Enum.UserInputType.Touch then
if bQ and not aa.ButtonsLocked then
local bU=bT.Position-bR
bK.Config.Width=math.clamp(math.floor(bS.X+bU.X+0.5),48,220)
bK.Config.Height=math.clamp(math.floor(bS.Y+bU.Y+0.5),28,110)
refreshEntryVisuals()
if aa.ButtonDraft.Feature==bs then
aa.ButtonDraft.Width=bK.Config.Width
aa.ButtonDraft.Height=bK.Config.Height
refreshButtonPreviewWidget()
if aa.OnSyncButtonManagerSliders then
pcall(aa.OnSyncButtonManagerSliders,bK.Config.Width,bK.Config.Height)
end
end
elseif bL and not bQ then
local bU=bT.Position-bN
local bV=math.sqrt(bU.X*bU.X+bU.Y*bU.Y)
if bV>bP then bP=bV end
if not aa.ButtonsLocked and bP>=5 then
local bW=bO.X+bU.X
local bX=bO.Y+bU.Y
bC.Position=UDim2.new(bC.Position.X.Scale,bW,bC.Position.Y.Scale,bX)
bK.Config.PosX=bW
bK.Config.PosY=bX
bK.Config.ScaleX=bC.Position.X.Scale
bK.Config.ScaleY=bC.Position.Y.Scale
end
end
end
end)

b.InputEnded:Connect(function(bT)
if bT.UserInputType==Enum.UserInputType.MouseButton1 or bT.UserInputType==Enum.UserInputType.Touch then
if bQ then
bQ=false
tween(bJ,{TextColor3=Color3.fromRGB(115,115,130)},0.15)
refreshActiveButtonsListUI()
elseif bL then
bL=false
if bP<6 then
local bU=aa.ModuleByName[bs]
if bU then
bU:Set(not bU.Enabled)
end
refreshEntryVisuals()
if aa.ButtonDraft.Feature==bs then
refreshButtonPreviewWidget()
end
end
end
end
end)

aa.FloatingButtons[bs]=bK
refreshActiveButtonsListUI()
return bK
end

registerThemeRefresher(function(bq)
refreshESPPreviewVisuals()
refreshButtonPreviewWidget()
for br,bs in pairs(aa.FloatingButtons)do
if bs.Refresh then
pcall(bs.Refresh)
end
end
end)

refreshESPPreviewVisuals()
refreshButtonPreviewWidget()

task.spawn(function()
local bq=0
local br=tick()
local bs=60
local bt
bt=e.RenderStepped:Connect(function()
if not t or not t.Parent then
if bt then bt:Disconnect()end
return
end
bq=bq+1
local bu=tick()
if bu-br>=0.5 then
bs=math.floor(bq/(bu-br)+0.5)
bq=0
br=bu
if ae.Visible then
local bv=0
pcall(function()
local bw=game:GetService"Stats"
bv=math.floor(bw.Network.ServerStatsItem["Data Ping"]:GetValue()+0.5)
end)
local bw=string.format("%s  |  %d FPS  |  %d ms",formatBrandRichText(m,o),bs,bv)
aj.Text=bw
ae.Size=UDim2.new(0,math.max(210,aj.TextBounds.X+30),0,30)
end
end
end)
end)

local bq=false
function aa.Toggle(br,bs)
if bs==nil then
bs=not y.Visible
end
if bq then return end
bq=true
task.delay(0.25,function()
bq=false
end)
if bs then
updateResponsiveScale()
y.Visible=true
if isPreviewAllowedForActiveTab()then
at.Visible=true
at.BackgroundTransparency=0.5
tween(at,{BackgroundTransparency=0},0.2)
else
at.Visible=false
end
z.Scale=w*0.95
if x then x.Scale=w*0.95 end
y.BackgroundTransparency=0.5
if ac then
tween(ac,{Color=o},0.2)
end
local bt=tween(y,{
BackgroundTransparency=0
},0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
tween(z,{
Scale=w
},0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
if x then
tween(x,{
Scale=w
},0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
end
bt.Completed:Connect(function()
syncPreviewWindowDock()
bq=false
end)
else
if ac then
tween(ac,{Color=Color3.fromRGB(42,42,48)},0.2)
end
if at.Visible then
tween(at,{BackgroundTransparency=0.8},0.15)
end
local bt=tween(y,{
BackgroundTransparency=0.8
},0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
tween(z,{
Scale=w*0.95
},0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
if x then
tween(x,{
Scale=w*0.95
},0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
end
bt.Completed:Connect(function()
y.Visible=false
at.Visible=false
bq=false
end)
end
end

b.InputBegan:Connect(function(br,bs)
local function matchesBindKey(bt,bu)
if not bu or bu==Enum.KeyCode.Unknown then return false end
if typeof(bu)=="EnumItem"then
if bu.EnumType==Enum.KeyCode then
return bt.KeyCode==bu
elseif bu.EnumType==Enum.UserInputType then
return bt.UserInputType==bu
end
end
return false
end
if not bs and matchesBindKey(br,n)then
aa:Toggle()
end
end)

if r then
ab=Instance.new"Frame"
ab.Name="MobileToggleButton"
ab.Size=UDim2.new(0,48,0,48)
ab.Position=l.MobileButtonPosition or UDim2.new(0,48,0.5,0)
ab.AnchorPoint=Vector2.new(0.5,0.5)
ab.BackgroundColor3=Color3.fromRGB(22,22,26)
ab.BorderSizePixel=0
ab.Active=true
ab.ZIndex=1000
ab.Parent=t

local br=Instance.new"UICorner"
br.CornerRadius=UDim.new(0,14)
br.Parent=ab

ac=Instance.new"UIStroke"
ac.Color=o
ac.Thickness=1.5
ac.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
ac.Parent=ab

ad=Instance.new"ImageLabel"
ad.Name="Icon"
ad.Size=UDim2.new(0,26,0,26)
ad.Position=UDim2.new(0.5,0,0.5,0)
ad.AnchorPoint=Vector2.new(0.5,0.5)
ad.BackgroundTransparency=1
ad.Image=l.HourglassImage or i.hourglass
ad.ImageColor3=o
ad.ScaleType=Enum.ScaleType.Fit
ad.ZIndex=1001
ad.Parent=ab

local bs=false
local bt
local bu
local bv
local bw=0

ab.InputBegan:Connect(function(bx)
if bx.UserInputType==Enum.UserInputType.MouseButton1 or bx.UserInputType==Enum.UserInputType.Touch then
bs=true
bt=bx
bu=bx.Position
bv=ab.Position
bw=0
tween(ab,{BackgroundColor3=Color3.fromRGB(28,28,34)},0.15)
tween(ac,{Color=o},0.15)
end
end)

ab.MouseEnter:Connect(function()
tween(ac,{Color=o},0.2)
tween(ab,{BackgroundColor3=Color3.fromRGB(26,26,32)},0.2)
end)

ab.MouseLeave:Connect(function()
if not bs then
local bx=y.Visible and o or Color3.fromRGB(42,42,48)
tween(ac,{Color=bx},0.2)
tween(ab,{BackgroundColor3=Color3.fromRGB(22,22,26)},0.2)
end
end)

b.InputChanged:Connect(function(bx)
if bs then
if bx==bt or bx.UserInputType==Enum.UserInputType.MouseMovement or bx.UserInputType==Enum.UserInputType.Touch then
local by=bx.Position-bu
local bz=math.sqrt(by.X*by.X+by.Y*by.Y)
if bz>bw then
bw=bz
end
ab.Position=UDim2.new(
bv.X.Scale,
bv.X.Offset+by.X,
bv.Y.Scale,
bv.Y.Offset+by.Y
)
end
end
end)

b.InputEnded:Connect(function(bx)
if bs and(bx==bt or bx.UserInputType==Enum.UserInputType.MouseButton1 or bx.UserInputType==Enum.UserInputType.Touch)then
bs=false
bt=nil
local by=y.Visible and o or Color3.fromRGB(42,42,48)
tween(ac,{Color=by},0.2)
tween(ab,{BackgroundColor3=Color3.fromRGB(22,22,26)},0.2)
if bw<14 then
local bz=UDim2.new(0,48,0,48)
tween(ab,{Size=UDim2.new(0,42,0,42)},0.08)
task.delay(0.08,function()
if ab and ab.Parent then
tween(ab,{Size=bz},0.12,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
end
end)
aa:Toggle()
end
end
end)

aa.MobileButton=ab
end

function aa.Notify(br,bs)
bs=bs or{}
local bt=tostring(bs.Title or m)
local bu=tostring(bs.Description or"")
local bv=tonumber(bs.Duration)or 3

local bw=game:GetService"TextService"
local bx=246
local by=Vector2.new(180,16)
pcall(function()
by=bw:GetTextSize(bu,12,Enum.Font.Gotham,Vector2.new(bx,200))
end)
local bz=Vector2.new(100,16)
pcall(function()
bz=bw:GetTextSize(bt,13,Enum.Font.GothamBold,Vector2.new(bx,40))
end)

local bA=math.clamp(math.max(by.X,bz.X)+46,230,300)
local bB=math.max(16,by.Y)
local bC=math.max(58,38+bB+10)

local bD=Instance.new"Frame"
bD.Name="ToastSlot"
bD.Size=UDim2.new(0,bA,0,bC)
bD.BackgroundTransparency=1
bD.BorderSizePixel=0
bD.Parent=Y

local bE=Instance.new"Frame"
bE.Name="Toast"
bE.Size=UDim2.new(1,0,1,0)
bE.Position=UDim2.new(1,40,0,0)
bE.BackgroundColor3=Color3.fromRGB(20,20,24)
bE.BorderSizePixel=0
bE.BackgroundTransparency=0.2
bE.ClipsDescendants=true
bE.Parent=bD

local bF=Instance.new"UICorner"
bF.CornerRadius=UDim.new(0,10)
bF.Parent=bE

local bG=Instance.new"UIStroke"
bG.Color=Color3.fromRGB(36,36,44)
bG.Thickness=1
bG.Transparency=0.2
bG.Parent=bE

local bH=Instance.new"Frame"
bH.Name="Accent"
bH.Size=UDim2.new(0,3,1,-20)
bH.Position=UDim2.new(0,10,0.5,-1)
bH.AnchorPoint=Vector2.new(0,0.5)
bH.BackgroundColor3=o
bH.BorderSizePixel=0
bH.Parent=bE

local bI=Instance.new"UICorner"
bI.CornerRadius=UDim.new(1,0)
bI.Parent=bH

local bJ=Instance.new"TextLabel"
bJ.Name="Title"
bJ.Size=UDim2.new(1,-36,0,18)
bJ.Position=UDim2.new(0,22,0,9)
bJ.BackgroundTransparency=1
bJ.Font=Enum.Font.GothamBold
bJ.TextSize=13
bJ.RichText=true
bJ.TextColor3=Color3.fromRGB(240,240,246)
bJ.TextXAlignment=Enum.TextXAlignment.Left
bJ.TextYAlignment=Enum.TextYAlignment.Center
if string.lower(bt)==string.lower(m)then
bJ.Text=formatBrandRichText(bt,o)
else
bJ.Text=bt
end
bJ.Parent=bE

local bK=Instance.new"TextLabel"
bK.Name="Desc"
bK.Size=UDim2.new(1,-36,0,bB)
bK.Position=UDim2.new(0,22,0,29)
bK.BackgroundTransparency=1
bK.Font=Enum.Font.Gotham
bK.TextSize=12
bK.TextColor3=Color3.fromRGB(165,165,178)
bK.TextXAlignment=Enum.TextXAlignment.Left
bK.TextYAlignment=Enum.TextYAlignment.Top
bK.TextWrapped=true
bK.Text=bu
bK.Parent=bE

local bL=Instance.new"Frame"
bL.Name="ProgressTrack"
bL.Size=UDim2.new(1,-20,0,2)
bL.Position=UDim2.new(0,10,1,-4)
bL.BackgroundColor3=Color3.fromRGB(30,30,36)
bL.BorderSizePixel=0
bL.Parent=bE

local bM=Instance.new"UICorner"
bM.CornerRadius=UDim.new(1,0)
bM.Parent=bL

local bN=Instance.new"Frame"
bN.Name="Fill"
bN.Size=UDim2.new(1,0,1,0)
bN.BackgroundColor3=o
bN.BorderSizePixel=0
bN.Parent=bL

local bO=Instance.new"UICorner"
bO.CornerRadius=UDim.new(1,0)
bO.Parent=bN

tween(bE,{
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=0
},0.28,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
tween(bG,{Transparency=0},0.25)
tween(bN,{Size=UDim2.new(0,0,1,0)},bv,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)

task.delay(bv,function()
if bD and bD.Parent then
tween(bE,{
Position=UDim2.new(1,40,0,0),
BackgroundTransparency=1
},0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.In)
tween(bG,{Transparency=1},0.2)
tween(bH,{BackgroundTransparency=1},0.2)
tween(bJ,{TextTransparency=1},0.2)
tween(bK,{TextTransparency=1},0.2)
tween(bL,{BackgroundTransparency=1},0.2)
tween(bN,{BackgroundTransparency=1},0.2)
task.delay(0.18,function()
if bD and bD.Parent then
local bP=tween(bD,{Size=UDim2.new(0,bA,0,0)},0.14,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
bP.Completed:Connect(function()
if bD and bD.Parent then
bD:Destroy()
end
end)
end
end)
end
end)
end

function aa.GetConfigData(br)
local bs={}
for bt,bu in pairs(aa.FloatingButtons)do
local bv=bu.Button
local bw=bv and bv.Position or UDim2.fromOffset(100,140)
local bx=bu.Config or{}
local by=(bx.PosX~=nil and bx.PosX)or bw.X.Offset
local bz=(bx.PosY~=nil and bx.PosY)or bw.Y.Offset
local bA=(bx.ScaleX~=nil and bx.ScaleX)or bw.X.Scale or 0
local bB=(bx.ScaleY~=nil and bx.ScaleY)or bw.Y.Scale or 0
table.insert(bs,{
Feature=bt,
Label=bx.Label or(bu.Label and bu.Label.Text)or"",
Style=bx.Style or"Standard",
Width=bx.Width or(bv and bv.Size.X.Offset)or 116,
Height=bx.Height or(bv and bv.Size.Y.Offset)or 42,
CornerRadius=bx.CornerRadius or 10,
Opacity=bx.Opacity or 88,
PosX=by,
PosY=bz,
ScaleX=bA,
ScaleY=bB
})
end

local bt=y and{
ScaleX=y.Position.X.Scale,
OffsetX=y.Position.X.Offset,
ScaleY=y.Position.Y.Scale,
OffsetY=y.Position.Y.Offset
}or nil

local bu=ab and{
ScaleX=ab.Position.X.Scale,
OffsetX=ab.Position.X.Offset,
ScaleY=ab.Position.Y.Scale,
OffsetY=ab.Position.Y.Offset
}or nil

local bv=ak and{
ScaleX=ak.Position.X.Scale,
OffsetX=ak.Position.X.Offset,
ScaleY=ak.Position.Y.Scale,
OffsetY=ak.Position.Y.Offset
}or nil

local bw=pvFrame and{
ScaleX=pvFrame.Position.X.Scale,
OffsetX=pvFrame.Position.X.Offset,
ScaleY=pvFrame.Position.Y.Scale,
OffsetY=pvFrame.Position.Y.Offset
}or nil

local bx={}
for by,bz in pairs(aa.ConfigElements)do
if bz.Type=="Keybind"then
local bA,bB=pcall(bz.Serialize)
if bA and bB~=nil then
bx[by]=bB
end
end
end
for by,bz in ipairs(aa.Keybinds)do
local bA=bz.GetKey()
if typeof(bA)=="EnumItem"then
bx[bz.Name]=bA.EnumType.Name.."."..bA.Name
end
end

local by={
AccentColor=colorToHex(o),
ToggleKey=n.Name,
ButtonsLocked=aa.ButtonsLocked,
FloatingButtons=bs,
Buttons=bs,
Keybinds=bx,
UIPositions={
Main=bt,
MobileButton=bu,
KeybindHUD=bv,
Preview=bw
},
Elements={}
}
for bz,bA in pairs(aa.ConfigElements)do
local bB,bC=pcall(bA.Serialize)
if bB and bC~=nil then
by.Elements[bz]=bC
end
end
return by
end

function aa.ApplyConfigData(br,bs)
if type(bs)~="table"then return false end
if bs.AccentColor then
local bt=hexToColor(bs.AccentColor)
if bt then
aa:SetAccentColor(bt)
end
end
if bs.ToggleKey and Enum.KeyCode[bs.ToggleKey]then
aa:SetToggleKey(Enum.KeyCode[bs.ToggleKey])
end

if type(bs.UIPositions)=="table"then
if bs.UIPositions.Main and y then
local bt=bs.UIPositions.Main
y.Position=UDim2.new(bt.ScaleX or 0.5,bt.OffsetX or 0,bt.ScaleY or 0.5,bt.OffsetY or 0)
end
if bs.UIPositions.MobileButton and ab then
local bt=bs.UIPositions.MobileButton
ab.Position=UDim2.new(bt.ScaleX or 0,bt.OffsetX or 48,bt.ScaleY or 0.5,bt.OffsetY or 0)
end
if bs.UIPositions.KeybindHUD and ak then
local bt=bs.UIPositions.KeybindHUD
ak.Position=UDim2.new(bt.ScaleX or 0,bt.OffsetX or 18,bt.ScaleY or 0.42,bt.OffsetY or 0)
end
if bs.UIPositions.Preview and pvFrame then
local bt=bs.UIPositions.Preview
pvFrame.Position=UDim2.new(bt.ScaleX or 0.5,bt.OffsetX or 0,bt.ScaleY or 0.5,bt.OffsetY or 0)
end
end

local bt=(type(bs.Elements)=="table"and bs.Elements)or bs
if type(bt)=="table"then
for bu,bv in pairs(bt)do
aa.Flags[bu]=bv
local bw=aa.ConfigElements[bu]
if bw and bw.Deserialize then
pcall(bw.Deserialize,bv)
end
end
end

if type(bs.Keybinds)=="table"then
for bu,bv in pairs(bs.Keybinds)do
local bw=aa.ConfigElements[bu]
if bw and bw.Type=="Keybind"and bw.Deserialize then
pcall(bw.Deserialize,bv)
else
for bx,by in pairs(aa.ConfigElements)do
if by.Type=="Keybind"and bu~="Keybind"and bx:find(bu,1,true)and by.Deserialize then
pcall(by.Deserialize,bv)
end
end
end
end
end

local bu=(type(bs.Buttons)=="table"and bs.Buttons)or(type(bs.FloatingButtons)=="table"and bs.FloatingButtons)
if bu then
aa:ClearFloatingButtons()
for bv,bw in ipairs(bu)do
if type(bw)=="table"and bw.Feature then
aa:CreateFloatingButton(bw)
end
end
end

if type(bs.ButtonsLocked)=="boolean"then
aa:SetButtonsLocked(bs.ButtonsLocked)
end
refreshKeybindHUD()
return true
end

function aa.ExportConfigJSON(br)
local bs,bt=pcall(function()
return f:JSONEncode(aa:GetConfigData())
end)
return bs and bt or"{}"
end

function aa.ImportConfigJSON(br,bs)
local bt,bu=pcall(function()
return f:JSONDecode(bs)
end)
if not bt or type(bu)~="table"then
return false
end
return aa:ApplyConfigData(bu)
end

function aa.SaveConfig(br,bs)
bs=tostring(bs or""):gsub("[^%w%-%_ ]",""):gsub("^%s+",""):gsub("%s+$","")
if bs==""then
return false,"Invalid config name"
end
local bt=aa:ExportConfigJSON()
aa.MemoryConfigs[bs]=bt
if h.hasFS then
local bu=false
pcall(function()
if not h.isfolder"future.club"then pcall(h.makefolder,"future.club")end
if not h.isfolder(p)then pcall(h.makefolder,p)end
h.writefile(p.."/"..bs..".json",bt)
bu=true
end)
if not bu then
pcall(function()
h.writefile("future_"..bs..".json",bt)
end)
end
end
return true,bs
end

local function forceResetPlayer()
local br=c.LocalPlayer or g
local bs=br and br.Character
local bt=bs and bs:FindFirstChildOfClass"Humanoid"
if bt and bt.Health>0 then
pcall(function()
bt.WalkSpeed=16
if bt.UseJumpPower then
bt.JumpPower=50
else
bt.JumpHeight=7.2
end
end)
end
end

function aa.LoadConfig(br,bs)
bs=tostring(bs or""):gsub("%.[jJ][sS][oO][nN]$","")
if bs==""then
return false,"No config selected"
end
local bt
if h.hasFS then
local bu={
p.."/"..bs..".json",
p.."\\"..bs..".json",
"future_"..bs..".json",
bs..".json"
}
for bv,bw in ipairs(bu)do
pcall(function()
if h.isfile(bw)then
bt=h.readfile(bw)
end
end)
if bt and bt~=""then break end
pcall(function()
bt=h.readfile(bw)
end)
if bt and bt~=""then break end
end
end
if not bt or bt==""then
bt=aa.MemoryConfigs[bs]
end
if not bt or bt==""then
return false,"Config not found"
end
forceResetPlayer()
local bu=aa:ImportConfigJSON(bt)
return bu,bu and bs or"Failed to parse config"
end

function aa.DeleteConfig(br,bs)
bs=tostring(bs or""):gsub("%.[jJ][sS][oO][nN]$","")
if bs==""then return false end
aa.MemoryConfigs[bs]=nil
if h.hasFS then
local bt={
p.."/"..bs..".json",
p.."\\"..bs..".json",
"future_"..bs..".json",
bs..".json"
}
for bu,bv in ipairs(bt)do
pcall(function()
if h.isfile(bv)then
h.delfile(bv)
end
end)
pcall(function()
h.delfile(bv)
end)
end
end
return true
end

function aa.GetConfigs(br)
local bs={}
local bt={}
local function addConfig(bu)
if bu and bu~=""and not bs[bu]then
bs[bu]=true
table.insert(bt,bu)
end
end

if h.hasFS then
pcall(function()
if h.isfolder(p)then
for bu,bv in ipairs(h.listfiles(p))do
local bw=tostring(bv):match"([^/\\]+)%.[jJ][sS][oO][nN]$"or tostring(bv):match"([^/\\]+)$"
addConfig(bw)
end
end
end)
pcall(function()
for bu,bv in ipairs(h.listfiles"")do
local bw=tostring(bv):match"future_([^/\\]+)%.[jJ][sS][oO][nN]$"
addConfig(bw)
end
end)
end
for bu,bv in pairs(aa.MemoryConfigs)do
addConfig(bu)
end
table.sort(bt)
if#bt==0 then
aa:SaveConfig"default"
table.insert(bt,"default")
end
return bt
end

local function filterModules(br,bs)
if not br then return end
bs=string.lower(tostring(bs or""))
for bt,bu in ipairs(br.Modules)do
if bs==""then
bu.Card.Visible=true
else
local bv=string.find(string.lower(tostring(bu.Name or"")),bs,1,true)~=nil
local bw=string.find(string.lower(tostring(bu.Description or"")),bs,1,true)~=nil
bu.Card.Visible=bv or bw
end
end
end

N:GetPropertyChangedSignal"Text":Connect(function()
aa.SearchQuery=N.Text
if aa.ActiveTab then
filterModules(aa.ActiveTab,aa.SearchQuery)
end
end)

local br
local bs
local bt
local bu=0
local bv=false
local bw=false
local bx=0
local by=0
local bz=0

local function getScrollTargetAt(bA,bB)
if not y.Visible then return nil end

if aa.OpenDropdownOptions and aa.OpenDropdownOptions.Visible then
local bC=aa.OpenDropdownOptions
local bD=bC.AbsolutePosition
local bE=bC.AbsoluteSize
if bA>=bD.X and bA<=bD.X+bE.X and bB>=bD.Y and bB<=bD.Y+bE.Y then
return bC
end
end

local bC=aa.ActiveTab and aa.ActiveTab.Page
if bC and bC.Visible then
local bD=bC.AbsolutePosition
local bE=bC.AbsoluteSize
if bA>=bD.X and bA<=bD.X+bE.X and bB>=bD.Y and bB<=bD.Y+bE.Y then
return bC
end
end

if H and H.Visible then
local bD=H.AbsolutePosition
local bE=H.AbsoluteSize
if bA>=bD.X and bA<=bD.X+bE.X and bB>=bD.Y and bB<=bD.Y+bE.Y then
return H
end
end

if bn and bn.Visible and at and at.Visible then
local bD=bn.AbsolutePosition
local bE=bn.AbsoluteSize
if bA>=bD.X and bA<=bD.X+bE.X and bB>=bD.Y and bB<=bD.Y+bE.Y then
return bn
end
end

return nil
end

b.InputBegan:Connect(function(bA,bB)
if bA.UserInputType~=Enum.UserInputType.Touch then return end
if not y.Visible then return end

local bC=getScrollTargetAt(bA.Position.X,bA.Position.Y)
if bC then
br=bC
bs=bA.Position.Y
bt=bA.Position.X
bu=bC.CanvasPosition.Y
by=bA.Position.Y
bz=tick()
bx=0
bv=false
bw=false
end
end)

b.InputChanged:Connect(function(bA)
if bA.UserInputType~=Enum.UserInputType.Touch then return end
if not br or not bs then return end
if not br.Visible or not y.Visible then return end

local bB=bA.Position.X-bt
local bC=bs-bA.Position.Y
local bD=math.abs(bB)
local bE=math.abs(bC)

if not bv then
if bE>5 and bE>=bD then
bv=true
bw=true
elseif bD>8 and bD>bE then
br=nil
return
end
end

if bv then
bw=true
local bF=(z and z.Scale)or 1
local bG=bC/bF
local bH=math.max(0,br.AbsoluteCanvasSize.Y-br.AbsoluteWindowSize.Y)
br.CanvasPosition=Vector2.new(0,math.clamp(bu+bG,0,bH))

local bI=tick()
local bJ=bI-bz
if bJ>0 then
local bK=(by-bA.Position.Y)/bJ
bx=bx*0.4+bK*0.6
by=bA.Position.Y
bz=bI
end
end
end)

b.InputEnded:Connect(function(bA)
if bA.UserInputType~=Enum.UserInputType.Touch then return end
local bB=br
local bC=bv
local bD=bx
local bE=(z and z.Scale)or 1

br=nil
bs=nil
bt=nil
bv=false

if bC then
task.delay(0.12,function()
bw=false
end)

if bB and bB.Parent and math.abs(bD)>60 then
task.spawn(function()
local bF=bD/bE
while math.abs(bF)>15 and bB and bB.Parent and not br do
local bG=e.RenderStepped:Wait()
bF=bF*math.exp(-6*bG)
local bH=math.max(0,bB.AbsoluteCanvasSize.Y-bB.AbsoluteWindowSize.Y)
local bI=math.clamp(bB.CanvasPosition.Y+bF*bG,0,bH)
bB.CanvasPosition=Vector2.new(0,bI)
if bI<=0 or bI>=bH then
break
end
end
end)
end
else
bw=false
end
end)

function aa.CreateTab(bA,bB)
bB=bB or{}
local bC=bB.Name or"Tab"
local bD=resolveIcon(bB.Icon or bC)

local bE=Instance.new"TextButton"
bE.Name="Tab_"..bC
bE.Size=UDim2.new(1,0,0,36)
bE.BackgroundColor3=o
bE.BackgroundTransparency=1
bE.BorderSizePixel=0
bE.AutoButtonColor=false
bE.Text=""
bE.ZIndex=2
bE.Parent=H

local bF=Instance.new"UICorner"
bF.CornerRadius=UDim.new(0,18)
bF.Parent=bE

local bG=Instance.new"ImageLabel"
bG.Name="Icon"
bG.Size=UDim2.new(0,16,0,16)
bG.Position=UDim2.new(0,14,0.5,0)
bG.AnchorPoint=Vector2.new(0,0.5)
bG.BackgroundTransparency=1
bG.Image=bD
bG.ImageColor3=Color3.fromRGB(125,125,135)
bG.ZIndex=2
bG.Parent=bE

local bH=Instance.new"TextLabel"
bH.Name="Label"
bH.Size=UDim2.new(1,-44,1,0)
bH.Position=UDim2.new(0,38,0,0)
bH.BackgroundTransparency=1
bH.Font=Enum.Font.GothamBold
bH.TextSize=13
bH.TextColor3=Color3.fromRGB(125,125,135)
bH.TextXAlignment=Enum.TextXAlignment.Left
bH.Text=bC
bH.ZIndex=2
bH.Parent=bE

local bI=Instance.new"ScrollingFrame"
bI.Name="Page_"..bC
bI.Size=UDim2.new(1,0,1,0)
bI.Position=UDim2.new(0,0,0,0)
bI.BackgroundTransparency=1
bI.BorderSizePixel=0
bI.ScrollBarThickness=6
bI.ScrollBarImageColor3=Color3.fromRGB(55,55,65)
bI.ScrollingDirection=Enum.ScrollingDirection.Y
bI.ElasticBehavior=Enum.ElasticBehavior.Always
bI.ScrollingEnabled=true
bI.Active=true
bI.AutomaticCanvasSize=Enum.AutomaticSize.None
bI.CanvasSize=UDim2.new(0,0,0,0)
bI.Visible=false
bI.ClipsDescendants=true
bI.Parent=X

local bJ=Instance.new"UIListLayout"
bJ.SortOrder=Enum.SortOrder.LayoutOrder
bJ.Padding=UDim.new(0,10)
bJ.Parent=bI

local function syncCanvas()
local bK=bJ.AbsoluteContentSize.Y
bI.CanvasSize=UDim2.new(0,0,0,bK+40)
end
bJ:GetPropertyChangedSignal"AbsoluteContentSize":Connect(syncCanvas)

local function hookTouchDescendant(bK)
if bK:IsA"GuiObject"then
bK.InputBegan:Connect(function(bL)
if bL.UserInputType==Enum.UserInputType.Touch and bI.Visible and y.Visible then
if not bv then
br=bI
bs=bL.Position.Y
bt=bL.Position.X
bu=bI.CanvasPosition.Y
by=bL.Position.Y
bz=tick()
bx=0
end
end
end)
end
end

bI.DescendantAdded:Connect(hookTouchDescendant)
for bK,bL in ipairs(bI:GetDescendants())do
hookTouchDescendant(bL)
end

local bK=Instance.new"UIPadding"
bK.PaddingTop=UDim.new(0,4)
bK.PaddingBottom=UDim.new(0,14)
bK.PaddingLeft=UDim.new(0,2)
bK.PaddingRight=UDim.new(0,14)
bK.Parent=bI

local bL={
Name=bC,
Button=bE,
Page=bI,
Icon=bG,
Label=bH,
Modules={}
}

registerThemeRefresher(function(bM)
bE.BackgroundColor3=bM
end)

local function selectTab()
for bM,bN in ipairs(aa.Tabs)do
if bN==bL then
tween(bN.Button,{BackgroundTransparency=0},0.18)
tween(bN.Icon,{ImageColor3=Color3.fromRGB(18,18,22)},0.18)
tween(bN.Label,{TextColor3=Color3.fromRGB(18,18,22)},0.18)
bN.Page.Visible=true
else
tween(bN.Button,{BackgroundTransparency=1},0.18)
tween(bN.Icon,{ImageColor3=Color3.fromRGB(125,125,135)},0.18)
tween(bN.Label,{TextColor3=Color3.fromRGB(125,125,135)},0.18)
bN.Page.Visible=false
end
end
aa.ActiveTab=bL
filterModules(bL,aa.SearchQuery)
local bM=string.lower(bC)
if bM=="visuals"or bM=="visual"then
aa:SetPreviewMode"ESP"
at.Visible=isPreviewAllowedForActiveTab()
elseif bM=="settings"then
aa:SetPreviewMode"Buttons"
at.Visible=isPreviewAllowedForActiveTab()
else
at.Visible=false
end
end

bE.MouseButton1Click:Connect(function()
if bw then return end
selectTab()
end)

bE.MouseEnter:Connect(function()
if aa.ActiveTab~=bL then
tween(bE,{BackgroundTransparency=0.88},0.15)
tween(bG,{ImageColor3=Color3.fromRGB(185,185,195)},0.15)
tween(bH,{TextColor3=Color3.fromRGB(185,185,195)},0.15)
end
end)

bE.MouseLeave:Connect(function()
if aa.ActiveTab~=bL then
tween(bE,{BackgroundTransparency=1},0.15)
tween(bG,{ImageColor3=Color3.fromRGB(125,125,135)},0.15)
tween(bH,{TextColor3=Color3.fromRGB(125,125,135)},0.15)
end
end)

function bL.CreateModule(bM,bN)
bN=bN or{}
local bO=bN.Name or"Module"
local bP=bN.Description or""
local bQ=bN.Default or false
local bR=bN.Flag or("Module_"..bC.."_"..bO)
local bS=bN.Callback or function()end

local bT=bP~=""
local bU=bT and 58 or 44

local bV=Instance.new"Frame"
bV.Name="Module_"..bO
bV.Size=UDim2.new(1,0,0,bU)
bV.BackgroundColor3=Color3.fromRGB(24,24,28)
bV.BorderSizePixel=0
bV.ClipsDescendants=true
bV.Parent=bI

local bW=Instance.new"UICorner"
bW.CornerRadius=UDim.new(0,10)
bW.Parent=bV

local bX=Instance.new"UIStroke"
bX.Color=Color3.fromRGB(33,33,38)
bX.Thickness=1
bX.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
bX.Parent=bV

local bY=Instance.new"Frame"
bY.Name="Header"
bY.Size=UDim2.new(1,0,0,bU)
bY.BackgroundTransparency=1
bY.Parent=bV

local bZ=Instance.new"TextLabel"
bZ.Name="Title"
bZ.Size=UDim2.new(1,-120,0,18)
bZ.Position=bT and UDim2.new(0,16,0,10)or UDim2.new(0,16,0.5,-9)
bZ.BackgroundTransparency=1
bZ.Font=Enum.Font.GothamBold
bZ.TextSize=13
bZ.TextColor3=bQ and o or Color3.fromRGB(245,245,250)
bZ.TextXAlignment=Enum.TextXAlignment.Left
bZ.Text=bO
bZ.Parent=bY

if bT then
local b_=Instance.new"TextLabel"
b_.Name="Description"
b_.Size=UDim2.new(1,-120,0,14)
b_.Position=UDim2.new(0,16,0,30)
b_.BackgroundTransparency=1
b_.Font=Enum.Font.Gotham
b_.TextSize=11
b_.TextColor3=Color3.fromRGB(115,115,125)
b_.TextXAlignment=Enum.TextXAlignment.Left
b_.Text=bP
b_.Parent=bY
end

local b_=Instance.new"Frame"
b_.Name="Controls"
b_.Size=UDim2.new(0,80,0,24)
b_.Position=UDim2.new(1,-16,0.5,0)
b_.AnchorPoint=Vector2.new(1,0.5)
b_.BackgroundTransparency=1
b_.Parent=bY

local b0=Instance.new"ImageButton"
b0.Name="Gear"
b0.Size=UDim2.new(0,20,0,20)
b0.Position=UDim2.new(0,0,0.5,0)
b0.AnchorPoint=Vector2.new(0,0.5)
b0.BackgroundTransparency=1
b0.Image=i.gear
b0.ImageColor3=Color3.fromRGB(110,110,120)
b0.Parent=b_

local b1=Instance.new"TextButton"
b1.Name="Toggle"
b1.Size=UDim2.new(0,44,0,24)
b1.Position=UDim2.new(0,34,0.5,0)
b1.AnchorPoint=Vector2.new(0,0.5)
b1.BackgroundColor3=bQ and o or Color3.fromRGB(38,38,44)
b1.BorderSizePixel=0
b1.AutoButtonColor=false
b1.Text=""
b1.Parent=b_

local b2=Instance.new"UICorner"
b2.CornerRadius=UDim.new(1,0)
b2.Parent=b1

local b3=Instance.new"Frame"
b3.Name="Knob"
b3.Size=UDim2.new(0,18,0,18)
b3.Position=bQ and UDim2.new(1,-21,0.5,0)or UDim2.new(0,3,0.5,0)
b3.AnchorPoint=Vector2.new(0,0.5)
b3.BackgroundColor3=bQ and Color3.fromRGB(22,22,26)or Color3.fromRGB(68,68,76)
b3.BorderSizePixel=0
b3.Parent=b1

local b4=Instance.new"UICorner"
b4.CornerRadius=UDim.new(1,0)
b4.Parent=b3

local b5=Instance.new"Frame"
b5.Name="SettingsTray"
b5.Position=UDim2.new(0,0,0,bU)
b5.Size=UDim2.new(1,0,0,0)
b5.BackgroundTransparency=1
b5.Visible=false
b5.Parent=bV

local b6=Instance.new"Frame"
b6.Name="Divider"
b6.Size=UDim2.new(1,-32,0,1)
b6.Position=UDim2.new(0,16,0,0)
b6.BackgroundColor3=Color3.fromRGB(34,34,40)
b6.BorderSizePixel=0
b6.Parent=b5

local b7=Instance.new"Frame"
b7.Name="List"
b7.Size=UDim2.new(1,0,0,0)
b7.Position=UDim2.new(0,0,0,8)
b7.BackgroundTransparency=1
b7.Parent=b5

local b8=Instance.new"UIListLayout"
b8.SortOrder=Enum.SortOrder.LayoutOrder
b8.Padding=UDim.new(0,8)
b8.Parent=b7

local b9=Instance.new"UIPadding"
b9.PaddingLeft=UDim.new(0,18)
b9.PaddingRight=UDim.new(0,18)
b9.PaddingTop=UDim.new(0,4)
b9.PaddingBottom=UDim.new(0,14)
b9.Parent=b7



local ca=false
local cb={
Name=bO,
Description=bP,
Enabled=bQ,
Flag=bR,
Card=bV,
Elements={}
}

aa.Flags[bR]=bQ

local function updateTraySize()
if ca then
local cc=b8.AbsoluteContentSize.Y+20
b5.Size=UDim2.new(1,0,0,cc)
b7.Size=UDim2.new(1,0,0,b8.AbsoluteContentSize.Y+12)
tween(bV,{Size=UDim2.new(1,0,0,bU+cc)},0.18)
else
local cc=tween(bV,{Size=UDim2.new(1,0,0,bU)},0.18)
cc.Completed:Connect(function()
if not ca then
b5.Visible=false
end
syncCanvas()
end)
end
task.defer(syncCanvas)
task.delay(0.2,syncCanvas)
end

b8:GetPropertyChangedSignal"AbsoluteContentSize":Connect(function()
if ca then
updateTraySize()
end
syncCanvas()
end)

local function setToggleState(cc,cd)
cc=cc==true
cb.Enabled=cc
aa.Flags[bR]=cc
if cc then
tween(b1,{BackgroundColor3=o},0.2)
tween(b3,{
Position=UDim2.new(1,-21,0.5,0),
BackgroundColor3=Color3.fromRGB(22,22,26)
},0.2)
tween(bZ,{TextColor3=o},0.2)
else
tween(b1,{BackgroundColor3=Color3.fromRGB(38,38,44)},0.2)
tween(b3,{
Position=UDim2.new(0,3,0.5,0),
BackgroundColor3=Color3.fromRGB(68,68,76)
},0.2)
tween(bZ,{TextColor3=Color3.fromRGB(245,245,250)},0.2)
end
refreshKeybindHUD()
if aa.FloatingButtons[bO]and aa.FloatingButtons[bO].Refresh then
pcall(aa.FloatingButtons[bO].Refresh)
end
if aa.ButtonDraft and aa.ButtonDraft.Feature==bO then
pcall(refreshButtonPreviewWidget)
end
if not cd then
task.spawn(function()
pcall(bS,cc)
end)
end
end

registerThemeRefresher(function(cc)
if cb.Enabled then
b1.BackgroundColor3=cc
bZ.TextColor3=cc
end
if ca then
b0.ImageColor3=cc
end
end)

aa.ConfigElements[bR]={
Type="Module",
Serialize=function()
return cb.Enabled
end,
Deserialize=function(cc)
if cc~=nil then
local cd=(cc==true or cc=="true"or cc==1)
setToggleState(cd,false)
end
end
}

b1.MouseButton1Click:Connect(function()
if bw then return end
setToggleState(not cb.Enabled)
end)

b0.MouseButton1Click:Connect(function()
if bw then return end
ca=not ca
if ca then
b5.Visible=true
tween(b0,{Rotation=90,ImageColor3=o},0.2)
updateTraySize()
else
tween(b0,{Rotation=0,ImageColor3=Color3.fromRGB(110,110,120)},0.2)
updateTraySize()
end
end)

b0.MouseEnter:Connect(function()
if not ca then
tween(b0,{ImageColor3=Color3.fromRGB(190,190,200)},0.15)
end
end)

b0.MouseLeave:Connect(function()
if not ca then
tween(b0,{ImageColor3=Color3.fromRGB(110,110,120)},0.15)
end
end)

function cb.Set(cc,cd)
setToggleState(cd)
end

function cb.Get(cc)
return cb.Enabled
end

function cb.CreateSlider(cc,cd)
cd=cd or{}
local ce=cd.Name or"Slider"
local cf=cd.Min or 0
local cg=cd.Max or 100
local ch=cd.Default or cf
local ci=cd.Precision or 1
local cj=cd.Unit or""
local ck=cd.Flag or(bR.."_"..ce)
local cl=cd.Callback or function()end

local cm=math.clamp(ch,cf,cg)
aa.Flags[ck]=cm

local cn=Instance.new"Frame"
cn.Name="Slider_"..ce
cn.Size=UDim2.new(1,0,0,42)
cn.BackgroundColor3=Color3.fromRGB(19,19,22)
cn.BorderSizePixel=0
cn.Parent=b7

local co=Instance.new"UICorner"
co.CornerRadius=UDim.new(0,8)
co.Parent=cn

local cp=Instance.new"UIStroke"
cp.Color=Color3.fromRGB(30,30,35)
cp.Thickness=1
cp.Parent=cn

local cq=Instance.new"TextLabel"
cq.Name="Label"
cq.Size=UDim2.new(1,-80,0,16)
cq.Position=UDim2.new(0,12,0,7)
cq.BackgroundTransparency=1
cq.Font=Enum.Font.Gotham
cq.TextSize=12
cq.TextColor3=Color3.fromRGB(200,200,210)
cq.TextXAlignment=Enum.TextXAlignment.Left
cq.Text=ce
cq.Parent=cn

local cr=Instance.new"TextLabel"
cr.Name="Value"
cr.Size=UDim2.new(0,70,0,16)
cr.Position=UDim2.new(1,-12,0,7)
cr.AnchorPoint=Vector2.new(1,0)
cr.BackgroundTransparency=1
cr.Font=Enum.Font.GothamBold
cr.TextSize=12
cr.TextColor3=o
cr.TextXAlignment=Enum.TextXAlignment.Right
cr.Text=tostring(cm)..cj
cr.Parent=cn

local cs=Instance.new"TextButton"
cs.Name="Track"
cs.Size=UDim2.new(1,-24,0,6)
cs.Position=UDim2.new(0,12,0,27)
cs.BackgroundColor3=Color3.fromRGB(32,32,38)
cs.BorderSizePixel=0
cs.AutoButtonColor=false
cs.Text=""
cs.Parent=cn

local ct=Instance.new"UICorner"
ct.CornerRadius=UDim.new(1,0)
ct.Parent=cs

local cu=Instance.new"Frame"
cu.Name="Fill"
local cv=(cg>cf)and math.clamp((cm-cf)/(cg-cf),0,1)or 0
cu.Size=UDim2.new(cv,0,1,0)
cu.BackgroundColor3=o
cu.BorderSizePixel=0
cu.Parent=cs

local cw=Instance.new"UICorner"
cw.CornerRadius=UDim.new(1,0)
cw.Parent=cu

local cx=Instance.new"Frame"
cx.Name="Knob"
cx.Size=UDim2.new(0,12,0,12)
cx.Position=UDim2.new(1,0,0.5,0)
cx.AnchorPoint=Vector2.new(0.5,0.5)
cx.BackgroundColor3=Color3.fromRGB(250,250,255)
cx.BorderSizePixel=0
cx.Parent=cu

local cy=Instance.new"UICorner"
cy.CornerRadius=UDim.new(1,0)
cy.Parent=cx

registerThemeRefresher(function(cz)
cr.TextColor3=cz
cu.BackgroundColor3=cz
end)

local cz=false

local function applyValue(cA,cB)
cA=tonumber(cA)or cf

local cC=ci
local cD=0

if ci>=1 and(cg-cf)<ci then
cD=math.floor(ci)
cC=10^(-cD)
elseif ci<1 then
cD=math.max(1,math.floor(-math.log10(ci)+0.5))
cC=ci
else
cC=ci
cD=0
end

if cC>0 then
cA=math.floor(cA/cC+0.5)*cC
end

if cD>0 then
cA=tonumber(string.format("%."..tostring(cD).."f",cA))or cA
end

cA=math.clamp(cA,cf,cg)

cm=cA
aa.Flags[ck]=cA

local cE=cg-cf
local cF=cE>0 and math.clamp((cA-cf)/cE,0,1)or 0
cu.Size=UDim2.new(cF,0,1,0)

local cG
if cD>0 then
cG=string.format("%."..tostring(cD).."f",cA)
else
cG=tostring(math.floor(cA+0.5))
end
cr.Text=cG..cj

if not cB then
task.spawn(function()
pcall(cl,cA)
end)
end
end

applyValue(cm,true)

aa.ConfigElements[ck]={
Type="Slider",
Serialize=function()
return cm
end,
Deserialize=function(cA)
local cB=tonumber(cA)
if cB~=nil then
applyValue(cB,false)
end
end
}

local function updateFromInput(cA)
if bv then return end
local cB=cs.AbsoluteSize.X
if cB<=0 then return end
local cC=cs.AbsolutePosition.X
local cD=(cA and cA.Position and cA.Position.X)or b:GetMouseLocation().X
if cA and(cA.UserInputType==Enum.UserInputType.MouseMovement or cA.UserInputType==Enum.UserInputType.MouseButton1)then
cD=b:GetMouseLocation().X
end
local cE=math.clamp((cD-cC)/cB,0,1)
local cF=cf+(cg-cf)*cE
applyValue(cF)
end

cs.InputBegan:Connect(function(cA)
if cA.UserInputType==Enum.UserInputType.MouseButton1 or cA.UserInputType==Enum.UserInputType.Touch then
cz=true
updateFromInput(cA)
end
end)

cn.InputBegan:Connect(function(cA)
if cA.UserInputType==Enum.UserInputType.MouseButton1 or cA.UserInputType==Enum.UserInputType.Touch then
if cA.Position.Y>=cs.AbsolutePosition.Y-8 and cA.Position.Y<=cs.AbsolutePosition.Y+14 then
cz=true
updateFromInput(cA)
end
end
end)

b.InputChanged:Connect(function(cA)
if cz and(cA.UserInputType==Enum.UserInputType.MouseMovement or cA.UserInputType==Enum.UserInputType.Touch)then
if bv then
cz=false
return
end
updateFromInput(cA)
end
end)

b.InputEnded:Connect(function(cA)
if cA.UserInputType==Enum.UserInputType.MouseButton1 or cA.UserInputType==Enum.UserInputType.Touch then
cz=false
end
end)

local cA={}
function cA.Set(cB,cC)
applyValue(cC)
end
function cA.Get(cB)
return cm
end
return cA
end

function cb.CreateToggle(cc,cd)
cd=cd or{}
local ce=cd.Name or"Toggle"
local cf=cd.Default or false
local cg=cd.Flag or(bR.."_"..ce)
local ch=cd.Callback or function()end

aa.Flags[cg]=cf

local ci=Instance.new"Frame"
ci.Name="Toggle_"..ce
ci.Size=UDim2.new(1,0,0,34)
ci.BackgroundColor3=Color3.fromRGB(19,19,22)
ci.BorderSizePixel=0
ci.Parent=b7

local cj=Instance.new"UICorner"
cj.CornerRadius=UDim.new(0,8)
cj.Parent=ci

local ck=Instance.new"UIStroke"
ck.Color=Color3.fromRGB(30,30,35)
ck.Thickness=1
ck.Parent=ci

local cl=Instance.new"TextLabel"
cl.Name="Label"
cl.Size=UDim2.new(1,-60,1,0)
cl.Position=UDim2.new(0,12,0,0)
cl.BackgroundTransparency=1
cl.Font=Enum.Font.Gotham
cl.TextSize=12
cl.TextColor3=Color3.fromRGB(200,200,210)
cl.TextXAlignment=Enum.TextXAlignment.Left
cl.Text=ce
cl.Parent=ci

local cm=Instance.new"TextButton"
cm.Name="SubTrack"
cm.Size=UDim2.new(0,36,0,20)
cm.Position=UDim2.new(1,-12,0.5,0)
cm.AnchorPoint=Vector2.new(1,0.5)
cm.BackgroundColor3=cf and o or Color3.fromRGB(38,38,44)
cm.BorderSizePixel=0
cm.AutoButtonColor=false
cm.Text=""
cm.Parent=ci

local cn=Instance.new"UICorner"
cn.CornerRadius=UDim.new(1,0)
cn.Parent=cm

local co=Instance.new"Frame"
co.Name="SubKnob"
co.Size=UDim2.new(0,14,0,14)
co.Position=cf and UDim2.new(1,-17,0.5,0)or UDim2.new(0,3,0.5,0)
co.AnchorPoint=Vector2.new(0,0.5)
co.BackgroundColor3=cf and Color3.fromRGB(22,22,26)or Color3.fromRGB(68,68,76)
co.BorderSizePixel=0
co.Parent=cm

local cp=Instance.new"UICorner"
cp.CornerRadius=UDim.new(1,0)
cp.Parent=co

registerThemeRefresher(function(cq)
if cf then
cm.BackgroundColor3=cq
end
end)

local function setSub(cq,cr)
cq=cq==true
cf=cq
aa.Flags[cg]=cq
if cq then
tween(cm,{BackgroundColor3=o},0.2)
tween(co,{
Position=UDim2.new(1,-17,0.5,0),
BackgroundColor3=Color3.fromRGB(22,22,26)
},0.2)
else
tween(cm,{BackgroundColor3=Color3.fromRGB(38,38,44)},0.2)
tween(co,{
Position=UDim2.new(0,3,0.5,0),
BackgroundColor3=Color3.fromRGB(68,68,76)
},0.2)
end
if not cr then
task.spawn(function()
pcall(ch,cq)
end)
end
end

aa.ConfigElements[cg]={
Type="Toggle",
Serialize=function()
return cf
end,
Deserialize=function(cq)
if cq~=nil then
local cr=(cq==true or cq=="true"or cq==1)
setSub(cr,false)
end
end
}

cm.MouseButton1Click:Connect(function()
if bw then return end
setSub(not cf)
end)

local cq={}
function cq.Set(cr,cs)
setSub(cs)
end
function cq.Get(cr)
return cf
end
return cq
end

function cb.CreateDropdown(cc,cd)
cd=cd or{}
local ce=cd.Name or"Dropdown"
local cf=cd.Options or{}
local cg=cd.Multi==true
local ch=cd.Default
local ci=cd.Flag or(bR.."_"..ce)
local cj=cd.Callback or function()end

local ck
if cg then
ck={}
if type(ch)=="table"then
for cl,cm in pairs(ch)do
if type(cl)=="number"then
ck[tostring(cm)]=true
elseif cm==true then
ck[tostring(cl)]=true
end
end
elseif type(ch)=="string"and ch~=""then
ck[ch]=true
end
else
ck=ch or cf[1]or""
end

aa.Flags[ci]=ck
local cl=false

local cm=Instance.new"Frame"
cm.Name="Dropdown_"..ce
cm.Size=UDim2.new(1,0,0,36)
cm.BackgroundColor3=Color3.fromRGB(19,19,22)
cm.BorderSizePixel=0
cm.ClipsDescendants=true
cm.Parent=b7

local cn=Instance.new"UICorner"
cn.CornerRadius=UDim.new(0,8)
cn.Parent=cm

local co=Instance.new"UIStroke"
co.Color=Color3.fromRGB(30,30,35)
co.Thickness=1
co.Parent=cm

local cp=Instance.new"Frame"
cp.Name="Header"
cp.Size=UDim2.new(1,0,0,36)
cp.BackgroundTransparency=1
cp.Parent=cm

local cq=Instance.new"TextLabel"
cq.Name="Label"
cq.Size=UDim2.new(0.48,0,1,0)
cq.Position=UDim2.new(0,12,0,0)
cq.BackgroundTransparency=1
cq.Font=Enum.Font.Gotham
cq.TextSize=12
cq.TextColor3=Color3.fromRGB(200,200,210)
cq.TextXAlignment=Enum.TextXAlignment.Left
cq.Text=ce
cq.Parent=cp

local cr=Instance.new"TextButton"
cr.Name="Selector"
cr.Size=UDim2.new(0.48,-12,0,26)
cr.Position=UDim2.new(1,-12,0.5,0)
cr.AnchorPoint=Vector2.new(1,0.5)
cr.BackgroundColor3=Color3.fromRGB(26,26,31)
cr.BorderSizePixel=0
cr.AutoButtonColor=false
cr.Text=""
cr.Parent=cp

local cs=Instance.new"UICorner"
cs.CornerRadius=UDim.new(0,6)
cs.Parent=cr

local ct=Instance.new"UIStroke"
ct.Color=Color3.fromRGB(36,36,42)
ct.Thickness=1
ct.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
ct.Parent=cr

local function getDisplayString()
if not cg then
return tostring(ck~=""and ck or"None")
end
local cu={}
for cv,cw in ipairs(cf)do
if ck[tostring(cw)]then
table.insert(cu,tostring(cw))
end
end
if#cu==0 then
return"None"
end
return table.concat(cu,", ")
end

local cu=Instance.new"TextLabel"
cu.Name="Text"
cu.Size=UDim2.new(1,-28,1,0)
cu.Position=UDim2.new(0,8,0,0)
cu.BackgroundTransparency=1
cu.Font=Enum.Font.GothamMedium
cu.TextSize=11
cu.TextColor3=Color3.fromRGB(240,240,245)
cu.TextXAlignment=Enum.TextXAlignment.Left
cu.TextTruncate=Enum.TextTruncate.AtEnd
cu.Text=getDisplayString()
cu.Parent=cr

local cv=Instance.new"ImageLabel"
cv.Name="Chevron"
cv.Size=UDim2.new(0,14,0,14)
cv.Position=UDim2.new(1,-8,0.5,0)
cv.AnchorPoint=Vector2.new(1,0.5)
cv.BackgroundTransparency=1
cv.Image=i.chevron
cv.ImageColor3=Color3.fromRGB(120,120,130)
cv.Parent=cr

local cw=Instance.new"ScrollingFrame"
cw.Name="Options"
cw.Size=UDim2.new(1,-24,0,0)
cw.Position=UDim2.new(0,12,0,38)
cw.BackgroundTransparency=1
cw.BorderSizePixel=0
cw.ScrollBarThickness=4
cw.ScrollBarImageColor3=Color3.fromRGB(55,55,65)
cw.ScrollingDirection=Enum.ScrollingDirection.Y
cw.ElasticBehavior=Enum.ElasticBehavior.Always
cw.Active=true
cw.CanvasSize=UDim2.new(0,0,0,0)
cw.AutomaticCanvasSize=Enum.AutomaticSize.Y
cw.Parent=cm

local cx=Instance.new"UIListLayout"
cx.SortOrder=Enum.SortOrder.LayoutOrder
cx.Padding=UDim.new(0,4)
cx.Parent=cw

cx:GetPropertyChangedSignal"AbsoluteContentSize":Connect(function()
cw.CanvasSize=UDim2.new(0,0,0,cx.AbsoluteContentSize.Y+8)
end)

local function updateDropdownSize()
if cl then
aa.OpenDropdownOptions=cw
local cy=math.max(1,#cf)*28
local cz=math.min(cy,140)
cw.Size=UDim2.new(1,-24,0,cz)
tween(cm,{Size=UDim2.new(1,0,0,44+cz)},0.2)
tween(cv,{Rotation=180},0.2)
else
if aa.OpenDropdownOptions==cw then
aa.OpenDropdownOptions=nil
end
tween(cm,{Size=UDim2.new(1,0,0,36)},0.2)
tween(cv,{Rotation=0},0.2)
end
task.delay(0.22,updateTraySize)
end

local function isOptSelected(cy)
if cg then
return ck[tostring(cy)]==true
else
return ck==cy
end
end

local function refreshOptionColors()
cu.Text=getDisplayString()
for cy,cz in ipairs(cw:GetChildren())do
if cz:IsA"TextButton"then
local cA=cz:GetAttribute"OptionValue"
local cB=isOptSelected(cA)
cz.TextColor3=cB and o or Color3.fromRGB(150,150,160)
end
end
end

registerThemeRefresher(function()
refreshOptionColors()
end)

local function selectOption(cy,cz)
if cg then
if type(cy)=="table"then
ck={}
for cA,cB in pairs(cy)do
if type(cA)=="number"then
ck[tostring(cB)]=true
elseif cB==true then
ck[tostring(cA)]=true
end
end
else
local cA=tostring(cy)
ck[cA]=not ck[cA]
end
else
ck=cy
end
aa.Flags[ci]=ck
refreshOptionColors()
if not cz then
task.spawn(function()
pcall(cj,ck)
end)
end
end

local function renderOptions()
for cy,cz in ipairs(cw:GetChildren())do
if cz:IsA"TextButton"then
cz:Destroy()
end
end
for cy,cz in ipairs(cf)do
local cA=Instance.new"TextButton"
cA.Name="Opt_"..tostring(cz)
cA:SetAttribute("OptionValue",tostring(cz))
cA.Size=UDim2.new(1,0,0,24)
cA.BackgroundColor3=Color3.fromRGB(24,24,28)
cA.BorderSizePixel=0
cA.Font=Enum.Font.Gotham
cA.TextSize=11
cA.TextColor3=isOptSelected(cz)and o or Color3.fromRGB(150,150,160)
cA.TextXAlignment=Enum.TextXAlignment.Left
cA.Text="  "..tostring(cz)
cA.AutoButtonColor=false
cA.Parent=cw

local cB=Instance.new"UICorner"
cB.CornerRadius=UDim.new(0,5)
cB.Parent=cA

cA.MouseButton1Click:Connect(function()
if bw then return end
selectOption(cz)
if not cg then
cl=false
updateDropdownSize()
end
end)

cA.MouseEnter:Connect(function()
if not isOptSelected(cz)then
tween(cA,{TextColor3=Color3.fromRGB(230,230,235)},0.15)
end
end)

cA.MouseLeave:Connect(function()
if not isOptSelected(cz)then
tween(cA,{TextColor3=Color3.fromRGB(150,150,160)},0.15)
end
end)
end
end

renderOptions()

aa.ConfigElements[ci]={
Type="Dropdown",
Serialize=function()
if cg then
local cy={}
for cz,cA in pairs(ck)do
if cA then table.insert(cy,cz)end
end
return cy
end
return ck
end,
Deserialize=function(cy)
if cy~=nil then
selectOption(cy,false)
end
end
}

cr.MouseButton1Click:Connect(function()
if bw then return end
cl=not cl
updateDropdownSize()
end)

local cy={}
function cy.Set(cz,cA)
selectOption(cA)
end
function cy.Refresh(cz,cA,cB)
cf=cA or{}
if not cB and not cg then
if not table.find(cf,ck)then
ck=cf[1]or""
end
end
renderOptions()
refreshOptionColors()
if cl then
updateDropdownSize()
end
end
function cy.Get(cz)
return ck
end
return cy
end

function cb.CreateKeybind(cc,cd)
cd=cd or{}
local ce=cd.Name or"Keybind"
local cf=cd.Default or Enum.KeyCode.Unknown
local cg=cd.Mode or"Toggle"
local ch=cd.BindModule
if ch==nil then
ch=true
end
local ci=cd.Flag or(bR.."_"..ce)
local cj=cd.Callback or function()end

local function formatKeyText(ck)
if not ck or ck==Enum.KeyCode.Unknown then return"[ NONE ]"end
if typeof(ck)=="EnumItem"then
if ck.EnumType==Enum.UserInputType then
if ck==Enum.UserInputType.MouseButton1 then return"[ M1 ]"
elseif ck==Enum.UserInputType.MouseButton2 then return"[ M2 ]"
elseif ck==Enum.UserInputType.MouseButton3 then return"[ M3 ]"
end
return"[ "..ck.Name.." ]"
elseif ck.EnumType==Enum.KeyCode then
local cl=ck.Name
if cl:sub(1,6)=="Button"then return"[ "..cl:sub(7).." ]"end
return"[ "..cl.." ]"
end
end
return"[ NONE ]"
end

local function matchesKey(ck,cl)
if not cl or cl==Enum.KeyCode.Unknown then return false end
if typeof(cl)=="EnumItem"then
if cl.EnumType==Enum.KeyCode then
return ck.KeyCode==cl
elseif cl.EnumType==Enum.UserInputType then
return ck.UserInputType==cl
end
end
return false
end

aa.Flags[ci]=cf
local ck=false
local cl=0

local cm=Instance.new"Frame"
cm.Name="Keybind_"..ce
cm.Size=UDim2.new(1,0,0,34)
cm.BackgroundColor3=Color3.fromRGB(19,19,22)
cm.BorderSizePixel=0
cm.Parent=b7

local cn=Instance.new"UICorner"
cn.CornerRadius=UDim.new(0,8)
cn.Parent=cm

local co=Instance.new"UIStroke"
co.Color=Color3.fromRGB(30,30,35)
co.Thickness=1
co.Parent=cm

local cp=Instance.new"TextLabel"
cp.Name="Label"
cp.Size=UDim2.new(1,-90,1,0)
cp.Position=UDim2.new(0,12,0,0)
cp.BackgroundTransparency=1
cp.Font=Enum.Font.Gotham
cp.TextSize=12
cp.TextColor3=Color3.fromRGB(200,200,210)
cp.TextXAlignment=Enum.TextXAlignment.Left
cp.Text=ce
cp.Parent=cm

local cq=Instance.new"TextButton"
cq.Name="KeyBtn"
cq.Size=UDim2.new(0,72,0,22)
cq.Position=UDim2.new(1,-12,0.5,0)
cq.AnchorPoint=Vector2.new(1,0.5)
cq.BackgroundColor3=Color3.fromRGB(26,26,31)
cq.BorderSizePixel=0
cq.AutoButtonColor=false
cq.Font=Enum.Font.GothamBold
cq.TextSize=11
cq.TextColor3=Color3.fromRGB(240,240,245)
cq.Text=formatKeyText(cf)
cq.Parent=cm

local cr=Instance.new"UICorner"
cr.CornerRadius=UDim.new(0,6)
cr.Parent=cq

local cs=Instance.new"UIStroke"
cs.Color=Color3.fromRGB(36,36,42)
cs.Thickness=1
cs.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
cs.Parent=cq

table.insert(aa.Keybinds,{
Name=bO,
GetKey=function()
return cf
end,
IsActive=function()
return cb.Enabled
end
})
refreshKeybindHUD()

cq.MouseButton1Click:Connect(function()
if bw then return end
ck=true
cl=tick()
cq.Text="[ ... ]"
tween(cs,{Color=o},0.15)
end)

b.InputBegan:Connect(function(ct,cu)
if ck then
local cv=tick()
local cw
if ct.UserInputType==Enum.UserInputType.Keyboard then
if ct.KeyCode==Enum.KeyCode.Escape or ct.KeyCode==Enum.KeyCode.Backspace then
cw=Enum.KeyCode.Unknown
else
cw=ct.KeyCode
end
elseif ct.UserInputType==Enum.UserInputType.MouseButton1 or ct.UserInputType==Enum.UserInputType.MouseButton2 or ct.UserInputType==Enum.UserInputType.MouseButton3 then
if ct.UserInputType~=Enum.UserInputType.MouseButton1 or(cv-cl>0.25)then
cw=ct.UserInputType
end
elseif tostring(ct.UserInputType.Name):find"Gamepad"then
if ct.KeyCode~=Enum.KeyCode.Unknown then
cw=ct.KeyCode
end
end

if cw~=nil then
cf=cw
aa.Flags[ci]=cf
cq.Text=formatKeyText(cf)
ck=false
tween(cs,{Color=Color3.fromRGB(36,36,42)},0.15)
refreshKeybindHUD()
task.spawn(function()
pcall(cj,cf,true)
end)
end
elseif not cu and matchesKey(ct,cf)then
if ch then
if cg=="Toggle"then
setToggleState(not cb.Enabled)
elseif cg=="Hold"then
setToggleState(true)
end
end
refreshKeybindHUD()
task.spawn(function()
pcall(cj,cf,false)
end)
end
end)

if cg=="Hold"and ch then
b.InputEnded:Connect(function(ct)
if not ck and matchesKey(ct,cf)then
setToggleState(false)
refreshKeybindHUD()
end
end)
end

aa.ConfigElements[ci]={
Type="Keybind",
Serialize=function()
if typeof(cf)=="EnumItem"then
return cf.EnumType.Name.."."..cf.Name
end
return"KeyCode.Unknown"
end,
Deserialize=function(ct)
if typeof(ct)=="EnumItem"then
cf=ct
aa.Flags[ci]=cf
cq.Text=formatKeyText(cf)
refreshKeybindHUD()
pcall(cj,cf,false)
elseif type(ct)=="string"then
local cu,cv=ct:match"^(%w+)%.(%w+)$"
if cu=="KeyCode"and Enum.KeyCode[cv]then
cf=Enum.KeyCode[cv]
elseif cu=="UserInputType"and Enum.UserInputType[cv]then
cf=Enum.UserInputType[cv]
elseif Enum.KeyCode[ct]then
cf=Enum.KeyCode[ct]
elseif Enum.UserInputType[ct]then
cf=Enum.UserInputType[ct]
end
aa.Flags[ci]=cf
cq.Text=formatKeyText(cf)
refreshKeybindHUD()
pcall(cj,cf,false)
end
end
}

local ct={}
function ct.Set(cu,cv)
cf=cv or Enum.KeyCode.Unknown
aa.Flags[ci]=cf
cq.Text=formatKeyText(cf)
refreshKeybindHUD()
task.spawn(function()
pcall(cj,cf,false)
end)
end
function ct.Get(cu)
return cf
end
return ct
end

function cb.CreateTextBox(cc,cd)
cd=cd or{}
local ce=cd.Name or"TextBox"
local cf=cd.Placeholder or"Enter text..."
local cg=cd.Default or""
local ch=cd.Flag or(bR.."_"..ce)
local ci=cd.Callback or function()end

aa.Flags[ch]=cg

local cj=Instance.new"Frame"
cj.Name="TextBox_"..ce
cj.Size=UDim2.new(1,0,0,36)
cj.BackgroundColor3=Color3.fromRGB(19,19,22)
cj.BorderSizePixel=0
cj.Parent=b7

local ck=Instance.new"UICorner"
ck.CornerRadius=UDim.new(0,8)
ck.Parent=cj

local cl=Instance.new"UIStroke"
cl.Color=Color3.fromRGB(30,30,35)
cl.Thickness=1
cl.Parent=cj

local cm=Instance.new"TextLabel"
cm.Name="Label"
cm.Size=UDim2.new(0.48,0,1,0)
cm.Position=UDim2.new(0,12,0,0)
cm.BackgroundTransparency=1
cm.Font=Enum.Font.Gotham
cm.TextSize=12
cm.TextColor3=Color3.fromRGB(200,200,210)
cm.TextXAlignment=Enum.TextXAlignment.Left
cm.Text=ce
cm.Parent=cj

local cn=Instance.new"Frame"
cn.Name="BoxHolder"
cn.Size=UDim2.new(0.48,-12,0,26)
cn.Position=UDim2.new(1,-12,0.5,0)
cn.AnchorPoint=Vector2.new(1,0.5)
cn.BackgroundColor3=Color3.fromRGB(26,26,31)
cn.BorderSizePixel=0
cn.Parent=cj

local co=Instance.new"UICorner"
co.CornerRadius=UDim.new(0,6)
co.Parent=cn

local cp=Instance.new"UIStroke"
cp.Color=Color3.fromRGB(36,36,42)
cp.Thickness=1
cp.Parent=cn

local cq=Instance.new"TextBox"
cq.Name="Input"
cq.Size=UDim2.new(1,-16,1,0)
cq.Position=UDim2.new(0,8,0,0)
cq.BackgroundTransparency=1
cq.Font=Enum.Font.Gotham
cq.TextSize=11
cq.TextColor3=Color3.fromRGB(240,240,245)
cq.PlaceholderText=cf
cq.PlaceholderColor3=Color3.fromRGB(100,100,110)
cq.Text=cg
cq.ClearTextOnFocus=cd.ClearOnFocus or false
cq.Parent=cn

cq.Focused:Connect(function()
tween(cp,{Color=o},0.15)
end)

cq.FocusLost:Connect(function(cr)
tween(cp,{Color=Color3.fromRGB(36,36,42)},0.15)
aa.Flags[ch]=cq.Text
task.spawn(function()
pcall(ci,cq.Text,cr)
end)
end)

aa.ConfigElements[ch]={
Type="TextBox",
Serialize=function()
return cq.Text
end,
Deserialize=function(cr)
if cr~=nil then
cr=tostring(cr)
cq.Text=cr
aa.Flags[ch]=cr
task.spawn(function()
pcall(ci,cr,false)
end)
end
end
}

local cr={}
function cr.Set(cs,ct)
cq.Text=tostring(ct)
aa.Flags[ch]=cq.Text
end
function cr.Get(cs)
return cq.Text
end
return cr
end

function cb.CreateButton(cc,cd)
cd=cd or{}
local ce=cd.Name or"Button"
local cf=cd.Callback or function()end
local cg=false

local ch=Instance.new"TextButton"
ch.Name="Button_"..ce
ch.Size=UDim2.new(1,0,0,34)
ch.BackgroundColor3=Color3.fromRGB(19,19,22)
ch.BorderSizePixel=0
ch.AutoButtonColor=false
ch.Font=Enum.Font.GothamMedium
ch.TextSize=12
ch.TextColor3=Color3.fromRGB(210,210,220)
ch.Text=ce
ch.Parent=b7

local ci=Instance.new"UICorner"
ci.CornerRadius=UDim.new(0,8)
ci.Parent=ch

local cj=Instance.new"UIStroke"
cj.Color=Color3.fromRGB(30,30,35)
cj.Thickness=1
cj.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
cj.Parent=ch

ch.MouseButton1Click:Connect(function()
if bw then return end
tween(ch,{BackgroundColor3=Color3.fromRGB(30,30,36)},0.08)
tween(cj,{Color=o},0.08)
task.delay(0.12,function()
if cg then
tween(ch,{BackgroundColor3=Color3.fromRGB(24,24,29)},0.16)
tween(cj,{Color=Color3.fromRGB(46,46,54)},0.16)
else
tween(ch,{BackgroundColor3=Color3.fromRGB(19,19,22)},0.16)
tween(cj,{Color=Color3.fromRGB(30,30,35)},0.16)
end
end)
task.spawn(function()
pcall(cf)
end)
end)

ch.MouseEnter:Connect(function()
cg=true
tween(ch,{
BackgroundColor3=Color3.fromRGB(24,24,29),
TextColor3=Color3.fromRGB(245,245,250)
},0.15)
tween(cj,{Color=Color3.fromRGB(46,46,54)},0.15)
end)

ch.MouseLeave:Connect(function()
cg=false
tween(ch,{
BackgroundColor3=Color3.fromRGB(19,19,22),
TextColor3=Color3.fromRGB(210,210,220)
},0.15)
tween(cj,{Color=Color3.fromRGB(30,30,35)},0.15)
end)

local ck={}
function ck.SetText(cl,cm)
ch.Text=tostring(cm)
end
return ck
end

function cb.CreateColorPicker(cc,cd)
cd=cd or{}
local ce=cd.Name or"Color Picker"
local cf=cd.Default or o
local cg=cd.Flag or(bR.."_"..ce)
local ch=cd.Callback or function()end

local ci,cj,ck=Color3.toHSV(cf)
local cl=false
aa.Flags[cg]=cf

local cm=Instance.new"Frame"
cm.Name="ColorPicker_"..ce
cm.Size=UDim2.new(1,0,0,34)
cm.BackgroundColor3=Color3.fromRGB(19,19,22)
cm.BorderSizePixel=0
cm.ClipsDescendants=true
cm.Parent=b7

local cn=Instance.new"UICorner"
cn.CornerRadius=UDim.new(0,8)
cn.Parent=cm

local co=Instance.new"UIStroke"
co.Color=Color3.fromRGB(30,30,35)
co.Thickness=1
co.Parent=cm

local cp=Instance.new"Frame"
cp.Name="Header"
cp.Size=UDim2.new(1,0,0,34)
cp.BackgroundTransparency=1
cp.Parent=cm

local cq=Instance.new"TextLabel"
cq.Name="Label"
cq.Size=UDim2.new(1,-120,1,0)
cq.Position=UDim2.new(0,12,0,0)
cq.BackgroundTransparency=1
cq.Font=Enum.Font.Gotham
cq.TextSize=12
cq.TextColor3=Color3.fromRGB(200,200,210)
cq.TextXAlignment=Enum.TextXAlignment.Left
cq.Text=ce
cq.Parent=cp

local cr=Instance.new"TextLabel"
cr.Name="HexBadge"
cr.Size=UDim2.new(0,62,0,18)
cr.Position=UDim2.new(1,-50,0.5,0)
cr.AnchorPoint=Vector2.new(1,0.5)
cr.BackgroundTransparency=1
cr.Font=Enum.Font.GothamMedium
cr.TextSize=11
cr.TextColor3=Color3.fromRGB(130,130,142)
cr.TextXAlignment=Enum.TextXAlignment.Right
cr.Text=colorToHex(cf)
cr.Parent=cp

local cs=Instance.new"TextButton"
cs.Name="Preview"
cs.Size=UDim2.new(0,32,0,18)
cs.Position=UDim2.new(1,-12,0.5,0)
cs.AnchorPoint=Vector2.new(1,0.5)
cs.BackgroundColor3=cf
cs.BorderSizePixel=0
cs.AutoButtonColor=false
cs.Text=""
cs.Parent=cp

local ct=Instance.new"UICorner"
ct.CornerRadius=UDim.new(0,5)
ct.Parent=cs

local cu=Instance.new"UIStroke"
cu.Color=Color3.fromRGB(45,45,52)
cu.Thickness=1
cu.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
cu.Parent=cs

local cv=Instance.new"Frame"
cv.Name="Drawer"
cv.Size=UDim2.new(1,-24,0,146)
cv.Position=UDim2.new(0,12,0,38)
cv.BackgroundTransparency=1
cv.Parent=cm

local cw=Instance.new"TextButton"
cw.Name="SVCanvas"
cw.Size=UDim2.new(1,-120,0,108)
cw.Position=UDim2.new(0,0,0,0)
cw.BackgroundColor3=Color3.fromHSV(ci,1,1)
cw.BorderSizePixel=0
cw.AutoButtonColor=false
cw.Text=""
cw.ClipsDescendants=true
cw.Parent=cv

local cx=Instance.new"UICorner"
cx.CornerRadius=UDim.new(0,6)
cx.Parent=cw

local cy=Instance.new"UIStroke"
cy.Color=Color3.fromRGB(38,38,45)
cy.Thickness=1
cy.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
cy.Parent=cw

local cz=Instance.new"Frame"
cz.Name="SatOverlay"
cz.Size=UDim2.new(1,0,1,0)
cz.BackgroundColor3=Color3.fromRGB(255,255,255)
cz.BorderSizePixel=0
cz.Parent=cw

local cA=Instance.new"UICorner"
cA.CornerRadius=UDim.new(0,6)
cA.Parent=cz

local cB=Instance.new"UIGradient"
cB.Color=ColorSequence.new(Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255))
cB.Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1)
}
cB.Rotation=0
cB.Parent=cz

local cC=Instance.new"Frame"
cC.Name="ValOverlay"
cC.Size=UDim2.new(1,0,1,0)
cC.BackgroundColor3=Color3.fromRGB(0,0,0)
cC.BorderSizePixel=0
cC.ZIndex=2
cC.Parent=cw

local cD=Instance.new"UICorner"
cD.CornerRadius=UDim.new(0,6)
cD.Parent=cC

local cE=Instance.new"UIGradient"
cE.Color=ColorSequence.new(Color3.fromRGB(0,0,0),Color3.fromRGB(0,0,0))
cE.Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(1,0)
}
cE.Rotation=90
cE.Parent=cC

local cF=Instance.new"Frame"
cF.Name="Cursor"
cF.Size=UDim2.new(0,10,0,10)
cF.AnchorPoint=Vector2.new(0.5,0.5)
cF.Position=UDim2.new(cj,0,1-ck,0)
cF.BackgroundColor3=Color3.fromRGB(255,255,255)
cF.BorderSizePixel=0
cF.ZIndex=4
cF.Parent=cw

local cG=Instance.new"UICorner"
cG.CornerRadius=UDim.new(1,0)
cG.Parent=cF

local cH=Instance.new"UIStroke"
cH.Color=Color3.fromRGB(15,15,18)
cH.Thickness=1.5
cH.Parent=cF

local cI=Instance.new"TextButton"
cI.Name="HueBar"
cI.Size=UDim2.new(1,-120,0,12)
cI.Position=UDim2.new(0,0,0,118)
cI.BackgroundColor3=Color3.fromRGB(255,255,255)
cI.BorderSizePixel=0
cI.AutoButtonColor=false
cI.Text=""
cI.Parent=cv

local cJ=Instance.new"UICorner"
cJ.CornerRadius=UDim.new(1,0)
cJ.Parent=cI

local cK=Instance.new"UIStroke"
cK.Color=Color3.fromRGB(38,38,45)
cK.Thickness=1
cK.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
cK.Parent=cI

local cL=Instance.new"UIGradient"
cL.Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.00,Color3.fromRGB(255,0,0)),
ColorSequenceKeypoint.new(0.17,Color3.fromRGB(255,255,0)),
ColorSequenceKeypoint.new(0.33,Color3.fromRGB(0,255,0)),
ColorSequenceKeypoint.new(0.50,Color3.fromRGB(0,255,255)),
ColorSequenceKeypoint.new(0.67,Color3.fromRGB(0,0,255)),
ColorSequenceKeypoint.new(0.83,Color3.fromRGB(255,0,255)),
ColorSequenceKeypoint.new(1.00,Color3.fromRGB(255,0,0))
}
cL.Parent=cI

local cM=Instance.new"Frame"
cM.Name="HueKnob"
cM.Size=UDim2.new(0,8,1,4)
cM.AnchorPoint=Vector2.new(0.5,0.5)
cM.Position=UDim2.new(ci,0,0.5,0)
cM.BackgroundColor3=Color3.fromRGB(255,255,255)
cM.BorderSizePixel=0
cM.ZIndex=3
cM.Parent=cI

local cN=Instance.new"UICorner"
cN.CornerRadius=UDim.new(1,0)
cN.Parent=cM

local cO=Instance.new"UIStroke"
cO.Color=Color3.fromRGB(18,18,22)
cO.Thickness=1.5
cO.Parent=cM

local cP=Instance.new"Frame"
cP.Name="SidePanel"
cP.Size=UDim2.new(0,110,0,130)
cP.Position=UDim2.new(1,-110,0,0)
cP.BackgroundTransparency=1
cP.Parent=cv

local cQ=Instance.new"Frame"
cQ.Name="HexBg"
cQ.Size=UDim2.new(1,0,0,24)
cQ.Position=UDim2.new(0,0,0,0)
cQ.BackgroundColor3=Color3.fromRGB(26,26,31)
cQ.BorderSizePixel=0
cQ.Parent=cP

local cR=Instance.new"UICorner"
cR.CornerRadius=UDim.new(0,6)
cR.Parent=cQ

local cS=Instance.new"UIStroke"
cS.Color=Color3.fromRGB(36,36,42)
cS.Thickness=1
cS.Parent=cQ

local cT=Instance.new"TextBox"
cT.Name="HexInput"
cT.Size=UDim2.new(1,-12,1,0)
cT.Position=UDim2.new(0,6,0,0)
cT.BackgroundTransparency=1
cT.Font=Enum.Font.GothamBold
cT.TextSize=11
cT.TextColor3=Color3.fromRGB(240,240,245)
cT.PlaceholderText="#RRGGBB"
cT.PlaceholderColor3=Color3.fromRGB(100,100,110)
cT.Text=colorToHex(cf)
cT.ClearTextOnFocus=false
cT.Parent=cQ

local cU=Instance.new"Frame"
cU.Name="RGBRow"
cU.Size=UDim2.new(1,0,0,24)
cU.Position=UDim2.new(0,0,0,30)
cU.BackgroundTransparency=1
cU.Parent=cP

local function createChannelInput(cV,cW)
local cX=Instance.new"Frame"
cX.Name=cV
cX.Size=UDim2.new(0.31,0,1,0)
cX.Position=UDim2.new(cW,0,0,0)
cX.BackgroundColor3=Color3.fromRGB(26,26,31)
cX.BorderSizePixel=0
cX.Parent=cU

local cY=Instance.new"UICorner"
cY.CornerRadius=UDim.new(0,5)
cY.Parent=cX

local cZ=Instance.new"UIStroke"
cZ.Color=Color3.fromRGB(36,36,42)
cZ.Thickness=1
cZ.Parent=cX

local c_=Instance.new"TextBox"
c_.Size=UDim2.new(1,0,1,0)
c_.BackgroundTransparency=1
c_.Font=Enum.Font.GothamMedium
c_.TextSize=10
c_.TextColor3=Color3.fromRGB(230,230,238)
c_.ClearTextOnFocus=false
c_.Text="255"
c_.Parent=cX
return c_
end

local cV=createChannelInput("R",0)
local cW=createChannelInput("G",0.345)
local cX=createChannelInput("B",0.69)

local cY=Instance.new"Frame"
cY.Name="Swatches"
cY.Size=UDim2.new(1,0,0,68)
cY.Position=UDim2.new(0,0,0,62)
cY.BackgroundTransparency=1
cY.Parent=cP

local cZ=Instance.new"UIGridLayout"
cZ.CellSize=UDim2.new(0,23,0,20)
cZ.CellPadding=UDim2.new(0,6,0,6)
cZ.SortOrder=Enum.SortOrder.LayoutOrder
cZ.Parent=cY

local c_={
Color3.fromRGB(255,75,114),
Color3.fromRGB(100,120,255),
Color3.fromRGB(0,210,140),
Color3.fromRGB(255,170,0),
Color3.fromRGB(185,85,255),
Color3.fromRGB(255,65,65),
Color3.fromRGB(70,215,255),
Color3.fromRGB(255,255,255)
}

local function updateVisualsFromHSV(c0)
cf=Color3.fromHSV(ci,cj,ck)
aa.Flags[cg]=cf
cs.BackgroundColor3=cf
cw.BackgroundColor3=Color3.fromHSV(ci,1,1)
cF.Position=UDim2.new(cj,0,1-ck,0)
cM.Position=UDim2.new(ci,0,0.5,0)
local c1=colorToHex(cf)
cr.Text=c1
if not cT:IsFocused()then
cT.Text=c1
end
if not cV:IsFocused()then
cV.Text=tostring(math.floor(cf.R*255+0.5))
end
if not cW:IsFocused()then
cW.Text=tostring(math.floor(cf.G*255+0.5))
end
if not cX:IsFocused()then
cX.Text=tostring(math.floor(cf.B*255+0.5))
end
if not c0 then
task.spawn(function()
pcall(ch,cf)
end)
end
end

local function setColorDirect(c0,c1)
if typeof(c0)~="Color3"then return end
local c2,c3,c4=Color3.toHSV(c0)
ci,cj,ck=c2,c3,c4
updateVisualsFromHSV(c1)
end

updateVisualsFromHSV(true)

for c0,c1 in ipairs(c_)do
local c2=Instance.new"TextButton"
c2.Name="Swatch_"..tostring(c0)
c2.BackgroundColor3=c1
c2.BorderSizePixel=0
c2.AutoButtonColor=false
c2.Text=""
c2.Parent=cY

local c3=Instance.new"UICorner"
c3.CornerRadius=UDim.new(0,4)
c3.Parent=c2

local c4=Instance.new"UIStroke"
c4.Color=Color3.fromRGB(40,40,48)
c4.Thickness=1
c4.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
c4.Parent=c2

c2.MouseButton1Click:Connect(function()
if bw then return end
setColorDirect(c1,false)
end)
end

local c0=false
local c1=false

local function updateSVFromInput(c2)
local c3=cw.AbsoluteSize
if c3.X<=0 or c3.Y<=0 then return end
local c4=cw.AbsolutePosition
cj=math.clamp((c2.Position.X-c4.X)/c3.X,0,1)
ck=1-math.clamp((c2.Position.Y-c4.Y)/c3.Y,0,1)
updateVisualsFromHSV(false)
end

local function updateHueFromInput(c2)
local c3=cI.AbsoluteSize.X
if c3<=0 then return end
local c4=cI.AbsolutePosition.X
ci=math.clamp((c2.Position.X-c4)/c3,0,1)
updateVisualsFromHSV(false)
end

cw.InputBegan:Connect(function(c2)
if c2.UserInputType==Enum.UserInputType.MouseButton1 or c2.UserInputType==Enum.UserInputType.Touch then
c0=true
updateSVFromInput(c2)
end
end)

cI.InputBegan:Connect(function(c2)
if c2.UserInputType==Enum.UserInputType.MouseButton1 or c2.UserInputType==Enum.UserInputType.Touch then
c1=true
updateHueFromInput(c2)
end
end)

b.InputChanged:Connect(function(c2)
if c2.UserInputType==Enum.UserInputType.MouseMovement or c2.UserInputType==Enum.UserInputType.Touch then
if c0 then
updateSVFromInput(c2)
elseif c1 then
updateHueFromInput(c2)
end
end
end)

b.InputEnded:Connect(function(c2)
if c2.UserInputType==Enum.UserInputType.MouseButton1 or c2.UserInputType==Enum.UserInputType.Touch then
c0=false
c1=false
end
end)

cT.FocusLost:Connect(function()
local c2=hexToColor(cT.Text)
if c2 then
setColorDirect(c2,false)
else
cT.Text=colorToHex(cf)
end
end)

local function onRGBFocusLost()
local c2=math.clamp(tonumber(cV.Text)or math.floor(cf.R*255+0.5),0,255)
local c3=math.clamp(tonumber(cW.Text)or math.floor(cf.G*255+0.5),0,255)
local c4=math.clamp(tonumber(cX.Text)or math.floor(cf.B*255+0.5),0,255)
setColorDirect(Color3.fromRGB(c2,c3,c4),false)
end

cV.FocusLost:Connect(onRGBFocusLost)
cW.FocusLost:Connect(onRGBFocusLost)
cX.FocusLost:Connect(onRGBFocusLost)

local function togglePicker()
cl=not cl
if cl then
tween(cm,{Size=UDim2.new(1,0,0,178)},0.2)
tween(cu,{Color=o},0.2)
else
tween(cm,{Size=UDim2.new(1,0,0,34)},0.2)
tween(cu,{Color=Color3.fromRGB(45,45,52)},0.2)
end
task.delay(0.22,updateTraySize)
end

cs.MouseButton1Click:Connect(function()
if bw then return end
togglePicker()
end)

aa.ConfigElements[cg]={
Type="ColorPicker",
Serialize=function()
return colorToHex(cf)
end,
Deserialize=function(c2)
if typeof(c2)=="Color3"then
setColorDirect(c2,false)
elseif type(c2)=="string"then
local c3=hexToColor(c2)
if c3 then
setColorDirect(c3,false)
end
end
end
}

local c2={}
function c2.Set(c3,c4)
setColorDirect(c4,false)
end
function c2.Get(c3)
return cf
end
return c2
end

table.insert(bL.Modules,cb)
if not tostring(bR):match"^Internal_"then
aa.ModuleByName[bO]=cb
local cc=false
for cd,ce in ipairs(aa.AllModules)do
if ce.Name==bO then
cc=true
break
end
end
if not cc then
table.insert(aa.AllModules,cb)
end
for cd,ce in ipairs(aa.ModuleCreateListeners)do
pcall(ce,cb)
end
end
return cb
end

function bL.CreateConfigSystem(bM)
local bN="default"
local bO="default"
local bP

local bQ=bL:CreateModule{
Name="Config Manager",
Default=true,
Flag="Internal_ConfigManager"
}
aa.ConfigElements.Internal_ConfigManager=nil

local bR=bQ:CreateDropdown{
Name="Selected Profile",
Options=aa:GetConfigs(),
Default="default",
Flag="Internal_SelectedProfile",
Callback=function(bR)
bN=bR
if bP and bP.Set then
bP:Set(bR)
end
end
}
aa.ConfigElements.Internal_SelectedProfile=nil

bP=bQ:CreateTextBox{
Name="Profile Name",
Placeholder="Enter config name...",
Default="default",
Flag="Internal_ProfileName",
Callback=function(bS)
bO=bS
end
}
aa.ConfigElements.Internal_ProfileName=nil

local function refreshProfiles(bS)
local bT=aa:GetConfigs()
if bS and table.find(bT,bS)then
bN=bS
elseif not table.find(bT,bN)then
bN=bT[1]or"default"
end
bR:Refresh(bT,true)
bR:Set(bN)
end

bQ:CreateButton{
Name="Save Profile",
Callback=function()
local bS=(bP:Get()~=""and bP:Get())or bN
local bT,bU=aa:SaveConfig(bS)
if bT then
refreshProfiles(bU)
aa:Notify{
Title="Config Saved",
Description="Saved profile '"..tostring(bU).."'",
Duration=2.5
}
else
aa:Notify{
Title="Config Error",
Description=tostring(bU),
Duration=2.5
}
end
end
}

bQ:CreateButton{
Name="Load Profile",
Callback=function()
local bS=bR:Get()
local bT,bU=aa:LoadConfig(bS)
if bT then
aa:Notify{
Title="Config Loaded",
Description="Loaded profile '"..tostring(bU).."'",
Duration=2.5
}
else
aa:Notify{
Title="Config Error",
Description=tostring(bU),
Duration=2.5
}
end
end
}

bQ:CreateButton{
Name="Overwrite Profile",
Callback=function()
local bS=bR:Get()
local bT,bU=aa:SaveConfig(bS)
if bT then
refreshProfiles(bU)
aa:Notify{
Title="Config Updated",
Description="Overwrote profile '"..tostring(bU).."'",
Duration=2.5
}
end
end
}

bQ:CreateButton{
Name="Delete Profile",
Callback=function()
local bS=bR:Get()
if aa:DeleteConfig(bS)then
refreshProfiles()
aa:Notify{
Title="Config Deleted",
Description="Deleted profile '"..tostring(bS).."'",
Duration=2.5
}
end
end
}

bQ:CreateButton{
Name="Refresh List",
Callback=function()
refreshProfiles()
aa:Notify{
Title="Configs",
Description="Profile list refreshed",
Duration=2
}
end
}

local bS=bL:CreateModule{
Name="Cloud / Clipboard Config",
Default=true,
Flag="Internal_CloudConfig"
}
aa.ConfigElements.Internal_CloudConfig=nil

local bT=bS:CreateTextBox{
Name="Config JSON Data",
Placeholder="Paste config JSON here...",
Default="",
Flag="Internal_ImportJSON"
}
aa.ConfigElements.Internal_ImportJSON=nil

bS:CreateButton{
Name="Export Current Config to Clipboard",
Callback=function()
local bU=aa:ExportConfigJSON()
local bV=false
pcall(function()
local bW=setclipboard or toclipboard
if bW then
bW(bU)
bV=true
end
end)
bT:Set(bU)
aa:Notify{
Title="Config Exported",
Description=bV and"Copied JSON config to clipboard"or"Exported JSON to text box",
Duration=2.5
}
end
}

bS:CreateButton{
Name="Import Config from JSON Box",
Callback=function()
local bU=bT:Get()
forceResetPlayer()
if aa:ImportConfigJSON(bU)then
aa:Notify{
Title="Config Imported",
Description="Applied configuration from JSON",
Duration=2.5
}
else
aa:Notify{
Title="Import Failed",
Description="Invalid config JSON string",
Duration=2.5
}
end
end
}

return bQ
end

function bL.CreateButtonManager(bM)
local bN=bL:CreateModule{
Name="Button Manager",
Default=true,
Flag="Internal_ButtonManager"
}
aa.ConfigElements.Internal_ButtonManager=nil

local function getFeatureList()
local bO={}
for bP,bQ in ipairs(aa.AllModules)do
if bQ.Name and bQ.Name~="UI Preferences"and bQ.Name~="Button Manager"then
table.insert(bO,bQ.Name)
end
end
if#bO==0 then
bO={"Aim Assist","Silent Aim","Auto Clicker","Player ESP"}
end
return bO
end

local bO=getFeatureList()
local bP=aa.ButtonDraft.Feature or bO[1]or"Aim Assist"
aa.ButtonDraft.Feature=bP

local bQ=false
local bR,bS,bT,bU,bV,bW,bX

local function syncLiveFloatingIfPresent()
local bY=aa.ButtonDraft.Feature
local bZ=aa.FloatingButtons[bY]
if bZ and bZ.Config then
bZ.Config.Label=aa.ButtonDraft.Label
bZ.Config.Style=aa.ButtonDraft.Style
bZ.Config.Width=aa.ButtonDraft.Width
bZ.Config.Height=aa.ButtonDraft.Height
bZ.Config.CornerRadius=aa.ButtonDraft.CornerRadius
bZ.Config.Opacity=aa.ButtonDraft.Opacity
if bZ.Refresh then
bZ.Refresh()
end
refreshActiveButtonsListUI()
end
end

local function loadFeatureIntoDraft(bY)
bQ=true
aa.ButtonDraft.Feature=bY
local bZ=aa.FloatingButtons[bY]
if bZ and bZ.Config then
aa.ButtonDraft.Label=bZ.Config.Label or""
aa.ButtonDraft.Style=bZ.Config.Style or"Standard"
aa.ButtonDraft.Width=bZ.Config.Width or 116
aa.ButtonDraft.Height=bZ.Config.Height or 42
aa.ButtonDraft.CornerRadius=bZ.Config.CornerRadius or 10
aa.ButtonDraft.Opacity=bZ.Config.Opacity or 88
end
if bS then bS:Set(aa.ButtonDraft.Label or"")end
if bT then bT:Set(aa.ButtonDraft.Style or"Standard")end
if bU then bU:Set(aa.ButtonDraft.Width or 116)end
if bV then bV:Set(aa.ButtonDraft.Height or 42)end
if bW then bW:Set(aa.ButtonDraft.CornerRadius or 10)end
if bX then bX:Set(aa.ButtonDraft.Opacity or 88)end
bQ=false
refreshButtonPreviewWidget()
end

bR=bN:CreateDropdown{
Name="Feature",
Options=bO,
Default=bP,
Flag="Internal_BM_Feature",
Callback=function(bY)
if bQ then return end
aa:SetPreviewMode"Buttons"
loadFeatureIntoDraft(bY)
end
}
aa.ConfigElements.Internal_BM_Feature=nil

table.insert(aa.ModuleCreateListeners,function()
local bY=getFeatureList()
bR:Refresh(bY,true)
end)

bS=bN:CreateTextBox{
Name="Label",
Placeholder="feature name",
Default="",
Flag="Internal_BM_Label",
Callback=function(bY)
if bQ then return end
aa.ButtonDraft.Label=bY
aa:SetPreviewMode"Buttons"
refreshButtonPreviewWidget()
syncLiveFloatingIfPresent()
end
}
aa.ConfigElements.Internal_BM_Label=nil

bT=bN:CreateDropdown{
Name="Button Style",
Options={"Standard","Compact","Minimal","Outline"},
Default="Standard",
Flag="Internal_BM_Style",
Callback=function(bY)
if bQ then return end
aa.ButtonDraft.Style=bY
aa:SetPreviewMode"Buttons"
refreshButtonPreviewWidget()
syncLiveFloatingIfPresent()
end
}
aa.ConfigElements.Internal_BM_Style=nil

bU=bN:CreateSlider{
Name="Button Width",
Min=48,
Max=220,
Default=116,
Precision=2,
Unit="px",
Flag="Internal_BM_Width",
Callback=function(bY)
if bQ then return end
aa.ButtonDraft.Width=bY
aa:SetPreviewMode"Buttons"
refreshButtonPreviewWidget()
syncLiveFloatingIfPresent()
end
}
aa.ConfigElements.Internal_BM_Width=nil

bV=bN:CreateSlider{
Name="Button Height",
Min=28,
Max=110,
Default=42,
Precision=2,
Unit="px",
Flag="Internal_BM_Height",
Callback=function(bY)
if bQ then return end
aa.ButtonDraft.Height=bY
aa:SetPreviewMode"Buttons"
refreshButtonPreviewWidget()
syncLiveFloatingIfPresent()
end
}
aa.ConfigElements.Internal_BM_Height=nil

bW=bN:CreateSlider{
Name="Corner Radius",
Min=2,
Max=30,
Default=10,
Precision=1,
Unit="px",
Flag="Internal_BM_Corner",
Callback=function(bY)
if bQ then return end
aa.ButtonDraft.CornerRadius=bY
aa:SetPreviewMode"Buttons"
refreshButtonPreviewWidget()
syncLiveFloatingIfPresent()
end
}
aa.ConfigElements.Internal_BM_Corner=nil

bX=bN:CreateSlider{
Name="Opacity",
Min=10,
Max=100,
Default=88,
Precision=2,
Unit="%",
Flag="Internal_BM_Opacity",
Callback=function(bY)
if bQ then return end
aa.ButtonDraft.Opacity=bY
aa:SetPreviewMode"Buttons"
refreshButtonPreviewWidget()
syncLiveFloatingIfPresent()
end
}
aa.ConfigElements.Internal_BM_Opacity=nil

aa.OnSyncButtonManagerSliders=function(bY,bZ)
bQ=true
if bU then bU:Set(bY)end
if bV then bV:Set(bZ)end
bQ=false
end

aa.OnSelectFloatingButtonInManager=function(bY,bZ)
bQ=true
bR:Set(bY)
bQ=false
loadFeatureIntoDraft(bY)
end

bN:CreateButton{
Name="Add Button",
Callback=function()
local bY=bR:Get()or aa.ButtonDraft.Feature
aa:CreateFloatingButton{
Feature=bY,
Label=bS:Get(),
Style=bT:Get(),
Width=bU:Get(),
Height=bV:Get(),
CornerRadius=bW:Get(),
Opacity=bX:Get()
}
aa:SetPreviewMode"Buttons"
aa:Notify{
Title="Button Manager",
Description=tostring(bY).." button added",
Duration=2.5
}
end
}

bN:CreateButton{
Name="Remove Button",
Callback=function()
local bY=bR:Get()or aa.ButtonDraft.Feature
if aa:RemoveFloatingButton(bY)then
aa:Notify{
Title="Button Manager",
Description="Removed button for '"..tostring(bY).."'",
Duration=2
}
else
aa:Notify{
Title="Button Manager",
Description="No active button found for '"..tostring(bY).."'",
Duration=2
}
end
end
}

bN:CreateButton{
Name="Clear All",
Callback=function()
aa:ClearFloatingButtons()
aa:Notify{
Title="Button Manager",
Description="Cleared all on-screen toggle buttons",
Duration=2
}
end
}

bN:CreateToggle{
Name="Lock Buttons",
Default=aa.ButtonsLocked,
Flag="UI_LockFloatingButtons",
Callback=function(bY)
aa:SetButtonsLocked(bY)
end
}

return bN
end

function bL.CreateSettingsSystem(bM)
local bN=bL:CreateModule{
Name="UI Preferences",
Default=true,
Flag="UI_Preferences"
}

bN:CreateColorPicker{
Name="Accent Color",
Default=o,
Flag="UI_AccentColor",
Callback=function(bO)
aa:SetAccentColor(bO)
end
}

bN:CreateKeybind{
Name="Menu Keybind",
Default=n,
Mode="Toggle",
BindModule=false,
Flag="UI_ToggleKey",
Callback=function(bO,bP)
if bO and bO~=Enum.KeyCode.Unknown then
aa:SetToggleKey(bO)
if bP then
aa:Notify{
Title="Menu Keybind",
Description="Bound menu toggle to ["..bO.Name.."]",
Duration=2
}
end
end
end
}

bN:CreateToggle{
Name="Preview Window",
Default=aa.PreviewEnabled,
Flag="UI_ShowPreviewWindow",
Callback=function(bO)
aa:SetPreviewVisible(bO)
end
}

bN:CreateToggle{
Name="Watermark",
Default=ae.Visible,
Flag="UI_Watermark",
Callback=function(bO)
aa:SetWatermarkVisible(bO)
end
}

bN:CreateToggle{
Name="Keybind List",
Default=ak.Visible,
Flag="UI_KeybindList",
Callback=function(bO)
aa:SetKeybindListVisible(bO)
end
}

bN:CreateToggle{
Name="Mobile Button",
Default=ab~=nil and ab.Visible or false,
Flag="UI_MobileButton",
Callback=function(bO)
if ab then
ab.Visible=bO
end
end
}

bN:CreateSlider{
Name="UI Scale",
Min=0.35,
Max=1.1,
Default=w,
Precision=0.05,
Flag="UI_MainScale",
Callback=function(bO)
w=bO
if z then
z.Scale=bO
end
end
}

bN:CreateButton{
Name="Unload",
Callback=function()
aa:Destroy()
end
}

bL:CreateButtonManager()

return bN
end

table.insert(aa.Tabs,bL)
if#aa.Tabs==1 then
selectTab()
end

return bL
end

function aa.Destroy(bA)
t:Destroy()
end

return aa
end

j.new=j.CreateWindow

pcall(function()
if getgenv then
getgenv().FutureClub=j
end
end)

local aa=j
local ab=game:GetService"Workspace"
local ac=game:GetService"Players"
local ad=game:GetService"RunService"
local ae=game:GetService"UserInputService"
local af=game:GetService"Lighting"
local ag=game:GetService"HttpService"

local ah=ac.LocalPlayer
local ai=ab.CurrentCamera
local aj=ah:GetMouse()

local ak=Vector2.new
local al=Vector3.new
local am=Vector3.zero
local an=CFrame.new
local ao=CFrame.lookAt local ap=
CFrame.Angles
local aq=Color3.fromRGB
local ar=math.clamp
local as=math.random local at=
math.rad
local au=math.floor
local av=table.insert
local aw=table.clear

local ax;
local ay={}
local function registerCleanup(az)
av(ay,az)
return az
end

getgenv().FutureClubCleanup=function()
for az,aA in ipairs(ay)do
if typeof(aA)=="RBXScriptConnection"then
pcall(function()aA:Disconnect()end)
elseif type(aA)=="function"then
pcall(aA)
elseif typeof(aA)=="Instance"then
pcall(function()aA:Destroy()end)
elseif type(aA)=="table"and aA.Remove then
pcall(function()aA:Remove()end)
end
end
aw(ay)
end

local function matchesKey(az,aA)
if not aA or aA==Enum.KeyCode.Unknown then return false end
if typeof(aA)=="EnumItem"then
if aA.EnumType==Enum.KeyCode then
return az.KeyCode==aA
elseif aA.EnumType==Enum.UserInputType then
return az.UserInputType==aA
end
end
return false
end

local az={
Aiming={
Camlock={
Enabled=false,
Method="CFrame",
Keybind=Enum.KeyCode.C,
Mode="Toggle",
Active=false,
TargetPart="Head",
FOVOrigin="Mouse",
Prediction="Off",
PredictionAmount=0.138,
PredictionX_Right=0.138,
PredictionX_Left=0.138,
PredictionY_Up=0.138,
PredictionY_Down=0.138,
PredictionZ=0.138,
Resolver=false,
ResolverMode="Recalculation",
UnlockUponDeath=false,
Smoothness=0.20,
Shake=false,
ShakeAmount=15,
WallCheck=false,
KOCheck=false,
GrabbedCheck=false,
FriendCheck=false,
CrewCheck=false,
ShowFOV=false,
FOVRadius=120,
FOVColor=aq(255,75,114),
StickyAim=false,
ForceFieldCheck=false,
PriorityOnly=false
},
Silent={
Enabled=false,
Mode="Always On",
Keybind=Enum.KeyCode.Unknown,
Active=true,
FOVOrigin="Mouse",
TargetPart="Closest Part",
HitChance=100,
WallCheck=false,
KOCheck=false,
GrabbedCheck=false,
FriendCheck=false,
CrewCheck=false,
ShotgunSpread=6,
SpreadModEnabled=false,
SpreadAmount=0,
SpreadSpecificOnly=true,
SyncFOV=true,
ShowFOV=false,
FOVRadius=150,
FOVColor=aq(255,75,114),
TargetCamlockOnly=false,
TargetTracer=false,
TracerOrigin="Bottom",
TracerColor=aq(255,75,114),
TracerThickness=1.5,
ForceFieldCheck=false,
PriorityOnly=false
},
Triggerbot={
Enabled=false,
Keybind=Enum.KeyCode.Unknown,
Active=false,
Method="tool:Activate()",
Delay=50,
TolerancePX=0,
OnlyWhenSilent=false,
OnlyWhenLock=false,
FireOnSilentTarget=false,
WallCheck=false,
KOCheck=false,
GrabbedCheck=false,
FriendCheck=false,
CrewCheck=false,
TeamCheck=false,
ForceFieldCheck=false,
PriorityOnly=false
}
},
Visuals={
ESP={
Enabled=false,
Boxes=false,
BoxStyle="Corner",
BoxFill=false,
Names=false,
HealthBar=false,
Distance=false,
Weapon=false,
Tracers=false,
TracerOrigin="Bottom",
Chams=false,
Bones=false,
HeadDot=false,
TeamCheck=false,
MaxDistance=1000,
Colors={
Box=aq(255,75,114),
Name=aq(245,245,250),
Health=aq(90,245,140),
Distance=aq(165,165,180),
Weapon=aq(205,205,218),
Tracer=aq(0,210,140),
Chams=aq(255,75,114),
Bone=aq(240,240,250),
HeadDot=aq(255,75,114)
}
},
World={
Fullbright=false,
RemoveFog=false,
Crosshair=false,
CrosshairColor=aq(255,255,255),
CrosshairSize=10,
CrosshairGap=4
}
},
Client={
Noclip=false,
AnimationChanger=false,
SelectedAnimation="Default",
HitSounds=false,
HitSoundPreset="Rust",
HitSoundVolume=80,
CustomHitSoundId="",
DamageNumbers=false,
HitNotifications=false,
DamageNumbersColor=aq(255,75,114),
DamageDuration=1.0
},
Movement={
WalkSpeedEnabled=false,
WalkSpeedValue=16,
JumpPowerEnabled=false,
JumpPowerValue=50,
InfiniteJump=false,
FakeMacro=false,
MacroKey=Enum.KeyCode.Q,
MacroMode="Toggle",
MacroSpeedMode="Fixed",
MacroSpeed=120,
MacroSpeedMin=200,
MacroSpeedMax=300,
MacroRampStart=60,
MacroRampMax=280,
MacroRampDuration=1.0,
MacroActive=false
},
Targeting={
SelectedPlayer=nil,
Priority={},
Friends={}
}
}

local aA=16
local aB=50
local aC=16
local aD=50
local aE

local function updateWalkspeed()
if aE and aE:IsDescendantOf(game)then
aE.WalkSpeed=az.Movement.WalkSpeedEnabled and aA or aC
end
end

local function updateJumpPower()
if aE and aE:IsDescendantOf(game)then
aE.JumpPower=az.Movement.JumpPowerEnabled and aB or aD
end
end

local function onCharacterAddedSpeedJump(aF)
aE=aF:WaitForChild("Humanoid",5)
if aE then
updateWalkspeed()
updateJumpPower()
aE:GetPropertyChangedSignal"WalkSpeed":Connect(function()
if az.Movement.WalkSpeedEnabled and aE.WalkSpeed~=aA then
aE.WalkSpeed=aA
end
end)
aE:GetPropertyChangedSignal"JumpPower":Connect(function()
if az.Movement.JumpPowerEnabled and aE.JumpPower~=aB then
aE.JumpPower=aB
end
end)
end
end


local aF
local aG=false
local aH
local aI

local function findMeleeTool()
local aJ=ah.Character
local aK=ah:FindFirstChildOfClass"Backpack"
local aL={}
if aJ then
for aM,aN in ipairs(aJ:GetChildren())do
if aN:IsA"Tool"then av(aL,aN)end
end
end
if aK then
for aM,aN in ipairs(aK:GetChildren())do
if aN:IsA"Tool"then av(aL,aN)end
end
end
for aM,aN in ipairs(aL)do
local aO=aN.Name:lower()
if aO:find"knife"or aO:find"blade"or aO:find"combat"or aO:find"fist"or aO:find"katana"or aO:find"sword"or aO:find"machete"then
return aN
end
end
return aL[1]
end

local function getMacroAnimation()
if aH then return aH end
local aJ,aK=pcall(function()
return game:GetObjects"rbxassetid://15610015346"
end)
if aJ and aK and#aK>0 then
local aL=aK[1]
if aL:IsA"Animation"then
aH=aL
aI=aL.AnimationId
return aH
end
local aM=aL:FindFirstChildWhichIsA("Animation",true)
if aM then
aH=aM
aI=aM.AnimationId
return aH
end
end
local aL=Instance.new"Animation"
aL.AnimationId=aI or"rbxassetid://15610015346"
aH=aL
return aH
end

local aJ

local function playMacroEmote(aK)
if not aK then return nil end
local aL=aK:FindFirstChildOfClass"Animator"
if not aL then
aL=Instance.new"Animator"
aL.Parent=aK
end

local aM=getMacroAnimation()
pcall(function()aM.Parent=aK end)
local aN

local aO=pcall(function()
aN=aL:LoadAnimation(aM)
end)
if not aO or not aN then
pcall(function()
aN=aK:LoadAnimation(aM)
end)
end

if aN then
aN.Priority=Enum.AnimationPriority.Action4
aN.Looped=true
aN:Play(0.05,1,1)
end
return aN
end

local function startFakeMacro()
if aG then return end
aG=true
task.spawn(function()
local aK=ah.Character
local aL=aK and aK:FindFirstChildOfClass"Humanoid"
local aM=aK and aK:FindFirstChild"HumanoidRootPart"
if not aK or not aL or not aM then aG=false;return end

if aF then
pcall(function()aF:Stop(0.05)end)
aF=nil
end
if aJ then
aJ:Disconnect()
aJ=nil
end

aA=0
az.Movement.WalkSpeedEnabled=true
updateWalkspeed()
pcall(function()
aM.AssemblyLinearVelocity=am
aL:Move(am,false)
end)

local aN=findMeleeTool()
if aN and aN.Parent~=aK then
aL:EquipTool(aN)
task.wait(0.05)
end

if not aG then return end

for aO,aP in ipairs(aL:GetPlayingAnimationTracks())do
if aP.Priority==Enum.AnimationPriority.Movement or aP.Priority==Enum.AnimationPriority.Idle then
pcall(function()aP:Stop(0)end)
end
end

local aO=playMacroEmote(aL)
if aO then
aF=aO
end

task.wait(0.7)
if not aG then
if aF then
pcall(function()aF:Stop(0.05)end)
aF=nil
end
return
end

if aF then
pcall(function()aF:Stop(0.05)end)
aF=nil
end

if az.Movement.MacroSpeedMode=="Fixed"then
aA=az.Movement.MacroSpeed
az.Movement.WalkSpeedEnabled=true
updateWalkspeed()
elseif az.Movement.MacroSpeedMode=="Random"then
aA=as(az.Movement.MacroSpeedMin,az.Movement.MacroSpeedMax)
az.Movement.WalkSpeedEnabled=true
updateWalkspeed()
aJ=ad.Heartbeat:Connect(function()
if not aG then return end
aA=as(az.Movement.MacroSpeedMin,az.Movement.MacroSpeedMax)
updateWalkspeed()
end)
elseif az.Movement.MacroSpeedMode=="Ramp Up"then
local aP=az.Movement.MacroRampStart
local aQ=az.Movement.MacroRampMax
local aR=math.max(0.1,az.Movement.MacroRampDuration)
local aS=tick()
aA=aP
az.Movement.WalkSpeedEnabled=true
updateWalkspeed()
aJ=ad.Heartbeat:Connect(function()
if not aG then return end
local aT=ar((tick()-aS)/aR,0,1)
aA=au(aP+(aQ-aP)*aT)
updateWalkspeed()
if aT>=1 and aJ then
aJ:Disconnect()
aJ=nil
end
end)
end
end)
end

local function stopFakeMacro()
aG=false
if aJ then
aJ:Disconnect()
aJ=nil
end
if aF then
pcall(function()aF:Stop(0.05)end)
aF=nil
end
aA=az.Movement.WalkSpeedValue
az.Movement.WalkSpeedEnabled=(aA~=16)
updateWalkspeed()
end

local aK=RaycastParams.new()
aK.FilterType=Enum.RaycastFilterType.Exclude
aK.IgnoreWater=true

local function isKnocked(aL)
if not aL then return true end
local aM=aL:FindFirstChildOfClass"Humanoid"
if not aM or aM.Health<=0 then return true end
local aN=aL:FindFirstChild"BodyEffects"
if aN then
local aO=aN:FindFirstChild"K.O"or aN:FindFirstChild"KO"
if aO and aO.Value then return true end
end
return false
end

local function isGrabbed(aL)
if not aL then return true end
if aL:FindFirstChild"GRABBING_CONSTRAINT"then return true end
local aM=aL:FindFirstChild"BodyEffects"
if aM then
local aN=aM:FindFirstChild"Grabbed"
if aN and aN.Value then return true end
end
return false
end

local function isFriend(aL)
if not aL then return false end
local aM=az.Targeting and az.Targeting.Friends
if aM and(aM[aL.UserId]or aM[tostring(aL.UserId)]or aM[aL.Name])then return true end
local aN,aO=pcall(function()return ah:IsFriendsWith(aL.UserId)end)
return aN and aO==true
end

local function isPriorityPlayer(aL)
if not aL then return false end
local aM=az.Targeting and az.Targeting.Priority
if not aM then return false end
return(aM[aL.UserId]==true)or(aM[tostring(aL.UserId)]==true)or(aM[aL.Name]==true)
end

local function isCrew(aL)
if not aL then return false end
if aL.Team and ah.Team and aL.Team==ah.Team then return true end
local aM=ah.Character
local aN=aL.Character
if aM and aN then
local aO=aM:FindFirstChild"CrewTitle"or aM:FindFirstChild"[CREW]"
local aP=aN:FindFirstChild"CrewTitle"or aN:FindFirstChild"[CREW]"
if aO and aP and aO.Value==aP.Value and aO.Value~=""then
return true
end
end
return false
end

local function hasForceField(aL)
if not aL then return false end
return aL:FindFirstChildOfClass"ForceField"~=nil
end

local function isVisible(aL,aM)
if not aL then return false end
aK.FilterDescendantsInstances={ai,ah.Character}
local aN=aL.Position-aM
local aO=ab:Raycast(aM,aN,aK)
if not aO then return true end
return aO.Instance:IsDescendantOf(aL.Parent)
end

local function getTargetPart(aL,aM)
if not aL then return nil end
if aM=="Closest Part"then
local aN=ae:GetMouseLocation()
local aO=math.huge
local aP
for aQ,aR in ipairs(aL:GetChildren())do
if aR:IsA"BasePart"then
local aS,aT=ai:WorldToViewportPoint(aR.Position)
if aT then
local aU=(ak(aS.X,aS.Y)-aN).Magnitude
if aU<aO then
aO=aU
aP=aR
end
end
end
end
return aP or aL:FindFirstChild"HumanoidRootPart"or aL:FindFirstChild"Head"
end
return aL:FindFirstChild(aM)or aL:FindFirstChild"HumanoidRootPart"or aL:FindFirstChild"Head"
end

local function getToolRange(aL)
if not aL then return nil end
local aM=aL:FindFirstChild("Range",true)
if aM and(aM:IsA"NumberValue"or aM:IsA"IntValue")then
local aN=tonumber(aM.Value)
if aN and aN>0 then
return aN
end
end
local aN=aL:GetAttribute"Range"
if type(aN)=="number"and aN>0 then
return aN
end
local aO=aL:FindFirstChild"Configuration"or aL:FindFirstChild"Settings"or aL:FindFirstChild"GunConfig"
if aO then
local aP=aO:FindFirstChild"Range"
if aP and(aP:IsA"NumberValue"or aP:IsA"IntValue")and tonumber(aP.Value)and aP.Value>0 then
return tonumber(aP.Value)
end
end
return nil
end

local aL={Player=nil,Part=nil}
local aM={Player=nil,Part=nil}
local aN="None"

local aO={}

local function updateVelocityTracker(aP)
if not aP or aP<=0 or aP>0.5 then return end
for aQ,aR in ipairs(ac:GetPlayers())do
if aR~=ah and aR.Character then
local aS=aR.Character:FindFirstChild"HumanoidRootPart"or aR.Character:FindFirstChild"Head"
if aS and aS:IsA"BasePart"then
local aT=aO[aR]
if not aT then
aO[aR]={
lastChar=aR.Character,
lastPos=aS.Position,
velocity=am
}
elseif aT.lastChar~=aR.Character then
aT.lastChar=aR.Character
aT.lastPos=aS.Position
aT.velocity=am
else
local aU=aS.Position-aT.lastPos
if aU.Magnitude>300 then
aT.velocity=am
else
aT.velocity=aU/aP
end
aT.lastPos=aS.Position
end
end
end
end
end

registerCleanup(ac.PlayerRemoving:Connect(function(aP)
aO[aP]=nil
end))

registerCleanup(ad.Heartbeat:Connect(function(aP)
updateVelocityTracker(aP)
end))

local function getEffectiveVelocity(aP,aQ,aR,aS,aT)
local aU=(aQ and(aQ.AssemblyLinearVelocity or aQ.Velocity))or am
if not aP or not aP.Character then
return aU
end

local aV=aP.Character
local aW=aV:FindFirstChildOfClass"Humanoid"
local aX=aO[aP]
local aY=(aX and aX.velocity)or aU

if aT then
return aY
end

if aR then
local aZ=aS or"Recalculation"
if aZ=="Recalculation"then
return aY
elseif aZ=="MoveDirection"and aW then
if aW.MoveDirection.Magnitude>0.01 then
local a_=(aW.WalkSpeed>0 and aW.WalkSpeed)or 16
local a0=(aY.Y>-100 and aY.Y<100)and aY.Y or 0
return al(aW.MoveDirection.X*a_,a0,aW.MoveDirection.Z*a_)
else
return al(0,(aY.Y>-100 and aY.Y<100)and aY.Y or 0,0)
end
elseif aZ=="LookVector"and aQ then
local a_=(aW and aW.MoveDirection.Magnitude>0.01)or(aY.Magnitude>=1)
if not a_ then
local a0=(aY.Y>-100 and aY.Y<100)and aY.Y or 0
return al(0,a0,0)
end
local a0=aY.Magnitude
if a0<1 or a0>100 then
a0=(aW and aW.WalkSpeed>0 and aW.WalkSpeed)or 16
end
local a1=(aY.Y>-100 and aY.Y<100)and aY.Y or 0
local a2=aQ.CFrame.LookVector
return al(a2.X*a0,a1,a2.Z*a0)
end
return aY
end

if aU.Magnitude>100 or aU.Y<-100 or aU.Y>100 then
if aX and aX.velocity and aX.velocity.Magnitude<100 then
return aX.velocity
end
end

return aU
end

local function isShotgun(aP)
if not aP or aP=="None"then return false end
local aQ=tostring(aP):lower()
return aQ:find"double"or aQ:find"db"or aQ:find"tactical"or aQ:find"tac"or aQ:find"shotgun"
end

local function isSilentAimActive()
if not az.Aiming.Silent.Enabled then return false end
if az.Aiming.Silent.Mode=="Always On"then return true end
if az.Aiming.Silent.Keybind==Enum.KeyCode.Unknown then return true end
return az.Aiming.Silent.Active==true
end

local function getClosestSilentTarget()
if not isSilentAimActive()then return nil,nil end
local aP=az.Aiming.Silent.SyncFOV and az.Aiming.Camlock.Enabled
local aQ=aP and(az.Aiming.Camlock.FOVRadius or 120)or(az.Aiming.Silent.FOVRadius or 150)
local aR=ai.ViewportSize/2
local aS=ae.MouseBehavior
local aT=(aS==Enum.MouseBehavior.LockCenter or aS==Enum.MouseBehavior.LockCurrentPosition)
local aU=aP and az.Aiming.Camlock.FOVOrigin or az.Aiming.Silent.FOVOrigin
local aV=(aU=="Screen Center"or aT)and aR or ae:GetMouseLocation()
local aW=az.Aiming.Silent.TargetPart or"Closest Part"

if az.Aiming.Silent.TargetCamlockOnly then
if aM.Player and aM.Player.Character and aM.Part then
local aX=aM.Player
if not az.Aiming.Silent.PriorityOnly or isPriorityPlayer(aX)then
local aY=aX.Character
local aZ=aY:FindFirstChildOfClass"Humanoid"
if aZ and aZ.Health>0 then
local a_
if aW=="Closest Part"then
a_=aM.Part
else
a_=aY:FindFirstChild(aW)or(aW:find"Torso"and aY:FindFirstChild"Torso")or aY:FindFirstChild"HumanoidRootPart"or aY:FindFirstChild"Head"
end
if a_ and a_:IsA"BasePart"then
return aX,a_
end
end
end
end
return nil,nil
end

local aX,aY
local aZ=aQ
local a_,a0
local a1=aQ

for a2,a3 in ipairs(ac:GetPlayers())do
if a3~=ah and a3.Character and a3.Character:FindFirstChildOfClass"Humanoid"and a3.Character:FindFirstChildOfClass"Humanoid".Health>0 then
local a4=isPriorityPlayer(a3)
if not az.Aiming.Silent.PriorityOnly or a4 then
local a5=a3.Character
if(not az.Aiming.Silent.KOCheck or not isKnocked(a5))and
(not az.Aiming.Silent.GrabbedCheck or not isGrabbed(a5))and
(not az.Aiming.Silent.FriendCheck or not isFriend(a3))and
(not az.Aiming.Silent.CrewCheck or not isCrew(a3))and
(not az.Aiming.Silent.ForceFieldCheck or not hasForceField(a5))then
if aW=="Closest Part"then
local a6
local a7=aQ
for a8,a9 in ipairs(a5:GetChildren())do
if a9:IsA"BasePart"then
if not az.Aiming.Silent.WallCheck or isVisible(a9,ai.CFrame.Position)then
local ba,bb=ai:WorldToViewportPoint(a9.Position)
if bb then
local bc=(ak(ba.X,ba.Y)-aV).Magnitude
if bc<a7 then
a7=bc
a6=a9
end
end
end
end
end
if a6 then
if a4 then
if a7<aZ then
aZ=a7
aX=a3
aY=a6
end
else
if a7<a1 then
a1=a7
a_=a3
a0=a6
end
end
end
else
local a6=a5:FindFirstChild(aW)or(aW:find"Torso"and a5:FindFirstChild"Torso")or a5:FindFirstChild"HumanoidRootPart"or a5:FindFirstChild"Head"
if a6 and a6:IsA"BasePart"then
if not az.Aiming.Silent.WallCheck or isVisible(a6,ai.CFrame.Position)then
local a7,a8=ai:WorldToViewportPoint(a6.Position)
if a8 then
local a9=(ak(a7.X,a7.Y)-aV).Magnitude
if a4 then
if a9<aZ then
aZ=a9
aX=a3
aY=a6
end
else
if a9<a1 then
a1=a9
a_=a3
a0=a6
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

if aX then
return aX,aY
elseif not az.Aiming.Silent.PriorityOnly and a_ then
return a_,a0
end
return nil,nil
end

local function calculateSpreadDirection(aP,aQ,aR)
local aS=(aQ-aP).Unit
if aR and aR>0 then
local aT=aR*((aQ-aP).Magnitude/100)
aS=(aQ+Vector3.new(
as(-aT*1000,aT*1000)/1000,
as(-aT*1000,aT*1000)/1000,
as(-aT*1000,aT*1000)/1000
)-aP).Unit
end
return aS*1000
end

local function bindToolTracking(aP)
if not aP then return end
for aQ,aR in ipairs(aP:GetChildren())do
if aR:IsA"Tool"then aN=aR.Name end
end
aP.ChildAdded:Connect(function(aQ)
if aQ:IsA"Tool"then aN=aQ.Name end
end)
aP.ChildRemoved:Connect(function(aQ)
if aQ:IsA"Tool"then aN="None"end
end)
end

local aP;
aP=hookmetamethod(game,"__namecall",newcclosure(function(aQ,...)
local aR=getnamecallmethod()
local aS={...}
if not checkcaller()and az.Aiming.Silent.Enabled and isSilentAimActive()and aL.Part then
if(az.Aiming.Silent.HitChance or 100)<100 and as(1,100)>(az.Aiming.Silent.HitChance or 100)then
return aP(aQ,...)
end
local aT=aL.Part
local aU=0
local aV=isShotgun(aN)
local aW=not az.Aiming.Silent.SpreadSpecificOnly or aV
if aW then
local aX=az.Aiming.Silent.ShotgunSpread or 6
if az.Aiming.Silent.SpreadModEnabled then
aU=aX*((az.Aiming.Silent.SpreadAmount or 0)/100)
else
aU=aX
end
end
if aR=="Raycast"and(aQ==ab or aQ==workspace)and#aS>=2 and typeof(aS[1])=="Vector3"and typeof(aS[2])=="Vector3"then
aS[2]=calculateSpreadDirection(aS[1],aT.Position,aU)
return aP(aQ,unpack(aS))
end
if aR:find"FindPartOnRay"and typeof(aS[1])=="Ray"then
local aX=aS[1]
aS[1]=Ray.new(aX.Origin,calculateSpreadDirection(aX.Origin,aT.Position,aU))
return aP(aQ,unpack(aS))
end
end
return aP(aQ,...)
end))

local aQ;
aQ=hookmetamethod(game,"__index",newcclosure(function(aR,aS)
if not checkcaller()and az.Aiming.Silent.Enabled and isSilentAimActive()and aL.Part and aR==aj then
if(az.Aiming.Silent.HitChance or 100)<100 and as(1,100)>(az.Aiming.Silent.HitChance or 100)then
return aQ(aR,aS)
end
local aT=aL.Part
if aS=="Hit"then
return CFrame.new(aT.Position)
elseif aS=="Target"then
return aT
end
end
return aQ(aR,aS)
end))

local function resolveCamlockTarget()
if not az.Aiming.Camlock.Enabled or not az.Aiming.Camlock.Active then
aM.Player=nil
aM.Part=nil
return
end

local aR=az.Aiming.Camlock.FOVRadius
local aS=ai.ViewportSize/2
local aT=ae.MouseBehavior
local aU=(aT==Enum.MouseBehavior.LockCenter or aT==Enum.MouseBehavior.LockCurrentPosition)
local aV=(az.Aiming.Camlock.FOVOrigin=="Screen Center"or aU)and aS or ae:GetMouseLocation()

local aW=aM.Player
local aX=isPriorityPlayer(aW)
local aY=false

if aW and aW.Character and aM.Part and aM.Part.Parent then
local aZ=aW.Character
local a_=aZ:FindFirstChildOfClass"Humanoid"
if not a_ or a_.Health<=0 then
aM.Player=nil
aM.Part=nil
if az.Aiming.Camlock.UnlockUponDeath then
az.Aiming.Camlock.Active=false
return
end
elseif az.Aiming.Camlock.PriorityOnly and not aX then
aM.Player=nil
aM.Part=nil
elseif(not az.Aiming.Camlock.KOCheck or not isKnocked(aZ))and
(not az.Aiming.Camlock.GrabbedCheck or not isGrabbed(aZ))and
(not az.Aiming.Camlock.FriendCheck or not isFriend(aW))and
(not az.Aiming.Camlock.CrewCheck or not isCrew(aW))and
(not az.Aiming.Camlock.ForceFieldCheck or not hasForceField(aZ))then
if not az.Aiming.Camlock.WallCheck or isVisible(aM.Part,ai.CFrame.Position)then
if az.Aiming.Camlock.StickyAim then
aY=true
else
local a0,a1=ai:WorldToViewportPoint(aM.Part.Position)
if a1 then
local a2=(ak(a0.X,a0.Y)-aV).Magnitude
if a2<=aR then
aY=true
end
end
end
end
else
aM.Player=nil
aM.Part=nil
end
elseif aW then
aM.Player=nil
aM.Part=nil
if az.Aiming.Camlock.UnlockUponDeath then
az.Aiming.Camlock.Active=false
return
end
end

if aY and aX and az.Aiming.Camlock.StickyAim then
return
end

local aZ,a_
local a0=aR
local a1,a2
local a3=aR

for a4,a5 in ipairs(ac:GetPlayers())do
if a5~=ah and a5.Character then
local a6=a5.Character
local a7=a6:FindFirstChildOfClass"Humanoid"
if a7 and a7.Health>0 then
local a8=isPriorityPlayer(a5)
if not az.Aiming.Camlock.PriorityOnly or a8 then
if(not az.Aiming.Camlock.KOCheck or not isKnocked(a6))and
(not az.Aiming.Camlock.GrabbedCheck or not isGrabbed(a6))and
(not az.Aiming.Camlock.FriendCheck or not isFriend(a5))and
(not az.Aiming.Camlock.CrewCheck or not isCrew(a5))and
(not az.Aiming.Camlock.ForceFieldCheck or not hasForceField(a6))then
local a9
local ba=aR
if az.Aiming.Camlock.TargetPart=="Closest Part"then
for bb,bc in ipairs(a6:GetChildren())do
if bc:IsA"BasePart"then
if not az.Aiming.Camlock.WallCheck or isVisible(bc,ai.CFrame.Position)then
local bd,be=ai:WorldToViewportPoint(bc.Position)
if be then
local bf=(ak(bd.X,bd.Y)-aV).Magnitude
if bf<ba then
ba=bf
a9=bc
end
end
end
end
end
else
local bb=getTargetPart(a6,az.Aiming.Camlock.TargetPart)
if bb and bb:IsA"BasePart"then
if not az.Aiming.Camlock.WallCheck or isVisible(bb,ai.CFrame.Position)then
local bc,bd=ai:WorldToViewportPoint(bb.Position)
if bd then
local be=(ak(bc.X,bc.Y)-aV).Magnitude
if be<aR then
ba=be
a9=bb
end
end
end
end
end

if a9 and ba<aR then
if a8 then
if ba<a0 then
a0=ba
aZ=a5
a_=a9
end
else
if ba<a3 then
a3=ba
a1=a5
a2=a9
end
end
end
end
end
end
end
end

if aZ then
aM.Player=aZ
aM.Part=a_
elseif aY and not az.Aiming.Camlock.PriorityOnly then
return
elseif not az.Aiming.Camlock.PriorityOnly and a1 then
aM.Player=a1
aM.Part=a2
else
aM.Player=nil
aM.Part=nil
end
end

local aR
local aS
local aT

pcall(function()
if Drawing then
aR=Drawing.new"Circle"
aR.Thickness=1.5
aR.NumSides=64
aR.Filled=false
aR.Visible=false
aR.Transparency=1
registerCleanup(function()pcall(function()aR:Remove()end)end)

aS=Drawing.new"Circle"
aS.Thickness=1.5
aS.NumSides=64
aS.Filled=false
aS.Visible=false
aS.Transparency=1
registerCleanup(function()pcall(function()aS:Remove()end)end)

aT=Drawing.new"Line"
aT.Thickness=1.5
aT.Visible=false
aT.Transparency=1
aT.Color=aq(255,75,114)
registerCleanup(function()pcall(function()aT:Remove()end)end)
end
end)

if not aT then
pcall(function()
local aU=Instance.new"ScreenGui"
aU.Name="FutureTracerOverlay"
aU.ResetOnSpawn=false
aU.DisplayOrder=1000
pcall(function()
if syn and syn.protect_gui then
syn.protect_gui(aU)
aU.Parent=game:GetService"CoreGui"
elseif gethui then
aU.Parent=gethui()
else
aU.Parent=game:GetService"CoreGui"
end
end)
if not aU.Parent then
aU.Parent=ah:WaitForChild"PlayerGui"
end

local aV=Instance.new"Frame"
aV.Name="Line"
aV.AnchorPoint=Vector2.new(0,0.5)
aV.BorderSizePixel=0
aV.Visible=false
aV.Parent=aU

local aW={
_gui=aU,
_frame=aV,
Visible=false,
From=Vector2.zero,
To=Vector2.zero,
Color=Color3.fromRGB(255,75,114),
Thickness=1.5,
Transparency=1
}

local aX={}
aX.__newindex=function(aY,aZ,a_)
rawset(aY,aZ,a_)
if aZ=="Visible"then
aV.Visible=a_
elseif aZ=="Color"then
aV.BackgroundColor3=a_
elseif aZ=="Thickness"then
aV.Size=UDim2.new(0,aV.AbsoluteSize.X,0,a_)
elseif aZ=="From"or aZ=="To"then
local a0=rawget(aY,"From")or Vector2.zero
local a1=rawget(aY,"To")or Vector2.zero
local a2=a1-a0
local a3=a2.Magnitude
local a4=math.deg(math.atan2(a2.Y,a2.X))
aV.Position=UDim2.new(0,a0.X,0,a0.Y)
aV.Size=UDim2.new(0,a3,0,rawget(aY,"Thickness")or 1.5)
aV.Rotation=a4
end
end
setmetatable(aW,aX)
function aW.Remove(aY)
pcall(function()aU:Destroy()end)
end
aT=aW
registerCleanup(function()pcall(function()aT:Remove()end)end)
end)
end

local aU={}
pcall(function()
if Drawing then
for aV=1,4 do
local aW=Drawing.new"Line"
aW.Thickness=1.5
aW.Visible=false
av(aU,aW)
end
registerCleanup(function()
for aV,aW in ipairs(aU)do pcall(function()aW:Remove()end)end
end)
end
end)

local function updateWorldCrosshair()
if#aU==4 then
if az.Visuals.World.Crosshair then
local aV=ai.ViewportSize.X/2
local aW=ai.ViewportSize.Y/2
local aX=az.Visuals.World.CrosshairSize
local aY=az.Visuals.World.CrosshairGap
local aZ=az.Visuals.World.CrosshairColor

aU[1].From=ak(aV-aY-aX,aW);aU[1].To=ak(aV-aY,aW);aU[1].Color=aZ;aU[1].Visible=true
aU[2].From=ak(aV+aY,aW);aU[2].To=ak(aV+aY+aX,aW);aU[2].Color=aZ;aU[2].Visible=true
aU[3].From=ak(aV,aW-aY-aX);aU[3].To=ak(aV,aW-aY);aU[3].Color=aZ;aU[3].Visible=true
aU[4].From=ak(aV,aW+aY);aU[4].To=ak(aV,aW+aY+aX);aU[4].Color=aZ;aU[4].Visible=true
else
for aV,aW in ipairs(aU)do aW.Visible=false end
end
end
end

do
if getgenv().ESP and getgenv().ESP.Unload then
pcall(getgenv().ESP.Unload)
end


local aV=gethui or function()return game:GetService"CoreGui"end
local aW=getexecutorname or function()return"Unknown"end
local aX=getcustomasset or getsynasset





local aY=Instance.new local
aZ, a_, a0, a1=Color3.fromRGB, Color3.new, Color3.fromHSV, Color3.fromHex local
a2, a3, a4, a5, a6, a7, a8=table.clear, table.insert, table.remove, table.unpack, table.find, table.sort, table.concat local
a9, ba, bb, bc, bd, be, bf=string.find, string.match, string.format, string.gsub, string.lower, string.upper, string.sub local bg=
task.wait, task.spawn, task.delay, task.defer local
bh, bi, bj, bk=coroutine.wrap, coroutine.close, coroutine.create, coroutine.resume local
bl, bm=os.clock, os.date local
bn, bo, bp, bq=Vector2.new, Vector3.new, Vector3.one, Vector3.zero local
br, bs, bt, bu=UDim2.new, UDim2.fromScale, UDim2.fromOffset, UDim.new local bv=
CFrame.Angles, CFrame.new local
bw, bx, by, bz, bA, bB, bC, bD, bE, bF, bG, bH=math.clamp, math.round, math.floor, math.huge, math.sin, math.cos, math.pi, math.min, math.deg, math.max, math.random, math.abs local
bI, bJ, bK, bL, bM, bN, bO, bP=Drawing and Drawing.new or nil, Rect.new, Font and Font.new or nil, ColorSequence.new, ColorSequenceKeypoint.new, TweenInfo.new, NumberSequence.new, NumberSequenceKeypoint.new local
bQ, bR, bS, bT, bU, bV=game.FindFirstChild, game.GetChildren, game.GetDescendants, game.WaitForChild, game.FindFirstChildWhichIsA, game.IsA

getgenv().ESP={
Settings={
Players={
Enabled=false,
LocalPlayer=false,

Font="Tahoma",
FontSize=12,
FontType="lowercase",

MaxDistance=1000,
RefreshRate=60,

BoundingBox={
Enabled=false,
DynamicBox=true,
IncludeAccessories=false,
Type="Corner",

Rotation=90,
Color={aZ(255,75,114),aZ(255,75,114)},
Transparency={0,0},

Glow={
Enabled=false,
Rotation=90,
Color={aZ(255,75,114),aZ(255,75,114)},
Transparency={0.75,0.75},
},

Fill={
Enabled=false,
Rotation=90,
Color={aZ(255,75,114),aZ(255,75,114)},
Transparency={1,0.5},
},
},

Bars={
HealthBar={
Enabled=false,
Position="Left",
Color={aZ(131,245,78),aZ(255,255,0),aZ(252,71,77)},

Type=function(bW,bX)
if not bV(bW,"Player")then return 1 end
local bY=bX.Humanoid
if not bY or bY.MaxHealth<=0 then return 1 end
return bw(bY.Health/bY.MaxHealth,0,1)
end,

Text={
Enabled=false,
FollowBar=true,
Ending="",
Position="Left",
Color=aZ(255,255,255),
Transparency=0,

Type=function(bW,bX)
if not bV(bW,"Player")then return 100,false end
local bY=bX.Humanoid
if not bY then return 100,false end
return bY.Health,bY.Health~=bY.MaxHealth
end,
},
},

ArmorBar={
Enabled=false,
Position="Bottom",
Color={aZ(52,131,235),aZ(52,131,235),aZ(52,131,235)},

Type=function(bW,bX)
if not bV(bW,"Player")then return 0 end
local bY=bX.Character
local bZ=bY and bY:FindFirstChild"BodyEffects"
local b_=bZ and bZ:FindFirstChild"Armor"
if b_ then
return bw(b_.Value/100,0,1)
end
return 0
end,

Text={
Enabled=false,
FollowBar=true,
Ending="%",
Position="Bottom",
Color=aZ(255,255,255),
Transparency=0,

Type=function(bW,bX)
local bY=bX.Character
local bZ=bY and bY:FindFirstChild"BodyEffects"
local b_=bZ and bZ:FindFirstChild"Armor"
if b_ and b_.Value>0 then
return b_.Value,true
end
return 0,false
end,
},
},
},

Chams={
Enabled=false,
DepthMode=Enum.HighlightDepthMode.AlwaysOnTop,
Fill={aZ(255,75,114),0.5},
Outline={aZ(0,0,0),0.5},
},

Name={
Enabled=false,
UseDisplay=true,
Position="Top",
Color=aZ(255,255,255),
Transparency=0,
},

Distance={
Enabled=false,
Ending="m",
Position="Bottom",
Color=aZ(255,255,255),
Transparency=0,
},

Weapon={
Enabled=false,
Position="Bottom",
Color=aZ(255,255,255),
Transparency=0,
},

Flags={
Enabled=false,
Position="Right",
Color=aZ(255,255,255),
Transparency=0,

Type=function(bW,bX)
local bY={}
if not bV(bW,"Player")then return bY end
local bZ=bX.Character
local b_=bX.Humanoid
if not b_ then return bY end

if b_.MoveDirection.Magnitude>0 then
a3(bY,"moving")
end
if b_.Jump then
a3(bY,"jumping")
end
if isKnocked and isKnocked(bZ)then
a3(bY,"KO")
end
if isGrabbed and isGrabbed(bZ)then
a3(bY,"grabbed")
end
return bY
end
},
},
},

Connections={},
Errors={},
Objects={},
Targets={},
Folder="ESP",
Font=nil,
Holder=nil,
}

local bW=ac.LocalPlayer
local bX=ab.CurrentCamera or bU(ab,"Camera")local bY=
bX.ViewportSize
local bZ=ESP.Connections
local b_=ESP.Objects local b0=
ESP.Drawings
local b1=ESP.Folder
local b2=ESP.Errors
local b3=ESP.Settings
local b4=bX.WorldToViewportPoint
local b5=aW()

local function P(b6)
return b6:gsub("\\","/")
end

do
pcall(function()
local b6=P(b1)
local b7=P(b1 .."/Fonts")

if isfolder and makefolder then
if not isfolder(b6)then
makefolder(b6)
end
if not isfolder(b7)then
makefolder(b7)
end
end
end)
end

local b6={Tahoma=
{Link="https://github.com/LuckyHub1/LuckyHub/raw/main/zekton_rg.ttf"},Minecraftia=
{Link="https://github.com/LuckyHub1/LuckyHub/raw/refs/heads/main/Minecraftia.ttf"},Silkscreen=
{Link="https://github.com/LuckyHub1/LuckyHub/raw/refs/heads/main/Silkscreen.ttf"},
}

do
pcall(function()
local b7=P(b1 .."/Fonts")

if writefile and isfile and aX and game.HttpGet then
for b8,b9 in pairs(b6)do
local ca=P(b7 .."/"..b8 ..".ttf")
local cb=P(b7 .."/"..b8 ..".font")

if not isfile(ca)then
pcall(writefile,ca,game:HttpGet(b9.Link))
end

if not isfile(cb)or b5=="Potassium"then
local cc={
name=b8,
faces={{
name="Regular",
weight=9e9,
style="normal",
assetId=aX(ca)
}}
}
pcall(writefile,cb,ag:JSONEncode(cc))
end
end
end

if not getgenv().Fonts then
getgenv().Fonts={
Loaded={}
}

if listfiles and isfolder and isfolder(b7)and aX then
for b8,b9 in ipairs(listfiles(b7))do
b9=P(b9)
local ca=ba(b9,b7 .."/(.+)%.font")
if ca then
local cb,cc=pcall(aX,b9)
if cb and cc and bK then
Fonts.Loaded[ca]=bK(cc,Enum.FontWeight.Regular)
else
if Font and Font.fromEnum then
Fonts.Loaded[ca]=Font.fromEnum(Enum.Font.SourceSans)
end
end
end
end
end
end
end)
end

local b7={};do
function b7.AddConnection(b8,b9)
local ca=b8:Connect(function(...)
local ca={...}
local cb,cc=pcall(function()bh(b9)(a5(ca))end)
if not cb and not b2[cc]then
b2[cc]=cc
if bZ[Connection]then
bZ[Connection]=nil
end
return Connection and Connection:Disconnect()
end
end)
if ca and bZ then
a3(bZ,ca)
end
return ca
end

function b7.CreateObject(b8,b9,ca)
local cb=aY(b8)
for cc,cd in pairs(b9)do
cb[cc]=cd
end
a3(b_,cb)
return cb
end

function b7.CalculateBox(b8,b9,ca,cb)
if not ca then return 0,0,0,0,false end
local cc=ca.Position
local cd=bV(b9,"Player")

local ce=cd and 2.6 or(ca.Size.Y*0.5)
local cf=cd and 3.2 or(ca.Size.Y*0.5)

local cg,ch=b4(bX,cc+bo(0,ce,0))
local ci,cj=b4(bX,cc-bo(0,cf,0))

if not ch and not cj then
return 0,0,0,0,false
end

local ck=bH(ci.Y-cg.Y)
local cl=by(ck*0.62)
local cm=by(cg.X-(cl*0.5))
local cn=by(bD(cg.Y,ci.Y))

return cl,by(ck),cm,cn,true
end

function b7.GetFontType(b8,b9)
local ca=bd(tostring(b8.FontType or"none"))
if ca=="uppercase"then
return be(b9)
elseif ca=="lowercase"then
return bd(b9)
else
return b9
end
end
end

local b8={};do
function b8.GetCharacter(b9)
if not b9 then return nil end
return b9.Character
end

function b8.GetChildren(b9)
if not b9 then return{}end
return b9:GetChildren()
end

function b8.GetDescendants(b9)
if not b9 then return{}end
return b9:GetDescendants()
end

function b8.GetTool(b9)
if not b9 then return nil end
return nil
end
end

do
local b9={Left=
Enum.TextXAlignment.Right,Right=
Enum.TextXAlignment.Left,Top=
Enum.TextXAlignment.Center,Bottom=
Enum.TextXAlignment.Center,
}

local ca={
Top=bn(0,0),
Bottom=bn(0,0),
Left=bn(0,1),
Right=bn(0,1)
}
local cb={
Top=br(0,0,0,0),
Bottom=br(0,0,0,0),
Left=br(0,0,1,0),
Right=br(0,0,1,0)
}
local cc={
Top=bn(0,0.5),
Bottom=bn(0,0.5),
Left=bn(0.5,0),
Right=bn(0.5,0)
}
local cd={
Top=Enum.TextXAlignment.Right,
Bottom=Enum.TextXAlignment.Right,
Left=Enum.TextXAlignment.Center,
Right=Enum.TextXAlignment.Center
}

local ce={
{br(0,-1,0,-1),br(0.3,0,0,1),bn(0,0),0},
{br(0,-1,0,-1),br(0,1,0.3,0),bn(0,0),180},

{br(1,1,0,-1),br(0.3,0,0,1),bn(1,0),0},
{br(1,1,0,-1),br(0,1,0.3,0),bn(1,0),180},

{br(0,-1,1,1),br(0.3,0,0,1),bn(0,1),0},
{br(0,-1,1,1),br(0,1,0.3,0),bn(0,1),-180},

{br(1,1,1,1),br(0.3,0,0,1),bn(1,1),0},
{br(1,1,1,1),br(0,1,0.3,0),bn(1,1),-180},
}

ESP.Holder=b7.CreateObject("ScreenGui",{
Name="DualESPHolder",
ScreenInsets=Enum.ScreenInsets.DeviceSafeInsets,
ZIndexBehavior=Enum.ZIndexBehavior.Global,
ResetOnSpawn=false,
DisplayOrder=10000,
IgnoreGuiInset=true,
Parent=aV()
})

function ESP.AddTarget(cf,cg)
if cf==nil then return end
if not ESP.Targets[cg]then ESP.Targets[cg]={}end
if ESP.Targets[cg][cf]then return end

local ch={
Objects={},
CharacterObjects={},
CharacterConnection=nil,
ToolConnection={Added=nil,Removed=nil},
CurrentTool="none",
LastTick=bl()
}

local ci=bV(cf,"Player")
bV(cf,"BasePart")
local cj=ch.Objects
local ck=ch.LastTick
local cl=ch.ToolConnection
local cm=ch.CharacterObjects
local cn=b3[cg]
local co=(getgenv().Fonts and getgenv().Fonts.Loaded and getgenv().Fonts.Loaded[cn.Font])or(Font and Font.fromEnum and Font.fromEnum(Enum.Font.Gotham))or(bK and bK(Enum.Font.SourceSans,Enum.FontWeight.Regular))
local cp=cn.FontSize
local cq=ESP.Holder

cm.Character=if ci then(b8.GetCharacter(cf))else cf
cm.Children=b8.GetChildren(cm.Character)
cm.Descendants=b8.GetDescendants(cm.Character)

if ci and cm.Character then
cm.HumanoidRootPart=cm.Character:FindFirstChild"HumanoidRootPart"
cm.Humanoid=cm.Character:FindFirstChildWhichIsA"Humanoid"
end

do
function ch.Init()
if#cj>0 then return end

if ci then
ch.CharacterConnection=b7.AddConnection(cf.CharacterAdded,function(cr)
cm.Character=cr
cm.HumanoidRootPart=bT(cr,"HumanoidRootPart",10)
cm.Humanoid=bT(cr,"Humanoid",10)
cm.Children=b8.GetChildren(cr)
cm.Descendants=b8.GetDescendants(cr)

local cs=cj.Highlight
if cs then
cs.Adornee=cm.Character
cs.Enabled=false
end
end)

if cm.Character then
cl.Added=b7.AddConnection(cm.Character.ChildAdded,function(cr)
if bV(cr,"Tool")then
ch.CurrentTool=cr.Name
end
end)

cl.Removed=b7.AddConnection(cm.Character.ChildRemoved,function(cr)
if bV(cr,"Tool")then
ch.CurrentTool="none"
end
end)

for cr,cs in ipairs(cm.Character:GetChildren())do
if bV(cs,"Tool")then
ch.CurrentTool=cs.Name
break
end
end
end
end

cj.Highlight=b7.CreateObject("Highlight",{
Parent=cm.Character or cq,
Adornee=cm.Character,
Enabled=false,
FillColor=aZ(255,75,114),
FillTransparency=1,
OutlineColor=aZ(0,0,0),
OutlineTransparency=1
})
cj.TargetHolder=b7.CreateObject("Frame",{Parent=cq,Visible=false,BackgroundTransparency=1,Position=br(0,0,0,0),BorderColor3=aZ(0,0,0),Size=br(0,0,0,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
cj.TopHolder=b7.CreateObject("Frame",{Parent=cj.TargetHolder,AutomaticSize=Enum.AutomaticSize.Y,Visible=true,BackgroundTransparency=1,AnchorPoint=bn(0,1),Position=br(0,-2,0,-5),BorderColor3=aZ(0,0,0),Size=br(1,4,0,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
cj.BottomHolder=b7.CreateObject("Frame",{Parent=cj.TargetHolder,AutomaticSize=Enum.AutomaticSize.Y,Visible=true,BackgroundTransparency=1,Position=br(0,-2,1,3),BorderColor3=aZ(0,0,0),Size=br(1,4,0,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
cj.LeftHolder=b7.CreateObject("Frame",{Parent=cj.TargetHolder,AutomaticSize=Enum.AutomaticSize.X,Visible=true,BackgroundTransparency=1,AnchorPoint=bn(1,0),Position=br(0,-4,0,-2),BorderColor3=aZ(0,0,0),Size=br(0,0,1,4),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
cj.RightHolder=b7.CreateObject("Frame",{Parent=cj.TargetHolder,AutomaticSize=Enum.AutomaticSize.X,Visible=true,BackgroundTransparency=1,Position=br(1,8,0,-2),BorderColor3=aZ(0,0,0),Size=br(0,0,1,4),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})

do
cj.TopTextHolder=b7.CreateObject("Frame",{Parent=cj.TopHolder,AutomaticSize=Enum.AutomaticSize.Y,Visible=true,BackgroundTransparency=1,Position=br(0,0,0,0),BorderColor3=aZ(0,0,0),Size=br(1,0,0,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
b7.CreateObject("UIListLayout",{Parent=cj.TopTextHolder,VerticalAlignment=Enum.VerticalAlignment.Bottom,HorizontalAlignment=Enum.HorizontalAlignment.Center,Padding=bu(0,0),SortOrder=Enum.SortOrder.LayoutOrder})
b7.CreateObject("UIPadding",{Parent=cj.TopTextHolder,PaddingBottom=bu(0,2)})

cj.BottomTextHolder=b7.CreateObject("Frame",{Parent=cj.BottomHolder,LayoutOrder=2,AutomaticSize=Enum.AutomaticSize.Y,Visible=true,BackgroundTransparency=1,Position=br(0,0,0,0),BorderColor3=aZ(0,0,0),Size=br(1,0,0,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
b7.CreateObject("UIListLayout",{Parent=cj.BottomTextHolder,HorizontalAlignment=Enum.HorizontalAlignment.Center,Padding=bu(0,0),SortOrder=Enum.SortOrder.LayoutOrder})
b7.CreateObject("UIPadding",{Parent=cj.BottomTextHolder,PaddingTop=bu(0,2)})

cj.LeftTextHolder=b7.CreateObject("Frame",{Parent=cj.LeftHolder,AutomaticSize=Enum.AutomaticSize.XY,Visible=true,BackgroundTransparency=1,Position=br(0,0,0,0),BorderColor3=aZ(0,0,0),Size=br(1,0,0,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
b7.CreateObject("UIListLayout",{Parent=cj.LeftTextHolder,HorizontalAlignment=Enum.HorizontalAlignment.Right,Padding=bu(0,0),SortOrder=Enum.SortOrder.LayoutOrder})
b7.CreateObject("UIPadding",{Parent=cj.LeftTextHolder,PaddingTop=bu(0,-3)})

cj.RightTextHolder=b7.CreateObject("Frame",{Parent=cj.RightHolder,LayoutOrder=2,AutomaticSize=Enum.AutomaticSize.XY,Visible=true,BackgroundTransparency=1,Position=br(0,0,0,0),BorderColor3=aZ(0,0,0),Size=br(0,0,0,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
b7.CreateObject("UIListLayout",{Parent=cj.RightTextHolder,HorizontalAlignment=Enum.HorizontalAlignment.Left,Padding=bu(0,0),SortOrder=Enum.SortOrder.LayoutOrder})
b7.CreateObject("UIPadding",{Parent=cj.RightTextHolder,PaddingTop=bu(0,-3)})
end

do
cj.TopBarHolder=b7.CreateObject("Frame",{Visible=false,Parent=cj.TopHolder,AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Position=br(0,0,0,0),BorderColor3=aZ(0,0,0),Size=br(1,0,0,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
b7.CreateObject("UIListLayout",{Parent=cj.TopBarHolder,HorizontalAlignment=Enum.HorizontalAlignment.Center,Padding=bu(0,1),VerticalAlignment=Enum.VerticalAlignment.Bottom,SortOrder=Enum.SortOrder.LayoutOrder})

cj.BottomBarHolder=b7.CreateObject("Frame",{Visible=false,Parent=cj.BottomHolder,AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Position=br(0,0,0,0),BorderColor3=aZ(0,0,0),Size=br(1,0,0,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
b7.CreateObject("UIListLayout",{Parent=cj.BottomBarHolder,HorizontalAlignment=Enum.HorizontalAlignment.Center,Padding=bu(0,1),VerticalAlignment=Enum.VerticalAlignment.Bottom,SortOrder=Enum.SortOrder.LayoutOrder})
b7.CreateObject("UIPadding",{Parent=cj.BottomBarHolder,PaddingTop=bu(0,2)})

cj.LeftBarHolder=b7.CreateObject("Frame",{Visible=false,Parent=cj.LeftHolder,AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Position=br(0,0,0,0),BorderColor3=aZ(0,0,0),Size=br(0,0,1,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
b7.CreateObject("UIListLayout",{Parent=cj.LeftBarHolder,FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Right,Padding=bu(0,1),SortOrder=Enum.SortOrder.LayoutOrder})
b7.CreateObject("UIPadding",{Parent=cj.LeftBarHolder,PaddingRight=bu(0,1)})

cj.RightBarHolder=b7.CreateObject("Frame",{Visible=false,Parent=cj.RightHolder,AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Position=br(0,0,0,0),BorderColor3=aZ(0,0,0),Size=br(0,0,1,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
b7.CreateObject("UIListLayout",{Parent=cj.RightBarHolder,FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Left,Padding=bu(0,1),SortOrder=Enum.SortOrder.LayoutOrder})
b7.CreateObject("UIPadding",{Parent=cj.RightBarHolder,PaddingLeft=bu(0,-3)})
end

do
b7.CreateObject("UIListLayout",{Parent=cj.TopHolder,VerticalAlignment=Enum.VerticalAlignment.Bottom,Padding=bu(0,3),SortOrder=Enum.SortOrder.LayoutOrder})
b7.CreateObject("UIListLayout",{Parent=cj.BottomHolder,Padding=bu(0,1),SortOrder=Enum.SortOrder.LayoutOrder})
b7.CreateObject("UIPadding",{Parent=cj.LeftHolder,PaddingRight=bu(0,1)})
b7.CreateObject("UIListLayout",{Parent=cj.LeftHolder,FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Left,Padding=bu(0,5),SortOrder=Enum.SortOrder.LayoutOrder})
b7.CreateObject("UIListLayout",{Parent=cj.RightHolder,FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Left,Padding=bu(0,2),SortOrder=Enum.SortOrder.LayoutOrder})
end

do
cj.BoxGlow=b7.CreateObject("ImageLabel",{Parent=cj.TargetHolder,Image="rbxassetid://110204605000367",ScaleType=Enum.ScaleType.Slice,SliceCenter=bJ(bn(21,21),bn(79,79)),AutomaticSize=Enum.AutomaticSize.XY,ImageTransparency=0.65,ResampleMode=Enum.ResamplerMode.Pixelated,Visible=true,BackgroundTransparency=1,Position=br(0,-21,0,-21),BorderColor3=aZ(0,0,0),Size=br(0,0,0,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
cj.BoxGlowGradient=b7.CreateObject("UIGradient",{Parent=cj.BoxGlow,Rotation=90,Color=bL{bM(0,aZ(0,0,0)),bM(1,aZ(0,0,0))},Transparency=bO{bP(0,0),bP(1,0)}})
b7.CreateObject("UIPadding",{Parent=cj.BoxGlow,PaddingTop=bu(0,21),PaddingBottom=bu(0,20),PaddingLeft=bu(0,21),PaddingRight=bu(0,20)})

cj.BoxOutlineHolder=b7.CreateObject("Frame",{Parent=cj.BoxGlow,Visible=false,BackgroundTransparency=1,Position=br(0,0,0,0),BorderColor3=aZ(0,0,0),Size=br(0,0,0,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
cj.BoxOutline=b7.CreateObject("UIStroke",{Parent=cj.BoxOutlineHolder,Thickness=3,LineJoinMode=Enum.LineJoinMode.Miter})
cj.BoxOutlineGradient=b7.CreateObject("UIGradient",{Parent=cj.BoxOutline,Rotation=90,Color=bL{bM(0,aZ(0,0,0)),bM(1,aZ(0,0,0))},Transparency=bO{bP(0,0),bP(1,0)}})

cj.BoxInlineHolder=b7.CreateObject("Frame",{Parent=cj.BoxGlow,Visible=false,BackgroundTransparency=1,Position=br(0,-1,0,-1),BorderColor3=aZ(0,0,0),Size=br(0,0,0,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
cj.BoxInline=b7.CreateObject("UIStroke",{Parent=cj.BoxInlineHolder,Color=aZ(255,255,255),LineJoinMode=Enum.LineJoinMode.Miter})
cj.BoxInlineGradient=b7.CreateObject("UIGradient",{Parent=cj.BoxInline,Rotation=90,Color=bL{bM(0,aZ(0,0,0)),bM(1,aZ(255,255,255))},Transparency=bO{bP(0,0),bP(1,0)}})

cj.BoxFill=b7.CreateObject("Frame",{Parent=cj.BoxGlow,Visible=false,BackgroundTransparency=0,Position=br(0,0,0,0),BorderColor3=aZ(0,0,0),Size=br(0,0,0,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
cj.BoxFillGradient=b7.CreateObject("UIGradient",{Parent=cj.BoxFill,Rotation=90,Color=bL{bM(0,aZ(0,0,0)),bM(1,aZ(255,255,255))},Transparency=bO{bP(0,1),bP(1,1)}})
end

do
cj.CornerHolder=b7.CreateObject("Frame",{Parent=cj.BoxGlow,Visible=false,BackgroundTransparency=1,Position=br(0,-1,0,-1),BorderColor3=aZ(0,0,0),Size=br(0,0,0,0),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})

for cr=1,8 do
local cs=ce[cr]
cj["Line_"..cr]=b7.CreateObject("Frame",{
Parent=cj.CornerHolder,
Visible=false,
BackgroundTransparency=0,
Position=cs[1],
Size=cs[2],
AnchorPoint=cs[3],
Rotation=cs[4],
BorderColor3=aZ(0,0,0),
BorderSizePixel=0,
BackgroundColor3=aZ(255,255,255)
})
b7.CreateObject("UIStroke",{Parent=cj["Line_"..cr],Thickness=1,LineJoinMode=Enum.LineJoinMode.Miter})
end
end

do
for cr,cs in pairs(cn.Bars)do
cj[cr.."Outline"]=b7.CreateObject("Frame",{Parent=cj[cs.Position.."BarHolder"],ZIndex=5,LayoutOrder=0,Visible=true,BackgroundTransparency=0,Position=br(0,0,0,0),BorderColor3=aZ(0,0,0),Size=br(1,0,0,1),BorderSizePixel=0,BackgroundColor3=aZ(0,0,0)})
b7.CreateObject("UIStroke",{Parent=cj[cr.."Outline"],Thickness=1,LineJoinMode=Enum.LineJoinMode.Miter})

cj[cr]=b7.CreateObject("Frame",{Parent=cj[cr.."Outline"],ZIndex=6,LayoutOrder=0,Visible=true,BackgroundTransparency=0,Position=br(0,0,0,0),BorderColor3=aZ(0,0,0),Size=br(1,0,0,1),BorderSizePixel=0,BackgroundColor3=aZ(255,255,255)})
cj[cr.."Gradient"]=b7.CreateObject("UIGradient",{Parent=cj[cr],Rotation=90,Color=bL{bM(0,aZ(0,0,0)),bM(0,aZ(0,0,0)),bM(1,aZ(255,255,255))},Transparency=bO{bP(0,0),bP(1,0)}})

local ct=b7.CreateObject("TextLabel",{
Parent=cj[cs.Position.."TextHolder"],
TextSize=cp,
LayoutOrder=2,
TextColor3=aZ(255,255,255),
Text="",
AnchorPoint=bn(0,1),
BorderSizePixel=0,
Visible=false,
BackgroundTransparency=1,
ZIndex=5,
AutomaticSize=Enum.AutomaticSize.Y,
Size=br(1,0,0,0)
})
if co then pcall(function()ct.FontFace=co end)end
cj[cr.."Text"]=ct
b7.CreateObject("UIStroke",{Parent=cj[cr.."Text"],Color=aZ(0,0,0),LineJoinMode=Enum.LineJoinMode.Miter})
end
end

do
local cr=b7.CreateObject("TextLabel",{
Parent=cj.TopTextHolder,
TextSize=cp,
LayoutOrder=2,
TextColor3=aZ(255,255,255),
Text="",
AnchorPoint=bn(0,1),
BorderSizePixel=0,
Visible=false,
BackgroundTransparency=1,
ZIndex=5,
AutomaticSize=Enum.AutomaticSize.Y,
Size=br(1,0,0,0)
})
if co then pcall(function()cr.FontFace=co end)end
cj.TargetName=cr
b7.CreateObject("UIStroke",{Parent=cj.TargetName,Color=aZ(0,0,0),LineJoinMode=Enum.LineJoinMode.Miter})

local cs=b7.CreateObject("TextLabel",{
Parent=cj.BottomTextHolder,
TextSize=cp,
LayoutOrder=2,
TextColor3=aZ(255,255,255),
Text="",
AnchorPoint=bn(0,1),
BorderSizePixel=0,
Visible=false,
BackgroundTransparency=1,
ZIndex=5,
AutomaticSize=Enum.AutomaticSize.Y,
Size=br(1,0,0,0)
})
if co then pcall(function()cs.FontFace=co end)end
cj.Distance=cs
b7.CreateObject("UIStroke",{Parent=cj.Distance,Color=aZ(0,0,0),LineJoinMode=Enum.LineJoinMode.Miter})

local ct=b7.CreateObject("TextLabel",{
Parent=cj.RightTextHolder,
TextSize=cp,
LayoutOrder=2,
TextColor3=aZ(255,255,255),
Text="",
AnchorPoint=bn(0,1),
BorderSizePixel=0,
Visible=false,
BackgroundTransparency=1,
ZIndex=5,
AutomaticSize=Enum.AutomaticSize.Y,
Size=br(1,0,0,0)
})
if co then pcall(function()ct.FontFace=co end)end
cj.Flags=ct
b7.CreateObject("UIStroke",{Parent=cj.Flags,Color=aZ(0,0,0),LineJoinMode=Enum.LineJoinMode.Miter})

local cu=b7.CreateObject("TextLabel",{
Parent=cj.BottomTextHolder,
TextSize=cp,
LayoutOrder=2,
TextColor3=aZ(255,255,255),
Text="none",
AnchorPoint=bn(0,1),
BorderSizePixel=0,
Visible=false,
BackgroundTransparency=1,
ZIndex=5,
AutomaticSize=Enum.AutomaticSize.Y,
Size=br(1,0,0,0)
})
if co then pcall(function()cu.FontFace=co end)end
cj.Weapon=cu
b7.CreateObject("UIStroke",{Parent=cj.Weapon,Color=aZ(0,0,0),LineJoinMode=Enum.LineJoinMode.Miter})
end

if cj.Highlight then
cj.Highlight.Enabled=false
end
ESP.Targets[cg][cf]=ch
end

function ch.Update()
if not cn.Enabled then
cj.TargetHolder.Visible=false
cj.Highlight.Enabled=false
return
end

local cr=bl()
if(cr-ck)<(1/cn.RefreshRate)then return end
ck=cr

if(not cn.LocalPlayer)and cf==bW then
cj.TargetHolder.Visible=false
cj.Highlight.Enabled=false
return
end
if not cm.Character then
cj.TargetHolder.Visible=false
cj.Highlight.Enabled=false
return
end

if az.Visuals.ESP.TeamCheck and cf~=bW and cf.Team and bW.Team and cf.Team==bW.Team then
cj.TargetHolder.Visible=false
cj.Highlight.Enabled=false
return
end

if ci then
if not cm.HumanoidRootPart or not cm.HumanoidRootPart.Parent then
if cm.Character then
cm.HumanoidRootPart=bQ(cm.Character,"HumanoidRootPart")
end
if not cm.HumanoidRootPart then
cj.TargetHolder.Visible=false
cj.Highlight.Enabled=false
return
end
end

if not cm.Humanoid or not cm.Humanoid.Parent then
if cm.Character then
cm.Humanoid=bU(cm.Character,"Humanoid")
end
if not cm.Humanoid or cm.Humanoid.Health<=0 then
cj.TargetHolder.Visible=false
cj.Highlight.Enabled=false
return
end
elseif cm.Humanoid.Health<=0 then
cj.TargetHolder.Visible=false
cj.Highlight.Enabled=false
return
end
else
if not cm.HumanoidRootPart then
if bV(cf,"BasePart")then
cm.HumanoidRootPart=cf
elseif cm.Character and cm.Character.PrimaryPart then
cm.HumanoidRootPart=cm.Character.PrimaryPart
end
if not cm.HumanoidRootPart then
cj.TargetHolder.Visible=false
cj.Highlight.Enabled=false
return
end
end
end

local cs=(bX.CFrame.Position-cm.HumanoidRootPart.Position).Magnitude
if cs>cn.MaxDistance then
cj.TargetHolder.Visible=false
cj.Highlight.Enabled=false
return
end

local ct,cu,cv,cw,cx=b7.CalculateBox(cn,cf,cm.HumanoidRootPart,cm.Character)

if not cx then
cj.TargetHolder.Visible=false
cj.Highlight.Enabled=false
return
end

local cy=az.Targeting.Priority[cf.UserId]==true
local cz=az.Targeting.Friends[cf.UserId]==true

local cA,cB=bt(by(ct),by(cu)),bt(by(cv),by(cw))
local cC=cj.TargetHolder
cC.Visible=true
if cC.Position~=cB then cC.Position=cB end
if cC.Size~=cA then cC.Size=cA end

local cD,cE,cF,cG=cj.BoxOutline,cj.BoxInline,cj.BoxFill,cj.BoxGlow
local cH,cI,cJ,cK,cL=cn.BoundingBox.Enabled,cn.BoundingBox.Color,cn.BoundingBox.Transparency,cn.BoundingBox.Rotation,cn.BoundingBox.Type

local cM=cy and aZ(255,215,0)or(cz and aZ(0,230,180)or cI[1])
local cN=cy and aZ(255,215,0)or(cz and aZ(0,230,180)or cI[2])

if cH then
local cO=cj.BoxGlowGradient local
cP, cQ, cR, cS=cn.BoundingBox.Glow.Enabled, cn.BoundingBox.Glow.Color, cn.BoundingBox.Glow.Transparency, cn.BoundingBox.Glow.Rotation

if cP then
cG.ImageTransparency=0
cO.Rotation=cS
cO.Color=bL{bM(0,cM),bM(1,cN)}
cO.Transparency=bO{bP(0,cR[1]),bP(1,cR[2])}
else
cG.ImageTransparency=1
end

if cL=="2D"then
cD.Parent.Visible=true
cD.Parent.Size=bt(ct,cu)
cE.Parent.Visible=true
cE.Parent.Size=bt(ct+2,cu+2)

local cT,cU=cj.BoxInlineGradient,cj.BoxOutlineGradient
cT.Color=bL{bM(0,cM),bM(1,cN)}
cT.Transparency=bO{bP(0,cJ[1]),bP(1,cJ[2])}
cT.Rotation=cK

cU.Transparency=bO{bP(0,cJ[1]),bP(1,cJ[2])}
cU.Rotation=cK

local cV=cj.BoxFillGradient local
cW, cX, cY=cn.BoundingBox.Fill.Color, cn.BoundingBox.Fill.Transparency, cn.BoundingBox.Fill.Rotation

cF.Visible=cn.BoundingBox.Fill.Enabled
cF.Size=bt(ct,cu)
cV.Rotation=cY
cV.Color=bL{bM(0,cM),bM(1,cN)}
cV.Transparency=bO{bP(0,cX[1]),bP(1,cX[2])}
if cj.CornerHolder then cj.CornerHolder.Visible=false end
else
cD.Parent.Visible=false
cE.Parent.Visible=false
cF.Visible=false

local cT=cj.CornerHolder
cT.Visible=true
cT.Size=bt(ct+2,cu+2)

for cU=1,8 do
local cV=cj["Line_"..cU]
cV.UIStroke.Transparency=cJ[1]
cV.BackgroundColor3=cM
cV.BackgroundTransparency=cJ[1]
cV.Visible=true
end
end
else
cG.ImageTransparency=1
cD.Parent.Visible=false
cE.Parent.Visible=false
cF.Visible=false
if cj.CornerHolder then cj.CornerHolder.Visible=false end

for cO=1,8 do
local cP=cj["Line_"..cO]
cP.Visible=false
end
end

for cO,cP in pairs(cn.Bars)do
local cQ,cR,cS=cj[cO],cj[cO.."Outline"],cj[cO.."Gradient"]
local cT,cU=cP.Enabled,cP.Color
local cV=cP.Position or"Left"
local cW=cj[cV.."BarHolder"]

if cT and ci then
local cX=cP.Type(cf,cm)
cW.Visible=true

cQ.AnchorPoint=ca[cV]or bn(0,1)
cQ.Position=cb[cV]or br(0,0,1,0)

if cV=="Left"or cV=="Right"then
cQ.Size=br(0,1,cX,0)
cR.Size=br(0,1,1,0)
cS.Rotation=90
cS.Offset=bn(0,cX-1)
else
cQ.Size=br(cX,0,0,1)
cR.Size=br(1,0,0,1)
cS.Rotation=-180
cS.Offset=bn(1-cX,0)
end

if cR.Parent~=cW then
cR.Parent=cW
end
cS.Color=bL{bM(0,cU[1]),bM(0.5,cU[2]),bM(1,cU[3])}
else
cW.Visible=false
end

local cX=cj[cO.."Text"]
local cY,cZ,c_=cP.Text.Enabled,cP.Text.Color,cP.Text.Transparency

if cY and ci then
local c0,c1=cP.Text.Type(cf,cm)

cX.Text=tostring(by(c0))..tostring(cP.Text.Ending)
cX.TextColor3=cZ
cX.TextTransparency=c_
cX.UIStroke.Transparency=c_

if cP.Text.FollowBar then
cX.Visible=c1
if cX.Parent~=cQ then
cX.Parent=cQ
end
cX.ZIndex=10
cX.TextXAlignment=cd[cV]or Enum.TextXAlignment.Center
cX.AnchorPoint=cc[cV]or bn(0.5,0)
else
cX.Visible=true
local c2=cj[cP.Text.Position.."TextHolder"]
if cX.Parent~=c2 then
cX.Parent=c2
end
cX.TextXAlignment=b9[cP.Text.Position]
cX.AnchorPoint=bn(0,0)
end
else
cX.Visible=false
end
end

local cO=cj.Highlight
local cP,cQ,cR=cn.Chams.Enabled,cn.Chams.Fill,cn.Chams.Outline

if cP then
cO.Enabled=true
cO.DepthMode=cn.Chams.DepthMode
cO.FillColor=cy and aZ(255,215,0)or(cz and aZ(0,230,180)or cQ[1])
cO.FillTransparency=cQ[2]
cO.OutlineColor=cR[1]
cO.OutlineTransparency=cR[2]
else
cO.Enabled=false
end

local cS=cj.TargetName
local cT,cU,cV=cn.Name.Enabled,cn.Name.Color,cn.Name.Transparency

if cT then
local cW=if cn.Name.UseDisplay then(ci and cf.DisplayName or cf.Name)else cf.Name

cS.Visible=true
cS.Text=b7.GetFontType(cn,cW)
cS.TextXAlignment=b9[cn.Name.Position]
cS.Parent=cj[cn.Name.Position.."TextHolder"]
cS.TextColor3=cy and aZ(255,215,0)or(cz and aZ(0,230,180)or cU)
cS.TextTransparency=cV
cS.UIStroke.Transparency=cV
else
cS.Visible=false
end

local cW=cj.Distance
local cX,cY,cZ=cn.Distance.Enabled,cn.Distance.Color,cn.Distance.Transparency

if cX then
cW.Visible=true
cW.TextXAlignment=b9[cn.Distance.Position]
cW.Parent=cj[cn.Distance.Position.."TextHolder"]
cW.TextColor3=cY
cW.TextTransparency=cZ
cW.UIStroke.Transparency=cZ
cW.Text=b7.GetFontType(cn,tostring(by(cs))..tostring(cn.Distance.Ending))
else
cW.Visible=false
end

local c_=cj.Weapon
local c0,c1,c2=cn.Weapon.Enabled,cn.Weapon.Color,cn.Weapon.Transparency

if ci and c0 then
local c3=b8.GetTool(cf)or ch.CurrentTool

c_.Visible=true
c_.TextXAlignment=b9[cn.Weapon.Position]
c_.Parent=cj[cn.Weapon.Position.."TextHolder"]
c_.TextColor3=c1
c_.TextTransparency=c2
c_.UIStroke.Transparency=c2
c_.Text=b7.GetFontType(cn,c3)
else
c_.Visible=false
end

local c3=cj.Flags
local c4,k,l=cn.Flags.Enabled,cn.Flags.Color,cn.Flags.Transparency

if c4 then
local m=cn.Flags.Type(cf,cm)
c3.Visible=true
c3.TextXAlignment=b9[cn.Flags.Position]
c3.Parent=cj[cn.Flags.Position.."TextHolder"]
c3.TextColor3=k
c3.TextTransparency=l
c3.UIStroke.Transparency=l
c3.Text=a8(m,"\n")
else
c3.Visible=false
end
end

function ch.Remove()
for cr,cs in pairs(cj)do
pcall(function()cs:Destroy()end)
end

if ch.CharacterConnection then
pcall(function()ch.CharacterConnection:Disconnect()end)
ch.CharacterConnection=nil
end

if cl.Added then
pcall(function()cl.Added:Disconnect()end)
cl.Added=nil
end

if cl.Removed then
pcall(function()cl.Removed:Disconnect()end)
cl.Removed=nil
end

ESP.Targets[cg][cf]=nil
end
end

ch.Init()
if ch.Objects.Highlight then
ch.Objects.Highlight.Enabled=false
end
if ch.Objects.TargetHolder then
ch.Objects.TargetHolder.Visible=false
end
end

function ESP.RemoveTarget(cf,cg)
for ch,ci in pairs(ESP.Settings)do
if ESP.Targets[ch]then
for cj,ck in pairs(ESP.Targets[ch])do
if cj==cf then
ck.Remove()
end
end
end
end
end

function ESP.Init()
for cf,cg in pairs(b3)do
if not ESP.Targets[cf]then ESP.Targets[cf]={}end
end
end

function ESP.Unload()
for cf,cg in ipairs(bZ)do
pcall(function()cg:Disconnect()end)
end
a2(bZ)

for cf,cg in ipairs(b_)do
pcall(function()cg:Destroy()end)
end
a2(b_)

if ESP.Holder then
pcall(function()ESP.Holder:Destroy()end)
end

getgenv().Fonts=nil
end
end

do
ESP.Init()

for b9,ca in ipairs(ac:GetPlayers())do
ESP.AddTarget(ca,"Players")
end

b7.AddConnection(ac.PlayerAdded,function(b9)
pcall(function()b9.CharacterAdded:Wait()end)
ESP.AddTarget(b9,"Players")
end)

b7.AddConnection(ac.PlayerRemoving,function(b9)
ESP.RemoveTarget(b9,"Players")
end)

local b9=ad.PreRender or ad.RenderStepped
local ca=ESP.Targets.Players
b7.AddConnection(b9,function()
local cb=b3.Players
if not cb or not cb.Enabled then return end
if not ca then
ca=ESP.Targets.Players
if not ca then return end
end
for cc,cd in pairs(ca)do
cd.Update()
end
end)

registerCleanup(function()
if getgenv().ESP and getgenv().ESP.Unload then
pcall(getgenv().ESP.Unload)
end
end)
end
end


local aV={Zombie=
{idle1="10921344533",idle2="10921345304",run="616163682",walk="616168032",jump="616161997",fall="616157476"},Ninja=
{idle1="656117400",idle2="656118341",run="616118852",walk="656121766",jump="656117878",fall="656115606"},Robot=
{idle1="616136790",idle2="616138447",run="616140816",walk="616146177",jump="616139451",fall="616134815"},Levitate=
{idle1="616006778",idle2="616008087",run="616010382",walk="616013216",jump="616008936",fall="616005863"},Cartoony=
{idle1="742637544",idle2="742638445",run="742638842",walk="742640026",jump="742637942",fall="742637151"},
["Super Hero"]={idle1="616111295",idle2="616113536",run="616117076",walk="616122287",jump="616115533",fall="616118211"},Elder=
{idle1="845397899",idle2="845400520",run="845386501",walk="845403856",jump="845398858",fall="845396048"},Toy=
{idle1="782841498",idle2="782845736",run="782842708",walk="782843345",jump="782847020",fall="782846423"},
["Old School"]={idle1="5319828216",idle2="5319831086",run="5319844329",walk="5319847204",jump="5319841935",fall="5319839762"},Stylish=
{idle1="616136790",idle2="616138447",run="616140816",walk="616146177",jump="616139451",fall="616134815"},Default=
{idle1="507766388",idle2="507766666",run="507767714",walk="507777826",jump="507765000",fall="507767968"}
}

local function applyAnimationPreset(aW)
local aX=ah.Character
if not aX then return end
local aY=aX:FindFirstChild"Animate"
if not aY then return end
local aZ=aV[aW]or aV.Default

local function setTrack(a_,a0)
local a1=aY
for a2,a3 in ipairs(a_)do
a1=a1 and a1:FindFirstChild(a3)
end
if a1 and a1:IsA"Animation"then
a1.AnimationId="rbxassetid://"..a0
end
end

setTrack({"idle","Animation1"},aZ.idle1)
setTrack({"idle","Animation2"},aZ.idle2)
setTrack({"run","RunAnim"},aZ.run)
setTrack({"walk","WalkAnim"},aZ.walk)
setTrack({"jump","JumpAnim"},aZ.jump)
setTrack({"fall","FallAnim"},aZ.fall)

local a_=aX:FindFirstChildOfClass"Humanoid"
if a_ then
for a0,a1 in ipairs(a_:GetPlayingAnimationTracks())do
pcall(function()a1:Stop(0)end)
end
end
pcall(function()
aY.Disabled=true
task.wait()
aY.Disabled=false
end)
end
local function setupAnimationRespawn(aW)
if not aW then return end
task.spawn(function()
local aX=aW:WaitForChild("Animate",6)
local aY=aW:WaitForChild("Humanoid",6)
if aX and aY and az.Client.AnimationChanger and az.Client.SelectedAnimation and az.Client.SelectedAnimation~="Default"then
task.wait(0.2)
applyAnimationPreset(az.Client.SelectedAnimation)
end
end)
end


local aW=0
local aX

local aY={
Rust="rbxassetid://1255040462",
Neverlose="rbxassetid://6534947240",
Skeet="rbxassetid://4817809188",
Bubble="rbxassetid://6534947588",
Bell="rbxassetid://6534947869",
Hitmarker="rbxassetid://160432334"
}

local function playHitSound()
if not az.Client.HitSounds then return end
local aZ=aY[az.Client.HitSoundPreset]
if(not aZ or aZ=="")and az.Client.CustomHitSoundId and az.Client.CustomHitSoundId~=""then
aZ=az.Client.CustomHitSoundId
end
if not aZ or aZ==""then aZ=aY.Rust end
if not aZ:find"rbxassetid://"and tonumber(aZ)then
aZ="rbxassetid://"..aZ
end

local a_=Instance.new"Sound"
a_.Name="FutureHitSound"
a_.SoundId=aZ
a_.Volume=(az.Client.HitSoundVolume or 80)/100
a_.Parent=game:GetService"SoundService"
a_:Play()
a_.Ended:Connect(function()
a_:Destroy()
end)
task.delay(2.5,function()
if a_ and a_.Parent then a_:Destroy()end
end)
end

local function spawnDamageNumber(aZ,a_)
if not az.Client.DamageNumbers or not aZ then return end
local a0=aZ:FindFirstChild"Head"or aZ:FindFirstChild"HumanoidRootPart"
if not a0 then return end

local a1=Instance.new"BillboardGui"
a1.Name="DamageIndicator"
a1.Adornee=a0
a1.Size=UDim2.new(0,100,0,40)
a1.StudsOffset=al(as(-15,15)/10,2+as(0,10)/10,as(-15,15)/10)
a1.AlwaysOnTop=true
a1.ResetOnSpawn=false

local a2=Instance.new"TextLabel"
a2.Size=UDim2.new(1,0,1,0)
a2.BackgroundTransparency=1
a2.Font=Enum.Font.GothamBlack
a2.TextSize=20
a2.TextColor3=az.Client.DamageNumbersColor or aq(255,75,114)
a2.TextStrokeTransparency=0
a2.TextStrokeColor3=Color3.fromRGB(0,0,0)
a2.Text="-"..tostring(a_)
a2.Parent=a1

local a3=ah:FindFirstChildOfClass"PlayerGui"
if a3 then
a1.Parent=a3
else
a1.Parent=ab
end

local a4=az.Client.DamageDuration or 1.0
local a5=game:GetService"TweenService"
local a6=TweenInfo.new(a4,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
local a7=a5:Create(a1,a6,{StudsOffset=a1.StudsOffset+al(0,3,0)})
local a8=a5:Create(a2,a6,{TextTransparency=1,TextStrokeTransparency=1})

a7:Play()
a8:Play()
task.delay(a4,function()
a1:Destroy()
end)
end

local function onEnemyHitRegistered(aZ,a_,a0)
playHitSound()
spawnDamageNumber(a0,a_)
if az.Client.HitNotifications then
ax:Notify{
Title="Hit Confirmed",
Description=(aZ and aZ.Name or"Enemy").." hit for -"..tostring(a_).." HP",
Duration=1.5
}
end
end

local aZ={}
local function trackEnemyHealth(a_)
if a_==ah then return end
local function onChar(a0)
if not a0 then return end
local a1=a0:WaitForChild("Humanoid",5)
if not a1 then return end
aZ[a_]=a1.Health
a1.HealthChanged:Connect(function(a2)
local a3=aZ[a_]or a1.MaxHealth
aZ[a_]=a2
local a4=a3-a2
if a4>0.5 then
local a5=tick()-aW
local a6=(aX==a_)or(aL.Player==a_)or(aM.Player==a_)
if a6 and a5<0.65 then
onEnemyHitRegistered(a_,au(a4+0.5),a0)
elseif a5<0.3 then
onEnemyHitRegistered(a_,au(a4+0.5),a0)
end
end
end)
end
if a_.Character then onChar(a_.Character)end
a_.CharacterAdded:Connect(onChar)
end

for a_,a0 in ipairs(ac:GetPlayers())do
trackEnemyHealth(a0)
end
ac.PlayerAdded:Connect(trackEnemyHealth)

local function hookLocalTools(a_)
if not a_ then return end
for a0,a1 in ipairs(a_:GetChildren())do
if a1:IsA"Tool"then
a1.Activated:Connect(function()
aW=tick()
if aL.Player then aX=aL.Player end
end)
end
end
a_.ChildAdded:Connect(function(a0)
if a0:IsA"Tool"then
a0.Activated:Connect(function()
aW=tick()
if aL.Player then aX=aL.Player end
end)
end
end)
end

local function onCharacterSpawn(a_)
if not a_ then return end
onCharacterAddedSpeedJump(a_)
stopFakeMacro()
bindToolTracking(a_)
setupAnimationRespawn(a_)
hookLocalTools(a_)
end

registerCleanup(ah.CharacterAdded:Connect(onCharacterSpawn))
if ah.Character then
task.spawn(function()
onCharacterSpawn(ah.Character)
end)
end


local a_=0

registerCleanup(ad.RenderStepped:Connect(function()
resolveCamlockTarget()

if isSilentAimActive()then
local a0,a1=getClosestSilentTarget()
if a0 and a1 then
aL.Player=a0
aL.Part=a1
else
aL.Player=nil
aL.Part=nil
end
else
aL.Player=nil
aL.Part=nil
end

if az.Aiming.Camlock.Enabled and az.Aiming.Camlock.Active and aM.Part then
local a0=aM.Part
local a1=az.Aiming.Camlock.Prediction
local a2=(a1 and a1~="Off"and a1~=false)

local a3=(az.Aiming.Camlock.Resolver and az.Aiming.Camlock.ResolverMode=="Recalculation")
local a4=getEffectiveVelocity(aM.Player,aM.Part,az.Aiming.Camlock.Resolver,az.Aiming.Camlock.ResolverMode,a3)

local a5=am
if a2 then
local a6=az.Aiming.Camlock.PredictionAmount or 0.138
if a1=="Directional"then
local a7=(a4.X>0)and(az.Aiming.Camlock.PredictionX_Right or a6)
or(az.Aiming.Camlock.PredictionX_Left or a6)
local a8=(a4.Y>0)and(az.Aiming.Camlock.PredictionY_Up or a6)
or(az.Aiming.Camlock.PredictionY_Down or a6)
local a9=az.Aiming.Camlock.PredictionZ or a6
a5=al(a4.X*a7,a4.Y*a8,a4.Z*a9)
elseif a1=="Auto"then
local a7=50
pcall(function()
local a8=game:GetService"Stats".Network.ServerStatsItem["Data Ping"]
if a8 then
local a9=a8:GetValueString()
local ba=tonumber(string.match(a9,"%d+"))
if ba then a7=ba end
end
end)
local a8=ar(a7*0.0016,0.05,0.28)
a5=a4*a8
else
a5=a4*a6
end
end
local a6=a0.Position+a5

if az.Aiming.Camlock.Shake then
local a7=az.Aiming.Camlock.ShakeAmount/100
a6=a6+al(as(-10,10),as(-10,10),as(-10,10))*a7
end

local a7=ar(az.Aiming.Camlock.Smoothness or 1,0.01,1)

if az.Aiming.Camlock.Method=="CFrame"then
if a7>=1 then
ai.CFrame=ao(ai.CFrame.Position,a6)
else
ai.CFrame=ai.CFrame:Lerp(ao(ai.CFrame.Position,a6),a7)
end
elseif az.Aiming.Camlock.Method=="mousemoverel"and mousemoverel then
local a8,a9=ai:WorldToViewportPoint(a6)
if a9 then
local ba=ae:GetMouseLocation()
local bb=(a8.X-ba.X)*a7
local bc=(a8.Y-ba.Y)*a7
mousemoverel(bb,bc)
end
end
end
local a0=ae:GetMouseLocation()
local a1=ai.ViewportSize/2
local a2=ae.MouseBehavior
local a3=(a2==Enum.MouseBehavior.LockCenter or a2==Enum.MouseBehavior.LockCurrentPosition)

if aR then
aR.Visible=az.Aiming.Camlock.Enabled and az.Aiming.Camlock.ShowFOV
aR.Radius=az.Aiming.Camlock.FOVRadius
local a4=(az.Aiming.Camlock.FOVOrigin=="Screen Center"or a3)and a1 or a0
aR.Position=a4
aR.Color=az.Aiming.Camlock.FOVColor
end
if aS then
local a4=az.Aiming.Silent.SyncFOV and az.Aiming.Camlock.Enabled
local a5=a4 and az.Aiming.Camlock.FOVRadius or az.Aiming.Silent.FOVRadius
local a6=az.Aiming.Silent.Enabled and az.Aiming.Silent.ShowFOV and(not a4 or not(az.Aiming.Camlock.Enabled and az.Aiming.Camlock.ShowFOV))
aS.Visible=a6
aS.Radius=a5
local a7=a4 and az.Aiming.Camlock.FOVOrigin or az.Aiming.Silent.FOVOrigin
local a8=(a7=="Screen Center"or a3)and a1 or a0
aS.Position=a8
aS.Color=az.Aiming.Silent.FOVColor
end

if aT then
local a4=(isSilentAimActive()and aL.Part)or nil
local a5=az.Aiming.Silent.TargetTracer and a4~=nil
if a5 then
local a6,a7=ai:WorldToViewportPoint(a4.Position)
if a7 then
local a8=az.Aiming.Silent.TracerOrigin or"Bottom"
local a9
if a8=="Screen Center"then
a9=ai.ViewportSize/2
elseif a8=="Mouse"then
a9=a0
else
a9=ak(ai.ViewportSize.X/2,ai.ViewportSize.Y)
end
aT.From=a9
aT.To=ak(a6.X,a6.Y)
aT.Color=az.Aiming.Silent.TracerColor or aq(255,75,114)
aT.Thickness=az.Aiming.Silent.TracerThickness or 1.5
aT.Visible=true
else
aT.Visible=false
end
else
aT.Visible=false
end
end

if az.Aiming.Triggerbot.Enabled and(az.Aiming.Triggerbot.Keybind==Enum.KeyCode.Unknown or az.Aiming.Triggerbot.Active)then
local a4=az.Aiming.Triggerbot.OnlyWhenSilent
local a5=az.Aiming.Triggerbot.OnlyWhenLock
local a6=az.Aiming.Silent.Enabled and aL.Player and aL.Part
local a7=az.Aiming.Camlock.Enabled and az.Aiming.Camlock.Active and aM.Player and aM.Part

local a8=true
if a4 and a5 then
if not a6 and not a7 then a8=false end
elseif a4 then
if not a6 then a8=false end
elseif a5 then
if not a7 then a8=false end
end

if a8 and(tick()-a_)>=(az.Aiming.Triggerbot.Delay/1000)then
local a9=ah.Character and ah.Character:FindFirstChildOfClass"Tool"
local ba=getToolRange(a9)
local bb=ba or 1000

local bc=false
local bd

local function isTriggerTargetValid(be,bf,bh)
if not be or not bf or be==ah then return false end
local bi=bf:FindFirstChildOfClass"Humanoid"
if not bi or bi.Health<=0 then return false end
if az.Aiming.Triggerbot.PriorityOnly and not isPriorityPlayer(be)then return false end
if az.Aiming.Triggerbot.KOCheck and isKnocked(bf)then return false end
if az.Aiming.Triggerbot.GrabbedCheck and isGrabbed(bf)then return false end
if az.Aiming.Triggerbot.FriendCheck and isFriend(be)then return false end
if az.Aiming.Triggerbot.CrewCheck and isCrew(be)then return false end
if az.Aiming.Triggerbot.TeamCheck and(be.Team and ah.Team and be.Team==ah.Team)then return false end
if az.Aiming.Triggerbot.ForceFieldCheck and hasForceField(bf)then return false end
if az.Aiming.Triggerbot.WallCheck and bh and not isVisible(bh,ai.CFrame.Position)then return false end
return true
end

if a6 and(a4 or az.Aiming.Triggerbot.FireOnSilentTarget)and isPriorityPlayer(aL.Player)then
local be=aL.Player
local bf=be.Character
if isTriggerTargetValid(be,bf,aL.Part)then
local bh=(aL.Part.Position-ai.CFrame.Position).Magnitude
if bh<=bb then
bc=true
bd=be
end
end
end

if not bc and a7 and isPriorityPlayer(aM.Player)then
local be=aM.Player
local bf=be.Character
if isTriggerTargetValid(be,bf,aM.Part)then
local bh=(aM.Part.Position-ai.CFrame.Position).Magnitude
if bh<=bb then
bc=true
bd=be
end
end
end

if not bc and not a4 and not a5 then
local be=ai:ViewportPointToRay(a0.X,a0.Y)
aK.FilterDescendantsInstances={ai,ah.Character}
local bf=ab:Raycast(be.Origin,be.Direction*bb,aK)
if bf and bf.Instance then
local bh=bf.Instance:FindFirstAncestorOfClass"Model"
local bi=bh and ac:GetPlayerFromCharacter(bh)
if bi and isPriorityPlayer(bi)and isTriggerTargetValid(bi,bh,bf.Instance)then
bc=true
bd=bi
end
end

if not bc and az.Aiming.Triggerbot.TolerancePX and az.Aiming.Triggerbot.TolerancePX>0 then
local bh=az.Aiming.Triggerbot.TolerancePX
local bi=bh
local bj
for bk,bl in ipairs(ac:GetPlayers())do
if bl~=ah and bl.Character and isPriorityPlayer(bl)then
local bm=bl.Character
if isTriggerTargetValid(bl,bm,nil)then
local bn={bm:FindFirstChild"Head",bm:FindFirstChild"HumanoidRootPart",bm:FindFirstChild"UpperTorso"or bm:FindFirstChild"Torso"}
for bo,bp in ipairs(bn)do
if bp and bp:IsA"BasePart"then
local bq=(bp.Position-ai.CFrame.Position).Magnitude
if bq<=bb then
local br,bs=ai:WorldToViewportPoint(bp.Position)
if bs then
local bt=(ak(br.X,br.Y)-a0).Magnitude
if bt<=bi and(not az.Aiming.Triggerbot.WallCheck or isVisible(bp,ai.CFrame.Position))then
bi=bt
bj=bl
end
end
end
end
end
end
end
end
if bj then
bc=true
bd=bj
end
end
end

if not bc and not az.Aiming.Triggerbot.PriorityOnly then
if a6 and(a4 or az.Aiming.Triggerbot.FireOnSilentTarget)then
local be=aL.Player
local bf=be.Character
if isTriggerTargetValid(be,bf,aL.Part)then
local bh=(aL.Part.Position-ai.CFrame.Position).Magnitude
if bh<=bb then
bc=true
bd=be
end
end
end

if not bc and a7 then
local be=aM.Player
local bf=be.Character
if isTriggerTargetValid(be,bf,aM.Part)then
local bh=(aM.Part.Position-ai.CFrame.Position).Magnitude
if bh<=bb then
bc=true
bd=be
end
end
end

if not bc and not a4 and not a5 then
local be=ai:ViewportPointToRay(a0.X,a0.Y)
aK.FilterDescendantsInstances={ai,ah.Character}
local bf=ab:Raycast(be.Origin,be.Direction*bb,aK)
if bf and bf.Instance then
local bh=bf.Instance:FindFirstAncestorOfClass"Model"
local bi=bh and ac:GetPlayerFromCharacter(bh)
if bi and isTriggerTargetValid(bi,bh,bf.Instance)then
bc=true
bd=bi
end
end

if not bc and az.Aiming.Triggerbot.TolerancePX and az.Aiming.Triggerbot.TolerancePX>0 then
local bh=az.Aiming.Triggerbot.TolerancePX
local bi=bh
local bj
for bk,bl in ipairs(ac:GetPlayers())do
if bl~=ah and bl.Character then
local bm=bl.Character
if isTriggerTargetValid(bl,bm,nil)then
local bn={bm:FindFirstChild"Head",bm:FindFirstChild"HumanoidRootPart",bm:FindFirstChild"UpperTorso"or bm:FindFirstChild"Torso"}
for bo,bp in ipairs(bn)do
if bp and bp:IsA"BasePart"then
local bq=(bp.Position-ai.CFrame.Position).Magnitude
if bq<=bb then
local br,bs=ai:WorldToViewportPoint(bp.Position)
if bs then
local bt=(ak(br.X,br.Y)-a0).Magnitude
if bt<=bi and(not az.Aiming.Triggerbot.WallCheck or isVisible(bp,ai.CFrame.Position))then
bi=bt
bj=bl
end
end
end
end
end
end
end
end
if bj then
bc=true
bd=bj
end
end
end
end

if bc then
a_=tick()
aW=tick()
aX=bd
if az.Aiming.Triggerbot.Method=="tool:Activate()"then
if a9 then a9:Activate()end
elseif mouse1click then
mouse1click()
end
end
end
end
updateWorldCrosshair()
end))

ad.Stepped:Connect(function()
if az.Client.Noclip then
local a0=ah.Character
if a0 then
for a1,a2 in ipairs(a0:GetDescendants())do
if a2:IsA"BasePart"and a2.CanCollide then
a2.CanCollide=false
end
end
end
end
end)

ae.JumpRequest:Connect(function()
if az.Movement.InfiniteJump then
local a0=ah.Character
local a1=a0 and a0:FindFirstChildOfClass"Humanoid"
if a1 then
a1:ChangeState(Enum.HumanoidStateType.Jumping)
end
end
end)

ae.InputBegan:Connect(function(a0,a1)
if a1 then return end
if az.Aiming.Camlock.Enabled and matchesKey(a0,az.Aiming.Camlock.Keybind)then
if az.Aiming.Camlock.Mode=="Toggle"then
az.Aiming.Camlock.Active=not az.Aiming.Camlock.Active
elseif az.Aiming.Camlock.Mode=="Hold"then
az.Aiming.Camlock.Active=true
end
end
if az.Aiming.Silent.Enabled and matchesKey(a0,az.Aiming.Silent.Keybind)then
if az.Aiming.Silent.Mode=="Toggle"then
az.Aiming.Silent.Active=not az.Aiming.Silent.Active
elseif az.Aiming.Silent.Mode=="Hold"then
az.Aiming.Silent.Active=true
end
end
if az.Aiming.Triggerbot.Enabled and matchesKey(a0,az.Aiming.Triggerbot.Keybind)then
az.Aiming.Triggerbot.Active=true
end
if az.Movement.FakeMacro and matchesKey(a0,az.Movement.MacroKey)then
if az.Movement.MacroMode=="Toggle"then
if aG then
stopFakeMacro()
else
startFakeMacro()
end
else
startFakeMacro()
end
end

end)

ae.InputEnded:Connect(function(a0,a1)
if az.Aiming.Camlock.Enabled and matchesKey(a0,az.Aiming.Camlock.Keybind)and az.Aiming.Camlock.Mode=="Hold"then
az.Aiming.Camlock.Active=false
end
if az.Aiming.Silent.Enabled and matchesKey(a0,az.Aiming.Silent.Keybind)and az.Aiming.Silent.Mode=="Hold"then
az.Aiming.Silent.Active=false
end
if az.Movement.FakeMacro and matchesKey(a0,az.Movement.MacroKey)and az.Movement.MacroMode~="Toggle"then
stopFakeMacro()
end
if az.Aiming.Triggerbot.Enabled and matchesKey(a0,az.Aiming.Triggerbot.Keybind)then
az.Aiming.Triggerbot.Active=false
end

end)

ax=aa:CreateWindow{
Title="future.club",
ToggleKey=Enum.KeyCode.P,
SidebarHourglass=true,
MobileButton=true,
ShowWatermark=true,
ShowKeybindList=false
}

local a0=ax:CreateTab{Name="Aiming",Icon="combat"}
local a1=ax:CreateTab{Name="Visuals",Icon="visuals"}
local a2=ax:CreateTab{Name="Client",Icon="player"}
local a3=ax:CreateTab{Name="Movement",Icon="move"}
local a4=ax:CreateTab{Name="Targeting",Icon="friends"}
local a5=ax:CreateTab{Name="Configs",Icon="configs"}
local a6=ax:CreateTab{Name="Settings",Icon="settings"}

do
local a7=a0:CreateModule{
Name="Camlock",
Default=false,
Callback=function(a7)
az.Aiming.Camlock.Enabled=a7
if not a7 then az.Aiming.Camlock.Active=false end
end
}

a7:CreateDropdown{
Name="Method",
Options={"CFrame","mousemoverel"},
Default="CFrame",
Callback=function(a8)az.Aiming.Camlock.Method=a8 end
}

a7:CreateDropdown{
Name="Mode",
Options={"Toggle","Hold"},
Default="Toggle",
Callback=function(a8)az.Aiming.Camlock.Mode=a8 end
}

a7:CreateKeybind{
Name="Keybind",
Default=Enum.KeyCode.C,
Mode="Toggle",
BindModule=false,
Callback=function(a8)az.Aiming.Camlock.Keybind=a8 end
}

a7:CreateDropdown{
Name="Target Part",
Options={"Head","HumanoidRootPart","UpperTorso","Closest Part"},
Default="Head",
Callback=function(a8)az.Aiming.Camlock.TargetPart=a8 end
}

a7:CreateDropdown{
Name="FOV Origin",
Options={"Mouse Location","Screen Center"},
Default="Mouse Location",
Callback=function(a8)
az.Aiming.Camlock.FOVOrigin=(a8=="Screen Center"and"Screen Center"or"Mouse")
end
}

a7:CreateDropdown{
Name="Prediction",
Options={"Off","Static","Directional","Auto"},
Default="Off",
Callback=function(a8)az.Aiming.Camlock.Prediction=a8 end
}

a7:CreateSlider{
Name="Prediction Amount",
Min=0.01,
Max=0.35,
Default=0.138,
Precision=0.001,
Callback=function(a8)az.Aiming.Camlock.PredictionAmount=a8 end
}

a7:CreateSlider{
Name="Prediction X (Right)",
Min=0.05,
Max=0.35,
Default=0.138,
Precision=0.001,
Callback=function(a8)az.Aiming.Camlock.PredictionX_Right=a8 end
}

a7:CreateSlider{
Name="Prediction X (Left)",
Min=0.05,
Max=0.35,
Default=0.138,
Precision=0.001,
Callback=function(a8)az.Aiming.Camlock.PredictionX_Left=a8 end
}

a7:CreateSlider{
Name="Prediction Y (Up)",
Min=0.05,
Max=0.35,
Default=0.138,
Precision=0.001,
Callback=function(a8)az.Aiming.Camlock.PredictionY_Up=a8 end
}

a7:CreateSlider{
Name="Prediction Y (Down)",
Min=0.05,
Max=0.35,
Default=0.138,
Precision=0.001,
Callback=function(a8)az.Aiming.Camlock.PredictionY_Down=a8 end
}

a7:CreateSlider{
Name="Prediction Z",
Min=0.05,
Max=0.35,
Default=0.138,
Precision=0.001,
Callback=function(a8)az.Aiming.Camlock.PredictionZ=a8 end
}

a7:CreateToggle{
Name="Resolver",
Default=false,
Callback=function(a8)az.Aiming.Camlock.Resolver=a8 end
}

a7:CreateDropdown{
Name="Resolver Mode",
Options={"Recalculation","MoveDirection","LookVector"},
Default="Recalculation",
Callback=function(a8)az.Aiming.Camlock.ResolverMode=a8 end
}

a7:CreateToggle{
Name="Unlock Upon Death",
Default=false,
Callback=function(a8)az.Aiming.Camlock.UnlockUponDeath=a8 end
}

a7:CreateSlider{
Name="Smoothness",
Min=0.01,
Max=1.00,
Default=0.20,
Precision=0.01,
Callback=function(a8)az.Aiming.Camlock.Smoothness=a8 end
}

a7:CreateToggle{
Name="Shake",
Default=false,
Callback=function(a8)az.Aiming.Camlock.Shake=a8 end
}

a7:CreateSlider{
Name="Shake Amount",
Min=1,
Max=50,
Default=15,
Precision=1,
Callback=function(a8)az.Aiming.Camlock.ShakeAmount=a8 end
}

a7:CreateToggle{
Name="Wall Check",
Default=false,
Callback=function(a8)az.Aiming.Camlock.WallCheck=a8 end
}

a7:CreateToggle{
Name="KO Check",
Default=false,
Callback=function(a8)az.Aiming.Camlock.KOCheck=a8 end
}

a7:CreateToggle{
Name="Grabbed Check",
Default=false,
Callback=function(a8)az.Aiming.Camlock.GrabbedCheck=a8 end
}

a7:CreateToggle{
Name="Friend Check",
Default=false,
Callback=function(a8)az.Aiming.Camlock.FriendCheck=a8 end
}

a7:CreateToggle{
Name="Crew Check",
Default=false,
Callback=function(a8)az.Aiming.Camlock.CrewCheck=a8 end
}

a7:CreateToggle{
Name="Forcefield Check",
Default=false,
Callback=function(a8)az.Aiming.Camlock.ForceFieldCheck=a8 end
}

a7:CreateToggle{
Name="Priority Only",
Default=false,
Callback=function(a8)az.Aiming.Camlock.PriorityOnly=a8 end
}

a7:CreateToggle{
Name="Show FOV",
Default=false,
Callback=function(a8)az.Aiming.Camlock.ShowFOV=a8 end
}

a7:CreateSlider{
Name="FOV Radius",
Min=20,
Max=400,
Default=120,
Precision=5,
Unit="px",
Callback=function(a8)az.Aiming.Camlock.FOVRadius=a8 end
}

a7:CreateColorPicker{
Name="FOV Color",
Default=aq(255,75,114),
Callback=function(a8)az.Aiming.Camlock.FOVColor=a8 end
}

a7:CreateToggle{
Name="Sticky Aim",
Default=false,
Callback=function(a8)az.Aiming.Camlock.StickyAim=a8 end
}

end

do
local a7=a0:CreateModule{
Name="Silent Aim",
Default=false,
Callback=function(a7)az.Aiming.Silent.Enabled=a7 end
}

a7:CreateDropdown{
Name="Mode",
Options={"Always On","Toggle","Hold"},
Default="Always On",
Callback=function(a8)az.Aiming.Silent.Mode=a8 end
}

a7:CreateKeybind{
Name="Keybind",
Default=Enum.KeyCode.Unknown,
Mode="Hold",
BindModule=false,
Callback=function(a8)az.Aiming.Silent.Keybind=a8 end
}

a7:CreateDropdown{
Name="Target Part",
Options={"Closest Part","Head","HumanoidRootPart","UpperTorso","LowerTorso"},
Default="Closest Part",
Callback=function(a8)az.Aiming.Silent.TargetPart=a8 end
}

a7:CreateDropdown{
Name="FOV Origin",
Options={"Mouse","Screen Center"},
Default="Mouse",
Callback=function(a8)az.Aiming.Silent.FOVOrigin=a8 end
}

a7:CreateSlider{
Name="Hit Chance",
Min=0,
Max=100,
Default=100,
Precision=1,
Unit="%",
Callback=function(a8)az.Aiming.Silent.HitChance=a8 end
}

a7:CreateToggle{
Name="Wall Check",
Default=false,
Callback=function(a8)az.Aiming.Silent.WallCheck=a8 end
}

a7:CreateToggle{
Name="K.O. Check",
Default=false,
Callback=function(a8)az.Aiming.Silent.KOCheck=a8 end
}

a7:CreateToggle{
Name="Grabbed Check",
Default=false,
Callback=function(a8)az.Aiming.Silent.GrabbedCheck=a8 end
}

a7:CreateToggle{
Name="Friend Check",
Default=false,
Callback=function(a8)az.Aiming.Silent.FriendCheck=a8 end
}

a7:CreateToggle{
Name="Crew Check",
Default=false,
Callback=function(a8)az.Aiming.Silent.CrewCheck=a8 end
}

a7:CreateToggle{
Name="Forcefield Check",
Default=false,
Callback=function(a8)az.Aiming.Silent.ForceFieldCheck=a8 end
}

a7:CreateToggle{
Name="Priority Only",
Default=false,
Callback=function(a8)az.Aiming.Silent.PriorityOnly=a8 end
}

a7:CreateSlider{
Name="Shotgun Spread",
Min=0,
Max=25,
Default=6,
Precision=1,
Unit=" deg",
Callback=function(a8)az.Aiming.Silent.ShotgunSpread=a8 end
}

a7:CreateToggle{
Name="Spread Modifier",
Default=false,
Callback=function(a8)az.Aiming.Silent.SpreadModEnabled=a8 end
}

a7:CreateSlider{
Name="Spread Amount",
Min=0,
Max=100,
Default=0,
Precision=1,
Unit="%",
Callback=function(a8)az.Aiming.Silent.SpreadAmount=a8 end
}

a7:CreateToggle{
Name="Shotguns Only",
Default=true,
Callback=function(a8)az.Aiming.Silent.SpreadSpecificOnly=a8 end
}

a7:CreateToggle{
Name="Sync FOV",
Default=true,
Callback=function(a8)az.Aiming.Silent.SyncFOV=a8 end
}

a7:CreateToggle{
Name="Show FOV",
Default=false,
Callback=function(a8)az.Aiming.Silent.ShowFOV=a8 end
}

a7:CreateSlider{
Name="FOV Radius",
Min=20,
Max=400,
Default=150,
Precision=5,
Unit="px",
Callback=function(a8)az.Aiming.Silent.FOVRadius=a8 end
}

a7:CreateColorPicker{
Name="FOV Color",
Default=aq(255,75,114),
Callback=function(a8)az.Aiming.Silent.FOVColor=a8 end
}

a7:CreateToggle{
Name="Camlock Target Only",
Default=false,
Callback=function(a8)az.Aiming.Silent.TargetCamlockOnly=a8 end
}

a7:CreateToggle{
Name="Tracer",
Default=false,
Callback=function(a8)az.Aiming.Silent.TargetTracer=a8 end
}

a7:CreateDropdown{
Name="Tracer Origin",
Options={"Bottom","Screen Center","Mouse"},
Default="Bottom",
Callback=function(a8)az.Aiming.Silent.TracerOrigin=a8 end
}

a7:CreateColorPicker{
Name="Tracer Color",
Default=aq(255,75,114),
Callback=function(a8)az.Aiming.Silent.TracerColor=a8 end
}

a7:CreateSlider{
Name="Tracer Thickness",
Min=1,
Max=5,
Default=1.5,
Precision=0.5,
Unit="px",
Callback=function(a8)az.Aiming.Silent.TracerThickness=a8 end
}

end

do
local a7=a0:CreateModule{
Name="Triggerbot",
Default=false,
Callback=function(a7)az.Aiming.Triggerbot.Enabled=a7 end
}

a7:CreateDropdown{
Name="Method",
Options={"tool:Activate()","mouse1click"},
Default="tool:Activate()",
Callback=function(a8)az.Aiming.Triggerbot.Method=a8 end
}

a7:CreateSlider{
Name="Fire Delay",
Min=10,
Max=300,
Default=50,
Precision=5,
Unit="ms",
Callback=function(a8)az.Aiming.Triggerbot.Delay=a8 end
}

a7:CreateSlider{
Name="Pixel Tolerance",
Min=0,
Max=150,
Default=0,
Precision=5,
Unit="px",
Callback=function(a8)az.Aiming.Triggerbot.TolerancePX=a8 end
}

a7:CreateToggle{
Name="Only When Silent",
Default=false,
Callback=function(a8)az.Aiming.Triggerbot.OnlyWhenSilent=a8 end
}

a7:CreateToggle{
Name="Only When Lock",
Default=false,
Callback=function(a8)az.Aiming.Triggerbot.OnlyWhenLock=a8 end
}

a7:CreateToggle{
Name="Fire on Silent",
Default=false,
Callback=function(a8)az.Aiming.Triggerbot.FireOnSilentTarget=a8 end
}

a7:CreateKeybind{
Name="Keybind",
Default=Enum.KeyCode.Unknown,
Mode="Hold",
Callback=function(a8)az.Aiming.Triggerbot.Keybind=a8 end
}

a7:CreateToggle{
Name="Wall Check",
Default=false,
Callback=function(a8)az.Aiming.Triggerbot.WallCheck=a8 end
}

a7:CreateToggle{
Name="KO Check",
Default=false,
Callback=function(a8)az.Aiming.Triggerbot.KOCheck=a8 end
}

a7:CreateToggle{
Name="Grabbed Check",
Default=false,
Callback=function(a8)az.Aiming.Triggerbot.GrabbedCheck=a8 end
}

a7:CreateToggle{
Name="Friend Check",
Default=false,
Callback=function(a8)az.Aiming.Triggerbot.FriendCheck=a8 end
}

a7:CreateToggle{
Name="Crew Check",
Default=false,
Callback=function(a8)az.Aiming.Triggerbot.CrewCheck=a8 end
}

a7:CreateToggle{
Name="Team Check",
Default=false,
Callback=function(a8)az.Aiming.Triggerbot.TeamCheck=a8 end
}

a7:CreateToggle{
Name="Forcefield Check",
Default=false,
Callback=function(a8)az.Aiming.Triggerbot.ForceFieldCheck=a8 end
}

a7:CreateToggle{
Name="Priority Only",
Default=false,
Callback=function(a8)az.Aiming.Triggerbot.PriorityOnly=a8 end
}

end

do
local a7=a1:CreateModule{
Name="Player ESP",
Default=false,
Callback=function(a7)
az.Visuals.ESP.Enabled=a7
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.Enabled=a7
end
if not a7 and getgenv().ESP and getgenv().ESP.Targets and getgenv().ESP.Targets.Players then
for a8,a9 in pairs(getgenv().ESP.Targets.Players)do
if a9.Objects then
if a9.Objects.TargetHolder then a9.Objects.TargetHolder.Visible=false end
if a9.Objects.Highlight then a9.Objects.Highlight.Enabled=false end
end
end
end
ax:UpdateESPPreview{Boxes=az.Visuals.ESP.Boxes}
end
}

a7:CreateToggle{
Name="Boxes",
Default=false,
Callback=function(a8)
az.Visuals.ESP.Boxes=a8
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.BoundingBox.Enabled=a8
end
ax:UpdateESPPreview{Boxes=a8}
end
}

a7:CreateDropdown{
Name="Box Style",
Options={"Corner","2D"},
Default="Corner",
Callback=function(a8)
az.Visuals.ESP.BoxStyle=a8
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.BoundingBox.Type=a8
end
ax:UpdateESPPreview{BoxStyle=(a8=="2D"and"Full"or"Corner")}
end
}

a7:CreateToggle{
Name="Box Fill",
Default=false,
Callback=function(a8)
az.Visuals.ESP.BoxFill=a8
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.BoundingBox.Fill.Enabled=a8
end
ax:UpdateESPPreview{BoxFill=a8}
end
}

a7:CreateToggle{
Name="Box Glow",
Default=false,
Callback=function(a8)
az.Visuals.ESP.BoxGlow=a8
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.BoundingBox.Glow.Enabled=a8
end
end
}

a7:CreateToggle{
Name="Names",
Default=false,
Callback=function(a8)
az.Visuals.ESP.Names=a8
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.Name.Enabled=a8
end
ax:UpdateESPPreview{Names=a8}
end
}

a7:CreateToggle{
Name="Health Bar",
Default=false,
Callback=function(a8)
az.Visuals.ESP.HealthBar=a8
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.Bars.HealthBar.Enabled=a8
getgenv().ESP.Settings.Players.Bars.HealthBar.Text.Enabled=a8
end
ax:UpdateESPPreview{HealthBar=a8}
end
}

a7:CreateToggle{
Name="Armor Bar",
Default=false,
Callback=function(a8)
az.Visuals.ESP.ArmorBar=a8
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.Bars.ArmorBar.Enabled=a8
getgenv().ESP.Settings.Players.Bars.ArmorBar.Text.Enabled=a8
end
end
}

a7:CreateToggle{
Name="Distance",
Default=false,
Callback=function(a8)
az.Visuals.ESP.Distance=a8
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.Distance.Enabled=a8
end
ax:UpdateESPPreview{Distance=a8}
end
}

a7:CreateToggle{
Name="Weapon",
Default=false,
Callback=function(a8)
az.Visuals.ESP.Weapon=a8
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.Weapon.Enabled=a8
end
ax:UpdateESPPreview{Weapon=a8}
end
}

a7:CreateToggle{
Name="Flags",
Default=false,
Callback=function(a8)
az.Visuals.ESP.Flags=a8
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.Flags.Enabled=a8
end
end
}

a7:CreateToggle{
Name="Chams",
Default=false,
Callback=function(a8)
az.Visuals.ESP.Chams=a8
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.Chams.Enabled=a8
end
if not a8 and getgenv().ESP and getgenv().ESP.Targets and getgenv().ESP.Targets.Players then
for a9,ba in pairs(getgenv().ESP.Targets.Players)do
if ba.Objects and ba.Objects.Highlight then
ba.Objects.Highlight.Enabled=false
end
end
end
ax:UpdateESPPreview{Chams=a8}
end
}

a7:CreateToggle{
Name="Team Check",
Default=false,
Callback=function(a8)
az.Visuals.ESP.TeamCheck=a8
end
}

a7:CreateSlider{
Name="Max Distance",
Min=100,
Max=3000,
Default=1000,
Precision=50,
Unit=" studs",
Callback=function(a8)
az.Visuals.ESP.MaxDistance=a8
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.MaxDistance=a8
end
end
}

a7:CreateColorPicker{
Name="Box Color",
Default=aq(255,75,114),
Callback=function(a8)
az.Visuals.ESP.Colors.Box=a8
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.BoundingBox.Color={a8,a8}
getgenv().ESP.Settings.Players.BoundingBox.Fill.Color={a8,a8}
getgenv().ESP.Settings.Players.BoundingBox.Glow.Color={a8,a8}
end
ax:UpdateESPPreview{BoxColor=a8}
end
}

a7:CreateColorPicker{
Name="Name Color",
Default=aq(245,245,250),
Callback=function(a8)
az.Visuals.ESP.Colors.Name=a8
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.Name.Color=a8
end
ax:UpdateESPPreview{NameColor=a8}
end
}

a7:CreateColorPicker{
Name="Chams Color",
Default=aq(255,75,114),
Callback=function(a8)
az.Visuals.ESP.Colors.Chams=a8
if getgenv().ESP and getgenv().ESP.Settings and getgenv().ESP.Settings.Players then
getgenv().ESP.Settings.Players.Chams.Fill={a8,0.5}
end
ax:UpdateESPPreview{ChamsColor=a8}
end
}

end

do
local a7={
Ambient=af.Ambient,
Brightness=af.Brightness,
ClockTime=af.ClockTime,
FogEnd=af.FogEnd
}

local a8=a1:CreateModule{
Name="World Visuals",
Default=false,
Callback=function(a8)end
}

a8:CreateToggle{
Name="Fullbright",
Default=false,
Callback=function(a9)
az.Visuals.World.Fullbright=a9
if a9 then
af.Ambient=aq(255,255,255)
af.Brightness=2
af.ClockTime=14
else
af.Ambient=a7.Ambient
af.Brightness=a7.Brightness
af.ClockTime=a7.ClockTime
end
end
}

a8:CreateToggle{
Name="Remove Fog",
Default=false,
Callback=function(a9)
az.Visuals.World.RemoveFog=a9
af.FogEnd=a9 and 9e9 or a7.FogEnd
end
}

a8:CreateToggle{
Name="Crosshair",
Default=false,
Callback=function(a9)az.Visuals.World.Crosshair=a9 end
}

a8:CreateColorPicker{
Name="Crosshair Color",
Default=aq(255,255,255),
Callback=function(a9)az.Visuals.World.CrosshairColor=a9 end
}

a8:CreateSlider{
Name="Crosshair Size",
Min=4,
Max=30,
Default=10,
Precision=1,
Unit="px",
Callback=function(a9)az.Visuals.World.CrosshairSize=a9 end
}

a8:CreateSlider{
Name="Crosshair Gap",
Min=1,
Max=15,
Default=4,
Precision=1,
Unit="px",
Callback=function(a9)az.Visuals.World.CrosshairGap=a9 end
}

end

do
a2:CreateModule{
Name="Noclip",
Default=false,
Callback=function(a7)
az.Client.Noclip=a7
if not a7 then
local a8=ah.Character
if a8 then
for a9,ba in ipairs(a8:GetDescendants())do
if ba:IsA"BasePart"then ba.CanCollide=true end
end
end
end
end
}

end

do
local a7=a2:CreateModule{
Name="Animation Changer",
Default=false,
Callback=function(a7)
az.Client.AnimationChanger=a7
applyAnimationPreset(a7 and az.Client.SelectedAnimation or"Default")
end
}

a7:CreateDropdown{
Name="Animation Preset",
Options={"Default","Zombie","Ninja","Robot","Levitate","Cartoony","Super Hero","Elder","Toy","Old School","Stylish"},
Default="Default",
Callback=function(a8)
az.Client.SelectedAnimation=a8
if az.Client.AnimationChanger then
applyAnimationPreset(a8)
end
end
}

end

do
local a7=a2:CreateModule{
Name="Hit Sounds",
Default=false,
Callback=function(a7)az.Client.HitSounds=a7 end
}

a7:CreateDropdown{
Name="Sound Preset",
Options={"Rust","Neverlose","Skeet","Bubble","Bell","Hitmarker"},
Default="Rust",
Callback=function(a8)az.Client.HitSoundPreset=a8 end
}

a7:CreateSlider{
Name="Sound Volume",
Min=10,
Max=100,
Default=80,
Precision=5,
Unit="%",
Callback=function(a8)az.Client.HitSoundVolume=a8 end
}

a7:CreateTextBox{
Name="Custom Sound ID",
Default="",
Placeholder="rbxassetid://...",
Callback=function(a8)az.Client.CustomHitSoundId=a8 end
}

end

do
local a7=a2:CreateModule{
Name="Damage Indicators",
Default=false,
Callback=function(a7)az.Client.DamageNumbers=a7 end
}

a7:CreateToggle{
Name="Hit Notifications",
Default=false,
Callback=function(a8)az.Client.HitNotifications=a8 end
}

a7:CreateColorPicker{
Name="Number Color",
Default=aq(255,75,114),
Callback=function(a8)az.Client.DamageNumbersColor=a8 end
}

a7:CreateSlider{
Name="Display Duration",
Min=0.5,
Max=2.5,
Default=1.0,
Precision=0.1,
Unit="s",
Callback=function(a8)az.Client.DamageDuration=a8 end
}

end

do
local a7=a3:CreateModule{
Name="WalkSpeed",
Default=false,
Callback=function(a7)
az.Movement.WalkSpeedEnabled=a7
updateWalkspeed()
end
}

a7:CreateSlider{
Name="Speed Value",
Min=16,
Max=250,
Default=32,
Precision=1,
Unit=" ws",
Callback=function(a8)
az.Movement.WalkSpeedValue=a8
if not aG then
aA=a8
updateWalkspeed()
end
end
}

end

do
local a7=a3:CreateModule{
Name="JumpPower",
Default=false,
Callback=function(a7)
az.Movement.JumpPowerEnabled=a7
updateJumpPower()
end
}

a7:CreateSlider{
Name="Jump Value",
Min=50,
Max=300,
Default=100,
Precision=5,
Unit=" jp",
Callback=function(a8)
az.Movement.JumpPowerValue=a8
aB=a8
updateJumpPower()
end
}

a7:CreateToggle{
Name="Infinite Jump",
Default=false,
Callback=function(a8)
az.Movement.InfiniteJump=a8
end
}

end

do
local a7=a3:CreateModule{
Name="Fake Macro",
Default=false,
Callback=function(a7)
az.Movement.FakeMacro=a7
if not a7 and aG then
stopFakeMacro()
end
end
}

a7:CreateDropdown{
Name="Mode",
Options={"Toggle","Hold"},
Default="Toggle",
Callback=function(a8)az.Movement.MacroMode=a8 end
}

a7:CreateKeybind{
Name="Keybind",
Default=Enum.KeyCode.Q,
Mode="Toggle",
Callback=function(a8)az.Movement.MacroKey=a8 end
}

a7:CreateDropdown{
Name="Speed Mode",
Options={"Fixed","Random","Ramp Up"},
Default="Fixed",
Callback=function(a8)az.Movement.MacroSpeedMode=a8 end
}

a7:CreateSlider{
Name="Fixed Speed",
Min=50,
Max=350,
Default=120,
Precision=5,
Unit=" ws",
Callback=function(a8)
az.Movement.MacroSpeed=a8
if aG and az.Movement.MacroSpeedMode=="Fixed"then
aA=a8
updateWalkspeed()
end
end
}

a7:CreateSlider{
Name="Min Speed",
Min=50,
Max=350,
Default=200,
Precision=5,
Unit=" ws",
Callback=function(a8)az.Movement.MacroSpeedMin=a8 end
}

a7:CreateSlider{
Name="Max Speed",
Min=50,
Max=400,
Default=300,
Precision=5,
Unit=" ws",
Callback=function(a8)az.Movement.MacroSpeedMax=a8 end
}

a7:CreateSlider{
Name="Start Speed",
Min=16,
Max=200,
Default=60,
Precision=5,
Unit=" ws",
Callback=function(a8)az.Movement.MacroRampStart=a8 end
}

a7:CreateSlider{
Name="Max Speed",
Min=100,
Max=400,
Default=280,
Precision=5,
Unit=" ws",
Callback=function(a8)az.Movement.MacroRampMax=a8 end
}

a7:CreateSlider{
Name="Duration",
Min=0.5,
Max=3.0,
Default=1.0,
Precision=0.1,
Unit="s",
Callback=function(a8)az.Movement.MacroRampDuration=a8 end
}

end

do
local function getPlayerNameList()
local a7={}
for a8,a9 in ipairs(ac:GetPlayers())do
if a9~=ah then
av(a7,a9.Name)
end
end
if#a7==0 then av(a7,"None")end
return a7
end

local a7=a4:CreateModule{
Name="Player Targeting",
Default=false,
Callback=function(a7)end
}

local a8=a7:CreateDropdown{
Name="Select Player",
Options=getPlayerNameList(),
Default=getPlayerNameList()[1]or"None",
Callback=function(a8)
az.Targeting.SelectedPlayer=ac:FindFirstChild(a8)
end
}
ax.ConfigElements["Module_Targeting_Player Targeting_Select Player"]=nil

ac.PlayerAdded:Connect(function()
a8:Refresh(getPlayerNameList(),true)
end)
ac.PlayerRemoving:Connect(function()
task.delay(0.2,function()a8:Refresh(getPlayerNameList(),true)end)
end)

a7:CreateButton{
Name="Add Priority",
Callback=function()
local a9=az.Targeting.SelectedPlayer or ac:FindFirstChild(a8:Get())
if a9 then
az.Targeting.Priority[a9.UserId]=true
az.Targeting.Priority[tostring(a9.UserId)]=true
az.Targeting.Priority[a9.Name]=true
ax:Notify{
Title="Priority Added",
Description=a9.Name.." set as high-priority target",
Duration=2
}
end
end
}

a7:CreateButton{
Name="Add Friend",
Callback=function()
local a9=az.Targeting.SelectedPlayer or ac:FindFirstChild(a8:Get())
if a9 then
az.Targeting.Friends[a9.UserId]=true
az.Targeting.Friends[tostring(a9.UserId)]=true
az.Targeting.Friends[a9.Name]=true
ax:Notify{
Title="Friend Added",
Description=a9.Name.." added to safe list",
Duration=2
}
end
end
}

a7:CreateButton{
Name="Remove Target",
Callback=function()
local a9=az.Targeting.SelectedPlayer or ac:FindFirstChild(a8:Get())
if a9 then
az.Targeting.Priority[a9.UserId]=nil
az.Targeting.Priority[tostring(a9.UserId)]=nil
az.Targeting.Priority[a9.Name]=nil
az.Targeting.Friends[a9.UserId]=nil
az.Targeting.Friends[tostring(a9.UserId)]=nil
az.Targeting.Friends[a9.Name]=nil
ax:Notify{
Title="Target Removed",
Description="Removed "..a9.Name.." from priority & safe lists",
Duration=2
}
end
end
}

a7:CreateToggle{
Name="Spectate",
Default=false,
Callback=function(a9)
if a9 then
local ba=az.Targeting.SelectedPlayer or ac:FindFirstChild(a8:Get())
local bb=ba and ba.Character and ba.Character:FindFirstChildOfClass"Humanoid"
if bb then
ai.CameraSubject=bb
end
else
local ba=ah.Character and ah.Character:FindFirstChildOfClass"Humanoid"
if ba then
ai.CameraSubject=ba
end
end
end
}

a7:CreateButton{
Name="Teleport",
Callback=function()
local a9=az.Targeting.SelectedPlayer or ac:FindFirstChild(a8:Get())
local ba=a9 and a9.Character and a9.Character:FindFirstChild"HumanoidRootPart"
local bb=ah.Character and ah.Character:FindFirstChild"HumanoidRootPart"
if ba and bb then
bb.CFrame=ba.CFrame*an(0,0,3)
ax:Notify{
Title="Teleported",
Description="Teleported to "..a9.Name,
Duration=2
}
end
end
}

end

a5:CreateConfigSystem()
a6:CreateSettingsSystem()

ax:Notify{
Title="future.club",
Duration=3.5
}
