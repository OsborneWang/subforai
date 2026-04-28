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

  <div
    v-else
    class="landing-shell"
    :class="{ 'landing-shell--expanded': hasOfficialEntries }"
  >
    <div class="landing-bg">
      <span class="bg-orb orb-a"></span>
      <span class="bg-orb orb-b"></span>
      <span class="bg-orb orb-c"></span>
    </div>

    <header class="landing-header">
      <nav class="header-actions">
        <a
          v-if="docsHref"
          :href="docsHref"
          :target="hasHelpDocs ? '_self' : '_blank'"
          rel="noopener noreferrer"
          class="nav-btn nav-link"
        >
          <Icon name="book" size="sm" />
          <span>{{ t('home.docs') }}</span>
        </a>
        <router-link
          v-if="isAuthenticated"
          :to="dashboardPath"
          class="nav-btn nav-dashboard"
        >
          <span class="user-dot">{{ userInitial }}</span>
          <span>{{ t('home.dashboard') }}</span>
        </router-link>
        <router-link v-else to="/login" class="nav-btn nav-login">
          {{ t('home.login') }}
        </router-link>
      </nav>
    </header>

    <main class="landing-main">
      <section class="hero">
        <p class="hero-kicker">{{ isZh ? '企业级网关' : 'Enterprise Gateway' }}</p>
        <h1 class="brand-title">{{ heroTitle }}</h1>
        <p class="hero-subtitle">{{ heroSubtitle }}</p>
        <p class="hero-description">{{ heroDescription }}</p>
        <div class="hero-tags">
          <span v-for="tag in heroTags" :key="tag" class="hero-tag">{{ tag }}</span>
        </div>
        <router-link :to="isAuthenticated ? dashboardPath : '/login'" class="hero-cta">
          {{ ctaText }}
        </router-link>
      </section>

      <section class="feature-grid feature-grid--primary">
        <article v-for="item in primaryFeatureCards" :key="item.title" class="feature-card feature-card--primary">
          <div class="feature-icon">
            <Icon :name="item.icon" size="md" />
          </div>
          <h3 class="feature-title">{{ item.title }}</h3>
          <p class="feature-desc">{{ item.desc }}</p>
        </article>
      </section>

      <section class="feature-grid feature-grid--secondary">
        <article v-for="item in secondaryFeatureCards" :key="item.title" class="feature-card feature-card--secondary">
          <div class="feature-icon">
            <Icon :name="item.icon" size="md" />
          </div>
          <h3 class="feature-title">{{ item.title }}</h3>
          <p class="feature-desc">{{ item.desc }}</p>
        </article>
      </section>

      <section v-if="officialEntries.length" class="entrance-section">
        <div class="section-heading">
          <p class="section-kicker">{{ t('home.officialEntrances.title') }}</p>
          <h2 class="section-title">{{ t('home.officialEntrances.subtitle') }}</h2>
        </div>
        <div class="entrance-grid">
          <article
            v-for="entry in officialEntries"
            :key="entry.key"
            class="entrance-card"
          >
            <div class="entrance-copy">
              <div class="entrance-badge">
                <Icon :name="entry.icon" size="sm" />
                <span>{{ entry.badge }}</span>
              </div>
              <h3 class="entrance-title">{{ entry.title }}</h3>
              <p class="entrance-desc">{{ entry.description }}</p>
              <p v-if="entry.meta" class="entrance-meta">
                <span>{{ t('home.officialEntrances.qqGroupNumber') }}</span>
                <strong>{{ entry.meta }}</strong>
              </p>
              <a
                v-if="entry.link"
                :href="entry.link"
                target="_blank"
                rel="noopener noreferrer"
                class="entrance-action"
              >
                <span>{{ entry.actionLabel }}</span>
                <Icon name="externalLink" size="sm" />
              </a>
            </div>

            <div class="entrance-qr">
              <div v-if="entry.qrCode" class="entrance-qr-shell">
                <img :src="entry.qrCode" :alt="entry.qrAlt" class="entrance-qr-image" />
              </div>
              <div v-else class="entrance-qr-empty">
                <Icon name="grid" size="lg" />
                <span>{{ t('home.officialEntrances.missing') }}</span>
              </div>
              <p class="entrance-qr-caption">{{ t('home.officialEntrances.qrCaption') }}</p>
            </div>
          </article>
        </div>
      </section>
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAuthStore, useAppStore } from '@/stores'
import Icon from '@/components/icons/Icon.vue'

