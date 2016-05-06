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

. $UTIL/bin/checkroot.sh
. $UTIL/bin/checktool.sh
. $UTIL/bin/checkcfg.sh
. $UTIL/bin/logging.sh
. $UTIL/bin/usage.sh
. $UTIL/bin/devel.sh

TOOL_NAME=mybackup
TOOL_VERSION=ver.1.0
TOOL_HOME=$UTIL_ROOT/$TOOL_NAME/$TOOL_VERSION
TOOL_CFG=$TOOL_HOME/conf/$TOOL_NAME.cfg
TOOL_LOG=$TOOL_HOME/log

declare -A ATMANAGER_USAGE=(
	[TOOL_NAME]="__$TOOL_NAME"
	[ARG2]="[OPTION] help"
	[EX-PRE]="# Restart Apache Tomcat Server"
	[EX]="__$TOOL_NAME restart"	
)

declare -A LOG=(
	[TOOL]="$TOOL_NAME"
	[FLAG]="info"
	[PATH]="$TOOL_LOG"
	[MSG]=""
)

TOOL_DEBUG="false"

MYSQLDUMP="/usr/bin/mysqldump"
MYSQLDUMP_ROOT_LOCATION="/path-to-folder/mysql"

#
# @brief  Creating MySQL dump for database
# @params Values required database name and SQL file name
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __mybackup 
# STATUS=$?
#
# if [ "$STATUS" -eq "$SUCCESS" ]; then
#   # true
# else
#   # false
# fi
#
function __mybackup() {
	SQL_FILE=$1
	if [ -n "$SQL_FILE" ]; then
		unalias rm     	   2> /dev/null
		rm ${SQL_FILE}     2> /dev/null
		rm ${SQL_FILE}.gz  2> /dev/null
		eval "$MYSQLDUMP -uroot ${DATABASE} > ${SQL_FILE}"
		gzip $SQL_FILE
		return $SUCCESS
	fi
	return $NOT_SUCCESS
}

#
# @brief Main entry point
# @param Value optional help
#
printf "\n%s\n%s\n\n" "$TOOL_NAME $TOOL_VERSION" "`date`"
HELP=$1
__checkroot
STATUS=$?
if [ "$STATUS" -eq "$SUCCESS" ]; then
    if [ "$HELP" == "help" ]; then
        __usage $TOOL_USAGE
    else
        __checktool "$MYSQLDUMP"
        STATUS=$?
        if [ "$STATUS" -eq "$NOT_SUCCESS" ]; then
            exit 127
        fi
        FILE=nsfrobas.mysql.`date +"%Y%m%d"`
        DATABASE=XXX
		# TODO set list of databases 
        databases=( my_test my_test2 )
        for i in "${databases[@]}"
        do
            DATABASE=$i
            RESULT=`mysql -uroot --skip-column-names -e "SHOW DATABASES LIKE '$DATABASE'"`
            if [ "$RESULT" == "$DATABASE" ]; then
                __mybackup "$MYSQLDUMP_ROOT_LOCATION/${FILE}_${DATABASE}"
                STATUS=$?
                if [ "$STATUS" -eq "$SUCCESS" ]; then
					if [ "$TOOL_DEBUG" == "true" ]; then
                    	printf "%s\n" "Backup [$MYSQLDUMP_ROOT_LOCATION/${FILE}_${DATABASE}.gz] was created"
					fi
                    ls -l "$MYSQLDUMP_ROOT_LOCATION/${FILE}_${DATABASE}.gz"
                    LOG[FLAG]="info"
                    LOG[PATH]="$TOOL_LOG"
                    LOG[MSG]="Backup [$MYSQLDUMP_ROOT_LOCATION/${FILE}_${DATABASE}.gz] was created"
					if [ "$TOOL_DEBUG" == "true" ]; then
						printf "%s\n\n" "${LOG[MSG]}"
					fi
                    __logging $LOG
                else
					if [ "$TOOL_DEBUG" == "true" ]; then
                    	printf "%s\n\n" "[Error] Can't create SQL file [$MYSQLDUMP_ROOT_LOCATION/${FILE}_${DATABASE}]"
					fi
					:
                fi
            else
				LOG[FLAG]="error"
                LOG[PATH]="$TOOL_LOG"
                LOG[MSG]="Database [$DATABASE] does not exist"
				if [ "$TOOL_DEBUG" == "true" ]; then
                	printf "%s\n" "[Error] ${LOG[MSG]}"
				fi
                __logging $LOG
            fi
        done
    fi
fi

exit 0

