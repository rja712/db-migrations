CREATE TABLE label (

    id BIGSERIAL PRIMARY KEY,

    fk_gmail_mailbox_id BIGINT NOT NULL,

    display_name VARCHAR(255) NOT NULL,
    full_name VARCHAR(1024) NOT NULL,
    source VARCHAR(16) NOT NULL,
    description TEXT,

    reference_embedding vector(768),

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    -- audit
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_label_mailbox
        FOREIGN KEY (fk_gmail_mailbox_id)
        REFERENCES gmail_mailbox(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_label_mailbox_full_name
        UNIQUE (fk_gmail_mailbox_id, full_name)
);

CREATE INDEX idx_label_mailbox
    ON label (fk_gmail_mailbox_id);

CREATE INDEX idx_label_source
    ON label (source);

CREATE INDEX idx_label_active
    ON label (is_active);

CREATE INDEX idx_label_reference_embedding
    ON label
    USING hnsw (reference_embedding vector_cosine_ops)
    WHERE reference_embedding IS NOT NULL;