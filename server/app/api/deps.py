from app.core.interfaces.llm_provider import LLMProvider
from app.infrastructure.llm.factory import get_llm_provider
from app.services.chat_service import ChatService
from app.core.config import settings
import os

def get_llm_service() -> ChatService:
    # In a real app, this could come from config, headers, etc.
    provider_name = settings.LLM_PROVIDER
    llm_provider = get_llm_provider(provider_name)
    return ChatService(llm_provider)
