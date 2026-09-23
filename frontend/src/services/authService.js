import api from "./api";

export async function loginUser(username, password) {
  const response = await api.post("/auth/login", {
    username,
    password
  });

  return response.data;
}

export async function getCurrentUser() {
  const response = await api.get("/users/me");
  return response.data;
}

export function logoutUser() {
  localStorage.removeItem("token");
}
