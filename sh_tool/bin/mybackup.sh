#!/bin/bash
#
# @brief   MySQL Backup Manager
# @version ver.3.0
# @date    Mon 29 Nov 2021 11:44:02 PM CET
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=${UTIL_ROOT}/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/check_root.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/check_op.sh
.    ${UTIL}/bin/logging.sh
.    ${UTIL}/bin/load_conf.sh
.    ${UTIL}/bin/load_util_conf.sh
.    ${UTIL}/bin/send_mail.sh
.    ${UTIL}/bin/progress_bar.sh
.    ${UTIL}/bin/display_logo.sh

MYBACKUP_TOOL=mybackup
MYBACKUP_VERSION=ver.3.0
MYBACKUP_HOME=${UTIL_ROOT}/${MYBACKUP_TOOL}/${MYBACKUP_VERSION}
MYBACKUP_CFG=${MYBACKUP_HOME}/conf/${MYBACKUP_TOOL}.cfg
MYBACKUP_UTIL_CFG=${MYBACKUP_HOME}/conf/${MYBACKUP_TOOL}_util.cfg
MYBACKUP_LOGO=${MYBACKUP_HOME}/conf/${MYBACKUP_TOOL}.logo
MYBACKUP_LOG=${MYBACKUP_HOME}/log

declare -A MYBACKUP_USAGE=(
    [USAGE_TOOL]="${MYBACKUP_TOOL}"
    [USAGE_ARG1]="[OPTION] help"
    [USAGE_EX_PRE]="# Get this info"
    [USAGE_EX]="${MYBACKUP_TOOL} help"
)

