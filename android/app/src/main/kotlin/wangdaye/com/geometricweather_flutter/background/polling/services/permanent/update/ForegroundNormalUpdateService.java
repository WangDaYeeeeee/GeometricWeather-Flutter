package wangdaye.com.geometricweather_flutter.background.polling.services.permanent.update;

import java.util.List;
import java.util.Map;

import wangdaye.com.geometricweather_flutter.GeometricWeather;
import wangdaye.com.geometricweather_flutter.background.polling.services.basic.ForegroundUpdateService;
import wangdaye.com.geometricweather_flutter.background.polling.services.permanent.PermanentServiceHelper;
import wangdaye.com.geometricweather_flutter.common.utils.LogHelper;

public class ForegroundNormalUpdateService extends ForegroundUpdateService {

    @Override
    public void onCreate() {
        super.onCreate();
        LogHelper.log("ForegroundNormalUpdateService on create");
    }

    @Override
    public void handlePollingResult(boolean updateFailed) {
        PermanentServiceHelper.updatePollingService(this, updateFailed);
    }

    @Override
    public int getForegroundNotificationId() {
        return GeometricWeather.NOTIFICATION_ID_UPDATING_NORMALLY;
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
