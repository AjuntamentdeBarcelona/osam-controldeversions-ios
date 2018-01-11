//
//  T21AlertComponent.m
//  MyPod
//
//  Created by Govind Tiwari on 05/11/15.
//  Copyright © 2015 Tempos21. All rights reserved.
//

#import "T21AlertComponent.h"

#import "Constants.h"
#import "UIDevice+T21CommonUtils.h"
#import "NSURL+T21CommonUtils.h"
#import "UIViewController+Utils.h"
#import "NSString+T21ComminUtils.h"

@interface T21AlertComponent () <NSURLConnectionDelegate>

//@property (readonly, strong, nonatomic) GCWorker *worker;
@property (assign, nonatomic) BOOL shouldAlertExistOnScreen;
@property (copy, nonatomic) void (^completionBlock) (NSError*);
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSDictionary *serviceKeys;
@property (nonatomic, copy) NSString *language;

@end

@implementation T21AlertComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        //_worker = [GCWorker new];
    }
    return self;
}

/*!
 * @discussion Create shared instance to use for other classes.
 */
+ (T21AlertComponent *)sharedInstance
{
    static T21AlertComponent * _sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

#pragma mark - Private methods

- (void)openAlertActionURLWithTitle:(NSString *)title message:(NSString *)message andOkButtonTitle:(NSString *)buttonTitle
{
    if (self.alertOpenURL && self.alertOpenURL.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.alertOpenURL]];
    }
    
    if (self.shouldAlertExistOnScreen) {
        if (title && message) {
            [self showAlertWithTitle:title message:message okTitle:buttonTitle okActionURL:self.alertOpenURL andCancelTitle:nil];
        }
    }else if (self.completionBlock) {
        self.completionBlock(nil);
    }
}

- (void)displayAlertByInfo:(NSDictionary *)alertDict withServiceKeys:(NSDictionary *)serviceKeys language:(NSString *)language
{
    NSString *title = [self getTextFromDictionary:alertDict withServiceKeys:serviceKeys language:language andKey:eGATitleKey];
    NSString *message = [self getTextFromDictionary:alertDict withServiceKeys:serviceKeys language:language andKey:eGAMessageKey];
    NSString *okButtonTitle = [self getTextFromDictionary:alertDict withServiceKeys:serviceKeys language:language andKey:eGAOkButtonTitleKey];
    NSString *cancelButtonTitle = [self getTextFromDictionary:alertDict withServiceKeys:serviceKeys language:language andKey:eGACancelButtonTitleKey];
    
    NSString *okButtonActionURL = alertDict[serviceKeys[@(eGAOkButtonActionURLKey)]];
    
    if ((nil==cancelButtonTitle) || (0==cancelButtonTitle.length)) {
        self.shouldAlertExistOnScreen = YES;
    }
    
    [self showAlertWithTitle:title
                     message:message
                     okTitle:okButtonTitle
                 okActionURL:okButtonActionURL
              andCancelTitle:cancelButtonTitle];
}

- (NSString *)getTextFromDictionary:(NSDictionary *)dictionary withServiceKeys:(NSDictionary *)serviceKeys language:(NSString *)language andKey:(T21GAKeysEnum)key
{
    NSString *resultText;
    if ([dictionary[serviceKeys[@(key)]] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *messageDic = dictionary[serviceKeys[@(key)]];
        if (language && ![language isEqualToString:@""]) {
            NSString *selectedText = messageDic[language];
            resultText = selectedText ? : [[messageDic allValues] firstObject];
        }else {
            resultText = [[messageDic allValues] firstObject];
        }
    }else if ([dictionary[serviceKeys[@(key)]] isKindOfClass:[NSString class]]) {
        resultText = dictionary[serviceKeys[@(key)]];
    }
    
    return resultText;
}

- (void)parseJSON:(id)json withServiceKeys:(NSDictionary *)serviceKeys language:(NSString *)language
{
    if ([json isKindOfClass:[NSDictionary class]]) {
        [self parseJSONDict:json withServiceKeys:serviceKeys language:language];
    } else if ([json isKindOfClass:[NSData class]]) {
        [self parseJSONData:json withServiceKeys:serviceKeys language:language];
    } else {
        if (self.completionBlock) {
            self.completionBlock([NSError errorWithDomain:@"Error parsing data" code:0 userInfo:nil]);
        }
    }
}

- (void)parseJSONData:(NSData *)jsonData withServiceKeys:(NSDictionary *)serviceKeys language:(NSString *)language
{
    if (jsonData) {
        NSError *errorInfo = nil;
        NSDictionary *alertDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&errorInfo];
        
        if (errorInfo) {
            self.completionBlock([NSError errorWithDomain:@"Error parsing data" code:0 userInfo:nil]);
        }else {
            [self parseJSONDict:alertDict withServiceKeys:serviceKeys language:language];
        }
    } else {
        self.completionBlock([NSError errorWithDomain:@"Error getting data" code:0 userInfo:nil]);
    }
}

