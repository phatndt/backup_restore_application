package com.example.backup_restore_application.model

import kotlinx.serialization.Serializable

@Serializable
data class BackupCallLog(
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