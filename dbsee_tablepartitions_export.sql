/*********************************************************************/
/* Author      : VLDB                                                */
/* Date        : 07/02/2017                                          */
/* Version     : 1                                                   */
/* Description : Generate CSV to report on table statistics on       */
/*               partitioned tables in the Teradata system           */
/*********************************************************************/
/* 1 - export contents of table as a CSV                             */
/*********************************************************************/

-- export location defined by controlling shell

.set recordmode off
.set separator '|'
.set width 2000
.set titledashes off
.set null as ''

select  t1.databasename     as database_name
       ,t1.tablename        as table_name
       ,t2.total_perm       as total_perm 
       ,t4.columnname       as column_name
       ,max(case when t3.tablename = t4.tablename then t3.lastcollecttimestamp
                 else null
            end) as table_ts
       ,t5.lastcollecttimestamp  as column_ts 
       ,current_date - max(cast(t5.lastcollecttimestamp as date format 'DD-MM-YYYY')) as day_since_column_updated
from    dbc.partitioningconstraintsv t1
left outer join
       (select databasename
              ,tablename
              ,sum(currentperm) as total_perm
        from   dbc.tablesizev
        group by 1,2) t2
on      t1.databasename = t2.databasename
and     t1.tablename    = t2.tablename
left outer join 
        dbc.tablestatsv t3
on      t1.databasename = t3.databasename
and     t1.tablename    = t3.tablename
left outer join
        dbc.columnsv t4
on      t1.databasename = t4.databasename
and     t1.tablename    = t4.tablename
left outer join
        dbc.columnstatsv t5
on      t1.databasename = t5.databasename
and     t1.tablename    = t5.tablename
and     t4.columnname   = t5.columnname
group by 1,2,3,4,6
where   t4.partitioningcolumn = 'Y'
;
.if errorcode <> 0 then .quit errorcode

.logoff
.exit

