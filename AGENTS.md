# SubForAI - AI Agent Codebase Guide

> AI API Gateway Platform for Subscription Quota Distribution

## Project Overview

SubForAI is a full-stack AI API gateway that distributes and manages API quotas from AI product subscriptions (Claude, OpenAI, Gemini, Bedrock). Users access upstream AI services through platform-generated API Keys. The platform handles authentication, billing, load balancing, request forwarding, and payment.

**Tech Stack:** Go 1.26 (backend) + Vue 3.4 / TypeScript / Tailwind CSS (frontend) + PostgreSQL 15+ + Redis 7+

**Scale:** ~200k lines Go (backend), ~130k lines Vue/TS (frontend), 161 SQL migrations, 504 Go test files, 90 frontend test files.

---

## Architecture

```
┌─────────────┐     ┌────────────────────────────────────────────┐
│  Vue 3 SPA  │────▶│              Go HTTP Server                │
│  (frontend) │     │  ┌──────────┐  ┌────────────┐  ┌────────┐ │
└─────────────┘     │  │ Handlers │──│  Services   │──│  Ent   │ │
                    │  └──────────┘  └────────────┘  │  ORM   │ │
┌─────────────┐     │  ┌──────────────────────┐      └───┬────┘ │
│ API Clients │────▶│  │   Gateway (proxy)    │          │      │
│ (Claude Code│     │  │ OpenAI/Anthropic/    │     ┌────▼────┐ │
│  Codex etc) │     │  │ Gemini/Bedrock       │     │PostgreSQL│ │
└─────────────┘     │  └──────────┬───────────┘     └─────────┘ │
                    │             │                  ┌─────────┐ │
                    │             ▼                  │  Redis   │ │
                    │  ┌──────────────────────┐      └─────────┘ │
                    │  │  Upstream Accounts   │                  │
                    │  │  (OAuth/API Key)     │                  │
                    │  └──────────────────────┘                  │
                    └────────────────────────────────────────────┘
```

**Request Flow:** API Client → Auth Middleware (API Key validation) → Rate Limiter → Gateway Handler → Scheduler (select upstream account) → Upstream AI Provider → Stream/Response back to client → Billing (token counting)

---

## Directory Structure

### Root

| Path | Purpose |
|------|---------|
| `backend/` | Go backend (API server, gateway, scheduler) |
| `frontend/` | Vue 3 SPA (admin dashboard, user portal) |
| `deploy/` | Docker Compose, Caddy, entrypoint scripts, config examples |
| `docs/` | Payment docs, environment docs, API docs |
| `tools/` | Dev helper scripts (env setup, secret scan, audit) |
| `Makefile` | Top-level build/test/dev commands |
| `.goreleaser.yaml` | Release automation config |

### Backend (`backend/`)

| Path | Purpose |
|------|---------|
| `cmd/server/` | Application entrypoint (`main.go`) |
| `cmd/jwtgen/` | JWT token generation utility |
| `internal/config/` | YAML config loading, dependency injection (Wire) |
| `internal/domain/` | Domain constants, message dispatch types |
| `internal/handler/` | HTTP handlers — user-facing API endpoints |
| `internal/handler/admin/` | Admin-only HTTP handlers (40+ files) |
| `internal/handler/dto/` | Data transfer objects for API request/response |
| `internal/middleware/` | Rate limiter middleware |
| `internal/model/` | Shared model types |
| `internal/service/` | **Core business logic** (~200 files, largest package) |
| `internal/payment/` | Payment abstraction layer |
| `internal/payment/provider/` | Payment providers: Alipay, WeChat Pay, EasyPay, Stripe |
| `internal/repository/` | Database repository layer |
| `internal/server/` | HTTP server setup, route registration |
| `internal/server/routes/` | Route definitions |
| `internal/server/middleware/` | Server-level middleware |
| `internal/setup/` | First-run setup wizard logic |
| `internal/integration/` | External service integrations |
| `internal/web/` | Embedded frontend static files |
| `internal/pkg/` | Reusable internal packages (see below) |
| `internal/util/` | General utilities |
| `internal/testutil/` | Test helpers |
| `ent/` | Ent ORM generated code (DO NOT edit manually) |
| `migrations/` | SQL migration files (numbered, 161 files) |
| `resources/model-pricing/` | AI model pricing data |
| `data/` | Static data resources |

