# TPC-H Query Optimizations

These queries were written for the TPC-H benchmark. 
The "originals" folder contains the initial functional queries in pseudocode, while the 
"optimized" folder contains optimized versions written for PostgreSQL.

## Purpose

Transaction Processing Performance Council (TPC) benchmarks, which measure 
database system performance, are accepted gold standards in the industry. 
The purpose of this post is demonstrate some optimizations that can be made to 
the queries. 

## Source

Information on the TPC-H and other benchmarks can be found here: http://tpc.org/default5.asp