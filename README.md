# **__Bhojan-AI__**  
*AI Solution for Estimation of Protein in South Indian Meals*


## Overview

In 2024, nutrition apps are expected to have 1.4 billion users. However, a major challenge persists: the manual entry of food data, which is often time-consuming and inaccurate. For individuals tracking protein intake—particularly bodybuilders and athletes—estimating protein content in meals can be complicated, especially with South Indian cuisine's variety of ingredients and cooking methods.

This project addresses this issue by leveraging an AI-based image analysis solution to automatically identify South Indian dishes and estimate their protein content. This makes nutrition tracking easier, faster, and more reliable for users.

## Problem Statement

Tracking protein in South Indian meals is difficult due to the diversity of traditional ingredients and cooking methods. Existing tools often fail to estimate the protein content of such diverse cuisines accurately. This project aims to use deep learning to identify South Indian dishes from images and estimate their protein content by analyzing ingredients and portion sizes.

## Solution Overview

This project develops a website and mobile application that uses deep learning techniques to estimate the protein content of South Indian dishes based on food images. By leveraging a curated nutritional database, the system calculates protein values, helping users track their protein intake accurately and supporting personalized nutrition goals.

## Features

- **Food Image Recognition**: Detect and classify South Indian dishes using a pre-trained machine learning model.
- **Protein Estimation**: Estimate the protein content of identified dishes based on their ingredients and portion sizes.
- **Mobile & Web App**: Built using Android Studio for mobile and React.js, Flask for the web backend.
- **User Interaction**: Users can upload images of meals and receive protein estimates.
- **Data Storage**: User data (meal logs, protein intake history) stored in Firebase and MongoDB.

## Dataset

The **South Indian Food Detection and Classification Dataset** from [Roboflow](https://roboflow.com) is used for training and testing the model. It contains over 9,000 high-quality images of South Indian dishes like idli, dosa, and biryani, across 31 food classes. The dataset includes 300 images per class, with annotations for food identification.

### Dataset Details:
- **Food Classes**: 31 South Indian dishes.
- **Total Images**: 9,000+ images.
- **Image Annotations**: Each image is labeled with the corresponding food item.
- **Dataset Usage**: For training food recognition models.

## Architecture

1. **Dataset Preparation**: Clean and preprocess images from the Roboflow dataset. Augment images for training.
2. **Model Selection & Training**: Fine-tune a pre-trained model like **EfficientNet** or **ResNet** for food classification and protein estimation.
3. **Model Deployment**: Convert the trained model to **TensorFlow Lite** for mobile app deployment, applying model optimization techniques for mobile-friendly performance.
4. **Mobile & Web App Development**: 
    - **Mobile App**: Developed with **Android Studio**, **Java**, and **XML** for UI, and integrated with TensorFlow Lite for protein estimation.
    - **Web App**: Built with **React.js** and **Flask** for the backend.
5. **User Data Management**: Store user meal logs and history using **Firebase**.

## Technologies Used

- **Deep Learning**: EfficientNet/ResNet for image classification and protein estimation.
- **Mobile Development**: Android Studio, Java, XML, TensorFlow Lite.
- **Web Development**: React.js, Tailwind CSS, JavaScript, Flask.
- **Database**: MongoDB for storing user data, Firebase for authentication and cloud storage.
- **Image Processing**: OpenCV for image preprocessing and enhancement.
- **Cloud**: Firebase for cloud storage and user management.
- **Model Optimization**: TensorFlow Lite for mobile model deployment and optimization.

## Workflow

1. **Image Upload**: Users upload images of their South Indian meals.
2. **Food Classification**: The model detects the dish in the image.
3. **Protein Estimation**: Based on the recognized dish, the system estimates the protein content using the nutritional database.
4. **Display Results**: Protein estimates are displayed, and users can save their meal logs.
5. **User Authentication**: Users can securely log in using Firebase Authentication.

## App Preview

- **Mobile App**: Users can easily upload meal images, track protein intake, and manage their meal logs through the app.
- **Web App**: Provides the same features with a responsive web interface for easy access from browsers.

## Team Members

- **Allu Diwakar** – Mobile App Development
- **Anusha Mayaluri** – Web Development
- **Sai Ganesh Chintha** – Machine Learning Engineering

## Installation & Setup

To get started with the project locally, follow the instructions below:

### Prerequisites

- **Python** (for backend development)
- **React** (for frontend development)
- **Android Studio** (for mobile app development)
- **TensorFlow Lite** (for model optimization and mobile deployment)
