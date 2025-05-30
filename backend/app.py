from flask import Flask, redirect, request, jsonify
from ultralytics import YOLO
import cv2
import numpy as np
from PIL import Image
import io
from gradio_client import Client, handle_file
import tempfile
from flask_cors import CORS
import os
import cv2
import tempfile
import numpy as np
from flask import Blueprint, request, send_file, jsonify
from ultralytics import YOLO
from werkzeug.utils import secure_filename
import base64


# Load model
model = YOLO("best.pt")

# Nutrition and class data (you can also move this to a separate file and import)
class_names = ['Appam', 'Beetroot poriyal', 'Boiled Egg', 'Carrot poriyal', 'Chicken 65', 'Chicken briyani',
               'Dosa', 'Idly', 'Kaara chutney', 'Kali', 'Koozh', 'Lemon Rice', 'Mushroom briyani',
               'Mutton Briyani', 'Nandu masala', 'Nei satham', 'Paal kolukattai', 'Paneer briyani',
               'Panner masala', 'Parupu vada', 'Pidi kolukattai', 'Poorna kolukattai', 'Prawn thokku',
               'Puthina Chutney', 'Sambar', 'Sambar satham', 'Satham', 'Thengai chutney', 'Uzhuntha vadai',
               'Veg briyani', 'Ven Pongal']