declare -A MYBACKUP_LOGGING=(
    [LOG_TOOL]="${MYBACKUP_TOOL}"
    [LOG_FLAG]="info"
    [LOG_PATH]="${MYBACKUP_LOG}"
    [LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
    [BW]=50
    [MP]=100
    [SLEEP]=0.01
)

declare -A MYBACKUP_LOGO_DATA=(
    [OWNER]="vroncevic"
    [REPO]="${MYBACKUP_TOOL}"
    [VERSION]="${MYBACKUP_VERSION}"
    [LOGO]="${MYBACKUP_LOGO}"
)

TOOL_DBG="false"
TOOL_LOG="false"
TOOL_NOTIFY="false"

#
# @brief  Creating MySQL dump for database
# @param  Value required SQL file name and database name
# @retval Success return 0, else 1
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# __backup "SQL_FILE" "$DB"
# STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
# else
#    # false
# fi
#
function __backup {
    local MYDUMP=$1 SQLF=$2 DB=$3 FUNC=${FUNCNAME[0]} MSG="None" STATUS
    if [[ -n "${MYDUMP}" && -n "${SQLF}" && -n "${DB}" ]]; then
        MSG="Run backup mechanism"
        info_debug_message "$MSG" "$FUNC" "$MYBACKUP_TOOL"
        unalias rm 2> /dev/null
        rm ${SQLF} 2> /dev/null
        rm ${SQLF}.gz 2> /dev/null
        eval "${MYDUMP} -uroot ${DB} > ${SQLF}"
        gzip $SQLF
        info_debug_message "Done" "$FUNC" "$MYBACKUP_TOOL"
        return $SUCCESS
    fi
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$MYBACKUP_TOOL"
    return $NOT_SUCCESS
}

#
# @brief   Main function
# @param   Value optional help
# @retval  Function __mybackup exit with integer value
#            0   - tool finished with success operation 
#            128 - failed to load tool script configuration from files
#            129 - missing external tool mysqldump
#
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
function __mybackup {
    local HELP=$1
    if [ "${HELP}" == "help" ]; then
        usage MYBACKUP_USAGE
        exit 0
    fi
    display_logo MYBACKUP_LOGO_DATA
    local FUNC=${FUNCNAME[0]} MSG="None" STATUS_CONF STATUS_CONF_UTIL STATUS
    MSG="Loading basic and util configuration!"
    info_debug_message "$MSG" "$FUNC" "$MYBACKUP_TOOL"
    progress_bar PB_STRUCTURE
    declare -A config_mybackup=()
    load_conf "$MYBACKUP_CFG" config_mybackup
    STATUS_CONF=$?
    declare -A config_mybackup_util=()
    load_util_conf "$MYBACKUP_UTIL_CFG" config_mybackup_util
    STATUS_CONF_UTIL=$?
    declare -A STATUS_STRUCTURE=([1]=$STATUS_CONF [2]=$STATUS_CONF_UTIL)
    check_status STATUS_STRUCTURE
    STATUS=$?
    if [ $STATUS -eq $NOT_SUCCESS ]; then
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$MYBACKUP_TOOL"
        exit 128
    fi
    TOOL_DBG=${config_mybackup[DEBUGGING]}
    TOOL_LOG=${config_mybackup[LOGGING]}
    TOOL_NOTIFY=${config_mybackup[EMAILING]}
    local SHDBS="SHOW DATABASES LIKE" MYDUMP=${config_mybackup_util[MYSQLDUMP]}
    check_tool "${MYDUMP}"
    STATUS=$?
    if [ $STATUS -eq $NOT_SUCCESS ]; then
        MSG="Force exit!"
        info_debug_message_end "$MSG" "$FUNC" "$MYBACKUP_TOOL"
        return 129
    fi
    local FILE=company.mysql.`date +"%Y%m%d"`
    local DBS=${config_mybackup_util[MYSQL_DATABASES]}
    local MYSQLDUMPDIR=${config_mybackup_util[MYSQLDUMP_ROOT_LOCATION]}
    IFS=' ' read -ra databases <<< "${DBS}"
    for i in "${databases[@]}"
    do
        local DB RESULT SQL
        DB=$i
        RESULT=`mysql -uroot -p --skip-column-names -e "${SHDBS} '${DB}'"`
        if [ "${RESULT}" == "${DB}" ]; then
            SQL="${MYSQLDUMPDIR}/${FILE}_${DB}"
            __backup "${MYDUMP}" "$SQL" "$DB"
            STATUS=$?
            if [ $STATUS -eq $SUCCESS ]; then
                MSG="Backup [${SQL}.gz] was created"
                info_debug_message "$MSG" "$FUNC" "$MYBACKUP_TOOL"
                ls -l "${SQL}.gz"
                MYBACKUP_LOGGING[LOG_FLAG]="info"
                MYBACKUP_LOGGING[LOG_MSGE]="Backup [${SQL}.gz] was created"
                logging MYBACKUP_LOGGING
                MSG="${MYBACKUP_LOG[LOG_MSGE]}"
                info_debug_message "$MSG" "$FUNC" "$MYBACKUP_TOOL"
            else
                MYBACKUP_LOGGING[LOG_FLAG]="error"
                MYBACKUP_LOGGING[LOG_MSGE]="Can't create SQL file [${SQL}]"
                logging MYBACKUP_LOGGING
                MSG="${MYBACKUP_LOG[LOG_MSGE]}"
                info_debug_message "$MSG" "$FUNC" "$MYBACKUP_TOOL"
            fi
        else
            MYBACKUP_LOGGING[LOG_FLAG]="error"
            MYBACKUP_LOGGING[LOG_MSGE]="Database [${DB}] does not exist"
            logging MYBACKUP_LOGGING
            MSG="${MYBACKUP_LOG[LOG_MSGE]}"
            info_debug_message "$MSG" "$FUNC" "$MYBACKUP_TOOL"
            send_mail "$MSG" "${config_mybackup_util[ADMIN_EMAIL]}"
        fi
    done
    info_debug_message "$MSG" "$FUNC" "$MYBACKUP_TOOL"
    exit 0
}

#
# @brief   Main entry point
# @param   Value optional help
# @exitval Script tool mybackup exit with integer value
#            0   - tool finished with success operation
#            127 - run tool script as root user from cli
#            128 - failed to load tool script configuration from files
#            129 - missing external tool mysqldump
#
printf "\n%s\n%s\n\n" "${MYBACKUP_TOOL} ${MYBACKUP_VERSION}" "`date`"
check_root
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
    __mybackup $1
fi

exit 127
