# csm script for https://github.com/gorhill/uMatrix

local __dir="uMatrix"
local __path="${csm_extensions_dir}/${__dir}"

local __name="uMatrix.chromium"
local __build="${__path}/dist/build/uMatrix.chromium"
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

# copy current uMatrix settings
uMsqlPath="${HOME}/.mozilla/firefox/user.default/extension-data/umatrix.sqlite"
local __assets="${1}/umatrix"
if [[ "$(test_file_read "${uMsqlPath}" )" == "0" ]]; then
	patch -t -p0 -d "${__dest}" < "${__assets}/01-uMatrix-load-userMatrix.patch" > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		logv_warn "patching uMatrix failed.\n"
	fi

	sqlite3 ${uMsqlPath} "select value from settings where name = \"userMatrix\";" | sed s/^\"//g | sed s/\"\$//g | sed s/"\\\\n"/"\n"/g > "${__dest}/assets/umatrix/userMatrix.txt"
fi

# restore cwd
cd ${CSM_PWD}
