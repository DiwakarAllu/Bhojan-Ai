import { useState } from "react";
import axios from "axios";
import "../styles/UploadSection.css"; // Import the CSS file

export default function UploadSection() {
  const [image, setImage] = useState(null);
  const [preview, setPreview] = useState(null);
  const [prediction, setPrediction] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setImage(file);
      setPreview(URL.createObjectURL(file));
      setPrediction(null); 
      setError(null);
    }
  };

  const handlePredict = async () => {
    if (!image) {
      setError("⚠️ Please upload an image first.");
      return;
    }

    setLoading(true);
    setPrediction(null);
    setError(null);

    const formData = new FormData();
    formData.append("image", image);

    try {
      const response = await axios.post("http://127.0.0.1:5000/predict", formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });

      setPrediction(response.data.prediction);
    } catch (err) {
      setError("❌ Error processing image. Please try again.");
    }

    setLoading(false);
  };

  return (
    <div className="upload-container">
      <h2 className="upload-title">Upload Your Food Image</h2>

      <input type="file" accept="image/*" onChange={handleFileChange} className="file-input" />

      {preview && <img src={preview} alt="Preview" className="image-preview" />}

      <button onClick={handlePredict} className={`predict-button ${loading ? "disabled" : ""}`} disabled={loading}>
        {loading ? "⏳ Processing..." : "🔍 Predict"}
      </button>

      {prediction && <p className="prediction-text">✅ Protein: {prediction}g</p>}

      {error && <p className="error-text">{error}</p>}
    </div>
  );
}