nutrition_data = {
  "0": {
    "fat": 2.4,
    "name": "Appam",
    "salt": 0.068,
    "sugar": 1.6,
    "protein": 1.5,
    "calories": 94,
    "source_url": "https://www.kaggle.com/datasets/bindudiva/south-indian-food-dataset?select=south+indian+foods.csv (https://www.nutritionix.com/food/appam)",
    "ingredients": [
      "Raw rice",
      "cooked rice",
      "grated coconut",
      "instant yeast",
      "sugar",
      "salt",
      "coconut milk",
      "water",
      "oil or ghee."
    ],
    "carbohydrate": 17
  },
  "1": {
    "fat": 3.5,
    "name": "Beetroot poriyal",
    "salt": 0.18,
    "sugar": 4,
    "protein": 2,
    "calories": 90,
    "source_url": "https://www.nutribit.app/food/669cfe6c2028bbb5cd43f395",
    "ingredients": [
      "Beetroot",
      "oil",
      "mustard seeds",
      "urad dal",
      "chana dal",
      "dried red chili",
      "curry leaves",
      "green chilies",
      "ginger",
      "turmeric powder",
      "salt",
      "grated coconut."
    ],
    "carbohydrate": 10
  },
  "2": {
    "fat": 5.3,
    "name": "Boiled Egg",
    "salt": 0.062,
    "sugar": 0.6,
    "protein": 6.3,
    "calories": 78,
    "source_url": "https://www.nutritionix.com/food/boiled-egg",
    "ingredients": [
      "Egg",
      "water",
      "salt"
    ],
    "carbohydrate": 0.6
  },
  "3": {
    "fat": 1,
    "name": "Carrot poriyal",
    "salt": 0.15,
    "sugar": 4,
    "protein": 1,
    "calories": 50,
    "source_url": "https://www.nutribit.app/food/669cfe6c2028bbb5cd43fd33",
    "ingredients": [
      "Carrots",
      "oil",
      "mustard seeds",
      "urad dal",
      "chana dal",
      "dried red chili",
      "curry leaves",
      "green chilies",
      "ginger or garlic",
      "turmeric powder",
      "salt",
      "grated coconut."
    ],
    "carbohydrate": 10
  },
  "4": {
    "fat": 9.8,
    "name": "Chicken 65",
    "salt": 0.672,
    "sugar": 2.1,
    "protein": 15.4,
    "calories": 182,
    "source_url": "https://www.nutribit.app/food/6489caea3aa9d8b5afe7f8de",
    "ingredients": [
      "Boneless chicken",
      "yogurt",
      "ginger-garlic paste",
      "red chili powder",
      "turmeric powder",
      "garam masala",
      "rice flour",
      "corn flour",
      "all-purpose flour",
      "egg",
      "curry leaves",
      "green chilies",
      "garlic",
      "lemon juice",
      "salt",
      "oil."
    ],
    "carbohydrate": 7
  },
  "5": {
    "fat": 9.4,
    "name": "Chicken briyani",
    "salt": 0.419,
    "sugar": 3.2,
    "protein": 20,
    "calories": 292,
    "source_url": "https://www.kaggle.com/datasets/bindudiva/south-indian-food-dataset?select=south+indian+foods.csv",
    "ingredients": [
      "Chicken",
      "basmati rice",
      "yogurt",
      "onions",
      "tomatoes",
      "garlic",
      "ginger",
      "green chilies",
      "mint leaves",
      "coriander leaves",
      "lemon juice",
      "saffron",
      "garam masala",
      "turmeric powder",
      "red chili powder",
      "coriander powder",
      "cumin seeds",
      "cinnamon stick",
      "cardamom pods",
      "cloves",
      "bay leaves",
      "star anise",
      "shahi jeera",
      "ghee",
      "oil",
      "salt",
      "water."
    ],
    "carbohydrate": 31
  },
  "6": {
    "fat": 3.84,
    "name": "Dosa",
    "salt": 0.399,
    "sugar": 0.29,
    "protein": 5.53,
    "calories": 209,
    "source_url": "https://calories-info.com/dosa-calories-kcal",
    "ingredients": [
      "Rice",
      "urad dal",
      "fenugreek seeds",
      "poha (flattened rice)",
      "salt",
      "water",
      "oil",
      "turmeric",
      "cooked rice",
      "sesame seeds",
      "and hing (asafoetida)."
    ],
    "carbohydrate": 35.97
  },
  "7": {
    "fat": 0.4,
    "name": "Idly",
    "salt": 0.075,
    "sugar": 0.1,
    "protein": 1.6,
    "calories": 58,
    "source_url": "https://www.kaggle.com/datasets/bindudiva/south-indian-food-dataset?select=south+indian+foods.csv",
    "ingredients": [
      "Idli rice",
      "urad dal (split black gram)",
      "fenugreek seeds",
      "water",
      "salt."
    ],
    "carbohydrate": 12
  },
  "8": {
    "fat": 5,
    "name": "Kaara chutney",
    "salt": 0.45,
    "sugar": 2,
    "protein": 2,
    "calories": 85,
    "source_url": "https://thetastesofindia.com/kara-chutney-recipe/",
    "ingredients": [
      "Dry red chilies",
      "garlic",
      "onion",
      "tomato",
      "chana dal",
      "urad dal",
      "oil",
      "mustard seeds",
      "curry leaves",
      "salt",
      "asafoetida",
      "water."
    ],
    "carbohydrate": 8
  },
  "9": {
    "fat": 11.35,
    "name": "Kali",
    "salt": 0.968,
    "sugar": 0.73,
    "protein": 4.78,
    "calories": 252.8,
    "source_url": "https://www.nutribit.app/food/655f038635ae4ffda864d706",
    "ingredients": [
      "Ragi flour (finger millet flour)",
      "water",
      "salt",
      "ghee",
      "cooked rice",
      "sour curd",
      "mustard seeds",
      "urad dal",
      "chana dal",
      "curry leaves",
      "green chilies",
      "hing (asafoetida)",
      "sesame oil."
    ],
    "carbohydrate": 33.23
  },
  "10": {
    "fat": 0.5,
    "name": "Koozh",
    "salt": 0.05,
    "sugar": 0,
    "protein": 2.5,
    "calories": 60,
    "source_url": "https://www.snapcalorie.com/nutrition/ragi_koozh_nutrition.html",
    "ingredients": [
      "Kezhvaragu (finger millet) flour",
      "cooked rice",
      "salt",
      "buttermilk or yogurt",
      "finely chopped onions or shallots",
      "curry leaves",
      "coriander leaves"
    ],
    "carbohydrate": 13
  },
  "11": {
    "fat": 3,
    "name": "Lemon Rice",
    "salt": 0.104,
    "sugar": 1.1,
    "protein": 4.9,
    "calories": 221,
    "source_url": "https://www.kaggle.com/datasets/bindudiva/south-indian-food-dataset?select=south+indian+foods.csv",
    "ingredients": [
      "Rice",
      "lemon juice",
      "onion",
      "green chilies",
      "ginger",
      "curry leaves",
      "mustard seeds",
      "urad dal",
      "chana dal",
      "turmeric powder",
      "red chili powder",
      "asafoetida",
      "peanuts",
      "oil",
      "salt."
    ],
    "carbohydrate": 43
  },
  "12": {
    "fat": 15,
    "name": "Mushroom briyani",
    "salt": 0.073,
    "sugar": 1.6,
    "protein": 4.3,
    "calories": 320,
    "source_url": "https://www.kaggle.com/datasets/bindudiva/south-indian-food-dataset?select=south+indian+foods.csv",
    "ingredients": [
      "Mushrooms",
      "basmati rice",
      "onion",
      "tomato",
      "ginger-garlic paste",
      "green chilies",
      "mint leaves",
      "coriander leaves",
      "yogurt",
      "garam masala",
      "biryani masala",
      "red chili powder",
      "coriander powder",
      "turmeric powder",
      "cumin seeds",
      "bay leaves",
      "cinnamon",
      "cloves",
      "cardamom",
      "star anise",
      "ghee",
      "oil",
      "salt."
    ],
    "carbohydrate": 43
  },
  "13": {
    "fat": 12,
    "name": "Mutton Briyani",
    "salt": 0.89,
    "sugar": 1,
    "protein": 15,
    "calories": 350,
    "source_url": "https://www.kaggle.com/datasets/bindudiva/south-indian-food-dataset?select=south+indian+foods.csv",
    "ingredients": [
      "Mutton",
      "basmati rice",
      "yogurt",
      "onion",
      "ginger-garlic paste",
      "green chilies",
      "mint leaves",
      "coriander leaves",
      "lemon juice",
      "garam masala",
      "red chili powder",
      "turmeric powder",
      "salt",
      "ghee",
      "bay leaves",
      "cinnamon",
      "cloves",
      "green cardamom",
      "black cardamom",
      "star anise",
      "shahi jeera",
      "saffron",
      "milk",
      "fried onions",
      "oil."
    ],
    "carbohydrate": 44
  },
  "14": {
    "fat": 19.8,
    "name": "Nandu masala",
    "salt": 0.215,
    "sugar": 2.5,
    "protein": 2.8,
    "calories": 218,
    "source_url": "https://happietrio.com/nandu-kuzhambu-crab-curry-nandu-kulambu/?utm_source=chatgpt.com",
    "ingredients": [
      "Crab",
      "onion",
      "tomato",
      "ginger",
      "garlic",
      "fennel seeds",
      "curry leaves",
      "chili powder",
      "coriander powder",
      "turmeric",
      "oil",
      "salt"
    ],
    "carbohydrate": 9.9
  },
  "15": {
    "fat": 10,
    "name": "Nei satham",
    "salt": 0.4,
    "sugar": 1,
    "protein": 3,
    "calories": 220,
    "source_url": "https://www.steffisrecipes.com/2017/03/ghee-rice-recipe-nei-sadam.html",
    "ingredients": [
      "Basmati rice",
      "ghee",
      "onion",
      "dry red chili",
      "cloves",
      "cardamom",
      "cinnamon",
      "bay leaf",
      "cashew",
      "raisins",
      "salt"
    ],
    "carbohydrate": 30
  },
  "16": {
    "fat": 6.8,
    "name": "Paal kolukattai",
    "salt": 0.15,
    "sugar": 10,
    "protein": 2.2,
    "calories": 160,
    "source_url": "https://www.yummytummyaarthi.com/paal-kozhukattai-rice-flour-balls/",
    "ingredients": [
      "Rice flour",
      "water",
      "ghee",
      "milk",
      "coconut milk",
      "jaggery/sugar",
      "cardamom"
    ],
    "carbohydrate": 25
  },
  "17": {
    "fat": 6.5,
    "name": "Paneer briyani",
    "salt": 0.5,
    "sugar": 5,
    "protein": 7,
    "calories": 200,
    "source_url": "https://www.charcoaleats.com/post/paneer-veg-biryani-flavorful-delight",
    "ingredients": [
      "Basmati rice",
      "paneer",
      "yogurt",
      "onions",
      "tomatoes",
      "ginger-garlic paste",
      "garam masala",
      "saffron",
      "mint",
      "coriander",
      "ghee/oil",
      "spices (cardamom",
      "cloves",
      "cinnamon",
      "bay leaves)"
    ],
    "carbohydrate": 30
  },
  "18": {
    "fat": 12,
    "name": "Panner masala",
    "salt": 0.4,
    "sugar": 3,
    "protein": 8,
    "calories": 160,
    "source_url": "https://www.snapcalorie.com/nutrition/paneer_masala_nutrition.html",
    "ingredients": [
      "Paneer",
      "tomatoes",
      "onions",
      "ginger",
      "garlic",
      "cumin",
      "coriander",
      "garam masala",
      "chili powder",
      "turmeric",
      "oil",
      "salt"
    ],
    "carbohydrate": 6
  },
  "19": {
    "fat": 23,
    "name": "Parupu vada",
    "salt": 0.2,
    "sugar": 1,
    "protein": 9,
    "calories": 300,
    "source_url": "https://www.snapcalorie.com/nutrition/paruppu_vada_nutrition.html",
    "ingredients": [
      "Chana dal (split chickpeas)",
      "urad dal (black gram)",
      "onion",
      "green chilies",
      "ginger",
      "curry leaves",
      "coriander leaves",
      "cumin seeds",
      "black pepper",
      "red chili powder",
      "coriander powder",
      "garam masala",
      "ginger-garlic paste",
      "salt",
      "oil for deep frying"
    ],
    "carbohydrate": 25
  },
  "20": {
    "fat": 8,
    "name": "Pidi kolukattai",
    "salt": 0.07,
    "sugar": 12,
    "protein": 5,
    "calories": 190,
    "source_url": "https://www.nutribit.app/food/66ac7fc9f3a3e393cb974f99",
    "ingredients": [
      "Rice flour",
      "water",
      "ghee",
      "coconut",
      "jaggery",
      "cardamom"
    ],
    "carbohydrate": 28
  },
  "21": {
    "fat": 21.13,
    "name": "Poorna kolukattai",
    "salt": 0.027,
    "sugar": 29.53,
    "protein": 3.9,
    "calories": 190,
    "source_url": "https://recipes.behindtalkies.com/purana-kolukattai-tamil-recipes/",
    "ingredients": [
      "Rice flour",
      "jaggery",
      "grated coconut",
      "cardamom",
      "ghee",
      "water"
    ],
    "carbohydrate": 35.8
  },
  "22": {
    "fat": 1.72,
    "name": "Prawn thokku",
    "salt": 0.47,
    "sugar": 0,
    "protein": 20.14,
    "calories": 94,
    "source_url": "https://www.yummytummyaarthi.com/prawn-thokku/           https://www.fatsecret.co.in/calories-nutrition/generic/prawns/",
    "ingredients": [
      "Prawns",
      "onion",
      "tomato",
      "ginger-garlic paste",
      "green chilies",
      "curry leaves",
      "mustard seeds",
      "urad dal",
      "fennel seeds",
      "cloves",
      "cinnamon",
      "cardamom",
      "star anise",
      "garam masala",
      "chili powder",
      "coriander powder",
      "turmeric powder",
      "oil",
      "salt"
    ],
    "carbohydrate": 0.9
  },
  "23": {
    "fat": 2,
    "name": "Puthina Chutney",
    "salt": 0.3,
    "sugar": 1,
    "protein": 1,
    "calories": 50,
    "source_url": "https://www.nutribit.app/food/669cfe6c2028bbb5cd43fd1c",
    "ingredients": [
      "Mint leaves",
      "green chilies",
      "tamarind",
      "salt",
      "oil",
      "mustard seeds",
      "urad dal"
    ],
    "carbohydrate": 6
  },
  "24": {
    "fat": 4.38,
    "name": "Sambar",
    "salt": 0.45,
    "sugar": 3.31,
    "protein": 3.35,
    "calories": 96.92,
    "source_url": "https://www.anuvaad.org.in/nutrition-fact/sambar/",
    "ingredients": [
      "Toor dal",
      "tamarind",
      "onions",
      "tomatoes",
      "drumstick",
      "brinjal",
      "okra",
      "sambar powder",
      "mustard seeds",
      "curry leaves",
      "oil",
      "asafoetida",
      "turmeric",
      "salt"
    ],
    "carbohydrate": 10.57
  },
  "25": {
    "fat": 1,
    "name": "Sambar satham",
    "salt": 0.39,
    "sugar": 3,
    "protein": 2,
    "calories": 65,
    "source_url": "https://www.fatsecret.co.in/calories-nutrition/mtr/sambar-rice/100g",
    "ingredients": [
      "Rice",
      "toor dal",
      "tamarind",
      "sambar powder",
      "mustard seeds",
      "curry leaves",
      "oil",
      "vegetables (carrot",
      "beans",
      "drumstick)",
      "salt"
    ],
    "carbohydrate": 12
  },
  "26": {
    "fat": 0.3,
    "name": "Satham",
    "salt": 0,
    "sugar": 0.1,
    "protein": 2.7,
    "calories": 130,
    "source_url": "https://vitahoy.ch/en/ndb/pml/us-20545",
    "ingredients": [
      "White rice",
      "water"
    ],
    "carbohydrate": 28
  },
  "27": {
    "fat": 25,
    "name": "Thengai chutney",
    "salt": 0.43,
    "sugar": 3.8,
    "protein": 3.6,
    "calories": 266,
    "source_url": "https://www.anuvaad.org.in/nutrition-fact/coconut-chutney-nariyal-ki-chutney/",
    "ingredients": [
      "Fresh coconut",
      "green chilies",
      "ginger",
      "tamarind",
      "salt",
      "oil",
      "mustard seeds",
      "curry leaves",
      "urad dal",
      "chana dal"
    ],
    "carbohydrate": 8.3
  },
  "28": {
    "fat": 76.3,
    "name": "Uzhuntha vadai",
    "salt": 0.066,
    "sugar": 0.16,
    "protein": 4.4,
    "calories": 745,
    "source_url": "https://www.anuvaad.org.in/nutrition-fact/plain-urad-dal-vada-uzunne-vada-minapa-garelu-ulundu-vadai-medu-vada/",
    "ingredients": [
      "Urad dal (black gram)",
      "rice flour",
      "ginger",
      "green chilies",
      "curry leaves",
      "black pepper",
      "salt",
      "oil"
    ],
    "carbohydrate": 9.7
  },
  "29": {
    "fat": 9,
    "name": "Veg briyani",
    "salt": 0.366,
    "sugar": 4,
    "protein": 3.2,
    "calories": 173,
    "source_url": "https://www.eatthismuch.com/calories/vegetable-biryani-3594525",
    "ingredients": [
      "rice",
      "milk",
      "ghee",
      "onions",
      "garlic",
      "ginger",
      "jalape�o",
      "garam masala paste",
      "yogurt",
      "mixed vegetables (cauliflower",
      "potato",
      "carrots",
      "peas)",
      "dried apricots",
      "raisins",
      "cashews",
      "cilantro",
      "mint",
      "lime juice",
      "and whole spices like saffron",
      "cardamom",
      "cinnamon",
      "bay leaves",
      "star anise",
      "and turmeric."
    ],
    "carbohydrate": 24.2
  },
  "30": {
    "fat": 3.87,
    "name": "Ven Pongal",
    "salt": 0.016,
    "sugar": 0.5,
    "protein": 3.51,
    "calories": 153.12,
    "source_url": "https://www.nutribit.app/food/655f041535ae4ffda86519ab",
    "ingredients": [
      "short-grain rice",
      "yellow moong dal",
      "ghee",
      "black pepper",
      "cumin",
      "grated ginger",
      "curry leaves",
      "cashews",
      "asafoetida",
      "salt",
      "and water."
    ],
    "carbohydrate": 25.91
  }
}

