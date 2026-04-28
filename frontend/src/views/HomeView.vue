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
    class="relative min-h-screen overflow-hidden bg-[radial-gradient(circle_at_top_left,_rgba(251,191,36,0.18),_transparent_28%),radial-gradient(circle_at_85%_16%,_rgba(45,212,191,0.18),_transparent_26%),linear-gradient(135deg,_#f8fafc_0%,_#eff6ff_45%,_#ecfeff_100%)] text-slate-900 dark:bg-[radial-gradient(circle_at_top_left,_rgba(251,191,36,0.08),_transparent_28%),radial-gradient(circle_at_85%_16%,_rgba(45,212,191,0.1),_transparent_26%),linear-gradient(135deg,_#020617_0%,_#0f172a_45%,_#042f2e_100%)] dark:text-white"
  >
    <div class="pointer-events-none absolute inset-0 overflow-hidden">
      <div class="absolute left-[-8rem] top-[-6rem] h-72 w-72 rounded-full bg-amber-300/35 blur-3xl dark:bg-amber-400/10"></div>
      <div class="absolute right-[-5rem] top-[10%] h-80 w-80 rounded-full bg-cyan-300/35 blur-3xl dark:bg-cyan-400/10"></div>
      <div class="absolute bottom-[-10rem] left-[22%] h-96 w-96 rounded-full bg-sky-300/25 blur-3xl dark:bg-sky-400/10"></div>
      <div class="absolute inset-0 bg-[linear-gradient(rgba(148,163,184,0.16)_1px,transparent_1px),linear-gradient(90deg,rgba(148,163,184,0.16)_1px,transparent_1px)] bg-[size:72px_72px] opacity-40 dark:opacity-15"></div>
    </div>

    <header class="relative z-20 px-4 pt-4 sm:px-6">
      <nav class="mx-auto flex max-w-7xl items-center justify-between rounded-[28px] border border-white/65 bg-white/70 px-4 py-3 shadow-[0_24px_70px_-32px_rgba(15,23,42,0.45)] backdrop-blur-xl dark:border-white/10 dark:bg-slate-950/58">
        <router-link :to="homePath" class="flex min-w-0 items-center gap-3">
          <div class="flex h-11 w-11 items-center justify-center overflow-hidden rounded-2xl border border-white/75 bg-white shadow-md dark:border-white/10 dark:bg-slate-900">
            <img :src="siteLogo || '/logo.png'" alt="Logo" class="h-full w-full object-contain" />
          </div>
          <div class="min-w-0">
            <p class="truncate text-base font-semibold tracking-tight text-slate-900 dark:text-white">{{ siteName }}</p>
            <p class="truncate text-xs font-medium uppercase tracking-[0.24em] text-slate-500 dark:text-slate-400">
              {{ heroEyebrow }}
            </p>
          </div>
        </router-link>

        <div class="flex items-center gap-2 sm:gap-3">
          <LocaleSwitcher />
          <a
            v-if="docsHref"
            :href="docsHref"
            :target="hasHelpDocs ? '_self' : '_blank'"
            rel="noopener noreferrer"
            class="inline-flex h-10 w-10 items-center justify-center rounded-xl border border-white/70 bg-white/75 text-slate-500 transition hover:-translate-y-0.5 hover:text-slate-900 dark:border-white/10 dark:bg-slate-900/70 dark:text-slate-400 dark:hover:text-white"
            :title="t('home.viewDocs')"
          >
            <Icon name="book" size="md" />
          </a>
          <button
            type="button"
            class="inline-flex h-10 w-10 items-center justify-center rounded-xl border border-white/70 bg-white/75 text-slate-500 transition hover:-translate-y-0.5 hover:text-slate-900 dark:border-white/10 dark:bg-slate-900/70 dark:text-slate-400 dark:hover:text-white"
            :title="isDark ? t('home.switchToLight') : t('home.switchToDark')"
            @click="toggleTheme"
          >
            <Icon v-if="isDark" name="sun" size="md" />
            <Icon v-else name="moon" size="md" />
          </button>
          <router-link
            v-if="isAuthenticated"
            :to="dashboardPath"
            class="inline-flex items-center gap-2 rounded-xl border border-emerald-500/20 bg-slate-950 px-4 py-2.5 text-sm font-semibold text-white shadow-[0_18px_40px_-22px_rgba(15,23,42,0.8)] transition hover:-translate-y-0.5 dark:border-emerald-400/20 dark:bg-white dark:text-slate-950"
          >
            <span class="inline-flex h-6 w-6 items-center justify-center rounded-full bg-white/10 text-[11px] font-bold dark:bg-slate-900/10">{{ userInitial }}</span>
            <span class="hidden sm:inline">{{ t('home.dashboard') }}</span>
          </router-link>
          <router-link
            v-else
            to="/login"
            class="inline-flex items-center rounded-xl bg-gradient-to-r from-slate-950 via-slate-800 to-emerald-700 px-4 py-2.5 text-sm font-semibold text-white shadow-[0_18px_40px_-22px_rgba(15,23,42,0.8)] transition hover:-translate-y-0.5 dark:from-white dark:via-slate-100 dark:to-emerald-200 dark:text-slate-950"
          >
            {{ t('home.login') }}
          </router-link>
        </div>
      </nav>
    </header>

    <main class="relative z-10 mx-auto flex max-w-7xl flex-col gap-8 px-4 pb-16 pt-8 sm:px-6 sm:pb-20 sm:pt-10 lg:gap-12">
      <section class="grid gap-6 lg:grid-cols-[minmax(0,1.08fr)_minmax(360px,0.92fr)] lg:items-stretch">
        <div class="flex flex-col justify-center rounded-[34px] border border-white/70 bg-white/72 p-6 shadow-[0_32px_90px_-42px_rgba(15,23,42,0.45)] backdrop-blur-2xl dark:border-white/10 dark:bg-slate-950/58 sm:p-8 lg:p-10">
          <div class="mb-5 inline-flex w-fit items-center gap-2 rounded-full border border-emerald-500/15 bg-emerald-500/10 px-4 py-2 text-xs font-semibold uppercase tracking-[0.24em] text-emerald-700 dark:border-emerald-400/20 dark:bg-emerald-400/10 dark:text-emerald-300">
            <span class="inline-flex h-2 w-2 rounded-full bg-emerald-500"></span>
            {{ heroEyebrow }}
          </div>

          <div class="space-y-4">
            <p class="text-sm font-semibold uppercase tracking-[0.28em] text-slate-500 dark:text-slate-400">
              {{ heroTitle }}
            </p>
            <h1 class="max-w-3xl text-4xl font-semibold tracking-[-0.06em] text-slate-950 dark:text-white sm:text-5xl lg:text-6xl">
              {{ heroSubtitle }}
              <span class="mt-2 block bg-gradient-to-r from-amber-600 via-orange-500 to-emerald-500 bg-clip-text text-transparent dark:from-amber-300 dark:via-orange-200 dark:to-emerald-300">
                {{ heroHeadlineTail }}
              </span>
            </h1>
            <p class="max-w-2xl text-base leading-8 text-slate-600 dark:text-slate-300 sm:text-lg">
              {{ heroDescription }}
            </p>
          </div>

          <div class="mt-6 flex flex-wrap gap-3">
            <span
              v-for="tag in heroTags"
              :key="tag"
              class="inline-flex min-h-11 items-center rounded-full border border-white/80 bg-white/80 px-4 text-sm font-medium text-slate-700 shadow-sm dark:border-white/10 dark:bg-white/5 dark:text-slate-200"
            >
              {{ tag }}
            </span>
          </div>

          <div class="mt-8 flex flex-col gap-3 sm:flex-row">
            <router-link
              :to="isAuthenticated ? dashboardPath : '/login'"
              class="inline-flex min-h-12 items-center justify-center rounded-2xl bg-gradient-to-r from-slate-950 via-slate-800 to-emerald-700 px-6 text-sm font-semibold text-white shadow-[0_18px_50px_-24px_rgba(5,150,105,0.9)] transition hover:-translate-y-0.5 dark:from-white dark:via-slate-100 dark:to-emerald-200 dark:text-slate-950"
            >
              {{ ctaText }}
            </router-link>
            <a
              v-if="docsHref"
              :href="docsHref"
              :target="hasHelpDocs ? '_self' : '_blank'"
              rel="noopener noreferrer"
              class="inline-flex min-h-12 items-center justify-center gap-2 rounded-2xl border border-slate-200 bg-white/80 px-6 text-sm font-semibold text-slate-700 transition hover:-translate-y-0.5 hover:border-slate-300 dark:border-white/10 dark:bg-white/5 dark:text-slate-200 dark:hover:border-white/20"
            >
              <Icon name="arrowRight" size="sm" />
              {{ t('home.docs') }}
            </a>
          </div>

          <div class="mt-8 grid gap-3 sm:grid-cols-3">
            <article
              v-for="metric in metrics"
              :key="metric.label"
              class="rounded-2xl border border-white/80 bg-white/82 p-4 shadow-sm dark:border-white/10 dark:bg-white/5"
            >
              <p class="text-[11px] font-semibold uppercase tracking-[0.24em] text-slate-500 dark:text-slate-400">{{ metric.label }}</p>
              <p class="mt-2 text-2xl font-semibold tracking-tight text-slate-950 dark:text-white">{{ metric.value }}</p>
              <p class="mt-1 text-sm leading-6 text-slate-600 dark:text-slate-300">{{ metric.desc }}</p>
            </article>
          </div>
        </div>

        <div class="grid gap-4">
          <section class="rounded-[34px] border border-white/70 bg-slate-950 p-5 text-white shadow-[0_32px_90px_-42px_rgba(15,23,42,0.7)] lg:p-6">
            <div class="mb-5 flex items-center justify-between gap-3">
              <div>
                <p class="text-xs font-semibold uppercase tracking-[0.24em] text-emerald-300/90">{{ terminalBadge }}</p>
                <h2 class="mt-2 text-2xl font-semibold tracking-tight">{{ terminalTitle }}</h2>
              </div>
              <div class="rounded-2xl border border-white/10 bg-white/5 px-3 py-2 text-right">
                <p class="text-[11px] uppercase tracking-[0.22em] text-slate-400">{{ terminalStatusLabel }}</p>
                <p class="mt-1 text-sm font-semibold text-emerald-300">{{ terminalStatusValue }}</p>
              </div>
            </div>

            <div class="rounded-[28px] border border-white/10 bg-[#050b18] p-4 shadow-[inset_0_1px_0_rgba(255,255,255,0.05)]">
              <div class="mb-4 flex items-center justify-between gap-3">
                <div class="flex items-center gap-2">
                  <span class="h-3 w-3 rounded-full bg-rose-400"></span>
                  <span class="h-3 w-3 rounded-full bg-amber-400"></span>
                  <span class="h-3 w-3 rounded-full bg-emerald-400"></span>
                </div>
                <p class="text-xs font-medium text-slate-500">gateway.live</p>
              </div>

              <div class="space-y-3 rounded-2xl border border-white/5 bg-white/[0.03] p-4 font-mono text-[13px] leading-6 text-slate-200">
                <div
                  v-for="line in terminalLines"
                  :key="line.text"
                  class="terminal-line"
                >
                  <span :class="line.prefixClass">{{ line.prefix }}</span>
                  <span :class="line.textClass">{{ line.text }}</span>
                </div>
                <div class="terminal-line">
                  <span class="text-emerald-300">$</span>
                  <span class="terminal-cursor ml-2"></span>
                </div>
              </div>

              <div class="mt-4 grid gap-3 sm:grid-cols-2">
                <div class="rounded-2xl border border-emerald-400/15 bg-emerald-400/10 p-4">
                  <p class="text-[11px] font-semibold uppercase tracking-[0.24em] text-emerald-200/90">{{ providerHeadline }}</p>
                  <p class="mt-2 text-sm leading-6 text-slate-200">{{ providerDescription }}</p>
                </div>
                <div class="rounded-2xl border border-white/10 bg-white/[0.04] p-4">
                  <p class="text-[11px] font-semibold uppercase tracking-[0.24em] text-slate-400">{{ supportHeadline }}</p>
                  <p class="mt-2 text-sm leading-6 text-slate-300">{{ supportDescription }}</p>
                </div>
              </div>
            </div>
          </section>

          <section class="rounded-[30px] border border-white/70 bg-white/72 p-5 shadow-[0_24px_70px_-36px_rgba(15,23,42,0.45)] backdrop-blur-xl dark:border-white/10 dark:bg-slate-950/58">
            <div class="flex flex-wrap items-center justify-between gap-3">
              <div>
                <p class="text-xs font-semibold uppercase tracking-[0.24em] text-slate-500 dark:text-slate-400">{{ providersEyebrow }}</p>
                <h3 class="mt-1 text-xl font-semibold tracking-tight text-slate-950 dark:text-white">{{ t('home.providers.title') }}</h3>
              </div>
              <p class="max-w-sm text-sm leading-6 text-slate-600 dark:text-slate-300">{{ t('home.providers.description') }}</p>
            </div>

            <div class="mt-4 flex flex-wrap gap-3">
              <span
                v-for="provider in providers"
                :key="provider.name"
                class="inline-flex items-center gap-2 rounded-2xl border px-4 py-3 text-sm font-medium shadow-sm"
                :class="provider.enabled
                  ? 'border-emerald-500/15 bg-emerald-500/10 text-slate-800 dark:border-emerald-400/20 dark:bg-emerald-400/10 dark:text-slate-100'
                  : 'border-slate-200 bg-slate-100/80 text-slate-500 dark:border-white/10 dark:bg-white/5 dark:text-slate-400'"
              >
                <span
                  class="inline-flex h-8 w-8 items-center justify-center rounded-xl text-xs font-bold"
                  :class="provider.enabled
                    ? 'bg-gradient-to-br from-emerald-500 to-cyan-500 text-white'
                    : 'bg-slate-200 text-slate-500 dark:bg-white/10 dark:text-slate-400'"
                >
                  {{ provider.initial }}
                </span>
                <span>{{ provider.name }}</span>
                <span class="rounded-full px-2 py-0.5 text-[10px] font-semibold uppercase tracking-[0.18em]"
                  :class="provider.enabled
                    ? 'bg-white/80 text-emerald-700 dark:bg-white/10 dark:text-emerald-300'
                    : 'bg-white/80 text-slate-500 dark:bg-white/10 dark:text-slate-400'"
                >
                  {{ provider.enabled ? t('home.providers.supported') : t('home.providers.soon') }}
                </span>
              </span>
            </div>
          </section>
        </div>
      </section>

      <section class="rounded-[34px] border border-white/70 bg-white/72 p-6 shadow-[0_28px_80px_-40px_rgba(15,23,42,0.45)] backdrop-blur-2xl dark:border-white/10 dark:bg-slate-950/58 sm:p-8">
        <div class="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-[0.24em] text-emerald-700 dark:text-emerald-300">{{ featuresEyebrow }}</p>
            <h2 class="mt-2 text-3xl font-semibold tracking-tight text-slate-950 dark:text-white">{{ featuresTitle }}</h2>
          </div>
          <p class="max-w-2xl text-sm leading-7 text-slate-600 dark:text-slate-300">{{ featuresDescription }}</p>
        </div>

        <div class="mt-6 grid gap-4 md:grid-cols-2 xl:grid-cols-3">
          <article
            v-for="(item, index) in featureCards"
            :key="item.title"
            class="group overflow-hidden rounded-[28px] border border-white/80 bg-white/82 p-5 transition duration-200 hover:-translate-y-1 hover:shadow-[0_26px_70px_-38px_rgba(5,150,105,0.5)] dark:border-white/10 dark:bg-white/[0.04] sm:p-6"
            :class="index === 0 || index === 3 ? 'xl:col-span-2' : ''"
          >
            <div class="flex h-full flex-col justify-between gap-6">
              <div class="space-y-4">
                <div
                  class="inline-flex h-12 w-12 items-center justify-center rounded-2xl text-white shadow-lg"
                  :class="featureIconClass(index)"
                >
                  <Icon :name="item.icon" size="md" />
                </div>
                <div>
                  <p class="text-xs font-semibold uppercase tracking-[0.24em] text-slate-500 dark:text-slate-400">
                    {{ featureMeta(index) }}
                  </p>
                  <h3 class="mt-2 text-2xl font-semibold tracking-tight text-slate-950 dark:text-white">{{ item.title }}</h3>
                </div>
                <p class="max-w-2xl text-sm leading-7 text-slate-600 dark:text-slate-300">{{ item.desc }}</p>
              </div>

              <div
                class="rounded-2xl border px-4 py-3 text-sm leading-6"
                :class="index % 2 === 0
                  ? 'border-emerald-500/15 bg-emerald-500/10 text-slate-700 dark:border-emerald-400/20 dark:bg-emerald-400/10 dark:text-slate-200'
                  : 'border-slate-200 bg-slate-100/70 text-slate-600 dark:border-white/10 dark:bg-white/5 dark:text-slate-300'"
              >
                {{ featureFootnote(index) }}
              </div>
            </div>
          </article>
        </div>
      </section>

      <section
        v-if="officialEntries.length"
        class="rounded-[34px] border border-white/70 bg-white/72 p-6 shadow-[0_28px_80px_-40px_rgba(15,23,42,0.45)] backdrop-blur-2xl dark:border-white/10 dark:bg-slate-950/58 sm:p-8"
      >
        <div class="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
          <div>
            <p class="text-xs font-semibold uppercase tracking-[0.24em] text-emerald-700 dark:text-emerald-300">{{ t('home.officialEntrances.title') }}</p>
            <h2 class="mt-2 text-3xl font-semibold tracking-tight text-slate-950 dark:text-white">{{ t('home.officialEntrances.subtitle') }}</h2>
          </div>
          <p class="max-w-2xl text-sm leading-7 text-slate-600 dark:text-slate-300">
            {{ officialEntriesDescription }}
          </p>
        </div>

        <div class="mt-6 grid gap-4 xl:grid-cols-2">
          <article
            v-for="entry in officialEntries"
            :key="entry.key"
            class="grid gap-5 rounded-[28px] border border-white/80 bg-white/82 p-5 shadow-sm dark:border-white/10 dark:bg-white/[0.04] md:grid-cols-[minmax(0,1fr)_190px]"
          >
            <div class="flex flex-col gap-4">
              <div class="inline-flex w-fit items-center gap-2 rounded-full border border-emerald-500/15 bg-emerald-500/10 px-3 py-2 text-xs font-semibold uppercase tracking-[0.2em] text-emerald-700 dark:border-emerald-400/20 dark:bg-emerald-400/10 dark:text-emerald-300">
                <Icon :name="entry.icon" size="sm" />
                <span>{{ entry.badge }}</span>
              </div>
              <div>
                <h3 class="text-2xl font-semibold tracking-tight text-slate-950 dark:text-white">{{ entry.title }}</h3>
                <p class="mt-2 text-sm leading-7 text-slate-600 dark:text-slate-300">{{ entry.description }}</p>
              </div>
              <p v-if="entry.meta" class="text-sm text-slate-500 dark:text-slate-400">
                {{ t('home.officialEntrances.qqGroupNumber') }}
                <strong class="ml-2 font-semibold text-slate-900 dark:text-white">{{ entry.meta }}</strong>
              </p>
              <a
                v-if="entry.link"
                :href="entry.link"
                target="_blank"
                rel="noopener noreferrer"
                class="inline-flex min-h-11 w-fit items-center gap-2 rounded-2xl bg-gradient-to-r from-slate-950 via-slate-800 to-emerald-700 px-5 text-sm font-semibold text-white shadow-[0_18px_50px_-24px_rgba(5,150,105,0.9)] transition hover:-translate-y-0.5 dark:from-white dark:via-slate-100 dark:to-emerald-200 dark:text-slate-950"
              >
                <span>{{ entry.actionLabel }}</span>
                <Icon name="externalLink" size="sm" />
              </a>
            </div>

            <div class="flex flex-col items-center justify-center gap-3 rounded-[26px] border border-slate-200/80 bg-slate-100/70 p-4 dark:border-white/10 dark:bg-white/[0.04]">
              <div
                v-if="entry.qrCode"
                class="flex h-[164px] w-[164px] items-center justify-center rounded-[22px] border border-white/80 bg-white p-3 shadow-sm dark:border-white/10 dark:bg-slate-950"
              >
                <img :src="entry.qrCode" :alt="entry.qrAlt" class="h-full w-full rounded-2xl object-contain" />
              </div>
              <div
                v-else
                class="flex h-[164px] w-[164px] flex-col items-center justify-center gap-3 rounded-[22px] border border-dashed border-slate-300 bg-white/80 text-slate-500 dark:border-white/10 dark:bg-slate-950/60 dark:text-slate-400"
              >
                <Icon name="grid" size="lg" />
                <span class="text-sm">{{ t('home.officialEntrances.missing') }}</span>
              </div>
              <p class="text-sm font-medium text-slate-500 dark:text-slate-400">{{ t('home.officialEntrances.qrCaption') }}</p>
            </div>
          </article>
        </div>
      </section>

      <footer class="flex flex-col gap-4 rounded-[30px] border border-white/70 bg-white/72 px-6 py-5 text-sm text-slate-500 shadow-[0_22px_60px_-40px_rgba(15,23,42,0.45)] backdrop-blur-xl dark:border-white/10 dark:bg-slate-950/58 dark:text-slate-400 sm:flex-row sm:items-center sm:justify-between">
        <p>© {{ currentYear }} {{ siteName }}. {{ t('home.footer.allRightsReserved') }}</p>
        <div class="flex flex-wrap items-center gap-4">
          <a
            v-if="docsHref"
            :href="docsHref"
            :target="hasHelpDocs ? '_self' : '_blank'"
            rel="noopener noreferrer"
            class="transition hover:text-slate-900 dark:hover:text-white"
          >
            {{ t('home.docs') }}
          </a>
          <a
            href="https://github.com/Wei-Shaw/sub2api"
            target="_blank"
            rel="noopener noreferrer"
            class="transition hover:text-slate-900 dark:hover:text-white"
          >
            GitHub
          </a>
        </div>
      </footer>
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
  icon: 'shield' | 'dollar' | 'calculator' | 'sparkles' | 'grid' | 'bolt'
  title: string
  desc: string
}

