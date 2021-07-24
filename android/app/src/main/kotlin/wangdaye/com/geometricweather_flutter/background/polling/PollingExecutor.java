package wangdaye.com.geometricweather_flutter.background.polling;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;

import androidx.annotation.Nullable;

import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.loader.FlutterLoader;
import io.flutter.view.FlutterCallbackInformation;
import wangdaye.com.geometricweather_flutter.language.LanguagePlugin;
import wangdaye.com.geometricweather_flutter.location.LocationPlugin;

public class PollingExecutor
        implements SenderPlugin.MethodHandler {

    private @Nullable FlutterEngine flutterEngine;
    private final SenderPlugin.MethodHandler methodHandler;

    public PollingExecutor(SenderPlugin.MethodHandler methodHandler) {
        this.methodHandler = methodHandler;
    }

    public void execute(Context c) {
        new Handler(Looper.getMainLooper()).post(() -> {
            if (flutterEngine != null) {
                return;
            }

            Context context = c.getApplicationContext();

            this.flutterEngine = new FlutterEngine(context);

            FlutterLoader flutterLoader = new FlutterLoader();
            if (!flutterLoader.initialized()) {
                flutterLoader.startInitialization(context);
            }

            Handler handler = new Handler(Looper.getMainLooper());

            flutterLoader.ensureInitializationCompleteAsync(context, null, handler, () -> {
                Long callbackHandle = BackgroundPlugin.getCachedDartPollingMethod(context);
                if (callbackHandle == null) {
                    return;
                }

                LanguagePlugin.register(flutterEngine.getDartExecutor().getBinaryMessenger());
                LocationPlugin.register(
                        context,
                        flutterEngine.getDartExecutor().getBinaryMessenger()
                );
                SenderPlugin.register(
                        flutterEngine.getDartExecutor().getBinaryMessenger(),
                        this
                );

                flutterEngine.getDartExecutor().executeDartCallback(
                        new DartExecutor.DartCallback(
                                context.getAssets(),
                                flutterLoader.findAppBundlePath(),
                                FlutterCallbackInformation.lookupCallbackInformation(callbackHandle)
                        )
                );
            });
        });
    }

    public void dispose() {
        new Handler(Looper.getMainLooper()).post(() -> {
            SenderPlugin.unregister(this);

            if (flutterEngine != null) {
                flutterEngine.destroy();
                flutterEngine = null;
            }
        });
    }

    // method handler.

    @Override
    public void onUpdateCompleted(Map<String, Object> location,
                                  boolean succeed,
                                  int index,
                                  int total) {
        methodHandler.onUpdateCompleted(location, succeed, index, total);
    }

    @Override
    public void onPollingCompleted(List<Map<String, Object>> locationList,
                                   boolean succeed) {
        methodHandler.onPollingCompleted(locationList, succeed);
        dispose();
    }

    @Override
    public void sendTodayForecast(Map<String, Object> location) {

    }

    @Override
    public void sendTomorrowForecast(Map<String, Object> location) {

    }
}
