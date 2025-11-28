import { apiClient } from "./core/apiClient";
import * as ScriptsTypes from "../types/script";
export const scriptService = {
  /**
   * Fetches the script content from the server.
   * @returns The script content as a string.
   */
  async downloadScript(): Promise<string> {
    const response = await apiClient.get("/download-script");
    return response.text();
  },

  /**
   * Generates a custom script based on selected rules.
   * @param request The script generation request object.
   * @returns The generated script content and filename.
   */
  async generateCustomScript(
    request: ScriptsTypes.ScriptGenerationRequest,
  ): Promise<ScriptsTypes.ScriptResponse> {
    const response = await apiClient.post("/script/generate", request);
    return response.json();
  },
};
