-- TPC-H/TPC-R Top Supplier (Q15)
-- Postgres Query Definition
/*Returns for a specfic quarter of a specific year, the supplier who has 
contributed the most to overall revenue of parts shipped, sorted according to 
supplier number in case of ties*/

CREATE view revenue [STREAM_ID] (
    supplier_no,
    total_revenue) AS
    SELECT
        l_suppkey,
        sum(
            l_extendedprice * (1 - l_discount))
    FROM
        lineitem
    WHERE
        l_shipdate >= '[DATE]'::DATE
        AND l_shipdate < '[DATE]'::DATE + '3 month'::INTERVAL
    GROUP BY
        l_suppkey;

SELECT
    s_suppkey,
    s_name,
    s_address,
    s_phone,
    total_revenue
FROM
    supplier,
    revenue [STREAM_ID]
WHERE
    s_suppkey = supplier_no
    AND total_revenue = (
        SELECT
            max(total_revenue)
        FROM
            revenue [STREAM_ID]
            )
    ORDER BY
        s_suppkey;

DROP VIEW revenue [STREAM_ID];
