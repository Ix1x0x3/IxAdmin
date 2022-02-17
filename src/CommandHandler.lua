local CmdHandler = {}
CmdHandler.__index = CmdHandler;

function CmdHandler.New(Player, Options)
    local self = {}
    self.Master = Player;
    self.Prefix = Options.Prefix;
    self.Commands = {}

    return setmetatable(self, CmdHandler)
end

function CmdHandler:CheckCommand(RawMsg)
    
    local h0 = RawMsg:split(" ")[1]:gsub(self.Prefix, "");

    return h0:lower();

end

function CmdHandler:AddCommand(CommandInfo)
    
    self.Commands[CommandInfo.ID] = CommandInfo;

end

function CmdHandler:Listen()
    
    self.Master.Chatted:Connect(function(Msg)

        local Cmd = self:CheckCommand(Msg);
        
        if Cmd ~= "" then
            local FoundCmd = false;

            local Args = Msg:split(" ")
            table.remove(Args, 1)

            for _,Command in pairs(self.Commands) do
                
                for _,Alias in pairs(Command.Aliases) do

                    if Cmd:lower() == Alias:lower() then
                        
                        FoundCmd = true;
                        return Command.Run(self.Master, Args)

                    end

                end

            end

            if not FoundCmd then
                return false;
            end
        end
        
    end)

end

return CmdHandler;