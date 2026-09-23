import {
  createContext,
  useCallback,
  useEffect,
  useMemo,
  useState
} from "react";

import {
  loginUser,
  logoutUser,
  getCurrentUser
} from "../services/authService";

export const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  const loadUser = useCallback(async () => {
    try {
      const token = localStorage.getItem("token");

      if (!token) {
        setUser(null);
        return;
      }

      const currentUser = await getCurrentUser();
      setUser(currentUser);
    } catch {
      localStorage.removeItem("token");
      setUser(null);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    loadUser();
  }, [loadUser]);

  const login = async (username, password) => {
    const response = await loginUser(username, password);

    if (response?.access_token) {
      localStorage.setItem("token", response.access_token);
    }

    const currentUser = await getCurrentUser();
    setUser(currentUser);

    return response;
  };

  const logout = () => {
    logoutUser();
    setUser(null);
  };

  const value = useMemo(
    () => ({
      user,
      loading,
      isAuthenticated: Boolean(user),
      login,
      logout
    }),
    [user, loading]
  );

  return (
    <AuthContext.Provider value={value}>
      {children}
    </AuthContext.Provider>
  );
}
