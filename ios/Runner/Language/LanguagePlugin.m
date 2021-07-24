//
//  LanguagePlugin.m
//  Runner
//
//  Created by 王大爷 on 2021/7/7.
//

#import "LanguagePlugin.h"

@implementation LanguagePlugin

+ (void)registerWithMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
    FlutterMethodChannel* batteryChannel = [FlutterMethodChannel methodChannelWithName:CHANNEL_LANGUAGE
                                                                       binaryMessenger:binaryMessenger];
    [batteryChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call,
                                           FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:METHOD_GET_LANGUAGE]) {
            result([NSLocale preferredLanguages][0]);
            return;
        }
        
        result(FlutterMethodNotImplemented);
    }];
}

@end