type FeatureCard = {
  icon: 'shield' | 'dollar' | 'calculator' | 'sparkles' | 'grid' | 'bolt'
  title: string
  desc: string
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

const authStore = useAuthStore()
const appStore = useAppStore()

const siteName = computed(() => appStore.cachedPublicSettings?.site_name || appStore.siteName || 'Right Code')
const docUrl = computed(() => appStore.cachedPublicSettings?.doc_url || appStore.docUrl || '')
const helpDocs = computed(() => appStore.cachedPublicSettings?.help_docs ?? [])
const hasHelpDocs = computed(() => helpDocs.value.length > 0)
const docsHref = computed(() => (hasHelpDocs.value ? '/help-docs' : docUrl.value))
const homeContent = computed(() => appStore.cachedPublicSettings?.home_content || '')
const heroTitle = computed(() => siteName.value.trim() || 'SubForAI')

const isHomeContentUrl = computed(() => {
  const content = homeContent.value.trim()
  return content.startsWith('http://') || content.startsWith('https://')
})

const isZh = computed(() => locale.value.startsWith('zh'))
const isAuthenticated = computed(() => authStore.isAuthenticated)
const isAdmin = computed(() => authStore.isAdmin)
const dashboardPath = computed(() => (isAdmin.value ? '/admin/dashboard' : '/dashboard'))
const userInitial = computed(() => {
  const email = authStore.user?.email || ''
  return email ? email.charAt(0).toUpperCase() : 'U'
})

const heroSubtitle = computed(() =>
  isZh.value ? '企业级 AI Agent 分发平台' : 'Enterprise AI Agent distribution platform'
)
const heroDescription = computed(() => t('home.heroDescription'))
const heroTags = computed(() => [
  t('home.tags.subscriptionToApi'),
  t('home.tags.stickySession'),
  t('home.tags.realtimeBilling')
])

const ctaText = computed(() => {
  if (isAuthenticated.value) {
    return isZh.value ? '进入控制台' : 'Open Dashboard'
  }
  return isZh.value ? '立即开始' : 'Get Started'
})

const officialEntries = computed<OfficialEntry[]>(() => {
  const settings = appStore.cachedPublicSettings
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

const hasOfficialEntries = computed(() => officialEntries.value.length > 0)

const featureCards = computed<FeatureCard[]>(() => {
  if (isZh.value) {
    return [
      {
        icon: 'shield',
        title: '稳定优先',
        desc: '独家网关，确保号池稳定，可用率达 99.5%'
      },
      {
        icon: 'dollar',
        title: '高性价比',
        desc: '可选按量/包月计费，使用成本仅官网十分之一'
      },
      {
        icon: 'calculator',
        title: '透明计费',
        desc: '实时监控用量，无任何隐藏扣费'
      },
      {
        icon: 'sparkles',
        title: '简单易用',
        desc: '一键创建 API Key，快速接入各大模型服务'
      },
      {
        icon: 'grid',
        title: '多种渠道',
        desc: 'Codex、Claude Max、Droid 等号池多渠道聚合'
      },
      {
        icon: 'bolt',
        title: '专业客服',
        desc: '专业客服团队，极速响应，解决你的任何疑问'
      }
    ]
  }

  return [
    {
      icon: 'shield',
      title: 'Stability First',
      desc: 'Exclusive gateway routing with a 99.5% service availability target.'
    },
    {
      icon: 'dollar',
      title: 'Cost Efficient',
      desc: 'Usage-based and monthly plans with significantly lower model access cost.'
    },
    {
      icon: 'calculator',
      title: 'Transparent Billing',
      desc: 'Real-time usage tracking with clear pricing and no hidden deductions.'
    },
    {
      icon: 'sparkles',
      title: 'Easy to Launch',
      desc: 'Create API keys in one click and integrate mainstream models in minutes.'
    },
    {
      icon: 'grid',
      title: 'Multi-Channel',
      desc: 'Aggregate Codex, Claude Max, Droid, and more channels in one panel.'
    },
    {
      icon: 'bolt',
      title: 'Expert Support',
      desc: 'Fast-response support team ready to resolve integration and billing issues.'
    }
  ]
})

const primaryFeatureCards = computed(() => featureCards.value.slice(0, 3))
const secondaryFeatureCards = computed(() => featureCards.value.slice(3))

onMounted(() => {
  authStore.checkAuth()
  if (!appStore.publicSettingsLoaded) {
    appStore.fetchPublicSettings()
  }
})
</script>

<style scoped>
.landing-shell {
  --bg-a: #f4c9bf;
  --bg-b: #f2c2cf;
  --bg-c: #c2d3f4;
  --text-main: #1d2430;
  --text-sub: #4a5260;
  --card-bg: rgba(255, 255, 255, 0.66);
  --card-border: rgba(236, 236, 239, 0.9);
  --accent: #c7643f;
  --accent-strong: #b45433;

  position: relative;
  min-height: 100vh;
  overflow: hidden;
  color: var(--text-main);
  background: linear-gradient(135deg, #f2d3cc 0%, #f2d9cf 34%, #d7dff5 100%);
}

:global(.dark) .landing-shell {
  --bg-a: #3c2f3a;
  --bg-b: #382d42;
  --bg-c: #2a3350;
  --text-main: #edf2fb;
  --text-sub: #c8d0dc;
  --card-bg: rgba(28, 32, 41, 0.68);
  --card-border: rgba(92, 102, 120, 0.4);
  --accent: #d37d53;
  --accent-strong: #e08b60;
  background: linear-gradient(135deg, #2a2f42 0%, #31263d 40%, #22314a 100%);
}

.landing-bg {
  position: absolute;
  inset: 0;
  pointer-events: none;
}

.bg-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(90px);
  opacity: 0.8;
  animation: drift 12s ease-in-out infinite;
}

.orb-a {
  top: -120px;
  left: -130px;
  width: 440px;
  height: 440px;
  background: var(--bg-a);
}

.orb-b {
  top: 80px;
  left: 35%;
  width: 460px;
  height: 460px;
  background: var(--bg-b);
  animation-delay: -3s;
}

.orb-c {
  top: -60px;
  right: -120px;
  width: 530px;
  height: 530px;
  background: var(--bg-c);
  animation-delay: -6s;
}

.landing-main {
  position: relative;
  z-index: 10;
  max-width: 1120px;
  margin: 0 auto;
  padding: 56px 24px 100px;
}

.landing-header {
  position: relative;
  z-index: 12;
  max-width: 1120px;
  margin: 0 auto;
  padding: 18px 24px 0;
  display: flex;
  justify-content: flex-end;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.nav-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  height: 38px;
  border-radius: 999px;
  text-decoration: none;
  font-weight: 700;
  font-size: 14px;
  line-height: 1;
  transition: 180ms ease;
}

.nav-link {
  padding: 0 13px;
  color: #4b5666;
  border: 1px solid rgba(255, 255, 255, 0.52);
  background: rgba(255, 255, 255, 0.42);
}

.nav-login,
.nav-dashboard {
  padding: 0 15px;
  color: #fff8f0;
  border: 1px solid rgba(177, 91, 58, 0.3);
  background: linear-gradient(180deg, var(--accent) 0%, var(--accent-strong) 100%);
  box-shadow:
    0 10px 25px rgba(181, 92, 58, 0.28),
    inset 0 1px 0 rgba(255, 255, 255, 0.2);
}

.nav-btn:hover {
  transform: translateY(-1px);
}

.user-dot {
  width: 20px;
  height: 20px;
  border-radius: 999px;
  font-size: 11px;
  font-weight: 800;
  color: #f36d43;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: #fff3ec;
}

:global(.dark) .nav-link {
  color: #dde6f4;
  border-color: rgba(151, 161, 183, 0.34);
  background: rgba(19, 23, 31, 0.52);
}

:global(.dark) .nav-login,
:global(.dark) .nav-dashboard {
  border-color: rgba(224, 139, 96, 0.42);
}

.hero {
  text-align: center;
  margin: 0 auto 76px;
  max-width: 860px;
  animation: fade-up 0.7s ease both;
}

.hero-kicker {
  margin: 0 0 14px;
  color: var(--accent);
  font-size: 0.84rem;
  font-weight: 800;
  letter-spacing: 0.24em;
  text-transform: uppercase;
}

.brand-title {
  margin: 0;
  font-size: clamp(2.7rem, 8vw, 5rem);
  line-height: 1;
  letter-spacing: 0.05em;
  font-weight: 800;
  color: var(--accent);
  font-family:
    'Courier New',
    'Cascadia Mono',
    'JetBrains Mono',
    ui-monospace,
    monospace;
  text-shadow:
    -1px -1px 0 rgba(0, 0, 0, 0.03),
    1px -1px 0 rgba(0, 0, 0, 0.03),
    -1px 1px 0 rgba(0, 0, 0, 0.03),
    1px 1px 0 rgba(0, 0, 0, 0.03);
}

.hero-subtitle {
  margin: 18px auto 18px;
  color: var(--text-sub);
  font-size: clamp(1.25rem, 2.6vw, 2.9rem);
  font-weight: 600;
}

.hero-description {
  margin: 0 auto 24px;
  max-width: 680px;
  color: var(--text-sub);
  font-size: clamp(1rem, 1.5vw, 1.18rem);
  line-height: 1.7;
}

.hero-tags {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 10px;
  margin-bottom: 28px;
}

.hero-tag {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 34px;
  padding: 0 14px;
  border-radius: 999px;
  border: 1px solid rgba(255, 255, 255, 0.52);
  background: rgba(255, 255, 255, 0.42);
  color: #556071;
  font-size: 0.88rem;
  font-weight: 700;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
}

:global(.dark) .hero-tag {
  color: #dde6f4;
  border-color: rgba(151, 161, 183, 0.3);
  background: rgba(19, 23, 31, 0.42);
}

.hero-cta {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 14px 56px;
  border-radius: 22px;
  border: 0;
  color: #fff8f0;
  font-size: 1.05rem;
  font-weight: 700;
  text-decoration: none;
  background: linear-gradient(180deg, var(--accent) 0%, var(--accent-strong) 100%);
  box-shadow:
    0 16px 36px rgba(181, 92, 58, 0.33),
    inset 0 1px 0 rgba(255, 255, 255, 0.25);
  transition: transform 180ms ease, box-shadow 180ms ease;
}

.hero-cta:hover {
  transform: translateY(-2px);
  box-shadow:
    0 18px 34px rgba(181, 92, 58, 0.38),
    inset 0 1px 0 rgba(255, 255, 255, 0.3);
}

.feature-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 18px;
  animation: fade-up 0.75s ease 0.08s both;
}

.feature-grid--primary {
  margin-bottom: 18px;
}

.feature-grid--secondary {
  margin-bottom: 44px;
}

.entrance-section {
  margin: 0 auto 20px;
  padding-top: 6px;
  animation: fade-up 0.82s ease 0.12s both;
}

.section-heading {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-bottom: 18px;
}

.section-kicker {
  margin: 0;
  color: var(--accent);
  font-size: 0.74rem;
  font-weight: 800;
  letter-spacing: 0.16em;
  text-transform: uppercase;
}

.section-title {
  margin: 0;
  max-width: 760px;
  font-size: clamp(1.1rem, 1.8vw, 1.45rem);
  line-height: 1.1;
  font-weight: 700;
}

.entrance-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 18px;
}

.entrance-card {
  display: grid;
  grid-template-columns: minmax(0, 1fr) 156px;
  gap: 20px;
  align-items: center;
  padding: 20px;
  border: 1px solid var(--card-border);
  border-radius: 22px;
  background:
    linear-gradient(145deg, rgba(255, 255, 255, 0.74), rgba(255, 255, 255, 0.5)),
    var(--card-bg);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
  box-shadow: 0 12px 26px rgba(89, 96, 125, 0.12);
}

.entrance-copy {
  display: flex;
  flex-direction: column;
  gap: 12px;
  align-items: flex-start;
}

.entrance-badge {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 7px 10px;
  border-radius: 999px;
  color: var(--accent);
  background: rgba(199, 100, 63, 0.1);
  font-size: 0.78rem;
  font-weight: 700;
}

.entrance-title {
  margin: 0;
  font-size: 1.35rem;
  line-height: 1.05;
  font-weight: 800;
}

.entrance-desc {
  margin: 0;
  color: var(--text-sub);
  line-height: 1.6;
}

.entrance-meta {
  margin: 0;
  display: inline-flex;
  flex-wrap: wrap;
  gap: 8px;
  font-size: 0.92rem;
  color: var(--text-sub);
}

.entrance-meta strong {
  color: var(--text-main);
}

.entrance-action {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 11px 15px;
  border-radius: 16px;
  text-decoration: none;
  font-weight: 700;
  color: #fff8f0;
  background: linear-gradient(180deg, var(--accent) 0%, var(--accent-strong) 100%);
  box-shadow: 0 10px 20px rgba(181, 92, 58, 0.2);
}

.entrance-qr {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
}

.entrance-qr-shell,
.entrance-qr-empty {
  width: 156px;
  height: 156px;
  border-radius: 22px;
  border: 1px solid rgba(255, 255, 255, 0.6);
  background: rgba(255, 255, 255, 0.78);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.55);
}

.entrance-qr-image {
  width: 132px;
  height: 132px;
  object-fit: contain;
  border-radius: 18px;
}

.entrance-qr-empty {
  flex-direction: column;
  gap: 8px;
  color: var(--text-sub);
  font-size: 0.85rem;
}

.entrance-qr-caption {
  margin: 0;
  font-size: 0.8rem;
  color: var(--text-sub);
}

.feature-card {
  border-radius: 20px;
  border: 1px solid var(--card-border);
  background: var(--card-bg);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
  padding: 26px 26px 24px;
  box-shadow: 0 18px 44px rgba(89, 96, 125, 0.13);
  transition: transform 180ms ease, box-shadow 180ms ease;
}

.feature-card--primary {
  padding-top: 30px;
}

.feature-card--secondary {
  background: rgba(255, 255, 255, 0.52);
}

.feature-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 24px 42px rgba(89, 96, 125, 0.18);
}

