-- TPC-H/TPC-R Shipping Priority (Q3)
-- Postgres Query Definition
/* Returns up to 10 unshipped orders as of a specific date ordered in terms of 
highest to lowest value/revenue, calculated after discounts are applied. Each
order’s order number, revenue, order date, and shipping priority is returned.*/

/*Using similar reasoning to the queries above I used indices to replace the 
seqscan with index searches and Bitmap heat searches which greatly decreased 
the runtime. */


CREATE INDEX idx_orderdate on orders(o_orderdate);
CREATE INDEX idx_itemdate on lineitem(l_shipdate);
CREATE INDEX idx_MKTSEGMENT  on customer(c_mktsegment);
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
DROP INDEX idx_MKTSEGMENT;
DROP INDEX idx_itemdate;
DROP INDEX idx_orderdate;
