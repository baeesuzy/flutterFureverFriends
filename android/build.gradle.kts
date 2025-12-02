allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

plugins {
    
    
    // 3. 👇 Add the Firebase Google Services DECLARATION here 👇
    id("com.google.gms.google-services") version "4.4.4" apply false
}

// ... rest of the file starts below (allprojects, subprojects, etc.)

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
