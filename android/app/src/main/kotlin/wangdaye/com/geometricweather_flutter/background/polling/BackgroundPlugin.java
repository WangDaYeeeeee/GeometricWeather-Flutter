package wangdaye.com.geometricweather_flutter.background.polling;

import android.content.Context;

import androidx.annotation.Nullable;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import wangdaye.com.geometricweather_flutter.settings.ConfigStore;

public class BackgroundPlugin {

    private static final String CHANNEL_NAME = "com.wangdaye.geometricweather/background";

    private static final String METHOD_RESET_ALL_BACKGROUND_TASK = "resetAllBackgroundTask";
    private static final String METHOD_RESET_POLLING_BACKGROUND_TASK = "resetPollingBackgroundTask";
    private static final String METHOD_RESET_TODAY_FORECAST_BACKGROUND_TASK = "resetTodayForecastBackgroundTask";
    private static final String METHOD_RESET_TOMORROW_FORECAST_BACKGROUND_TASK = "resetTomorrowForecastBackgroundTask";

    public static final String PARAM_DART_POLLING_METHOD = "dartPollingMethod";
    public static final String PARAM_BACKGROUND_FREE = "backgroundFree";
    public static final String PARAM_FORCE_UPDATE = "forceUpdate";
    public static final String PARAM_POLLING_INTERVAL_IN_HOUR = "pollingIntervalInHour";
    public static final String PARAM_NEXT_DAY = "nextDay";
    public static final String PARAM_TODAY_FORECAST_TIME = "todayForecastTime";
    public static final String PARAM_TODAY_FORECAST_ENABLED = "todayForecastEnabled";
    public static final String PARAM_TOMORROW_FORECAST_TIME = "tomorrowForecastTime";
    public static final String PARAM_TOMORROW_FORECAST_ENABLED = "tomorrowForecastEnabled";

    private static final double VALUE_DEFAULT_POLLING_INTERVAL_IN_HOUR = 1.5;
    public static final String VALUE_DEFAULT_TODAY_FORECAST_TIME = "08:00";
    public static final String VALUE_DEFAULT_TOMORROW_FORECAST_TIME = "20:00";
    
    private static final String CONFIG_STORE_NAME = "backgroundConfigs";

    @Nullable
    private static ConfigStore configStore;

    public static void register(Context context, BinaryMessenger messenger) {
        Context applicationContext = context.getApplicationContext();

        getBackgroundChannel(messenger).setMethodCallHandler((methodCall, result) -> {

            Long dartPollingMethod = methodCall.argument(PARAM_DART_POLLING_METHOD);
            Boolean forceUpdate = methodCall.argument(PARAM_FORCE_UPDATE);
            Boolean backgroundFree = methodCall.argument(PARAM_BACKGROUND_FREE);
            Double pollingIntervalInHour = methodCall.argument(PARAM_POLLING_INTERVAL_IN_HOUR);
            Boolean nextDay = methodCall.argument(PARAM_NEXT_DAY);
            Boolean todayForecastEnabled = methodCall.argument(PARAM_TODAY_FORECAST_ENABLED);
            String todayForecastTime = methodCall.argument(PARAM_TODAY_FORECAST_TIME);
            Boolean tomorrowForecastEnabled = methodCall.argument(PARAM_TOMORROW_FORECAST_ENABLED);
            String tomorrowForecastTime = methodCall.argument(PARAM_TOMORROW_FORECAST_TIME);

            cacheOptions(
                    applicationContext,
                    dartPollingMethod,
                    backgroundFree,
                    pollingIntervalInHour,
                    todayForecastEnabled,
                    todayForecastTime,
                    tomorrowForecastEnabled,
                    tomorrowForecastTime
            );

            switch (methodCall.method) {
                case METHOD_RESET_ALL_BACKGROUND_TASK:
                    PollingManager.resetAllBackgroundTask(
                            applicationContext,
                            forceUpdate != null && forceUpdate,
                            backgroundFree != null && backgroundFree,
                            pollingIntervalInHour == null
                                    ? VALUE_DEFAULT_POLLING_INTERVAL_IN_HOUR
                                    : pollingIntervalInHour,
                            todayForecastEnabled != null && todayForecastEnabled,
                            todayForecastTime == null
                                    ? VALUE_DEFAULT_TODAY_FORECAST_TIME
                                    : todayForecastTime,
                            tomorrowForecastEnabled != null && tomorrowForecastEnabled,
                            tomorrowForecastTime == null
                                    ? VALUE_DEFAULT_TOMORROW_FORECAST_TIME
                                    : tomorrowForecastTime
                    );
                    break;

                case METHOD_RESET_POLLING_BACKGROUND_TASK:
                    PollingManager.resetNormalBackgroundTask(
                            applicationContext,
                            forceUpdate != null && forceUpdate,
                            backgroundFree != null && backgroundFree,
                            pollingIntervalInHour == null
                                    ? VALUE_DEFAULT_POLLING_INTERVAL_IN_HOUR
                                    : pollingIntervalInHour
                    );
                    break;

                case METHOD_RESET_TODAY_FORECAST_BACKGROUND_TASK:
                    PollingManager.resetTodayForecastBackgroundTask(
                            applicationContext,
                            forceUpdate != null && forceUpdate,
                            backgroundFree != null && backgroundFree,
                            nextDay != null && nextDay,
                            todayForecastEnabled != null && todayForecastEnabled,
                            todayForecastTime == null
                                    ? VALUE_DEFAULT_TODAY_FORECAST_TIME
                                    : todayForecastTime
                    );
                    break;

                case METHOD_RESET_TOMORROW_FORECAST_BACKGROUND_TASK:
                    PollingManager.resetTomorrowForecastBackgroundTask(
                            applicationContext,
                            forceUpdate != null && forceUpdate,
                            backgroundFree != null && backgroundFree,
                            nextDay != null && nextDay,
                            tomorrowForecastEnabled != null && tomorrowForecastEnabled,
                            tomorrowForecastTime == null
                                    ? VALUE_DEFAULT_TOMORROW_FORECAST_TIME
                                    : tomorrowForecastTime
                    );
                    break;

                default:
                    result.notImplemented();
                    break;
            }
        });
    }

