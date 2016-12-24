# csm script for https://github.com/ParticleCore/Particle

local __dir="Particle"
local __path="${csm_extensions_dir}/${__dir}"

local __name="Particle"
local __build="${__path}/src/Webextension"

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

# restore cwd
cd ${CSM_PWD}
