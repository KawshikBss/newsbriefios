-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider

-keepattributes Signature
-keepattributes *Annotation*
-keepclassmembers class * { @com.google.gson.annotations.SerializedName <fields>; }
-keepclassmembers class * { @com.google.firebase.database.PropertyName <methods>; }
-keepclassmembers class * { @com.google.firebase.database.Exclude <fields>; }
-keepclassmembers class * { @com.google.firebase.database.ServerValue <fields>; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
