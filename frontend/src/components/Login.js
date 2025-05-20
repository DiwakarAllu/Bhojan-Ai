// src/components/Login.js
import { useState } from "react";

export default function Login({ onClose }) {
  const [formData, setFormData] = useState({ email: "", password: "" });

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    alert(`Welcome back, ${formData.email}!`);
    onClose && onClose(); // Close modal if passed as a prop
  };

  return (
    <div className="login-container">
      <h2 className="form-title">Login</h2>
      <form onSubmit={handleSubmit} className="form">
        <input type="email" name="email" placeholder="Email" required onChange={handleChange} className="input" />
        <input type="password" name="password" placeholder="Password" required onChange={handleChange} className="input" />
        <button type="submit" className="btn">Login</button>
      </form>
    </div>
  );
}
