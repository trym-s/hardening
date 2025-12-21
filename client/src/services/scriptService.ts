import { apiClient } from "./core/apiClient";
import * as ScriptsTypes from "../types/script";

interface CustomScriptParams {
  platform: string;
  rule_ids: string[];
}

export const scriptService = {
  /**
   * Fetches the script content from the server.
   * @returns The script content as a string.
   */
  async downloadScript(): Promise<string> {
    // This endpoint seems to download a static script, may need review later.
    const response = await apiClient.get("/script/download-script/"); // Added trailing slash
    return response.text();
  },

  /**
   * Generates a custom script based on selected rules for a specific platform.
   * @param params The script generation parameters including platform and rule_ids.
   * @returns The generated script content and filename.
   */
  async generateCustomScript(
    params: CustomScriptParams
  ): Promise<ScriptsTypes.ScriptResponse> {
    const { platform, rule_ids } = params;
    const response = await apiClient.post(
      `/script/generate/?platform=${platform}`, // Added trailing slash
      { rule_ids } // Only send rule_ids in the body
    );
    return response.json();
  },
};
