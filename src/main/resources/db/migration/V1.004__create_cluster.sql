CREATE TABLE cluster (

    id BIGSERIAL PRIMARY KEY,

    fk_gmail_mailbox_id BIGINT NOT NULL,

    -- hdbscan output
    cluster_label INT         NOT NULL, -- numeric label from HDBSCAN (0, 1, 2 ...); noise (-1) excluded
    email_count   INT         NOT NULL,
    centroid      vector(768) NOT NULL,

    -- audit
        created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT uq_cluster_mailbox_label
        UNIQUE (fk_gmail_mailbox_id, cluster_label),

    CONSTRAINT fk_cluster_mailbox
        FOREIGN KEY (fk_gmail_mailbox_id)
        REFERENCES gmail_mailbox(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_cluster_mailbox
    ON cluster (fk_gmail_mailbox_id);

CREATE INDEX idx_cluster_centroid
    ON cluster
    USING ivfflat (centroid vector_cosine_ops)
    WITH (lists = 10);
