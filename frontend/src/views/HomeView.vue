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

  <div v-else class="landing-shell">
    <div class="landing-bg">
      <span class="bg-orb orb-a"></span>
      <span class="bg-orb orb-b"></span>
      <span class="bg-orb orb-c"></span>
    </div>

    <header class="landing-header">
      <nav class="header-actions">
        <a
          v-if="docUrl"
          :href="docUrl"
          target="_blank"
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
        <h1 class="brand-title">{{ heroTitle }}</h1>
        <p class="hero-subtitle">{{ heroSubtitle }}</p>
        <router-link :to="isAuthenticated ? dashboardPath : '/login'" class="hero-cta">
          {{ ctaText }}
        </router-link>
      </section>

      <section class="feature-grid">
        <article v-for="item in featureCards" :key="item.title" class="feature-card">
          <div class="feature-icon">
            <Icon :name="item.icon" size="md" />
          </div>
          <h3 class="feature-title">{{ item.title }}</h3>
          <p class="feature-desc">{{ item.desc }}</p>
        </article>
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

const { locale, t } = useI18n()

const authStore = useAuthStore()
const appStore = useAppStore()

const siteName = computed(() => appStore.cachedPublicSettings?.site_name || appStore.siteName || 'Right Code')
const docUrl = computed(() => appStore.cachedPublicSettings?.doc_url || appStore.docUrl || '')
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

const ctaText = computed(() => {
  if (isAuthenticated.value) {
    return isZh.value ? '进入控制台' : 'Open Dashboard'
  }
  return isZh.value ? '立即开始' : 'Get Started'
})

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
  margin: 18px auto 34px;
  color: var(--text-sub);
  font-size: clamp(1.25rem, 2.6vw, 2.9rem);
  font-weight: 600;
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
  .landing-shell {
    height: 100svh;
  }

  .landing-header {
    padding-top: 12px;
  }

  .landing-main {
    min-height: calc(100svh - 56px);
    display: flex;
    flex-direction: column;
    justify-content: center;
    gap: clamp(24px, 4vh, 48px);
    padding: clamp(20px, 3.8vh, 34px) 22px clamp(24px, 4.4vh, 42px);
  }

  .hero {
    margin: 0 auto;
  }

  .hero-subtitle {
    margin: 14px auto 26px;
  }

  .feature-grid {
    gap: 16px;
  }

  .feature-card {
    padding: 22px 22px 20px;
  }

  .feature-title {
    margin-bottom: 10px;
    font-size: 1.8rem;
  }

  .feature-desc {
    font-size: 0.97rem;
    line-height: 1.48;
  }
}

@media (max-height: 760px) and (min-width: 900px) {
  .landing-main {
    gap: 16px;
    padding: 14px 18px 18px;
  }

  .brand-title {
    font-size: clamp(2.15rem, 5vw, 3.7rem);
  }

  .hero-subtitle {
    margin-top: 8px;
    margin-bottom: 18px;
    font-size: clamp(1rem, 2vw, 1.6rem);
  }

  .hero-cta {
    padding: 9px 30px;
    border-radius: 18px;
    font-size: 0.92rem;
  }

  .feature-grid {
    gap: 12px;
  }

  .feature-card {
    padding: 16px 16px 14px;
  }

  .feature-title {
    margin-bottom: 6px;
    font-size: 1.52rem;
  }

  .feature-desc {
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
  .feature-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
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
    margin-bottom: 22px;
  }

  .hero-cta {
    width: min(100%, 280px);
    padding: 13px 22px;
  }

  .feature-grid {
    grid-template-columns: 1fr;
    gap: 14px;
  }

  .feature-card {
    padding: 22px 18px;
  }

  .feature-title {
    font-size: 1.65rem;
  }
}
</style>
