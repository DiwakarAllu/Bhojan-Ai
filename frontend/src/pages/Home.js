// src/pages/Home.js
import HeroSection from "../components/HeroSection";
import UploadSection from "../components/UploadSection";
import HowItWorks from "../components/HowItWorks";
import HealthInsights from "../components/HealthInsights";
import Testimonials from "../components/Testimonials";
import ContactForm from "../components/ContactForm";


export default function Home() {
  return (
    <div>
      <HeroSection />
      <HowItWorks />
      <UploadSection />
      <HealthInsights />
      <Testimonials />
      <ContactForm />
    </div>
  );
}
