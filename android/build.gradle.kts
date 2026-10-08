import org.jetbrains.kotlin.gradle.dsl.JvmTarget

// Pure Kotlin/JVM module: the shared domain logic an Android app's ViewModels
// call into. Unit tests run on the JVM with JUnit 4, like `testDebugUnitTest`.
plugins {
    kotlin("jvm") version "2.4.20"
    jacoco
}

dependencies {
    testImplementation("junit:junit:4.13.2")
}

java {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
}

kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

jacoco {
    toolVersion = "0.8.15"
}

tasks.test {
    useJUnit()
}

tasks.jacocoTestReport {
    reports {
        xml.required.set(true)
        html.required.set(false)
        csv.required.set(false)
    }
}
