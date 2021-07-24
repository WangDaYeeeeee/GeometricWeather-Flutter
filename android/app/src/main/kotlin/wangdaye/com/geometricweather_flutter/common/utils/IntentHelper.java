package wangdaye.com.geometricweather_flutter.common.utils;

import android.content.Context;
import android.content.Intent;

import androidx.core.content.ContextCompat;

import wangdaye.com.geometricweather_flutter.background.polling.services.basic.AwakeForegroundUpdateService;

public class IntentHelper {

    public static void startAwakeForegroundUpdateService(Context context) {
        ContextCompat.startForegroundService(context, getAwakeForegroundUpdateServiceIntent(context));
    }

    public static Intent getAwakeForegroundUpdateServiceIntent(Context context) {
        return new Intent(context, AwakeForegroundUpdateService.class);
    }
}
