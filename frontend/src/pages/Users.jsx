import { useEffect, useState } from "react";

import Header from "../components/Header";
import Sidebar from "../components/Sidebar";
import Navbar from "../components/Navbar";
import UserTable from "../components/UserTable";
import LoadingSpinner from "../components/LoadingSpinner";
import ErrorMessage from "../components/ErrorMessage";

import { getUsers } from "../services/userService";

function Users() {
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    async function loadUsers() {
      try {
        const data = await getUsers();
        setUsers(data);
      } catch {
        setError("Unable to load users.");
      } finally {
        setLoading(false);
      }
    }

    loadUsers();
  }, []);

  return (
    <div className="app-layout">
      <Sidebar />

      <div className="main-area">
        <Navbar />
        <Header />

        <main className="page-content">
          <h2>Users</h2>
          <p>Platform users and access roles.</p>

          {loading && <LoadingSpinner />}

          {error && <ErrorMessage message={error} />}

          {!loading && !error && (
            <UserTable users={users} />
          )}
        </main>
      </div>
    </div>
  );
}

export default Users;