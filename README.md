# BizTracker 📊

A modern Flutter mobile app for business tracking with beautiful glassmorphism UI design. Track your capital, inventory, sales, expenses, and generate detailed profit reports.

## ✨ Features

### 🏢 **Business Management**
- **Capital Tracking** - Record initial and additional capital investments
- **Stock Management** - Full CRUD operations for inventory items
- **Sales Recording** - Track sales transactions with customer details
- **Expense Tracking** - Monitor business expenses by category
- **Profit Analysis** - Automatic profit/loss calculations

### 📈 **Analytics & Reports**
- **Business Overview** - Real-time dashboard with key metrics
- **Profit Reports** - Generate detailed profit analysis by date range
- **Business Health Score** - AI-powered business performance assessment
- **Monthly Trends** - Track performance over time
- **Top Products** - Identify best-selling items
- **Expense Categories** - Analyze spending patterns

### 🎨 **Modern UI Design**
- **Glassmorphism Design** - Beautiful blur effects and transparency
- **Dark Theme** - Easy on the eyes with modern color scheme
- **Responsive Layout** - Optimized for mobile devices
- **Smooth Animations** - Fluid user experience
- **Intuitive Navigation** - Easy-to-use interface
- **Bottom Navigation** - Quick access to all sections
- **Search & Filter** - Advanced data filtering capabilities
- **Custom Charts** - Beautiful data visualization
- **Quick Actions** - One-tap access to common tasks

## 🛠️ Technical Stack

- **Framework**: Flutter 3.8+
- **Database**: Isar (NoSQL database)
- **State Management**: Flutter StatefulWidget
- **UI Design**: Custom Glassmorphism Theme
- **Dependencies**: 
  - `isar: ^3.1.0+1` - Local database
  - `path_provider: ^2.1.2` - File system access
  - `intl: ^0.19.0` - Internationalization
  - `flutter_blur: ^0.0.2` - Blur effects

## 📱 Screenshots

The app includes the following screens:

1. **Dashboard** - Business overview with key metrics
2. **Capital Management** - Add and view capital entries
3. **Stock Management** - Manage inventory items
4. **Sales Management** - Record and view sales
5. **Expenses Management** - Track business expenses
6. **Reports** - Generate profit reports and analytics
7. **Settings** - App configuration and data management

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/biztracker.git
   cd biztracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Isar database files**
   ```bash
   dart run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── business_data.dart    # Data models (Capital, Stock, Sale, Expense, Profit)
│   └── business_data.g.dart  # Generated Isar schema
├── services/
│   ├── database_service.dart # Database operations
│   └── analytics_service.dart # Business analytics
├── screens/
│   ├── dashboard_screen.dart # Main dashboard
│   ├── capital_screen.dart   # Capital management
│   ├── stock_screen.dart     # Stock management
│   ├── sales_screen.dart     # Sales management
│   ├── expenses_screen.dart  # Expenses management
│   ├── reports_screen.dart   # Reports and analytics
│   └── settings_screen.dart  # App settings
└── utils/
    ├── glassmorphism_theme.dart # UI theme and glassmorphism utilities
    └── formatters.dart       # Data formatting utilities
```

## 🎯 Key Features Explained

### **Glassmorphism UI**
The app uses a custom glassmorphism design system with:
- Backdrop blur effects
- Semi-transparent containers
- Gradient backgrounds
- Modern color palette
- Smooth animations

### **Database Architecture**
- **Isar Database**: Fast, lightweight NoSQL database
- **Data Models**: Structured entities for business data
- **CRUD Operations**: Full create, read, update, delete functionality
- **Real-time Updates**: Instant data synchronization

### **Business Logic**
- **Profit Calculation**: Automatic revenue - expenses calculation
- **Business Health Score**: Multi-factor business performance assessment
- **Analytics**: Comprehensive business insights and trends
- **Data Validation**: Input validation and error handling

## 🔧 Configuration

### **Database Setup**
The app automatically initializes the Isar database on first launch. No additional configuration required.

### **Theme Customization**
Modify `lib/utils/glassmorphism_theme.dart` to customize:
- Color scheme
- Typography
- Glassmorphism effects
- Component styles

## 📊 Data Models

### **Capital**
- Amount, description, type (initial/additional)
- Date tracking and creation timestamps

### **Stock**
- Name, description, quantity, unit price
- Automatic total value calculation
- Creation and update timestamps

### **Sale**
- Product name, quantity, unit price
- Customer name, notes, sale date
- Automatic total amount calculation

### **Expense**
- Category, description, amount
- Payment method, expense date
- Creation timestamp

### **Profit**
- Revenue, expenses, net profit
- Profit margin calculation
- Date range tracking

## 🚀 Deployment

### **Android**
```bash
flutter build apk --release
```

### **iOS**
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Isar team for the fast database solution
- Glassmorphism design inspiration from modern UI trends

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Email: support@biztracker.app
- Documentation: [docs.biztracker.app](https://docs.biztracker.app)

---

**Made with ❤️ using Flutter and Isar**
