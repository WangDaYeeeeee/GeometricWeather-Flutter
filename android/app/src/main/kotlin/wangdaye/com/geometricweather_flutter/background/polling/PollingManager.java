package wangdaye.com.geometricweather_flutter.background.polling;

import android.content.Context;

import wangdaye.com.geometricweather_flutter.background.polling.services.permanent.PermanentServiceHelper;
import wangdaye.com.geometricweather_flutter.background.polling.work.WorkerHelper;
import wangdaye.com.geometricweather_flutter.common.utils.IntentHelper;

public class PollingManager {

    public static void resetAllBackgroundTask(Context context,
                                              boolean forceRefresh,
                                              boolean backgroundFree,
                                              double pollingIntervalInHour,
                                              boolean todayForecastEnabled,
                                              String todayForecastTime,
                                              boolean tomorrowForecastEnabled,
                                              String tomorrowForecastTime) {

        if (forceRefresh) {
            forceRefresh(context, backgroundFree);
            return;
        }

        if (backgroundFree) {
            PermanentServiceHelper.stopPollingService(context);

            WorkerHelper.setNormalPollingWork(context, pollingIntervalInHour);

            if (todayForecastEnabled) {
                WorkerHelper.setTodayForecastUpdateWork(context, todayForecastTime, false);
            } else {
                WorkerHelper.cancelTodayForecastUpdateWork(context);
            }

            if (tomorrowForecastEnabled) {
                WorkerHelper.setTomorrowForecastUpdateWork(context, tomorrowForecastTime, false);
            } else {
                WorkerHelper.cancelTomorrowForecastUpdateWork(context);
            }
        } else {
            WorkerHelper.cancelNormalPollingWork(context);
            WorkerHelper.cancelTodayForecastUpdateWork(context);
            WorkerHelper.cancelTomorrowForecastUpdateWork(context);

            PermanentServiceHelper.startPollingService(
                    context,
                    pollingIntervalInHour,
                    todayForecastEnabled,
                    todayForecastTime,
                    tomorrowForecastEnabled,
                    tomorrowForecastTime
            );
        }
    }

    public static void resetNormalBackgroundTask(Context context,
                                                 boolean forceRefresh,
                                                 boolean backgroundFree,
                                                 double pollingIntervalInHour) {
        if (forceRefresh) {
            forceRefresh(context, backgroundFree);
            return;
        }

        if (backgroundFree) {
            PermanentServiceHelper.stopPollingService(context);

            WorkerHelper.setNormalPollingWork(
                    context,
                    pollingIntervalInHour);
        } else {
            WorkerHelper.cancelNormalPollingWork(context);
            WorkerHelper.cancelTodayForecastUpdateWork(context);
            WorkerHelper.cancelTomorrowForecastUpdateWork(context);

            PermanentServiceHelper.startPollingService(
                    context,
                    pollingIntervalInHour,
                    BackgroundPlugin.getCachedTodayForecastEnabled(context),
                    BackgroundPlugin.getCachedTodayForecastTime(context),
                    BackgroundPlugin.getCachedTomorrowForecastEnabled(context),
                    BackgroundPlugin.getCachedTomorrowForecastTime(context)
            );
        }
    }

    public static void resetTodayForecastBackgroundTask(Context context,
                                                        boolean forceRefresh,
                                                        boolean backgroundFree,
                                                        boolean nextDay,
                                                        boolean todayForecastEnabled,
                                                        String todayForecastTime) {
        if (forceRefresh) {
            forceRefresh(context, backgroundFree);
            return;
        }

        if (backgroundFree) {
            PermanentServiceHelper.stopPollingService(context);

            if (todayForecastEnabled) {
                WorkerHelper.setTodayForecastUpdateWork(context, todayForecastTime, nextDay);
            } else {
                WorkerHelper.cancelTodayForecastUpdateWork(context);
            }
        } else {
            WorkerHelper.cancelNormalPollingWork(context);
            WorkerHelper.cancelTodayForecastUpdateWork(context);
            WorkerHelper.cancelTomorrowForecastUpdateWork(context);

            PermanentServiceHelper.startPollingService(
                    context,
                    BackgroundPlugin.getCachedPollingIntervalInHour(context),
                    todayForecastEnabled,
                    todayForecastTime,
                    BackgroundPlugin.getCachedTomorrowForecastEnabled(context),
                    BackgroundPlugin.getCachedTomorrowForecastTime(context)
            );
        }
    }

    public static void resetTomorrowForecastBackgroundTask(Context context,
                                                           boolean forceRefresh,
                                                           boolean backgroundFree,
                                                           boolean nextDay,
                                                           boolean tomorrowForecastEnabled,
                                                           String tomorrowForecastTime) {
        if (forceRefresh) {
            forceRefresh(context, backgroundFree);
            return;
        }

        if (backgroundFree) {
            PermanentServiceHelper.stopPollingService(context);

            if (tomorrowForecastEnabled) {
                WorkerHelper.setTomorrowForecastUpdateWork(context, tomorrowForecastTime, nextDay);
            } else {
                WorkerHelper.cancelTomorrowForecastUpdateWork(context);
            }
        } else {
            WorkerHelper.cancelNormalPollingWork(context);
            WorkerHelper.cancelTodayForecastUpdateWork(context);
            WorkerHelper.cancelTomorrowForecastUpdateWork(context);

            PermanentServiceHelper.startPollingService(
                    context,
                    BackgroundPlugin.getCachedPollingIntervalInHour(context),
                    BackgroundPlugin.getCachedTodayForecastEnabled(context),
                    BackgroundPlugin.getCachedTodayForecastTime(context),
                    tomorrowForecastEnabled,
                    tomorrowForecastTime
            );
        }
    }

    private static void forceRefresh(Context context, boolean backgroundFree) {
        IntentHelper.startAwakeForegroundUpdateService(context);
        /*
        if (backgroundFree) {
            WorkerHelper.setExpeditedPollingWork(context);
        } else {
            IntentHelper.startAwakeForegroundUpdateService(context);
        }
        */
    }
}
