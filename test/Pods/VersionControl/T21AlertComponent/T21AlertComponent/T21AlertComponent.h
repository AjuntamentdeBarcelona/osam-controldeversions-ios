//
//  T21AlertComponent.h
//  T21AlertComponent
//
//  Created by Govind Tiwari on 05/11/15.
//  Copyright © 2015 Tempos21. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 Define this enum to identify the key values fron json response.
 */
typedef enum GAKeysEnum{
    eGAMinVersionKey = 0,
    eGAComparisonModeKey,
    eGAMinSystemVersionKey,
    eGATitleKey,
    eGAMessageKey,
    eGAOkButtonTitleKey,
    eGACancelButtonTitleKey,
    eGAOkButtonActionURLKey,
}T21GAKeysEnum;

/*!
 Define this enum to identify the app version comparison mode.
 */
typedef enum GAComparisonModeEnum {
    eGAAppVersionLowerKey = 0,
    eGAAppVersionEqualKey,
    eGAAppVersionGreaterKey,
    
}T21GAComparisonModeEnum;

/*!
 Define this macro of this class as shared instance to use for other classes.
 */
#define _T21AlertComponent [T21AlertComponent sharedInstance]

/*!
 This is the generic alert class which will display diffrent types of alerts with ok, cancel or both button. This class will
 also provide the facilty to fetch the alert information from server.
 */
@interface T21AlertComponent : NSObject

/*!
 Declare alertOpenURL property to open the url in external safari app.
 */
@property (nonatomic, strong) NSString *alertOpenURL;

/*!
 * @discussion Create shared instance to use for other classes.
 */
+(T21AlertComponent *)sharedInstance;

/*!
 * @discussion Fetch the alert information by the server URL.
 * @param serviceURL To identify from where we need to fetch the alert information.
 */
- (void)showAlertWithService:(NSString *)serviceURL;

/*!
 * @discussion Fetch the alert information by the server URL with selected language.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param language Language code from the message dictionary.
 */
- (void)showAlertWithService:(NSString *)serviceURL withLanguage:(NSString *)language;

/*!
 * @discussion Fetch the alert information by the server URL.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param completionBlock To execute after alert dissmis or if alert is not showed.
 */
- (void)showAlertWithService:(NSString *)serviceURL withCompletionBlock:(void(^)(NSError *))completionBlock;

/*!
 * @discussion Fetch the alert information by the server URL.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param completionBlock To execute after alert dissmis or if alert is not showed.
 * @param queryParams To identify query parametes
 */
- (void)showAlertWithService:(NSString *)serviceURL withQueryParams:(NSDictionary *)queryParams withCompletionBlock:(void(^)(NSError *))completionBlock;
/*!
 * @discussion Fetch the alert information by the server URL with selected language.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param language Language code from the message dictionary.
 * @param completionBlock To execute after alert dissmis or if alert is not showed.
 */
- (void)showAlertWithService:(NSString *)serviceURL withLanguage:(NSString *)language andCompletionBlock:(void(^)(NSError *))completionBlock;

/*!
 * @discussion Fetch the alert information by the server URL with selected language.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param language Language code from the message dictionary.
 * @param completionBlock To execute after alert dissmis or if alert is not showed.
 * @param queryParams To identify query parametes
 */
- (void)showAlertWithService:(NSString *)serviceURL withQueryParams:(NSDictionary *)queryParams withLanguage:(NSString *)language andCompletionBlock:(void(^)(NSError *))completionBlock;

/*!
 * @discussion Fetch the alert information by the server URL.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param serviceKeys To identify value associated with the declare enum keys.Make sure it will contain all values
 associated with T21GAEnum keys.
 */
- (void)showAlertWithService:(NSString *)serviceURL withServiceKeys:(NSDictionary *)serviceKeys;

/*!
 * @discussion Fetch the alert information by the server URL with selected language.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param serviceKeys To identify value associated with the declare enum keys.Make sure it will contain all values
 associated with T21GAEnum keys.
 * @param language Language code from the message dictionary.
 */
- (void)showAlertWithService:(NSString *)serviceURL withServiceKeys:(NSDictionary *)serviceKeys andLanguage:(NSString *)language;

/*!
 * @discussion Fetch the alert information by the server URL.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param serviceKeys To identify value associated with the declare enum keys.Make sure it will contain all values
 associated with T21GAEnum keys.
 * @param completionBlock To execute after alert dissmis or if alert is not showed.
 */
- (void)showAlertWithService:(NSString *)serviceURL withServiceKeys:(NSDictionary *)serviceKeys andCompletionBlock:(void(^)(NSError *))completionBlock;

/*!
 * @discussion Fetch the alert information by the server URL with selected language.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param serviceKeys To identify value associated with the declare enum keys.Make sure it will contain all values
 associated with T21GAEnum keys.
 * @param language Language code from the message dictionary.
 * @param completionBlock To execute after alert dissmis or if alert is not showed.
 */
- (void)showAlertWithService:(NSString *)serviceURL withServiceKeys:(NSDictionary *)serviceKeys language:(NSString *)language andCompletionBlock:(void(^)(NSError *))completionBlock;

/*!
 * @discussion Display alert with title, message, ok button title, cancel button title and launch the url in external app based on user slection.
 */
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle okActionURL:(NSString *)okActionUrl andCancelTitle:(NSString *)cancelTitle;

/*!
 * @discussion Display alert with title, message, ok button title, cancel button title and launch the url in external app based on user slection.
 * @param completionBlock To execute after alert dissmis or if alert is not showed.
 */
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle okActionURL:(NSString *)okActionUrl andCancelTitle:(NSString *)cancelTitle withCompletionBlock:(void(^)(NSError *))completionBlock;


@end
