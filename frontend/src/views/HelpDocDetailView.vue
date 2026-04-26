<template>
  <div class="help-doc-shell">
    <header class="help-doc-header">
      <div class="help-doc-header-inner">
        <router-link to="/help-docs" class="help-doc-back">
          <Icon name="arrowLeft" size="sm" />
          <span>{{ t('home.helpDocs.backToList') }}</span>
        </router-link>
        <a
          v-if="doc"
          :href="doc.url"
          target="_blank"
          rel="noopener noreferrer"
          class="help-doc-open"
        >
          {{ t('home.helpDocs.openExternal') }}
        </a>
      </div>
    </header>

    <main class="help-doc-main">
      <section v-if="doc" class="help-doc-frame-shell">
        <div class="help-doc-meta">
          <span class="help-doc-category">{{ doc.category || t('home.helpDocs.categoryFallback') }}</span>
          <h1 class="help-doc-title">{{ doc.title }}</h1>
          <p class="help-doc-summary">{{ doc.summary || t('home.helpDocs.embedHint') }}</p>
        </div>
        <div class="help-doc-frame-wrap">
          <iframe :src="doc.url" class="help-doc-frame" allowfullscreen></iframe>
        </div>
      </section>
      <section v-else class="help-doc-empty">
        <Icon name="book" size="xl" />
        <p>{{ t('home.helpDocs.empty') }}</p>
      </section>
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useAppStore } from '@/stores'
import Icon from '@/components/icons/Icon.vue'

const route = useRoute()
const { t } = useI18n()
const appStore = useAppStore()

const docIndex = computed(() => Number(route.params.index))
const docs = computed(() => appStore.cachedPublicSettings?.help_docs ?? [])
const doc = computed(() => docs.value[docIndex.value] ?? null)

onMounted(() => {
  if (!appStore.publicSettingsLoaded) {
    appStore.fetchPublicSettings()
  }
})
</script>

<style scoped>
.help-doc-shell {
  min-height: 100vh;
  background: #f5f6fb;
}

.help-doc-header {
  position: sticky;
  top: 0;
  z-index: 20;
  backdrop-filter: blur(18px);
  background: rgba(245, 246, 251, 0.84);
  border-bottom: 1px solid rgba(216, 221, 231, 0.9);
}

.help-doc-header-inner {
  max-width: 1240px;
  margin: 0 auto;
  padding: 14px 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.help-doc-back,
.help-doc-open {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  min-height: 40px;
  padding: 0 14px;
  border-radius: 999px;
  text-decoration: none;
  font-weight: 700;
}

.help-doc-back {
  color: #4d5668;
  background: rgba(255, 255, 255, 0.8);
  border: 1px solid rgba(216, 221, 231, 0.9);
}

.help-doc-open {
  color: #fff8f0;
  background: linear-gradient(180deg, #c7643f 0%, #b45433 100%);
}

.help-doc-main {
  max-width: 1240px;
  margin: 0 auto;
  padding: 24px 20px 30px;
}

.help-doc-meta {
  margin-bottom: 18px;
}

.help-doc-category {
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

.help-doc-title {
  margin: 12px 0 8px;
  font-size: clamp(1.6rem, 3vw, 2.4rem);
  line-height: 1.08;
  font-weight: 800;
  color: #1d2430;
}

.help-doc-summary {
  margin: 0;
  color: #5a6477;
}

.help-doc-frame-wrap {
  overflow: hidden;
  border-radius: 22px;
  border: 1px solid rgba(223, 227, 235, 0.95);
  background: #fff;
  box-shadow: 0 18px 36px rgba(89, 96, 125, 0.12);
}

.help-doc-frame {
  display: block;
  width: 100%;
  height: calc(100vh - 210px);
  border: 0;
}

.help-doc-empty {
  min-height: 320px;
  border-radius: 24px;
  border: 1px solid rgba(233, 235, 241, 0.9);
  background: rgba(255, 255, 255, 0.82);
  display: flex;
  flex-direction: column;
  gap: 14px;
  align-items: center;
  justify-content: center;
  color: #6b7486;
}

@media (max-width: 640px) {
  .help-doc-header-inner,
  .help-doc-main {
    padding-left: 14px;
    padding-right: 14px;
  }

  .help-doc-frame {
    height: calc(100vh - 230px);
  }
}
</style>