app = Flask(__name__)
client = Client("cutiepi3/bhojan-ai")
CORS(app)


@app.route("/prediction", methods=["POST"])
def predict():
    if "image" not in request.files:
        return jsonify({"error": "No image uploaded"}), 400

    file = request.files["image"]
    image_bytes = file.read()
    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    image_np = np.array(image)

    # Run inference
    results = model(image_np)[0]

    detections = []
    for box in results.boxes:
        cls_id = int(box.cls)
        confidence = float(box.conf)
        x1, y1, x2, y2 = map(int, box.xyxy[0].tolist())
        label = class_names[cls_id]
        food_info = nutrition_data[str(cls_id)]

        detections.append({
            "class": label,
            "confidence": round(confidence, 2),
            "bbox": [x1, y1, x2, y2],
            "nutritional_info": food_info
        })
    print(detections)    

    return jsonify({"detections": detections})


@app.route('/yolo_predict', methods=['POST'])
def yolo_predict():
    if 'file' not in request.files:
        return jsonify({'error': 'No file part in the request'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    filename = secure_filename(file.filename)
    temp_dir = tempfile.mkdtemp()
    file_path = os.path.join(temp_dir, filename)
    file.save(file_path)

    try:
        results = model(file_path)[0]
        image = cv2.imread(file_path)

        detections = []

        for box in results.boxes:
            cls_id = int(box.cls)
            confidence = float(box.conf)
            x1, y1, x2, y2 = map(int, box.xyxy[0].tolist())
            label = f"{class_names[cls_id]}: {confidence:.2f}"

            # Draw bounding box and label on image
            cv2.rectangle(image, (x1, y1), (x2, y2), (0, 255, 0), 2)
            cv2.putText(image, label, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX,
                        0.5, (255, 0, 0), 2)

            # Calculate center and area
            center_x = (x1 + x2) // 2
            center_y = (y1 + y2) // 2
            area = (x2 - x1) * (y2 - y1)

            # Append detection info
            detections.append({
                "class": class_names[cls_id],
                "confidence": round(confidence, 2),
                "bbox": [x1, y1, x2, y2],
                "center": {"x": center_x, "y": center_y},
                "area": area
            })

        # Encode annotated image
        _, buffer = cv2.imencode('.jpg', image)
        encoded_image = base64.b64encode(buffer.tobytes()).decode('utf-8')

        return jsonify({
            "image": encoded_image,
            "detections": detections
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/predict", methods=["POST"])
def hugging_predict():
    if "image" not in request.files:
        return jsonify({"error": "No image uploaded"}), 400

    image = request.files["image"]

    # Save uploaded file to temp directory
    with tempfile.NamedTemporaryFile(delete=False, suffix=".jpg") as temp:
        image.save(temp.name)
        temp_path = temp.name

    try:
        result = client.predict(
            image=handle_file(temp_path),
            api_name="/predict"
        )
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/predict2", methods=["POST"])
def hugging_predict2():
    if "image" not in request.files:
        return jsonify({"error": "No image uploaded"}), 400

    image = request.files["image"]

    # Save uploaded file to temp directory
    with tempfile.NamedTemporaryFile(delete=False, suffix=".jpg") as temp:
        image.save(temp.name)
        temp_path = temp.name

    try:
        result = client.predict(
            image=handle_file(temp_path),
            api_name="/yolo_predict"  # Ensure correct API endpoint
        )

        # Delete temp file after processing
        os.remove(temp_path)

        return jsonify({"result": result})

    except Exception as e:
        # Clean up temp file if an error occurs
        if os.path.exists(temp_path):
            os.remove(temp_path)

        return jsonify({"error": str(e)}), 500
    
@app.route("/web", methods=["GET"])
def webview():
    return redirect("https://cutiepi3-bhojan-ai.hf.space/?__theme=system", code=302)  



@app.route("/", methods=["GET"])
def home():
    return "Bhojan AI YOLO Food Detection API is up!", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
