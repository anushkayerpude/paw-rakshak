# 🐾 PawRakshak

> **India's Community Emergency Animal Rescue & Triage Network**
>
> 🌐 **Live Web Application**: [https://paw-rakshak.web.app](https://paw-rakshak.web.app)

---

## Overview

PawRakshak is an emergency animal welfare platform connecting citizens, volunteer rescuers, and veterinary clinics across Gujarat and India. When an animal is spotted injured on the street, PawRakshak delivers instant AI-generated first-aid guidance and alerts nearby responders within minutes.

---

## Key Features

- **Public Landing Page**: Storytelling hero with real-time response metrics, "How PawRakshak Works" 3-step guide, and verified animal recovery stories.
- **Live Incident Dashboard**: Reactive triage feed tracking active SOS alerts, volunteer assignments, and care funding progress.
- **Instant AI First-Aid Protocol**: Powered by Gemini to provide immediate stabilization steps, critical precautions, and clinic handover briefing before medical help arrives.
- **5km Radius Volunteer Dispatch**: Alerts nearby registered volunteers with the transport vehicles, rescue crates, and on-site dressing kits.
- **100% Transparent Care Ledger**: Micro-donation tiers (₹100, ₹250, ₹500, ₹1000) directly funding emergency medicines, bandages, and surgical treatment.
- **Emergency Helpline Hub**: One-tap direct dialer to the National Animal Ambulance (`1962`) and local municipal animal control.
- **Midnight Forest Rescue Theme**: High-contrast, dark-mode design with real documentary rescue photography and intuitive mobile-first touch targets.

---

## Technology Stack

- **Framework**: Flutter (Web, Android, iOS, macOS)
- **Design System**: Material 3 with custom Emerald / Forest / Slate design tokens
- **AI Triage**: Google Gemini API (Emergency veterinary first-aid generation)
- **Deployment**: Firebase Hosting

---

## Getting Started Locally

### Prerequisites

- Flutter SDK (>= 3.11.5)
- Google Chrome or Xcode / Android Studio

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/anushkayerpude/paw-rakshak.git
   cd paw-rakshak
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app in Chrome:
   ```bash
   flutter run -d chrome
   ```

4. Run tests and static analysis:
   ```bash
   flutter analyze
   flutter test
   ```

---

## Live Deployment

The web application is continuously deployed on Firebase Hosting:
- **Production URL**: [https://paw-rakshak.web.app](https://paw-rakshak.web.app)
