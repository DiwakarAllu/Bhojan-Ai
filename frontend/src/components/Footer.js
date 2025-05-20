import "../styles/Footer.css"; // Import CSS file

export default function Footer() {
  return (
    <footer className="footer-container">
      <div className="footer-content">
        <p className="footer-text">© {new Date().getFullYear()} Bhojan-AI. All rights reserved.</p>
        <div className="footer-links">
          <a href="/privacy" className="footer-link">Privacy Policy</a>
          <a href="/terms" className="footer-link">Terms of Service</a>
          <a href="/contact" className="footer-link">Contact Us</a>
        </div>
      </div>
    </footer>
  );
}
