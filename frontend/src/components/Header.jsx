import { useAuth } from "../hooks/useAuth";

function Header() {
  const { user } = useAuth();

  return (
    <header className="header">
      <div>
        <h1>DevSecOps CI/CD Platform</h1>
        <p>Secure software delivery and infrastructure management</p>
      </div>

      <div className="header-user">
        <strong>{user?.name || "User"}</strong>
      </div>
    </header>
  );
}

export default Header;