# csm script for buku bookmarks export

# needs https://github.com/thewisenerd/Buku/commit/f0e06085041e01309c54f0fe6692fe46d158e74e
# use at own risk for now.

if [ $private -eq 0 ]; then
	log_warn "buku: please use only in --private mode!\n"
	return
fi

mkdir -p "${CSM_HOME}/${CSM_USER_DATA_DIR}"

buku --export "${CSM_HOME}/${CSM_USER_DATA_DIR}/Bookmarks" --chromeprofile

read -d '' String <<-_EOF

# csm extensions
private-home ${CSM_HOME}/.config
_EOF

echo -e "$String" >> ${CSM_PROFILE}
