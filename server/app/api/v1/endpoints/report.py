from fastapi import APIRouter

router = APIRouter()

@router.get("/report")
async def report():
    return {"message": "Jinja2 reporting endpoint"}
