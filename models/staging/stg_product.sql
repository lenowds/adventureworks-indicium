with orderdetail as (
    select
      salesorderid as orderid,
      productid,
      unitprice,
      orderqty
    from {{ source('indiciumdesafiofinal', 'salesorderdetail') }}    
  ),
  product as (
    select
      productid,
      name as nmeproduct,
      productnumber,
      modifieddate
    from {{ source('indiciumdesafiofinal', 'product') }}    
  ),
  detail as (
    select
      row_number() over (order by product.productid) as sk_productid,
      orderid,
      nmeproduct,
      productnumber,
      orderqty,
      unitprice,
      modifieddate
    from 
      orderdetail
      inner join product on (product.productid = orderdetail.productid)
  )
select * from detail
