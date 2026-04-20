CREATE TABLE email_cluster_assignment (

    id BIGSERIAL PRIMARY KEY,

    fk_cluster_run_id BIGINT NOT NULL,
    fk_email_content_id BIGINT NOT NULL,

    -- hdbscan output
    cluster_label INT NOT NULL,
    probability FLOAT,

    -- audit
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_cluster_assignment_run
        FOREIGN KEY (fk_cluster_run_id)
        REFERENCES cluster_run(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_cluster_assignment_email
        FOREIGN KEY (fk_email_content_id)
        REFERENCES email_content(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_cluster_assignment_email
        UNIQUE (fk_email_content_id)
);


CREATE INDEX idx_cluster_assignment_run ON email_cluster_assignment (fk_cluster_run_id);
