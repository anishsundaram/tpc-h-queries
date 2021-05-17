-- TPC-H/TPC-R Customer Distribution (Q13)
-- Postgres Query Definition
/*Returns distribution of customers who have made x orders, from 0 to the 
highest. There is a check in place to make sure certain orders of defined 
products are not counted.*/

SELECT
    c_count,
    count(*) AS custdist
FROM (
    SELECT
        c_custkey,
        count(o_orderkey)
    FROM
        customer LEFT OUTER join orders ON
            c_custkey = o_custkey
        AND o_comment NOT LIKE '%[WORD1]%[WORD2]%'
GROUP BY
    c_custkey) AS c_orders (c_custkey,
        c_count)
GROUP BY
    c_count
ORDER BY
    custdist DESC,
    c_count DESC;
