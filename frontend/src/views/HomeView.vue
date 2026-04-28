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
    class="relative flex min-h-screen flex-col overflow-hidden bg-gradient-to-br from-gray-50 via-primary-50/30 to-gray-100 dark:from-dark-950 dark:via-dark-900 dark:to-dark-950"
  >
    <div class="pointer-events-none absolute inset-0 overflow-hidden">
      <div class="absolute -right-40 -top-40 h-96 w-96 rounded-full bg-primary-400/20 blur-3xl"></div>
      <div class="absolute -bottom-40 -left-40 h-96 w-96 rounded-full bg-primary-500/15 blur-3xl"></div>
      <div class="absolute left-1/3 top-1/4 h-72 w-72 rounded-full bg-primary-300/10 blur-3xl"></div>
      <div class="absolute bottom-1/4 right-1/4 h-64 w-64 rounded-full bg-primary-400/10 blur-3xl"></div>
      <div class="absolute inset-0 bg-[linear-gradient(rgba(20,184,166,0.03)_1px,transparent_1px),linear-gradient(90deg,rgba(20,184,166,0.03)_1px,transparent_1px)] bg-[size:64px_64px]"></div>
    </div>

    <header class="relative z-20 px-6 py-4">
      <nav class="mx-auto flex max-w-6xl items-center justify-between">
        <router-link :to="homePath" class="flex min-w-0 items-center gap-3">
          <div class="h-10 w-10 overflow-hidden rounded-xl shadow-md">
            <img :src="siteLogo || '/logo.png'" alt="Logo" class="h-full w-full object-contain" />
          </div>
          <span class="truncate text-lg font-semibold tracking-tight text-gray-900 dark:text-white">{{ siteName }}</span>
        </router-link>

        <div class="flex items-center gap-3">
          <LocaleSwitcher />
          <a
            v-if="docsHref"
            :href="docsHref"
            :target="hasHelpDocs ? '_self' : '_blank'"
            rel="noopener noreferrer"
            class="rounded-lg p-2 text-gray-500 transition-colors hover:bg-gray-100 hover:text-gray-700 dark:text-dark-400 dark:hover:bg-dark-800 dark:hover:text-white"
            :title="t('home.viewDocs')"
          >
            <Icon name="book" size="md" />
          </a>
          <button
            type="button"
            class="rounded-lg p-2 text-gray-500 transition-colors hover:bg-gray-100 hover:text-gray-700 dark:text-dark-400 dark:hover:bg-dark-800 dark:hover:text-white"
            :title="isDark ? t('home.switchToLight') : t('home.switchToDark')"
            @click="toggleTheme"
          >
            <Icon v-if="isDark" name="sun" size="md" />
            <Icon v-else name="moon" size="md" />
          </button>
          <router-link
            v-if="isAuthenticated"
            :to="dashboardPath"
            class="inline-flex items-center gap-1.5 rounded-full bg-gray-900 py-1 pl-1 pr-2.5 transition-colors hover:bg-gray-800 dark:bg-dark-800 dark:hover:bg-dark-700"
          >
            <span class="flex h-5 w-5 items-center justify-center rounded-full bg-gradient-to-br from-primary-400 to-primary-600 text-[10px] font-semibold text-white">
              {{ userInitial }}
            </span>
            <span class="text-xs font-medium text-white">{{ t('home.dashboard') }}</span>
            <svg class="h-3 w-3 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 19.5l15-15m0 0H8.25m11.25 0v11.25" />
            </svg>
          </router-link>
          <router-link
            v-else
            to="/login"
            class="inline-flex items-center rounded-full bg-gray-900 px-3 py-1 text-xs font-medium text-white transition-colors hover:bg-gray-800 dark:bg-dark-800 dark:hover:bg-dark-700"
          >
            {{ t('home.login') }}
          </router-link>
        </div>
      </nav>
    </header>

    <main class="relative z-10 flex-1 px-6 py-16">
      <div class="mx-auto max-w-6xl">
        <section class="mb-12 flex flex-col items-center justify-between gap-12 lg:flex-row lg:gap-16">
          <div class="flex-1 text-center lg:text-left">
            <p class="mb-4 text-sm font-semibold uppercase tracking-[0.24em] text-primary-600 dark:text-primary-400">
              {{ heroEyebrow }}
            </p>
            <h1 class="mb-4 text-4xl font-bold tracking-tight text-gray-900 dark:text-white md:text-5xl lg:text-6xl">
              {{ siteName }}
            </h1>
            <p class="mb-4 text-2xl font-semibold text-gray-800 dark:text-gray-100 md:text-3xl">
              {{ heroSubtitle }}
            </p>
            <p class="mb-8 max-w-2xl text-lg leading-relaxed text-gray-600 dark:text-dark-300 md:text-xl lg:mx-0 lg:max-w-xl">
              {{ heroDescription }}
            </p>
            <router-link
              :to="isAuthenticated ? dashboardPath : '/login'"
              class="btn btn-primary px-8 py-3 text-base shadow-lg shadow-primary-500/30"
            >
              {{ ctaText }}
            </router-link>
          </div>

          <div class="flex flex-1 justify-center lg:justify-end">
            <div class="terminal-container">
              <div class="terminal-window">
                <div class="terminal-header">
                  <div class="terminal-buttons">
                    <span class="btn-close"></span>
                    <span class="btn-minimize"></span>
                    <span class="btn-maximize"></span>
                  </div>
                  <span class="terminal-title">terminal</span>
                </div>
                <div class="terminal-body">
                  <div v-for="line in terminalLines" :key="line.text" class="code-line" :class="line.className">
                    <template v-if="line.type === 'command'">
                      <span class="code-prompt">$</span>
                      <span class="code-cmd">{{ line.text }}</span>
                    </template>
                    <template v-else-if="line.type === 'comment'">
                      <span class="code-comment">{{ line.text }}</span>
                    </template>
                    <template v-else>
                      <span class="code-success">{{ line.prefix }}</span>
                      <span class="code-response">{{ line.text }}</span>
                    </template>
                  </div>
                  <div class="code-line line-4">
                    <span class="code-prompt">$</span>
                    <span class="cursor"></span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        <section class="mb-12 flex flex-wrap items-center justify-center gap-4 md:gap-6">
          <div
            v-for="tag in heroTags"
            :key="tag.label"
            class="inline-flex items-center gap-2.5 rounded-full border border-gray-200/50 bg-white/80 px-5 py-2.5 shadow-sm backdrop-blur-sm dark:border-dark-700/50 dark:bg-dark-800/80"
          >
            <Icon :name="tag.icon" size="sm" class="text-primary-500" />
            <span class="text-sm font-medium text-gray-700 dark:text-dark-200">{{ tag.label }}</span>
          </div>
        </section>

        <section class="mb-8 grid gap-6 md:grid-cols-3">
          <article
            v-for="(feature, index) in featureCards"
            :key="feature.title"
            class="group rounded-2xl border border-gray-200/50 bg-white/60 p-6 backdrop-blur-sm transition-all duration-300 hover:-translate-y-1 hover:shadow-xl hover:shadow-primary-500/10 dark:border-dark-700/50 dark:bg-dark-800/60"
          >
            <div
              class="mb-4 flex h-12 w-12 items-center justify-center rounded-xl shadow-lg transition-transform group-hover:scale-110"
              :class="featureIconClass(index)"
            >
              <Icon :name="feature.icon" size="lg" class="text-white" />
            </div>
            <h3 class="mb-2 text-lg font-semibold text-gray-900 dark:text-white">{{ feature.title }}</h3>
            <p class="text-sm leading-relaxed text-gray-600 dark:text-dark-400">{{ feature.desc }}</p>
          </article>
        </section>

        <section class="mb-16 text-center">
          <div class="mb-3 text-2xl font-bold text-gray-900 dark:text-white">
            {{ t('home.providers.title') }}
          </div>
          <p class="text-sm text-gray-600 dark:text-dark-400">
            {{ t('home.providers.description') }}
          </p>
          <div class="mt-6 flex flex-wrap items-center justify-center gap-4">
            <div
              v-for="provider in providers"
              :key="provider.name"
              class="flex items-center gap-2 rounded-xl px-5 py-3 backdrop-blur-sm"
              :class="provider.enabled
                ? 'border border-primary-200 bg-white/60 ring-1 ring-primary-500/20 dark:border-primary-800 dark:bg-dark-800/60'
                : 'border border-gray-200/50 bg-white/40 opacity-60 dark:border-dark-700/50 dark:bg-dark-800/40'"
            >
              <div
                class="flex h-8 w-8 items-center justify-center rounded-lg text-xs font-bold text-white"
                :class="provider.badgeClass"
              >
                {{ provider.initial }}
              </div>
              <span class="text-sm font-medium text-gray-700 dark:text-dark-200">{{ provider.name }}</span>
              <span
                class="rounded px-1.5 py-0.5 text-[10px] font-medium"
                :class="provider.enabled
                  ? 'bg-primary-100 text-primary-600 dark:bg-primary-900/30 dark:text-primary-400'
                  : 'bg-gray-100 text-gray-500 dark:bg-dark-700 dark:text-dark-400'"
              >
                {{ provider.enabled ? t('home.providers.supported') : t('home.providers.soon') }}
              </span>
            </div>
          </div>
        </section>

        <section v-if="officialEntries.length" class="mb-10">
          <div class="mb-5">
            <p class="mb-2 text-xs font-semibold uppercase tracking-[0.16em] text-primary-600 dark:text-primary-400">
              {{ t('home.officialEntrances.title') }}
            </p>
            <h2 class="text-2xl font-bold text-gray-900 dark:text-white">
              {{ t('home.officialEntrances.subtitle') }}
            </h2>
          </div>

          <div class="grid gap-5 xl:grid-cols-2">
            <article
              v-for="entry in officialEntries"
              :key="entry.key"
              class="grid items-center gap-5 rounded-2xl border border-gray-200/50 bg-white/70 p-5 shadow-sm backdrop-blur-sm dark:border-dark-700/50 dark:bg-dark-800/60 md:grid-cols-[minmax(0,1fr)_156px]"
            >
              <div class="flex flex-col items-start gap-3">
                <div class="inline-flex items-center gap-2 rounded-full bg-primary-100 px-3 py-1.5 text-xs font-semibold text-primary-700 dark:bg-primary-900/30 dark:text-primary-300">
                  <Icon :name="entry.icon" size="sm" />
                  <span>{{ entry.badge }}</span>
                </div>
                <h3 class="text-2xl font-bold text-gray-900 dark:text-white">{{ entry.title }}</h3>
                <p class="text-sm leading-7 text-gray-600 dark:text-dark-400">{{ entry.description }}</p>
                <p v-if="entry.meta" class="text-sm text-gray-500 dark:text-dark-400">
                  {{ t('home.officialEntrances.qqGroupNumber') }}
                  <strong class="ml-2 text-gray-900 dark:text-white">{{ entry.meta }}</strong>
                </p>
                <a
                  v-if="entry.link"
                  :href="entry.link"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="inline-flex items-center gap-2 rounded-xl bg-gray-900 px-4 py-2.5 text-sm font-semibold text-white transition-colors hover:bg-gray-800 dark:bg-white dark:text-gray-900"
                >
                  <span>{{ entry.actionLabel }}</span>
                  <Icon name="externalLink" size="sm" />
                </a>
              </div>

              <div class="flex flex-col items-center gap-3">
                <div
                  v-if="entry.qrCode"
                  class="flex h-[156px] w-[156px] items-center justify-center rounded-2xl border border-white/70 bg-white p-3 shadow-sm dark:border-white/10 dark:bg-dark-900"
                >
                  <img :src="entry.qrCode" :alt="entry.qrAlt" class="h-full w-full rounded-xl object-contain" />
                </div>
                <div
                  v-else
                  class="flex h-[156px] w-[156px] flex-col items-center justify-center gap-2 rounded-2xl border border-dashed border-gray-300 bg-white/70 text-sm text-gray-500 dark:border-dark-700 dark:bg-dark-900 dark:text-dark-400"
                >
                  <Icon name="grid" size="lg" />
                  <span>{{ t('home.officialEntrances.missing') }}</span>
                </div>
                <p class="text-xs text-gray-500 dark:text-dark-400">{{ t('home.officialEntrances.qrCaption') }}</p>
              </div>
            </article>
          </div>
        </section>

        <footer class="border-t border-gray-200/50 px-2 py-8 dark:border-dark-800/50">
          <div class="mx-auto flex max-w-6xl flex-col items-center justify-center gap-4 text-center sm:flex-row sm:text-left">
            <p class="text-sm text-gray-500 dark:text-dark-400">
              © {{ currentYear }} {{ siteName }}. {{ t('home.footer.allRightsReserved') }}
            </p>
            <div class="flex items-center gap-4">
              <a
                v-if="docsHref"
                :href="docsHref"
                :target="hasHelpDocs ? '_self' : '_blank'"
                rel="noopener noreferrer"
                class="text-sm text-gray-500 transition-colors hover:text-gray-700 dark:text-dark-400 dark:hover:text-white"
              >
                {{ t('home.docs') }}
              </a>
              <a
                href="https://github.com/Wei-Shaw/sub2api"
                target="_blank"
                rel="noopener noreferrer"
                class="text-sm text-gray-500 transition-colors hover:text-gray-700 dark:text-dark-400 dark:hover:text-white"
              >
                GitHub
              </a>
            </div>
          </div>
        </footer>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAuthStore, useAppStore } from '@/stores'
