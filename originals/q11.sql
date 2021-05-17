-- TPC-H/TPC-R Important Stock Identification (Q11)
-- Postgres Query Definition
/*Returns all in stock parts from local suppliers that form a significant 
percentage of total value of all available parts in descending order of value.*/

SELECT
    PS_PARTKEY,
    SUM(PS_SUPPLYCOST * PS_AVAILQTY) AS VALUE
FROM
    PARTSUPP,
    SUPPLIER,
    NATION
WHERE
    PS_SUPPKEY = S_SUPPKEY
    AND S_NATIONKEY = N_NATIONKEY
    AND N_NAME = '[NATIONe]'
GROUP BY
    PS_PARTKEY HAVING
        SUM(PS_SUPPLYCOST * PS_AVAILQTY) > (
            SELECT
                SUM(PS_SUPPLYCOST * PS_AVAILQTY) * [FRACTION]
            FROM
                PARTSUPP,
                SUPPLIER,
                NATION
            WHERE
                PS_SUPPKEY = S_SUPPKEY
                AND S_NATIONKEY = N_NATIONKEY
                AND N_NAME = '[NATION]'
        )
    ORDER BY
        VALUE DESC;
