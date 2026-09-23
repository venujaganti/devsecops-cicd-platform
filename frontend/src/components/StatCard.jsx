function StatCard({ title, value, description, icon }) {
  return (
    <div className="stat-card">
      <div className="stat-card-header">
        <span>{title}</span>
        {icon}
      </div>

      <div className="stat-card-value">
        {value}
      </div>

      {description && (
        <p className="stat-card-description">
          {description}
        </p>
      )}
    </div>
  );
}

export default StatCard;