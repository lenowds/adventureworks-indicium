with orderdetail as (
  select 
    salesorderid as orderid,
    creditcardid
  from {{ source('indiciumdesafiofinal', 'salesorderheader') }} 
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
      row_number() over (order by creditcard.creditcardid) as sk_creditcardid,
      orderid,
      cardtype,
      cardnumber,
      modifieddate
    from
      orderdetail
      inner join creditcard on (creditcard.creditcardid = orderdetail.creditcardid)
  )
select * from detail