.feature-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 12px;
  color: #6e7482;
  background: rgba(255, 255, 255, 0.6);
  margin-bottom: 12px;
}

:global(.dark) .feature-icon {
  color: #d0d6e1;
  background: rgba(255, 255, 255, 0.08);
}

.feature-title {
  margin: 0 0 10px;
  font-size: 2rem;
  line-height: 1.05;
  letter-spacing: 0.01em;
  font-weight: 800;
}

.feature-desc {
  margin: 0;
  color: var(--text-sub);
  font-size: 1rem;
  line-height: 1.55;
}

/* Laptop-fit mode: reduce scroll while keeping vertical balance */
@media (max-height: 920px) and (min-width: 900px) {
  .landing-shell:not(.landing-shell--expanded) {
    height: 100svh;
  }

  .landing-shell:not(.landing-shell--expanded) .landing-header {
    padding-top: 12px;
  }

  .landing-shell:not(.landing-shell--expanded) .landing-main {
    min-height: calc(100svh - 56px);
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: clamp(24px, 4vh, 48px);
    padding: clamp(20px, 3.8vh, 34px) 22px clamp(24px, 4.4vh, 42px);
  }

  .landing-shell:not(.landing-shell--expanded) .hero {
    margin: 0 auto;
  }

  .landing-shell:not(.landing-shell--expanded) .hero-subtitle {
    margin: 14px auto 26px;
  }

  .landing-shell:not(.landing-shell--expanded) .hero-description {
    margin-bottom: 18px;
  }

  .landing-shell:not(.landing-shell--expanded) .hero-tags {
    margin-bottom: 22px;
  }

  .landing-shell:not(.landing-shell--expanded) .feature-grid {
    gap: 16px;
  }

  .landing-shell:not(.landing-shell--expanded) .feature-card {
    padding: 22px 22px 20px;
  }

  .landing-shell:not(.landing-shell--expanded) .feature-title {
    margin-bottom: 10px;
    font-size: 1.8rem;
  }

  .landing-shell:not(.landing-shell--expanded) .feature-desc {
    font-size: 0.97rem;
    line-height: 1.48;
  }
}

