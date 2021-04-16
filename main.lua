local Helper = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserMouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Heartbeat = RunService.Heartbeat

local function ParentGui(Gui)
	Gui.Name = HttpService:GenerateGUID(false):gsub("-", ""):sub(1, math.random(25, 30))
	if (not is_sirhurt_closure) and (syn and syn.protect_gui) then
		syn.protect_gui(Gui)
		Gui.Parent = CoreGui
	elseif get_hidden_gui or gethui then
		local HiddenUI = get_hidden_gui or gethui
		Gui.Parent = HiddenUI()
	elseif CoreGui:FindFirstChild("RobloxGui") then
		Gui.Parent = CoreGui["RobloxGui"]
	else
		Gui.Parent = CoreGui
	end
end

local function SmoothDrag(frame)
	local s, event = pcall(function()
		return frame.MouseEnter
	end)
	if s then
		frame.Active = true;
		event:connect(function()
			local input = frame.InputBegan:connect(function(key)
				if key.UserInputType == Enum.UserInputType.MouseButton1 then
					local objectPosition = Vector2.new(UserMouse.X - frame.AbsolutePosition.X, UserMouse.Y - frame.AbsolutePosition.Y);
					while Heartbeat:wait() and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
						pcall(function()
							frame:TweenPosition(UDim2.new(0, UserMouse.X - objectPosition.X, 0, UserMouse.Y - objectPosition.Y), 'Out', 'Linear', 0.1, true);
						end)
					end
				end
			end)
			local leave;
			leave = frame.MouseLeave:connect(function()
				input:disconnect();
				leave:disconnect();
			end)
		end)
	end
end

local function GetCharacter(user)
	if user ~= nil then
		return user.Character
	else
		return LocalPlayer.Character
	end
end

local function GetRoot(character)
	local RootPart = nil
	if character ~= nil then
		RootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
	else
		RootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso") or LocalPlayer.Character:FindFirstChild("UpperTorso")
	end
	return RootPart
end

local function Is_R15(character)
	local Humanoid = nil
	if character ~= nil then
		Humanoid = character:FindFirstChildOfClass("Humanoid")
	else
		Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	end
	if (Humanoid.RigType == Enum.HumanoidRigType.R15) then
		return true
	else
		return false
	end
end

local function ToUserClipboard(str)
	local UserClip = setclipboard or writeclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
	if UserClip then
		UserClip(str)
	end
end

local function FixUserCam()
	workspace.CurrentCamera:remove()
	wait(.1)
	repeat wait() until LocalPlayer.Character ~= nil
	workspace.CurrentCamera.CameraSubject = LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
	workspace.CurrentCamera.CameraType = "Custom"
	LocalPlayer.CameraMinZoomDistance = 0.5
	LocalPlayer.CameraMaxZoomDistance = 400
	LocalPlayer.CameraMode = "Classic"
	local SearchForHead = LocalPlayer.Character:FindFirstChild("Head")
	if SearchForHead then
		LocalPlayer.Character.Head.Anchored = false
	end
end

local function EasyNotify(title, text)
	title = title or "Notification"
	text = text or "bruh"
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title = title;
		Text = title;
	})
end

local function MetaHook(str, func)
    if (type(str) == "string") and (type(func) == "function") then
        local NewCClosure = newcclosure
        local GetMetatable = (debug and debug.getrawmetatable) or getrawmetatable
        local SetReadOnly = setreadonly or (make_writeable and function(table, readonly) if readonly then make_readonly(table) else make_writeable(table) end end)
        local gmt = GetMetatable(game)
        SetReadOnly(gmt, false)
        local oldindex = gmt.__index
        gmt.__index = NewCClosure(function(self, b)
            if b == str then
                pcall(func)
            end
            return oldindex(self, b)
        end)
    end
end

local function LoopVariableAction(val, cd, func)
	if type(func) == "function" then
		spawn(function()
			while wait(cd) do
				if val then
					pcall(func)
				end
			end
		end
	end
end

local function GetHumanoid(character)
	if character ~= nil then
		return character:FindFirstChildOfClass("Humanoid")
	else
		return LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	end
end

local function FindHumanoid(character)
	if character ~= nil then
		if character:FindFirstChildOfClass("Humanoid") then
			return true
		else
			return false
		end
	else
		if LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
			return true
		else
			return false
		end
	end
end

local function QuickRejoin()
	if #Players:GetPlayers() <= 1 then
		Players.LocalPlayer:Kick("\nRejoining...")
		wait()
		game:GetService("TeleportService"):Teleport(game.PlaceId, Players.LocalPlayer)
	else
		game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
	end
end

local function SHP_sethidden(x, i, v)
	x[i] = v
end









--// GUI
Helper.protect_gui = ParentGui
Helper.dragify = SmoothDrag

--// Players & Characters
Helper.player = LocalPlayer
Helper.getchar = GetCharacter
Helper.gethum = GetHumanoid
Helper.findhum = FindHumanoid
Helper.getroot = GetRoot
Helper.r15 = Is_R15

--// Useful Actions
Helper.restorecamera = FixUserCam
Helper.notify = EasyNotify
Helper.rejoin = QuickRejoin
Helper.loadda = lda

--// Global Methods
Helper.sethidden = sethiddenproperty or sethiddenprop or sethidden or set_hidden_prop or set_hidden_property or SHP_sethidden
Helper.gethidden = gethiddenproperty or get_hidden_property or get_hidden_prop
Helper.setsimulation = setsimulationradius or set_simulation_radius
Helper.hookfunction = hookfunction or detour_function
Helper.toclipboard = ToUserClipboard
Helper.setconstant = (debug and debug.setconstant) or setconstant or setconst
Helper.getconstants = (debug and debug.getconstants) or getconstants or getconsts
Helper.getconnections = getconnections or get_signal_cons
Helper.getgc = getgc or get_gc_objects
Helper.hookfunction = hookfunction or detour_function
Helper.getscriptclosure = getscriptclosure or get_script_function
Helper.setreadonly = setreadonly or (make_writeable and function(table, readonly) if readonly then make_readonly(table) else make_writeable(table) end end)
Helper.isreadyonly = isreadonly or is_readonly
Helper.isxclosure = is_synapse_function or issentinelclosure or is_protosmasher_closure or is_sirhurt_closure or iselectronfunction or checkclosure
Helper.getcontext = getthreadcontext or get_thread_context or (syn and syn.get_thread_identity)
Helper.getnamecallmethod = getnamecallmethod or get_namecall_method
Helper.getupvalues = (debug and debug.getupvalues) or getupvalues or getupvals
Helper.metahook = MetaHook
Helper.loopvariable = LoopVariableAction

--// Aliases
Helper.plr = LocalPlayer
helper.hookfunc = hookfunction or detour_function
Helper.rj = QuickRejoin

--// Setup
getgenv().pam = Helper
