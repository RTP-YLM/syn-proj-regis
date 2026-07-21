## ADDED Requirements

### Requirement: Attachments are uploaded via a dedicated multipart endpoint, not the JSON save endpoint
File attachments SHALL be uploaded through a dedicated multipart-form endpoint (handled directly by the Fastify API via `@fastify/multipart` — no separate UI-side action or framework hop needed), never bundled into the JSON `/save` request used for Register data.

#### Scenario: Save creates the Entry/Revision before any file upload is attempted
- **WHEN** a Sales user creates a new Entry with attachments
- **THEN** the system SHALL first persist the Entry and its current Revision (obtaining a Revision ID), and only then accept file uploads against that Revision ID

### Requirement: Attachment type and size are validated server-side
The system SHALL accept only document/PDF file types (pdf, doc/docx, xls/xlsx) and SHALL reject any upload that would bring the total size of all files on a Revision above 10 MB — enforced on the server regardless of client-side checks.

#### Scenario: Oversized total rejected
- **WHEN** the sum of existing files plus a new upload on a Revision would exceed 10 MB
- **THEN** the server SHALL reject the new upload, even if the client's own size check was bypassed

#### Scenario: Disallowed file type rejected
- **WHEN** a file with an extension outside pdf/doc/docx/xls/xlsx is uploaded
- **THEN** the server SHALL reject it

### Requirement: Disk filenames are collision-safe
Files SHALL be renamed on disk (or in object storage — backend not yet chosen, see impact assessment `9b.5`) to `{project_code}_{TIMESTAMP}_{Seq}.{ext}`, where `{Seq}` is a running sequence number, so that multiple files uploaded within the same second do not overwrite each other. The original filename the user provided SHALL be preserved separately for display.

#### Scenario: Two files uploaded in the same second
- **WHEN** a Sales user uploads two files as part of the same request within the same second
- **THEN** both SHALL be written to disk under distinct filenames (distinguished by `{Seq}`), and both SHALL retain their own original display filename

### Requirement: Orphaned files are cleaned up
If a file is written to disk (or object storage) but its metadata row fails to persist (or vice versa), the system SHALL roll back the successful half of the operation or flag the orphan for a periodic cleanup job — an attachment SHALL NOT exist on disk/object storage with no corresponding `project.entry_file` row indefinitely.

#### Scenario: Metadata write failure rolls back the disk write
- **WHEN** the disk write for an uploaded file succeeds but the database write for its metadata row fails
- **THEN** the system SHALL remove the orphaned disk file as part of handling that failure, or ensure a scheduled cleanup job will remove it
