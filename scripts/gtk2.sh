
local cursorsDir="${HOME}/.icons"

if [ $private -ne 0 ]; then
	cp -rL ${cursorsDir} "${CSM_HOME}/.icons"

	cat > "${CSM_HOME}/.gtkrc-2.0" <<-_EOF
	gtk-cursor-theme-name="Breeze_Hacked"
	gtk-cursor-theme-size=48
	_EOF

	read -d '' String <<-_EOF
	# gtk2
	private-home ${CSM_HOME}/.icons
	private-home ${CSM_HOME}/.gtkrc-2.0
	_EOF
	echo -e "\n$String" >> ${CSM_PROFILE}
fi
