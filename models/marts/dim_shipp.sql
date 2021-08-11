with staging as (
    select *
    from {{ ref('stg_shipp')}}
)
select * from staging