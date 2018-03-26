Language = {};

AvailableLanguages = {
	['en'] = true,
	['hu'] = true
};

function getLocalizedText(player, lang_code, ...)
	if (player and lang_code) then
		if (...) then
			return getLocalizedCode(player, lang_code):format(...);
		else
			return getLocalizedCode(player, lang_code);
		end
	end
end

function getLocalizedCode(player, code)
	if (player and code) then
		local playerLanguage = getPlayerLanguage(player);
		
		if (playerLanguage) then
			if (Language[playerLanguage]) then
				if (Language[playerLanguage][code]) then
					return Language[playerLanguage][code];
				else
					return code;
				end
			else
				return code;
			end
		end
	end
end

function getPlayerLanguage(player)
	if (player) then
		local playerLanguage = getElementData(player, 'acc.Language') or 'en';
		
		return playerLanguage;
	end
end

function setPlayerLanguage(player, lang)
	if (player and lang) then
		if (AvailableLanguages[lang]) then
			setElementData(player, 'acc.Language', lang);
			iprint("Language set to " ..tostring(lang))
			return true;
		else
			return false;
		end
	end
end