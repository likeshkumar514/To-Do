To-Do App

A feature-rich Flutter application to help users manage their daily tasks efficiently. The app supports user authentication, task management, and a responsive user interface with smooth animations.

Features

🛠 User Authentication

Login and Signup functionality using Firebase Authentication.
Persistent user sessions with SharedPreferences.

📋 Task Management

Add, edit, and delete tasks.
Mark tasks as completed or incomplete.
Swipe to delete tasks.

🎨 Beautiful UI

Clean and intuitive design.
Smooth animations for transitions and user interactions.
Adaptive and responsive layout for different devices.

💾 Persistent Storage

Tasks are stored in Firebase Realtime Database.
Local storage for maintaining user sessions.



Project Structure


lib/
├── Models/
│   └── task.dart              # Task model
├── Screens/
│   ├── Auth/
│   │   ├── auth_service.dart  # Authentication service
│   │   ├── login_page.dart    # Login screen
│   │   └── signup_page.dart   # Signup screen
│   ├── Pages/
│   │   └── home_page.dart     # Home screen with task management
└── main.dart                  # Entry point of the app



Installation

1️⃣ Clone the Repository

git clone https://github.com/yourusername/to_do_bangl.git
cd to_do_bangl



2️⃣ Install Dependencies

Ensure you have Flutter installed. Run the following command to fetch dependencies:

flutter pub get


3️⃣ Run the App

Launch the app using:

flutter run




Configuration


Firebase Setup

Go to the Firebase Console and create a new project.
Enable Authentication and Realtime Database.
Download the google-services.json file and place it in the android/app/ directory.
Make sure the database rules in Firebase allow read and write access during development.


Dependencies
The app uses the following Flutter packages:


dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  fluttertoast: ^8.2.10
  shared_preferences: ^2.3.5
  firebase_core: ^3.10.0
  firebase_auth: ^5.4.0
  cloud_firestore: ^5.6.1
  http: ^1.2.2



Usage


Authentication:

New users can register using the Sign Up feature.
Existing users can log in with their credentials.

Task Management:

Add new tasks using the floating action button.
Edit existing tasks by tapping the edit icon.
Swipe tasks left or right to delete them.
Mark tasks as complete or incomplete using the checkbox.

Logout:

Users can log out by tapping the "Signout" button on the Home Page.


Screens


Login Page

Smooth animations for the login form.
Email and password validation for secure access.


Signup Page

New users can create an account.
Username, email, and password validation for error-free signups.


Home Page

View all tasks in a scrollable list.
Add, edit, or delete tasks with intuitive UI components.


Future Enhancements

Add notifications for task reminders.
Implement categories for tasks.
Dark mode support.
Offline access using local storage.



Author
Developed by Likesh Kumar B M.
Feel free to connect for feedback, feature requests, or collaborations!

