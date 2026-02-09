SELECT
    toString(base_currency) as base_currency,
    toString(target_currency) as target_currency,
    toFloat64(rate) as rate,
    toDateTime64(rate_timestamp, 4) as rate_timestamp,
    toDateTime64(ingestion_datetime, 4) as ingestion_datetime
FROM
   s3(
        '{{ env_var("S3_HOST") }}/currency-beacon/exchange_rates/*.parquet',
        '{{ env_var("S3_ACCESS_KEY_ID") }}',
        '{{ env_var("S3_SECRET_ACCESS_KEY") }}',
        'Parquet'
    )
