package wangdaye.com.geometricweather_flutter.location;

import android.annotation.SuppressLint;
import android.content.Context;
import android.location.Location;
import android.location.LocationManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Looper;
import android.provider.Settings;
import android.util.Pair;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

@SuppressLint("MissingPermission")
public class NativeLocator {
    
    @Nullable private LocationManager mLocationManager;

    @Nullable private LocationListener mNetworkListener;
    @Nullable private LocationListener mGPSListener;

    @Nullable private LocationCallback mLocationCallback;

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
        mNetworkListener = null;
        mGPSListener = null;

        mLocationCallback = null; 
    }

    public void requestLocation(Context context,
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

        if (mLocationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)) {
            mLocationManager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER,
                    0, 0, mNetworkListener, Looper.getMainLooper());
        }
        if (mLocationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
            mLocationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,
                    0, 0, mGPSListener, Looper.getMainLooper());
        }
    }

    @Nullable
    public Pair<Double, Double> getLastKnownLocation() {
        if (mLocationManager == null) {
            return null;
        }

        Location location = mLocationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
        if (location != null) {
            return new Pair<>(location.getLatitude(), location.getLongitude());
        }
        
        location = mLocationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);
        if (location != null) {
            return new Pair<>(location.getLatitude(), location.getLongitude());
        }

        location = mLocationManager.getLastKnownLocation(LocationManager.PASSIVE_PROVIDER);
        if (location != null) {
            return new Pair<>(location.getLatitude(), location.getLongitude());
        }
        
        return null;
    }

    public void cancel() {
        stopLocationUpdates();
        mLocationCallback = null;
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
