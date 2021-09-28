# PHWrapperApp

Dieses Swift-Package beinhaltet alle Klassen und Komponenten um die Wrapper-Apps des Palasthotels zu implementieren.

## Installation

1. Das Repo als Swift-Package über Xcode installieren.
2. Das Main-Storyboard wird nicht benötigt und muss entfernt werden
	- Eventuell wird in Zukunft eine Unterstützung für Storyboards hinzugefügt.
3. Im `SceneDelegate` in der Funktion `willConnectTo session: UISceneSession` den Code zum initialisieren hinzufügen:

```
guard let windowScene = (scene as? UIWindowScene) else { return }
				
let window = UIWindow(windowScene: windowScene)
window.rootViewController = PHWrapperApp.instantiate()
self.window = window
window.makeKeyAndVisible()
```

4. Es ist noch eine zusätzliche Konfiguration nötig in Form eines Objekts welches das `AppConfig`-Protokoll implementiert.

```
struct ExampleConfig: AppConfig {
	var credentials: (user: String, password: String) {
		(user: "user", password: "password")
	}
```

Dieses wird per Dependency-Injection ebenfalls im SceneDelegate direkt verfügbar gemacht:

```
Container.default.register(ExampleConfig() as AppConfig)
```

5. Außerdem muss Firebase entsprechend konfiguriert werden, also zumindest die `GoogleService-Info.plist` Datei vorhanden sein.

