//
//  LanguagePlugin.h
//  Runner
//
//  Created by 王大爷 on 2021/7/7.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

NSString * const CHANNEL_LANGUAGE = @"com.wangdaye.geometricweather/language";
NSString * const METHOD_GET_LANGUAGE = @"getLanguage";

@interface LanguagePlugin : NSObject

+ (void)registerWithMessenger:(NSObject<FlutterBinaryMessenger> *)binaryMessenger;

@end

NS_ASSUME_NONNULL_END
