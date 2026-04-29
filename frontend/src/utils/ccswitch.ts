export function normalizeCcsBaseUrl(value: string): string {
  return value.trim().replace(/\/+$/, '')
}

export function buildCcsUsageScript(): string {
  return `({
    request: {
      url: (() => {
        const baseUrl = "{{baseUrl}}".trim().replace(/\\/+$/, "");
        return /\\/v1$/i.test(baseUrl) ? \`\${baseUrl}/usage\` : \`\${baseUrl}/v1/usage\`;
      })(),
      method: "GET",
      headers: { "Authorization": "Bearer {{apiKey}}" }
    },
    extractor: function(response) {
      const remaining = response?.remaining ?? response?.quota?.remaining ?? response?.balance;
      const unit = response?.unit ?? response?.quota?.unit ?? "USD";
      return {
        isValid: response?.is_active ?? response?.isValid ?? true,
        remaining,
        unit
      };
    }
  })`
}
