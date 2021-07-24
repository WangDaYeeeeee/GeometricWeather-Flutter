package wangdaye.com.geometricweather_flutter.background.polling.services.basic;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

import androidx.annotation.Nullable;

import java.util.List;
import java.util.Map;

import wangdaye.com.geometricweather_flutter.background.polling.PollingExecutor;
import wangdaye.com.geometricweather_flutter.background.polling.SenderPlugin;

public abstract class UpdateService extends Service
        implements SenderPlugin.MethodHandler {

    private final PollingExecutor pollingExecutor = new PollingExecutor(this);

    @Override
    public void onCreate() {
        super.onCreate();
        pollingExecutor.execute(this);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        pollingExecutor.dispose();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    public abstract void handlePollingResult(boolean updateFailed);

    public void stopService(boolean updateFailed) {
        handlePollingResult(updateFailed);
        stopSelf();
    }

    // method handler.

    @Override
    public void onPollingCompleted(List<Map<String, Object>> locationList,
                                   boolean succeed) {
        stopService(!succeed);
    }
}
