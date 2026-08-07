## ADDED Requirements

### Requirement: Push notification supplements the in-app bell, never replaces it
The system SHALL deliver selected notification events to external messaging channels (LINE and Telegram) in addition to the in-app notification bell. The bell SHALL remain the complete record of a user's notifications regardless of whether any external channel is linked, reachable, or enabled.

#### Scenario: Bell is unaffected by push outcome
- **WHEN** a notification event is created for a user
- **THEN** the in-app bell entry SHALL be written regardless of whether push delivery succeeds, fails, or is skipped

#### Scenario: Only action-required events are pushed
- **WHEN** the system creates a notification event
- **THEN** it SHALL push externally only for event types configured as requiring the recipient's action (a pending approval, or a project closed via "ล่ม"), and SHALL NOT mirror every in-app notification to the external channels

### Requirement: Users link their own messaging account, and unlinked users are told
A user SHALL be able to link and unlink their own LINE and/or Telegram account against their own profile, using the identity verified from the SSO session — no user SHALL be able to link a channel on another user's behalf. A user with no linked channel SHALL receive no push, and the UI SHALL make that state visible rather than failing silently.

#### Scenario: Linking is restricted to the account owner
- **WHEN** a request attempts to bind a messaging account to a user other than the verified session identity
- **THEN** the server SHALL reject it

#### Scenario: Unlinked state is surfaced, not silent
- **WHEN** a user who can receive approval events has no messaging channel linked
- **THEN** the UI SHALL show that they will not receive external notifications, with a way to link one

#### Scenario: Unlinking stops delivery without affecting the bell
- **WHEN** a user unlinks a channel
- **THEN** no further messages SHALL be sent to it, and their in-app notifications SHALL continue unchanged

### Requirement: Telegram account linking is the only inbound path and must be token-verified
Because Telegram cannot bind an account from an outbound push alone, the system SHALL accept an inbound `/start` message carrying a one-time, expiring token that the system itself issued for a known user, and SHALL bind the resulting `chat_id` only to that user. The system SHALL NOT bind an account from a `chat_id` presented without a valid token. When the inbound path is implemented as a webhook, the system SHALL verify Telegram's secret-token header on every call and ignore any request failing that check.

#### Scenario: Valid token binds the account
- **WHEN** a user opens the bot deep link containing a token the system issued to them and the bot receives `/start`
- **THEN** the system SHALL store the sender's `chat_id` against that user and invalidate the token

#### Scenario: Missing, expired, or reused token binds nothing
- **WHEN** `/start` arrives with no token, an expired token, or a token already consumed
- **THEN** the system SHALL NOT bind any account and SHALL respond with an instruction to restart linking from the web app

#### Scenario: Unverified webhook call is ignored
- **WHEN** an inbound webhook request arrives without the expected Telegram secret-token header
- **THEN** the system SHALL ignore it and SHALL NOT process any binding

### Requirement: Message content is minimal and identical across channels
An external message SHALL contain only the project code, the request/event type, and a deep link back into the authenticated web app. It SHALL NOT contain cost, EP, GP, price, or any other commercially sensitive figure, since the receiving app is outside this system's control. The content rule SHALL be enforced on the neutral payload shared by all channels, not re-implemented per channel.

#### Scenario: Sensitive figures never leave in a message
- **WHEN** a push is generated for an event on a project carrying cost and GP data
- **THEN** the delivered message SHALL contain no cost, EP, GP, or price value on any channel

#### Scenario: Both channels carry the same information
- **WHEN** the same event is delivered to a user on LINE and to a user on Telegram
- **THEN** both messages SHALL convey the same fields and the same deep-link target, differing only in presentation format

### Requirement: Channel adapters isolate per-channel formatting from business logic
Notification-producing code SHALL emit one channel-neutral payload per event and SHALL NOT construct channel-specific message bodies. Each channel SHALL have an adapter responsible for rendering that payload (LINE Flex Message; Telegram text with an inline keyboard) and calling its provider API. Adding a further channel SHALL NOT require changing notification-producing code.

#### Scenario: Adding a channel does not touch business logic
- **WHEN** a third channel is added later
- **THEN** the change SHALL be confined to a new adapter and configuration, with no edit to the services that create notification events

### Requirement: Push delivery is asynchronous and never fails the originating action
Push delivery SHALL run outside the HTTP request that triggered the event. A delivery failure on any channel — provider outage, exceeded quota, blocked bot, revoked link — SHALL NOT fail, roll back, or delay the business action that produced the event, and SHALL NOT prevent delivery on the other channel.

#### Scenario: Provider outage does not block approval submission
- **WHEN** a Sales user submits a request for approval while the messaging provider is unavailable
- **THEN** the request SHALL be created successfully, the in-app notification SHALL appear, and the failed push SHALL be recorded for retry or diagnosis without surfacing as a user-facing error

#### Scenario: One channel failing does not suppress the other
- **WHEN** a recipient has both channels linked and delivery fails on one of them
- **THEN** delivery on the other channel SHALL still be attempted
