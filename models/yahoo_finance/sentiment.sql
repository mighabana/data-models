SELECT
    ticker,
    snapshot_timestamp,
    target_high_price,
    target_low_price,
    target_mean_price,
    target_median_price,
    recommendation_mean,
    recommendation_key,
    number_of_analyst_opinions,
    short_ratio,
    shares_short,
    shares_short_prior_month,
    shares_percent_shares_out,
    held_percent_insiders,
    held_percent_institutions,
    shares_outstanding,
    float_shares,
    beta,
    beta_3year,
    ingestion_datetime
FROM
    s3(
        '{{ env_var("S3_HOST") }}/yahoo-finance/sentiment/*.parquet',
        '{{ env_var("S3_ACCESS_KEY_ID") }}',
        '{{ env_var("S3_SECRET_ACCESS_KEY") }}',
        'Parquet'
    )
