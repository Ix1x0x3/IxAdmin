local lp = game:GetService("Players").LocalPlayer
local CoreGui = game:GetService("CoreGui");
local TS = game:GetService("TweenService")

local Temp = {
    NotifCache = {}
}

local Modules = {
    HttpRun = function(raw)return loadstring(game:HttpGet(raw))()end;

    Notif = function(Txt, Time, Tag)
        local NotifGui = CoreGui:FindFirstChild("IXADMIN_NGUI");

        if not NotifGui then
            NotifGui = Instance.new("ScreenGui", CoreGui);
            NotifGui.Name = "IXADMIN_NGUI";
        end

        local Ntif = Instance.new("TextLabel", NotifGui)
        Ntif.Position = UDim2.new(0.5, 0, 0.9, 0);
        Ntif.Size = UDim2.new(1,0,0.25,0);
        Ntif.TextTransparency = 0;
        Ntif.Text = Tag ~= nil and Txt or "["..Tag.."] "..Txt
        Ntif.TextScaled = true;
        Ntif.BackgroundTransparency = 1;
        Ntif.Font = Enum.Font.Code;

        TS:Create(
            Ntif,
            TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {
                Position = UDim2.new(0.5,0,0.7+(#Temp.NotifCache*0.15),0);
                TextTransparency = 1;
            }
        ):Play()

        delay(Time ~= nil and Time or 5, function()
            TS:Create(
                Ntif,
                TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {
                    TextTransparency = 0;
                    Position = UDim2.new(0.5, 0, 0.9, 0);
                }
            ):Play()

            delay(1, function()
                Ntif:Destroy()
            end)
        end)
    end
}

local Lib = {
    PrisonLife = Modules.HttpRun"https://raw.githubusercontent.com/Ix1x0x3/game-libs/main/libs/prisonlife.lua";
    Eurus = Modules.HttpRun"https://raw.githubusercontent.com/Ix1x0x3/eurus/main/src/index.lua"
}

Lib.Eurus:SetScriptData {
    Prefix = ".";
    ScriptName = "IxAdmin";
}

local Commands = {
    "Test"
}

for _,Command in pairs(Commands) do
    
    Modules.Notif(Command)

end