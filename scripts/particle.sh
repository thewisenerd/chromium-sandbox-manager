# csm script for https://github.com/ParticleCore/Particle

local __dir="Particle"
local __path="${csm_extensions_dir}/${__dir}"

local __name="Particle"
local __build="${__path}/src/Webextension"
local __dest="${CSM_HOME}/${CSM_EXTS_DIR}/${__name}"


if [ "$(test_folder_read "${__path}")" == "1" ]; then
	logv_warn "${__path} not readable, skip loading ${__name}\n"
	return
fi

local update=1
containsElement "--no-update" "${extras[@]}"
if [ $? -eq 0 ]; then
	update=0
fi

# switch cwd
cd ${__path}

if [ $update -ne 0 ]; then
	git pull -q origin master
fi

register_extension "${__name}" "${__build}"

local __assets="${1}/particle"
patch -t -p0 -d "${__dest}" < "${__assets}/01-Particle-settings.patch" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	logv_warn "patching Particle failed.\n"
fi

# restore cwd
cd ${CSM_PWD}
