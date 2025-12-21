export interface Rule {
  id: string;
  title: string;
  section: string;
  description?: string;
  audit: string;
  remediation: string | null;
}

/**
 * Represents rules for a single platform, grouped by section.
 * e.g., { "Section 1": [rule1, rule2], "Section 2": [rule3] }
 */
export type PlatformRules = {
  [section: string]: Rule[];
};
