from typing import AsyncGenerator
from app.core.interfaces.llm_provider import LLMProvider
import os

class OpenAIProvider(LLMProvider):
    def __init__(self):
        # In a real app, you'd initialize the OpenAI client here
        # e.g., self.client = OpenAI(api_key=os.environ.get("OPENAI_API_KEY"))
        pass

    async def generate_stream(self, prompt: str) -> AsyncGenerator[str, None]:
        # This is a mock implementation
        for i in range(10):
            yield f"OpenAI response chunk {i} for prompt: '{prompt}'\n"
