# PHWrapperApp

Dieses Swift-Package beinhaltet alle Klassen und Komponenten um die Wrapper-Apps des Palasthotels zu implementieren.

## Installation

1. Das Repo als Swift-Package über Xcode installieren.
2. Das Main-Storyboard wird nicht benötigt und muss entfernt werden
	- Eventuell wird in Zukunft eine Unterstützung für Storyboards hinzugefügt.
3. Im `SceneDelegate` in der Funktion `willConnectTo session: UISceneSession` den Code zum initialisieren hinzufügen:
	- Config initialisieren mit Zugangsdaten um `.htaccess`-Schutz zu umgehen.
	- Instanziieren des `PHWrapperApp`-Objekts, welches einen `UIViewController` zurückgibt.
	- Dieser wird der `.rootViewController` des App-Windows. 

```
guard let windowScene = (scene as? UIWindowScene) else { return }
				
let config = AppConfig(credentials: (user: "", password: ""))				
let window = UIWindow(windowScene: windowScene)
window.rootViewController = PHWrapperApp.instantiate(with: config)
self.window = window
window.makeKeyAndVisible()
```

5. Außerdem muss Firebase entsprechend konfiguriert werden, also zumindest die `GoogleService-Info.plist` Datei vorhanden sein.


## Versionshistorie

### 1.0.1
- Firebase Analytics als Dependency explizit hinzugefügt.

### 1.1
- Added a more convenient handling of `AppConfig` initialization in the SceneDelegate. 
