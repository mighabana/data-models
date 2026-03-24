SELECT
    toString(ticker) as ticker,
    snapshot_timestamp,
    toFloat64(current_price) as current_price,
    toFloat64(previous_close) as previous_close,
    toFloat64(open) as open,
    toFloat64(day_low) as day_low,
    toFloat64(day_high) as day_high,
    volume,
    average_volume,
    average_volume_10day,
    bid,
    ask,
    bid_size,
    ask_size,
    pre_market_price,
    post_market_price,
    pre_market_change,
    post_market_change,
    ingestion_datetime
FROM
    s3(
        '{{ env_var("S3_HOST") }}/yahoo-finance/price/*.parquet',
        '{{ env_var("S3_ACCESS_KEY_ID") }}',
        '{{ env_var("S3_SECRET_ACCESS_KEY") }}',
        'Parquet'
    )
