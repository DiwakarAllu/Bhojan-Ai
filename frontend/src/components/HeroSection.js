import React from "react";
import "../styles/HeroSection.css";
//import heroImage from "../assets/Hero-Image1 SDP.jpg";

const HeroSection = () => {
  return (
    <section className="hero">
      <div className="bg-video" style={{ width: "100%", height: "100%" }}>
        <video
          preload="auto"
          autoPlay
          loop
          muted 
          style={{ objectFit: "cover", width: "100%", height: "100%" }}
        >
          <source
            src="https://videos.pexels.com/video-files/3198159/3198159-hd_1920_1080_25fps.mp4"
            type="video/mp4"
          />
          Your browser does not support the video tag.
        </video>
      </div>

      <div className="hero-overlay">
        <h1>Welcome to Bhojan-AI</h1>
        <p>Experience AI-driven food recommendations</p>
        <button className="hero-btn">Get Started</button>
      </div>
    </section>
  );
};

export default HeroSection;
