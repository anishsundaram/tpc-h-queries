-- TPC-H/TPC-R Returned Item Reporting (Q10)
-- Postgres Query Definition
/*Returns up to 20 customers whose returns had the greatest impact on revenue 
for a specific quarter. Output liists the customer's name, address, nation, 
phone number, account balance, comment information and revenue lost.*/

CREATE INDEX idx_orderdate on orders (o_orderdate) where  O_ORDERDATE between '[DATE]' and '[DATE]'::date + '3 months'::INTERVAL;
CREATE index idx_item on lineitem(l_returnflag, l_orderkey) where L_RETURNFLAG = 'R';
CREATE INDEX idx_customer on customer (c_custkey, c_nationkey);
SELECT
    C_NAME,
    SUM(L_EXTENDEDPRICE * (1 - L_DISCOUNT)) AS REVENUE,
    C_ACCTBAL,
    N_NAME,
    C_ADDRESS,
    C_PHONE,
    C_COMMENT
FROM
    CUSTOMER,
    ORDERS,
    LINEITEM,
    NATION
WHERE
    C_CUSTKEY = O_CUSTKEY
    AND L_ORDERKEY = O_ORDERKEY
    AND O_ORDERDATE >= '[DATE]'
    AND o_orderdate < '[DATE]'+ '3 months'::INTERVAL
    AND L_RETURNFLAG = 'R'
    AND C_NATIONKEY = N_NATIONKEY
GROUP BY
    C_CUSTKEY,
    C_NAME,
    C_ACCTBAL,
    C_PHONE,
    N_NAME,
    C_ADDRESS,
    C_COMMENT
ORDER BY
    REVENUE DESC
LIMIT 20;
drop index idx_orderdate;
drop index idx_customer;
drop index idx_item;
