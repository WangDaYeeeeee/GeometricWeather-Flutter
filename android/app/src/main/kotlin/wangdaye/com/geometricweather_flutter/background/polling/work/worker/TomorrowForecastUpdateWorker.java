package wangdaye.com.geometricweather_flutter.background.polling.work.worker;

import android.annotation.SuppressLint;
import android.content.Context;

import androidx.annotation.NonNull;
import androidx.work.WorkerParameters;
import androidx.work.impl.utils.futures.SettableFuture;

import java.util.List;
import java.util.Map;

import wangdaye.com.geometricweather_flutter.background.polling.BackgroundPlugin;
import wangdaye.com.geometricweather_flutter.background.polling.PollingManager;

public class TomorrowForecastUpdateWorker extends AsyncUpdateWorker {

    public TomorrowForecastUpdateWorker(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
    }

    @SuppressLint("RestrictedApi")
    @Override
    public void handleUpdateResult(SettableFuture<Result> future, boolean failed) {
        future.set(failed ? Result.failure() : Result.success());
        PollingManager.resetTomorrowForecastBackgroundTask(
                getApplicationContext(), 
                false, 
                true,
                true,
                BackgroundPlugin.getCachedTomorrowForecastEnabled(getApplicationContext()),
                BackgroundPlugin.getCachedTomorrowForecastTime(getApplicationContext())
        );
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

    @Override
    public void sendTomorrowForecast(Map<String, Object> location) {

    }
}
