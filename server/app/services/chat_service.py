from app.core.interfaces.llm_provider import LLMProvider
from typing import AsyncGenerator

class ChatService:
    def __init__(self, llm_provider: LLMProvider):
        self.llm_provider = llm_provider

    async def generate_response_stream(self, prompt: str) -> AsyncGenerator[str, None]:
        return self.llm_provider.generate_stream(prompt)
