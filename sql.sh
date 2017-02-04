#!/bin/bash
#set -x
#Define log
TIMESTAMP=`date +%Y%m%d%H%M%S`
LOG=call_sql_${TIMESTAMP}.log
echo "Start execute sql statement at `date`.">>${LOG}

#*               soft                0
#executesqlstat
mysql -P 3866 -h 192.168.0.60 -uinvsql -p'#Ud2016fp^,' -e"
tee /tmp/temp.log
use inv
UPDATE fin_token SET STATUS = 0 WHERE id > 17;
notee
quit"
echo "">>${LOG}
echo "below is output result.">>${LOG}
cat /tmp/temp.log>>${LOG}
echo "script executed successful.">>${LOG}
exit;
