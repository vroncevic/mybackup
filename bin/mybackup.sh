#!/bin/bash
#
# @brief   Backup mechanism for MySQL databases
# @version ver.1.0
# @date    Tue Apr 12 11:07:20 CEST 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
#
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=$UTIL_ROOT/sh-util-srv/$UTIL_VERSION
UTIL_LOG=$UTIL/log

. $UTIL/bin/devel.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/checkroot.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/sendmail.sh
. $UTIL/bin/loadconf.sh
. $UTIL/bin/loadutilconf.sh
. $UTIL/bin/progressbar.sh

MYBACKUP_NAME=mybackup
MYBACKUP_VERSION=ver.1.0
MYBACKUP_HOME=$UTIL_ROOT/$MYBACKUP_NAME/$MYBACKUP_VERSION
MYBACKUP_CFG=$MYBACKUP_HOME/conf/$MYBACKUP_NAME.cfg
MYBACKUP_UTIL_CFG=$MYBACKUP_HOME/conf/${MYBACKUP_TOOL}_util.cfg
MYBACKUP_LOG=$MYBACKUP_HOME/log

declare -A MYBACKUP_USAGE=(
	[USAGE_TOOL]="$TOOL_NAME"
	[USAGE_ARG1]="[OPTION] help"
	[USAGE_EX_PRE]="# Get this info"
	[USAGE_EX]="$TOOL_NAME help"	
)

