import { apiClient } from "./core/apiClient";
import * as ChatTypes from "../types";
export const chatService = {
  /**
   * Sends a chat message and returns the response stream.
   * @param request The chat request object.
   * @returns A ReadableStream of the response.
   */
  async streamChatResponse(
    request: ChatTypes.ChatRequest,
  ): Promise<ReadableStream<Uint8Array> | null> {
    const response = await apiClient.post("/chat", request);
    return response.body;
  },
};
