from typing import AsyncGenerator
from app.core.interfaces.llm_provider import LLMProvider

class LocalProvider(LLMProvider):
    async def generate_stream(self, prompt: str) -> AsyncGenerator[str, None]:
        # This is a mock implementation for a local model
        for i in range(5):
            yield f"Local LLM response chunk {i} for prompt: '{prompt}'\n"
