logv_info "extensions: start load\n"

CSM_EXTS_DIR=".csm_extensions"
local -a __EXTS
local -a __STATIC_EXTS
__EXTS=()
__STATIC_EXTS=()

register_extension() {
	name="${1}"
	path="${2}"
	cp -r "${path}" "${CSM_HOME}/${CSM_EXTS_DIR}/${name}"
	__EXTS+=( "${name}" )
	log_info "extensions: register extension: ${name}; ${path}\n"
}

register_static_extension() {
	name="${1}"
	path="${2}"
	__STATIC_EXTS+=( "${path}" )
	log_info "extensions: register static extension: ${name}; ${path}\n"
}

if [ -z "${csm_extensions_dir+x}" ]; then
	logv_fatal "extensions: \$csm_extensions_dir unset! skip loading extensions!\n"
	return
fi

# make ${CSM_HOME}/csm_extensions/
mkdir -p "${CSM_HOME}/${CSM_EXTS_DIR}"

##
## load your scripts here
##

# ublock, umatrix
cmd__load_script "uassets"
cmd__load_script "ublock"
cmd__load_script "umatrix"

# youtube+ (particle)
cmd__load_script "particle"

# browserpass
cmd__load_script "browserpass"

##
## load your scripts here (end)
##

if [ ${#__EXTS[@]} -eq 0 ]; then
	logv_info "no extensions to load!"
	return
fi

local -a T=()
local argstr
if [ $private -ne 0 ]; then
	for ext in "${__EXTS[@]}"; do
		T+=( "${HOME}/${CSM_EXTS_DIR}/${ext}" )
	done


	read -d '' String <<-_EOF
	# csm extensions
	private-home ${CSM_HOME}/${CSM_EXTS_DIR}
	_EOF
	echo -e "\n$String" >> ${CSM_PROFILE}
else
	for ext in "${__EXTS[@]}"; do
		T+=( "${CSM_HOME}/${CSM_EXTS_DIR}/${ext}" )
	done

fi
for ext in "${__STATIC_EXTS[@]}"; do
	T+=( "${ext}" )

	read -d '' String <<-_EOF
	# static extension
	noblacklist ${ext}
	whitelist ${ext}
	_EOF
	echo -e "\n$String" >> ${CSM_PROFILE}
done
argstr=$(local IFS=","; echo "${T[*]}" )

# add extensions to sandbox args
sandbox_args+=( "--load-extension=${argstr}" )
