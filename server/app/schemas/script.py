from pydantic import BaseModel
from typing import List, Optional
from enum import Enum

class RuleBase(BaseModel):
    id: str
    title: str
    section: str
    description: Optional[str] = None
    audit: str
    remediation: Optional[str] # Can be null for audit-only rules

class ScriptGenerationRequest(BaseModel):
    rule_ids: List[str]

class ScriptResponse(BaseModel):
    content: str
    filename: str
