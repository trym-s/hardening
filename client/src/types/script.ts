import { OSType } from './os';

export interface ScriptGenerationRequest {
  rule_ids: string[];
  os_type?: OSType;
}

export interface ScriptResponse {
  content: string;
  filename: string;
}
