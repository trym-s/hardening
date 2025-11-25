from fastapi import APIRouter, Depends
from starlette.responses import StreamingResponse

from app.api.deps import get_llm_service
from app.schemas.chat import ChatRequest
from app.services.chat_service import ChatService

router = APIRouter()

@router.post("/chat")
async def chat(
    request: ChatRequest,
    chat_service: ChatService = Depends(get_llm_service)
):
    """
    Chat endpoint that streams the response from the LLM.
    """
    response_stream = await chat_service.generate_response_stream(request.message)
    return StreamingResponse(response_stream, media_type="text/event-stream")
