#!/bin/bash -
#===============================================================================
# vim: softtabstop=4 shiftwidth=4 expandtab fenc=utf-8 spell spelllang=en cc=81
#===============================================================================
#
#          FILE: auto_fix_bash_bug.sh
#
#   DESCRIPTION: Auto fix bash bug. Use this script in all of linux distribution. Bug see at:http://seclists.org/oss-sec/2014/q3/650
#
#     COPYRIGHT: (c) 2014 By Robin 
#
#       LICENSE: Apache 2.0
#       CREATED: 11/11/2014 11:00:00
#===============================================================================

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  echoerr
#   DESCRIPTION:  Echo errors to stderr.
#-------------------------------------------------------------------------------
echoerror() {
    printf "${RC} * ERROR${EC}: $@\n" 1>&2;
}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  echoinfo
#   DESCRIPTION:  Echo information to stdout.
#-------------------------------------------------------------------------------
echoinfo() {
    printf "${GC} *  INFO${EC}: %s\n" "$@";
}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  echowarn
#   DESCRIPTION:  Echo warning informations to stdout.
#-------------------------------------------------------------------------------
echowarn() {
    printf "${YC} *  WARN${EC}: %s\n" "$@";
}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  echodebug
#   DESCRIPTION:  Echo debug information to stdout.
#-------------------------------------------------------------------------------
echodebug() {
    if [ $_ECHO_DEBUG -eq $BS_TRUE ]; then
        printf "${BC} * DEBUG${EC}: %s\n" "$@";
    fi
}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  __test_distro_arch
#   DESCRIPTION:  Echo errors to stderr.
#-------------------------------------------------------------------------------
__test_distro_arch() {
    ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
    if [ "$ARCH" = 32 ]; then
        echoerror "32-bit Arch kernel does not support"
        exit 1
    fi
}
__test_distro_arch

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  __strip_duplicates
#   DESCRIPTION:  Strip duplicate strings
#-------------------------------------------------------------------------------
__strip_duplicates() {
    echo $@ | tr -s '[:space:]' '\n' | awk '!x[$0]++'
}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  __function_defined
#   DESCRIPTION:  Checks if a function is defined within this scripts scope
#    PARAMETERS:  function name
#       RETURNS:  0 or 1 as in defined or not defined
#-------------------------------------------------------------------------------
__function_defined() {
    FUNC_NAME=$1
    if [ "$(command -v $FUNC_NAME)x" != "x" ]; then
        echoinfo "Found function $FUNC_NAME"
        return 0
    fi
    echodebug "$FUNC_NAME not found...."
    return 1
}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  __parse_version_string
#   DESCRIPTION:  Parse version strings ignoring the revision.
#                 MAJOR.MINOR.REVISION becomes MAJOR.MINOR
#-------------------------------------------------------------------------------
__parse_version_string() {
    VERSION_STRING="$1"
    PARSED_VERSION=$(
        echo $VERSION_STRING |
        sed -e 's/^/#/' \
            -e 's/^#[^0-9]*\([0-9][0-9]*\.[0-9][0-9]*\)\(\.[0-9][0-9]*\).*$/\1/' \
            -e 's/^#[^0-9]*\([0-9][0-9]*\.[0-9][0-9]*\).*$/\1/' \
            -e 's/^#[^0-9]*\([0-9][0-9]*\).*$/\1/' \
            -e 's/^#.*$//'
    )
    echo $PARSED_VERSION
}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  __sort_release_files
#   DESCRIPTION:  Custom sort function. Alphabetical or numerical sort is not
#                 enough.
#-------------------------------------------------------------------------------
__sort_release_files() {
    KNOWN_RELEASE_FILES=$(echo "(arch|centos|debian|ubuntu|fedora|redhat|suse|\
        mandrake|mandriva|gentoo|slackware|turbolinux|unitedlinux|lsb|system|\
        os)(-|_)(release|version)" | sed -r 's:[[:space:]]::g')
    primary_release_files=""
    secondary_release_files=""
    # Sort know VS un-known files first
    for release_file in $(echo $@ | sed -r 's:[[:space:]]:\n:g' | sort --unique --ignore-case); do
        match=$(echo $release_file | egrep -i ${KNOWN_RELEASE_FILES})
        if [ "x${match}" != "x" ]; then
            primary_release_files="${primary_release_files} ${release_file}"
        else
            secondary_release_files="${secondary_release_files} ${release_file}"
        fi
    done

    # Now let's sort by know files importance, max important goes last in the max_prio list
    max_prio="redhat-release centos-release"
    for entry in $max_prio; do
        if [ "x$(echo ${primary_release_files} | grep $entry)" != "x" ]; then
            primary_release_files=$(echo ${primary_release_files} | sed -e "s:\(.*\)\($entry\)\(.*\):\2 \1 \3:g")
        fi
    done
    # Now, least important goes last in the min_prio list
    min_prio="lsb-release"
    for entry in $max_prio; do
        if [ "x$(echo ${primary_release_files} | grep $entry)" != "x" ]; then
            primary_release_files=$(echo ${primary_release_files} | sed -e "s:\(.*\)\($entry\)\(.*\):\1 \3 \2:g")
        fi
    done

    # Echo the results collapsing multiple white-space into a single white-space
    echo "${primary_release_files} ${secondary_release_files}" | sed -r 's:[[:space:]]:\n:g'
}

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  __gather_linux_system_info
#   DESCRIPTION:  Discover Linux system information
#-------------------------------------------------------------------------------
__gather_linux_system_info() {
    DISTRO_NAME=""
    DISTRO_VERSION=""

    # Let's test if the lsb_release binary is available
    rv=$(lsb_release >/dev/null 2>&1)
    if [ $? -eq 0 ]; then
        DISTRO_NAME=$(lsb_release -si)
        if [ "x$(echo "$DISTRO_NAME" | grep RedHat)" != "x" ]; then
            # Let's convert CamelCase to Camel Case
            DISTRO_NAME=$(__camelcase_split "$DISTRO_NAME")
        fi
        if [ "${DISTRO_NAME}" = "openSUSE project" ]; then
            # lsb_release -si returns "openSUSE project" on openSUSE 12.3
            DISTRO_NAME="opensuse"
        fi
        if [ "${DISTRO_NAME}" = "SUSE LINUX" ]; then
            # lsb_release -si returns "SUSE LINUX" on SLES 11 SP3
            DISTRO_NAME="suse"
        fi
        rv=$(lsb_release -sr)
        [ "${rv}x" != "x" ] && DISTRO_VERSION=$(__parse_version_string "$rv")
    elif [ -f /etc/lsb-release ]; then
        # We don't have the lsb_release binary, though, we do have the file it parses
        DISTRO_NAME=$(grep DISTRIB_ID /etc/lsb-release | sed -e 's/.*=//')
        rv=$(grep DISTRIB_RELEASE /etc/lsb-release | sed -e 's/.*=//')
        [ "${rv}x" != "x" ] && DISTRO_VERSION=$(__parse_version_string "$rv")
    fi

    if [ "x$DISTRO_NAME" != "x" ] && [ "x$DISTRO_VERSION" != "x" ]; then
        # We already have the distribution name and version
        return
    fi

    for rsource in $(__sort_release_files $(
            cd /etc && /bin/ls *[_-]release *[_-]version 2>/dev/null | env -i sort | \
            sed -e '/^redhat-release$/d' -e '/^lsb-release$/d'; \
            echo redhat-release lsb-release
            )); do

        [ -L "/etc/${rsource}" ] && continue        # Don't follow symlinks
        [ ! -f "/etc/${rsource}" ] && continue      # Does not exist

        n=$(echo ${rsource} | sed -e 's/[_-]release$//' -e 's/[_-]version$//')
        rv=$( (grep VERSION /etc/${rsource}; cat /etc/${rsource}) | grep '[0-9]' | sed -e 'q' )
        [ "${rv}x" = "x" ] && continue  # There's no version information. Continue to next rsource
        v=$(__parse_version_string "$rv")
        case $(echo ${n} | tr '[:upper:]' '[:lower:]') in
            redhat             )
                if [ ".$(egrep 'CentOS' /etc/${rsource})" != . ]; then
                    n="CentOS"
                elif [ ".$(egrep 'Red Hat Enterprise Linux' /etc/${rsource})" != . ]; then
                    n="<R>ed <H>at <E>nterprise <L>inux"
                else
                    n="<R>ed <H>at <L>inux"
                fi
                ;;
            arch               ) n="Arch Linux"     ;;
            centos             ) n="CentOS"         ;;
            redhat			   ) n="RedHat"         ;;
            debian             ) n="Debian"         ;;
            ubuntu             ) n="Ubuntu"         ;;
            fedora             ) n="Fedora"         ;;
            suse               ) n="SUSE"           ;;
            system             )
                while read -r line; do
                    [ "${n}x" != "systemx" ] && break
                    case "$line" in
                        *Amazon*Linux*AMI*)
                            n="Amazon Linux AMI"
                            break
                    esac
                done < /etc/${rsource}
                ;;
            os                 )
                nn=$(grep '^ID=' /etc/os-release | sed -e 's/^ID=\(.*\)$/\1/g')
                rv=$(grep '^VERSION_ID=' /etc/os-release | sed -e 's/^VERSION_ID=\(.*\)$/\1/g')
                [ "${rv}x" != "x" ] && v=$(__parse_version_string "$rv") || v=""
                case $(echo ${nn} | tr '[:upper:]' '[:lower:]') in
                    arch        )
                        n="Arch Linux"
                        v=""  # Arch Linux does not provide a version.
                        ;;
                    debian      )
                        n="Debian"
                        if [ "${v}x" = "x" ]; then
                            if [ "$(cat /etc/debian_version)" = "wheezy/sid" ]; then
                                # I've found an EC2 wheezy image which did not tell its version
                                v=$(__parse_version_string "7.0")
                            fi
                        else
                            echowarn "Unable to parse the Debian Version"
                        fi
                        ;;
                    *           )
                        n=${nn}
                        ;;
                esac
                ;;
            *                  ) n="${n}"           ;
        esac
        DISTRO_NAME=$n
        DISTRO_VERSION=$v
        break
    done
}
__gather_linux_system_info

