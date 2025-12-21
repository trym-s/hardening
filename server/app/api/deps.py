from fastapi import Depends, Query, HTTPException
from pathlib import Path
from app.core.interfaces.llm_provider import LLMProvider
from app.infrastructure.llm.factory import get_llm_provider
from app.services.chat_service import ChatService
from app.services.rule_service import RuleService
from app.services.script_service import ScriptService
from app.core.config import settings
import os

def get_llm_service() -> ChatService:
    # In a real app, this could come from config, headers, etc.
    provider_name = settings.LLM_PROVIDER
    llm_provider = get_llm_provider(provider_name)
    return ChatService(llm_provider)

# DÜZELTME: Dosya yolunu deps.py dosyasının konumuna göre dinamik olarak belirliyoruz.
# deps.py konumu: .../server/app/api/deps.py
# Hedef: .../server/app/static/hardening_rules/src/platforms
# .parent -> api
# .parent.parent -> app
PLATFORMS_DIR = Path(__file__).resolve().parent.parent / "static" / "hardening_rules" / "src" / "platforms"

def get_platform(
    platform: str = Query(
        ..., 
        description="Platform identifier (e.g., 'linux/ubuntu/server' or 'windows/desktop/win11')",
        example="linux/ubuntu/server"
    )
) -> str:
    """Dependency to get and validate the platform path."""
    platform_path = PLATFORMS_DIR / platform
    
    # Debug için (gerekirse açabilirsiniz)
    # print(f"DEBUG: Checking platform path: {platform_path}")
    
    if not platform_path.is_dir():
        raise HTTPException(
            status_code=404,
            detail=f"Platform '{platform}' not found. Check the available platforms.",
        )
    return platform

def get_rule_service(platform: str = Depends(get_platform)) -> RuleService:
    """Dependency to get a RuleService instance for a specific platform."""
    return RuleService(platform=platform)

def get_script_service(platform: str = Depends(get_platform)) -> ScriptService:
    """Dependency to get a ScriptService instance for a specific platform."""
    return ScriptService(platform=platform)
