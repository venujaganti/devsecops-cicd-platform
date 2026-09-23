import pytest

from app.database.init_db import init_db


@pytest.fixture(scope="session", autouse=True)
def initialize_database():
    """Create test database tables before the test suite runs."""
    init_db()
    yield
