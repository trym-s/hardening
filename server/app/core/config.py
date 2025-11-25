from pydantic_settings import BaseSettings
from typing import Optional
from dotenv import load_dotenv
import os

# Construct the path to the .env file.
# It assumes this config.py file is located at server/app/core/config.py
# and the .env file is at server/.env
dotenv_path = os.path.join(os.path.dirname(__file__), '..', '..', '.env')
load_dotenv(dotenv_path=dotenv_path)

class Settings(BaseSettings):
    PROJECT_NAME: str = "Hardening Project"
    API_V1_STR: str = "/api/v1"
    GEMINI_API_KEY: Optional[str] = None
    LLM_PROVIDER: Optional[str] = "openai"
    GEMINI_MODEL: Optional[str] = "gemini-2.5-flash-lite"

settings = Settings()
