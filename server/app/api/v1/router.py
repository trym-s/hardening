from fastapi import APIRouter

from app.api.v1.endpoints import chat, report, script, rules

api_router = APIRouter()
api_router.include_router(chat.router, prefix="/chat", tags=["chat"])
api_router.include_router(report.router, prefix="/report", tags=["report"])
api_router.include_router(script.router, prefix="/script", tags=["script"])
api_router.include_router(rules.router, prefix="/rules", tags=["rules"])
