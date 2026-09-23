from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api import auth, products, users
from app.config import settings
from app.database.init_db import init_db


@asynccontextmanager
async def lifespan(app: FastAPI):
    init_db()
    yield


app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    debug=settings.DEBUG,
    lifespan=lifespan,
)


app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins_list,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get(
    "/",
    tags=["Health"],
)
def root():
    return {
        "message": "DevSecOps CI/CD Platform API",
        "version": settings.APP_VERSION,
        "status": "running",
    }


@app.get(
    "/health",
    tags=["Health"],
)
def health_check():
    return {
        "status": "healthy",
    }


app.include_router(auth.router)
app.include_router(users.router)
app.include_router(products.router)