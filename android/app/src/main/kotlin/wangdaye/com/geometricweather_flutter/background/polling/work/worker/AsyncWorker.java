package wangdaye.com.geometricweather_flutter.background.polling.work.worker;

import android.annotation.SuppressLint;
import android.content.Context;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import androidx.work.ListenableWorker;
import androidx.work.WorkerParameters;
import androidx.work.impl.utils.futures.SettableFuture;

import com.google.common.util.concurrent.ListenableFuture;

public abstract class AsyncWorker extends ListenableWorker {

    @Keep
    @SuppressLint("BanKeepAnnotation")
    public AsyncWorker(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
    }

    public abstract void doAsyncWork(SettableFuture<Result> future);

    @SuppressLint("RestrictedApi")
    @Override
    public final @NonNull
    ListenableFuture<Result> startWork() {
        // Package-private to avoid synthetic accessor.
        SettableFuture<Result> future = SettableFuture.create();
        doAsyncWork(future);
        return future;
    }
}
