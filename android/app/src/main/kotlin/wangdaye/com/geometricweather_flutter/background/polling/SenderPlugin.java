package wangdaye.com.geometricweather_flutter.background.polling;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class SenderPlugin {

    private static final Set<MethodHandler> methodHandlerSet = new HashSet<>();
    
    private static final String CHANNEL_NAME = "com.wangdaye.geometricweather/sender";

    private static final String METHOD_ON_UPDATE_COMPLETED = "onUpdateCompleted";
    private static final String METHOD_ON_POLLING_COMPLETED = "onPollingCompleted";
    private static final String METHOD_SEND_TODAY_FORECAST = "sendTodayForecast";
    private static final String METHOD_SEND_TOMORROW_FORECAST = "sendTomorrowForecast";

    private static final String PARAM_LOCATION = "location";
    private static final String PARAM_LOCATION_LIST = "locationList";
    private static final String PARAM_SUCCEED = "succeed";
    private static final String PARAM_INDEX = "index";
    private static final String PARAM_TOTAL = "total";

    public interface MethodHandler {
        void onUpdateCompleted(Map<String, Object> location,
                               boolean succeed,
                               int index,
                               int total);
        void onPollingCompleted(List<Map<String, Object>> locationList,
                                boolean succeed);
        void sendTodayForecast(Map<String, Object> location);
        void sendTomorrowForecast(Map<String, Object> location);
    }

    public static void register(BinaryMessenger messenger,
                                MethodHandler methodHandler) {
        methodHandlerSet.add(methodHandler);

        new MethodChannel(messenger, CHANNEL_NAME).setMethodCallHandler((methodCall, result) -> {
            switch (methodCall.method) {
                case METHOD_ON_UPDATE_COMPLETED: {
                    Map<String, Object> location = methodCall.argument(PARAM_LOCATION);
                    Boolean succeed = methodCall.argument(PARAM_SUCCEED);
                    Integer index = methodCall.argument(PARAM_INDEX);
                    Integer total = methodCall.argument(PARAM_TOTAL);
                    if (location == null
                            || succeed == null
                            || index == null
                            || total == null) {
                        return;
                    }

                    for (MethodHandler handler : methodHandlerSet) {
                        handler.onUpdateCompleted(location, succeed, index, total);
                    }
                    break;
                }
                case METHOD_ON_POLLING_COMPLETED: {
                    List<Map<String, Object>> locationList = methodCall.argument(PARAM_LOCATION_LIST);
                    Boolean succeed = methodCall.argument(PARAM_SUCCEED);
                    if (locationList == null
                            || succeed == null) {
                        return;
                    }

                    for (MethodHandler handler : methodHandlerSet) {
                        handler.onPollingCompleted(locationList, succeed);
                    }
                    break;
                }
                case METHOD_SEND_TODAY_FORECAST: {
                    Map<String, Object> location = methodCall.argument(PARAM_LOCATION);
                    if (location == null) {
                        return;
                    }

                    for (MethodHandler handler : methodHandlerSet) {
                        handler.sendTodayForecast(location);
                    }
                    break;
                }
                case METHOD_SEND_TOMORROW_FORECAST: {
                    Map<String, Object> location = methodCall.argument(PARAM_LOCATION);
                    if (location == null) {
                        return;
                    }

                    for (MethodHandler handler : methodHandlerSet) {
                        handler.sendTomorrowForecast(location);
                    }
                    break;
                }
                default:
                    result.notImplemented();
                    break;
            }
        });
    }

    public static void unregister(MethodHandler methodHandler) {
        methodHandlerSet.remove(methodHandler);
    }
}
