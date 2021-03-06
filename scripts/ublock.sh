# csm script for https://github.com/gorhill/uBlock

local __dir="uBlock"
local __path="${csm_extensions_dir}/${__dir}"

local __name="uBlock0.chromium"
local __build="${__path}/dist/build/uBlock0.chromium"
local __dest="${CSM_HOME}/${CSM_EXTS_DIR}/${__name}"


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

register_extension "${__name}" "${__build}"

local __assets="${1}/ublock"
patch -t -p0 -d "${__dest}" < "${__assets}/01-uBlock-load-local-adminSettings.patch" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	logv_warn "patching uBlock failed.\n"
fi
cp "${__assets}/uBlockadminSettings.json" "${__dest}/assets/ublock/adminSettings.json"

# restore cwd
cd ${CSM_PWD}
