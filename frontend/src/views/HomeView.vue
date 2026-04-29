<template>
  <div v-if="homeContent" class="min-h-screen">
    <iframe
      v-if="isHomeContentUrl"
      :src="homeContent.trim()"
      class="h-screen w-full border-0"
      allowfullscreen
    ></iframe>
    <div v-else v-html="homeContent"></div>
  </div>

  <div v-else class="duomi-shell">
    <div class="duomi-bg" aria-hidden="true">
      <span class="bg-orb orb-one"></span>
      <span class="bg-orb orb-two"></span>
      <span class="bg-orb orb-three"></span>
      <span class="grid-mask"></span>
    </div>

    <header class="duomi-header">
      <a class="brand" href="#top" :aria-label="`${siteName} home`">
        <span class="brand-mark">{{ brandMark }}</span>
        <span class="brand-copy">
          <strong>{{ siteName }}</strong>
          <small>{{ heroEyebrow }}</small>
        </span>
      </a>

      <nav class="nav-links" :aria-label="isZh ? '页面导航' : 'Page navigation'">
        <a href="#overview">{{ isZh ? '能力' : 'Overview' }}</a>
        <a href="#guides">{{ isZh ? '教程' : 'Guides' }}</a>
        <a href="#access">{{ isZh ? '接入' : 'Access' }}</a>
      </nav>

      <div class="nav-actions">
        <a
          v-if="docsHref"
          :href="docsHref"
          :target="hasHelpDocs ? '_self' : '_blank'"
          rel="noopener noreferrer"
          class="ghost-link"
        >
          {{ isZh ? '帮助文档' : 'Docs' }}
        </a>
        <router-link
          v-if="isAuthenticated"
          :to="dashboardPath"
          class="primary-action"
        >
          {{ isZh ? '进入控制台' : 'Open Dashboard' }}
        </router-link>
        <router-link v-else to="/login" class="primary-action">
          {{ isZh ? '立即开始' : 'Get Started' }}
        </router-link>
      </div>
    </header>

    <main id="top" class="duomi-main">
      <section class="hero-section">
        <div class="hero-inner">
          <div class="hero-copy">
            <p class="eyebrow">
              <span class="status-dot"></span>
              {{ heroEyebrow }}
            </p>
            <h1>{{ siteName }}</h1>
            <p class="hero-subtitle">{{ heroSubtitle }}</p>
            <div class="hero-actions">
              <router-link
                :to="isAuthenticated ? dashboardPath : '/login'"
                class="primary-action large"
              >
                {{ primaryCtaText }}
              </router-link>
              <a
                v-if="docsHref"
                :href="docsHref"
                :target="hasHelpDocs ? '_self' : '_blank'"
                rel="noopener noreferrer"
                class="secondary-action large"
              >
                {{ isZh ? '帮助文档' : 'Help Docs' }}
              </a>
            </div>

            <div class="metrics-strip" :aria-label="isZh ? '核心指标' : 'Key metrics'">
              <div v-for="metric in metrics" :key="metric.label">
                <strong>{{ metric.value }}</strong>
                <span>{{ metric.label }}</span>
              </div>
            </div>
          </div>

          <div class="hero-visual" :aria-label="isZh ? '接入示意' : 'Connection preview'">
            <div class="command-card">
              <div class="command-top">
                <span></span>
                <span></span>
                <span></span>
                <strong>quick-start</strong>
              </div>

              <div class="endpoint-stack">
                <button
                  v-for="endpoint in endpointCards"
                  :key="endpoint.endpoint"
                  type="button"
                  class="endpoint-mini"
                  @click="copyEndpoint(endpoint.endpoint)"
                >
                  <span>{{ endpoint.name }}</span>
                  <code>{{ endpoint.endpoint }}</code>
                </button>
              </div>

              <div class="model-board">
                <span v-for="tool in toolBadges" :key="tool">{{ tool }}</span>
              </div>

              <pre><code>{{ sampleCommand }}</code></pre>
            </div>
          </div>
        </div>
      </section>

      <section id="overview" class="feature-section">
        <div class="section-inner">
          <div class="section-heading">
            <span>{{ isZh ? 'Unified Access' : 'Unified Access' }}</span>
            <h2>{{ isZh ? '一个入口，稳定承接高频 AI 调用' : 'One gateway built for stable, high-frequency AI access' }}</h2>
            <p>{{ isZh ? '我们把主流模型接入、稳定路由、透明用量和官方群支持集中到同一个平台，让个人开发与团队协作都能更快上线。' : 'Mainstream model access, resilient routing, transparent usage, and official support are brought into one platform so both solo builders and teams can ship faster.' }}</p>
          </div>

          <div class="feature-grid">
            <article
              v-for="feature in featureCards"
              :key="feature.title"
              class="feature-card"
            >
              <div class="mini-visual" :class="feature.visualClass" aria-hidden="true">
                <Icon :name="feature.icon" size="lg" />
                <template v-if="feature.visualClass === 'model-cloud'">
                  <span>Claude</span>
                  <span>GPT</span>
                  <span>Gemini</span>
                  <span>Codex</span>
                </template>
                <template v-else-if="feature.visualClass === 'route-visual'">
                  <i></i>
                  <i></i>
                  <i></i>
                </template>
                <template v-else-if="feature.visualClass === 'chart-visual'">
                  <span></span>
                  <span></span>
                  <span></span>
                </template>
                <template v-else>
                  <b>+</b>
                </template>
              </div>
              <h3>{{ feature.title }}</h3>
              <p>{{ feature.desc }}</p>
            </article>
          </div>
        </div>
      </section>

      <section id="guides" class="docs-preview-section">
        <div class="section-inner docs-preview">
          <div class="section-heading left">
            <span>{{ isZh ? 'Getting Started' : 'Getting Started' }}</span>
            <h2>{{ isZh ? '三步完成接入，快速开始调用' : 'Go live in three steps and start calling fast' }}</h2>
            <p>{{ isZh ? '默认端点可直接复制，文档集中说明注册、创建 API Key 与工具配置流程。新用户按步骤完成即可开始调用。' : 'Copy the default endpoint directly, then follow the docs for signup, API key creation, and tool configuration. New users can start calling by following the guided steps.' }}</p>
          </div>

          <div class="docs-preview-card">
            <div class="endpoint-grid">
              <button
                v-for="endpoint in endpointCards"
                :key="endpoint.endpoint"
                type="button"
                class="endpoint-card"
                @click="copyEndpoint(endpoint.endpoint)"
              >
                <span>{{ endpoint.name }}</span>
                <small>{{ endpoint.description || copyHint }}</small>
                <code>{{ endpoint.endpoint }}</code>
              </button>
            </div>

            <div class="quick-steps">
              <div v-for="step in quickSteps" :key="step.label">
                <strong>{{ step.index }}</strong>
                <span>{{ step.label }}</span>
              </div>
            </div>

            <a
              v-if="docsHref"
              class="primary-action large"
              :href="docsHref"
              :target="hasHelpDocs ? '_self' : '_blank'"
              rel="noopener noreferrer"
            >
              {{ isZh ? '打开帮助文档' : 'Open Help Docs' }}
            </a>
          </div>
        </div>
      </section>

      <section id="access" class="pricing-section">
        <div class="section-inner">
          <div class="section-heading">
            <span>{{ isZh ? 'Access Map' : 'Access Map' }}</span>
            <h2>{{ isZh ? '把目标站的“价目列”改造成更通用的接入总览' : 'A source-style column layout, adapted into a broader access overview' }}</h2>
            <p>{{ isZh ? '不伪造真实价格，改用工具、场景和协作方式来承接这一段的视觉结构。' : 'Instead of inventing prices, this section uses tools, scenarios, and collaboration paths to occupy the same visual role.' }}</p>
          </div>

          <div class="pricing-grid">
            <article
              v-for="column in accessColumns"
              :key="column.title"
              class="price-column"
            >
              <h3>{{ column.title }}</h3>
              <div v-for="row in column.rows" :key="row.label">
                <span>{{ row.label }}</span>
                <strong>{{ row.value }}</strong>
              </div>
            </article>
          </div>
        </div>
      </section>

      <section v-if="hasOfficialSection" id="official" class="official-section">
        <div class="section-inner">
          <div class="section-heading">
            <span>{{ isZh ? 'Official Channels' : 'Official Channels' }}</span>
            <h2>{{ isZh ? '官方群与服务支持入口，接入、购买、使用问题都能快速响应' : 'Official support channels for faster help with setup, purchase, and usage' }}</h2>
            <p>{{ isZh ? '我们集中提供官方群、店铺与联络方式，方便新用户快速咨询开通流程，也方便老用户获取更新通知与售后支持。' : 'Official groups, shop links, and contact paths are kept in one place so new users can onboard faster and existing users can get updates and after-sales support efficiently.' }}</p>
          </div>

          <div v-if="contactInfo" class="contact-banner">
            <div>
              <span class="section-label">{{ isZh ? 'Contact' : 'Contact' }}</span>
              <h3>{{ isZh ? '公开联络方式' : 'Public contact info' }}</h3>
              <p>{{ contactInfo }}</p>
            </div>
            <button
              v-if="primaryEndpoint"
              type="button"
              class="secondary-action"
              @click="copyEndpoint(primaryEndpoint)"
            >
              {{ isZh ? '复制默认端点' : 'Copy default endpoint' }}
            </button>
          </div>

          <div v-if="officialEntries.length" class="official-grid">
            <article
              v-for="entry in officialEntries"
              :key="entry.key"
              class="official-card"
            >
              <div class="official-copy">
                <div class="official-badge">
                  <Icon :name="entry.icon" size="sm" />
                  <span>{{ entry.badge }}</span>
                </div>
                <h3>{{ entry.title }}</h3>
                <p>{{ entry.description }}</p>
                <p v-if="entry.meta" class="official-meta">
                  <span>{{ isZh ? '附加信息' : 'Meta' }}</span>
                  <strong>{{ entry.meta }}</strong>
                </p>
                <a
                  v-if="entry.link"
                  :href="entry.link"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="secondary-action"
                >
                  {{ entry.actionLabel }}
                </a>
              </div>

              <div class="official-qr">
                <div v-if="entry.qrCode" class="official-qr-shell">
                  <img :src="entry.qrCode" :alt="entry.qrAlt" class="official-qr-image" />
                </div>
                <div v-else class="official-qr-shell official-qr-empty">
                  <Icon name="grid" size="lg" />
                  <span>{{ isZh ? '暂未配置二维码' : 'No QR configured' }}</span>
                </div>
              </div>
            </article>
          </div>

          <div v-if="helperLinks.length" class="helper-links">
            <a
              v-for="item in helperLinks"
              :key="item.id"
              :href="item.url"
              target="_blank"
              rel="noopener noreferrer"
              class="helper-link"
            >
              <span>{{ item.label }}</span>
              <Icon name="externalLink" size="sm" />
            </a>
          </div>
        </div>
      </section>
    </main>

    <a v-if="hasOfficialSection" href="#official" class="support-fab">
      {{ isZh ? '客服' : 'Support' }}
    </a>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useI18n } from 'vue-i18n'
