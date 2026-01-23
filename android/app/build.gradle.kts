plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.money_manager"
    compileSdk = 34  // 👈 UBAH dari flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.azizafirdaus.financeapp"  // 👈 UBAH sesuai nama Anda
        minSdk = 21  // 👈 UBAH dari flutter.minSdkVersion
        targetSdk = 34  // 👈 UBAH dari flutter.targetSdkVersion
        versionCode = 1  // 👈 UBAH dari flutter.versionCode
        versionName = "1.0"  // 👈 UBAH dari flutter.versionName
        multiDexEnabled = true  // 👈 TAMBAHKAN untuk Firebase/Google Services
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}