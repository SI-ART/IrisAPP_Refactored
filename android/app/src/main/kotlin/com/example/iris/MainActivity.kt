package com.example.iris
import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.FlutterEngine

import io.flutter.plugin.common.MethodChannel

import io.flutter.plugins.GeneratedPluginRegistrant


import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.content.Context

import android.content.Intent

import android.net.Uri

import android.os.Build

import java.io.File

import io.flutter.embedding.android.FlutterFragmentActivity


import androidx.annotation.NonNull

import androidx.core.app.ActivityCompat

import androidx.core.content.ContextCompat

import androidx.core.content.FileProvider

import androidx.core.content.PermissionChecker


class MainActivity: FlutterFragmentActivity() {


    private val bluetoothAdapter: BluetoothAdapter? by lazy(LazyThreadSafetyMode.NONE) {
        val bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        bluetoothManager.adapter
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "iris")
            .setMethodCallHandler { call, result ->
                if (call.method.equals("viewPdf") || call.method.equals("viewExcel")) {
                    val path: String = call.argument("file_path")!!
                    if (!checkPermission(Manifest.permission.READ_EXTERNAL_STORAGE)) {
                        requestPermission(arrayOf<String>(Manifest.permission.READ_EXTERNAL_STORAGE))
                    } else {
                        launchFile(path)
                    }
                }else if (call.method.equals("checkBlueStatus"))
                {
                    result.success(checkBlueStatus());
                }else if (call.method.equals("enableBt"))
                {
                    result.success(enableBt());
                }else if (call.method.equals("disableBt"))
                {
                    result.success(disableBt());
                }
            }
    }
    private fun requestPermission(permission: Array<String>) {
        ActivityCompat.requestPermissions(this, permission, 1)
    }

    private fun checkPermission(permission: String): Boolean {
        return if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            true
        } else {
            if (ContextCompat.checkSelfPermission(
                    this,
                    permission
                ) === PermissionChecker.PERMISSION_GRANTED
            ) {
                true
            } else {
                false
            }
        }
    }

    private fun launchFile(filePath: String) {
        val file = File(filePath)
        if (file.exists()) {
            val intent = Intent(Intent.ACTION_VIEW)
            intent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            intent.addCategory("android.intent.category.DEFAULT")
            var uri: Uri? = null
            uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                val packageName: String = this.getPackageName()
                FileProvider.getUriForFile(this, "$packageName.fileProvider", File(filePath))
            } else {
                Uri.fromFile(file)
            }
            if (filePath.contains(".pdf")) intent.setDataAndType(
                uri,
                "application/pdf"
            ) else intent.setDataAndType(
                uri,
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            )
            try {
                this.startActivity(intent)
            } catch (e: Exception) {
                //Could not launch the file.
            }
        }
    }

    private fun checkBlueStatus(): Boolean? {
            return bluetoothAdapter?.isEnabled
    }


    private fun enableBt(): Boolean? {
        return  bluetoothAdapter?.enable()
    }

    private fun disableBt(): Boolean? {
        return  bluetoothAdapter?.disable()
    }

}