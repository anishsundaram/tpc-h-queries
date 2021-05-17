-- TPC-H/TPC-R Minimum Cost Supplier (Q2)
-- Postgres Query Definition
/* Returns information on the supplier that can provide a specified part given
 a region for the lowest cost. In the case that there are multiple suppliers 
 offering the same price the query lists the top 100 in order of descending 
 account balance, which will help determine where to source the parts. 
 For each supplier, the query returns the supplier's account balance, name, 
 nation, address, phone number, and any attached comments, as well as 
 the specified part’s number and manufacturer.*/



/*In a similar way to Q1, this query can be doubled in speed if an index is 
used. I've also lowered the number of results because the likelihood of having 
all 100 suppliers provide the same price but also have the same account balance
is low and ultimately unnecessary. I do think further optimization can be 
accomplished by flattening the subquery for the ps_supplycost, but I am not 
sure how.*/

CREATE INDEX idx_part_sup on partsupp (ps_supplycost, ps_partkey);
 select
    s_acctbal,
    s_name,
    n_name,
    p_partkey,
    p_mfgr,
    s_address,
    s_phone,
    s_comment
from
    part,
    supplier,
    partsupp,
    nation,
    region
where
    p_partkey = ps_partkey
    and s_suppkey = ps_suppkey
    and p_size = [SIZE]
    and p_type like '%[TYPE]’'
    and s_nationkey = n_nationkey
    and n_regionkey = r_regionkey
    and r_name = '[REGION]'
    and ps_supplycost = (
        select
            min(ps_supplycost)
        from
            partsupp,
            supplier,
            nation,
            region
        where
            p_partkey = ps_partkey
            and s_suppkey = ps_suppkey
            and s_nationkey = n_nationkey
            and n_regionkey = r_regionkey
            and r_name = '[REGION]'
    )
order by
    s_acctbal desc,
    n_name,
    s_name,
    p_partkey
LIMIT 15;
DROP INDEX idx_part_sup;

