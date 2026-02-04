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
