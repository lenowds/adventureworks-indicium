with orderdetail as (
  select 
    salesorderid,
    shiptoaddressid,
    shipdate
  from {{ source('indiciumdesafiofinal', 'salesorderheader') }} 
),
  address as (
    select 
      addressid,
      stateprovinceid,
      addressline1,
      modifieddate 
    from {{ source('indiciumdesafiofinal', 'address') }} 
  ),
  stateprovince as (
    select
      stateprovinceid,
      countryregioncode,
      "name" as nmestate
    from {{ source('indiciumdesafiofinal', 'stateprovince') }}  
  ),
  countryregion as (
  	select 
  	  countryregioncode,
  	  "name" as nmeregion
  	from {{ source('indiciumdesafiofinal', 'countryregion') }}  
  ),
  detail as (
    select
      row_number() over (order by address.addressid) as sk_shipp,
      address.addressid,
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