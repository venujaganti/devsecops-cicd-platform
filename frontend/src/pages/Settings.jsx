import Header from "../components/Header";
import Sidebar from "../components/Sidebar";
import Navbar from "../components/Navbar";

function Settings() {
  return (
    <div className="app-layout">
      <Sidebar />

      <div className="main-area">
        <Navbar />
        <Header />

        <main className="page-content">
          <h2>Settings</h2>

          <div className="settings-card">
            <h3>Platform Settings</h3>

            <label className="setting-row">
              <span>Enable notifications</span>
              <input type="checkbox" defaultChecked />
            </label>

            <label className="setting-row">
              <span>Enable security alerts</span>
              <input type="checkbox" defaultChecked />
            </label>

            <label className="setting-row">
              <span>Enable deployment notifications</span>
              <input type="checkbox" defaultChecked />
            </label>
          </div>
        </main>
      </div>
    </div>
  );
}

export default Settings;