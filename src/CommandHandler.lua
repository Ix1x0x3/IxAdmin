local CmdHandler = {}
CmdHandler.__index = CmdHandler;

function CmdHandler.New(Player, Options)
    local self = {}
    self.Master = Player;
    self.Prefix = Options.Prefix;

    return setmetatable(self, CmdHandler)
end

function CmdHandler:CheckCommand(RawMsg)
    
    local h0 = RawMsg:split(" ")[1]:gsub(self.Prefix, "");

    return h0;

end

return CmdHandler;