type MetricCard = {
  label: string
  value: string
  desc: string
}

type ProviderChip = {
  initial: string
  name: string
  enabled: boolean
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
  prefix: string
  text: string
  prefixClass: string
  textClass: string
}

const { locale, t } = useI18n()

const authStore = useAuthStore()
const appStore = useAppStore()

const isDark = ref(document.documentElement.classList.contains('dark'))

const siteName = computed(() => appStore.cachedPublicSettings?.site_name || appStore.siteName || 'SubForAI')
const siteLogo = computed(() => appStore.cachedPublicSettings?.site_logo || appStore.siteLogo || '')
const docUrl = computed(() => appStore.cachedPublicSettings?.doc_url || appStore.docUrl || '')
const helpDocs = computed(() => appStore.cachedPublicSettings?.help_docs ?? [])
const hasHelpDocs = computed(() => helpDocs.value.length > 0)
const docsHref = computed(() => (hasHelpDocs.value ? '/help-docs' : docUrl.value))
const homeContent = computed(() => appStore.cachedPublicSettings?.home_content || '')
const homePath = computed(() => '/home')

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

const heroTitle = computed(() => siteName.value.trim() || 'SubForAI')
const heroEyebrow = computed(() => (isZh.value ? 'AI API Gateway' : 'AI API Gateway'))
const heroSubtitle = computed(() => t('home.heroSubtitle'))
const heroHeadlineTail = computed(() =>
  isZh.value ? '统一入口，稳定分发，实时计费。' : 'Unified access, stable routing, real-time billing.'
)
const heroDescription = computed(() => t('home.heroDescription'))
const heroTags = computed(() => [
  t('home.tags.subscriptionToApi'),
  t('home.tags.stickySession'),
  t('home.tags.realtimeBilling'),
])

