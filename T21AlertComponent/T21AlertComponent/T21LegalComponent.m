//
//  T21LegalComponent.m
//  VersionControl
//
//  Created by Tempos21 on 07/05/2018.
//

#import "T21LegalComponent.h"

#import "Constants.h"
#import "categories/NSURL+T21CommonUtils.h"
#import "categories/NSString+T21ComminUtils.h"
#import "LegalConditionsVC.h"
#import "categories/UIViewController+Utils.h"

@interface T21LegalComponent () <NSURLConnectionDelegate, LegalConditionsVCDelegate>

@property (copy, nonatomic) void (^completionBlock) (NSError*);
@property (copy, nonatomic) void (^completionBlockURL) (NSError*, NSString*);

@property (strong, nonatomic) NSDictionary *serviceKeys;
@property (strong, nonatomic) NSMutableData *responseData;
@property (nonatomic, copy) NSString *language;

@property (nonatomic, assign) NSInteger legalVersion;
@property (nonatomic, copy) NSString *legalURL;
@property (nonatomic, strong) NSDictionary *configDict;

@end

@implementation T21LegalComponent

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
+ (T21LegalComponent *)sharedInstance
{
    static T21LegalComponent * _sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

#pragma mark - Private methods

-(NSNumber *)userDefaultsLegalVersion {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:kLegalVersionKeyName];
}

-(void)storeLegalVersion:(NSNumber *)legalVersion {
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    if (legalVersion) {
        [userDefaults setObject:legalVersion forKey:kLegalVersionKeyName];
    } else {
        [userDefaults removeObjectForKey:kLegalVersionKeyName];
    }
    [userDefaults synchronize];
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
      //  self.legalVersion = [alertDict[serviceKeys[@(eGALegalVersionKey)]] integerValue];
        self.legalURL = alertDict[serviceKeys[@(eGALegalURLKey)]];
        
        //NSNumber *legalVersionLocal = [self userDefaultsLegalVersion];
        
       /* if(legalVersionLocal && ([legalVersionLocal integerValue] >= self.legalVersion)) {

            if (self.completionBlock) {
                self.completionBlock(nil);
            }
        } else {
            [self displayLegalAlertWithURL:self.legalURL];
        }*/
        if(self.completionBlock != nil){
            [self displayLegalAlertWithURL:self.legalURL];
        }
        else{
            self.completionBlockURL(nil, self.legalURL);
        }
        
    } else {
        self.completionBlock([NSError errorWithDomain:@"Error getting data" code:0 userInfo:nil]);
    }
}

-(void)displayLegalAlertWithURL:(NSString *)URL {
    
    LegalConditionsVC *legalConditionsVC = [[LegalConditionsVC alloc] initWithConfigDict:self.configDict];
    legalConditionsVC.delegate = self;
    UIViewController *vc = [UIViewController currentViewController];
    [vc presentViewController:legalConditionsVC animated:YES
                   completion:^{
                       [legalConditionsVC loadLegalConditionsURL:URL];
                   }];
}

#pragma mark - Public methods

-(void)showLegalWithService:(NSString *)serviceURL withQueryParams:(NSDictionary *)queryParams withConfigDict:(NSDictionary *)configDict withCompletionBlock:(void (^)(NSError *))completionBlock
{
    self.configDict = configDict;
    
    self.serviceKeys = @{@(eGALegalVersionKey) : kLegalVersionKeyName,
                         @(eGALegalURLKey) : kLegalURLKeyName};
    
    //parsing query parameters
    if (queryParams) {
        NSString * queryString = [NSString URLQueryWithParameters:queryParams];
        serviceURL = [serviceURL stringByAppendingURLQuery:queryString];
    }
    
    [self showAlertWithService:serviceURL withServiceKeys:_serviceKeys language:nil andCompletionBlock:completionBlock];
}

- (void)showLegalWithService:(NSString *)serviceURL withLanguaje:language withCompletionBlock:(void(^)(NSError *, NSString*))completionBlock
{
    // self.configDict = configDict;
    
    self.serviceKeys = @{@(eGALegalVersionKey) : kLegalVersionKeyName,
                         @(eGALegalURLKey) : kLegalURLKeyName};
    
    
    [self showAlertWithService:serviceURL language:language andCompletionBlock:completionBlock];
}


- (void)showAlertWithService:(NSString *)serviceURL withServiceKeys:(NSDictionary *)serviceKeys language:(NSString *)language andCompletionBlock:(void(^)(NSError *))completionBlock;
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:serviceURL]];
    // Create url connection and fire request
    __unused NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (completionBlock) {
        self.completionBlock = completionBlock;
    }
}
    
- (void)showAlertWithService:(NSString *)serviceURL language:(NSString *)language andCompletionBlock:(void(^)(NSError *,NSString *))completionBlock;
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:serviceURL]];
    // Create url connection and fire request
    __unused NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.language = language;
    
    if (completionBlock) {
        self.completionBlockURL = completionBlock;
    }
}
    

#pragma mark LegalConditionsVCDelegate
-(void)legalConditionsVCDidPressAccept:(LegalConditionsVC *)legalConditionsVC
{
    // store version accepted
    [self storeLegalVersion:[NSNumber numberWithInteger: self.legalVersion]];
    
    // run completion
    if (self.completionBlock) {
        self.completionBlock(nil);
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
