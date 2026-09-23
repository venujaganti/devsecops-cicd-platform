import {
  Activity,
  Server,
  ShieldCheck,
  GitBranch
} from "lucide-react";

import Header from "../components/Header";
import Sidebar from "../components/Sidebar";
import StatCard from "../components/StatCard";
import Navbar from "../components/Navbar";

function Dashboard() {
  return (
    <div className="app-layout">
      <Sidebar />

      <div className="main-area">
        <Navbar />

        <Header />

        <main className="page-content">
          <section className="page-heading">
            <div>
              <h2>Dashboard</h2>
              <p>
                Overview of your DevSecOps platform.
              </p>
            </div>
          </section>

          <section className="stats-grid">
            <StatCard
              title="Applications"
              value="12"
              description="Currently registered"
              icon={<Activity size={22} />}
            />

            <StatCard
              title="Active Servers"
              value="8"
              description="Healthy infrastructure"
              icon={<Server size={22} />}
            />

            <StatCard
              title="Security Status"
              value="Healthy"
              description="No critical findings"
              icon={<ShieldCheck size={22} />}
            />

            <StatCard
              title="Pipelines"
              value="24"
              description="Successful deployments"
              icon={<GitBranch size={22} />}
            />
          </section>

          <section className="dashboard-grid">
            <div className="panel">
              <h3>Recent Deployments</h3>

              <div className="deployment-list">
                <div>
                  <strong>Frontend</strong>
                  <span>Production · Successful</span>
                </div>

                <div>
                  <strong>Backend API</strong>
                  <span>Development · Successful</span>
                </div>

                <div>
                  <strong>Monitoring Service</strong>
                  <span>Development · Running</span>
                </div>
              </div>
            </div>

            <div className="panel">
              <h3>Security Checks</h3>

              <ul className="security-list">
                <li>✓ Dependency scan completed</li>
                <li>✓ Container scan completed</li>
                <li>✓ Code quality check completed</li>
                <li>✓ Kubernetes configuration checked</li>
              </ul>
            </div>
          </section>
        </main>
      </div>
    </div>
  );
}

export default Dashboard;