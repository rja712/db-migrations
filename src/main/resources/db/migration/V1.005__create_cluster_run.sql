CREATE TABLE cluster_run (

    id BIGSERIAL PRIMARY KEY,

    fk_gmail_mailbox_id BIGINT NOT NULL,

    -- clustering config
    algorithm VARCHAR(64) NOT NULL DEFAULT 'hdbscan',
    params JSONB,

    -- results
    email_count INT,
    cluster_count INT,
    status VARCHAR(32) NOT NULL DEFAULT 'PENDING',
    error_message TEXT,

    -- timing
    started_at TIMESTAMP NOT NULL DEFAULT NOW(),
    completed_at TIMESTAMP,

    -- audit
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_cluster_run_mailbox
        FOREIGN KEY (fk_gmail_mailbox_id)
        REFERENCES gmail_mailbox(id)
        ON DELETE CASCADE
);


CREATE INDEX idx_cluster_run_mailbox ON cluster_run (fk_gmail_mailbox_id, started_at DESC);
