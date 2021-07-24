package wangdaye.com.geometricweather_flutter.background.polling.work.worker;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.work.WorkerParameters;
import androidx.work.impl.utils.futures.SettableFuture;

import java.util.List;
import java.util.Map;

import wangdaye.com.geometricweather_flutter.background.polling.PollingExecutor;
import wangdaye.com.geometricweather_flutter.background.polling.SenderPlugin;

public abstract class AsyncUpdateWorker extends AsyncWorker
        implements SenderPlugin.MethodHandler {

    private final PollingExecutor pollingExecutor = new PollingExecutor(this);
    private SettableFuture<Result> future;

    public AsyncUpdateWorker(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
    }

    @Override
    public void doAsyncWork(SettableFuture<Result> f) {
        future = f;
        pollingExecutor.execute(getApplicationContext());
    }

    // control.

    /**
     * Call {@link SettableFuture#set(Object)} here.
     * */
    public abstract void handleUpdateResult(SettableFuture<Result> future, boolean failed);

    // method handler.

    @Override
    public void onUpdateCompleted(Map<String, Object> location,
                                  boolean succeed,
                                  int index,
                                  int total) {

    }

    @Override
    public void onPollingCompleted(List<Map<String, Object>> locationList,
                                   boolean succeed) {
        handleUpdateResult(future, !succeed);
    }

    @Override
    public void sendTodayForecast(Map<String, Object> location) {
        
    }

    @Override
    public void sendTomorrowForecast(Map<String, Object> location) {
        
    }
}
