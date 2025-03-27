import "../styles/HowItWorks.css"; // Import the CSS file

export default function HowItWorks() {
  const steps = [
    { id: 1, title: "Upload Food Image", description: "Choose an image of your meal from your device." },
    { id: 2, title: "AI Analysis", description: "Our AI processes the image to estimate protein content." },
    { id: 3, title: "Get Instant Results", description: "See the protein content of your meal instantly!" },
  ];

  return (
    <div className="how-it-works-container">
      <h2 className="section-title">How It Works</h2>


      <div className="steps-grid">
        {steps.map((step) => (
          <div key={step.id} className="step-card">
            <h3 className="step-title">{step.title}</h3>
            <p className="step-description">{step.description}</p>
          </div>
        ))}
      </div>
    </div>
  );
}
