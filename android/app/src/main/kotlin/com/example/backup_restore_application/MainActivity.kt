package com.example.backup_restore_application

import android.annotation.SuppressLint
import android.content.ContentValues
import android.content.Context
import android.provider.CallLog
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.serialization.Serializable
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import java.text.SimpleDateFormat
import java.util.*
import kotlin.math.log

class MainActivity: FlutterActivity() {
    private val PHONE_CHANNEL = "com.backup_restore_application/phoneLogs"
    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
      super.configureFlutterEngine(flutterEngine)

      channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PHONE_CHANNEL)
        channel.setMethodCallHandler { call, result ->
            if (call.method == "insertPhoneLogs") {
                val arguments = call.arguments as String

                val obj = Json.decodeFromString<List<CallLogBean>>(arguments)
                obj.forEach { e -> insertCallLog(this, e) }
            }
        }
    }

    @SuppressLint("SimpleDateFormat")
    fun dateFormatter(timestamp: Long): String {
        return SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(Date(timestamp)).toString()
    }

    private fun insertCallLog(mContext: Context, callLog: CallLogBean) {
        val values = ContentValues();
        values.clear();
        values.put(CallLog.Calls.CACHED_NAME, callLog.name);
        values.put(CallLog.Calls.NUMBER, callLog.number);
        values.put(CallLog.Calls.TYPE, callLog.callType);
        values.put(CallLog.Calls.DATE, callLog.timestamp.toString());
        values.put(CallLog.Calls.DURATION, callLog.duration);
        values.put(CallLog.Calls.NEW, "0");
        mContext.contentResolver.insert(CallLog.Calls.CONTENT_URI, values);
    }
}

@Serializable
data class CallLogBean(
    val name: String?,
   val number: String?,
   val formattedNumber: String?,
   val callType: String?,
   val duration: Int?,
   val timestamp: Long,
   val cachedNumberType: Int?,
   val cachedNumberLabel: Int?,
   val cachedMatchedNumber: String?,
   val simDisplayName: String?,
   val phoneAccountId: String?,
   ) {
}

