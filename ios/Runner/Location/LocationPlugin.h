//
//  LocationPlugin.h
//  Runner
//
//  Created by 王大爷 on 2021/7/3.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PermissionStatus) {
    PermissionStatusDenied,
    PermissionStatusOnlyForeground,
    PermissionStatusAllowAllTheTime,
};

NSString * const CHANNEL_NAME = @"com.wangdaye.geometricweather/location";

NSString * const METHOD_REQUEST_LOCATION = @"requestLocation";
NSString * const METHOD_GET_LAST_KNOWN_LOCATION = @"getLastKnownLocation";
NSString * const METHOD_CANCEL_REQUEST = @"cancelRequest";
NSString * const METHOD_IS_LOCATION_SERVICE_ENABLED = @"isLocationServiceEnabled";
NSString * const METHOD_CHECK_PERMISSIONS = @"checkPermissions";
NSString * const METHOD_REQUEST_PERMISSIONS = @"requestPermissions";

NSString * const ERROR_CODE_LACK_OF_PERMISSION = @"0";
NSString * const ERROR_CODE_TIMEOUT = @"1";

@interface LocationPlugin : NSObject

+ (instancetype)sharedInstance;

+ (void)registerWithMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger;

// contains latitude and longitude.
+ (NSDictionary *)getLastKnownLocation;

+ (void)locationInBackground:(BOOL)inBackground
                handleResult:(FlutterResult)result;

+ (void)cancel;

+ (BOOL)isEnabled;

+ (PermissionStatus)checkPermissions;

+ (void)requestPermissionsWithResult:(FlutterResult)result;

@end

NS_ASSUME_NONNULL_END
