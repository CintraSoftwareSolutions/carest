# flutter_stripe: push provisioning is an optional Stripe feature whose classes
# are not bundled. R8 sees them referenced by the SDK shim and fails the build
# unless told to ignore the missing references. (Standard flutter_stripe fix.)
-keep class com.stripe.android.** { *; }
-keep class com.reactnativestripesdk.** { *; }
-dontwarn com.stripe.android.pushProvisioning.**
-dontwarn com.reactnativestripesdk.**

# Firebase / Google Play services (defensive; their own consumer rules usually
# cover this, but keep annotations to be safe under shrinking).
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod
