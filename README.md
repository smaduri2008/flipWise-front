# 💎 FlipWise iOS

AI-powered sneaker investment recommendations for iOS.

![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-3.0+-green.svg)

## ✨ Features

- 🔍 **Smart Search** - Search any sneaker by name or model
- 📊 **AI Analysis** - Get intelligent Buy/Hold/Sell recommendations
- 💰 **Profit Insights** - See potential profit margins and ROI
- 🎯 **Platform Recommendations** - Discover the best platforms to sell
- 📱 **Beautiful UI** - Native SwiftUI interface with smooth animations
- 🚀 **Real-time Results** - Fast API integration with loading states

## 🛠 Tech Stack

- **Framework**: SwiftUI
- **Language**: Swift 5.9+
- **Architecture**: MVVM (Model-View-ViewModel)
- **Networking**: URLSession with async/await
- **Minimum iOS**: 16.0+
- **Backend**: Flask API (Python)

## 📋 Requirements

- iOS 16.0 or later
- Xcode 15.0 or later
- macOS 13.0 or later (for development)
- Flask backend API running locally or on a server

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/smaduri2008/flipWise-front.git
cd flipWise-front
```

### 2. Open in Xcode

```bash
open FlipWise/FlipWise.xcodeproj
```

Or simply double-click the `.xcodeproj` file in Finder.

### 3. Configure API Endpoint

The app is configured to connect to a Flask backend running on `localhost:5001`. 

**For Simulator Testing (default):**
- No changes needed - uses `http://localhost:5001/api`

**For Real Device Testing:**
1. Find your computer's local IP address:
   ```bash
   ifconfig | grep "inet " | grep -v 127.0.0.1
   ```
   
2. Open `FlipWise/Services/APIService.swift`
3. Update the `baseURL`:
   ```swift
   static let baseURL = "http://YOUR_IP_ADDRESS:5001/api"
   ```
   For example: `http://192.168.1.100:5001/api`

### 4. Run the Flask Backend

Before running the iOS app, make sure your Flask API is running:

```bash
# Navigate to your Flask backend directory
cd path/to/flipwise-backend

# Activate virtual environment (if using one)
source venv/bin/activate

# Run the Flask server
python app.py
```

The Flask API should be running on `http://localhost:5001`

### 5. Build and Run

1. Select a simulator or connected device in Xcode
2. Press `Cmd + R` or click the Run button
3. The app will build and launch

## 📂 Project Structure

```
FlipWise/
├── FlipWiseApp.swift          # App entry point with @main
├── Models/
│   └── Shoe.swift             # Data models (Codable & Identifiable)
│       ├── Shoe               # Sneaker information
│       ├── Recommendation     # AI recommendation data
│       ├── Metrics            # Financial metrics
│       ├── AnalyzedShoe       # Combined shoe + recommendation
│       └── AnalyzeResponse    # API response wrapper
├── Views/
│   ├── ContentView.swift      # Main search screen with gradient
│   ├── ShoeCard.swift         # Card component for grid display
│   ├── ShoeDetailView.swift   # Full-screen detail modal
│   └── ErrorView.swift        # Error display component
├── ViewModels/
│   └── SneakerViewModel.swift # Business logic (@MainActor)
│       ├── @Published shoes   # Search results
│       ├── @Published isLoading
│       ├── @Published errorMessage
│       └── searchSneakers()   # Async search function
├── Services/
│   └── APIService.swift       # Network layer
│       └── analyzeSneakers()  # POST /api/analyze
├── Utils/
│   └── ColorExtension.swift   # Hex color support for SwiftUI
├── Resources/
│   └── Assets.xcassets/       # App assets and icons
└── Info.plist                 # App configuration
```

## 🎨 Design System

### Colors

- **Primary Gradient**: `#667eea` → `#764ba2`
- **Buy Badge**: Green
- **Hold Badge**: Orange  
- **Sell Badge**: Red

### Typography

- Uses SF Pro (system font)
- Dynamic type support
- Consistent font weights

### Components

- **Search Bar**: Clean white background with rounded corners
- **Shoe Cards**: Elevated cards with shadows and hover effects
- **Detail Modal**: Full-screen sheet presentation
- **Error View**: Centered with warning icon

## 🔌 API Integration

### Endpoint

```
POST http://localhost:5001/api/analyze
Content-Type: application/json

{
  "query": "Jordan 1"
}
```

### Response Format

```json
{
  "query": "Jordan 1",
  "count": 5,
  "results": [
    {
      "shoe": {
        "id": "555088-134",
        "name": "Air Jordan 1 Retro High OG Chicago",
        "brand": "Jordan",
        "colorway": "White/Black-Red",
        "image": "https://...",
        "release_date": "2015-05-30"
      },
      "recommendation": {
        "action": "BUY",
        "confidence": 85,
        "reason": "High demand and limited supply",
        "metrics": {
          "retail_price": 160.0,
          "average_resale_price": 450.0,
          "profit_margin": 290.0,
          "roi_percentage": 181.25
        },
        "best_platform": "StockX"
      }
    }
  ]
}
```

## 🧪 Testing

### Running the App

1. **In Simulator**: Use `localhost` as the API base URL
2. **On Device**: Update to your computer's local IP address
3. Ensure Flask backend is running before searching
4. Try searching: "Jordan 1", "Yeezy 350", "Dunk Low"

### Expected Behavior

1. App launches → Beautiful gradient screen
2. Enter search query → Search button activates
3. Tap search → Loading spinner appears
4. Results load → Cards animate into grid
5. Tap card → Detail modal slides up
6. View metrics → All data displayed correctly
7. Tap Done → Modal dismisses
8. Search again → Previous results clear

## 🐛 Troubleshooting

### "Failed to connect" Error

- ✅ Ensure Flask backend is running on port 5001
- ✅ Check that you're using the correct IP for device testing
- ✅ Verify Info.plist has `NSAllowsArbitraryLoads` enabled
- ✅ Check firewall isn't blocking connections

### Images Not Loading

- ✅ Verify image URLs from API are valid
- ✅ Check internet connection
- ✅ AsyncImage handles errors gracefully with placeholder

### Build Errors

- ✅ Ensure iOS deployment target is 16.0+
- ✅ Clean build folder: `Cmd + Shift + K`
- ✅ Update Xcode to latest version

## 📱 Screenshots

*(Screenshots will be added after running the app)*

## 🔐 Security Notes

- `NSAllowsArbitraryLoads` is enabled for local development
- **Important**: Before production/App Store release:
  - Remove `NSAllowsArbitraryLoads`
  - Use HTTPS for all API calls
  - Implement proper certificate pinning

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## 📄 License

This project is part of the FlipWise application suite.

## 🌟 Acknowledgments

- Built with SwiftUI
- Uses SF Symbols for icons
- Powered by AI-driven recommendations

## 📞 Support

For issues or questions:
- Open an issue on GitHub
- Check existing documentation
- Review API integration guide

---

**Made with ❤️ for sneaker enthusiasts**