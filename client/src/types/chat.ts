export interface ChatRequest {
  message: string;
}

// The response is a stream, so we don't have a single static type for the whole response.
// The consumer will handle the stream of strings.
