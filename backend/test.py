# import requests

# url = "https://bhojan-ai.onrender.com/predict/"
# #url="http://127.0.0.1:5000/predict"
# image_path = "test.jpg"

# with open(image_path, "rb") as img:
#     files = {"image": img}
#     response = requests.post(url, files=files)

# try:
#     data = response.json()
# except requests.exceptions.JSONDecodeError:
#     print("Server did not return valid JSON.")
#     print("Raw response:", response.text)
#     exit(1)

# print("Status Code:", response.status_code)
# print("Response:", response.json())

import requests

# https://huggingface.co/spaces/cutiepi3/bhojan-ai

# url = "https://cutiepi3-bhojan-ai.hf.space/run/predict"
# url = "https://bhojan-ai.onrender.com/predict"

# url="http://127.0.0.1:5000/yolo_predict"
url="http://127.0.0.1:5000/predict2"
# url="http://192.168.0.101:5000/yolo_predict"

import requests
url = "http://localhost:5000/predict"  # Change if running on a different host or port 1045

# url="https://bhojan-ai.onrender.com/predict2"

image_path = "p.jpg"  # Replace with your test image path

files = {'image': open(image_path, "rb")}  # must match 'image' key expected by Flask

try:
    response = requests.post(url, files=files, timeout=60)
    print("Status Code:", response.status_code)

    try:
        print("Response JSON:", response.json())
    except requests.exceptions.JSONDecodeError:
        print("❌ Non-JSON Response:")
        print(response.text)

except requests.exceptions.RequestException as e:
    print("❌ Request failed:", e)

# files = {'file': open("v.jpg", "rb")}
# try:
#     response = requests.post(url, files=files, timeout=60)
#     print("Status Code:", response.status_code)

#     try:
#         print("Response JSON:", response.json())
#     except requests.exceptions.JSONDecodeError:
#         print("Non-JSON Response Received:")
#         print(response.text)

# except requests.exceptions.RequestException as e:
#     print("Request failed:", e)
