# csm script for https://github.com/gorhill/uBlock

local __dir="uBlock"
local __path="${csm_extensions_dir}/${__dir}"

local __name="uBlock0.chromium"
local __build="${__path}/dist/build/uBlock0.chromium"

if [ "$(test_folder_read "${__path}")" == "1" ]; then
	logv_warn "${__path} not readable, skip loading ${__name}\n"
	return
fi

# check if uAssets was skipped
if [ -z "${__skip_uAssets}" ]; then
	logv_warn "skipped uAssets. skipping uBlock;\n"
	return;
fi
if [ $__skip_uAssets -ne 0 ]; then
	logv_warn "skipped uAssets. skipping uBlock;\n"
	return;
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

tools/make-chromium.sh > /dev/null


# todo: my patches

register_extension "${__name}" "${__build}"

# restore cwd
cd ${CSM_PWD}
