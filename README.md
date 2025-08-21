# Road Rangers: Edge-AI IoT Framework for Real-Time Road Accident Detection and Emergency Management

## Overview
This project aims to reduce fatalities caused by road accidents by using an Edge-AI enabled IoT system that detects crashes in real-time and automatically alerts emergency responders and nearby bystanders.

The system uses an ESP32 microcontroller with motion and sound sensors to run a TinyML model for accurate crash detection, combined with GPS and GSM/Wi-Fi communication for sending instant alerts.

## Project Structure
- `hardware-code/` — Firmware for ESP32 hardware integration with sensors and communication modules.
- `flutter-apps/stand-app` — Flutter app built for bystanders to receive accident alerts and assist.
- `flutter-apps/save-app` — Flutter app designed for emergency responders to view accident info and location.
- `tinyml-model/` — TinyML crash detection model files trained using Edge Impulse.
- `docs/` — Additional documentation and project notes.

## How to Use
1. Set up the ESP32 with provided hardware code and deploy the TinyML model.
2. Install and run the Flutter apps for bystanders and responders.
3. The system detects accidents in real-time and sends automated alerts with location details to the apps and emergency services.

## Team Members
- Rijul Nambiar P
- Sujith S
- Arul Balaji A

## License
This project is licensed under the MIT License.
