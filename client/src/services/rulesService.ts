import { apiClient } from "./core/apiClient";
import * as RulesTypes from "../types/rule";

export const rulesService = {
  /**
   * Fetches all hardening rules, grouped by OS and section.
   * @returns A promise that resolves to the grouped rules.
   */
  async getGroupedRules(): Promise<RulesTypes.GroupedRules> {
    const response = await apiClient.get("/rules");
    return response.json();
  },
};
