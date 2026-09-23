import { NavLink, useNavigate } from "react-router-dom";
import {
  LayoutDashboard,
  Users,
  Package,
  User,
  Settings,
  LogOut
} from "lucide-react";

import { useAuth } from "../hooks/useAuth";

function Sidebar() {
  const { logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  return (
    <aside className="sidebar">
      <div className="sidebar-logo">
        <img src="/logo.svg" alt="DevSecOps" />
        <span>DevSecOps</span>
      </div>

      <nav className="sidebar-nav">
        <NavLink to="/dashboard">
          <LayoutDashboard size={18} />
          Dashboard
        </NavLink>

        <NavLink to="/users">
          <Users size={18} />
          Users
        </NavLink>

        <NavLink to="/products">
          <Package size={18} />
          Applications
        </NavLink>

        <NavLink to="/profile">
          <User size={18} />
          Profile
        </NavLink>

        <NavLink to="/settings">
          <Settings size={18} />
          Settings
        </NavLink>
      </nav>

      <button
        className="logout-button"
        onClick={handleLogout}
      >
        <LogOut size={18} />
        Logout
      </button>
    </aside>
  );
}

export default Sidebar;