# Simplify distro name naming on functions
DISTRO_NAME_L=$(echo $DISTRO_NAME | tr '[:upper:]' '[:lower:]' | sed 's/[^a-zA-Z0-9_ ]//g' | sed -re 's/([[:space:]])+/_/g')
DISTRO_MAJOR_VERSION="$(echo $DISTRO_VERSION | sed 's/^\([0-9]*\).*/\1/g')"
DISTRO_MINOR_VERSION="$(echo $DISTRO_VERSION | sed 's/^\([0-9]*\).\([0-9]*\).*/\2/g')"
PREFIXED_DISTRO_MAJOR_VERSION="_${DISTRO_MAJOR_VERSION}"
if [ "${PREFIXED_DISTRO_MAJOR_VERSION}" = "_" ]; then
    PREFIXED_DISTRO_MAJOR_VERSION=""
fi
PREFIXED_DISTRO_MINOR_VERSION="_${DISTRO_MINOR_VERSION}"
if [ "${PREFIXED_DISTRO_MINOR_VERSION}" = "_" ]; then
    PREFIXED_DISTRO_MINOR_VERSION=""
fi

#---  FUNCTION  ----------------------------------------------------------------
#          NAME:  __check_distributions_versions
#   DESCRIPTION:  Check for distribution versions
#-------------------------------------------------------------------------------
__check_distributions_versions() {

    case "${DISTRO_NAME_L}" in
        debian)
			echo "Your distributions is debian."
            ;;

        ubuntu)
			echo "Your distributions is ubuntu."
            ;;

        opensuse)
			echo "Your distributions is opensuse."
            ;;

        suse)
			echo "Your distributions is suse."
            ;;

        fedora)
			echo "Your distributions is fedora."
            ;;

        centos)
			echo "Your distributions is centos."
            ;;

        red_hat*linux)
			echo "Your distributions is rhel."
            ;;

        redhat)
			echo "Your distributions is rhel."
            ;;

        *)
			echo "Your distributions is unknown."
            ;;
    esac
}
# Fail soon for end of life versions
__check_distributions_versions


