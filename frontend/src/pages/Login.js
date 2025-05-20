import React, { useState, useContext } from "react";
import { useNavigate } from "react-router-dom";
import "../styles/Auth.css";
import { AuthContext } from "../context/AuthContext";
// sweetalert
import Swal from "sweetalert2";

const Login = () => {
  const { setIsLoggedIn } = useContext(AuthContext);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
  
    try {
      const response = await fetch("http://127.0.0.1:5000/auth/login", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ email, password }),
      });
  
      const data = await response.json();
  
      if (response.ok) {
        console.log("Login successful:", data);
        localStorage.setItem("token", data.token);
        setIsLoggedIn(true); 
        //alert("Login successful!");
        Swal.fire({
          title: 'Login Successful!',
          text: 'You are now logged in.',
          icon:'success',
          confirmButtonText: 'Continue'
        }).then((result) => {
          if (result.isConfirmed) {
            navigate("/");
          }
        });
       // navigate("/"); 
      } else {
        console.error("Login failed:", data.message);
        alert(data.message);
      }
    } catch (error) {
      console.error("Error during login:", error);
      alert("Something went wrong. Please try again.");
    }
  };
  

  return (
    <div className="auth-container">
      <h2>Login</h2>
      <form onSubmit={handleLogin}>
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

        <button type="submit">Login</button>
      </form>
      <p>
        Don't have an account? <a href="/signup">Sign Up</a>
      </p>
    </div>
  );
};

export default Login;
