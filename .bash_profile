# bash will read either .bash_profile, .bash_login or .bash_logout (in that order)
# Must therefore make sure if this file exists, it sources .profile

source "${HOME}/.profile"
