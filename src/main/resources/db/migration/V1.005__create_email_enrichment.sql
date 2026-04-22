CREATE TABLE email_enrichments (

    id BIGSERIAL PRIMARY KEY,

    fk_email_content_id BIGINT NOT NULL,

    -- embedding
    embedding       vector(768),
    embedding_model VARCHAR(64),

    -- cluster assignment
    fk_cluster_id           BIGINT,
    cluster_probability     FLOAT,       -- HDBSCAN soft membership score (0.0–1.0)
    cluster_assignment_type VARCHAR(16), -- BATCH | INCREMENTAL

    -- audit
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_email_enrichments_email_content
        FOREIGN KEY (fk_email_content_id)
        REFERENCES email_content(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_email_enrichments_cluster
        FOREIGN KEY (fk_cluster_id)
        REFERENCES cluster(id)
        ON DELETE SET NULL,

    CONSTRAINT uq_email_enrichments_email_content
        UNIQUE (fk_email_content_id)
);

CREATE INDEX idx_email_enrichments_email_content
    ON email_enrichments (fk_email_content_id);

CREATE INDEX idx_email_enrichments_cluster
    ON email_enrichments (fk_cluster_id);

CREATE INDEX idx_email_enrichments_embedding
    ON email_enrichments
    USING ivfflat (embedding vector_cosine_ops)
    WITH (lists = 100)
    WHERE embedding IS NOT NULL;
