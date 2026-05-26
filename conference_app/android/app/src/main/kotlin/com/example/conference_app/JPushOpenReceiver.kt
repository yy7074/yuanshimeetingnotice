package com.example.conference_app

import android.content.Context
import android.content.Intent
import cn.jpush.android.api.NotificationMessage
import cn.jpush.android.service.JPushMessageReceiver

class JPushOpenReceiver : JPushMessageReceiver() {
    override fun onNotifyMessageOpened(
        context: Context,
        notificationMessage: NotificationMessage,
    ) {
        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        launchIntent?.addCategory(Intent.CATEGORY_LAUNCHER)
        launchIntent?.addFlags(
            Intent.FLAG_ACTIVITY_NEW_TASK or
                Intent.FLAG_ACTIVITY_CLEAR_TOP or
                Intent.FLAG_ACTIVITY_SINGLE_TOP,
        )
        context.startActivity(launchIntent)
    }
}
