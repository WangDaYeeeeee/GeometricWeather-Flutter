package wangdaye.com.geometricweather_flutter.background.polling.services.permanent.update;

import androidx.core.app.NotificationCompat;

import java.util.List;
import java.util.Map;

import wangdaye.com.geometricweather_flutter.GeometricWeather;
import wangdaye.com.geometricweather_flutter.R;
import wangdaye.com.geometricweather_flutter.background.polling.services.basic.ForegroundUpdateService;

public class ForegroundTodayForecastUpdateService extends ForegroundUpdateService {

    @Override
    public void handlePollingResult(boolean updateFailed) {
        // do nothing.
    }

    @Override
    public NotificationCompat.Builder getForegroundNotification(int index, int total) {
        return super.getForegroundNotification(index, total)
                .setContentTitle(getString(R.string.geometric_weather) + " " + getString(R.string.forecast));
    }

    @Override
    public int getForegroundNotificationId() {
        return GeometricWeather.NOTIFICATION_ID_UPDATING_TODAY_FORECAST;
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