import Icon from '@/components/icons/Icon.vue'
import { useClipboard } from '@/composables/useClipboard'
import { useAuthStore, useAppStore } from '@/stores'
import type { CustomEndpoint, CustomMenuItem } from '@/types'

type FeatureCard = {
  icon: 'brain' | 'swap' | 'chartBar' | 'users'
  title: string
  desc: string
  visualClass: 'model-cloud' | 'route-visual' | 'chart-visual' | 'shield-visual'
}

type AccessColumn = {
  title: string
  rows: Array<{
    label: string
    value: string
  }>
}

type OfficialEntry = {
  key: string
  icon: 'chatBubble' | 'link'
  badge: string
  title: string
  description: string
  meta?: string
  link?: string
  actionLabel: string
  qrCode?: string
  qrAlt: string
}

const { locale, t } = useI18n()
const { copyToClipboard } = useClipboard()

const authStore = useAuthStore()
const appStore = useAppStore()

const publicSettings = computed(() => appStore.cachedPublicSettings)
const siteName = computed(() => publicSettings.value?.site_name?.trim() || appStore.siteName || 'SubForAI')
const siteSubtitle = computed(() => {
  const configured = publicSettings.value?.site_subtitle?.trim()
  if (configured) return configured
  return isZh.value
    ? '统一 AI Gateway 与分发控制台'
    : 'Unified AI gateway and distribution console'
})
const docUrl = computed(() => publicSettings.value?.doc_url || appStore.docUrl || '')
const helpDocs = computed(() => publicSettings.value?.help_docs ?? [])
const hasHelpDocs = computed(() => helpDocs.value.length > 0)
const docsHref = computed(() => (hasHelpDocs.value ? '/help-docs' : docUrl.value))
const homeContent = computed(() => publicSettings.value?.home_content || '')
const contactInfo = computed(() => publicSettings.value?.contact_info?.trim() || '')
const homeBaseUrl = computed(() => publicSettings.value?.api_base_url?.trim() || '')

