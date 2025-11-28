from pydantic import BaseModel
from typing import List, Optional
from enum import Enum

class OSType(str, Enum):
    UBUNTU = "ubuntu"
    DEBIAN = "debian"
    WINDOWS = "windows"
    CENTOS = "centos"
    FEDORA = "fedora"

class RuleBase(BaseModel):
    id: str
    title: str
    section: str
    os: OSType
    description: Optional[str] = None
    audit: str
    remediation: str

class ScriptGenerationRequest(BaseModel):
    rule_ids: List[str]
    os_type: Optional[OSType] = None

class ScriptResponse(BaseModel):
    content: str
    filename: str
