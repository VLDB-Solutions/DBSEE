/*********************************************************************/
/* Author      : VLDB                                                */
/* Date        : 16/03/2017                                          */
/* Version     : 1                                                   */
/* Description : Generate CSV to report on tables with PI with       */
/*               nullable columns within the Teradata System         */
/*********************************************************************/
/* 1 - export target table to CSV                                    */
/*********************************************************************/

-- export location now set by controlling shell

.set recordmode off
.set separator '|'
.set width 2000
.set titledashes off
.set null as ''

select  t1.databasename as database_name
       ,t1.tablename    as table_name
       ,t1.columnname   as column_name
       ,t2.nullable     as nullable
       ,t3.total_perm   as total_perm
from    dbc.indicesv t1
left outer join
        dbc.columnsv t2
on      t1.databasename = t2.databasename
and     t1.tablename    = t2.tablename
and     t1.columnname   = t2.columnname
inner join
       (select databasename
              ,tablename
              ,sum(currentperm) as total_perm
        from   dbc.tablesizev
        group by 1,2) t3
on      t1.tablename    = t3.tablename
and     t1.databasename = t3.databasename
where   t1.indexnumber  = 1 -- denotes primary index
;
.if errorcode <> 0 then .quit errorcode

.logoff
.exit

