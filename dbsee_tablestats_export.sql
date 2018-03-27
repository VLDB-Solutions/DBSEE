/*********************************************************************/
/* Author      : VLDB                                                */
/* Date        : 07/02/2017                                          */
/* Version     : 1                                                   */
/* Description : Generate CSV to report on tables with missing or    */
/*               out of date stats within the Teradata System        */
/*********************************************************************/
/* 1 - export target table to CSV                                    */
/*********************************************************************/

-- export location defined by controlling shell

.set recordmode off
.set separator '|'
.set width 2000
.set titledashes off
.set null as ''

select  t1.databasename    as database_name
       ,t1.tablename       as table_name
       ,max(t2.lastcollecttimestamp) as last_collect_timestamp
       ,current_date - cast(last_collect_timestamp as date format 'DD-MM-YYYY') as days_since_collection
       ,case when t2.createtimestamp is null then 'N'
             else 'Y'
        end as stats_collected_ind
       ,t3.table_size as total_perm
from    dbc.tablesv t1
left outer join
        dbc.statsv t2
on      t1.databasename = t2.databasename
and     t1.tablename    = t2.tablename
inner join 
       (select  databasename 
               ,tablename
               ,sum(currentperm) as table_size
        from    dbc.tablesizev
        group by 1,2) t3
on      t1.databasename = t3.databasename
and     t1.tablename    = t3.tablename
where   t2.expressioncount is null
group by 1,2,5,6
;
.if errorcode <> 0 then .quit errorcode

.logoff
.exit

