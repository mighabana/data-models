SELECT
    -- *
    master_metadata_track_name as track_name,
    master_metadata_album_artist_name as artist_name,
    master_metadata_album_album_name as album_name,
    SUBSTRING(spotify_track_uri, 15) as track_uri,
    reason_start,
    reason_end,
    shuffle,
    skipped,
    offline,
    ts,
    CASE
        WHEN offline_timestamp > 253402300799999 THEN TIMESTAMP_MICROS(offline_timestamp)
        WHEN offline_timestamp > 253402300799 THEN TIMESTAMP_MILLIS(offline_timestamp)
        ELSE TIMESTAMP_SECONDS(offline_timestamp)
    END as offline_ts,
    ms_played,
    incognito_mode
FROM 
    {{ source('spotify', 'audio_streaming_history') }}
WHERE
    1=1
    AND master_metadata_track_name IS NOT NULL
ORDER BY
    ts DESC
