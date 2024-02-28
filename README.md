### <img src="https://storage.googleapis.com/cms-storage-bucket/ec64036b4eacc9f3fd73.svg" width="90">  <img src="https://dart.dev/assets/img/logo/logo-white-text.svg" width="90"> 

### Adicionar pacote Geolocator
```terminal
Flutter pub add geolocator
```

## Permissionamento do dispositivo
### <img src="https://lh3.googleusercontent.com/WyC9P3QnQMmIqp9TF5kJbNZxyX8SMhOtW9crxuClnYVeKMSPmf6qHLywz5dV0iu3SuJV_zbZlPlAIX535d5P8ht0AdHxFSfJiG3JjI1AXQ2dXpxT4g=s0" width="32"> Android
Caminho: android / app / src / main / AndroidManifest.xml -> Dentro de ```<application> </application>```
```md
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

### <img src="https://upload.wikimedia.org/wikipedia/commons/1/1b/Apple_logo_grey.svg" width="15"> IOS

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


## <img src="https://upload.wikimedia.org/wikipedia/commons/1/1b/Apple_logo_grey.svg" width="15">  Outras permissões comuns para IOS
#### Limited Photos
```md
<key>PHPhotoLibraryPreventAutomaticLimitedAccessAlert</key> 
<true/>
```

#### Camera
```md
<key>NSCameraUsageDescription</key> 
<string>$(PRODUCT_NAME) camera description.</string>
```
#### Photos
```md
<key>NSPhotoLibraryUsageDescription</key> 
<string>$(PRODUCT_NAME)photos description.</string>
```
#### Save Photos
```md
<key>NSPhotoLibraryAddUsageDescription</key> 
<string>$(PRODUCT_NAME) photos add description.</string>
```
#### Location
```md
<key> NSLocationWhenInUseUsageDescription</key>
<string>$(PRODUCT_NAME) location description.</string>
```
#### Apple Music
```md
<key>NSAppleMusicUsageDescription</key>
<string>$(PRODUCT_NAME) My description about why I need this capability</string>
```
#### Calendar
```md
<key>NSCalendarsUsageDescription</key>
<string>$(PRODUCT_NAME) My description about why I need this capability</string>
```
#### Siri
```md
<key>NSSiriUsageDescription</key>
<string>$(PRODUCT_NAME) My description about why I need this capability</string>
```

## <img src="https://lh3.googleusercontent.com/WyC9P3QnQMmIqp9TF5kJbNZxyX8SMhOtW9crxuClnYVeKMSPmf6qHLywz5dV0iu3SuJV_zbZlPlAIX535d5P8ht0AdHxFSfJiG3JjI1AXQ2dXpxT4g=s0" width="32"> Outras permissões comuns para Android
#### Armazenamento Externo
```md
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

#### Câmera
```md
<uses-permission android:name="android.permission.CAMERA" />
```

#### Microfone
```md
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

#### Contatos
```md
<uses-permission android:name="android.permission.READ_CONTACTS" />
<uses-permission android:name="android.permission.WRITE_CONTACTS" />
```

#### SMS
```md
<uses-permission android:name="android.permission.SEND_SMS" />
<uses-permission android:name="android.permission.RECEIVE_SMS" />
<uses-permission android:name="android.permission.READ_SMS" />
<uses-permission android:name="android.permission.RECEIVE_MMS" />
```

#### Telefone
```md
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.CALL_PHONE" />
<uses-permission android:name="android.permission.PROCESS_OUTGOING_CALLS" />
```

#### Calendário
```md
<uses-permission android:name="android.permission.READ_CALENDAR" />
<uses-permission android:name="android.permission.WRITE_CALENDAR" />
```

#### Sensores
```md
<uses-permission android:name="android.permission.BODY_SENSORS" />
```

#### Notificações
```md
<uses-permission android:name="android.permission.ACCESS_NOTIFICATION_POLICY" />
```

#### Bluetooth
```md
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
```