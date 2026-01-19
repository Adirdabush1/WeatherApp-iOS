# WeatherApp-iOS

iOS Weather App (UIKit) using OpenWeatherMap API with a clean MVVM-style separation.

אפליקציית מזג‑אוויר ל‑iOS (UIKit) שמבצעת קריאות ל‑OpenWeatherMap ומיישמת הפרדה נקייה בסגנון MVVM.

> Note: The repository currently contains the app source code (under `Sources/`) but does not include an Xcode project file (`.xcodeproj`).
> When running on macOS, you can create a new UIKit project and add these sources (instructions below).

> הערה: בריפו יש את קבצי המקור (תחת `Sources/`) אך אין קובץ פרויקט של Xcode (`.xcodeproj`).
> בהרצה על macOS ניתן ליצור פרויקט UIKit חדש ולהוסיף אליו את קבצי המקור (הוראות בהמשך).

## Features

## תכונות

- מסך ראשי (UITableView): שם עיר, טמפרטורה נוכחית, ואייקון מזג אוויר.
- מסך פרטים: טמפרטורת מינימום/מקסימום, לחות, ומהירות רוח.
- כפתור "רענן" במסך הפרטים.
- מחוון טעינה בזמן פנייה ל‑API.
- טיפול בשגיאות עם הודעות למשתמש.
- תמיכה ב‑Offline: הצגת הנתונים האחרונים שנשמרו במקרה של כשל רשת.

- Cities list (UITableView): city name, current temperature, and weather icon.
- Details screen: min/max temperature, humidity, wind speed.
- Refresh button on details.
- Loading indicator during API calls.
- Error handling with user-facing alerts.
- Offline mode: shows last cached data when network fails.

## Architecture

## ארכיטקטורה

הפרויקט בנוי בהפרדה נקייה בסגנון MVVM:

- `Models/`: מודלים של הדומיין.
- `Services/`: שכבת רשת ועזרים.
- `Persistence/`: שמירה מקומית / Cache.
- `ViewModels/`: מצב ולוגיקה עסקית עבור ה‑UI (ללא UIKit).
- `Views/`: מסכים/תצוגות UIKit.

This project follows a clean separation similar to MVVM:

- `Models/`: app domain models.
- `Services/`: networking and helpers.
- `Persistence/`: caching/local storage.
- `ViewModels/`: UI-facing state + business logic (no UIKit).
- `Views/`: UIKit views/controllers.

### Folder structure

### מבנה תיקיות

```
Sources/
	Models/
		City.swift
		Weather.swift
	Persistence/
		LocalStorage.swift
	Services/
		APIService.swift
		Config.swift
		ImageLoader.swift
		Secrets.swift (gitignored)
	ViewModels/
		WeatherListViewModel.swift
		DetailViewModel.swift
	Views/
		CityCell.swift
		WeatherListViewController.swift
		DetailView.swift
		DetailViewController.swift
```

## Technical choices

## בחירות טכניות

- **UIKit בלבד**: שימוש ב‑`UITableViewController`, `UIView`, `UITableViewCell`, Alerts ו‑Loading indicators.
- **Networking**: שימוש ב‑Alamofire לביצוע בקשות HTTP ול‑Decoding.
- **Persistence**: שימוש ב‑UserDefaults (JSON encode/decode) לשמירת מזג‑האוויר האחרון לכל עיר.
- **גישה Offline-first**: קודם מציגים cached (אם יש), ואז מבצעים רענון מה‑API.

- **UIKit only**: `UITableViewController`, `UIView`, `UITableViewCell`, alerts, activity indicators.
- **Networking**: Alamofire is used for HTTP requests and decoding.
- **Persistence**: UserDefaults (JSON encode/decode) for caching last known weather per city.
- **Offline-first UX**: UI renders cached values immediately (if present), then refreshes from network.

## API key setup

## הגדרת API Key

הקוד קורא את המפתח מ‑`Info.plist` (מפתח: `OPENWEATHER_API_KEY`) אם קיים.
בפיתוח מקומי יש fallback ל‑`Secrets.swift` (ב‑DEBUG בלבד).

