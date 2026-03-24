with rates as (
  SELECT
    base_currency,
    target_currency,
    AVG(rate) as avg_rate,
    toDate32(rate_timestamp) as rate_date
  FROM
    {{ ref('exchange_rates') }}
  WHERE
    base_currency = 'EUR'
  GROUP BY
    rate_date,
    base_currency,
    target_currency
),

bank_transactions as (
    SELECT
        'SANTANDER' as source,
        toDateTime(st.created_on) as created_on,
        st.category,
        st.target_name,
        st.direction,
        st.currency,
        ABS(st.amount) as amount,
        st.amount as transaction_amount
    FROM
        bronze_santander.santander_transactions as st
    WHERE
        NOT (target_name ilike '%JUAN MIGUEL ALFONSO ALBERT HABANA%' AND st.direction = 'IN')
        
    UNION ALL

    SELECT
        'WISE' as source,
        wt.created_on,
        wt.category,
        wt.target_name,
        wt.direction,
        wt.source_currency as currency,
        wt.source_amount_after_fees as amount,
        CASE
            WHEN wt.direction = 'OUT' THEN -1 * wt.source_amount_after_fees
            ELSE wt.source_amount_after_fees
        END as transaction_amount
    FROM
        bronze_wise.wise_transactions as wt
)

SELECT
  bt.source,
  bt.created_on,
  bt.category,
  bt.target_name,
  bt.direction,
  'EUR' as currency,
  bt.amount / r.avg_rate as amount,
  bt.transaction_amount / r.avg_rate as transaction_amount
FROM
  bank_transactions as bt
INNER JOIN
  rates as r
  ON r.rate_date = toDate32(bt.created_on)
  AND r.target_currency = bt.currency
