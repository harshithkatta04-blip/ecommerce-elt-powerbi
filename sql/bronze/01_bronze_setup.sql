-- Bronze Layer
-- Raw ingestion and ingestion audit checks

CREATE TABLE IF NOT EXISTS ingestion_log (
    batch_id CHAR(36) PRIMARY KEY,
    file_name VARCHAR(255) NOT NULL,
    file_hash CHAR(64) NOT NULL UNIQUE,
    source_rows INT NOT NULL,
    loaded_rows INT NOT NULL,
    loaded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Validate Bronze row count
SELECT COUNT(*) AS bronze_rows
FROM bronze_ecommerce_customer;

-- Review ingestion history
SELECT *
FROM ingestion_log
ORDER BY loaded_at DESC;