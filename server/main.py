from fastapi import FastAPI
from fastapi.routing import APIRoute
from starlette.responses import HTMLResponse
from starlette.staticfiles import StaticFiles
from starlette.templating import Jinja2Templates

from app.api.v1.router import api_router

from app.core.config import settings

from fastapi.middleware.cors import CORSMiddleware





def custom_generate_unique_id(route: APIRoute):

    if route.tags:

        return f"{route.tags[0]}-{route.name}"

    return route.name





app = FastAPI(

    title=settings.PROJECT_NAME,

    openapi_url=f"{settings.API_V1_STR}/openapi.json",

    generate_unique_id_function=custom_generate_unique_id,

)



origins = [

    "http://localhost",

    "http://localhost:5173",

    "http://127.0.0.1:5173",

]



app.add_middleware(

    CORSMiddleware,

    allow_origins=origins,

    allow_credentials=True,

    allow_methods=["*"],

    allow_headers=["*"],

)



# Mount static files
app.mount("/static", StaticFiles(directory="app/static"), name="static")

# Templates
templates = Jinja2Templates(directory="app/templates")

@app.get("/")
async def root():
    return {"message": "Hello Hardening Project"}

app.include_router(api_router, prefix=settings.API_V1_STR)
