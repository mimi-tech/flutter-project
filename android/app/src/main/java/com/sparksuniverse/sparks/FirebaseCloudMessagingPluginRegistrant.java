//package com.sparksuniverse.sparks;
//
//import io.flutter.plugin.common.PluginRegistry;
////import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;
//import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;
//
//public final class FirebaseCloudMessagingPluginRegistrant{
//    public static void registerWith(PluginRegistry registry) {
//        if (alreadyRegisteredWith(registry)) {
//            return;
//        }
//        FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebase.messaging"));
//    }
//
//    private static boolean alreadyRegisteredWith(PluginRegistry registry) {
//        final String key = FirebaseCloudMessagingPluginRegistrant.class.getCanonicalName();
//        if (registry.hasPlugin(key)) {
//            return true;
//        }
//        registry.registrarFor(key);
//        return false;
//    }
//}