const ctaText = computed(() => {
  if (isAuthenticated.value) {
    return isZh.value ? '进入控制台' : 'Open Dashboard'
  }
  return isZh.value ? '立即开始' : 'Get Started'
})

const metrics = computed<MetricCard[]>(() => {
  if (isZh.value) {
    return [
      { label: 'Gateway Uptime', value: '99.5%', desc: '多账号池与自动切换，降低单账号触发限制的风险。' },
      { label: 'Access Surface', value: '1 Key', desc: '同一套 API 密钥访问 Claude、GPT、Gemini 等模型。' },
      { label: 'Billing Model', value: '实时', desc: '按量扣费，明细可查，额度和成本都更可控。' },
    ]
  }

  return [
    { label: 'Gateway Uptime', value: '99.5%', desc: 'Multi-account failover reduces single-account disruption risk.' },
    { label: 'Access Surface', value: '1 Key', desc: 'Use the same API key across Claude, GPT, Gemini, and more.' },
    { label: 'Billing Model', value: 'Live', desc: 'Usage-based charging with clear line items and cost control.' },
  ]
})

const terminalBadge = computed(() => (isZh.value ? '实时演示' : 'Live Demo'))
const terminalTitle = computed(() => (isZh.value ? '请求进入网关后的路径' : 'What happens after a request hits the gateway'))
const terminalStatusLabel = computed(() => (isZh.value ? '当前状态' : 'Current State'))
const terminalStatusValue = computed(() => (isZh.value ? 'Routing Healthy' : 'Routing Healthy'))
const providerHeadline = computed(() => (isZh.value ? '上游策略' : 'Upstream Strategy'))
const providerDescription = computed(() =>
  isZh.value
    ? '优先可用实例，按支付与订阅配置分发请求，保持响应稳定。'
    : 'Requests are routed through the best available upstream based on your payment and subscription policy.'
)
const supportHeadline = computed(() => (isZh.value ? '运维视角' : 'Ops View'))
const supportDescription = computed(() =>
  isZh.value
    ? '账号池、粘性会话、重试与计费逻辑都在同一面板里统一管理。'
    : 'Account pools, sticky sessions, retries, and billing logic are managed from one control plane.'
)

