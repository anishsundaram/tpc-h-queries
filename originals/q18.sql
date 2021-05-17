-- TPC-H/TPC-R Large Volume Customer (Q18)
-- Postgres Query Definition
/*Returns top 100 customers who have placed large quantity orders ranked in 
size. Lists the customer name, customer key, the order key, date and total 
price and the quantity for the order.*/

SELECT
    c_name,
    c_custkey,
    o_orderkey,
    o_orderdate,
    o_totalprice,
    sum(l_quantity)
FROM
    customer,
    orders,
    lineitem
WHERE
    o_orderkey in(
        SELECT
            l_orderkey
        FROM
            lineitem
        GROUP BY
            l_orderkey
        HAVING
            sum(l_quantity) > [AMOUNT])
    AND c_custkey = o_custkey and o_orderkey = l_orderkey
GROUP BY
    c_name,
    c_custkey,
    o_orderkey,
    o_orderdate,
    o_totalprice
ORDER BY
    o_totalprice DESC,
    o_orderdate
limit 100;
