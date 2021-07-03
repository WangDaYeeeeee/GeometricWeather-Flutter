//
//  LocationPlugin.m
//  Runner
//
//  Created by 王大爷 on 2021/7/3.
//

#import "LocationPlugin.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationPlugin ()<CLLocationManagerDelegate>

@property(nonatomic, readwrite, strong) CLLocationManager* locationManager;
@property(nonatomic, readwrite, copy) FlutterResult result;

@end

@implementation LocationPlugin

# pragma mark - init.

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static LocationPlugin *single = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [[self alloc] init];
    });
    return single;
}

# pragma mark - method channel.

+ (void)registerWithMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger {
    
    FlutterMethodChannel* batteryChannel = [FlutterMethodChannel methodChannelWithName:CHANNEL_NAME
                                                                       binaryMessenger:binaryMessenger];
    [batteryChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call,
                                           FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:METHOD_REQUEST_LOCATION]) {
            NSDictionary *args = (NSDictionary *)call.arguments;
            NSNumber *inBackground = [args objectForKey:@"inBackground"];
            
            [LocationPlugin cancel];
            [LocationPlugin locationInBackground:[inBackground boolValue]
                         handleResult:result];
            return;
        }
        
        if ([call.method isEqualToString:METHOD_GET_LAST_KNOWN_LOCATION]) {
            NSDictionary *dict = [LocationPlugin getLastKnownLocation];
            if (dict == nil) {
                result([FlutterError errorWithCode:ERROR_CODE_TIMEOUT
                                           message:@"Location Failed."
                                           details:nil]);
            } else {
                result(dict);
            }
            return;
        }
        
        if ([call.method isEqualToString:METHOD_CANCEL_REQUEST]) {
            [LocationPlugin cancel];
            return;
        }
        
        if ([call.method isEqualToString:METHOD_IS_LOCATION_SERVICE_ENABLED]) {
            result([NSNumber numberWithBool:[LocationPlugin isEnabled]]);
            return;
        }
        
        if ([call.method isEqualToString:METHOD_CHECK_PERMISSIONS]) {
            PermissionStatus status = [LocationPlugin checkPermissions];
            result([NSNumber numberWithInt:(int)status]);
            return;
        }
        
        if ([call.method isEqualToString:METHOD_REQUEST_PERMISSIONS]) {
            [LocationPlugin requestPermissionsWithResult:result];
            return;
        }
        
        result(FlutterMethodNotImplemented);
    }];
}

+ (void)locationInBackground:(BOOL)inBackground
                handleResult:(FlutterResult)result {
    if (![self isEnabled]) {
        result([FlutterError errorWithCode:ERROR_CODE_TIMEOUT
                                   message:@"Location failed."
                                   details:nil]);
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self sharedInstance].result = result;
    [self sharedInstance].locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self sharedInstance].locationManager.distanceFilter = 0;
    [self sharedInstance].locationManager.delegate = [weakSelf sharedInstance];
    [[self sharedInstance].locationManager requestAlwaysAuthorization];
    [[self sharedInstance].locationManager startUpdatingLocation];
}

+ (NSDictionary *)getLastKnownLocation {
    CLLocation *location = [self sharedInstance].locationManager.location;
    if (location == nil) {
        return nil;
    }
    
    return @{
        @"latitude": [NSNumber numberWithDouble:location.coordinate.latitude],
        @"longitude": [NSNumber numberWithDouble:location.coordinate.longitude],
    };
}

+ (void)cancel {
    [[self sharedInstance].locationManager stopUpdatingLocation];
}

+ (BOOL)isEnabled {
    return [CLLocationManager locationServicesEnabled];
}

+ (PermissionStatus)checkPermissions {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        return PermissionStatusAllowAllTheTime;
    }
    
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        return PermissionStatusOnlyForeground;
    }
    
    return PermissionStatusDenied;
}

+ (void)requestPermissionsWithResult:(FlutterResult)result {
    [[self sharedInstance].locationManager requestAlwaysAuthorization];
}

# pragma mark - CLLocationManagerDelegate.

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    
    NSDictionary *result = @{
        @"latitude": [NSNumber numberWithDouble:location.coordinate.latitude],
        @"longitude": [NSNumber numberWithDouble:location.coordinate.longitude],
    };
    
    self.result(result);
    [self.locationManager stopUpdatingLocation];
}

@end
