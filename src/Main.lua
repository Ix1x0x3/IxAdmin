local lp = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui");
local TS = game:GetService("TweenService");

local Lib = {
    PrisonLife = loadstring(game:HttpGet"https://raw.githubusercontent.com/Ix1x0x3/game-libs/main/libs/prisonlife.lua")();
    CHandler = loadstring(game:HttpGet("https://raw.githubusercontent.com/Ix1x0x3/IxAdmin/main/src/CommandHandler.lua"))();
}

local Temp = {
    NotifCache = {};
    AdminsChecked = {};
    AdminCHandlerInstances = {};
    Commands = {
        kill = {
            ID = "kill";
            Aliases = {
                "kill"
            };
            Run = function(Self, Args)
                print(Self, Args, Self.Name)
            end
        }
    }
}

local Admins = {
    lp.UserId;
}

local Modules = {
    HttpRun = function(raw)
        return loadstring(game:HttpGet(raw))
    end;

    GithubImport = function(file)
        return loadstring( game:HttpGet("https://raw.githubusercontent.com/Ix1x0x3/IxAdmin/main/src/"..file..".lua") )
    end;

    UpdateAdmins = function()
        for _,Admin in pairs(Admins) do
            if not Temp.AdminsChecked[Admin.Name] then
                
                Temp.AdminsChecked[Admin.Name] = true;
                Temp.AdminCHandlerInstances[Admin.Name] = Lib.CHandler.New(Admin, {
                    Prefix = ""
                })

                for _,c in pairs(Temp.Commands) do
                    Temp.AdminCHandlerInstances[Admin.Name]:AddCommand(_, c)
                end

                Temp.AdminCHandlerInstances[Admin.Name]:Listen()

            end
        end
    end;

    Notif = function(Txt, Time, Tag)
        local NotifGui = CoreGui:FindFirstChild("IXADMIN_NGUI");

        if not NotifGui then
            NotifGui = Instance.new("ScreenGui", CoreGui);
            NotifGui.Name = "IXADMIN_NGUI";
        end

        local Ntif = Instance.new("TextLabel", NotifGui)
        Ntif.Position = UDim2.new(0.5, 0, 0.9, 0);
        Ntif.Size = UDim2.new(1,0,0.25,0);
        Ntif.TextTransparency = 1;
        Ntif.Text = Tag and "["..Tag.."] "..Txt or Txt
        Ntif.BackgroundTransparency = 1;
        Ntif.Font = Enum.Font.SourceSansSemibold;
        Ntif.AnchorPoint = Vector2.new(0.5, 0.5)
        Ntif.TextSize = 32;
        Ntif.TextColor3 = Color3.new(1,1,1)

        table.insert(Temp.NotifCache, Ntif)

        TS:Create(
            Ntif,
            TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {
                Position = UDim2.new(0.5,0,0.8-(#Temp.NotifCache*0.05),0);
                TextTransparency = 0;
            }
        ):Play()

        wait(Time or 5)

        TS:Create(
            Ntif,
            TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {
                TextTransparency = 1;
                Position = UDim2.new(0.5, 0, 0.9, 0);
            }
        ):Play()
        table.remove(Temp.NotifCache, table.find(Temp.NotifCache, Ntif))
    end;

    SearchForPlayer = function(Data)
        if Data == "all" then
            local o={};
            for x,zz in pairs(game.Players:GetChildren()) do
                table.insert(o,zz)
            end
            return (o)
        end

        if Data == "others" then
            local o={};
            for x,zz in pairs(game.Players:GetChildren()) do
                if zz~=lp then
                    table.insert(o,zz)
                end
            end
            return (o)
        end

        local x={}

        for _,p in pairs(game.Players:GetChildren()) do
            if string.match(p.Name:lower(), Data:lower()) or string.match(p.DisplayName:lower(), Data:lower()) then
                table.insert(x,p)
            end
        end

        return x
    end;

    FormalTable = function(x)
        local res = "";
        for i,v in pairs(x) do
            if i == #x-1 then
                res ..= v..", and "
                continue
            end

            if i == #x then
                res ..= v
                continue
            end

            res ..= v..", "
        end

        return res;
    end
}

local Prefix = ">"

local Commands = {}

Commands.print = function(Sender,Arguments)
	local Message = table.concat(Arguments," ")
	Modules.Notif("From " ..Sender.Name..":\n"..Message)
    Modules.Notif("Test Formal "..Modules.FormalTable({"Someone", "Idk", "But",'Hi'}))
end

local function IsAdmin(Player)
	for _,Admin in pairs (Admins) do
		print(Admin,Player)
		if type(Admin) == "string" and string.lower(Admin) == string.lower(Player.Name) then
			return true
		elseif type(Admin) == "number" and Admin == Player.UserId then
			return true
		--[[elseif type(Admin) == "table" then
			local Rank = Player:GetRankInGroup(Admin.GroupId)
			if Rank >= (Admin.RankId or 1) then
				return true
			end]]
		end
	end
	return false
end

local function ParseMessage(Player,Message)
	Message = string.lower(Message)
	local PrefixMatch = string.match(Message,"^"..Prefix)
	
	if PrefixMatch then
		Message = string.gsub(Message,PrefixMatch,"",1)
		local Arguments = {}
		
		for Argument in string.gmatch(Message,"[^%s]+") do
			table.insert(Arguments,Argument)
		end
		
		local CommandName = Arguments[1]
		table.remove(Arguments,1)
		local CommandFunc = Commands[CommandName]
		
		if CommandFunc ~= nil then
			CommandFunc(Player,Arguments)
		end
	end
end

for _,Player in pairs(game.Players:GetChildren()) do
    Player.Chatted:Connect(function(Msg)
        if IsAdmin(Player) then
            ParseMessage(Player, Msg)
        end
    end)
end