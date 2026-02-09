# FlipWise iOS App - Implementation Details

## 🎯 Project Overview

This document provides details about the complete iOS app implementation for FlipWise.

## 📱 Screens Implemented

### 1. ContentView (Main Search Screen)
**Features:**
- Beautiful gradient background (#667eea → #764ba2)
- Centered title: "Find Your Next Investment"
- Subtitle: "Search any sneaker to get AI-powered recommendations"
- Search bar with:
  - Magnifying glass icon
  - Placeholder: "Search sneakers (e.g., Jordan 1)"
  - Clear button (X icon) when text is entered
  - Submit on return key
- Search button with arrow icon
- Three states:
  - **Empty**: Shows search interface only
  - **Loading**: Shows spinner with "Analyzing sneakers..." text
  - **Results**: Shows grid of shoe cards
  - **Error**: Shows ErrorView component

### 2. ShoeCard Component
**Layout:**
```
┌─────────────────────────┐
│   [Shoe Image]          │  (200px height, white bg)
│                         │
├─────────────────────────┤
│ BRAND NAME              │  (uppercase, gray, small)
│ Shoe Name Here          │  (bold, 2 line max)
│ ┌──────────┐           │
│ │   BUY    │           │  (colored badge)
│ └──────────┘           │
│                         │
│ Retail      Resale      │
│ $160        $450        │
│                         │
│ Profit: $290           │  (green/red)
└─────────────────────────┘
```

**Features:**
- AsyncImage for lazy loading
- Rounded corners (16px)
- Shadow effect
- Tappable to open detail modal
- Color-coded badges:
  - BUY: Green
  - HOLD: Orange
  - SELL: Red

### 3. ShoeDetailView (Full-Screen Modal)
**Layout:**
```
┌─────────────────────────────┐
│ Details            [Done]   │  (Navigation bar)
├─────────────────────────────┤
│                             │
│   [Large Shoe Image]        │  (300px height)
│                             │
├─────────────────────────────┤
│ BRAND                       │
│ Full Shoe Name              │
│ Colorway Text               │
│                             │
│ Recommendation              │
│ ┌────────┐ 85% confidence  │
│ │  BUY   │                 │
│ └────────┘                 │
│ ┌─────────────────────────┐│
│ │ High demand and limited ││
│ │ supply make this a      ││
│ │ strong investment       ││
│ └─────────────────────────┘│
│                             │
│ Metrics                     │
│ ┌──────────┬──────────┐   │
│ │ Retail   │ Avg      │   │
│ │ Price    │ Resale   │   │
│ │ $160     │ $450     │   │
│ ├──────────┼──────────┤   │
│ │ Profit   │ ROI      │   │
│ │ Margin   │          │   │
│ │ $290     │ 181.2%   │   │
│ └──────────┴──────────┘   │
│                             │
│ Best Platform               │
│ ⭐ StockX                   │
│                             │
│ Release Date                │
│ May 30, 2015                │
│                             │
└─────────────────────────────┘
```

### 4. ErrorView Component
**Features:**
- Warning triangle icon (48pt)
- Error message text
- White semi-transparent background
- Rounded corners
- Shadow effect
- Centered in screen

## 🏗️ Architecture (MVVM)

### Models
- **Shoe**: Contains shoe information (id, name, brand, colorway, image, release_date)
- **Recommendation**: Contains AI recommendation (action, confidence, reason, metrics, best_platform)
- **Metrics**: Contains financial data (retail_price, average_resale_price, profit_margin, roi_percentage)
- **AnalyzedShoe**: Combines Shoe + Recommendation
- **AnalyzeResponse**: API response wrapper

### Views
- **ContentView**: Main coordinator view
- **ShoeCard**: Reusable card component
- **ShoeDetailView**: Detail modal presentation
- **ErrorView**: Error display component

### ViewModels
- **SneakerViewModel**: Business logic and state management
  - Manages search state
  - Calls API service
  - Updates UI through @Published properties

### Services
- **APIService**: Network layer
  - Handles API communication
  - Error handling
  - async/await pattern

## 🔌 API Integration

### Request
```swift
POST http://localhost:5001/api/analyze
Content-Type: application/json

{
  "query": "Jordan 1"
}
```

### Response
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

## 🎨 Color Scheme

```swift
// Primary Gradient
Color(hex: "667eea") // Purple-blue
Color(hex: "764ba2") // Purple

// Badge Colors
.green   // BUY
.orange  // HOLD
.red     // SELL

// Text Colors
.white      // Main text on gradient
.primary    // Content text
.secondary  // Subtle text
.gray       // Labels
```

## 📐 Layout Specifications

### ContentView
- Search section: Centered, max-width container
- Title: 32pt bold
- Subtitle: System subheadline
- Search bar: 16pt padding, white background
- Grid: Auto-fill columns, minimum 280px
- Grid spacing: 16pt

### ShoeCard
- Card padding: 16pt
- Corner radius: 16pt
- Image height: 200px
- Shadow: Radius 8, offset Y 4
- Brand text: Caption, uppercase
- Name text: Headline, bold, 2 line limit
- Badge: 12pt horizontal padding, 6pt vertical
- Price row: HStack with Spacer

### ShoeDetailView
- Image height: 300px
- Section spacing: 24pt
- Metric cards: 2 column grid
- Metric card padding: 16pt
- Reason box: 16pt padding, gray background

## 🚀 Setup Instructions

### For Developers

1. **Open Project**
   ```bash
   open FlipWise.xcodeproj
   ```

2. **Select Target**
   - iOS 16.0 or later
   - Any iPhone or iPad

3. **Configure API**
   - Simulator: Use `localhost:5001` (default)
   - Device: Update `APIService.baseURL` with your computer's IP

4. **Run Flask Backend**
   ```bash
   python app.py  # Runs on port 5001
   ```

5. **Build & Run**
   - Press Cmd+R in Xcode
   - Or click Play button

### For Real Device Testing

Find your IP address:
```bash
ifconfig | grep "inet " | grep -v 127.0.0.1
```

Update `APIService.swift`:
```swift
static let baseURL = "http://YOUR_IP_ADDRESS:5001/api"
// Example: "http://192.168.1.100:5001/api"
```

## ✨ Features Implemented

- [x] Search functionality with loading state
- [x] Beautiful gradient UI
- [x] Card-based grid layout
- [x] Async image loading
- [x] Full-screen detail modal
- [x] Color-coded recommendations
- [x] Profit/ROI calculations
- [x] Platform recommendations
- [x] Error handling
- [x] Keyboard dismissal
- [x] Clear search button
- [x] SwiftUI animations
- [x] MVVM architecture
- [x] Async/await networking
- [x] Safe area handling
- [x] Responsive layout

## 🔒 Security Notes

⚠️ **Development Mode**
- `NSAllowsArbitraryLoads` is enabled for localhost testing
- This allows HTTP connections (not just HTTPS)

⚠️ **Production Requirements**
Before App Store submission:
1. Remove `NSAllowsArbitraryLoads`
2. Use HTTPS for all API calls
3. Implement certificate pinning
4. Add proper error handling for network failures
5. Add analytics and crash reporting

## 📱 Device Support

- **iPhone**: All models running iOS 16.0+
- **iPad**: All models running iOS 16.0+
- **Orientations**: Portrait (primary), supports all orientations on iPad
- **Dark Mode**: Automatically supported via system colors
- **Dynamic Type**: Supported through system fonts

## 🧪 Testing Checklist

- [ ] App launches successfully
- [ ] Search bar accepts input
- [ ] Search button disabled when empty
- [ ] Loading spinner appears on search
- [ ] Cards display properly in grid
- [ ] Images load asynchronously
- [ ] Card tap opens detail modal
- [ ] All data displays in detail view
- [ ] Done button dismisses modal
- [ ] Error view shows on API failure
- [ ] Clear button works
- [ ] Return key submits search
- [ ] Keyboard dismisses properly
- [ ] Layout responsive on different screen sizes

## 📞 Support

For issues or questions:
- Check README.md for setup instructions
- Verify Flask backend is running
- Check API endpoint configuration
- Review Info.plist settings

---

**Implementation Complete** ✅
All requirements from the problem statement have been implemented.
