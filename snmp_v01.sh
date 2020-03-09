BMCip=$1
U=js_snmp
MIB=/share/SR630v2/XCC/afbt01w_101z/lnvgy_fw_xcc_afbt01w-0.01_lenovoxcc-anyos_noarch.mib
SPW=Passw0rd123
a=SHA
x=AES
OID=lenovoXCCMIB
BMCv=AFBT01W
para="-m $MIB -v3 -u $U -l authPriv -a $a -A $SPW -x $x -X $SPW $BMCip"
snmpwalkcollect="snmpwalk $para $OID"
snmpgetcollect="snmpget $para $flag"
snmptablecollect="snmptable $para $Tableflag"

if [ "$1" == "/h" ] || [ "$1" == "?" ] || [ "$1" == "" ] || [ "$1" == "help" ] || [ "$1" == "/?" ] || [ "$1" == "/help" ] || [ "$1" == "h" ];
then
	echo "==------------------------------------------------------=="
	echo "usage:"
	echo "## snmp.sh <IMM_IP>"
	echo "There are 3 log files."
	echo "snmpget_<BMCversion>.log"
	echo "snmpgetnext_<BMCversion>.log"
	echo "snmptable_<BMCversion>.log"
	echo "==------------------------------------------------------=="
	echo "## Please contact JackyJS_Chen@compal.com for any question"
	echo "==------------------------------------------------------=="
	exit
fi

mkdir $BMCv
$snmpwalkcollect |tee -a $BMCv/"snmpwalk_"$BMCv"".log
N=`cat $BMCv/snmpwalk_"$BMCv".log |wc -l`

echo ======================================|tee -a $BMCv/snmpget_"$BMCv".log
echo "There are $N snmp entry in system"|tee -a $BMCv/snmpget_"$BMCv".log
echo ======================================|tee -a $BMCv/snmpget_"$BMCv".log
echo "getcmd = $snmpgetcollect $flag"|tee -a $BMCv/snmpget_"$BMCv".log

for (( i=1 ; i<=$N ; i=i+1 ))
	do
		flag=`cat $BMCv/snmpwalk_"$BMCv".log |awk '{print$1}'|sed -n ''$i'p'`
		echo =======================$flag===========================|tee -a $BMCv/snmpget_"$BMCv".log
		echo ==|tee -a $BMCv/snmpget_"$BMCv".log
		$snmpgetcollect $flag|tee -a $BMCv/snmpget_"$BMCv".log
		echo ++|tee -a $BMCv/snmpget_"$BMCv".log
	done

TN=`cat $MIB |grep -i table |grep -i object-type |wc -l`
echo "$snmptablecollect $Tableflag" |tee -a $BMCv/snmptable_"$BMCv".log
for (( i=1 ; i<=$TN ; i=i+1 ))
	do
		Tableflag=`cat $MIB |grep -i table --color |grep -i object-type --color |awk '{print$1}'|sed -n ''$i'p'`
		echo ================$Tableflag=================== |tee -a $BMCv/snmptable_"$BMCv".log
		$snmptablecollect $Tableflag |tee -a $BMCv/snmptable_"$BMCv".log
	done
