package wangdaye.com.geometricweather_flutter.background.polling.services.permanent;

import android.content.Context;
import android.content.Intent;
import android.os.Build;

import wangdaye.com.geometricweather_flutter.background.polling.services.permanent.observer.TimeObserverService;

/**
 * Service helper.
 * */

public class PermanentServiceHelper {

    public static void startPollingService(Context context,
                                           double pollingIntervalInHour,
                                           boolean todayForecastEnabled,
                                           String todayForecastTime,
                                           boolean tomorrowForecastEnabled,
                                           String tomorrowForecastTime) {
        Intent intent = new Intent(context, TimeObserverService.class).putExtra(
                TimeObserverService.KEY_CONFIG_CHANGED,
                true
        ).putExtra(
                TimeObserverService.KEY_POLLING_RATE,
                pollingIntervalInHour
        ).putExtra(
                TimeObserverService.KEY_TODAY_FORECAST_TIME,
                todayForecastEnabled ? todayForecastTime : ""
        ).putExtra(
                TimeObserverService.KEY_TOMORROW_FORECAST_TIME,
                tomorrowForecastEnabled ? tomorrowForecastTime : ""
        );
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(intent);
        } else {
            context.startService(intent);
        }
    }

    public static void updatePollingService(Context context, boolean pollingFailed) {
        Intent intent = new Intent(context, TimeObserverService.class);
        intent.putExtra(TimeObserverService.KEY_POLLING_FAILED, pollingFailed);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(intent);
        } else {
            context.startService(intent);
        }
    }

    public static void stopPollingService(Context context) {
        Intent intent = new Intent(context, TimeObserverService.class);
        context.stopService(intent);
    }
}
