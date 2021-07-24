package wangdaye.com.geometricweather_flutter.language;

import android.content.Context;
import android.content.res.Resources;
import android.os.Build;
import android.text.TextUtils;
import android.util.Pair;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import wangdaye.com.geometricweather_flutter.MainActivity;
import wangdaye.com.geometricweather_flutter.common.bus.DataBus;

public class LanguagePlugin {

    private static final String CHANNEL_NAME = "com.wangdaye.geometricweather/language";
    private static final String METHOD_GET_LANGUAGE = "getLanguage";

    public static void register(BinaryMessenger messenger) {
        new MethodChannel(
                messenger,
                CHANNEL_NAME
        ).setMethodCallHandler((methodCall, result) -> {
            if (METHOD_GET_LANGUAGE.equals(methodCall.method)) {
                Locale locale = Build.VERSION.SDK_INT >= Build.VERSION_CODES.N
                        ? Resources.getSystem().getConfiguration().getLocales().get(0)
                        : Resources.getSystem().getConfiguration().locale;
                String language = locale.getLanguage();
                String country = locale.getCountry();

                if (!TextUtils.isEmpty(country)
                        && (country.equalsIgnoreCase("tw") || country.equalsIgnoreCase("hk"))) {
                    result.success(language.toLowerCase() + "-" + country.toLowerCase());
                } else {
                    result.success(language.toLowerCase());
                }
                
            } else {
                result.notImplemented();
            }
        });
    }
}
