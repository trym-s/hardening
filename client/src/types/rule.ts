import { OSType } from './os';

export interface Rule {
  id: string;
  title: string;
  section: string;
  os: OSType;
  description?: string;
  audit: string;
  remediation: string;
}

export type GroupedRules = {
  [os in OSType]?: {
    [section: string]: Rule[];
  };
};
