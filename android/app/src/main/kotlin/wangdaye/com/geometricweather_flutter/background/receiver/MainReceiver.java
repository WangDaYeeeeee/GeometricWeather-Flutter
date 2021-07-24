package wangdaye.com.geometricweather_flutter.background.receiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;

import wangdaye.com.geometricweather_flutter.background.polling.BackgroundPlugin;
import wangdaye.com.geometricweather_flutter.background.polling.PollingManager;

/**
 * Main receiver.
 * */

public class MainReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        if (TextUtils.isEmpty(action)) {
            return;
        }
        switch (action) {
            case Intent.ACTION_BOOT_COMPLETED:
            case Intent.ACTION_WALLPAPER_CHANGED:
                PollingManager.resetAllBackgroundTask(
                        context,
                        true,
                        BackgroundPlugin.getCachedBackgroundFree(context),
                        BackgroundPlugin.getCachedPollingIntervalInHour(context),
                        BackgroundPlugin.getCachedTodayForecastEnabled(context),
                        BackgroundPlugin.getCachedTodayForecastTime(context),
                        BackgroundPlugin.getCachedTomorrowForecastEnabled(context),
                        BackgroundPlugin.getCachedTomorrowForecastTime(context)
                );
                break;
        }
    }
}