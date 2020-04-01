#!/bin/bash
#
# @brief   Creating MySQL dump for database
# @version ver.1.0.0
# @date    Tue Apr 12 11:07:20 CEST 2016
# @company Frobas IT Department, www.frobas.com 2016
# @author  Vladimir Roncevic <vladimir.roncevic@frobas.com>
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

