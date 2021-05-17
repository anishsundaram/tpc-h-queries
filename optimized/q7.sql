-- TPC-H/TPC-R Volume Shipping (Q7)
-- Postgres Query Definition
/*Returns the total discounted revenues of lineitem transactions in which the 
2 nations were either the customer or the supplier to the other between 1995 
to 1996. Output lists the supplier nation, the customer nation, the year, and 
the revenue from the shipments for that year.*/

create index idx_shipdate on lineitem (l_shipdate) where L_SHIPDATE BETWEEN '1995-01-01' AND '1996-12-31';
create index idx_orderkey on orders(o_orderdate);
SELECT
    supp_nation,
    cust_nation,
    l_year,
    sum(volume) AS revenue
FROM (
    SELECT
        n1.n_name AS supp_nation,
        n2.n_name AS cust_nation,
        extract(year FROM l_shipdate) AS l_year,
        l_extendedprice * (1 - l_discount) AS volume
    FROM
        supplier,
        lineitem,
        orders,
        customer,
        nation n1,
        nation n2
    WHERE
        s_suppkey = l_suppkey
        AND o_orderkey = l_orderkey
        AND c_custkey = o_custkey
        AND s_nationkey = n1.n_nationkeyand c_nationkey = n2.n_nationkey
        and(
            (n1.n_name = '[NATION1]' AND n2.n_name = '[NATION2]')
            or(n1.n_name = '[NATION2]' AND n2.n_name = '[NATION1]'))
        AND l_shipdate BETWEEN date '1995-01-01' AND date '1996-12-31'
    ) AS shipping
GROUP BY
    supp_nation,
    cust_nation,
    l_year
ORDER BY
    supp_nation,
    cust_nation,
    l_year;
drop index idx_shipdate;
drop index idx_orderkey;

