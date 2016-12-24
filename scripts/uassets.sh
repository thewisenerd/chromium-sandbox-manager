# csm script for https://github.com/uBlockOrigin/uAssets.git

local __dir="uAssets"
local __path="${csm_extensions_dir}/${__dir}"

local __name="uAssets"


__skip_uAssets=0;
if [ ! -d "${__path}" -o ! -r "${__path}" ]; then
	logv_warn "${__path} not readable, skip loading ${__name}\n"
	__skip_uAssets=1;
	return
fi

local update=1
containsElement "--no-update" "${extras[@]}"
if [ $? -eq 0 ]; then
	update=0
fi

if [ $update -ne 0 ]; then
	cd ${__path}
	git pull -q origin master
	cd ${CSM_PWD}
fi
