-- TPC-H/TPC-R Order Priority Checking (Q4)
-- Postgres Query Definition
/* Returns the count of orders in a given quarter of a given year in which at 
least 1 lineitem was received late. Results are grouped per order priority 
type in ascending priority order.*/

SELECT
    O_ORDERPRIORITY,
    COUNT(*) AS ORDER_COUNT
FROM
    ORDERS
WHERE
    O_ORDERDATE >= '[DATE]'::DATE
    AND o_orderdate < '[DATE]'::Date + '3 MONTHS'::INTERVAL
    AND EXISTS (
        SELECT
            *
        FROM
            LINEITEM
        WHERE
            L_ORDERKEY = O_ORDERKEY
            AND L_COMMITDATE < L_RECEIPTDATE
    )
GROUP BY
    O_ORDERPRIORITY
ORDER BY
    O_ORDERPRIORITY;


