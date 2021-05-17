-- TPC-H/TPC-R Suppliers Who Kept Orders Waiting (Q21)
-- Postgres Query Definition
/*Returns the first 100 names of suppliers who for a given nation were the sole
supplier out a multi-supplier order which was delivered late. Lists names and 
amount of orders late.*/

CREATE INDEX idx_order on orders (o_orderkey) where O_ORDERSTATUS = 'F';
CREATE INDEX idx_dates on lineitem(l_receiptdate,l_commitdate);
SELECT
    S_NAME,
    COUNT(*) AS NUMWAIT
FROM
    SUPPLIER,
    LINEITEM L1,
    ORDERS,
    NATION
WHERE
    S_SUPPKEY = L1.L_SUPPKEY
    AND O_ORDERKEY = L1.L_ORDERKEY
    AND O_ORDERSTATUS = 'F'
    AND L1.L_RECEIPTDATE > L1.L_COMMITDATE
    AND EXISTS (
        SELECT
            *
        FROM
            LINEITEM L2
        WHERE
            L2.L_ORDERKEY = L1.L_ORDERKEY
            AND L2.L_SUPPKEY <> L1.L_SUPPKEY)
        AND NOT EXISTS (
            SELECT
                *
            FROM
                LINEITEM L3
            WHERE
                L3.L_ORDERKEY = L1.L_ORDERKEY
                AND L3.L_SUPPKEY <> L1.L_SUPPKEY
                AND L3.L_RECEIPTDATE > L3.L_COMMITDATE)
            AND S_NATIONKEY = N_NATIONKEY
            AND N_NAME = '[NATION]'
        GROUP BY
            S_NAME
        ORDER BY
            NUMWAIT DESC,
            S_NAME
        LIMIT 100;
drop index idx_order;
drop index idx_dates;
