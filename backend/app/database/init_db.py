from app.database.connection import Base, engine

# Import models so SQLAlchemy knows about them.
from app.models import Product, User  # noqa: F401


def init_db() -> None:
    Base.metadata.create_all(bind=engine)