const isHomeContentUrl = computed(() => {
  const content = homeContent.value.trim()
  return content.startsWith('http://') || content.startsWith('https://')
})

const isZh = computed(() => locale.value.startsWith('zh'))
const isAuthenticated = computed(() => authStore.isAuthenticated)
const isAdmin = computed(() => authStore.isAdmin)
const dashboardPath = computed(() => (isAdmin.value ? '/admin/dashboard' : '/dashboard'))
const brandMark = computed(() => siteName.value.trim().slice(0, 2).toUpperCase())

const heroEyebrow = computed(() =>
  isZh.value
    ? 'Claude / GPT / Gemini / Codex · 一站式 API 中枢'
    : 'Claude / GPT / Gemini / Codex · One gateway surface'
)
const heroSubtitle = computed(() =>
  isZh.value
    ? siteSubtitle.value
    : siteSubtitle.value
)
  const primaryCtaText = computed(() => {
  if (isAuthenticated.value) {
    return isZh.value ? '进入控制台' : 'Open Dashboard'
  }
  return isZh.value ? '立即开始' : 'Get Started'
})
const copyHint = computed(() =>
  isZh.value ? '点击复制此端点' : 'Click to copy this endpoint'
)

const toolBadges = computed(() => ['Claude', 'GPT', 'Gemini', 'Codex'])

const fallbackOrigin = computed(() => {
  if (typeof window === 'undefined') return ''
  return window.location.origin
})

const endpointCards = computed<CustomEndpoint[]>(() => {
  const custom = (publicSettings.value?.custom_endpoints ?? [])
    .filter((item) => item.endpoint?.trim())
    .slice(0, 3)
    .map((item, index) => ({
      name: item.name?.trim() || (index === 0
        ? (isZh.value ? '默认端点' : 'Default endpoint')
        : `${isZh.value ? '端点' : 'Endpoint'} ${index + 1}`),
      endpoint: item.endpoint.trim(),
      description: item.description?.trim() || copyHint.value
    }))

  if (custom.length) return custom

  const fallbackEndpoint = homeBaseUrl.value || fallbackOrigin.value
  if (!fallbackEndpoint) return []

  return [
    {
      name: isZh.value ? '默认端点' : 'Default endpoint',
      endpoint: fallbackEndpoint,
      description: copyHint.value
    }
  ]
})

const primaryEndpoint = computed(() => endpointCards.value[0]?.endpoint || '')

const sampleCommand = computed(() => {
  const endpoint = primaryEndpoint.value || 'https://api.example.com'
  return [
    `export OPENAI_BASE_URL=${endpoint}`,
    'export OPENAI_API_KEY=sk-your-key',
    '',
    'codex "hello"',
  ].join('\n')
})

const metrics = computed(() => {
  if (isZh.value) {
    return [
      { value: `${endpointCards.value.length || 1}${isZh.value ? ' 个' : ''}`, label: '公开端点' },
      { value: officialEntries.value.length ? `${officialEntries.value.length}+` : '0', label: '官方群/店铺' }
    ]
  }

  return [
    { value: `${endpointCards.value.length || 1}+`, label: 'public endpoints' },
    { value: officialEntries.value.length ? `${officialEntries.value.length}+` : '0', label: 'official entries' }
  ]
})

  const featureCards = computed<FeatureCard[]>(() => {
  if (isZh.value) {
    return [
      {
        icon: 'brain',
        visualClass: 'model-cloud',
        title: '多模型统一接入',
        desc: '一个 API Key 即可直连 Claude、GPT、Gemini、Codex 等主流模型，减少多平台切换和重复配置成本。'
      },
      {
        icon: 'swap',
        visualClass: 'route-visual',
        title: '稳定路由与智能切换',
        desc: '通过统一网关承接请求，降低单点波动带来的影响，适合高频开发、持续调试和团队日常调用。'
      },
      {
        icon: 'chartBar',
        visualClass: 'chart-visual',
        title: '透明计费与用量可见',
        desc: '控制台内可直观看到端点、额度、Key 与使用路径，方便评估成本，也方便团队做统一管理。'
      },
      {
        icon: 'users',
        visualClass: 'shield-visual',
        title: '官方群支持与协作服务',
        desc: '提供官方群、店铺和联络入口，遇到接入、购买或使用问题时可以更快获得支持与反馈。'
      }
    ]
  }

  return [
    {
      icon: 'brain',
      visualClass: 'model-cloud',
      title: 'Unified model access',
      desc: 'One API key connects Claude, GPT, Gemini, Codex, and other mainstream model workflows without repeated setup.'
    },
    {
      icon: 'swap',
      visualClass: 'route-visual',
      title: 'Resilient routing and smart switching',
      desc: 'A unified gateway reduces single-path fragility and supports high-frequency development, testing, and team usage.'
    },
    {
      icon: 'chartBar',
      visualClass: 'chart-visual',
      title: 'Transparent billing and visible usage',
      desc: 'Endpoints, balances, keys, and usage paths stay easy to inspect so cost evaluation and team management remain straightforward.'
    },
    {
      icon: 'users',
      visualClass: 'shield-visual',
      title: 'Official support and collaboration paths',
      desc: 'Official groups, shop links, and contact channels make onboarding, purchasing, and troubleshooting faster.'
    }
  ]
})

