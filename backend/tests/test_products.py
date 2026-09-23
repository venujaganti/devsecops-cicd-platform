from fastapi.testclient import TestClient

from app.main import app


client = TestClient(app)


def get_token():
    username = "product_test_user"
    password = "TestPassword123!"

    register_response = client.post(
        "/auth/register",
        json={
            "username": username,
            "email": "product_test_user@example.com",
            "password": password,
        },
    )

    assert register_response.status_code in [201, 409]

    login_response = client.post(
        "/auth/login",
        json={
            "username": username,
            "password": password,
        },
    )

    assert login_response.status_code == 200

    return login_response.json()["access_token"]


def test_create_product():
    token = get_token()

    response = client.post(
        "/products/",
        headers={
            "Authorization": f"Bearer {token}"
        },
        json={
            "name": "Test Product",
            "description": "Product created during testing",
            "price": 99.99,
            "stock": 10,
        },
    )

    assert response.status_code == 201

    data = response.json()

    assert data["name"] == "Test Product"
    assert data["price"] == 99.99
    assert data["stock"] == 10


def test_products_require_authentication():
    response = client.get("/products/")

    assert response.status_code == 401
    