from flask import Blueprint, request, jsonify
import torch
import torch.nn as nn
import torchvision.transforms as transforms
from PIL import Image

# Define Blueprint
predict_blueprint = Blueprint("predict", __name__)

# Define model and transformations (as in your original app)
class CNNClassifier(nn.Module):
    def __init__(self, num_classes=80):
        super(CNNClassifier, self).__init__()
        self.conv1 = nn.Conv2d(3, 32, 3, 1, 1)
        self.conv2 = nn.Conv2d(32, 64, 3, 1, 1)
        self.conv3 = nn.Conv2d(64, 128, 3, 1, 1)
        self.pool = nn.MaxPool2d(2, 2)
        self.fc1 = nn.Linear(128 * 28 * 28, 512)
        self.fc2 = nn.Linear(512, num_classes)
        self.relu = nn.ReLU()
        self.dropout = nn.Dropout(0.5)

    def forward(self, x):
        x = self.pool(self.relu(self.conv1(x)))
        x = self.pool(self.relu(self.conv2(x)))
        x = self.pool(self.relu(self.conv3(x)))
        x = x.view(x.size(0), -1)
        x = self.relu(self.fc1(x))
        x = self.dropout(x)
        x = self.fc2(x)
        return x

# Load model
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = CNNClassifier(num_classes=80)
model.load_state_dict(torch.load("model.pth", map_location=device))
model.to(device)
model.eval()

# Image transformation
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5])
])

# Class labels
class_labels = [f"Class_{i}" for i in range(80)]  # Modify if you have specific labels

@predict_blueprint.route("/predict", methods=["POST"])
def predict():
    try:
        if "image" not in request.files:
            return jsonify({"error": "No image provided"}), 400

        file = request.files["image"]
        image = Image.open(file).convert("RGB")
        image = transform(image).unsqueeze(0).to(device)

        with torch.no_grad():
            outputs = model(image)
            _, predicted = torch.max(outputs, 1)
            predicted_class = class_labels[predicted.item()]

        return jsonify({"prediction": predicted_class})

    except Exception as e:
        import traceback
        print(traceback.format_exc())  # Print full error traceback
        return jsonify({"error": str(e)}), 500
