-- TPC-H/TPC-R Global Sales Opportunity (Q22)
-- Postgres Query Definition
/*Returns amount of customers from 7 country codes havent made an order in 7 
years but have a greater than average positive account balance.*/

SELECT
    CNTRYCODE,
    COUNT(*) AS NUMCUST,
    SUM(C_ACCTBAL) AS TOTACCTBAL
FROM (
    SELECT
        SUBSTRING(C_PHONE, 1, 2) AS CNTRYCODE,
        C_ACCTBAL
    FROM
        CUSTOMER
    WHERE
        substring(c_phone from 1 for 2) in
        ('[I1]','[I2]','[I3]','[I4]','[I5]','[I6]','[I7]')
        AND C_ACCTBAL > (
            SELECT
                AVG(C_ACCTBAL)
            FROM
                CUSTOMER
            WHERE
                C_ACCTBAL > 0.00
                and substring (c_phone from 1 for 2) in
                ('[I1]','[I2]','[I3]','[I4]','[I5]','[I6]','[I7]'))
            AND NOT EXISTS (
                SELECT
                    *
                FROM
                    ORDERS
                WHERE
                    O_CUSTKEY = C_CUSTKEY)) AS CUSTSALE
GROUP BY
    CNTRYCODE
ORDER BY
    CNTRYCODE;
