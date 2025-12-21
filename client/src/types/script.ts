export interface ScriptGenerationRequest {
  rule_ids: string[];
}

export interface ScriptResponse {
  content: string;
  filename: string;
}
