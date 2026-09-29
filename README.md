# 🎓 UniFind — University Campus Lost & Found Mobile App

UniFind is a cross-platform mobile application and web portal designed for university campuses. It allows students and staff to join private campus "Circles" using passcodes, report lost or found items with photos and location details, and track items until they are returned to their owners.

---

## 🌟 Key Features

- **🔐 Passcode-Protected University Circles**: Access campus lost & found feeds securely with passcodes (e.g., `MIT-FOUND`, `STANFORD-2026`).
- **⚡ Today's Daily Feed**: Quick filter to view items lost or found on the current day.
- **📍 Storage Spot & Location Tracking**: Track where the item was lost/found AND where it is currently stored (e.g. *Main Gate Security Desk*).
- **📞 Direct Contact System**: One-tap phone, email, and WhatsApp buttons for designated contacts.
- **✓ Resolution Workflow**: Mark items as **Claimed / Returned** when retrieved by owners.

---

## 📁 Repository Structure

```
├── flutter_app/          # Native Flutter / Dart mobile app codebase
│   ├── lib/              # Models, Screens, Providers & Widgets
│   └── pubspec.yaml      # Dependencies (Provider, Intl, Material 3)
└── web_prototype/        # Zero-dependency HTML5/CSS/JS mobile web prototype
    ├── index.html        # Interactive smartphone viewport simulator
    ├── styles.css        # Material 3 & glassmorphism UI styles
    └── app.js            # App state management & interactivity
```

---

## 🚀 How to Run Locally

### Option 1: Web Prototype (No installation required)
Open `web_prototype/index.html` in any web browser to instantly run the mobile simulator.

### Option 2: Flutter Native Mobile App
1. Navigate to `flutter_app`:
   ```bash
   cd flutter_app
   ```
2. Install dependencies and launch app:
   ```bash
   flutter pub get
   flutter run
   ```

---

## 🌐 Hosting on GitHub Pages (Free Web App Link)
To publish the interactive web prototype online so anyone can open it via a URL:
1. Go to your GitHub repository **Settings** tab.
2. Select **Pages** from the left menu.
3. Under **Build and deployment** -> **Source**, select **Deploy from a branch**.
4. Choose `main` branch and folder `/web_prototype`.
5. Click **Save**. Your app will be live at `https://<your-username>.github.io/<repo-name>/`!
