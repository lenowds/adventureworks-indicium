with _validation as (
    select 
      sum(unitprice) as unitprice
    from {{ ref ('dim_product') }}
    where
      modifieddate < '2014-02-08 10:03:55'
)
select 
  *
from 
  _validation 
where unitprice != 56410918.7987