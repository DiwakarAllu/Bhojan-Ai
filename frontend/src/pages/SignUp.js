import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "../styles/Auth.css";
// sweet alert
import Swal from "sweetalert2";

const Signup = () => {
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();

  const handleSignup = async (e) => {
    e.preventDefault();

    try {
      const response = await fetch("http://127.0.0.1:5000/auth/signup", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ username: name, email, password }), 
      });

      const data = await response.json();

      if (response.ok) {
        console.log("Signup successful:", data);
        //alert("Signup successful! Please log in.");
        Swal.fire({
          title: "Signup successful!",
          text: "Please log in.",
          icon: "success",
          confirmButtonText: "Okay",
        }).then((result) => {
          if (result.isConfirmed) {
            navigate("/login");
          }
        });
     //   navigate("/login"); 
      } else {
        console.error("Signup failed:", data.error || "Unknown error");
        alert(data.error || "Signup failed. Please try again.");
      }
    } catch (error) {
      console.error("Error during signup:", error);
      alert("Something went wrong. Please try again.");
    }
  };

  return (
    <div className="auth-container">
      <h2>Sign Up</h2>
      <form onSubmit={handleSignup}>
        <label>Name:</label>
        <input
          type="text"
          placeholder="Enter your name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          required
        />

        <label>Email:</label>
        <input
          type="email"
          placeholder="Enter your email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          required
        />

        <label>Password:</label>
        <input
          type="password"
          placeholder="Enter your password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          required
        />

        <button type="submit">Sign Up</button>
      </form>
      <p>
        Already have an account? <a href="/login">Login</a>
      </p>
    </div>
  );
};

export default Signup;