- (void)parseJSONDict:(NSDictionary *)alertDict withServiceKeys:(NSDictionary *)serviceKeys language:(NSString *)language
{
    if (alertDict) {
        
        NSString *minVersion = alertDict[serviceKeys[@(eGAMinVersionKey)]];
        NSString *appVersion  = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        
        NSComparisonResult result = [appVersion compare:minVersion options:NSNumericSearch];
        T21GAComparisonModeEnum comparisonModeValue = [alertDict[serviceKeys[@(eGAComparisonModeKey)]] intValue];
        BOOL shouldDisplayAlert = NO;
        
        switch (comparisonModeValue) {
                
            case eGAAppVersionLowerKey:
                shouldDisplayAlert = (result == NSOrderedAscending);
                break;
                
            case eGAAppVersionEqualKey:
                shouldDisplayAlert = (result == NSOrderedSame) ;
                break;
                
            case eGAAppVersionGreaterKey:
                shouldDisplayAlert = (result == NSOrderedDescending);
                break;
                
            default:
                break;
        }
        
        if (shouldDisplayAlert && IOS_VERSION_NEWER_OR_EQUAL_TO([alertDict[serviceKeys[@(eGAMinSystemVersionKey)]] floatValue])) {
            [self displayAlertByInfo:alertDict withServiceKeys:serviceKeys language:language];
        }else if (self.completionBlock) {
            self.completionBlock(nil);
        }
        
    } else {
        self.completionBlock([NSError errorWithDomain:@"Error getting data" code:0 userInfo:nil]);
    }
}

#pragma mark - Public methods

/*!
 * @discussion Fetch the alert information by the server URL.
 * @param serviceURL To identify from where we need to fetch the alert information.
 */
- (void)showAlertWithService:(NSString *)serviceURL;
{
    [self showAlertWithService:serviceURL withCompletionBlock:nil];
}

/*!
 * @discussion Fetch the alert information by the server URL with selected language.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param language Language code from the message dictionary.
 */
- (void)showAlertWithService:(NSString *)serviceURL withLanguage:(NSString *)language {
    [self showAlertWithService:serviceURL withLanguage:language andCompletionBlock:nil];
}

/*!
 * @discussion Fetch the alert information by the server URL.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param completionBlock To execute after alert dissmis or if alert is not showed.
 */
- (void)showAlertWithService:(NSString *)serviceURL withCompletionBlock:(void(^)(NSError *))completionBlock
{
    [self showAlertWithService:serviceURL withLanguage:nil andCompletionBlock:completionBlock];
}

/*!
 * @discussion Fetch the alert information by the server URL.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param completionBlock To execute after alert dissmis or if alert is not showed.
 * @param queryParams To identify query parametes
 */
- (void)showAlertWithService:(NSString *)serviceURL withQueryParams:(NSDictionary *)queryParams withCompletionBlock:(void(^)(NSError *))completionBlock{
    
   [self showAlertWithService:serviceURL withQueryParams:queryParams withLanguage:nil andCompletionBlock:completionBlock];
}

/*!
 * @discussion Fetch the alert information by the server URL with selected language.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param language Language code from the message dictionary.
 * @param completionBlock To execute after alert dissmis or if alert is not showed.
 */
- (void)showAlertWithService:(NSString *)serviceURL withLanguage:(NSString *)language andCompletionBlock:(void(^)(NSError *))completionBlock
{
    [self showAlertWithService:serviceURL withQueryParams:nil withLanguage:language andCompletionBlock:completionBlock];
}

/*!
 * @discussion Fetch the alert information by the server URL with selected language.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param language Language code from the message dictionary.
 * @param completionBlock To execute after alert dissmis or if alert is not showed.
 * @param queryParams To identify query parametes
 */
- (void)showAlertWithService:(NSString *)serviceURL withQueryParams:(NSDictionary *)queryParams withLanguage:(NSString *)language andCompletionBlock:(void(^)(NSError *))completionBlock{
    self.serviceKeys = @{@(eGAMinVersionKey) : kMinVersionKeyName,
                         @(eGAComparisonModeKey) : kComparisonModeKeyName,
                         @(eGAMinSystemVersionKey) : kMinSystemVersionKeyName,
                         @(eGATitleKey) : kTitleKeyName,
                         @(eGAMessageKey) : kMessageKeyName,
                         @(eGAOkButtonTitleKey) : kOkButtonTitleKeyName,
                         @(eGAOkButtonActionURLKey) : kOkButtonActionURLKeyName,
                         @(eGACancelButtonTitleKey) : kCancelButtonTitleKeyName};
    self.language = language;
    
    //parsing query parameters
    if (queryParams) {
        NSString * queryString = [NSString URLQueryWithParameters:queryParams];
        serviceURL = [serviceURL stringByAppendingURLQuery:queryString];
    }
    
    [self showAlertWithService:serviceURL withServiceKeys:_serviceKeys language:language andCompletionBlock:completionBlock];
}

/*!
 * @discussion Fetch the alert information by the server URL.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param serviceKeys To identify value associated with the declare enum keys.Make sure it will contain all values
 associated with T21GAEnum keys.
 */