import LocaleSwitcher from '@/components/common/LocaleSwitcher.vue'
import Icon from '@/components/icons/Icon.vue'

type FeatureCard = {
  icon: 'server' | 'users' | 'dollar'
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

type TerminalLine = {
  type: 'command' | 'comment' | 'success'
  prefix?: string
  text: string
  className: string
}

const { locale, t } = useI18n()

const authStore = useAuthStore()
const appStore = useAppStore()

const isDark = ref(document.documentElement.classList.contains('dark'))

const homePath = computed(() => '/home')
const siteName = computed(() => appStore.cachedPublicSettings?.site_name || appStore.siteName || 'SubForAI')
const siteLogo = computed(() => appStore.cachedPublicSettings?.site_logo || appStore.siteLogo || '')
const siteSubtitle = computed(() => appStore.cachedPublicSettings?.site_subtitle || 'AI API Gateway Platform')
const docUrl = computed(() => appStore.cachedPublicSettings?.doc_url || appStore.docUrl || '')
const helpDocs = computed(() => appStore.cachedPublicSettings?.help_docs ?? [])
const hasHelpDocs = computed(() => helpDocs.value.length > 0)
const docsHref = computed(() => (hasHelpDocs.value ? '/help-docs' : docUrl.value))
const homeContent = computed(() => appStore.cachedPublicSettings?.home_content || '')

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

const heroEyebrow = computed(() => (isZh.value ? '企业级网关' : 'Enterprise Gateway'))
const heroSubtitle = computed(() => siteSubtitle.value)
const heroDescription = computed(() => t('home.heroDescription'))

const ctaText = computed(() => {
  if (isAuthenticated.value) {
    return isZh.value ? '进入控制台' : 'Open Dashboard'
  }
  return isZh.value ? '立即开始' : 'Get Started'
})

const heroTags = computed(() => [
  { icon: 'swap' as const, label: t('home.tags.subscriptionToApi') },
  { icon: 'shield' as const, label: t('home.tags.stickySession') },
  { icon: 'chart' as const, label: t('home.tags.realtimeBilling') },
])

const terminalLines = computed<TerminalLine[]>(() => {
  if (isZh.value) {
    return [
      { type: 'command', text: 'curl -X POST /v1/messages', className: 'line-1' },
      { type: 'comment', text: '# Routing to upstream...', className: 'line-2' },
      { type: 'success', prefix: '200 OK', text: '{ "content": "Hello!" }', className: 'line-3' },
    ]
  }

  return [
    { type: 'command', text: 'curl -X POST /v1/messages', className: 'line-1' },
    { type: 'comment', text: '# Routing to upstream...', className: 'line-2' },
    { type: 'success', prefix: '200 OK', text: '{ "content": "Hello!" }', className: 'line-3' },
  ]
})

const featureCards = computed<FeatureCard[]>(() => [
  {
    icon: 'server',
    title: t('home.features.unifiedGateway'),
    desc: t('home.features.unifiedGatewayDesc'),
  },
  {
    icon: 'users',
    title: t('home.features.multiAccount'),
    desc: t('home.features.multiAccountDesc'),
  },
  {
    icon: 'dollar',
    title: t('home.features.balanceQuota'),
    desc: t('home.features.balanceQuotaDesc'),
  },
])

const providers = computed(() => [
  { initial: 'C', name: t('home.providers.claude'), enabled: true, badgeClass: 'bg-gradient-to-br from-orange-400 to-orange-500' },
  { initial: 'G', name: 'GPT', enabled: true, badgeClass: 'bg-gradient-to-br from-green-500 to-green-600' },
  { initial: 'G', name: t('home.providers.gemini'), enabled: true, badgeClass: 'bg-gradient-to-br from-blue-500 to-blue-600' },
  { initial: 'A', name: t('home.providers.antigravity'), enabled: true, badgeClass: 'bg-gradient-to-br from-rose-500 to-pink-600' },
  { initial: '+', name: t('home.providers.more'), enabled: false, badgeClass: 'bg-gradient-to-br from-gray-500 to-gray-600' },
])

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
      qrAlt: `${t('home.officialEntrances.qqGroup')} QR`,
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
          qr_code: settings.xianyu_shop_qr_code || '',
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
      qrAlt: `${t('home.officialEntrances.xianyuShop')} QR`,
    })
  }

  return entries
})