const quickSteps = computed(() => {
  if (isZh.value) {
    return [
      { index: '1', label: '注册账号' },
      { index: '2', label: '创建 API Key' },
      { index: '3', label: '填入工具并测试' }
    ]
  }

  return [
    { index: '1', label: 'Create account' },
    { index: '2', label: 'Generate API key' },
    { index: '3', label: 'Drop it into your tool' }
  ]
})

const accessColumns = computed<AccessColumn[]>(() => {
  if (isZh.value) {
    return [
      {
        title: '接入工具',
        rows: [
          { label: 'Claude Code', value: '终端直接接入' },
          { label: 'Codex CLI', value: '统一 Base URL' },
          { label: 'Cursor / Cline', value: '图形化配置' }
        ]
      },
      {
        title: '适用场景',
        rows: [
          { label: '个人开发', value: '单人高频使用' },
          { label: '团队协作', value: '共享额度与控制台' },
          { label: '内部应用', value: '自建 AI 工作流' }
        ]
      }
    ]
  }

  return [
    {
      title: 'Tooling',
      rows: [
        { label: 'Claude Code', value: 'terminal-first setup' },
        { label: 'Codex CLI', value: 'shared base URL' },
        { label: 'Cursor / Cline', value: 'GUI configuration' }
      ]
    },
    {
      title: 'Scenarios',
      rows: [
        { label: 'Solo development', value: 'high-frequency usage' },
        { label: 'Team workflows', value: 'shared quotas and console' },
        { label: 'Internal apps', value: 'custom AI workflows' }
      ]
    }
  ]
})

const helperLinks = computed<CustomMenuItem[]>(() =>
  (publicSettings.value?.custom_menu_items ?? [])
    .filter((item) => item.visibility === 'user' && item.url?.trim())
    .sort((a, b) => a.sort_order - b.sort_order)
    .slice(0, 4)
)

const officialEntries = computed<OfficialEntry[]>(() => {
  const settings = publicSettings.value
  if (!settings) return []

  const entries: OfficialEntry[] = []
  const qqHasContent = Boolean(
    settings.qq_group_number?.trim() ||
      settings.qq_group_link?.trim() ||
      settings.qq_group_qr_code?.trim()
  )

  if (qqHasContent) {
    entries.push({
      key: 'qq',
      icon: 'chatBubble',
      badge: t('home.officialEntrances.qqGroup'),
      title: t('home.officialEntrances.qqGroup'),
      description: t('home.officialEntrances.qqGroupDesc'),
      meta: settings.qq_group_number?.trim() || '',
      link: settings.qq_group_link?.trim() || '',
      actionLabel: t('home.officialEntrances.qqGroupOpen'),
      qrCode: settings.qq_group_qr_code || '',
      qrAlt: `${t('home.officialEntrances.qqGroup')} QR`
    })
  }

  const xianyuHasContent = Boolean(
    settings.xianyu_shop_name?.trim() ||
      settings.xianyu_shop_link?.trim() ||
      settings.xianyu_shop_qr_code?.trim()
  )
  const shops = settings.xianyu_shops?.length
    ? settings.xianyu_shops
    : xianyuHasContent
      ? [{
          name: settings.xianyu_shop_name?.trim() || t('home.officialEntrances.xianyuShop'),
          description: '',
          url: settings.xianyu_shop_link?.trim() || '',
          qr_code: settings.xianyu_shop_qr_code || ''
        }]
      : []

  for (const [index, shop] of shops.entries()) {
    entries.push({
      key: `xianyu-${index}`,
      icon: 'link',
      badge: t('home.officialEntrances.xianyuShops'),
      title: shop.name?.trim() || t('home.officialEntrances.xianyuShop'),
      description: shop.description?.trim() || t('home.officialEntrances.xianyuShopDesc'),
      link: shop.url?.trim() || '',
      actionLabel: t('home.officialEntrances.xianyuShopOpen'),
      qrCode: shop.qr_code || '',
      qrAlt: `${t('home.officialEntrances.xianyuShop')} QR`
    })
  }

  return entries
})

const hasOfficialSection = computed(() =>
  Boolean(contactInfo.value || officialEntries.value.length || helperLinks.value.length)
)

const copyEndpoint = async (endpoint: string) => {
  await copyToClipboard(
    endpoint,
    isZh.value ? '端点已复制到剪贴板' : 'Endpoint copied to clipboard'
  )
}

onMounted(() => {
  authStore.checkAuth()
  if (!appStore.publicSettingsLoaded) {
    appStore.fetchPublicSettings()
  }
})
</script>

