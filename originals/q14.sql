-- TPC-H/TPC-R Promotion Effect (Q14)
-- Postgres Query Definition
/*Returns the percentage of total revenue for a given year and month is derived
 from promotional parts shipped in that month.*/

 SELECT
    100.00 * SUM(
        CASE WHEN P_TYPE LIKE 'PROMO%' THEN
            L_EXTENDEDPRICE * (1 - L_DISCOUNT)
        ELSE
            0
        END) / SUM(L_EXTENDEDPRICE * (1 - L_DISCOUNT)) AS PROMO_REVENUE
FROM
    LINEITEM,
    PART
WHERE
    L_PARTKEY = P_PARTKEY
    AND L_SHIPDATE >= '[DATE]'::date
    AND L_SHIPDATE <  '[DATE]'::DATE + '1 Month'::INTERVAL;
