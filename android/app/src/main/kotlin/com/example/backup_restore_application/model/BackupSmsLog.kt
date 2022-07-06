package com.example.backup_restore_application.model

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class BackupSmsLog(
    val address: String?,
    val body: String?,
    @SerialName("_id")
    val id: Long?,
    @SerialName("thread_id")
    val threadID: Long?,
    val read: Boolean?,
    val date: Long?,
    val dateSent: Long?,
)
