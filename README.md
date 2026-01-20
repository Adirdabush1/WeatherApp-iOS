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
# WeatherApp-iOS

אפליקציית מזג‑אוויר ל‑iOS (מקוריות תחת `Sources/`).

בתמצית — הבחירות וההתנהגות העיקריות:

- **Alamofire** — ספרייה שמקצרת את העבודה ברשת, מפשטת בקשות HTTP וטיפול ב‑JSON (decoding).
- **NWPathMonitor** — ניטור חיבור רשת בזמן אמת (מחליף מודולים ישנים כמו Reachability).
- **CoreData** — אחסון מקומי מובנה לעבודה עם אובייקטים גדולים; מאפשר חיפוש, מיון וסינון ללא טעינת כל הנתונים לזיכרון.

התנהגות במצב Offline / חיבור לא יציב:

- שמירה של הנתונים האחרונים ב‑CoreData כ‑cache.
- ניטור רשת רציף בעזרת `NWPathMonitor`.
- בעת חוסר חיבור: הצגת הודעת אזהרה ל־המשתמש + הצגת הנתונים האחרונים מה‑cache.
- בעת ניסיון שליפה: הצגת גלגל טעינה (activity indicator).
- כשחיבור חוזר: Retry אוטומטי להורדת נתונים מהשרת, ובנוסף כפתור `רענן` לטעינה ידנית.

הרצה ופיתוח מקומי (קצר):

- הוסף את `Sources/` לפרויקט Xcode ו־Alamofire דרך Swift Package Manager.
- הגדר מפתח API ל‑OpenWeatherMap ב‑`Info.plist` (מפתח: `OPENWEATHER_API_KEY`) או ב‑`Secrets.swift` לפיתוח מקומי (מנוהל ב‑`.gitignore`).

אם תרצה, אעדכן פה דוגמת קוד לשימוש ב‑`NWPathMonitor` או דיאגרמת CoreData קצרה ל‑Entities/Attributes.

***
עוד נקודות: הקבצים העיקריים נמצאים תחת `Sources/` (Models, Services, Persistence, ViewModels, Views).  
README זה נועד להציג את הבחירות הטכניות המרכזיות ואת האופן שבו האפליקציה מתנהגת במצב לא מקוון.
***
- `Views/`: UIKit views/controllers.
test