@media (max-height: 760px) and (min-width: 900px) {
  .landing-shell:not(.landing-shell--expanded) .landing-main {
    gap: 16px;
    padding: 14px 18px 18px;
  }

  .landing-shell:not(.landing-shell--expanded) .brand-title {
    font-size: clamp(2.15rem, 5vw, 3.7rem);
  }

  .landing-shell:not(.landing-shell--expanded) .hero-subtitle {
    margin-top: 8px;
    margin-bottom: 18px;
    font-size: clamp(1rem, 2vw, 1.6rem);
  }

  .landing-shell:not(.landing-shell--expanded) .hero-description {
    margin-bottom: 16px;
    font-size: 0.96rem;
    line-height: 1.55;
  }

  .landing-shell:not(.landing-shell--expanded) .hero-tags {
    margin-bottom: 18px;
    gap: 8px;
  }

  .landing-shell:not(.landing-shell--expanded) .hero-tag {
    min-height: 30px;
    padding: 0 12px;
    font-size: 0.8rem;
  }

  .landing-shell:not(.landing-shell--expanded) .hero-cta {
    padding: 9px 30px;
    border-radius: 18px;
    font-size: 0.92rem;
  }

  .landing-shell:not(.landing-shell--expanded) .feature-grid {
    gap: 12px;
  }

  .landing-shell:not(.landing-shell--expanded) .feature-card {
    padding: 16px 16px 14px;
  }

  .landing-shell:not(.landing-shell--expanded) .feature-title {
    margin-bottom: 6px;
    font-size: 1.52rem;
  }

  .landing-shell:not(.landing-shell--expanded) .feature-desc {
    font-size: 0.9rem;
    line-height: 1.38;
  }
}

