// src/components/Signup.js
import { useState } from "react";

export default function Signup({ onClose }) {
  const [formData, setFormData] = useState({ name: "", email: "", password: "", confirmPassword: "" });

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (formData.password !== formData.confirmPassword) {
      alert("Passwords do not match!");
      return;
    }
    alert(`Welcome, ${formData.name}!`);
    onClose && onClose();
  };

  return (
    <div className="signup-container">
      <h2 className="form-title">Sign Up</h2>
      <form onSubmit={handleSubmit} className="form">
        <input type="text" name="name" placeholder="Full Name" required onChange={handleChange} className="input" />
        <input type="email" name="email" placeholder="Email" required onChange={handleChange} className="input" />
        <input type="password" name="password" placeholder="Password" required onChange={handleChange} className="input" />
        <input type="password" name="confirmPassword" placeholder="Confirm Password" required onChange={handleChange} className="input" />
        <button type="submit" className="btn">Sign Up</button>
      </form>
    </div>
  );
}
