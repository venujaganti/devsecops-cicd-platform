import api from "./api";

export async function getUsers() {
  const response = await api.get("/users/");
  return response.data.map((user) => ({
    ...user,
    name: user.username,
    role: user.username === "admin" ? "Administrator" : "User",
    status: user.is_active ? "Active" : "Inactive"
  }));
}
