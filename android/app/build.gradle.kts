import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val mapsApiKey: String = run {
    val mapsProperties = Properties()
    val localMapsPropertiesFile = rootProject.file("local_maps.properties")
    
    if (localMapsPropertiesFile.exists()) {
        project.logger.info("Load maps properties from local file")
        localMapsPropertiesFile.inputStream().use { mapsProperties.load(it) }
    } else {
        project.logger.info("Load maps properties from environment")
        try {
            val envKey = System.getenv("MAPS_API_KEY")
            if (envKey != null) {
                mapsProperties["MAPS_API_KEY"] = envKey
            }
        } catch (e: Exception) {
            project.logger.warn("Failed to load MAPS_API_KEY from environment.", e)
        }
    }
    
    val key = mapsProperties.getProperty("MAPS_API_KEY") ?: ""
    if (key.isEmpty()) {
        project.logger.error("Google Maps Api Key not configured. Set it in `local_maps.properties` or in the environment variable `MAPS_API_KEY`")
    }
    key
}

android {
    namespace = "com.example.map_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }

    defaultConfig {
        applicationId = "com.example.map_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        manifestPlaceholders["MAPS_API_KEY"] = mapsApiKey
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {}