<style scoped>
.duomi-shell {
  --bg-base: #f4f0e8;
  --bg-soft: #f9f5ef;
  --bg-card: rgba(255, 252, 247, 0.72);
  --bg-card-strong: rgba(255, 252, 247, 0.86);
  --border-soft: rgba(148, 124, 98, 0.18);
  --text-main: #1f2430;
  --text-sub: #5f6676;
  --accent: #bc5f3a;
  --accent-strong: #8e4528;
  --accent-glow: rgba(188, 95, 58, 0.2);
  --shadow-soft: 0 24px 70px rgba(74, 52, 35, 0.08);
  --shadow-card: 0 18px 42px rgba(76, 58, 44, 0.1);

  position: relative;
  min-height: 100vh;
  overflow: hidden;
  color: var(--text-main);
  background:
    radial-gradient(circle at top left, rgba(244, 205, 167, 0.38), transparent 34%),
    radial-gradient(circle at top right, rgba(222, 198, 243, 0.24), transparent 28%),
    linear-gradient(180deg, var(--bg-base) 0%, #efe6da 45%, #f6f1e9 100%);
}

:global(.dark) .duomi-shell {
  --bg-base: #171a20;
  --bg-soft: #1d222c;
  --bg-card: rgba(26, 31, 39, 0.72);
  --bg-card-strong: rgba(26, 31, 39, 0.88);
  --border-soft: rgba(169, 176, 194, 0.16);
  --text-main: #f1f5fb;
  --text-sub: #b2bbca;
  --accent: #e0865f;
  --accent-strong: #f2b08e;
  --accent-glow: rgba(224, 134, 95, 0.18);
  --shadow-soft: 0 24px 70px rgba(0, 0, 0, 0.32);
  --shadow-card: 0 20px 48px rgba(0, 0, 0, 0.28);

  background:
    radial-gradient(circle at top left, rgba(186, 113, 74, 0.16), transparent 30%),
    radial-gradient(circle at top right, rgba(110, 121, 175, 0.16), transparent 24%),
    linear-gradient(180deg, #171a20 0%, #1b1f27 42%, #12161d 100%);
}

.duomi-bg {
  position: absolute;
  inset: 0;
  pointer-events: none;
}

.bg-orb {
  position: absolute;
  border-radius: 999px;
  filter: blur(90px);
  opacity: 0.65;
  animation: drift 14s ease-in-out infinite;
}

.orb-one {
  top: -8rem;
  left: -6rem;
  width: 28rem;
  height: 28rem;
  background: rgba(244, 183, 146, 0.55);
}

.orb-two {
  top: 5rem;
  right: 10%;
  width: 24rem;
  height: 24rem;
  background: rgba(203, 178, 240, 0.42);
  animation-delay: -4s;
}

.orb-three {
  top: 30rem;
  left: 12%;
  width: 22rem;
  height: 22rem;
  background: rgba(255, 225, 173, 0.34);
  animation-delay: -8s;
}

.grid-mask {
  position: absolute;
  inset: 0;
  background-image:
    linear-gradient(rgba(143, 118, 92, 0.05) 1px, transparent 1px),
    linear-gradient(90deg, rgba(143, 118, 92, 0.05) 1px, transparent 1px);
  background-size: 28px 28px;
  mask-image: linear-gradient(180deg, rgba(0, 0, 0, 0.32), transparent 78%);
}

.duomi-header,
.duomi-main {
  position: relative;
  z-index: 1;
}

.duomi-header {
  max-width: 1200px;
  margin: 0 auto;
  padding: 1.2rem 1.4rem 0;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1.25rem;
}

.brand {
  display: inline-flex;
  align-items: center;
  gap: 0.85rem;
  min-height: 44px;
  text-decoration: none;
  color: inherit;
}

.brand-mark {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 3rem;
  height: 3rem;
  border-radius: 1rem;
  border: 1px solid var(--border-soft);
  background: rgba(255, 255, 255, 0.46);
  box-shadow: var(--shadow-soft);
  font-size: 0.95rem;
  font-weight: 800;
  letter-spacing: 0.12em;
  color: var(--accent);
}

.brand-copy {
  display: flex;
  flex-direction: column;
}

.brand-copy strong {
  font-size: 1rem;
  line-height: 1.1;
}

.brand-copy small {
  color: var(--text-sub);
  font-size: 0.8rem;
}

.nav-links,
.nav-actions {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.nav-links a,
.ghost-link,
.primary-action,
.secondary-action,
.helper-link {
  min-height: 44px;
}

.nav-links a,
.ghost-link,
.secondary-action,
.helper-link {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.45rem;
  padding: 0 0.95rem;
  border-radius: 999px;
  color: var(--text-sub);
  text-decoration: none;
  font-weight: 600;
  border: 1px solid var(--border-soft);
  background: rgba(255, 255, 255, 0.4);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  transition: transform 180ms ease, border-color 180ms ease, color 180ms ease;
}

.primary-action,
.secondary-action {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0 1.1rem;
  border-radius: 999px;
  font-weight: 700;
  text-decoration: none;
  transition: transform 180ms ease, box-shadow 180ms ease, border-color 180ms ease;
}

.primary-action {
  color: #fff8f2;
  border: 1px solid rgba(188, 95, 58, 0.28);
  background: linear-gradient(180deg, var(--accent) 0%, var(--accent-strong) 100%);
  box-shadow:
    0 16px 34px var(--accent-glow),
    inset 0 1px 0 rgba(255, 255, 255, 0.18);
}

.secondary-action {
  color: var(--text-main);
  border: 1px solid var(--border-soft);
  background: rgba(255, 255, 255, 0.5);
}

.large {
  min-height: 52px;
  padding: 0 1.5rem;
  font-size: 0.98rem;
}

.nav-links a:hover,
.ghost-link:hover,
.secondary-action:hover,
.helper-link:hover,
.primary-action:hover {
  transform: translateY(-1px);
}

.duomi-main {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem 1.4rem 6rem;
}

.hero-section {
  padding: 2rem 0 2.4rem;
}

.hero-inner {
  display: grid;
  grid-template-columns: minmax(0, 1.1fr) minmax(360px, 0.9fr);
  gap: 2rem;
  align-items: center;
}

.hero-copy,
.command-card,
.feature-card,
.plan-card,
.docs-preview-card,
.price-column,
.official-card,
.contact-banner {
  border: 1px solid var(--border-soft);
  background: var(--bg-card);
  box-shadow: var(--shadow-card);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
}

.hero-copy {
  border-radius: 2rem;
  padding: 2.15rem;
}

.eyebrow {
  display: inline-flex;
  align-items: center;
  gap: 0.65rem;
  margin: 0 0 1rem;
  color: var(--accent);
  font-size: 0.84rem;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.status-dot {
  width: 0.6rem;
  height: 0.6rem;
  border-radius: 999px;
  background: linear-gradient(180deg, #4ade80 0%, #16a34a 100%);
  box-shadow: 0 0 0 0.35rem rgba(74, 222, 128, 0.14);
}

.hero-copy h1 {
  margin: 0;
  font-size: clamp(3rem, 7vw, 5.4rem);
  line-height: 0.96;
  font-weight: 800;
  letter-spacing: 0.04em;
  color: var(--accent);
  font-family:
    'Courier New',
    'Cascadia Mono',
    'JetBrains Mono',
    ui-monospace,
    monospace;
}

.hero-subtitle {
  margin: 1rem 0 1rem;
  font-size: clamp(1.2rem, 2.2vw, 2.4rem);
  line-height: 1.14;
  font-weight: 700;
}

.hero-description {
  margin: 0;
  max-width: 42rem;
  color: var(--text-sub);
  font-size: 1.02rem;
  line-height: 1.75;
}

.hero-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 0.85rem;
  margin-top: 1.6rem;
}

.metrics-strip {
  margin-top: 1.7rem;
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 0.75rem;
}

.metrics-strip div {
  padding: 1rem 1.1rem;
  border-radius: 1.25rem;
  border: 1px solid rgba(255, 255, 255, 0.42);
  background: var(--bg-card-strong);
}

.metrics-strip strong {
  display: block;
  font-size: 1.15rem;
}

.metrics-strip span {
  display: block;
  margin-top: 0.28rem;
  color: var(--text-sub);
  font-size: 0.92rem;
}

.hero-visual {
  display: flex;
  justify-content: center;
}

.command-card {
  width: min(100%, 31rem);
  border-radius: 2rem;
  padding: 1.35rem;
  background:
    linear-gradient(180deg, rgba(255, 255, 255, 0.72), rgba(255, 249, 242, 0.6)),
    var(--bg-card);
}

:global(.dark) .command-card {
  background:
    linear-gradient(180deg, rgba(32, 37, 46, 0.92), rgba(22, 27, 35, 0.8)),
    var(--bg-card);
}

.command-top {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--text-sub);
  font-size: 0.88rem;
  margin-bottom: 1rem;
}

.command-top span {
  width: 0.72rem;
  height: 0.72rem;
  border-radius: 999px;
  background: rgba(188, 95, 58, 0.22);
}

.command-top strong {
  margin-left: auto;
  color: var(--text-main);
}

.endpoint-stack,
.endpoint-grid {
  display: grid;
  gap: 0.8rem;
}

.endpoint-mini,
.endpoint-card {
  width: 100%;
  text-align: left;
  border: 1px solid var(--border-soft);
  background: rgba(255, 255, 255, 0.58);
  color: inherit;
  transition: transform 180ms ease, border-color 180ms ease;
}

:global(.dark) .endpoint-mini,
:global(.dark) .endpoint-card {
  background: rgba(255, 255, 255, 0.04);
}

.endpoint-mini {
  display: flex;
  flex-direction: column;
  gap: 0.2rem;
  min-height: 64px;
  padding: 0.85rem 0.95rem;
  border-radius: 1rem;
}

.endpoint-mini span,
.endpoint-card span {
  font-weight: 700;
}

.command-card .endpoint-mini code,
.endpoint-card code {
  color: var(--accent);
  font-size: 0.88rem;
  word-break: break-all;
}

.endpoint-mini:hover,
.endpoint-card:hover {
  transform: translateY(-2px);
  border-color: rgba(188, 95, 58, 0.28);
}

.model-board {
  display: flex;
  flex-wrap: wrap;
  gap: 0.55rem;
  margin: 1rem 0;
}

.model-board span {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 34px;
  padding: 0 0.8rem;
  border-radius: 999px;
  border: 1px solid rgba(188, 95, 58, 0.16);
  background: rgba(188, 95, 58, 0.08);
  color: var(--accent);
  font-weight: 700;
  font-size: 0.84rem;
}

.command-card pre {
  margin: 0;
  padding: 1rem 1.05rem;
  border-radius: 1.2rem;
  border: 1px solid rgba(255, 255, 255, 0.26);
  background: rgba(17, 20, 26, 0.92);
  overflow-x: auto;
}

.command-card code {
  font-family:
    'SFMono-Regular',
    'Cascadia Code',
    'JetBrains Mono',
    monospace;
  font-size: 0.86rem;
  line-height: 1.65;
  color: #f4f7fb;
}

.section-inner {
  padding: 1.5rem 0 0;
}

.section-heading {
  margin-bottom: 1.35rem;
}

.section-heading.left {
  margin-bottom: 0;
}

.section-heading span,
.section-label {
  display: inline-flex;
  align-items: center;
  min-height: 32px;
  padding: 0 0.72rem;
  border-radius: 999px;
  color: var(--accent);
  font-size: 0.76rem;
  font-weight: 800;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  background: rgba(188, 95, 58, 0.08);
}

.section-heading h2,
.contact-banner h3 {
  margin: 0.72rem 0 0.5rem;
  font-size: clamp(1.6rem, 3vw, 2.45rem);
  line-height: 1.08;
}

.section-heading p,
.contact-banner p,
.official-card p {
  margin: 0;
  max-width: 48rem;
  color: var(--text-sub);
  line-height: 1.72;
}

.feature-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  gap: 1rem;
}

.feature-card {
  border-radius: 1.6rem;
  padding: 1.35rem;
}

.feature-card h3 {
  margin: 1rem 0 0.55rem;
  font-size: 1.18rem;
  line-height: 1.18;
}

.mini-visual {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 104px;
  border-radius: 1.25rem;
  border: 1px solid rgba(255, 255, 255, 0.34);
  background: rgba(255, 255, 255, 0.48);
  color: var(--accent);
  overflow: hidden;
}

:global(.dark) .mini-visual {
  background: rgba(255, 255, 255, 0.04);
}

.model-cloud {
  flex-wrap: wrap;
  gap: 0.55rem;
  padding: 0.9rem;
}

.model-cloud svg {
  display: none;
}

.model-cloud span {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 30px;
  padding: 0 0.72rem;
  border-radius: 999px;
  border: 1px solid rgba(188, 95, 58, 0.18);
  background: rgba(188, 95, 58, 0.1);
  font-size: 0.8rem;
  font-weight: 700;
}

.route-visual {
  gap: 0.8rem;
}

.route-visual svg {
  display: none;
}

.route-visual i {
  width: 14px;
  height: 14px;
  border-radius: 999px;
  background: linear-gradient(180deg, var(--accent), var(--accent-strong));
  box-shadow:
    0 0 0 8px rgba(188, 95, 58, 0.08),
    32px 0 0 -2px rgba(188, 95, 58, 0.44),
    -32px 0 0 -2px rgba(188, 95, 58, 0.44);
}

.chart-visual {
  gap: 0.7rem;
  align-items: flex-end;
}

.chart-visual svg {
  display: none;
}

.chart-visual span {
  width: 18px;
  border-radius: 999px 999px 0 0;
  background: linear-gradient(180deg, var(--accent), rgba(188, 95, 58, 0.4));
}

.chart-visual span:nth-child(2) {
  height: 56px;
}

.chart-visual span:nth-child(3) {
  height: 76px;
}

.chart-visual span:nth-child(4) {
  height: 42px;
}

.shield-visual {
  flex-direction: column;
  gap: 0.5rem;
}

.shield-visual svg {
  display: none;
}

.shield-visual b {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 56px;
  height: 56px;
  border-radius: 18px;
  font-size: 1.5rem;
  font-weight: 800;
  color: #fff8f2;
  background: linear-gradient(180deg, var(--accent), var(--accent-strong));
}

.plans-section,
.docs-preview-section,
.pricing-section,
.official-section {
  padding-top: 1.8rem;
}

.welfare-banner,
.contact-banner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  padding: 1rem 1.2rem;
  border-radius: 1.3rem;
  border: 1px solid rgba(188, 95, 58, 0.15);
  background: rgba(188, 95, 58, 0.08);
  margin-bottom: 1rem;
}

.plan-grid,
.pricing-grid {
  display: grid;
  gap: 1rem;
}

.plan-grid {
  grid-template-columns: repeat(4, minmax(0, 1fr));
}

.plan-card {
  position: relative;
  border-radius: 1.65rem;
  padding: 1.2rem;
}

.plan-fav {
  background:
    linear-gradient(180deg, rgba(255, 238, 231, 0.94), rgba(255, 247, 242, 0.72)),
    var(--bg-card);
}

:global(.dark) .plan-fav {
  background:
    linear-gradient(180deg, rgba(66, 39, 29, 0.42), rgba(26, 31, 39, 0.88)),
    var(--bg-card);
}

.fav-tag {
  position: absolute;
  top: 0.9rem;
  right: 0.95rem;
  padding: 0.36rem 0.65rem;
  border-radius: 999px;
  background: rgba(188, 95, 58, 0.12);
  color: var(--accent);
  font-size: 0.72rem;
  font-weight: 800;
}

.plan-top {
  display: flex;
  flex-direction: column;
  gap: 0.72rem;
}

.tier {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: fit-content;
  min-height: 30px;
  padding: 0 0.72rem;
  border-radius: 999px;
  font-size: 0.78rem;
  font-weight: 800;
}

.tier-green {
  background: rgba(34, 197, 94, 0.12);
  color: #15803d;
}

.tier-blue {
  background: rgba(59, 130, 246, 0.12);
  color: #2563eb;
}

.tier-red {
  background: rgba(239, 68, 68, 0.12);
  color: #dc2626;
}

.tier-purple {
  background: rgba(168, 85, 247, 0.12);
  color: #9333ea;
}

.plan-top strong {
  font-size: 2rem;
  line-height: 1;
}

.plan-top small {
  margin-left: 0.22rem;
  font-size: 0.9rem;
  color: var(--text-sub);
}

.plan-card dl {
  margin: 1rem 0 1.2rem;
  display: grid;
  gap: 0.7rem;
}

.plan-card dl div,
.price-column div {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
}

.plan-card dt,
.price-column span {
  color: var(--text-sub);
}

.plan-card dd,
.price-column strong {
  margin: 0;
  text-align: right;
  font-weight: 700;
}

.plan-card a {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  min-height: 44px;
  border-radius: 999px;
  text-decoration: none;
  color: #fff8f2;
  background: linear-gradient(180deg, var(--accent), var(--accent-strong));
}

.docs-preview {
  display: grid;
  grid-template-columns: minmax(0, 0.9fr) minmax(0, 1.1fr);
  gap: 1rem;
  align-items: start;
}

.docs-preview-card {
  border-radius: 1.8rem;
  padding: 1.3rem;
}

.endpoint-card {
  display: flex;
  flex-direction: column;
  gap: 0.28rem;
  min-height: 92px;
  padding: 0.95rem 1rem;
  border-radius: 1.15rem;
}

.endpoint-card small {
  color: var(--text-sub);
}

.quick-steps {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 0.8rem;
  margin: 1rem 0 1.1rem;
}

.quick-steps div {
  display: flex;
  align-items: center;
  gap: 0.7rem;
  min-height: 72px;
  padding: 0.85rem 0.95rem;
  border-radius: 1.15rem;
  border: 1px solid var(--border-soft);
  background: rgba(255, 255, 255, 0.44);
}

:global(.dark) .quick-steps div {
  background: rgba(255, 255, 255, 0.04);
}

.quick-steps strong {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 2rem;
  height: 2rem;
  border-radius: 999px;
  color: #fff8f2;
  background: linear-gradient(180deg, var(--accent), var(--accent-strong));
}

.pricing-grid {
  grid-template-columns: repeat(2, minmax(0, 1fr));
}

.price-column {
  border-radius: 1.65rem;
  padding: 1.25rem;
}

.price-column h3 {
  margin: 0 0 1rem;
  font-size: 1.15rem;
}

.price-column div + div {
  margin-top: 0.8rem;
  padding-top: 0.8rem;
  border-top: 1px solid var(--border-soft);
}

.official-grid {
  display: grid;
  gap: 1rem;
}

.official-card {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 184px;
  gap: 1rem;
  border-radius: 1.75rem;
  padding: 1.25rem;
}

.official-copy {
  display: flex;
  flex-direction: column;
  gap: 0.8rem;
  align-items: flex-start;
}

.official-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.45rem;
  min-height: 32px;
  padding: 0 0.75rem;
  border-radius: 999px;
  color: var(--accent);
  background: rgba(188, 95, 58, 0.1);
  font-size: 0.8rem;
  font-weight: 800;
}

