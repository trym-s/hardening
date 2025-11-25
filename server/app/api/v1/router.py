from fastapi import APIRouter

from app.api.v1.endpoints import chat, report, script

api_router = APIRouter()
api_router.include_router(chat.router, tags=["chat"])
api_router.include_router(report.router, tags=["report"])
api_router.include_router(script.router, tags=["script"])