const terminalLines = computed<TerminalLine[]>(() => {
  if (isZh.value) {
    return [
      {
        prefix: '$',
        text: 'curl -X POST /v1/messages',
        prefixClass: 'text-emerald-300',
        textClass: 'text-slate-100',
      },
      {
        prefix: '>',
        text: '识别用户订阅与余额策略',
        prefixClass: 'text-cyan-300',
        textClass: 'text-slate-300',
      },
      {
        prefix: '>',
        text: '选择 Claude / GPT / Gemini 最优上游实例',
        prefixClass: 'text-cyan-300',
        textClass: 'text-slate-300',
      },
      {
        prefix: '✓',
        text: '200 OK · usage synced · billing recorded',
        prefixClass: 'text-amber-300',
        textClass: 'text-white',
      },
    ]
  }

  return [
    {
      prefix: '$',
      text: 'curl -X POST /v1/messages',
      prefixClass: 'text-emerald-300',
      textClass: 'text-slate-100',
    },
    {
      prefix: '>',
      text: 'resolve subscription, quota, and payment policy',
      prefixClass: 'text-cyan-300',
      textClass: 'text-slate-300',
    },
    {
      prefix: '>',
      text: 'route to the best Claude / GPT / Gemini upstream',
      prefixClass: 'text-cyan-300',
      textClass: 'text-slate-300',
    },
    {
      prefix: '✓',
      text: '200 OK · usage synced · billing recorded',
      prefixClass: 'text-amber-300',
      textClass: 'text-white',
    },
  ]
})

