with _order as (
    select *
    from {{ ref('stg_orderdetails') }}
),
    _creditcard as (
        select *
        from {{ ref('dim_creditcard') }}
    ),
    _customer as (
        select *
        from {{ ref('dim_customer') }}
    ),
    _product as (
        select *
        from {{ ref('dim_product') }}
    ),
    _shipp as (
        select *
        from {{ ref('dim_shipp') }}
    ),
    fact_order as (
        select
            _order.orderid,
            _creditcard.sk_creditcardid,
            _customer.sk_customerid,
            _product.sk_productid,
            _shipp.sk_shipp,
            _order.orderdate,
            _order.status,
            _order.nmereason
        from
            _order
            left join _creditcard on (_creditcard.orderid = _order.orderid)
            left join _customer on (_customer.orderid = _order.orderid)
            left join _product on (_product.orderid = _order.orderid)
            left join _shipp on (_shipp.orderid = _order.orderid)

    )
select * from fact_order