.official-copy h3 {
  margin: 0;
  font-size: 1.35rem;
}

.official-meta {
  display: inline-flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.official-meta strong {
  color: var(--text-main);
}

.official-qr {
  display: flex;
  align-items: center;
  justify-content: center;
}

.official-qr-shell {
  width: 184px;
  height: 184px;
  border-radius: 1.4rem;
  border: 1px solid rgba(255, 255, 255, 0.42);
  background: rgba(255, 255, 255, 0.62);
  display: flex;
  align-items: center;
  justify-content: center;
}

:global(.dark) .official-qr-shell {
  background: rgba(255, 255, 255, 0.04);
}

.official-qr-image {
  width: 150px;
  height: 150px;
  object-fit: contain;
  border-radius: 1.1rem;
}

.official-qr-empty {
  flex-direction: column;
  gap: 0.5rem;
  color: var(--text-sub);
  font-size: 0.9rem;
}

.helper-links {
  display: flex;
  flex-wrap: wrap;
  gap: 0.8rem;
  margin-top: 1rem;
}

.support-fab {
  position: fixed;
  right: 1.4rem;
  bottom: 1.4rem;
  z-index: 20;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 64px;
  min-height: 64px;
  padding: 0 1rem;
  border-radius: 999px;
  text-decoration: none;
  color: #fff8f2;
  font-weight: 800;
  background: linear-gradient(180deg, var(--accent), var(--accent-strong));
  box-shadow: 0 18px 40px var(--accent-glow);
}

@keyframes drift {
  0%,
  100% {
    transform: translate3d(0, 0, 0);
  }
  50% {
    transform: translate3d(10px, 16px, 0);
  }
}

@media (max-width: 1100px) {
  .hero-inner,
  .docs-preview,
  .feature-grid,
  .plan-grid,
  .pricing-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .feature-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .plan-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .hero-inner {
    align-items: stretch;
  }
}

@media (max-width: 860px) {
  .duomi-header {
    flex-wrap: wrap;
  }

  .nav-links {
    order: 3;
    width: 100%;
    justify-content: flex-start;
    flex-wrap: wrap;
  }

  .hero-inner,
  .docs-preview,
  .feature-grid,
  .plan-grid,
  .pricing-grid,
  .metrics-strip {
    grid-template-columns: 1fr;
  }

  .official-card {
    grid-template-columns: 1fr;
  }

  .quick-steps {
    grid-template-columns: 1fr;
  }

  .official-qr {
    justify-content: flex-start;
  }

  .contact-banner {
    flex-direction: column;
    align-items: flex-start;
  }
}

@media (max-width: 640px) {
  .duomi-header,
  .duomi-main {
    padding-left: 1rem;
    padding-right: 1rem;
  }

  .hero-copy,
  .command-card,
  .feature-card,
  .plan-card,
  .docs-preview-card,
  .price-column,
  .official-card {
    border-radius: 1.35rem;
  }

  .hero-copy {
    padding: 1.4rem;
  }

  .hero-copy h1 {
    font-size: clamp(2.3rem, 13vw, 3.4rem);
  }

  .hero-subtitle {
    font-size: 1.18rem;
  }

  .nav-actions {
    width: 100%;
    justify-content: space-between;
  }

  .nav-actions > * {
    flex: 1 1 auto;
  }

  .support-fab {
    right: 1rem;
    bottom: 1rem;
    min-width: 56px;
    min-height: 56px;
  }
}
</style>
