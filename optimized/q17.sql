-- TPC-H/TPC-R Small-Quantity-Order Revenue (Q17)
-- Postgres Query Definition
/*Returns the average loss of undiscounted revenue across seven years if all 
orders for parts less than 20% of the average were no longer taken, essentially
calculating the average amount of yearly revenue that would be lost by 
concentrating sales on larger shipments only.*/

create index idx_lineitem on lineitem (l_partkey, l_suppkey);
CLUSTER idx_lineitem on lineitem;
SELECT
    sum(l_extendedprice) / 7.0 AS avg_yearly
FROM
    lineitem,
    part
WHERE
    p_partkey = l_partkey
    AND p_brand = '[BRAND]'
    AND p_container = '[CONTAINER]'
    AND l_quantity < (
        SELECT
            0.2 * avg(l_quantity)
        FROM
            lineitem
        WHERE
            l_partkey = p_partkey
    );
drop index idx_lineitem;
