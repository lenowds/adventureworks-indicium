with orderdetail as (
  select 
    salesorderid,
    customerid
  from {{ source('indiciumdesafiofinal', 'salesorderheader') }}    
),
  customer as (
	select
	 customerid,
	 personid
	from {{ source('indiciumdesafiofinal', 'customer') }}
  ),
  person as (
  	select 
  	  businessentityid as personid,
  	  firstname,
  	  middlename,
  	  lastname,
  	  modifieddate
  	from {{ source('indiciumdesafiofinal', 'person') }}
  ),
  detail as (
    select
      row_number() over (order by customer.customerid) as sk_customerid,
      orderdetail.salesorderid as orderid,
      person.firstname,
      person.middlename,
      person.lastname,
  	  person.modifieddate
    from 
      orderdetail
      inner join customer on (customer.customerid = orderdetail.customerid)
      inner join person on (person.personid = customer.personid)
  )
select * from detail
