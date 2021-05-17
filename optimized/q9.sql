-- TPC-H/TPC-R Product Type Profit Measure (Q9)
-- Postgres Query Definition
/*Returns per nation per year the profit made for a specific type of part that 
were supplied by a local supplier, ordered by most recent order.*/

 CREATE index idx_part on part (P_PARTKEY, P_NAME) where  P_NAME LIKE '%[COLOR]%';
SELECT
    NATION,
    O_YEAR,
    SUM(AMOUNT) AS SUM_PROFIT
FROM (
    SELECT
        n_name AS nation,
        extract(year FROM o_orderdate) AS o_year,
        l_extendedprice * (1 - l_discount) 
            - ps_supplycost * l_quantity AS amount
    FROM
        PART,
        SUPPLIER,
        LINEITEM,
        PARTSUPP,
        ORDERS,
        NATION
    WHERE
        S_SUPPKEY = L_SUPPKEY
        AND PS_SUPPKEY = L_SUPPKEY
        AND PS_PARTKEY = L_PARTKEY
        AND P_PARTKEY = L_PARTKEY
        AND O_ORDERKEY = L_ORDERKEY
        AND S_NATIONKEY = N_NATIONKEY
        AND P_NAME LIKE '%[COLOR]%') AS PROFIT
GROUP BY
    NATION,
    O_YEAR
ORDER BY
    NATION,
    O_YEAR DESC;
DROP INDEX idx_part;

