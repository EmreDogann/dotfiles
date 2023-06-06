# Available variants from Catppuccin:
# frappe | latte | macchiato | mocha
export THEMEVARIANT="frappe"

# FZF color scheme config
if [ $THEMEVARIANT = "frappe" ]
then
	export FZF_DEFAULT_OPTS=" \
	--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
	--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
	--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"
elif [ $THEMEVARIANT = "latte" ]
then
	export FZF_DEFAULT_OPTS=" \
	--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
	--color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
	--color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"
elif [ $THEMEVARIANT = "macchiato" ]
then
	export FZF_DEFAULT_OPTS=" \
	--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
	--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
	--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
elif [ $THEMEVARIANT = "mocha" ]
then
	export FZF_DEFAULT_OPTS=" \
	--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
	--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
	--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
else
	echo "Theme Variant: $THEMEVARIANT not recognized."
	export FZF_DEFAULT_OPTS=""
fi

# Bat color scheme config
if [[ ! -f $(bat --config-dir)/themes/Catppuccin-$THEMEVARIANT.tmTheme ]] then
	cd $(bat --config-dir)/themes
	curl -Ls -O https://raw.githubusercontent.com/catppuccin/bat/main/Catppuccin-$THEMEVARIANT.tmTheme
	cd - > /dev/null
	bat cache --build
fi
export BAT_THEME="Catppuccin-$THEMEVARIANT"
