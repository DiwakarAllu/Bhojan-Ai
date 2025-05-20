import React, { useContext } from "react";
import { AuthContext } from "../context/AuthContext"; 
import "../styles/Navbar.css";
import logo from "../assets/Bhojan-AI Logo.png";
import axios from "axios";
import { useEffect } from "react";
// import Swal from "sweetalert2";



const Navbar = () => {
  const { isLoggedIn, setIsLoggedIn } = useContext(AuthContext);

  const handleLogout = () => {
    localStorage.removeItem("token");
    setIsLoggedIn(false);
    alert("You have logged out.");
    /*
    - i have to fix this later
      Swal.fire({
      title: 'Are you sure you want to logout?',
      showDenyButton: true,
      confirmButtonText: `Yes`,
      denyButtonText: `No`,
    }).then((result) => {
      if (result.isConfirmed) {
        localStorage.removeItem("token");
        setIsLoggedIn(false);
        Swal.fire('Logged Out!', '', 'success')
      } else if (result.isDenied) {
        Swal.fire('You are still logged in', '', 'info')
      }
    })
    */
  };

   const validateToken = async () => {
     const token = localStorage.getItem("token");
     if (!token) {
       console.error("No token found");
       return false;
     }
     try {
       const response = await axios.post(
         "http://localhost:5000/auth/validate-token",
         { token }
       );
       if (response.data.valid) {
         console.log("Token is valid");
         return true;
       } else {
         console.error(response.data.message);
         return false;
       }
     } catch (error) {
       console.error(
         "Error validating token:",
         error.response?.data?.message || error.message
       );
       return false;
     }
   };

  useEffect(() => {
    const checkAuthStatus = async () => {
      const isValid = await validateToken();
      setIsLoggedIn(isValid); 
    };
    checkAuthStatus();
  }, [setIsLoggedIn]);

  
  return (
    <nav className="navbar">
      <div className="nav-left">
        <a href="/">Home</a>
        <a href="/services">Our Services</a>
      </div>
      <div className="nav-center">
        <img src={logo} alt="Bhojan-AI Logo" className="logo" />
        <span className="brand-name">Bhojan-AI</span>
      </div>
      <div className="nav-right">
        {isLoggedIn ? (
          <a href="/" onClick={handleLogout}>
            Logout
          </a>
        ) : (
          <>
            <a href="/login">Login</a>
            <a href="/signup">Sign Up</a>
          </>
        )}
      </div>
    </nav>
  );
};

export default Navbar;