const providersEyebrow = computed(() => (isZh.value ? '模型接入' : 'Model Coverage'))
const providers = computed<ProviderChip[]>(() => [
  { initial: 'C', name: 'Claude', enabled: true },
  { initial: 'G', name: 'GPT', enabled: true },
  { initial: 'G', name: 'Gemini', enabled: true },
  { initial: 'A', name: 'Antigravity', enabled: true },
  { initial: '+', name: t('home.providers.more'), enabled: false },
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

const officialEntriesDescription = computed(() =>
  isZh.value
    ? '把用户常用的咨询和下单入口放到首页，扫码就能直达，不再额外找群号或店铺链接。'
    : 'Bring your most-used support and ordering channels directly onto the home page for faster conversion.'
)

const featureCards = computed<FeatureCard[]>(() => {
  if (isZh.value) {
    return [
      {
        icon: 'shield',
        title: '稳定优先',
        desc: '独家网关，确保号池稳定，可用率达 99.5%',
      },
      {
        icon: 'dollar',
        title: '高性价比',
        desc: '可选按量/包月计费，使用成本仅官网十分之一',
      },
      {
        icon: 'calculator',
        title: '透明计费',
        desc: '实时监控用量，无任何隐藏扣费',
      },
      {
        icon: 'sparkles',
        title: '简单易用',
        desc: '一键创建 API Key，快速接入各大模型服务',
      },
      {
        icon: 'grid',
        title: '多种渠道',
        desc: 'Codex、Claude Max、Droid 等号池多渠道聚合',
      },
      {
        icon: 'bolt',
        title: '专业客服',
        desc: '专业客服团队，极速响应，解决你的任何疑问',
      },
    ]
  }

  return [
    {
      icon: 'shield',
      title: 'Stability First',
      desc: 'Exclusive gateway routing with a 99.5% service availability target.',
    },
    {
      icon: 'dollar',
      title: 'Cost Efficient',
      desc: 'Usage-based and monthly plans with significantly lower model access cost.',
    },
    {
      icon: 'calculator',
      title: 'Transparent Billing',
      desc: 'Real-time usage tracking with clear pricing and no hidden deductions.',
    },
    {
      icon: 'sparkles',
      title: 'Easy to Launch',
      desc: 'Create API keys in one click and integrate mainstream models in minutes.',
    },
    {
      icon: 'grid',
      title: 'Multi-Channel',
      desc: 'Aggregate Codex, Claude Max, Droid, and more channels in one panel.',
    },
    {
      icon: 'bolt',
      title: 'Expert Support',
      desc: 'Fast-response support team ready to resolve integration and billing issues.',
    },
  ]
})

const featuresEyebrow = computed(() => (isZh.value ? '核心能力' : 'Core Capabilities'))
const featuresTitle = computed(() => (isZh.value ? '用产品化的方式管理 AI 接入' : 'Manage AI access like a product, not a workaround'))
const featuresDescription = computed(() =>
  isZh.value
    ? '参考你给的站点风格，这里用更强的层次、玻璃质感和终端演示，把平台价值说清楚，同时保持当前项目的内容和配置能力。'
    : 'The page keeps the current project content model, but shifts the presentation toward a sharper landing-page visual language.'
)

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
  const styles = [
    'bg-gradient-to-br from-emerald-500 to-cyan-500',
    'bg-gradient-to-br from-amber-500 to-orange-500',
    'bg-gradient-to-br from-sky-500 to-indigo-500',
    'bg-gradient-to-br from-fuchsia-500 to-pink-500',
    'bg-gradient-to-br from-slate-700 to-slate-900 dark:from-slate-300 dark:to-white dark:text-slate-900',
    'bg-gradient-to-br from-teal-500 to-emerald-500',
  ]
  return styles[index] || styles[0]
}

function featureMeta(index: number): string {
  const labels = isZh.value
    ? ['Gateway', 'Pricing', 'Billing', 'Onboarding', 'Channels', 'Support']
    : ['Gateway', 'Pricing', 'Billing', 'Onboarding', 'Channels', 'Support']
  return labels[index] || labels[0]
}

function featureFootnote(index: number): string {
  const notesZh = [
    '多账号池 + 自动切换 + 失败重试',
    '按量和订阅组合，适配不同用户结构',
    '用量明细、支付能力与配额策略联动',
    '默认路径短，用户从首页到创建 Key 更直接',
    '多模型与多渠道聚合到同一面板',
    '官方入口、客服与交易链路放在一个落地页内',
  ]
  const notesEn = [
    'Multi-account pool, automatic failover, and retry logic.',
    'Usage and subscription pricing can coexist for different user segments.',
    'Usage records, payment settings, and quota policy stay aligned.',
    'A shorter path from first visit to API key creation.',
    'Multiple models and routing channels under one control surface.',
    'Support, official entry points, and conversion paths live together.',
  ]
  return (isZh.value ? notesZh : notesEn)[index] || ''
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
.terminal-line {
  animation: fade-up 0.55s ease both;
}

.terminal-line:nth-child(2) {
  animation-delay: 0.08s;
}

.terminal-line:nth-child(3) {
  animation-delay: 0.16s;
}

.terminal-line:nth-child(4) {
  animation-delay: 0.24s;
}

.terminal-cursor {
  display: inline-flex;
  width: 10px;
  height: 1.15em;
  border-radius: 3px;
  background: linear-gradient(180deg, #34d399 0%, #2dd4bf 100%);
  animation: blink 1s steps(2, start) infinite;
}

@keyframes fade-up {
  from {
    opacity: 0;
    transform: translateY(10px);
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
</style>
