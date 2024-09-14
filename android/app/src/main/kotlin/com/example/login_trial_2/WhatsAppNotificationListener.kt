package com.example.login_trial_2

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.content.Intent

class WhatsAppNotificationListener : NotificationListenerService() {

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        if (sbn.packageName == "com.whatsapp") {
            val title = sbn.notification.extras.getString("android.title")
            val text = sbn.notification.extras.getString("android.text")

            val intent = Intent("com.example.login_trial_2.whatsappNotification")
            intent.putExtra("title", title)
            intent.putExtra("text", text)
            sendBroadcast(intent)
        }
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification) {
        // Handle notification removal if necessary
    }
}
