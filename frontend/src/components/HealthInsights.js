import "../styles/HealthInsights.css"; // Import the CSS file

export default function HealthInsights() {
  const articles = [
    { id: 1, title: "Protein & Muscle Growth", description: "How protein intake affects muscle building." },
    { id: 2, title: "Healthy Eating Habits", description: "Tips to maintain a balanced diet with proper nutrition." },
    { id: 3, title: "AI in Nutrition", description: "How AI is revolutionizing diet and health monitoring." },
  ];

  return (
    <div className="health-insights-container">
      <h2 className="section-title">Health & Nutrition Insights</h2>

      <div className="articles-grid">
        {articles.map((article) => (
          <div key={article.id} className="article-card">
            <h3 className="article-title">{article.title}</h3>
            <p className="article-description">{article.description}</p>
            <button className="read-more-btn">Read More</button>
          </div>
        ))}
      </div>
    </div>
  );
}
