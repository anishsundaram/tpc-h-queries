-- TPC-H/TPC-R Parts/Supplier Relationship (Q16)
-- Postgres Query Definition
/*Returns number of suppliers who can satisfy a requirement placed by the 
customer on amount/specific kind of parts. Results are presented in descending 
count and ascending brand, type, and size.*/

SELECT
    p_brand,
    p_type,
    p_size,
    count(DISTINCT ps_suppkey) AS supplier_cnt
FROM
    partsupp,
    part
WHERE
    p_partkey = ps_partkey
    AND p_brand <> '[BRAND]'
    AND p_type NOT LIKE '[TYPE]%'
    AND p_size in([SIZE1], [SIZE2], [SIZE3], [SIZE4], [SIZE5], [SIZE6], [SIZE7], [SIZE8])
    AND ps_suppkey NOT in(
        SELECT
            s_suppkey FROM supplier
        WHERE
            s_comment LIKE '%Customer%Complaints%')
GROUP BY
    p_brand, p_type, p_size
ORDER BY
    supplier_cnt DESC,
    p_brand,
    p_type,
    p_size;
