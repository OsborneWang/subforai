import { describe, expect, it } from 'vitest'

import { buildCcsUsageScript, normalizeCcsBaseUrl } from '../ccswitch'

describe('ccswitch utils', () => {
  it('removes trailing slashes from base urls', () => {
    expect(normalizeCcsBaseUrl(' https://subforai.com/v1/ ')).toBe('https://subforai.com/v1')
    expect(normalizeCcsBaseUrl('https://subforai.com///')).toBe('https://subforai.com')
  })

  it('builds a usage script that avoids duplicating the v1 suffix', () => {
    const script = buildCcsUsageScript()

    expect(script).toContain('return /\\/v1$/i.test(baseUrl) ? `${baseUrl}/usage` : `${baseUrl}/v1/usage`;')
    expect(script).toContain('response?.remaining ?? response?.quota?.remaining ?? response?.balance')
  })
})