##############################################################################
#
#   RedHat Install Functions
#
install_red_hat_enterprise_linux() {
	echo "Your linux is rhel."
	echo "Bash Bug."
	env x='() { :;}; echo vulnerable' bash -c 'echo hello'
	echo "Fixing bug."

	yum install gcc gcc-c++ wget -y
	curl https://raw.githubusercontent.com/luofei614/bashfix/master/bashfix|bash

	echo "Fix bug finished!"
	env x='() { :;}; echo vulnerable' bash -c 'echo hello'
	return 0
}

#
#   Ended RedHat Install Functions
#
##############################################################################

##############################################################################
#
#   CentOS Install Functions
#
install_centos() {
	echo "Your linux is centos."
	echo "Bash Bug."
	env x='() { :;}; echo vulnerable' bash -c 'echo hello'
	echo "Fixing bug."

	yum install gcc gcc-c++ wget -y
	curl https://raw.githubusercontent.com/luofei614/bashfix/master/bashfix|bash

	echo "Fix bug finished!"
	env x='() { :;}; echo vulnerable' bash -c 'echo hello'
	return 0
}

#
#   Ended CentOS Install Functions
#
##############################################################################

##############################################################################
#
#   Fedora Install Functions
#
install_fedora() {
	echo "Your linux is fedora."
	echo "Bash Bug."
	env x='() { :;}; echo vulnerable' bash -c 'echo hello'
	echo "Fixing bug."

	yum install gcc gcc-c++ wget -y
	curl https://raw.githubusercontent.com/luofei614/bashfix/master/bashfix|bash

	echo "Fix bug finished!"
	env x='() { :;}; echo vulnerable' bash -c 'echo hello'
	return 0
}
#
#   Ended Fedora Install Functions
#
##############################################################################

