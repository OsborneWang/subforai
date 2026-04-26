<template>
  <div class="docs-shell">
    <header class="docs-header">
      <nav class="docs-header-inner">
        <router-link to="/home" class="docs-brand">
          <div class="docs-logo">
            <img :src="siteLogo || '/logo.png'" alt="Logo" class="h-full w-full object-contain" />
          </div>
          <span>{{ siteName }}</span>
        </router-link>
        <router-link to="/home" class="docs-home-link">
          <Icon name="home" size="sm" />
          <span>{{ t('home.getStarted') }}</span>
        </router-link>
      </nav>
    </header>

    <main class="docs-main">
      <section class="docs-hero">
        <p class="docs-kicker">{{ t('home.helpDocs.title') }}</p>
        <h1 class="docs-title">{{ t('home.helpDocs.subtitle') }}</h1>
      </section>

      <section v-if="docs.length" class="docs-grid">
        <article v-for="(doc, index) in docs" :key="`${doc.title}-${index}`" class="doc-card">
          <div class="doc-meta">
            <span class="doc-category">{{ doc.category || t('home.helpDocs.categoryFallback') }}</span>
          </div>
          <h2 class="doc-title">{{ doc.title }}</h2>
          <p class="doc-summary">{{ doc.summary || t('home.helpDocs.subtitle') }}</p>
          <div class="doc-actions">
            <router-link :to="`/help-docs/${index}`" class="doc-action doc-action--primary">
              {{ t('home.helpDocs.open') }}
            </router-link>
            <a
              :href="doc.url"
              target="_blank"
              rel="noopener noreferrer"
              class="doc-action doc-action--secondary"
            >
              {{ t('home.helpDocs.openExternal') }}
            </a>
          </div>
        </article>
      </section>

      <section v-else class="docs-empty">
        <Icon name="book" size="xl" />
        <p>{{ t('home.helpDocs.empty') }}</p>
      </section>
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useI18n } from 'vue-i18n'
import { useAppStore } from '@/stores'
import Icon from '@/components/icons/Icon.vue'

const { t } = useI18n()
const appStore = useAppStore()

const siteName = computed(() => appStore.cachedPublicSettings?.site_name || appStore.siteName || 'SubForAI')
const siteLogo = computed(() => appStore.cachedPublicSettings?.site_logo || appStore.siteLogo || '')
const docs = computed(() => appStore.cachedPublicSettings?.help_docs ?? [])

onMounted(() => {
  if (!appStore.publicSettingsLoaded) {
    appStore.fetchPublicSettings()
  }
})
</script>

<style scoped>
.docs-shell {
  min-height: 100vh;
  background: linear-gradient(180deg, #f6f1ee 0%, #f7f7fb 45%, #eef3ff 100%);
  color: #1d2430;
}

.docs-header {
  position: sticky;
  top: 0;
  z-index: 20;
  backdrop-filter: blur(18px);
  background: rgba(246, 241, 238, 0.78);
  border-bottom: 1px solid rgba(205, 210, 221, 0.55);
}

.docs-header-inner {
  max-width: 1120px;
  margin: 0 auto;
  padding: 14px 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.docs-brand {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  color: inherit;
  text-decoration: none;
  font-weight: 800;
}

.docs-logo {
  width: 42px;
  height: 42px;
  overflow: hidden;
  border-radius: 14px;
  box-shadow: 0 10px 18px rgba(57, 74, 112, 0.12);
}

.docs-home-link {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 10px 14px;
  border-radius: 999px;
  text-decoration: none;
  color: #fff8f0;
  font-weight: 700;
  background: linear-gradient(180deg, #c7643f 0%, #b45433 100%);
}

.docs-main {
  max-width: 1120px;
  margin: 0 auto;
  padding: 44px 24px 72px;
}

.docs-hero {
  margin-bottom: 28px;
}

.docs-kicker {
  margin: 0 0 10px;
  color: #c7643f;
  font-size: 0.8rem;
  font-weight: 800;
  letter-spacing: 0.16em;
  text-transform: uppercase;
}

.docs-title {
  margin: 0;
  max-width: 720px;
  font-size: clamp(2rem, 4vw, 3.4rem);
  line-height: 1.06;
  font-weight: 800;
}

.docs-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 18px;
}

.doc-card {
  padding: 24px;
  border-radius: 24px;
  border: 1px solid rgba(233, 235, 241, 0.9);
  background: rgba(255, 255, 255, 0.82);
  box-shadow: 0 16px 36px rgba(89, 96, 125, 0.12);
}

.doc-meta {
  margin-bottom: 12px;
}

.doc-category {
  display: inline-flex;
  align-items: center;
  min-height: 30px;
  padding: 0 10px;
  border-radius: 999px;
  background: rgba(199, 100, 63, 0.1);
  color: #c7643f;
  font-size: 0.78rem;
  font-weight: 700;
}

.doc-title {
  margin: 0 0 10px;
  font-size: 1.4rem;
  line-height: 1.15;
  font-weight: 800;
}

.doc-summary {
  margin: 0 0 18px;
  color: #596274;
  line-height: 1.7;
}

.doc-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.doc-action {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-height: 42px;
  padding: 0 16px;
  border-radius: 14px;
  text-decoration: none;
  font-weight: 700;
}

.doc-action--primary {
  color: #fff8f0;
  background: linear-gradient(180deg, #c7643f 0%, #b45433 100%);
}

.doc-action--secondary {
  color: #495366;
  border: 1px solid rgba(215, 220, 230, 0.95);
  background: rgba(255, 255, 255, 0.65);
}

.docs-empty {
  min-height: 280px;
  border-radius: 24px;
  border: 1px solid rgba(233, 235, 241, 0.9);
  background: rgba(255, 255, 255, 0.78);
  display: flex;
  flex-direction: column;
  gap: 14px;
  align-items: center;
  justify-content: center;
  color: #6b7486;
}

@media (max-width: 800px) {
  .docs-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 640px) {
  .docs-header-inner {
    padding: 12px 14px;
  }

  .docs-main {
    padding: 28px 14px 52px;
  }

  .docs-home-link span {
    display: none;
  }
}
</style>
