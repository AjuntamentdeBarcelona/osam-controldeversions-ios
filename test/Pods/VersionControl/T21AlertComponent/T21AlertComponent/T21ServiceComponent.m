//
//  T21ServiceComponent.m
//  T21AlertComponent
//
//  Created by Tempos21 on 23/08/2017.
//  Copyright © 2017 Tempos21. All rights reserved.
//

#import "T21ServiceComponent.h"

#import "Constants.h"
#import "NSDate+Utils.h"

@interface T21ServiceComponent () <NSURLConnectionDelegate>

@property (copy, nonatomic) void (^serviceBlock) (BOOL);
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSDictionary *serviceKeys;
@property (nonatomic, copy) NSString *language;

@end

@implementation T21ServiceComponent

/*!
 * @discussion Create shared instance to use for other classes.
 */
+ (T21ServiceComponent *)sharedInstance
{
    static T21ServiceComponent * _sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)parseJSON:(id)json withVerifyKeys:(NSDictionary *)verifyKeys
{
    if ([json isKindOfClass:[NSDictionary class]]) {
        [self parseJSONDict:json withVerifyKeys:verifyKeys];
    } else {
        if (self.serviceBlock) {
            self.serviceBlock(NO);
            self.serviceBlock = nil;
        }
    }
}


- (void)parseJSONDict:(NSDictionary *)dict withVerifyKeys:(NSDictionary *)verifyKeys
{
    if (dict) {
        
        NSString *dataIniciActivacio = dict[verifyKeys[@(eGADataIniciActivacio)]];
        NSString *dataFiActivacio = dict[verifyKeys[@(eGADataFiActivacio)]];
        BOOL enabled = [dict[verifyKeys[@(eGAGooltrackingEnable)]] boolValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Madrid"]];
        NSDate *iniciActivacio = [dateFormatter dateFromString:dataIniciActivacio];
        NSDate *fiActivacio = [dateFormatter dateFromString:dataFiActivacio];
        
        // fiActivacio inclusive, add24 hours
        NSTimeInterval secondsInOneDay = 24 * 60 * 60;
        NSDate *fiActivacioInclusive = [fiActivacio dateByAddingTimeInterval:secondsInOneDay];
        
        BOOL isBetweenDates = [[NSDate new] isBetweenDate:iniciActivacio andDate:fiActivacioInclusive];
        
        if (self.serviceBlock) {
            if (enabled && isBetweenDates) {
                self.serviceBlock(YES);
            } else {
                self.serviceBlock(NO);
            }
        }
        
    } else {
        if (self.serviceBlock) {
            self.serviceBlock(NO);
        }
    }
    self.serviceBlock = nil;
}

/*!
 * @discussion Check if a certain service, defined by serviceURL is active or not.
 * @param completionBlock To execute after service query, BOOL indicates if the service is active or not.
 */
- (void)verifyServiceEnabledURL:(NSString *)serviceURL withCompletionBlock:(void(^)(BOOL))completionBlock
{
    self.serviceKeys = @{@(eGAGooltrackingEnable) : kGooltrackingEnable,
                         @(eGADataIniciActivacio) : kDataIniciActivacio,
                         @(eGADataFiActivacio) : kDataFiActivacio};
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:serviceURL]];
    // Create url connection and fire request
    __unused NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (completionBlock) {
        self.serviceBlock = completionBlock;
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
    [self parseJSON:jsonObject withVerifyKeys:_serviceKeys];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    if (self.serviceBlock) {
        self.serviceBlock(NO);
        self.serviceBlock = nil;
    }
}

@end