    public static MethodChannel getBackgroundChannel(BinaryMessenger messenger) {
        return new MethodChannel(messenger, CHANNEL_NAME);
    }

    private static void cacheOptions(Context context,
                                     @Nullable Long dartPollingMethod,
                                     @Nullable Boolean backgroundFree,
                                     @Nullable Double pollingIntervalInHour,
                                     @Nullable Boolean todayForecastEnabled,
                                     @Nullable String todayForecastTime,
                                     @Nullable Boolean tomorrowForecastEnabled,
                                     @Nullable String tomorrowForecastTime) {
        if (configStore == null) {
            configStore = ConfigStore.getInstance(context, CONFIG_STORE_NAME);
        }

        ConfigStore.Editor editor = configStore.edit();
        if (dartPollingMethod != null) {
            editor.putLong(PARAM_DART_POLLING_METHOD, dartPollingMethod);
        }
        if (backgroundFree != null) {
            editor.putBoolean(PARAM_BACKGROUND_FREE, backgroundFree);
        }
        if (pollingIntervalInHour != null) {
            editor.putFloat(PARAM_POLLING_INTERVAL_IN_HOUR, pollingIntervalInHour.floatValue());
        }
        if (todayForecastEnabled != null) {
            editor.putBoolean(PARAM_TODAY_FORECAST_ENABLED, todayForecastEnabled);
        }
        if (todayForecastTime != null) {
            editor.putString(PARAM_TODAY_FORECAST_TIME, todayForecastTime);
        }
        if (tomorrowForecastEnabled != null) {
            editor.putBoolean(PARAM_TOMORROW_FORECAST_ENABLED, tomorrowForecastEnabled);
        }
        if (tomorrowForecastTime != null) {
            editor.putString(PARAM_TOMORROW_FORECAST_TIME, tomorrowForecastTime);
        }
        editor.apply();
    }

    @Nullable
    public static Long getCachedDartPollingMethod(Context context) {
        if (configStore == null) {
            configStore = ConfigStore.getInstance(context, CONFIG_STORE_NAME);
        }
        if (configStore.contains(PARAM_DART_POLLING_METHOD)) {
            return configStore.getLong(PARAM_DART_POLLING_METHOD, 0);
        }

        return null;
    }

    public static boolean getCachedBackgroundFree(Context context) {
        if (configStore == null) {
            configStore = ConfigStore.getInstance(context, CHANNEL_NAME);
        }
        return configStore.getBoolean(PARAM_BACKGROUND_FREE, true);
    }

    public static double getCachedPollingIntervalInHour(Context context) {
        if (configStore == null) {
            configStore = ConfigStore.getInstance(context, CHANNEL_NAME);
        }
        return configStore.getFloat(
                PARAM_POLLING_INTERVAL_IN_HOUR,
                (float) VALUE_DEFAULT_POLLING_INTERVAL_IN_HOUR
        );
    }

    public static boolean getCachedTodayForecastEnabled(Context context) {
        if (configStore == null) {
            configStore = ConfigStore.getInstance(context, CHANNEL_NAME);
        }
        return configStore.getBoolean(PARAM_TODAY_FORECAST_ENABLED, false);
    }

    public static String getCachedTodayForecastTime(Context context) {
        if (configStore == null) {
            configStore = ConfigStore.getInstance(context, CHANNEL_NAME);
        }
        return configStore.getString(
                PARAM_TODAY_FORECAST_TIME,
                VALUE_DEFAULT_TODAY_FORECAST_TIME
        );
    }

    public static boolean getCachedTomorrowForecastEnabled(Context context) {
        if (configStore == null) {
            configStore = ConfigStore.getInstance(context, CHANNEL_NAME);
        }
        return configStore.getBoolean(PARAM_TOMORROW_FORECAST_ENABLED, false);
    }

    public static String getCachedTomorrowForecastTime(Context context) {
        if (configStore == null) {
            configStore = ConfigStore.getInstance(context, CHANNEL_NAME);
        }
        return configStore.getString(
                PARAM_TOMORROW_FORECAST_TIME,
                VALUE_DEFAULT_TOMORROW_FORECAST_TIME
        );
    }
}
