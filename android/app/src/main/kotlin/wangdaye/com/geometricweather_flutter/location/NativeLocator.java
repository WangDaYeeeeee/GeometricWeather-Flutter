package wangdaye.com.geometricweather_flutter.location;


import android.annotation.SuppressLint;
import android.content.Context;
import android.location.Location;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.provider.Settings;
import android.util.Pair;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

@SuppressLint("MissingPermission")
public class NativeLocator {

    private final Handler mTimer;

    @Nullable private LocationManager mLocationManager;

    @Nullable private LocationListener mNetworkListener;
    @Nullable private LocationListener mGPSListener;

    @Nullable private LocationCallback mLocationCallback;
    @Nullable private Location mLastKnownLocation;

    public interface LocationCallback {
        void onCompleted(@Nullable Pair<Double, Double> geoPosition);
    }
    
    private class LocationListener implements android.location.LocationListener {

        @Override
        public void onLocationChanged(Location location) {
            if (location != null) {
                stopLocationUpdates();
                handleLocation(location);
            }
        }

        @Override
        public void onStatusChanged(String provider, int status, Bundle extras) {
            // do nothing.
        }

        @Override
        public void onProviderEnabled(String provider) {
            // do nothing.
        }

        @Override
        public void onProviderDisabled(String provider) {
            // do nothing.
        }
    }

    public NativeLocator() {
        mTimer = new Handler(Looper.getMainLooper());

        mNetworkListener = null;
        mGPSListener = null;

        mLocationCallback = null;
        mLastKnownLocation = null;
    }

    public void requestLocation(Context context,
                                long timeOutMillis, 
                                @NonNull LocationCallback callback){
        if (mLocationManager == null) {
            mLocationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        }

        if (mLocationManager == null) {
            callback.onCompleted(null);
            return;
        }

        mNetworkListener = new LocationListener();
        mGPSListener = new LocationListener();

        mLocationCallback = callback;
        mLastKnownLocation = getLastKnownLocation();

        if (mLocationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)) {
            mLocationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER,
                    0, 0, mNetworkListener, Looper.getMainLooper());
        }
        if (mLocationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
            mLocationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,
                    0, 0, mGPSListener, Looper.getMainLooper());
        }

        mTimer.postDelayed(() -> {
            stopLocationUpdates();
            handleLocation(mLastKnownLocation);
        }, timeOutMillis);
    }

    @Nullable
    private Location getLastKnownLocation() {
        if (mLocationManager == null) {
            return null;
        }

        Location location = mLocationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
        if (location != null) {
            return location;
        }
        location = mLocationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
        if (location != null) {
            return location;
        }
        return mLocationManager.getLastKnownLocation(LocationManager.PASSIVE_PROVIDER);
    }

    public void cancel() {
        stopLocationUpdates();
        mLocationCallback = null;
        mTimer.removeCallbacksAndMessages(null);
    }

    private void stopLocationUpdates() {
        if (mLocationManager != null) {
            if (mNetworkListener != null) {
                mLocationManager.removeUpdates(mNetworkListener);
                mNetworkListener = null;
            }
            if (mGPSListener != null) {
                mLocationManager.removeUpdates(mGPSListener);
                mGPSListener = null;
            }
        }
    }

    private void handleLocation(@Nullable Location location) {
        if (mLocationCallback != null) {
            mLocationCallback.onCompleted(
                    location == null ? null : new Pair<>(
                            location.getLatitude(), 
                            location.getLongitude()
                    )
            );
            mLocationCallback = null;
        }
    }

    public boolean isLocationEnabled(Context context) {
        if (mLocationManager == null) {
            mLocationManager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        }
        if (mLocationManager == null) {
            return false;
        }
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            if (!mLocationManager.isLocationEnabled()) {
                return false;
            }
        } else {
            int locationMode = -1;
            try {
                locationMode = Settings.Secure.getInt(
                        context.getContentResolver(),
                        Settings.Secure.LOCATION_MODE
                );
            } catch (Settings.SettingNotFoundException e) {
                e.printStackTrace();
            }
            if (locationMode == Settings.Secure.LOCATION_MODE_OFF) {
                return false;
            }
        }

        return mLocationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
                || mLocationManager.isProviderEnabled(LocationManager.GPS_PROVIDER);
    }
}
