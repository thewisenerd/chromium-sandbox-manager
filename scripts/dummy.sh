# this is a dummy script for csm

# variables:
# ==========
# ${CSM_PATH}    = path to csm script
# ${CSM_HOME}    = temporary folder to put your files at. copy to firejail from here.
# ${CSM_PWD}     = path where csm was called
# ${CSM_PROFILE} = firejail profile file to be used ( be careful not to override/overwrite )
# ${CSM_BIN}     = binary to call ("" by default, autoset if appimage is not "") # one in "chromium" "chromium-browser" "chrome" "google-chrome"
# ${CSM_USER_DATA_DIR} = user data directory; # ~/.config/{chromium,google-chrome}/Default

# ${appimage}         = path to appimage ("" by default)
# ${private}          = 0: not private, 1: private
# ${verbose}          = 0: not verbose, 1: be verbose (please try to respect this var)
# ${sandbox_args}     = sandbox arguments ("" by default) ( be careful not to override )
# ${fireprofiles_dir} = path to fireprofiles
# ${userscripts[@]}   = list of scripts to be loaded
# ${scripts_path[@]}  = path to the scripts
# ${extras[@]}        = extra _possibly invalid_ arguments (can be used for scripts)

# $1 = path of current file ( since source _script_ is used, this is needed )

# functions:
# ==========
# text_bold   : bold text      ( w/o newline )
# text_italic : italic_text    ( w/o newline )
# log         : log text       ( w/o newline )
# log_info    : log info text  ( w/o newline )
# log_warn    : log warn text  ( w/o newline )
# log_fatal   : log fatal text ( w/o newline )

# test_file_read    : check file   exist | file   | readable | nonzero
# test_folder_read  : check folder exist | folder | readable
# test_file_execute : check file   executable
# containsElement   : array contains element;    eg: containsElement "${path}" "${scripts_path[@]}"
# deleteElement     : delete element from array; eg: deleteElement "${path}" scripts_path

# cmd__load_script = when you want one script to run before another ( be careful not to add it to --load )

logv_info "dummy: start load\n"

# the firejail profiles are a powerful tool.
# more info on how to write firejail profiles, can be found here: https://firejail.wordpress.com/features-3/man-firejail-profile/

cat >> ${CSM_PROFILE} <<-_EOF

# noroot by default
noroot
_EOF
