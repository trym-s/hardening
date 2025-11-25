import { apiClient } from './core/apiClient';

export const reportService = {
  /**
   * Fetches the HTML report from the server.
   * @returns The report content as a string.
   */
  async getReport(): Promise<string> {
    const response = await apiClient.get('/report');
    return response.text();
  },
};
