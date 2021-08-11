with staging as (
    select *
    from {{ ref('stg_creditcard')}}
)
select * from staging