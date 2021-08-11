-- staging customer
with oderdetail as (
  select 
    s.salesorderid,
    s.customerid
  from 
    sales.salesorderheader s 
),
  customer as (
	select
	 c.customerid,
	 c.personid
	from
	 sales.customer c
  ),
  person as (
  	select 
  	  p.businessentityid as personid,
  	  p.firstname,
  	  p.middlename,
  	  p.lastname,
  	  p.modifieddate
  	from 
  	  person.person p
  ),
  detail as (
    select
      oderdetail.salesorderid,
      person.firstname,
      person.middlename,
      person.lastname,
  	  person.modifieddate
    from 
      oderdetail
      inner join customer on (customer.customerid = oderdetail.customerid)
      inner join person on (person.personid = customer.personid)
  ) 
  
select * from detail



-- staging shipp
with orderdetail as (
  select 
    s.salesorderid,
    s.shiptoaddressid,
    s.shipdate
  from 
    sales.salesorderheader s 
),
  address as (
    select 
      a.addressid,
      a.stateprovinceid,
      a.addressline1,
      a.modifieddate 
    from 
      person.address a
  ),
  stateprovince as (
    select
      s.stateprovinceid,
      s.countryregioncode,
      s."name" as nmestate
    from 
      person.stateprovince s 
  ),
  countryregion as (
  	select 
  	  c2.countryregioncode,
  	  c2."name" as nmeregion
  	from 
  	  person.countryregion c2 
  ),
  detail as (
    select
      orderdetail.salesorderid as orderid,
      address.addressline1,
      nmestate,
      nmeregion,
      orderdetail.shipdate,
      address.modifieddate
    from 
      orderdetail
      inner join address on (address.addressid = orderdetail.shiptoaddressid)
      inner join stateprovince on (stateprovince.stateprovinceid = address.stateprovinceid)
      inner join countryregion on (countryregion.countryregioncode = stateprovince.countryregioncode)
)
select * from detail



-- staging product
with orderdetail as (
    select
      s.salesorderid as orderid,
      s.productid,
      s.unitprice,
      s.orderqty
    from
      sales.salesorderdetail s
  ),
  product as (
    select
      productid,
      name as nmeproduct,
      productnumber,
      modifieddate
    from
      production.product
  ),
  detail as (
    select
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



-- stating creditcard
with orderdetail as (
  select 
    s.salesorderid as orderid,
    s.creditcardid
  from 
    sales.salesorderheader s
),
  creditcard as (
    select
	  creditcardid,
      cardtype,
      cardnumber,
      modifieddate
    from {{ source('indiciumdesafiofinal', 'creditcard') }}    
  ),
  detail as (
    select
      row_number() over (order by creditcardid) as sk_creditcardid,
      orderid,
      cardtype,
      cardnumber,
      modifieddate
    from
      orderdetail
      inner join creditcard on (creditcard.creditcardid = orderdetail.creditcardid)
  )
select * from detail
  
  

-- staging orderdetail
with salesorder as (
  select 
    s.salesorderid as orderid,
    s.orderdate,
    s.status,
    s.modifieddate 
  from 
    sales.salesorderheader s
),
  salesreason as (
    select
      s2.salesorderid,
      s2.salesreasonid
    from
      sales.salesorderheadersalesreason s2 
  ),
  reason as (
    select
      s.salesreasonid,
      s.name as nmereason
    from 
      sales.salesreason s 
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


