SELECT
    id,
    created_on,
    target_name,
    CASE
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, ['%STEAM%', '%DRUM LESSONS GCAMACHO%', '%CASA DEL LIBRO%', '%EL PATIO ESTUDIO%', '%THE SHORTLIST%']) THEN 'HOBBIES'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, ['%PREPLY%']) THEN 'LEARNING'
        WHEN UPPER(target_name) ILIKE '%AVECILLA%' THEN 'RENT'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, [
            '%SUPERMERCADO%', '%MERCADONA%', '%BON PREU%', '%CARREFOUR%', '%MARKET CASA ITALIA%', 
            '%PRIMAPRIX%', '%ALDI%', '%ALCAMPO%', '%CONDIS%', '%DAY DAY GO%',
            '%STORE LEPANT%', '%FAMILYMART%'
        ]) THEN 'GROCERIES'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, ['%ENTROPIA%', '%ALIEXPRESS%', '%MUJI%', '%NORMAL%']) THEN 'SHOPPING'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, ['%MOOBY CINEMAS%']) THEN 'ENTERTAINMENT'
        -- ^ [keep above] recategorizes some of the category filters
        -- # Category filters:
        WHEN category = 'Transport' THEN 'TRANSPORTATION'
        WHEN category = 'Eating out' THEN 'DINING'
        WHEN category = 'Shopping' THEN 'SHOPPING'
        ELSE 'OTHERS'
    END as category,

    direction,
    source_name,
    source_currency,
    source_amount_after_fees,
    source_fee_amount,
    source_fee_currency,
    exchange_rate,
    target_currency,
    target_amount_after_fees,
    target_fee_amount,
    target_fee_currency,
    reference,
    created_by,
    finished_on,
    batch,
    status,
    note
FROM
    s3(
        '{{ env_var("S3_HOST") }}/wise/transactions/*.csv',
        '{{ env_var("S3_ACCESS_KEY_ID") }}',
        '{{ env_var("S3_SECRET_ACCESS_KEY") }}',
        'CSVWithNames'
    )