##############################################################################
#
#   Ubuntu Install Functions
#
install_ubuntu() {
	echo "Your linux is ubuntu."
	echo "Bash Bug."
	env x='() { :;}; echo vulnerable' bash -c 'echo hello'
	echo "Fixing bug."

	apt-get install make patch gcc gcc+ curl -y
	curl https://raw.githubusercontent.com/luofei614/bashfix/master/bashfix|bash

	echo "Fix bug finished!"
	env x='() { :;}; echo vulnerable' bash -c 'echo hello'
	return 0
}


#
#   Ended Ubuntu Install Functions
#
##############################################################################

##############################################################################
#
#   Debian Install Functions
#
install_debian() {
	echo "Your linux is debian."
	echo "Bash Bug."
	env x='() { :;}; echo vulnerable' bash -c 'echo hello'
	echo "Fixing bug."

	apt-get install make patch gcc gcc+ curl -y
	curl https://raw.githubusercontent.com/luofei614/bashfix/master/bashfix|bash

	echo "Fix bug finished!"
	env x='() { :;}; echo vulnerable' bash -c 'echo hello'
	return 0
}
#
#   Ended Debian Install Functions
#
##############################################################################

#=============================================================================
# INSTALLATION
#=============================================================================
# Let's get the install function
INSTALL_FUNC_NAMES="install_${DISTRO_NAME_L}"

INSTALL_FUNC="null"
for FUNC_NAME in $(__strip_duplicates $INSTALL_FUNC_NAMES); do
    if __function_defined $FUNC_NAME; then
        INSTALL_FUNC=$FUNC_NAME
        break
    fi
done
echodebug "INSTALL_FUNC=${INSTALL_FUNC}"

if [ $INSTALL_FUNC = "null" ]; then
    echoerror "No installation function found. Exiting..."
    exit 1
else
    echoinfo "Running ${INSTALL_FUNC}()"
    $INSTALL_FUNC
    if [ $? -ne 0 ]; then
        echoerror "Failed to run ${INSTALL_FUNC}()!!!"
        exit 1
    fi
fi

exit 0
