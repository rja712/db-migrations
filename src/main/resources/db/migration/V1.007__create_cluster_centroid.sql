CREATE TABLE cluster_centroid (

    id BIGSERIAL PRIMARY KEY,

    fk_cluster_run_id   BIGINT NOT NULL,
    fk_gmail_mailbox_id BIGINT NOT NULL,

    -- cluster identity
    cluster_label INT NOT NULL,
    email_count   INT NOT NULL,

    -- mean vector of all embeddings in this cluster
    centroid vector(768) NOT NULL,

    -- audit
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_cluster_centroid_run
        FOREIGN KEY (fk_cluster_run_id)
        REFERENCES cluster_run(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_cluster_centroid_mailbox
        FOREIGN KEY (fk_gmail_mailbox_id)
        REFERENCES gmail_mailbox(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_cluster_centroid
        UNIQUE (fk_cluster_run_id, cluster_label)
);


CREATE INDEX idx_cluster_centroid_mailbox ON cluster_centroid (fk_gmail_mailbox_id, cluster_label);

CREATE INDEX idx_cluster_centroid_vector
    ON cluster_centroid
    USING ivfflat (centroid vector_cosine_ops)
    WITH (lists = 10)
    WHERE centroid IS NOT NULL;