### Backend Internal Packages (`backend/internal/pkg/`)

| Package | Purpose |
|---------|---------|
| `antigravity/` | Anthropic (Claude) API integration |
| `claude/` | Claude-specific protocol handling |
| `openai/` | OpenAI API protocol handling |
| `gemini/` | Google Gemini API integration |
| `geminicli/` | Gemini CLI code assist support |
| `googleapi/` | Google API helpers |
| `oauth/` | OAuth flow utilities |
| `apicompat/` | API compatibility layer |
| `httpclient/` | HTTP client abstraction |
| `httputil/` | HTTP utility functions |
| `ip/` | IP address utilities |
| `logger/` | Structured logging |
| `pagination/` | Pagination helpers |
| `proxyurl/` | Proxy URL parsing |
| `proxyutil/` | Proxy utilities |
| `response/` | Response formatting |
| `errors/` | Error types |
| `ctxkey/` | Context key definitions |
| `sysutil/` | System utilities |
| `timezone/` | Timezone handling |
| `tlsfingerprint/` | TLS fingerprint management |
| `usagestats/` | Usage statistics helpers |
| `websearch/` | Web search emulation |

### Frontend (`frontend/src/`)

| Path | Purpose |
|------|---------|
| `views/` | Page-level Vue components (route targets) |
| `views/admin/` | Admin dashboard pages (Accounts, Channels, Groups, Settings, Usage, etc.) |
| `views/admin/ops/` | Operations dashboard (error logs, latency, throughput, alerts) |
| `views/admin/orders/` | Payment order management |
| `views/auth/` | Login, Register, OAuth callbacks (LinuxDo, WeChat, OIDC) |
| `views/user/` | User portal (Dashboard, Keys, Usage, Payment, Subscriptions, Profile) |
| `views/setup/` | First-run setup wizard |
| `components/` | Reusable UI components |
| `components/admin/` | Admin-specific components (account, channel, group, monitor, payment, proxy, usage, user) |
| `components/auth/` | Authentication components |
| `components/charts/` | Chart.js chart components |
| `components/common/` | Shared UI components |
| `components/keys/` | API key management components |
| `components/layout/` | Layout components (sidebar, header) |
| `components/payment/` | Payment-related components |
| `components/user/` | User portal components (dashboard, monitor, profile) |
| `api/` | API client layer (Axios-based) |
| `api/admin/` | Admin API endpoints |
| `stores/` | Pinia state stores (app, auth, payment, subscriptions, announcements, onboarding, adminSettings) |
| `composables/` | Vue composables (form, clipboard, table, OAuth, search, etc.) |
| `router/` | Vue Router config with auth guards |
| `i18n/` | Internationalization (English, Chinese) |
| `i18n/locales/` | `en.ts`, `zh.ts` locale files |
| `utils/` | Utility functions (pricing, formatting, feature flags, billing, etc.) |
| `constants/` | Constant definitions (account types, channel types, monitor) |
| `types/` | TypeScript type definitions |
| `styles/` | Global CSS styles |
| `assets/` | Static assets and icons |

---

## Key Subsystems

### 1. Gateway (Request Proxy)

The core value: proxies AI API requests to upstream providers.

**Entry:** `handler/gateway_handler.go`, `handler/openai_gateway_handler.go`
**Service:** `service/gateway_service.go`, `service/openai_gateway_service.go`

Supports:
- **OpenAI-compatible**: Chat completions, Responses API, Images, WebSocket (Realtime)
- **Anthropic (Claude)**: Messages API via `antigravity` package
- **Google Gemini**: Native + Messages compatibility mode
- **AWS Bedrock**: Streaming via SigV4 signing
- **Codex**: OpenAI Codex transform + instructions template

