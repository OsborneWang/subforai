# Sub2API

<div align="center">

[![Go](https://img.shields.io/badge/Go-1.25.7-00ADD8.svg)](https://golang.org/)
[![Vue](https://img.shields.io/badge/Vue-3.4+-4FC08D.svg)](https://vuejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-336791.svg)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Redis-7+-DC382D.svg)](https://redis.io/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED.svg)](https://www.docker.com/)

**サブスクリプションクォータ配分のための AI API ゲートウェイプラットフォーム**

[English](README.md) | [中文](README_CN.md) | 日本語

</div>

> **Sub2API が公式に使用しているドメインは `sub2api.org` と `pincc.ai` のみです。Sub2API の名称を使用している他のウェブサイトは、サードパーティによるデプロイやサービスであり、本プロジェクトとは一切関係がありません。ご利用の際はご自身で確認・判断をお願いします。**

---

## デモ

Sub2API をオンラインでお試しください: **[https://demo.sub2api.org/](https://demo.sub2api.org/)**

デモ用認証情報（共有デモ環境です。セルフホスト環境では**自動作成されません**）:

| メールアドレス | パスワード |
|-------|----------|
| admin@sub2api.org | admin123 |

## 概要

Sub2API は、AI 製品のサブスクリプションから API クォータを配分・管理するために設計された AI API ゲートウェイプラットフォームです。ユーザーはプラットフォームが生成した API キーを通じて上流の AI サービスにアクセスでき、プラットフォームは認証、課金、負荷分散、リクエスト転送を処理します。

## 機能

- **マルチアカウント管理** - 複数の上流アカウントタイプ（OAuth、APIキー）をサポート
- **APIキー配布** - ユーザー向けの APIキーの生成と管理
- **精密な課金** - トークンレベルの使用量追跡とコスト計算
- **スマートスケジューリング** - スティッキーセッション付きのインテリジェントなアカウント選択
- **同時実行制御** - ユーザーごと・アカウントごとの同時実行数制限
- **レート制限** - 設定可能なリクエスト数およびトークンレート制限
- **内蔵決済システム** - EasyPay、Alipay、WeChat Pay、Stripe に対応。ユーザーのセルフサービスチャージが可能で、別途決済サービスのデプロイは不要（[設定ガイド](docs/PAYMENT.md)）
- **管理ダッシュボード** - 監視・管理のための Web インターフェース
- **外部システム連携** - 外部システム（チケット管理など）を iframe 経由で管理ダッシュボードに埋め込み可能

## ❤️ スポンサー

> [こちらに掲載しませんか？](mailto:support@pincc.ai)

<table>
<tr>
<td width="180" align="center" valign="middle"><a href="https://shop.pincc.ai/"><img src="assets/partners/logos/pincc-logo.png" alt="pincc" width="150"></a></td>
<td valign="middle"><b><a href="https://shop.pincc.ai/">PinCC</a></b> は Sub2API 上に構築された公式リレーサービスで、Claude Code、Codex、Gemini などの人気モデルへの安定したアクセスを提供します。デプロイやメンテナンスは不要で、すぐにご利用いただけます。</td>
</tr>
<tr>
<td width="180"><a href="https://www.packyapi.com/register?aff=sub2api"><img src="assets/partners/logos/packycode.png" alt="PackyCode" width="150"></a></td>
<td>PackyCode のご支援に感謝します！PackyCode は Claude Code、Codex、Gemini などのリレーサービスを提供する信頼性の高い API 中継プラットフォームです。本ソフト利用者向けに特別割引があります：<a href="https://www.packyapi.com/register?aff=sub2api">このリンク</a>で登録し、チャージ時に「sub2api」クーポンを入力すると 10% オフになります。</td>
</tr>

<tr>
<td width="180"><a href="https://poixe.com/i/sub2api"><img src="assets/partners/logos/poixe.png" alt="PoixeAi" width="150"></a></td>
<td>Poixe AI のご支援に感謝します！Poixe AI は信頼性の高い LLM API サービスを提供しています。プラットフォームの API エンドポイントを活用して、AI 搭載プロダクトをシームレスに構築できます。また、ベンダーとして AI API リソースをプラットフォームに提供し、収益を得ることも可能です。専用の <a href="https://poixe.com/i/sub2api">sub2api</a> 紹介リンクから登録すると、初回チャージ時に $5 USD のボーナスがもらえます。</td>
</tr>

<tr>
<td width="180"><a href="https://ctok.ai"><img src="assets/partners/logos/ctok.png" alt="CTok" width="150"></a></td>
<td>CTok.ai のご支援に感謝します！CTok.ai はワンストップ AI プログラミングツールサービスプラットフォームの構築に取り組んでいます。Claude Code の専用プランと技術コミュニティサービスを提供し、Google Gemini や OpenAI Codex もサポートしています。丁寧に設計されたプランと専門的な技術コミュニティを通じて、開発者に安定したサービス保証と継続的な技術サポートを提供し、AI アシスト プログラミングを真の生産性向上ツールにします。<a href="https://ctok.ai">こちら</a>から登録！</td>
</tr>

<tr>
<td width="180"><a href="https://code.silkapi.com/"><img src="assets/partners/logos/silkapi.png" alt="silkapi" width="150"></a></td>
<td>SilkAPI のご支援に感謝します！<a href="https://code.silkapi.com/">SilkAPI</a> は Sub2API をベースに構築された中継サービスで、高速かつ安定した Codex API 中継の提供に特化しています。</td>
</tr>

<tr>
<td width="180"><a href="https://ylscode.com/"><img src="assets/partners/logos/ylscode.png" alt="ylscode" width="150"></a></td>
<td>YLS Code のご支援に感謝します！<a href="https://ylscode.com/">YLS Code</a> は安全なエンタープライズグレードの Coding Agent 生産性サービスの構築に取り組んでおり、安定かつ高速な Codex / Claude / Gemini サブスクリプションサービスと従量課金 API の柔軟なプランを提供しています。期間限定で新規登録者に 3 日間の Codex 試用特典をプレゼント中！</td>
</tr>

<tr>
<td width="180"><a href="https://www.aicodemirror.com/register?invitecode=KMVZQM"><img src="assets/partners/logos/AICodeMirror.jpg" alt="AICodeMirror" width="150"></a></td>
<td>AICodeMirror のご支援に感謝します！AICodeMirror は Claude Code / Codex / Gemini CLI の公式高安定性リレーサービスを提供しており、エンタープライズグレードの同時実行、迅速な請求書発行、24時間年中無休の専属テクニカルサポートを備えています。Claude Code / Codex / Gemini の公式チャネルを定価の 38% / 2% / 9% で利用可能、チャージ時にはさらに追加割引！AICodeMirror は sub2api ユーザー向けに特別特典を提供中：<a href="https://www.aicodemirror.com/register?invitecode=KMVZQM">こちらのリンク</a>から登録すると、初回チャージが 20% オフ、法人のお客様は最大 25% オフ！</td>
</tr>

<tr>
<td width="180"><a href="https://aigocode.com/invite/SUB2API"><img src="assets/partners/logos/aigocode.png" alt="AIGoCode" width="150"></a></td>
<td>AIGoCode のご支援に感謝します！AIGoCode は Claude Code、Codex、最新の Gemini モデルを統合したオールインワンプラットフォームで、安定的かつ効率的でコストパフォーマンスに優れた AI コーディングサービスを提供します。柔軟なサブスクリプションプラン、アカウント停止リスクゼロ、VPN 不要の直接アクセス、超高速レスポンスが特長です。AIGoCode は sub2api ユーザー向けに特別特典を用意しています：<a href="https://aigocode.com/invite/SUB2API">こちらのリンク</a>から登録すると、初回チャージ時に 10% のボーナスクレジットを追加プレゼント！</td>
</tr>

<tr>
<td width="180"><a href="https://shop.bmoplus.com/?utm_source=github"><img src="assets/partners/logos/bmoplus.jpg" alt="bmoplus" width="150"></a></td>
<td>本プロジェクトにご支援いただいた BmoPlus に感謝いたします！BmoPlusは、AIサブスクリプションのヘビーユーザー向けに特化した信頼性の高いAIアカウントサービスプロバイダーであり、安定した ChatGPT Plus / ChatGPT Pro (完全保証) / Claude Pro / Super Grok / Gemini Pro の公式代行チャージおよび即納アカウントを提供しています。こちらの<a href="https://shop.bmoplus.com/?utm_source=github">BmoPlus AIアカウント専門店/代行チャージ</a>経由でご登録・ご注文いただいたユーザー様は、GPTを 公式サイト価格の約1割（90% OFF） という驚異的な価格でご利用いただけます！</td>
</tr>

<tr>
<td width="180"><a href="https://bestproxy.com/?keyword=a2e8iuol"><img src="assets/partners/logos/bestproxy.png" alt="bestproxy" width="150"></a></td>
<td>Bestproxy のご支援に感謝します！<a href="https://bestproxy.com/?keyword=a2e8iuol">Bestproxy</a> は高純度の住宅IPを提供し、1アカウント1IP専有をサポートしています。実際の家庭ネットワークとフィンガープリント分離を組み合わせることで、リンク環境の分離を実現し、関連付けによるリスク管理の確率を低減します。</td>
</tr>

</table>

## エコシステム

Sub2API を拡張・統合するコミュニティプロジェクト:

| プロジェクト | 説明 | 機能 |
|---------|-------------|----------|
| ~~[Sub2ApiPay](https://github.com/touwaeriol/sub2apipay)~~ | ~~セルフサービス決済システム~~ | **内蔵済み** — 決済機能は Sub2API に統合されました。別途デプロイは不要です。[決済設定ガイド](docs/PAYMENT.md)をご参照ください |
| [sub2api-mobile](https://github.com/ckken/sub2api-mobile) | モバイル管理コンソール | ユーザー管理、アカウント管理、監視ダッシュボード、マルチバックエンド切り替えが可能なクロスプラットフォームアプリ（iOS/Android/Web）。Expo + React Native で構築 |

## 技術スタック

| コンポーネント | 技術 |
|-----------|------------|
| バックエンド | Go 1.25.7, Gin, Ent |
| フロントエンド | Vue 3.4+, Vite 5+, TailwindCSS |
| データベース | PostgreSQL 15+ |
| キャッシュ/キュー | Redis 7+ |

---

## Nginx リバースプロキシに関する注意

Sub2API（または CRS）を Nginx でリバースプロキシし、Codex CLI と組み合わせて使用する場合、Nginx の `http` ブロックに以下の設定を追加してください:

```nginx
underscores_in_headers on;
```

Nginx はデフォルトでアンダースコアを含むヘッダー（例: `session_id`）を破棄するため、マルチアカウント構成でのスティッキーセッションルーティングに支障をきたします。

---

## デプロイ

### 方法1: ローカルソースを使う Docker Compose（推奨）

このリポジトリでは、現在 1 つの Docker デプロイ方式だけを保守しています。アプリイメージはローカルソースコードからビルドし、実行時データは `deploy/data`、`deploy/postgres_data`、`deploy/redis_data` に保持します。

#### 前提条件

- Docker 20.10+
- Docker Compose v2+

#### クイックスタート

```bash
git clone https://github.com/OsborneWang/subforai.git
cd subforai/deploy
cp .env.example .env
nano .env
mkdir -p data postgres_data redis_data
./appctl.sh up
```

この運用フローで使用する主なファイル:

- `deploy/docker-compose.local.yml`
- `deploy/docker-compose.local-build.yml`
- `deploy/appctl.sh`

`appctl.sh` は、現在のローカルリポジトリからアプリイメージをビルドし、PostgreSQL と Redis を永続化ディレクトリ付きで起動します。

#### 日常運用

```bash
# 現在のローカルコードで再ビルドして再起動
./appctl.sh deploy

# 先にバックアップしてから再ビルド・再起動
./appctl.sh upgrade

# アプリログを見る
./appctl.sh logs

# コンテナ状態を見る
./appctl.sh ps

# データを消さずに停止
./appctl.sh stop

# origin/main に同期し、古いファイルを掃除してから再デプロイ
./appctl.sh pull-deploy
```

#### バックアップと移行

```bash
# deploy/backups/ にタイムスタンプ付きバックアップを作成
./appctl.sh backup
```

新しいサーバーへ移行する場合は、最低でも次をコピーしてください:

- `deploy/.env`
- `deploy/data`
- `deploy/postgres_data`
- `deploy/redis_data`

移行先で `./appctl.sh up` を実行すれば再起動できます。

#### 注意事項

- データを消したくない限り `docker compose down -v` は実行しないでください。
- アップグレード時に前方互換のデータベース migration が走る可能性があります。重要な変更前は先にバックアップしてください。
- 詳細な運用手順は `deploy/LOCAL_BUILD_OPERATIONS.md` を参照してください。

---

### 方法2: ソースからビルド

開発やカスタマイズのためにソースコードからビルドして実行します。

#### 前提条件

- Go 1.21+
- Node.js 18+
- PostgreSQL 15+
- Redis 7+

#### ビルド手順

```bash
# 1. リポジトリをクローン
git clone https://github.com/OsborneWang/subforai.git
cd sub2api

# 2. pnpm をインストール（未インストールの場合）
npm install -g pnpm

# 3. フロントエンドをビルド
cd frontend
pnpm install
pnpm run build
# 出力先: ../backend/internal/web/dist/

# 4. フロントエンドを組み込んだバックエンドをビルド
cd ../backend
go build -tags embed -o sub2api ./cmd/server

# 5. 設定ファイルを作成
cp ../deploy/config.example.yaml ./config.yaml

# 6. 設定を編集
nano config.yaml
```

> **注意:** `-tags embed` フラグはフロントエンドをバイナリに組み込みます。このフラグがない場合、バイナリはフロントエンド UI を提供しません。

**`config.yaml` の主要設定:**

```yaml
server:
  host: "0.0.0.0"
  port: 8080
  mode: "release"

database:
  host: "localhost"
  port: 5432
  user: "postgres"
  password: "your_password"
  dbname: "sub2api"

redis:
  host: "localhost"
  port: 6379
  password: ""

jwt:
  secret: "change-this-to-a-secure-random-string"
  expire_hour: 24

default:
  user_concurrency: 5
  user_balance: 0
  api_key_prefix: "sk-"
  rate_multiplier: 1.0
```

### Sora ステータス（一時的に利用不可）

> ⚠️ Sora 関連の機能は、上流統合およびメディア配信の技術的問題により一時的に利用できません。
> 現時点では本番環境で Sora に依存しないでください。
> 既存の `gateway.sora_*` 設定キーは予約されていますが、これらの問題が解決されるまで有効にならない場合があります。

`config.yaml` では追加のセキュリティ関連オプションも利用できます:

- `cors.allowed_origins` - CORS 許可リスト
- `security.url_allowlist` - 上流/価格/CRS ホストの許可リスト
- `security.url_allowlist.enabled` - URL バリデーションの無効化（注意して使用）
- `security.url_allowlist.allow_insecure_http` - バリデーション無効時に HTTP URL を許可
- `security.url_allowlist.allow_private_hosts` - プライベート/ローカル IP アドレスを許可
- `security.response_headers.enabled` - 設定可能なレスポンスヘッダーフィルタリングを有効化（無効時はデフォルトの許可リストを使用）
- `security.csp` - Content-Security-Policy ヘッダーの制御
- `billing.circuit_breaker` - 課金エラー時にフェイルクローズ
- `server.trusted_proxies` - X-Forwarded-For パースの有効化
- `turnstile.required` - リリースモードでの Turnstile 必須化

**⚠️ セキュリティ警告: HTTP URL 設定**

`security.url_allowlist.enabled=false` の場合、システムはデフォルトで最小限の URL バリデーションを行い、**HTTP URL を拒否**して HTTPS のみを許可します。HTTP URL を許可するには（開発環境や内部テスト用など）、以下を明示的に設定する必要があります:

```yaml
security:
  url_allowlist:
    enabled: false                # 許可リストチェックを無効化
    allow_insecure_http: true     # HTTP URL を許可（⚠️ セキュリティリスクあり）
```

**または環境変数で設定:**

```bash
SECURITY_URL_ALLOWLIST_ENABLED=false
SECURITY_URL_ALLOWLIST_ALLOW_INSECURE_HTTP=true
```

**HTTP を許可するリスク:**
- API キーとデータが**平文**で送信される（傍受の危険性）
- **中間者攻撃（MITM）**を受けやすい
- **本番環境には不適切**

**HTTP を使用すべき場面:**
- ✅ ローカルサーバーでの開発・テスト（http://localhost）
- ✅ 信頼できるエンドポイントを持つ内部ネットワーク
- ✅ HTTPS 取得前のアカウント接続テスト
- ❌ 本番環境（HTTPS のみを使用）

**この設定なしで表示されるエラー例:**
```
Invalid base URL: invalid url scheme: http
```

URL バリデーションまたはレスポンスヘッダーフィルタリングを無効にする場合は、ネットワーク層を強化してください:
- 上流ドメイン/IP のエグレス許可リストを適用
- プライベート/ループバック/リンクローカル範囲をブロック
- TLS のみのアウトバウンドトラフィックを強制
- プロキシで機密性の高い上流レスポンスヘッダーを除去

```bash
# 6. アプリケーションを実行
./sub2api
```

#### 開発モード

```bash
# バックエンド（ホットリロード付き）
cd backend
go run ./cmd/server

# フロントエンド（ホットリロード付き）
cd frontend
pnpm run dev
```

#### コード生成

`backend/ent/schema` を編集した場合、Ent + Wire を再生成してください:

```bash
cd backend
go generate ./ent
go generate ./cmd/server
```

---

## シンプルモード

シンプルモードは、フル SaaS 機能を必要とせず、素早くアクセスしたい個人開発者や社内チーム向けに設計されています。

- 有効化: 環境変数 `RUN_MODE=simple` を設定
- 違い: SaaS 関連機能を非表示にし、課金プロセスをスキップ
- セキュリティに関する注意: 本番環境では `SIMPLE_MODE_CONFIRM=true` も設定する必要があります

---

## Antigravity サポート

Sub2API は [Antigravity](https://antigravity.so/) アカウントをサポートしています。認証後、Claude および Gemini モデル用の専用エンドポイントが利用可能になります。

### 専用エンドポイント

| エンドポイント | モデル |
|----------|-------|
| `/antigravity/v1/messages` | Claude モデル |
| `/antigravity/v1beta/` | Gemini モデル |

### Claude Code の設定

```bash
export ANTHROPIC_BASE_URL="http://localhost:8080/antigravity"
export ANTHROPIC_AUTH_TOKEN="sk-xxx"
```

### ハイブリッドスケジューリングモード

Antigravity アカウントはオプションの**ハイブリッドスケジューリング**をサポートしています。有効にすると、汎用エンドポイント `/v1/messages` および `/v1beta/` も Antigravity アカウントにリクエストをルーティングします。

> **⚠️ 警告**: Anthropic Claude と Antigravity Claude は**同じ会話コンテキスト内で混在させることはできません**。グループを使用して適切に分離してください。

### 既知の問題

Claude Code では、Plan Mode を自動的に終了できません。（通常、ネイティブの Claude API を使用する場合、計画が完了すると Claude Code はユーザーに計画を承認または拒否するオプションをポップアップ表示します。）

**回避策**: `Shift + Tab` を押して手動で Plan Mode を終了し、計画を承認または拒否するためのレスポンスを入力してください。

---

## プロジェクト構成

```
sub2api/
├── backend/                  # Go バックエンドサービス
│   ├── cmd/server/           # アプリケーションエントリ
│   ├── internal/             # 内部モジュール
│   │   ├── config/           # 設定
│   │   ├── model/            # データモデル
│   │   ├── service/          # ビジネスロジック
│   │   ├── handler/          # HTTP ハンドラー
│   │   └── gateway/          # API ゲートウェイコア
│   └── resources/            # 静的リソース
│
├── frontend/                 # Vue 3 フロントエンド
│   └── src/
│       ├── api/              # API 呼び出し
│       ├── stores/           # 状態管理
│       ├── views/            # ページコンポーネント
│       └── components/       # 再利用可能なコンポーネント
│
└── deploy/                   # デプロイファイル
    ├── appctl.sh             # 統一運用エントリ
    ├── docker-compose.local.yml
    ├── docker-compose.local-build.yml
    ├── LOCAL_BUILD_OPERATIONS.md
    ├── .env.example
    └── config.example.yaml
```

## 免責事項

> **本プロジェクトをご利用の前に、以下をよくお読みください:**
>
> :rotating_light: **利用規約違反のリスク**: 本プロジェクトの使用は Anthropic の利用規約に違反する可能性があります。使用前に Anthropic のユーザー契約をよくお読みください。本プロジェクトの使用に起因するすべてのリスクは、ユーザー自身が負うものとします。
>
> :book: **免責事項**: 本プロジェクトは技術的な学習および研究目的のみで提供されています。作者は、本プロジェクトの使用によるアカウント停止、サービス中断、その他の損失について一切の責任を負いません。

---

## スター履歴

<a href="https://star-history.com/#OsborneWang/subforai&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=OsborneWang/subforai&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=OsborneWang/subforai&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=OsborneWang/subforai&type=Date" />
 </picture>
</a>

---

## ライセンス

本プロジェクトは [GNU Lesser General Public License v3.0](LICENSE)（またはそれ以降のバージョン）の下でライセンスされています。

Copyright (c) 2026 Wesley Liddick

---

<div align="center">

**このプロジェクトが役に立ったら、ぜひスターをお願いします！**

</div>
