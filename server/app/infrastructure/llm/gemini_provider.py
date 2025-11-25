from typing import AsyncGenerator
from app.core.interfaces.llm_provider import LLMProvider
import os
import google.generativeai as genai
from app.core.config import settings

class GeminiProvider(LLMProvider):
    def __init__(self):
        self.api_key = settings.GEMINI_API_KEY
        if not self.api_key:
            raise ValueError("GEMINI_API_KEY environment variable not set")
        genai.configure(api_key=self.api_key)
        self.model = genai.GenerativeModel(settings.GEMINI_MODEL)

    async def generate_stream(self, prompt: str) -> AsyncGenerator[str, None]:
        response = await self.model.generate_content_async(prompt, stream=True)
        async for chunk in response:
            yield chunk.text
