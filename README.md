# 📚 Study Buddy – AI-Powered Personalized Study Assistant

StudyBuddy is an iOS productivity app built with SwiftUI that helps students manage their notes, generate smart summaries, and prepare for quizzes – all in one place. The app integrates document scanning, voice-based summaries, and AI-powered study tools.

---

## ✨ Features

- 🔐 Apple Sign-In & Guest Mode
- 📝 Create, pin, lock, update and delete notes
- 📷 Scan documents (VisionKit) and extract text
- 📂 Import handwritten/typed notes
- 🧠 Generate summaries using OpenAI
- 🎧 Text-to-speech for summaries
- ❓ Quiz generation based on notes
- 📅 Daily study plan view
- 🔔 Local notifications for focus sessions
- 💾 Core Data storage with user-scoped notes

---

## 🛠 Technologies Used

- **SwiftUI** – Declarative UI
- **Core Data** – Local persistence
- **VisionKit & Vision** – Document scanning and text recognition
- **AVFoundation** – Text-to-speech
- **LocalAuthentication** – FaceID/TouchID for locked notes
- **OpenAI API** – Summarization and quiz generation
- **UserDefaults / @AppStorage** – Lightweight persistent storage

---

## 🚀 Getting Started

### Prerequisites

- Xcode 15+
- iOS 16+
- An Apple Developer account for Sign-In & biometric auth
- An OpenAI API key and running backend server to interface with it

### Installation

1. Clone the repository:
   git clone https://github.com/Kavinsha-Chamod/Study-Buddy.git
   cd Study-Buddy

2.Open the project in Xcode:
open Study-Buddy.xcodeproj

3. Set your development team and unique bundle identifier in Signing & Capabilities.

4. Update QuizAPI.swift and any other networking files to use your hosted backend URL: let baseURL = "https://your-vercel-app.vercel.app"
   
## 🌐 API Endpoints
Node.js backend hosted on Vercel handles:
- **POST /summary** : Takes in note title and content, returns a smart summary.
-	**POST /quiz** : Accepts note content, returns a set of quiz questions.
Example request format:
{
  "userId": "abc123",
  "noteId": "xyz456",
  "title": "Management Functions",
  "content": "Full note content here"
}

## 📲  Key Screens
**NewNoteView** - Add new notes
**FilesView** – Browse, pin, lock, update and delete notes
**StudyPlanView** – View notes for the day and generate study materials
**SummaryView** – Read AI-generated summaries, listen via text-to-speech
**QuizView** – Attempt generated questions and flashcards
**FocusModeView** – Timer with alert + notification for deep work

## 🧪 Testing
### Use a real device to test features like:
- Apple Sign-In
- FaceID/TouchID (note locking)
- Local notifications
- Document scanning
- Watch debug output for API calls:
print("Sending Quiz API Request with:")
print("userId: \(loggedInUserId)")
print("noteId: \(note.id?.uuidString ?? "nil")")
print("title: \(title)")
print("content: \(summary.prefix(100))...")

## 📦 Backend Repo (Optional)
If you're hosting your own or modifying the backend:
**GitHub** : https://github.com/Kavinsha-Chamod/studdy-buddy-backend.git
**Hosted on Vercel at**: https://your-vercel-app.vercel.app

## 🙌 Credits
OpenAI for GPT-based summarization
Apple VisionKit & AVFoundation
SwiftUI community & developers

## 📄 License
MIT License. Open to contributions and feature ideas!