@keyframes drift {
  0%,
  100% {
    transform: translate3d(0, 0, 0) scale(1);
  }
  50% {
    transform: translate3d(10px, -18px, 0) scale(1.03);
  }
}

@keyframes fade-up {
  from {
    opacity: 0;
    transform: translateY(14px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (max-width: 1100px) {
  .landing-main {
    max-width: 930px;
  }

  .feature-title {
    font-size: 1.8rem;
  }
}

@media (max-width: 920px) {
  .entrance-grid {
    grid-template-columns: 1fr;
  }

  .feature-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .feature-grid--secondary {
    margin-bottom: 34px;
  }
}

@media (max-width: 640px) {
  .landing-header {
    padding: 12px 12px 0;
  }

  .header-actions {
    gap: 8px;
  }

  .nav-btn {
    height: 34px;
    font-size: 12px;
  }

  .nav-link {
    padding: 0 10px;
  }

  .nav-link span {
    display: none;
  }

  .nav-login,
  .nav-dashboard {
    padding: 0 12px;
  }

  .landing-main {
    padding: 40px 14px 86px;
  }

  .hero {
    margin-bottom: 34px;
  }

  .hero-subtitle {
    font-size: 1.8rem;
    margin-bottom: 14px;
  }

  .hero-description {
    margin-bottom: 18px;
    font-size: 0.98rem;
    line-height: 1.62;
  }

  .hero-tags {
    gap: 8px;
    margin-bottom: 20px;
  }

  .hero-tag {
    min-height: 30px;
    padding: 0 12px;
    font-size: 0.78rem;
  }

  .hero-cta {
    width: min(100%, 280px);
    padding: 13px 22px;
  }

  .entrance-section {
    margin-bottom: 18px;
  }

  .entrance-card {
    grid-template-columns: 1fr;
    gap: 16px;
    padding: 18px;
  }

  .entrance-copy {
    gap: 10px;
  }

  .entrance-title {
    font-size: 1.35rem;
  }

  .entrance-action {
    width: 100%;
    justify-content: center;
  }

  .entrance-qr-shell,
  .entrance-qr-empty {
    width: min(100%, 180px);
    height: min(calc(100vw - 120px), 180px);
  }

  .feature-grid {
    grid-template-columns: 1fr;
    gap: 14px;
  }

  .feature-grid--secondary {
    margin-bottom: 28px;
  }

  .feature-card {
    padding: 22px 18px;
  }

  .feature-title {
    font-size: 1.65rem;
  }
}
</style>
