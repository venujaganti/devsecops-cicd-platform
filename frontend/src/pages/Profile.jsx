import Header from "../components/Header";
import Sidebar from "../components/Sidebar";
import Navbar from "../components/Navbar";
import { useAuth } from "../hooks/useAuth";

function Profile() {
  const { user } = useAuth();

  return (
    <div className="app-layout">
      <Sidebar />

      <div className="main-area">
        <Navbar />
        <Header />

        <main className="page-content">
          <h2>Profile</h2>

          <div className="profile-card">
            <h3>{user?.name || "User"}</h3>

            <p>
              <strong>Username:</strong>{" "}
              {user?.username || "admin"}
            </p>

            <p>
              <strong>Role:</strong>{" "}
              {user?.role || "Administrator"}
            </p>
          </div>
        </main>
      </div>
    </div>
  );
}

export default Profile;