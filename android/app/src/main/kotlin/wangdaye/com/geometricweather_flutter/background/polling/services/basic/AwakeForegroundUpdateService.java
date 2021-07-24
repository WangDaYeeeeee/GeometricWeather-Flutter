package wangdaye.com.geometricweather_flutter.background.polling.services.basic;

import java.util.List;
import java.util.Map;

import wangdaye.com.geometricweather_flutter.GeometricWeather;
import wangdaye.com.geometricweather_flutter.background.polling.BackgroundPlugin;
import wangdaye.com.geometricweather_flutter.background.polling.PollingManager;

public class AwakeForegroundUpdateService extends ForegroundUpdateService {

    @Override
    public void handlePollingResult(boolean updateFailed) {
        PollingManager.resetAllBackgroundTask(
                this,
                false,
                BackgroundPlugin.getCachedBackgroundFree(this),
                BackgroundPlugin.getCachedPollingIntervalInHour(this),
                BackgroundPlugin.getCachedTodayForecastEnabled(this),
                BackgroundPlugin.getCachedTodayForecastTime(this),
                BackgroundPlugin.getCachedTomorrowForecastEnabled(this),
                BackgroundPlugin.getCachedTomorrowForecastTime(this)
        );
    }

    @Override
    public int getForegroundNotificationId() {
        return GeometricWeather.NOTIFICATION_ID_UPDATING_AWAKE;
    }

    // method handler.

    @Override
    public void onUpdateCompleted(Map<String, Object> location,
                                  boolean succeed,
                                  int index,
                                  int total) {
        // todo: update remote views.
    }

    @Override
    public void onPollingCompleted(List<Map<String, Object>> locationList,
                                   boolean succeed) {
        // todo: update remote views.
        super.onPollingCompleted(locationList, succeed);
    }
}
