from app.core.interfaces.llm_provider import LLMProvider
from .openai_provider import OpenAIProvider
from .local_provider import LocalProvider
from .gemini_provider import GeminiProvider

def get_llm_provider(provider_name: str) -> LLMProvider:
    if provider_name == "openai":
        return OpenAIProvider()
    elif provider_name == "local":
        return LocalProvider()
    elif provider_name == "gemini":
        return GeminiProvider()
    else:
        raise ValueError(f"Unknown LLM provider: {provider_name}")
