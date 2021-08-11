-- staging orderdetail
with salesorder as (
  select 
    salesorderid as orderid,
    orderdate,
    status,
    modifieddate 
  from {{ source('indiciumdesafiofinal', 'salesorderheader') }}
),
  salesreason as (
    select
      salesorderid,
      salesreasonid
    from {{ source('indiciumdesafiofinal', 'salesorderheadersalesreason') }}
  ),
  reason as (
    select
      salesreasonid,
      name as nmereason
    from {{ source('indiciumdesafiofinal', 'salesreason') }}
  ),
  detail as (
    select
      orderid,
      orderdate,
      status,
      nmereason,
      modifieddate
    from  
      salesorder
      inner join salesreason on (salesreason.salesorderid = salesorder.orderid)
      inner join reason on (reason.salesreasonid = salesreason.salesreasonid)
  )
select * from detail
