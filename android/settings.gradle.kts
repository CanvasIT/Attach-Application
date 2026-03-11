// here is all the gradle configuration for the project, including the plugins and dependencies
//plugin managment is used to tell gradle where to find the plugins and which version to use, in this case we are using the flutter plugin and the android plugin, we also have the google services plugin for firebase and the kotlin plugin for android development
pluginManagement {
    val flutterSdkPath = run {
        val properties = java.util.Properties()
        file("local.properties").inputStream().use { properties.load(it) }
        val flutterSdkPath = properties.getProperty("flutter.sdk")
        require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
        flutterSdkPath
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
//plugins block is used to apply the plugins to the project, in this case we are applying the flutter plugin and the android plugin, we also have the google services plugin for firebase and the kotlin plugin for android development, we are using the version 1.0.0 for the flutter plugin, version 8.7.0 for the android plugin, version 4.3.15 for the google services plugin and version 2.1.0 for the kotlin plugin, we are also using apply false to not apply the plugins to all subprojects, we will apply them only to the app module in the build.gradle file of the app module
plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.7.0" apply false
    // START: FlutterFire Configuration
    id("com.google.gms.google-services") version("4.3.15") apply false
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")
