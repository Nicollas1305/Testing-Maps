## Adicionar pacote geolocator
```terminal
Flutter pub add geolocator
```

## Permissionamento do dispositivo
#### Android
Caminho: android / app / src / main / AndroidManifest.xml -> Dentro de ```<application> </application>```
```md
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

### IOS
Caminho: ios / Runner / info.plist -> Dentro de ```<dict> </dict>```
```md
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background.</string>
```

## Instalando o Google Maps para Flutter
Android
Caminho: android / app / src / main / AndroidManifest.xml
```md
<meta-data android:name="com.google.android.geo.API_KEY" android:value="INSERIR_GOOGLE_MAPS_API_KEI" />
```

IOS
Caminho: ios / Runner / AppDelegate.swift -> dentro de Bool {}
```swift
import GoogleMaps
GMSServices.provideAPIKey("INSERIR_GOOGLE_MAPS_API_KEI")
```


## Outras permissões comuns para IOS
#### Limited Photos
```plist
<key>PHPhotoLibraryPreventAutomaticLimitedAccessAlert</key> 
<true/>
```

#### Camera
```plist
<key>NSCameraUsageDescription</key> 
<string>$(PRODUCT_NAME) camera description.</string>
```
#### Photos
```plist
<key>NSPhotoLibraryUsageDescription</key> 
<string>$(PRODUCT_NAME)photos description.</string>
```
#### Save Photos
```plist
<key>NSPhotoLibraryAddUsageDescription</key> 
<string>$(PRODUCT_NAME) photos add description.</string>
```
#### Location
```plist
<key> NSLocationWhenInUseUsageDescription</key>
<string>$(PRODUCT_NAME) location description.</string>
```
#### Apple Music
```plist
<key>NSAppleMusicUsageDescription</key>
<string>$(PRODUCT_NAME) My description about why I need this capability</string>
```
#### Calendar
```plist
<key>NSCalendarsUsageDescription</key>
<string>$(PRODUCT_NAME) My description about why I need this capability</string>
```
#### Siri
```plist
<key>NSSiriUsageDescription</key>
<string>$(PRODUCT_NAME) My description about why I need this capability</string>
```