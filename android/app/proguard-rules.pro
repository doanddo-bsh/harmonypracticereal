## Flutter wrapper
## io.flutter.** already covers app/, plugin/, plugins/, util/ and view/, so those
## subpackage lines were redundant and have been removed.
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

## No Firebase or Google Mobile Ads rules here on purpose. Both ship consumer
## ProGuard rules inside their AARs (play-services-ads-lite, firebase-common and
## play-services-measurement-api each contain a proguard.txt), so R8 already gets
## the keeps those libraries actually need. Blanket `-keep class ...** { *; }` rules
## would work against minifyEnabled/shrinkResources, and a blanket
## `-dontwarn com.google.firebase.**` would defeat android.r8.failOnMissingClasses
## and turn a missing class into a runtime NoClassDefFoundError.
