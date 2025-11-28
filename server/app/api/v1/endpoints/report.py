from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def report():
    return {"message": "Jinja2 reporting endpoint"}
