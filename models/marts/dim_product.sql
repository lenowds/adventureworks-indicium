with staging as (
    select *
    from {{ ref('stg_product')}}
)
select * from staging