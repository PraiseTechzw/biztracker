# BizTracker - Business Management App

A comprehensive Flutter application for tracking business operations including sales, expenses, stock management, and profit analysis.

## Features

### 🏢 Business Profile Management
- **Welcome Screen**: Beautiful onboarding experience for new users
- **Business Profile Creation**: Complete business profile setup with all necessary information
- **Profile Updates**: Easy editing and updating of business information
- **Profile Viewing**: Comprehensive display of all business details

### 📊 Business Operations
- **Sales Tracking**: Record and manage sales transactions
- **Expense Management**: Track business expenses by category
- **Stock Management**: Monitor inventory levels and values
- **Capital Tracking**: Manage business capital and investments
- **Profit Analysis**: Calculate and analyze profit margins

### 🎨 User Interface
- **Glassmorphism Design**: Modern, elegant UI with glass-like effects
- **Dark Theme**: Eye-friendly dark color scheme
- **Responsive Design**: Works seamlessly across different screen sizes
- **Smooth Animations**: Engaging user experience with fluid transitions

## Business Profile Features

The business profile system includes:

### Basic Information
- Business name and type
- Business description
- Industry classification

### Contact Information
- Phone number
- Email address
- Website URL

### Address Details
- Street address
- City, state, and country
- Postal code

### Business Details
- Tax identification number
- Business registration number
- Default currency for transactions

### Owner Information
- Owner name
- Owner contact details

### Settings
- Active/inactive status
- Logo and banner image support

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/biztracker.git
cd biztracker
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Database Setup

The app uses Isar database for local data storage. The database is automatically initialized when the app starts.

To generate the necessary database schema files:
```bash
dart run build_runner build
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── business_data.dart    # Core business data models
│   └── business_profile.dart # Business profile model
├── screens/
│   ├── welcome_screen.dart           # Welcome/onboarding screen
│   ├── business_profile_screen.dart  # Profile creation/editing
│   ├── profile_update_screen.dart    # Profile viewing/updating
│   ├── main_navigation_screen.dart   # Main app navigation
│   ├── dashboard_screen.dart         # Dashboard overview
│   ├── sales_screen.dart             # Sales management
│   ├── expenses_screen.dart          # Expense tracking
│   ├── stock_screen.dart             # Inventory management
│   ├── capital_screen.dart           # Capital tracking
│   ├── reports_screen.dart           # Reports and analytics
│   ├── profile_screen.dart           # User profile
│   ├── settings_screen.dart          # App settings
│   └── notifications_screen.dart     # Notifications
├── services/
│   ├── database_service.dart         # Database operations
│   └── analytics_service.dart        # Analytics and reporting
├── utils/
│   ├── glassmorphism_theme.dart      # UI theme and styling
│   ├── formatters.dart               # Data formatting utilities
│   └── search_filter_utils.dart      # Search and filter utilities
└── widgets/
    ├── chart_widget.dart             # Chart components
    └── quick_actions_widget.dart     # Quick action buttons
```

## Usage

### First Time Setup
1. Launch the app
2. You'll see the welcome screen with options to create a new business profile or continue with existing
3. Choose "Create Business Profile" to set up your business
4. Fill in all required information (business name, type, contact details)
5. Save your profile to proceed to the main app

### Managing Business Profile
- Access your profile from the main navigation
- View all your business information in an organized layout
- Edit any details by tapping the "Edit Profile" button
- All changes are automatically saved

### Business Operations
- Use the dashboard to get an overview of your business
- Navigate to different sections to manage sales, expenses, stock, etc.
- Generate reports to analyze your business performance

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support and questions, please open an issue in the GitHub repository or contact the development team.

---

**BizTracker** - Your Business, Simplified
