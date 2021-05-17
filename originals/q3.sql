-- TPC-H/TPC-R Shipping Priority (Q3)
-- Postgres Query Definition
/* Returns up to 10 unshipped orders as of a specific date ordered in terms of 
highest to lowest value/revenue, calculated after discounts are applied. Each
order’s order number, revenue, order date, and shipping priority is returned.*/

SELECT
    l_orderkey,
    sum(l_extendedprice * (1 - l_discount)) AS revenue,
    o_orderdate,
    o_shippriority
FROM
    customer,
    orders,
    lineitem
WHERE
    C_MKTSEGMENT = '[SEGMENT]'
    AND C_CUSTKEY = O_CUSTKEY
    AND L_ORDERKEY = O_ORDERKEY
    AND O_ORDERDATE < '[DATE]'
    AND L_SHIPDATE > '[DATE]'
GROUP BY
    l_orderkey,
    o_orderdate,
    o_shippriority
ORDER BY
    revenue DESC,
    o_orderdate
LIMIT 10;
