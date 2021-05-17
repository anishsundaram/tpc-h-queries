-- TPC-H/TPC-R Potential Part Promotion (Q20)
-- Postgres Query Definition
/*Returns names and addresses of suppliers with a surplus of a specific part, 
surplus defined as holding more than 50% than the amount shipped to a given 
nation in a given year. Parts are grouped together based on shared naming 
convention.*/

/*This Query takes a great deal of time so more clustered indexes are 
needed to compensate.
*/

CREATE INDEX idx_ps on partsupp (ps_partkey, PS_SUPPKEY);
CREATE INDEX idx_part on part (p_partkey) where P_NAME LIKE '[COLOR]%';
create INDEX idx_shipdate on lineitem (l_shipdate)
WHERE L_SHIPDATE >= '[DATE]'::DATE AND L_SHIPDATE < '[DATE]'::DATE + 
    '1 Year'::INTERVAL;
SELECT
    S_NAME,
    S_ADDRESS
FROM
    SUPPLIER,
    NATION
WHERE
    S_SUPPKEY IN(
        SELECT
            PS_SUPPKEY
        FROM
            PARTSUPP
        WHERE
            PS_PARTKEY in(
                SELECT
                    P_PARTKEY
                FROM
                    PART
                WHERE
                    P_NAME LIKE '[COLOR]%')
                AND PS_AVAILQTY > (
                    SELECT
                        0.5 * sum(L_QUANTITY)
                        FROM LINEITEM
                    WHERE
                        L_PARTKEY = PS_PARTKEY
                        AND L_SUPPKEY = PS_SUPPKEY
                        AND L_SHIPDATE >= '[DATE]::DATE
                        AND L_SHIPDATE < '[DATE]::DATE + '1 Year'::INTERVAL
                        )
                        )
    AND S_NATIONKEY = N_NATIONKEY
    AND N_NAME = '[NATION]'
ORDER BY
    S_NAME;
drop index idx_ps;
drop index idx_part;
drop index idx_shipdate;

