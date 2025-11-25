import { apiClient } from './core/apiClient';

export const scriptService = {
  /**
   * Fetches the script content from the server.
   * @returns The script content as a string.
   */
  async downloadScript(): Promise<string> {
    const response = await apiClient.get('/download-script');
    return response.text();
  },
};
