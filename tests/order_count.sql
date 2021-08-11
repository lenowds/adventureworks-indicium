with _validation as (
    select 
      count(1) as qtd
    from {{ ref('fact_order') }}
    where
      orderdate between '2011-06-07 00:00:00' and '2014-07-07 00:00:00'
)

select * from _validation 
where 
  qtd != 64477