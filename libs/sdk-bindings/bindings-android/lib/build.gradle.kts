plugins {
    id("com.android.library")
    id("org.jetbrains.kotlin.android") version "1.6.10"
    id("maven-publish")
    id("kotlinx-serialization")
}

repositories {
    mavenCentral()
    google()
}

android {
    compileSdk = 33

    defaultConfig {
        minSdk = 24
        targetSdk = 33
        consumerProguardFiles("consumer-rules.pro")
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            proguardFiles(file("proguard-android-optimize.txt"), file("proguard-rules.pro"))
        }
    }

    publishing {
        singleVariant("release") {
            withSourcesJar()
        }
    }
}

dependencies {
    implementation("net.java.dev.jna:jna:5.8.0@aar")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7")
    implementation("androidx.appcompat:appcompat:1.4.0")
    implementation("androidx.core:core-ktx:1.7.0")
    implementation("org.tinylog:tinylog-api-kotlin:2.6.2")
    implementation("org.tinylog:tinylog-impl:2.6.2")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.6.2")
}

val libraryVersion: String by project

publishing {
    repositories {
        maven {
            name = "breezReposilite"
            url = uri("https://mvn.breez.technology/releases")
            credentials(PasswordCredentials::class)
            authentication {
                create<BasicAuthentication>("basic")
            }
        }
        maven {
            name = "breezGitHubPackages"
            url = uri("https://maven.pkg.github.com/breez/breez-sdk")
            credentials {
                username = System.getenv("GITHUB_ACTOR")
                password = System.getenv("GITHUB_TOKEN")
            }
        }
    }
    publications {
        create<MavenPublication>("maven") {
            groupId = "breez_sdk"
            artifactId = "bindings-android"
            version = libraryVersion

            afterEvaluate {
                from(components["release"])
            }

            pom {
                name.set("breez-sdk")
                description.set("The Breez SDK enables mobile developers to integrate Lightning and bitcoin payments into their apps with a very shallow learning curve.")
                url.set("https://breez.technology")
                licenses {
                    license {
                        name.set("MIT")
                        url.set("https://github.com/breez/breez-sdk/blob/main/LICENSE")
                    }
                }
                scm {
                    connection.set("scm:git:github.com/breez/breez-sdk-ffi.git")
                    developerConnection.set("scm:git:ssh://github.com/breez/breez-sdk.git")
                    url.set("https://github.com/breez/breez-sdk")
                }
            }
        }
    }
}
