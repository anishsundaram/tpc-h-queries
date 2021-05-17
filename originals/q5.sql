-- TPC-H/TPC-R Local Supplier Volume (Q5)
-- Postgres Query Definition
/* Returns the names of each nation and its corresponding 
revenue(after discount) volume of all lineitem transactions wherein both the
customer and the supplier were both in the same nation for a timescale of
1 year. Nations and the associated revenue are displayed in descending order.*/

SELECT
    N_NAME,
    SUM(L_EXTENDEDPRICE * (1 - L_DISCOUNT)) AS REVENUE
FROM
    CUSTOMER,
    ORDERS,
    LINEITEM,
    SUPPLIER,
    NATION,
    REGION
WHERE
    C_CUSTKEY = O_CUSTKEY
    AND L_ORDERKEY = O_ORDERKEY
    AND L_SUPPKEY = S_SUPPKEY
    AND C_NATIONKEY = S_NATIONKEY
    AND S_NATIONKEY = N_NATIONKEY
    AND N_REGIONKEY = R_REGIONKEY
    AND R_NAME = '[REGION]'
    AND O_ORDERDATE >= '[DATE]'::DATE
    AND O_ORDERDATE < '[DATE]'::DATE + '1 Year'::INTERVAL
GROUP BY
    N_NAME
ORDER BY
    REVENUE DESC;
