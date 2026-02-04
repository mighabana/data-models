SELECT
    toDateTime(created_on) as created_on,
    toDateTime(finished_on) as finished_on,
    CASE
        WHEN UPPER(target_name) ILIKE '%BIZUM%' THEN 'BIZUM'
        WHEN UPPER(target_name) ILIKE '%CAJERO AUTOMATICO%' THEN 'ATM'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, ['%SUPERMERCAT%', '%MERCADONA%', '%CONDIS%', '%CARREF%', '%ALDI%', '%DIA%']) THEN 'GROCERIES'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, ['%BICING%', '%CABIFY%', '%RIDEMOVI%']) THEN 'TRANSPORTATION'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, ['%ACCESSTICKET%', '%MOOBY%', '%TEATRO COLISEUM%', '%FEVER%']) THEN 'ENTERTAINMENT'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, ['%VODAFONE%', '%AIRALO%']) THEN 'COMMUNICATION'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, ['%BETTERHELP%', '%VIVAGYM%']) THEN 'HEALTH'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, [
            '%RESTAURANTE%', '%MCDONALDS%', '%MC DONALD%', '%HAMBRE%', '%SANDWICHEZ%', '%MUSTAFA%', '%COFFEE%', '%365%', '% BAR %', '%EL CHANGARRITO%', '%BUENAS MIGAS%', '%ROYAL KING%', '%PIZZAMARKET%', '%TORRONS PLANELL%', '%EL ÑAÑO%', '%TIO BIGOTES%', '%LA CONDESA%', '%HOLY MADRE%', '%HELADERIA%', '%GELATS CARAMBOL%', '%EL FORNET%', '%99 CHEESECAKE%', '%HONEST GREENS%', '%FAUNA%', '%DULZURAMIA%', '%BEER%', '%GLOVO%'
        ]) THEN 'DINING'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, ['%SANITAS%']) THEN 'INSURANCE'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, ['%DRUM LESSONS%', '%EL PATIO ESTUDI%', '%BACKSTORY BOOKS%']) THEN 'HOBBIES'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, ['%NODISEA%']) THEN 'LEGAL'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, ['%ZARA%', '%CAMPER%', '%UNIQLO%', '%PRIMOR%', '%AMAZON%']) THEN 'SHOPPING'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, ['%UNITED%']) THEN 'TRAVEL'
        WHEN arrayExists(p -> UPPER(target_name) ILIKE p, ['%CLAUDE.AI%', '%YOUTUBE%', '%GOOGLE*CLOUD%', '%HETZNER%', '%FIGMA%']) THEN 'SUBSCRIPTIONS'
        ELSE 'OTHERS'
    END as category,
    target_name,
    CASE
        WHEN toFloat64(amount) < 0 THEN 'OUT'
        ELSE 'IN'
    END as direction,
    'EUR' as currency,
    toFloat64(replaceAll(amount, ',', '')) as amount,
    toFloat64(replaceAll(balance, ',', '')) as balance
FROM
    s3(
        '{{ env_var("S3_HOST") }}/santander/transactions/*.csv',
        '{{ env_var("S3_ACCESS_KEY_ID") }}',
        '{{ env_var("S3_SECRET_ACCESS_KEY") }}',
        'CSVWithNames'
    )
