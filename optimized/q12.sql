-- TPC-H/TPC-R Shipping Modes and Order Priority (Q12)
-- Postgres Query Definition
/*Returns based on delivery methods the amount of late deliveries shipped 
before the expected date split between low and high priority.*/
CREATE INDEX idx_dates on lineitem (l_commitdate, l_receiptdate, l_shipdate) where L_SHIPMODE IN('[SHIPMODE1]', '[SHIPMODE2]');
SELECT
    L_SHIPMODE,
    SUM(
        CASE WHEN O_ORDERPRIORITY = '1-URGENT'
            OR O_ORDERPRIORITY = '2-HIGH'
            THEN 1
        ELSE 0
        END) AS HIGH_LINE_COUNT,
    SUM(CASE
        WHEN O_ORDERPRIORITY <> '1-URGENT'
            AND O_ORDERPRIORITY <> '2-HIGH'
            THEN 1
        ELSE 0
    END) AS LOW_LINE_COUNT
FROM
    ORDERS,
    LINEITEM
WHERE
    O_ORDERKEY = L_ORDERKEY
    AND L_SHIPMODE IN('[SHIPMODE1]', '[SHIPMODE2]')
    AND L_COMMITDATE < L_RECEIPTDATE
    AND L_SHIPDATE < L_COMMITDATE
    AND L_RECEIPTDATE >= '[DATE]'::date
    AND L_RECEIPTDATE < '[DATE]'::date + '1 Year'::INTERVAL
GROUP BY
    L_SHIPMODE
ORDER BY
    L_SHIPMODE;
DROP INDEX idx_dates;
