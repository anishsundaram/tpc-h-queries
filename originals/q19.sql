-- TPC-H/TPC-R Discounted Revenue (Q19)
-- Postgres Query Definition
/*Returns gross discounted revenue for all orders of 3 specified types of parts
that were shipped by air and delivered in person*/

SELECT
    SUM(L_EXTENDEDPRICE* (1 - L_DISCOUNT)) AS REVENUE
FROM
    LINEITEM,
    PART
WHERE
    (
        P_PARTKEY = L_PARTKEY
        AND P_BRAND = '[BRAND1]'
        AND P_CONTAINER IN ('SM CASE', 'SM BOX', 'SM PACK', 'SM PKG')
        And l_quantity >= [QUANTITY1] 
and l_quantity <= [QUANTITY1] + 10
        AND P_SIZE BETWEEN 1 AND 5
        AND L_SHIPMODE IN ('AIR', 'AIR REG')
        AND L_SHIPINSTRUCT = 'DELIVER IN PERSON'
    )
    OR (
        P_PARTKEY = L_PARTKEY
        AND P_BRAND ='[BRAND2]'
        AND P_CONTAINER IN ('MED BAG', 'MED BOX', 'MED PKG', 'MED PACK')
        AND L_QUANTITY >= [QUANTITY2]
 AND L_QUANTITY <= [QUANTITY2] + 10
        AND P_SIZE BETWEEN 1 AND 10
        AND L_SHIPMODE IN ('AIR', 'AIR REG')
        AND L_SHIPINSTRUCT = 'DELIVER IN PERSON'
    )
    OR (
        P_PARTKEY = L_PARTKEY
        AND P_BRAND = '[BRAND3]'
        AND P_CONTAINER IN ( 'LG CASE', 'LG BOX', 'LG PACK', 'LG PKG')
        AND L_QUANTITY >=[QUANTITY3]
        AND L_QUANTITY <= [QUANTITY3] + 10
        AND P_SIZE BETWEEN 1 AND 15
        AND L_SHIPMODE IN ('AIR', 'AIR REG')
        AND L_SHIPINSTRUCT = 'DELIVER IN PERSON'
    );