- (void)showAlertWithService:(NSString *)serviceURL withServiceKeys:(NSDictionary *)serviceKeys
{
    [self showAlertWithService:serviceURL withServiceKeys:serviceKeys andLanguage:nil];
}

/*!
 * @discussion Fetch the alert information by the server URL with selected language.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param serviceKeys To identify value associated with the declare enum keys.Make sure it will contain all values
 associated with T21GAEnum keys.
 * @param language Language code from the message dictionary.
 */
- (void)showAlertWithService:(NSString *)serviceURL withServiceKeys:(NSDictionary *)serviceKeys andLanguage:(NSString *)language
{
    [self showAlertWithService:serviceURL withServiceKeys:serviceKeys language:language andCompletionBlock:nil];
}

/*!
 * @discussion Fetch the alert information by the server URL.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param serviceKeys To identify value associated with the declare enum keys.Make sure it will contain all values
 associated with T21GAEnum keys.
 * @param completionBlock To execute after alert dissmis or if alert is not showed.
 */
- (void)showAlertWithService:(NSString *)serviceURL withServiceKeys:(NSDictionary *)serviceKeys andCompletionBlock:(void(^)(NSError *))completionBlock {
    [self showAlertWithService:serviceURL withServiceKeys:serviceKeys language:nil andCompletionBlock:completionBlock];
}

/*!
 * @discussion Fetch the alert information by the server URL with selected language.
 * @param serviceURL To identify from where we need to fetch the alert information.
 * @param serviceKeys To identify value associated with the declare enum keys.Make sure it will contain all values
 associated with T21GAEnum keys.
 * @param language Language code from the message dictionary.
 * @param completionBlock To execute after alert dissmis or if alert is not showed.
 */
- (void)showAlertWithService:(NSString *)serviceURL withServiceKeys:(NSDictionary *)serviceKeys language:(NSString *)language andCompletionBlock:(void(^)(NSError *))completionBlock;
{
    if (![serviceURL hasPrefix:kHTTP_Prefix]) {
        NSString *fileBundlePath = [[NSBundle mainBundle] pathForResource:serviceURL ofType:nil];
        [self parseJSONData:[NSData dataWithContentsOfFile:fileBundlePath] withServiceKeys:serviceKeys language:language];
    }else {
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:serviceURL]];
        // Create url connection and fire request
        __unused NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (completionBlock) {
            self.completionBlock = completionBlock;
        }
    }
}

/*!
 * @discussion Display alert with title, message, ok button title, cancel button title and launch the url in external app based on user slection.
 */
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle okActionURL:(NSString *)okActionUrl andCancelTitle:(NSString *)cancelTitle
{
    [self showAlertWithTitle:title message:message okTitle:okTitle okActionURL:okActionUrl andCancelTitle:cancelTitle withCompletionBlock:nil];
}

/*!
 * @discussion Display alert with title, message, ok button title, cancel button title and launch the url in external app based on user slection.
 * @param completionBlock To execute after alert dissmis or if alert is not showed.
 */
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle okActionURL:(NSString *)okActionUrl andCancelTitle:(NSString *)cancelTitle withCompletionBlock:(void(^)(NSError *))completionBlock
{
    self.alertOpenURL = okActionUrl;
    
    if (IOS_VERSION_NEWER_OR_EQUAL_TO(8.0)) {
        
        if (completionBlock) {
            self.completionBlock = completionBlock;
        }
        
        T21AlertComponent * __weak weakSelf = self;
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        if (cancelTitle && cancelTitle.length > 0) {
            UIAlertAction *cancelAction = [UIAlertAction  actionWithTitle:cancelTitle
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      if (self.completionBlock) {
                                                                          self.completionBlock(nil);
                                                                      }
                                                                  }];
            [alertController addAction:cancelAction];
        }
        
        if (okTitle && okTitle.length > 0) {
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:okTitle
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *  _Nonnull action)
                                       {
                                           [weakSelf openAlertActionURLWithTitle:title
                                                                         message:message andOkButtonTitle:okTitle];
                                       }];
            
            [alertController addAction:okAction];
        }
        
        UIViewController *currentViewController = [UIViewController currentViewController];
        [currentViewController presentViewController:alertController animated:YES completion:nil];
        
    }else {
        if (completionBlock) {
            self.completionBlock = completionBlock;
        }
        
        if (!cancelTitle.length) {
            cancelTitle = nil;
        }
        if (!okTitle) {
            okTitle = nil;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message delegate:self
                                              cancelButtonTitle:cancelTitle
                                              otherButtonTitles:okTitle,nil];
        [alert show];
    }
}

#pragma mark - Alert View Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex) {
        NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
        [self openAlertActionURLWithTitle:alertView.title message:alertView.message andOkButtonTitle:buttonTitle];
    }else {
        if (self.completionBlock) {
            self.completionBlock(nil);
            self.completionBlock = nil;
        }
    }
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSError *error;
    NSString *string = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    [self parseJSON:jsonObject withServiceKeys:_serviceKeys language:self.language];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    if (self.completionBlock) {
        self.completionBlock(error);
    }
}

@end
