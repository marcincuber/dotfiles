#!/bin/bash
#########
# ./PITRdynamoDBtables.sh enable|disable dynamodb_table_name_prefix
########

## functions
function Usage() {
  printf "\nERROR: Invalid Usage"
  printf "\nERROR: PITRdynamoDBtables.bash {enable|disable} tablenamestring\n\n"
  exit 255
}

## main
Mode=${1}
case "${Mode}" in
  enable)
    Switch=true ; Comment=enabling
  ;;
  disable)
    Switch=false ; Comment=disabling
  ;;
  *)
    Usage
  ;;
esac

[[ -z ${2} ]] && Usage || String=${2:-NOSTRING}

TableCount=$(aws dynamodb list-tables | grep $String | wc -l)
[[ ${TableCount} -eq 0 ]] && printf "\nERROR: No table names found containing string: ${String}\n\n" && exit 255

printf "\nYou'll be ${Comment} PITR on table names containing ${String}"
printf "\nYou'll be updating ${TableCount} table(s)"
printf "\nThe following tables will be updated\n"

aws dynamodb list-tables | grep ${String} | tr -d [\",]

printf "\nType YES to continue ==> "
read Answer

[[ ${Answer} != YES ]] && printf "\nERROR: Incorrect input" && exit 255

for Table in $(aws dynamodb list-tables | grep ${String} | tr -d [\",])
do
  aws dynamodb update-continuous-backups --table-name ${Table} --point-in-time-recovery-specification PointInTimeRecoveryEnabled=$Switch
done