- `Sources/Services/Secrets.swift` נמצא ב‑`.gitignore` ולכן לא אמור להיכנס ל‑git.
- `Sources/Services/Config.swift` אחראי לשלוף את המפתח בזמן ריצה.

The code reads the API key from `Info.plist` (key: `OPENWEATHER_API_KEY`) when available.
For local development it can fall back to `Secrets.swift` (DEBUG only).

- `Sources/Services/Secrets.swift` is **gitignored** and should not be committed.
- `Sources/Services/Config.swift` resolves the key at runtime.

## How to run (macOS + Xcode)

## איך מריצים (macOS + Xcode)

מכיוון שאין בריפו קובץ `.xcodeproj`, ההרצה נעשית כך:

1. צור פרויקט חדש ב‑Xcode:
	- Xcode → New Project → iOS → App
	- Interface: **Storyboard** או **SwiftUI** (לא משנה, נגדיר Root בצורה ידנית)
	- Language: **Swift**

2. הוסף את קבצי המקור:
	- גרור את התיקייה `Sources/` לתוך ה‑Project Navigator
	- ודא ש‑"Copy items if needed" מסומן ושה‑Target של האפליקציה מסומן

3. הוסף Alamofire (דרך Swift Package Manager):
	- File → Add Package Dependencies…
	- URL: `https://github.com/Alamofire/Alamofire`
	- הוסף ל‑app target

4. הגדר Root View Controller:
	- ב‑`SceneDelegate` (או `AppDelegate` בתבניות ישנות) הגדר:
	  - `UINavigationController(rootViewController: WeatherListViewController())`

5. הרץ על Simulator.

Because there is no `.xcodeproj` in this repo, run it like this:

1. Create a new Xcode project:
	 - Xcode → New Project → iOS → App
	 - Interface: **Storyboard** or **SwiftUI** (either is fine, we’ll replace root programmatically)
	 - Language: **Swift**

2. Add the source files:
	 - Drag the `Sources/` folder into the Xcode project navigator
	 - Ensure “Copy items if needed” is checked and the app target is selected

3. Add Alamofire (Swift Package Manager):
	 - File → Add Package Dependencies…
	 - URL: `https://github.com/Alamofire/Alamofire`
	 - Add to the app target

4. Set the root view controller:
	 - In `SceneDelegate` (or `AppDelegate` for older templates), set the root to:
		 - `UINavigationController(rootViewController: WeatherListViewController())`

5. Run on Simulator.

## Offline behavior

## עבודה במצב Offline

- במקרה שאין אינטרנט/כשל רשת: מוצגים הנתונים האחרונים שנשמרו לכל עיר (אם קיימים).
- מוצגת הודעת אזהרה למשתמש שאין חיבור זמין.

- If the device is offline, the app shows the last cached weather per city (if available).
- A user-facing alert is presented indicating there is no connection.

## Notes

## הערות

- טעינת אייקון מזג‑אוויר מתבצעת מ‑OpenWeatherMap: `https://openweathermap.org/img/wn/{icon}@2x.png`.
- הודעות שגיאה מסוימות (כמו עיר לא קיימת) מפוענחות מתוך גוף התגובה ומוצגות למשתמש.

- Weather icon is loaded from OpenWeatherMap: `https://openweathermap.org/img/wn/{icon}@2x.png`.
- Some errors (e.g., invalid city name) are parsed from the API error body and shown to the user.

## What’s next (optional improvements)

## המשך אפשרי (שיפורים אופציונליים)

- הוספת Reachability כדי להבחין בין Offline לבין שגיאות אחרות.
- מעבר מ‑UserDefaults ל‑CoreData לשמירה עשירה יותר במצב לא מקוון.
- הוספת בדיקות יחידה ל‑JSON decoding ול‑ViewModels.

- Add reachability monitoring to distinguish offline vs. other errors.
- Replace UserDefaults caching with CoreData for richer offline storage.
- Add unit tests for API decoding and ViewModels.
