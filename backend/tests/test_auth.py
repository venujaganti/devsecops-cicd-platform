from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def test_register_user():
    response = client.post(
        "/auth/register",
        json={
            "username": "testuser_auth",
            "email": "testuser_auth@example.com",
            "password": "TestPassword123!",
        },
    )

    assert response.status_code in [201, 409]


def test_login_user():
    register_response = client.post(
        "/auth/register",
        json={
            "username": "loginuser",
            "email": "loginuser@example.com",
            "password": "TestPassword123!",
        },
    )

    assert register_response.status_code in [201, 409]

    response = client.post(
        "/auth/login",
        json={
            "username": "loginuser",
            "password": "TestPassword123!",
        },
    )

    assert response.status_code == 200

    data = response.json()

    assert "access_token" in data
    assert data["token_type"] == "bearer"