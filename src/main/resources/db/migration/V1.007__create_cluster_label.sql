CREATE TABLE cluster_label (

    id BIGSERIAL PRIMARY KEY,

    fk_cluster_id BIGINT NOT NULL,
    fk_label_id   BIGINT NOT NULL,

    -- similarity score used during assignment
    mapping_score DOUBLE PRECISION,

    -- audit
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_cluster_label_cluster
        FOREIGN KEY (fk_cluster_id)
        REFERENCES cluster(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_cluster_label_label
        FOREIGN KEY (fk_label_id)
        REFERENCES label(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_cluster_label
        UNIQUE (fk_cluster_id)
);

CREATE INDEX idx_cluster_label_cluster
    ON cluster_label (fk_cluster_id);

CREATE INDEX idx_cluster_label_label
    ON cluster_label (fk_label_id);