Key files:
- `service/gateway_request.go` — upstream request construction
- `service/gateway_billing_block.go` — pre-request billing checks
- `service/gateway_forward_as_chat_completions.go` / `gateway_forward_as_responses.go` — format conversion
- `service/openai_ws_*.go` — WebSocket relay (OpenAI Realtime API)
- `service/openai_ws_v2/` — V2 WebSocket passthrough relay

### 2. Scheduler (Account Selection)

Intelligently selects upstream accounts for each request.

**Service:** `service/openai_account_scheduler.go`
**Cache:** `service/scheduler_cache.go`
**Events:** `service/scheduler_events.go`

Features: sticky sessions, concurrency control, account rotation, health-based selection, temporary unscheduling.

### 3. Billing & Usage

Token-level usage tracking and cost calculation.

**Service:** `service/billing_service.go`, `service/billing_cache_service.go`
**Usage:** `service/usage_service.go`, `service/usage_log.go`, `service/usage_billing.go`
**Pricing:** `service/pricing_service.go`, `service/model_pricing_resolver.go`
**Worker:** `service/usage_record_worker_pool.go` — async usage recording
**Cleanup:** `service/usage_cleanup_service.go`

### 4. Authentication & Authorization

Multi-method auth system.

**Handler:** `handler/auth_handler.go`, `handler/auth_*_oauth.go`
**Service:** `service/auth_service.go`, `service/auth_*.go`
**API Keys:** `service/api_key_service.go`, `service/api_key_auth_cache.go`
**TOTP:** `service/totp_service.go`
**Identity:** `service/identity_service.go`, `service/auth_pending_identity_service.go`

Supports: Email/password, LinuxDo OAuth, WeChat OAuth, OIDC, TOTP 2FA.

### 5. Payment System

Built-in payment for user self-service top-up.

**Abstraction:** `payment/types.go`, `payment/registry.go`
**Providers:** `payment/provider/` — Alipay, WeChat Pay, EasyPay, Stripe
**Service:** `service/payment_service.go`, `service/payment_order.go`, `service/payment_fulfillment.go`
**Handler:** `handler/payment_handler.go`, `handler/payment_webhook_handler.go`
**Config:** `service/payment_config_*.go`
**Frontend:** `views/user/PaymentView.vue`, `views/user/StripePaymentView.vue`

### 6. Operations Dashboard (Ops)

Real-time monitoring and alerting.

**Backend:** `service/ops_*.go` (~25 files)
**Handlers:** `handler/admin/ops_*.go`
**Frontend:** `views/admin/ops/` — dashboard, charts, logs, alerts

Features: error tracking, latency histograms, throughput trends, account switch rates, concurrency monitoring, real-time WebSocket updates, alert rules with email notifications.

### 7. Channel Management

Channels = upstream AI service configurations.

**Service:** `service/channel_service.go`, `service/channel_available.go`
**Monitor:** `service/channel_monitor_*.go` — health checking, SSRF protection
**Frontend:** `views/admin/ChannelsView.vue`, `views/admin/ChannelMonitorView.vue`

### 8. Account Management

Upstream AI accounts (OAuth tokens, API keys).

**Service:** `service/account_service.go`, `service/account_usage_service.go`
**OAuth:** `service/antigravity_oauth_service.go`, `service/openai_oauth_service.go`, `service/gemini_oauth_service.go`
**Token Refresh:** `service/token_refresh_service.go`, `service/*_token_refresher.go`

### 9. User & Group Management

User tiers, groups, permissions, rate limits.

**Service:** `service/user_service.go`, `service/group_service.go`, `service/group_capacity_service.go`
**Rate Limits:** `service/ratelimit_service.go`, `service/model_rate_limit.go`, `service/user_group_rate_resolver.go`
**RPM:** `service/user_rpm_cache.go`, `service/rpm_cache.go`

