-- WITHOUT PARAMETERS: getLocalizedText(player, lang_code)
-- WITH PARAMETERS: getLocalizedText(player, lang_code, parameters)

addCommandHandler('getmoney',
	function(player, command, target)
		if (not target) then
			outputChatBox('SYNTAX: /' .. command .. ' [player name]', player, 255, 200, 0);
		else
			local targetPlayer = getPlayerFromPartialName(target);
			
			if (targetPlayer) then
				outputChatBox(getLocalizedText(player, 'admin.get_money', getPlayerName(targetPlayer), getPlayerMoney(targetPlayer)), player, 255, 255, 255);
			else
				outputChatBox('ERROR: Player not found!', player, 255, 0, 0);
			end
		end
	end
)

addCommandHandler('setlanguage',
	function(player, command, language)
		if (not language) then
			outputChatBox('SYNTAX: /' .. command .. ' [language (en | hu | etc..)]', player, 255, 200, 0);
		else
			local setLanguage = setPlayerLanguage(player, language);
			
			if (setLanguage) then
				outputChatBox('SUCCESS: Language has been changed!', player, 0, 200, 0);
			else
				outputChatBox('ERROR: Language not found!', player, 255, 0, 0);
			end
		end
	end
)

--> Useful function by TAPL
function getPlayerFromPartialName(name)
    local name = name and name:gsub('#%x%x%x%x%x%x', ''):lower() or nil;
	
    if (name) then
        for _, player in ipairs(getElementsByType('player')) do
            local name_ = getPlayerName(player):gsub('#%x%x%x%x%x%x', ''):lower();
           
		   if (name_:find(name, 1, true)) then
                return player;
            end
        end
    end
end