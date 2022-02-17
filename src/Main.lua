local lp = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui");
local TS = game:GetService("TweenService")

local Temp = {
    NotifCache = {}
}

local Modules = {
    HttpRun = function(raw)
        return loadstring(game:HttpGet(raw))
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

local Eurus = loadstring(game:HttpGet"https://raw.githubusercontent.com/Ix1x0x3/eurus/main/src/index.lua")();

local Lib = {
    PrisonLife = loadstring(game:HttpGet"https://raw.githubusercontent.com/Ix1x0x3/game-libs/main/libs/prisonlife.lua")();
}

Eurus:AddCommand("kill", {
    "end",
    "oof"
}, {
    Description = "Kills the specified target."
}, function(Self, Args)
    if Args[1] then
        local Targets = Modules.GetPlayer(Args[1])

        if #Targets == 0 then
            return Modules.Notif("Your search query matched no players.");
        end

        for i,Target in pairs(Targets) do
            Lib.PrisonLife.KillPlayer(Target)
        end

        return Modules.Notif("Killed "..Modules.FormalTable(Targets)..".")
    else
        return Modules.Notif("Invalid arguments, provide a player please.");
    end
end)

Modules.Notif(
    "Loaded.",
    5,
    "IxAdmin"
)