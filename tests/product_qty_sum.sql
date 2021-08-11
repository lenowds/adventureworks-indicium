with _validation as (
    select 
      sum(orderqty) as orderqty
    from {{ ref ('dim_product') }}
    where
      modifieddate < '2014-02-08 10:03:55'
)
select 
  * 
from 
  _validation 
where orderqty != 274238