const currentYear = computed(() => new Date().getFullYear())

function toggleTheme() {
  isDark.value = !isDark.value
  document.documentElement.classList.toggle('dark', isDark.value)
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}

function initTheme() {
  const savedTheme = localStorage.getItem('theme')
  if (savedTheme === 'dark' || (!savedTheme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
    isDark.value = true
    document.documentElement.classList.add('dark')
  } else {
    isDark.value = false
    document.documentElement.classList.remove('dark')
  }
}

function featureIconClass(index: number): string {
  return [
    'bg-gradient-to-br from-blue-500 to-blue-600 shadow-blue-500/30',
    'bg-gradient-to-br from-primary-500 to-primary-600 shadow-primary-500/30',
    'bg-gradient-to-br from-purple-500 to-purple-600 shadow-purple-500/30',
  ][index] || 'bg-gradient-to-br from-primary-500 to-primary-600 shadow-primary-500/30'
}

onMounted(() => {
  initTheme()
  authStore.checkAuth()
  if (!appStore.publicSettingsLoaded) {
    appStore.fetchPublicSettings()
  }
})
</script>

<style scoped>
.terminal-container {
  width: 100%;
  max-width: 480px;
}

.terminal-window {
  overflow: hidden;
  border: 1px solid rgba(15, 23, 42, 0.08);
  border-radius: 28px;
  background:
    linear-gradient(180deg, rgba(15, 23, 42, 0.96), rgba(15, 23, 42, 0.9)),
    rgba(15, 23, 42, 0.94);
  box-shadow:
    0 30px 80px -35px rgba(15, 23, 42, 0.55),
    inset 0 1px 0 rgba(255, 255, 255, 0.06);
}

.terminal-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1rem 1.1rem;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  background: rgba(255, 255, 255, 0.03);
}

