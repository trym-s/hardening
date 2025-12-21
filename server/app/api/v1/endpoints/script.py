from fastapi import APIRouter, Depends, HTTPException
from starlette.responses import FileResponse
from pathlib import Path

from app.schemas.script import ScriptGenerationRequest, ScriptResponse
from app.services.script_service import ScriptService
from app.api.deps import get_script_service

router = APIRouter()

@router.post("/generate", response_model=ScriptResponse)
async def generate_script(
    request: ScriptGenerationRequest,
    service: ScriptService = Depends(get_script_service)
):
    """
    Endpoint to generate a custom hardening script for a specific platform.
    Requires a 'platform' query parameter.
    """
    try:
        script_content = await service.generate_custom_script(request.rule_ids)
    except FileNotFoundError as e:
        raise HTTPException(status_code=404, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Script generation failed: {str(e)}")
    
    # DÜZELTME: service.platform string değerini kullanıyoruz.
    # Örn: "linux/ubuntu/desktop" -> "linux-ubuntu-desktop"
    safe_platform_name = service.platform.replace("/", "-").replace("\\", "-")

    return ScriptResponse(
        content=script_content,
        filename=f"hardening_{safe_platform_name}.sh"
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
