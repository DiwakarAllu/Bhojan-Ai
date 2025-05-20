import { useState } from "react";
import "../styles/Testimonials.css"; // Import the CSS file

const testimonials = [
  { id: 1, name: "Rohit Sharma", feedback: "This app helped me track my protein intake effortlessly!" },
  { id: 2, name: "Ananya Gupta", feedback: "I love how simple and accurate Bhojan-AI is!" },
  { id: 3, name: "Rahul Verma", feedback: "Great for fitness enthusiasts and health-conscious people." },
];

export default function Testimonials() {
  const [index, setIndex] = useState(0);

  const nextTestimonial = () => {
    setIndex((prev) => (prev + 1) % testimonials.length);
  };

  return (
    <div className="testimonials-container">
      <h2 className="section-title">What Our Users Say</h2>

      <div className="testimonial-card">
        <p className="testimonial-text">"{testimonials[index].feedback}"</p>
        <h4 className="testimonial-name">{testimonials[index].name}</h4>
      </div>

      <button onClick={nextTestimonial} className="next-btn">
        Next
      </button>
    </div>
  );
}
