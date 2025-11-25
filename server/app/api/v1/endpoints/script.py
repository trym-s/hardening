from fastapi import APIRouter
from starlette.responses import FileResponse
from pathlib import Path

router = APIRouter()

@router.get("/download-script")
async def download_script():
    """
    Endpoint to download the hardening script.
    """
    script_path = Path("app/static/scripts/hardening_v1.sh")
    if not script_path.exists():
        return {"message": "Script not found"}, 404
    return FileResponse(script_path, media_type="application/x-sh", filename="hardening_v1.sh")
