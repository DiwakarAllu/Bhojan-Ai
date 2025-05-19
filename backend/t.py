import requests

url = "https://bhojan-ai.onrender.com/prediction"
files = {"image": open("p.jpg", "rb")}
response = requests.post(url, files=files)

print(response.status_code)
print(response.json())
