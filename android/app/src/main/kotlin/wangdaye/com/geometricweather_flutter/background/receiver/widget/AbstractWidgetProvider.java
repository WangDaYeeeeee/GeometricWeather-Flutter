package wangdaye.com.geometricweather_flutter.background.receiver.widget;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;

import wangdaye.com.geometricweather_flutter.background.polling.BackgroundPlugin;
import wangdaye.com.geometricweather_flutter.background.polling.PollingManager;

public abstract class AbstractWidgetProvider extends AppWidgetProvider {

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        super.onUpdate(context, appWidgetManager, appWidgetIds);
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
    }
}
