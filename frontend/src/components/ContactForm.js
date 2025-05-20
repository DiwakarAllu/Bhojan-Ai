import { useState } from "react";
import Swal from "sweetalert2";
import "../styles/ContactForm.css";

export default function ContactForm() {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    message: "",
  });
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
        const response = await fetch(
          "https://formsubmit.co/75ab42d2f83b35de4da2415509950ba8",
          {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              Accept: "application/json",
            },
            body: JSON.stringify({
              name: formData.name,
              email: formData.email,
              message: formData.message,
              _captcha: false,
            }),
          }
        );

        if (response.ok) {
          Swal.fire({
            title: `Thank you, ${formData.name}!`,
            text: "Your message has been sent successfully.",
            icon: "success",
            confirmButtonText: "Close",
          });
          setFormData({ name: "", email: "", message: "" });
        } else {
          throw new Error("Failed to send message");
        }
      } catch (error) {
        Swal.fire({
          title: "Oops!",
          text: "Something went wrong. Please try again later.",
          icon: "error",
          confirmButtonText: "Okay",
        });
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
        <input
          type="hidden"
          name="_subject"
          value="Message from BhojanAI Site"
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

        <button
          type="submit"
          className="contact-button"
          disabled={isSubmitting}
        >
          {isSubmitting ? "Submitting..." : "Submit"}
        </button>
      </form>
    </div>
  );
}
