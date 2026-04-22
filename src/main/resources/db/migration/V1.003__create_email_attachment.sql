CREATE TABLE email_attachment (

    id BIGSERIAL PRIMARY KEY,

    fk_email_content_id BIGINT NOT NULL,

    -- gmail metadata
    email_attachment_id VARCHAR(1024),
    file_name           VARCHAR(1024) NOT NULL,
    mime_type           VARCHAR(255),
    size_in_bytes       BIGINT,

    -- storage
    storage_path     VARCHAR(1024) NOT NULL,
    storage_provider VARCHAR(8)    NOT NULL DEFAULT 'local',

    -- inline reference (maps to cid: in HTML body)
    content_id VARCHAR(1024),
    is_inline  BOOLEAN NOT NULL DEFAULT FALSE,

    -- audit
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_email_attachment_email_content
        FOREIGN KEY (fk_email_content_id)
        REFERENCES email_content(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_email_attachment_email_content
    ON email_attachment (fk_email_content_id);
