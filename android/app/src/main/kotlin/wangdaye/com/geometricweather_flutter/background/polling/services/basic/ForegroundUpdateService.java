package wangdaye.com.geometricweather_flutter.background.polling.services.basic;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Intent;
import android.os.Build;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.content.ContextCompat;

import java.util.Map;

import wangdaye.com.geometricweather_flutter.GeometricWeather;
import wangdaye.com.geometricweather_flutter.R;

public abstract class ForegroundUpdateService extends UpdateService {

    private int progress = 0;
    private int total = 0;
    
    @Override
    public void onCreate() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                    GeometricWeather.NOTIFICATION_CHANNEL_ID_BACKGROUND,
                    GeometricWeather.getNotificationChannelName(
                            this, GeometricWeather.NOTIFICATION_CHANNEL_ID_BACKGROUND),
                    NotificationManager.IMPORTANCE_MIN
            );
            channel.setShowBadge(false);
            channel.setLightColor(ContextCompat.getColor(this, R.color.colorPrimary));
            NotificationManagerCompat.from(this).createNotificationChannel(channel);
        }

        // version O.
        startForeground(
                getForegroundNotificationId(),
                getForegroundNotification(progress + 1, total).build()
        );

        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                    GeometricWeather.NOTIFICATION_CHANNEL_ID_BACKGROUND,
                    GeometricWeather.getNotificationChannelName(
                            this, GeometricWeather.NOTIFICATION_CHANNEL_ID_BACKGROUND),
                    NotificationManager.IMPORTANCE_MIN
            );
            channel.setShowBadge(false);
            channel.setLightColor(ContextCompat.getColor(this, R.color.colorPrimary));
            NotificationManagerCompat.from(this).createNotificationChannel(channel);
        }

        // version O.
        startForeground(
                getForegroundNotificationId(),
                getForegroundNotification(progress + 1, total).build()
        );
        return super.onStartCommand(intent, flags, startId);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        // version O.
        stopForeground(true);
        NotificationManagerCompat.from(this).cancel(getForegroundNotificationId());
    }

    @Override
    public void stopService(boolean updateFailed) {
        stopForeground(true);
        NotificationManagerCompat.from(this).cancel(getForegroundNotificationId());
        super.stopService(updateFailed);
    }

    public NotificationCompat.Builder getForegroundNotification(int index, int total) {
        this.total = total;
        return new NotificationCompat.Builder(this, GeometricWeather.NOTIFICATION_CHANNEL_ID_BACKGROUND)
                .setSmallIcon(R.drawable.ic_running_in_background)
                .setContentTitle(getString(R.string.geometric_weather))
                .setContentText(getString(R.string.feedback_updating_weather_data) + (total > 0 ? (" (" + index + "/" + total + ")") : ""))
                .setBadgeIconType(NotificationCompat.BADGE_ICON_NONE)
                .setPriority(NotificationCompat.PRIORITY_MIN)
                .setProgress(0, 0, true)
                .setColor(ContextCompat.getColor(this, R.color.colorPrimary))
                .setAutoCancel(false)
                .setOngoing(false);
    }

    public abstract int getForegroundNotificationId();

    // method handler.

    @Override
    public void onUpdateCompleted(Map<String, Object> location,
                                  boolean succeed,
                                  int index,
                                  int total) {
        progress ++;
        
        if (progress < total) {
            NotificationManagerCompat.from(this).notify(
                    getForegroundNotificationId(),
                    getForegroundNotification(progress + 1, total).build()
            );
        }
    }
}
