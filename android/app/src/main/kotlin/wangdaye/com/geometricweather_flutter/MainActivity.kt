package wangdaye.com.geometricweather_flutter

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.view.WindowCompat
import androidx.lifecycle.Observer
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import wangdaye.com.geometricweather_flutter.bus.DataBus
import wangdaye.com.geometricweather_flutter.location.BackgroundLocationDialog
import wangdaye.com.geometricweather_flutter.location.LocationPlugin

class MainActivity: FlutterFragmentActivity(),
    BackgroundLocationDialog.Callback {

    private var requestLocationPermissionsResult: MethodChannel.Result? = null

    companion object {
        const val MSG_REQUEST_LOCATION_PERMISSIONS = "request_location_permissions"

        const val CODE_REQUEST_LOCATION_PERMISSIONS = 1
        const val CODE_REQUEST_BACKGROUND_LOCATION_PERMISSIONS = 999
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)

        DataBus.getInstance().with(
            MSG_REQUEST_LOCATION_PERMISSIONS,
            MethodChannel.Result::class.java
        ).observe(this, Observer {
            it?.let {
                requestLocationPermissionsResult = it
                LocationPlugin.requestPermissions(
                    this,
                    it,
                    CODE_REQUEST_LOCATION_PERMISSIONS
                )
            }
        })
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        LocationPlugin.register(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        fun isForegroundLocationPermission(permission: String): Boolean {
            return permission == Manifest.permission.ACCESS_COARSE_LOCATION
                    || permission == Manifest.permission.ACCESS_FINE_LOCATION
        }

        if (requestCode == CODE_REQUEST_LOCATION_PERMISSIONS) {
            var i = 0
            while (i < permissions.size && i < grantResults.size) {
                if (isForegroundLocationPermission(permissions[i])
                    && grantResults[i] != PackageManager.PERMISSION_GRANTED
                ) {
                    // denied basic location permissions.
                    requestLocationPermissionsResult?.success(false)
                    return
                }
                i ++
            }

            // check background location permissions.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q && ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.ACCESS_BACKGROUND_LOCATION
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                BackgroundLocationDialog().show(supportFragmentManager, null)
            }
            requestLocationPermissionsResult?.success(true)
            return
        }
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun requestBackgroundLocationPermission() {
        val permissionList: MutableList<String> = ArrayList()
        permissionList.add(Manifest.permission.ACCESS_BACKGROUND_LOCATION)

        requestPermissions(
            permissionList.toTypedArray(),
            CODE_REQUEST_BACKGROUND_LOCATION_PERMISSIONS
        )
    }
}
