/*********************************************************************/
/* Author      : VLDB                                                */
/* Date        : 07/02/2017                                          */
/* Version     : 1                                                   */
/* Description : Generate csv to report on unused objects within     */
/*               the Teradata System                                 */
/*********************************************************************/
/* 1 - export target table to CSV                                    */
/*********************************************************************/

-- export location defined by controlling shell

.set recordmode off
.set separator '|'
.set width 2000
.set titledashes off
.set null as ''

select  t1.databasename     as database_name
       ,t1.tablename        as table_name
       ,t2.total            as total_perm
       ,t1.createtimestamp  as create_timestamp
       ,current_date - cast(t1.createtimestamp as date format 'DD-MM-YYYY')     as days_since_created
       ,t1.lastaltertimestamp as last_alter_timestamp
       ,current_date - cast(t1.lastaltertimestamp as date format 'DD-MM-YYYY')  as days_since_altered
       ,t1.lastaccesstimestamp as last_access_timestamp
       ,current_date - cast(t1.lastaccesstimestamp as date format 'DD-MM-YYYY') as days_since_accessed
from    dbc.tablesv t1
left join
       (select  databasename
               ,tablename
               ,sum(currentperm) as total
        from    dbc.tablesizev
        group by 1,2) t2
on      t1.databasename = t2.databasename
and     t1.tablename    = t2.tablename
;
.if errorcode <> 0 then .quit errorcode

.logoff
.exit