### 10. Subscription System

Subscription plans and user subscriptions.

**Service:** `service/subscription_service.go`, `service/subscription_expiry_service.go`
**Frontend:** `views/user/SubscriptionsView.vue`, `views/admin/SubscriptionsView.vue`

---

## Development

### Commands

```bash
make build              # Build backend + frontend
make test               # Run all tests
make test-backend       # Go tests only
make test-frontend      # Lint + typecheck + critical vitest tests
make dev-deps-up        # Start PostgreSQL + Redis (Docker)
make dev-backend        # Run backend dev server
make dev-frontend       # Run Vite dev server (pnpm)
make secret-scan        # Scan for secrets in code
make release-check      # Full test + build verification
```

### Key Config

Main config: `deploy/config.example.yaml` — server, database, Redis, auth, upstream providers, payment, scheduling, ops.

### Database

- ORM: [Ent](https://entgo.io/) — schema in `backend/ent/`, generated code (do not edit)
- Migrations: `backend/migrations/` — numbered SQL files, applied in order
- Migration runner: `backend/migrations/migrations.go`

### Dependency Injection

Uses Google Wire: `backend/internal/config/wire.go`, `backend/internal/handler/wire.go`, `backend/internal/service/wire.go`, `backend/internal/payment/wire.go`

### Frontend Build

- Bundler: Vite 5
- State: Pinia stores
- Routing: Vue Router with auth guards
- i18n: vue-i18n (en/zh)
- Charts: Chart.js via vue-chartjs
- Tests: Vitest + @vue/test-utils

### Deployment

- Docker: `Dockerfile` (multi-stage), `Dockerfile.goreleaser`
- Compose: `deploy/docker-compose.local.yml`, `deploy/docker-compose.local-build.yml`
- Reverse Proxy: Caddy (`deploy/Caddyfile`)
- Management: `deploy/appctl.sh` — operational helper script

---

## Conventions

- **Go package layout**: Standard `cmd/` + `internal/` with handler → service → repository layering
- **Generated code**: `backend/ent/` is auto-generated — never edit directly, modify schemas instead
- **Naming**: Services use `*_service.go` suffix; handlers use `*_handler.go`; upstream providers prefixed by platform (`openai_*`, `gemini_*`, `antigravity_*`, `bedrock_*`)
- **API compatibility**: OpenAI-compatible API is the primary interface; other providers are adapted to this format
- **Frontend**: Vue 3 Composition API + `<script setup>` style; composables for reusable logic
- **Bilingual**: All user-facing text supports English and Chinese via i18n
- **Config**: YAML-based config with extensive defaults; environment variables for secrets

---

## Common Tasks for AI Agents

| Task | Start Here |
|------|-----------|
| Add new AI provider | `backend/internal/pkg/` (protocol), `service/gateway_service.go` (routing), `service/*_token_provider.go` |
| Add payment provider | `backend/internal/payment/provider/` (implement interface in `types.go`), `payment/provider/factory.go` |
| Add admin API endpoint | `backend/internal/handler/admin/` + `backend/internal/server/routes/routes.go` |
| Add user API endpoint | `backend/internal/handler/` + `backend/internal/server/routes/routes.go` |
| Add frontend page | `frontend/src/views/` + `frontend/src/router/index.ts` |
| Add database migration | `backend/migrations/` (next number), update Ent schema if needed |
| Modify billing logic | `backend/internal/service/billing_service.go`, `usage_billing.go` |
| Change scheduling | `backend/internal/service/openai_account_scheduler.go` |
| Add ops metric | `backend/internal/service/ops_*.go` + `frontend/src/views/admin/ops/` |
| Fix upstream proxy | `backend/internal/service/gateway_request.go`, provider-specific `*_gateway_service.go` |
| Add OAuth provider | `backend/internal/handler/auth_*_oauth.go` + `backend/internal/service/oauth_service.go` |