declare -A MYBACKUP_LOG=(
	[LOG_TOOL]="$TOOL_NAME"
	[LOG_FLAG]="info"
	[LOG_PATH]="$TOOL_LOG"
	[LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
	[BAR_WIDTH]=50
	[MAX_PERCENT]=100
	[SLEEP]=0.01
)

TOOL_DEBUG="false"

#
# @brief  Creating MySQL dump for database
# @param  Value required SQL file name and database name
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __backup "SQL_FILE" "$DATABASE"
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#   # true
# else
#   # false
# fi
#
function __backup() {
	local SQL_FILE=$1
	local DATABASE=$2
	if [ -n "$SQL_FILE" ] && [ -n "$DATABASE" ]; then
		unalias rm     	   2> /dev/null
		rm ${SQL_FILE}     2> /dev/null
		rm ${SQL_FILE}.gz  2> /dev/null
		eval "${configmybackuputil[MYSQLDUMP]} -uroot $DATABASE > $SQL_FILE"
		gzip $SQL_FILE
		return $SUCCESS
	fi
	return $NOT_SUCCESS
}

#
# @brief   Main function
# @param   Value optional help
# @retval  Function __mybackup exit with integer value
#			0   - tool finished with success operation 
# 			128 - failed to load tool script configuration from file 
# 			129 - failed to load tool script utilities configuration from file
# 			130 - missing external tool mysqldump
#
function __mybackup() {
	if [ "$HELP" == "help" ]; then
        __usage MYBACKUP_USAGE
    fi
	local FUNC=${FUNCNAME[0]}
	local MSG="Loading basic and util configuration"
	printf "$SEND" "$MYBACKUP_TOOL" "$MSG"
	__progressbar PB_STRUCTURE
	printf "%s\n\n" ""
	declare -A configmybackup=()
	__loadconf $MYBACKUP_CFG configmybackup
	local STATUS=$?
	if [ $STATUS -eq $NOT_SUCCESS ]; then
		MSG="Failed to load tool script configuration"
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DSTA" "$MYBACKUP_TOOL" "$FUNC" "$MSG"
		else
			printf "$SEND" "$MYBACKUP_TOOL" "$MSG"
		fi
		exit 128
	fi
	declare -A configmybackuputil=()
	__loadutilconf $MYBACKUP_UTIL_CFG configmybackuputil
	STATUS=$?
	if [ $STATUS -eq $NOT_SUCCESS ]; then
		MSG="Failed to load tool script utilities configuration"
		if [ "$TOOL_DBG" == "true" ]; then
			printf "$DSTA" "$MYBACKUP_TOOL" "$FUNC" "$MSG"
		else
			printf "$SEND" "$MYBACKUP_TOOL" "$MSG"
		fi
		exit 129
	fi
	local SHOW_DBS="SHOW DATABASES LIKE"
    __checktool "${configmybackuputil[MYSQLDUMP]}"
    STATUS=$?
    if [ $STATUS -eq $NOT_SUCCESS ]; then
        MSG="Missing external tool ${configmybackuputil[MYSQLDUMP]}"
		if [ "${configmybackup[LOGGING]}" == "true" ]; then
			MYBACKUP_LOGGING[LOG_MSGE]="$MSG"
			MYBACKUP_LOGGING[LOG_FLAG]="error"
			__logging MYBACKUP_LOGGING
		fi
		if [ "${configmybackup[EMAILING]}" == "true" ]; then
			__sendmail "$MSG" "${configmybackup[ADMIN_EMAIL]}"
		fi
		return 130
    fi
    local FILE=company.mysql.`date +"%Y%m%d"`
    local DATABASE=XXX
	# TODO set array of databases 
    local -a databases=( my_test my_test2 )
    for i in "${databases[@]}"
    do
        DATABASE=$i
        local RESULT=`mysql -uroot --skip-column-names -e "$SHOW_DBS '$DATABASE'"`
        if [ "$RESULT" == "$DATABASE" ]; then
			local SQL="$MYSQLDUMP_ROOT_LOCATION/${FILE}_${DATABASE}"
            __backup "$SQL" "$DATABASE"
            STATUS=$?
            if [ $STATUS -eq $SUCCESS ]; then
				MSG="Backup [${SQL}.gz] was created"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DSTA" "$MYBACKUP_TOOL" "$FUNC" "$MSG"
				else
					printf "$SEND" "$MYBACKUP_TOOL" "$MSG"
				fi
                ls -l "${SQL}.gz"
                MYBACKUP_LOG[LOG_FLAG]="info"
                MYBACKUP_LOG[LOG_MSGE]="Backup [${SQL}.gz] was created"
                __logging MYBACKUP_LOG
				MSG="${MYBACKUP_LOG[LOG_MSGE]}"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DSTA" "$MYBACKUP_TOOL" "$FUNC" "$MSG"
				else
					printf "$SEND" "$MYBACKUP_TOOL" "$MSG"
				fi
            else
				MYBACKUP_LOG[LOG_FLAG]="error"
		        MYBACKUP_LOG[LOG_MSGE]="Can't create SQL file [$SQL]"
		        __logging MYBACKUP_LOG
				MSG="${MYBACKUP_LOG[LOG_MSGE]}"
				if [ "$TOOL_DBG" == "true" ]; then
					printf "$DSTA" "$MYBACKUP_TOOL" "$FUNC" "$MSG"
				else
					printf "$SEND" "$MYBACKUP_TOOL" "$MSG"
				fi
				:
            fi
        else
			MYBACKUP_LOG[LOG_FLAG]="error"
            MYBACKUP_LOG[LOG_MSGE]="Database [$DATABASE] does not exist"
            __logging MYBACKUP_LOG
			MSG="${MYBACKUP_LOG[LOG_MSGE]}"
			if [ "$TOOL_DBG" == "true" ]; then
				printf "$DSTA" "$MYBACKUP_TOOL" "$FUNC" "$MSG"
			else
				printf "$SEND" "$MYBACKUP_TOOL" "$MSG"
			fi
			if [ "${configmybackup[EMAILING]}" == "true" ]; then
				__sendmail "$MSG" "${configmybackup[ADMIN_EMAIL]}"
			fi
        fi
    done
	if [ "$TOOL_DBG" == "true" ]; then
		printf "$DSTA" "$MYBACKUP_TOOL" "$FUNC" "Done"
	else
		printf "$SEND" "$MYBACKUP_TOOL" "Done"
	fi
	exit 0
}

#
# @brief   Main entry point
# @param   Value optional help
# @exitval Script tool mybackup exit with integer value
#			0   - tool finished with success operation 
# 			127 - run tool script as root user from cli
# 			128 - failed to load tool script configuration from file 
# 			129 - failed to load tool script utilities configuration from file
# 			130 - missing external tool mysqldump
#
printf "\n%s\n%s\n\n" "$MYBACKUP_NAME $MYBACKUP_VERSION" "`date`"
__checkroot
STATUS=$?
if [ "$STATUS" -eq "$SUCCESS" ]; then
    __mybackup $1
fi

exit 127

