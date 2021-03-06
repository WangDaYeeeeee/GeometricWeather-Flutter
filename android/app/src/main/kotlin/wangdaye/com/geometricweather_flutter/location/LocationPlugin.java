package wangdaye.com.geometricweather_flutter.location;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.util.Pair;

import androidx.core.app.ActivityCompat;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import wangdaye.com.geometricweather_flutter.MainActivity;
import wangdaye.com.geometricweather_flutter.common.bus.DataBus;

public class LocationPlugin {

    private static final String CHANNEL_NAME = "com.wangdaye.geometricweather/location";
    
    private static final String METHOD_REQUEST_LOCATION = "requestLocation";
    private static final String METHOD_GET_LAST_KNOWN_LOCATION = "getLastKnownLocation";
    private static final String METHOD_CANCEL_REQUEST = "cancelRequest";
    private static final String METHOD_IS_LOCATION_SERVICE_ENABLED = "isLocationServiceEnabled";
    private static final String METHOD_CHECK_PERMISSIONS = "checkPermissions";
    private static final String METHOD_REQUEST_PERMISSIONS = "requestPermissions";
    
    private static final String ERROR_CODE_LACK_OF_PERMISSION = "0";
    private static final String ERROR_CODE_TIMEOUT = "1";

    private static final String PARAM_IN_BACKGROUND = "inBackground";
    private static final String PARAM_LATITUDE = "latitude";
    private static final String PARAM_LONGITUDE = "longitude";

    public enum PermissionStatus {
        DENIED,
        FOREGROUND_ONLY,
        ALLOW_ALL_THE_TIME,
    }

    private static final NativeLocator locator = new NativeLocator();

    public static void register(Context context, BinaryMessenger messenger) {
        Context applicationContext = context.getApplicationContext();

        new MethodChannel(
                messenger,
                CHANNEL_NAME
        ).setMethodCallHandler((methodCall, result) -> {
            switch (methodCall.method) {
                case METHOD_REQUEST_LOCATION:
                    Boolean inBackground = methodCall.argument(PARAM_IN_BACKGROUND);

                    cancel();
                    requestLocation(
                            applicationContext,
                            inBackground != null && inBackground,
                            result
                    );
                    break;

                case METHOD_GET_LAST_KNOWN_LOCATION:
                    Pair<Double, Double> r = locator.getLastKnownLocation();
                    if (r == null) {
                        result.error(
                                ERROR_CODE_TIMEOUT,
                                "Location time out.",
                                null
                        );
                        return;
                    }

                    final Map<String, Double> map = new HashMap<>();
                    map.put(PARAM_LATITUDE, r.first);
                    map.put(PARAM_LONGITUDE, r.second);
                    result.success(map);
                    break;

                case METHOD_CANCEL_REQUEST:
                    cancel();
                    result.success(null);
                    break;

                case METHOD_IS_LOCATION_SERVICE_ENABLED:
                    result.success(
                            locator.isLocationEnabled(applicationContext)
                    );
                    break;

                case METHOD_CHECK_PERMISSIONS:
                    result.success(
                            checkPermissions(applicationContext).ordinal()
                    );
                    break;

                case METHOD_REQUEST_PERMISSIONS:
                    // send a message to call foreground activity to invoke requestPermissions method.
                    DataBus.getInstance().with(
                            MainActivity.MSG_REQUEST_LOCATION_PERMISSIONS, 
                            MethodChannel.Result.class
                    ).setValue(result);
                    break;

                default:
                    result.notImplemented();
                    break;
            }
        });
    }

    public static void requestLocation(Context context,
                                       boolean inBackground,
                                       MethodChannel.Result result) {
        PermissionStatus status = checkPermissions(context);
        if (status == PermissionStatus.DENIED) {
            result.error(
                    ERROR_CODE_LACK_OF_PERMISSION,
                    "Lack of permissions: ACCESS_COARSE_LOCATION or ACCESS_FINE_LOCATION",
                    null
            );
            return;
        }
        if (status == PermissionStatus.FOREGROUND_ONLY && inBackground) {
            result.error(
                    ERROR_CODE_LACK_OF_PERMISSION,
                    "Lack of permission: ACCESS_BACKGROUND_LOCATION",
                    null
            );
            return;
        }

        locator.requestLocation(
                context, 
                r -> {
                    if (r == null) {
                        result.error(
                                ERROR_CODE_TIMEOUT,
                                "Location time out.",
                                null
                        );
                        return;
                    }

                    final Map<String, Double> map = new HashMap<>();
                    map.put(PARAM_LATITUDE, r.first);
                    map.put(PARAM_LONGITUDE, r.second);
                    result.success(map);
                }
        );
    }

    public static void cancel() {
        locator.cancel();
    }
    
    public static PermissionStatus checkPermissions(Context context) {
        if (ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_COARSE_LOCATION
        ) != PackageManager.PERMISSION_GRANTED || ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_FINE_LOCATION
        ) != PackageManager.PERMISSION_GRANTED) {
            return PermissionStatus.DENIED;
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q
                && ActivityCompat.checkSelfPermission(
                context,
                Manifest.permission.ACCESS_BACKGROUND_LOCATION
        ) != PackageManager.PERMISSION_GRANTED) {
            return PermissionStatus.FOREGROUND_ONLY;
        }
        
        return PermissionStatus.ALLOW_ALL_THE_TIME;
    }

    public static void requestPermissions(Activity activity, 
                                          MethodChannel.Result result, 
                                          int requestCode) {
        // android R:   foreground location. (allow all the time manually)
        // android Q:   foreground location and background location.
        // android M-P: foreground location.


        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            result.success(false);
            return;
        }

        List<String> permissionList = new ArrayList<>();
        permissionList.add(Manifest.permission.ACCESS_COARSE_LOCATION);
        permissionList.add(Manifest.permission.ACCESS_FINE_LOCATION);
        if (Build.VERSION_CODES.Q <= Build.VERSION.SDK_INT
                && Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
            permissionList.add(Manifest.permission.ACCESS_BACKGROUND_LOCATION);
        }
        
        for (int i = permissionList.size() - 1; i >= 0; i --) {
            if (ActivityCompat.checkSelfPermission(
                    activity,
                    permissionList.get(i)
            ) == PackageManager.PERMISSION_GRANTED) {
                permissionList.remove(i);
            }
        }

        activity.requestPermissions(permissionList.toArray(new String[0]), requestCode);
    }
}