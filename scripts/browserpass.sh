# csm script for browserpass

# modify this if --private
GPG_USER_ID="thewisenerd"


local __dir="browserpass"
local __path="${csm_extensions_dir}/${__dir}"

local __name="browserpass"
local __build="${__path}/chrome"

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
	npm install --update --silent
fi

# # start building

# check browserify
which "browserify" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	logv_fatal "browserify not found! skipping building ${__name}!\n"
	return
fi
which "go" > /dev/null 2>&1
if [ $? -ne 0 ]; then
	logv_fatal "go (golang) not found! skipping building ${__name}!\n"
	return
fi

make js > /dev/null
make browserpass-linux64 > /dev/null

if [ $private -ne 0 ]; then
	local TARGET_DIR_CHROMIUM="${CSM_HOME}/$( dirname "${CSM_USER_DATA_DIR}" )/NativeMessagingHosts"
	local HOST_FILE="${HOME}/browserpass-linux64"
else
	local TARGET_DIR_CHROMIUM="${HOME}/$( dirname "${CSM_USER_DATA_DIR}" )/NativeMessagingHosts"
	local HOST_FILE="$( realpath "${__path}/browserpass-linux64" )"
fi
local APP_NAME="com.dannyvankooten.browserpass"
ESCAPED_HOST_FILE=${HOST_FILE////\\/}

mkdir -p "${TARGET_DIR_CHROMIUM}"
cp "${__path}/chrome/host.json" "${TARGET_DIR_CHROMIUM}/$APP_NAME.json"

# hostname
sed -i -e "s/%%replace%%/$ESCAPED_HOST_FILE/" "${TARGET_DIR_CHROMIUM}/$APP_NAME.json"

# app id
# todo: find a way to figure this out
if [ $private -ne 0 ]; then
	sed -i -e "s/jegbgfamcgeocbfeebacnkociplhmfbk/nkodmognfjbkhaomhfgfiilmlddigjbp/" "${TARGET_DIR_CHROMIUM}/$APP_NAME.json"
else
	sed -i -e "s/jegbgfamcgeocbfeebacnkociplhmfbk/dkcpmojhhimjlaeabbcohbdpobjjhnea/" "${TARGET_DIR_CHROMIUM}/$APP_NAME.json"
fi

# chmod
chmod o+r "${TARGET_DIR_CHROMIUM}/$APP_NAME.json"

read -d '' String <<-_EOF
# browserpass host file
noblacklist ${HOST_FILE}
whitelist ${HOST_FILE}

noblacklist ${HOME}/.password-store
whitelist ${HOME}/.password-store

noblacklist ~/public.key
whitelist ~/public.key
_EOF

echo -e "\n$String" >> ${CSM_PROFILE}

# export gpg public key
gpg --output ${CSM_HOME}/public.key --armor --export "${GPG_USER_ID}"

if [ $private -ne 0 ]; then

	post_init_hooks+=( "gpg --import ${HOME}/public.key" )

	read -d '' String <<-_EOF
		private-home ${HOME}/.password-store
		private-home ${CSM_HOME}/public.key

		# browserpass host file copy
		private-home ${__path}/browserpass-linux64

		private-home ${CSM_HOME}/.config
	_EOF
	echo -e "\n$String" >> ${CSM_PROFILE}

	register_extension "${__name}" "${__build}"
else

	post_init_hooks+=( "gpg --import ${CSM_HOME}/public.key" )

	register_static_extension "${__name}" "$( realpath "${__build}" )"
fi
