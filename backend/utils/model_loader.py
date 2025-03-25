import torch
import torch.nn as nn
import torchvision.transforms as transforms
from PIL import Image

# Define the model architecture (Same as used in training)
class CNNClassifier(nn.Module):
    def __init__(self, num_classes=80):
        super(CNNClassifier, self).__init__()

        self.conv1 = nn.Conv2d(in_channels=3, out_channels=32, kernel_size=3, stride=1, padding=1)
        self.conv2 = nn.Conv2d(in_channels=32, out_channels=64, kernel_size=3, stride=1, padding=1)
        self.conv3 = nn.Conv2d(in_channels=64, out_channels=128, kernel_size=3, stride=1, padding=1)

        self.pool = nn.MaxPool2d(kernel_size=2, stride=2)

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
        x = self.fc2(x)  # Output layer (logits)

        return x

# Load the trained model
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = CNNClassifier(num_classes=80)
model.load_state_dict(torch.load("model.pth", map_location=device))  # Ensure correct model path
model.to(device)
model.eval()  # Set to evaluation mode

# Define image transformations (Same as training)
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5])
])

# Class labels
class_labels = [f"Class_{i}" for i in range(80)]  # Replace with actual class names if available
