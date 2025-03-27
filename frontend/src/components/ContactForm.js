import { useState } from "react";
import "../styles/ContactForm.css"; // Import the CSS file

export default function ContactForm() {
  const [formData, setFormData] = useState({ name: "", email: "", message: "" });
  const [errors, setErrors] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  const validateForm = () => {
    let errors = {};
    if (!formData.name.trim()) errors.name = "Name is required";
    if (!formData.email.trim()) {
      errors.email = "Email is required";
    } else if (!/\S+@\S+\.\S+/.test(formData.email)) {
      errors.email = "Enter a valid email address";
    }
    if (!formData.message.trim()) errors.message = "Message cannot be empty";
    return errors;
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const validationErrors = validateForm();
    setErrors(validationErrors);

    if (Object.keys(validationErrors).length === 0) {
      setIsSubmitting(true);
      
      try {
        // Simulated API call (Replace with actual API request)
        await new Promise((resolve) => setTimeout(resolve, 2000));
        alert(`Thanks for reaching out, ${formData.name}! We will get back to you soon.`);
        setFormData({ name: "", email: "", message: "" }); // Clear form
      } catch (error) {
        alert("Something went wrong! Please try again.");
      } finally {
        setIsSubmitting(false);
      }
    }
  };

  return (
    <div className="contact-container">
      <h2 className="contact-title">Contact Us</h2>

      <form onSubmit={handleSubmit} className="contact-form">
        <input
          type="text"
          name="name"
          placeholder="Your Name"
          value={formData.name}
          className={`contact-input ${errors.name ? "input-error" : ""}`}
          onChange={handleChange}
        />
        {errors.name && <p className="error-message">{errors.name}</p>}

        <input
          type="email"
          name="email"
          placeholder="Your Email"
          value={formData.email}
          className={`contact-input ${errors.email ? "input-error" : ""}`}
          onChange={handleChange}
        />
        {errors.email && <p className="error-message">{errors.email}</p>}

        <textarea
          name="message"
          placeholder="Your Message"
          value={formData.message}
          className={`contact-textarea ${errors.message ? "input-error" : ""}`}
          onChange={handleChange}
        ></textarea>
        {errors.message && <p className="error-message">{errors.message}</p>}

        <button type="submit" className="contact-button" disabled={isSubmitting}>
          {isSubmitting ? "Submitting..." : "Submit"}
        </button>
      </form>
    </div>
  );
}
