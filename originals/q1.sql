-- TPC-H/TPC-R Pricing Summary Report Query (Q1)
-- Postgres Query Definition
/* Returns a report of the pricing for all lineitems shipped, billed, and
returned as of a specific date about half a year to a full year before the
ultimate described shipping date. The report contains information on the total
number of items, total base price, total discounted price, total charged, and
the average quantity of items, average price, average discount, and number of
orders per group,with each group defined by the RETURNFLAG and LINESTATUS
columns and presented in ascending order.*/

Select
    l_returnflag,
    l_linestatus,
    sum(l_quantity) as sum_qty,
    sum(l_extendedprice) as sum_base_price,
    sum(l_extendedprice*(1-l_discount)) as sum_disc_price,
    sum(l_extendedprice*(1-l_discount)*(1+l_tax)) as sum_charge,
    avg(l_quantity) as avg_qty,
    avg(l_extendedprice) as avg_price,
    avg(l_discount) as avg_disc, count(*) as count_order
from 
    lineitem
where 
    l_shipdate <= date '1998-12-01' -interval '[DELTA]' day
group by 
    l_returnflag,
    l_linestatus
order by 
    l_returnflag,
    l_linestatus;

