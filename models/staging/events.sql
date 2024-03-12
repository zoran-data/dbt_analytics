-- This model creates a staging table for distribution centers data
-- Staging tables are used to ingest raw data from sources without any transformations

-- Create or replace the staging table
{{ config(
    materialized='view',
    schema='dbt_models',
    alias='events'
) }}

-- Query to select data from the source table and insert into the staging table
select
    *
from
    {{ source('analytics', 'events') }}