.terminal-buttons {
  display: flex;
  gap: 0.45rem;
}

.btn-close,
.btn-minimize,
.btn-maximize {
  width: 0.7rem;
  height: 0.7rem;
  border-radius: 999px;
}

.btn-close {
  background: #fb7185;
}

.btn-minimize {
  background: #fbbf24;
}

.btn-maximize {
  background: #34d399;
}

.terminal-title {
  font-size: 0.8rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  color: rgba(226, 232, 240, 0.72);
  text-transform: uppercase;
}

.terminal-body {
  padding: 1.25rem 1.1rem 1.35rem;
  font-family:
    'SFMono-Regular',
    'Cascadia Code',
    'JetBrains Mono',
    ui-monospace,
    monospace;
  font-size: 0.88rem;
  line-height: 1.8;
}

.code-line {
  display: flex;
  align-items: center;
  gap: 0.65rem;
  min-height: 1.75rem;
  animation: fade-up 0.65s ease both;
}

.line-2 {
  animation-delay: 0.1s;
}

.line-3 {
  animation-delay: 0.2s;
}

.line-4 {
  animation-delay: 0.3s;
}

.code-prompt {
  color: #34d399;
}

.code-cmd {
  color: #f8fafc;
}

.code-comment {
  color: rgba(148, 163, 184, 0.85);
}

.code-success {
  color: #fbbf24;
  font-weight: 700;
}

.code-response {
  color: rgba(226, 232, 240, 0.9);
}

.cursor {
  display: inline-flex;
  width: 0.62rem;
  height: 1rem;
  border-radius: 4px;
  background: linear-gradient(180deg, #34d399 0%, #2dd4bf 100%);
  animation: blink 1s steps(2, start) infinite;
}

@keyframes fade-up {
  from {
    opacity: 0;
    transform: translateY(12px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes blink {
  0%,
  49% {
    opacity: 1;
  }

  50%,
  100% {
    opacity: 0.2;
  }
}

@media (max-width: 640px) {
  .terminal-container {
    max-width: 100%;
  }
}
</style>
