package com.example.backup_restore_application

import android.annotation.SuppressLint
import android.content.ContentValues
import android.content.Context
import android.net.Uri
import android.provider.CallLog
import android.provider.Telephony
import android.telephony.SmsManager
import android.telephony.SmsMessage
import android.util.Log
import androidx.annotation.NonNull
import com.example.backup_restore_application.model.BackupCallLog
import com.example.backup_restore_application.model.BackupSmsLog
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import java.text.SimpleDateFormat
import java.util.*

class MainActivity : FlutterActivity() {
    private val PHONE_CHANNEL = "com.backup_restore_application/phoneLogs"
    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PHONE_CHANNEL)
        channel.setMethodCallHandler { call, result ->
            if (call.method == "insertPhoneLogs") {
                val arguments = call.arguments as String

                val obj = Json.decodeFromString<List<BackupCallLog>>(arguments)
                obj.forEach { e -> insertCallLog(this, e) }
            }
//            if (call.method == "insertSmsLogs") {
//                val arguments = call.arguments as String
//
//                val obj = Json.decodeFromString<List<BackupSmsLog>>(arguments)
//                obj.forEach { e -> insertSmsLog(this, e) }
//            }
        }
    }

    private fun insertCallLog(mContext: Context, callLog: BackupCallLog) {
        val values = ContentValues()
        values.clear()
        values.put(CallLog.Calls.CACHED_NAME, callLog.name)
        values.put(CallLog.Calls.NUMBER, callLog.number)
        values.put(CallLog.Calls.TYPE, callLog.callType)
        values.put(CallLog.Calls.DATE, callLog.timestamp.toString())
        values.put(CallLog.Calls.DURATION, callLog.duration)
        values.put(CallLog.Calls.NEW, "0")
        mContext.contentResolver.insert(CallLog.Calls.CONTENT_URI, values)
    }

//    private fun insertSmsLog(mContext: Context, backupSmsLog: BackupSmsLog) {
//        Log.d("1", "2")
//        val values = ContentValues()
//        values.clear()
//        values.put(Telephony.Sms.Draft.ADDRESS, backupSmsLog.address)
//        values.put(Telephony.Sms.BODY, backupSmsLog.body)
//        values.put(Telephony.Sms.THREAD_ID, backupSmsLog.threadID)
//        values.put(Telephony.Sms.READ, backupSmsLog.read)
//        values.put(Telephony.Sms.DATE, backupSmsLog.date)
//        values.put(Telephony.Sms.DATE_SENT, backupSmsLog.dateSent)
//        mContext.contentResolver.insert(Telephony.Sms.CONTENT_URI, values);
//    }
}



