import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Charge les secrets de signing release depuis android/key.properties (gitignored).
// Absent => les builds release retombent sur la clé debug (dev), voir buildTypes.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.mozaiklabs.tune"
    // Play Store exige targetSdk >= 35 (voir defaultConfig). compileSdk fixé à 36 :
    // une dépendance AndroidX est compilée contre android-36 et refuse un compileSdk
    // inférieur. compileSdk (APIs dispo à la compilation) et targetSdk (comportement
    // runtime) sont indépendants — cf. message AGP.
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.mozaiklabs.tune"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Signe avec la clé release si key.properties existe, sinon retombe sur
            // la clé debug pour que les builds locaux fonctionnent sans keystore.
            signingConfig = if (keystorePropertiesFile.exists())
                signingConfigs.getByName("release")
            else
                signingConfigs.getByName("debug")
        }
    }
}

// Garde-fou « bibliothèques natives périmées » (#1751).
//
// Les `.so` embarqués sont versionnés dans le dépôt : rien n'empêchait un APK
// de partir avec un moteur de trois semaines et demie sous une interface
// récente — c'est arrivé (rust v0.8.354 sous l'app 0.9.76). La vérification est
// branchée sur `preBuild`, donc AUCUN build Android ne peut la contourner :
// ni `flutter build apk` en local, ni la CI de release.
//
// Elle échoue, elle n'avertit pas. Pour repartir d'un état sain, reconstruire
// les .so puis `scripts/check-native-libs.sh --update`.
val checkNativeLibs = tasks.register<Exec>("checkNativeLibs") {
    description = "Échoue si les libtuneserver.so embarqués ne sont pas ceux de la version construite (#1751)"
    // rootProject = android/ ; son parent = racine du dépôt Flutter.
    workingDir = rootProject.projectDir.parentFile
    commandLine("bash", "scripts/check-native-libs.sh")
}

tasks.matching { it.name == "preBuild" }.configureEach {
    dependsOn(checkNativeLibs)
}

flutter {
    source = "../.."
}
