import { apiClient } from "./core/apiClient";
import * as RulesTypes from "../types/rule";

export const rulesService = {
  /**
   * Fetches all hardening rules for a specific platform, grouped by section.
   * @param platform The platform identifier (e.g., 'linux/ubuntu/server').
   * @returns A promise that resolves to the platform's rules, grouped by section.
   */
  async getRulesForPlatform(
    platform: string
  ): Promise<RulesTypes.PlatformRules> {
    const response = await apiClient.get(`/rules/?platform=${platform}`); // Added trailing slash here
    return response.json();
  },
};
