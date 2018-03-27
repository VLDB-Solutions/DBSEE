/*********************************************************************/
/* Author      : VLDB                                                */
/* Date        : 07/02/2017                                          */
/* Version     : 1                                                   */
/* Description : Generate CSV to report on table skew on all tables  */
/*               in the Teradata system                              */
/*********************************************************************/
/* 1 - export contents of table as a CSV                             */
/*********************************************************************/

-- export location defined by controlling shell

.set recordmode off
.set separator '|'
.set width 2000
.set titledashes off
.set null as ' '

select  t1.databasename as database_name
       ,t1.tablename    as table_name
       ,t1.currentperm  as current_perm 
       ,t2.total_perm   as total_perm
       ,cast(t2.total_perm/(select max(vproc) +1 
                            from   dbc.tablesizev) as bigint) as avg_size_by_amp
       ,t1.vproc        as vproc
       ,cast((currentperm - avg_size_by_amp) as bigint) as deviation
       ,cast(case when deviation = 0 then 0
                  else (cast(deviation as decimal(25,4))/cast(avg_size_by_amp as decimal(25,4)))*100
             end as decimal(23,2)) as deviation_perc
from    dbc.tablesizev t1
inner join 
       (select  databasename
               ,tablename
               ,sum(currentperm) as total_perm
        from    dbc.tablesizev
        group by 1,2) t2
on      t1.tablename    = t2.tablename
and     t1.databasename = t2.databasename
group by 1,2,3,4,6
;
.if errorcode <> 0 then .quit errorcode

.logoff
.exit

