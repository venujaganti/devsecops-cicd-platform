import { Link } from "react-router-dom";

function Navbar() {
  return (
    <nav className="navbar">
      <Link to="/dashboard">Dashboard</Link>
      <Link to="/users">Users</Link>
      <Link to="/products">Applications</Link>
      <Link to="/profile">Profile</Link>
      <Link to="/settings">Settings</Link>
    </nav>
  );
}

export default Navbar;