from fastapi import APIRouter
from starlette.responses import FileResponse
from pathlib import Path

from app.schemas.script import ScriptGenerationRequest, ScriptResponse
from app.services.script_service import ScriptService
from fastapi import Depends

router = APIRouter()

@router.post("/generate", response_model=ScriptResponse)
async def generate_script(
    request: ScriptGenerationRequest,
    service: ScriptService = Depends(ScriptService)
):
    """
    Endpoint to generate a custom hardening script.
    """
    script_content = await service.generate_custom_script(request.rule_ids)
    return ScriptResponse(
        content=script_content,
        filename=f"hardening_{request.os_type or 'custom'}.sh"
    )

@router.get("/download-script")
async def download_script():
    """
    Endpoint to download the hardening script.
    """
    script_path = Path("app/static/scripts/hardening_v1.sh")
    if not script_path.exists():
        return {"message": "Script not found"}, 404
    return FileResponse(script_path, media_type="application/x-sh", filename="hardening_v1.sh")
