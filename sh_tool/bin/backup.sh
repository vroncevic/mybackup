#!/bin/bash
#
# @brief   MySQL Backup Manager
# @version ver.2.0
# @date    Mon 29 Nov 2021 11:44:02 PM CET
# @company None, free software to use 2021
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#

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
    local SQLF=$1 DB=$2 FUNC=${FUNCNAME[0]} MSG="None" STATUS
    if [[ -n "${SQLF}" && -n "${DB}" ]]; then
        MSG="Run backup mechanism"
        info_debug_message "$MSG" "$FUNC" "$MYBACKUP_TOOL"
        unalias rm 2> /dev/null
        rm ${SQLF} 2> /dev/null
        rm ${SQLF}.gz 2> /dev/null
        local MYDUMP=${config_mybackup_util[MYSQLDUMP]}
        eval "${MYDUMP} -uroot ${DB} > ${SQLF}"
        gzip $SQLF
        info_debug_message "Done" "$FUNC" "$MYBACKUP_TOOL"
        return $SUCCESS
    fi
    MSG="Force exit!"
    info_debug_message_end "$MSG" "$FUNC" "$MYBACKUP_TOOL"
    return $NOT_SUCCESS
}

