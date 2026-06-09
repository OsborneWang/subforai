import { beforeEach, describe, expect, it, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import { createPinia, setActivePinia } from 'pinia'
import { createI18n } from 'vue-i18n'
import HomeView from '../HomeView.vue'

vi.mock('@/composables/useClipboard', () => ({
  useClipboard: () => ({ copyToClipboard: vi.fn() })
}))

const routerLinkStub = {
  props: ['to'],
  template: '<a><slot /></a>'
}

function mountHome(locale = 'zh') {
  const i18n = createI18n({
    legacy: false,
    locale,
    fallbackLocale: 'en',
    messages: {
      zh: {
        home: {
          officialEntrances: {
            qqGroup: '交流群',
            qqGroupDesc: '用于内部交流和学习讨论',
            qqGroupOpen: '查看交流入口',
            xianyuShops: '资料入口',
            xianyuShop: '资料入口',
            xianyuShopDesc: '内部资料说明',
            xianyuShopOpen: '查看资料'
          }
        }
      },
      en: {
        home: {
          officialEntrances: {
            qqGroup: 'Study group',
            qqGroupDesc: 'For internal learning discussion',
            qqGroupOpen: 'View discussion entry',
            xianyuShops: 'Resources',
            xianyuShop: 'Resources',
            xianyuShopDesc: 'Internal resources',
            xianyuShopOpen: 'View resources'
          }
        }
      }
    }
  })

  return mount(HomeView, {
    global: {
      plugins: [i18n],
      stubs: {
        RouterLink: routerLinkStub,
        Icon: true
      }
    }
  })
}

describe('HomeView', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    localStorage.clear()
  })

  it('presents the default Chinese homepage as internal learning exchange instead of external sales', () => {
    const wrapper = mountHome('zh')
    const text = wrapper.text()

    expect(text).toContain('仅供内部交流学习使用')
    expect(text).toContain('不面向公众销售')
    expect(text).toContain('内部资料')
    expect(text).not.toContain('立即开始')
    expect(text).not.toContain('购买')
    expect(text).not.toContain('店铺')
    expect(text).not.toContain('售后')
  })
})
