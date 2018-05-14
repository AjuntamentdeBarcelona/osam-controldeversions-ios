//
//  T21LegalComponent.h
//  VersionControl
//
//  Created by Tempos21 on 07/05/2018.
//

#import <Foundation/Foundation.h>

/*!
 Define this enum to identify the key values fron json response.
 */
typedef enum GALegalKeysEnum{
    eGALegalVersionKey = 0,
    eGALegalURLKey,
}T21GALegalKeysEnum;

/*
    Customization options
 */

// text_color: color for the accept button text
// primary_color: color for button, loading indicator and safari view controller bar button items
// background color: color for button container and web view background

static NSString *const legal_text_color   = @"legal_text_color";
static NSString *const legal_primary_color = @"legal_primary_color";
static NSString *const legal_background_color = @"legal_background_color";

/*!
 Define this macro of this class as shared instance to use for other classes.
 */
#define _T21LegalComponent [T21LegalComponent sharedInstance]

/*!
 This is the generic legal class which will display the web view with the legal conditions and an OK, button. This class will
 also provide the facilty to fetch the legal information from server.
 */

@interface T21LegalComponent : NSObject

/*!
 * @discussion Create shared instance to use for other classes.
 */
+(T21LegalComponent *)sharedInstance;

/*!
 * @discussion Fetch the legal information by the server URL.
 * @param serviceURL To identify from where we need to fetch the legal information.
 * @param completionBlock To execute after accept the conditions.
 * @param colorDict To specify colors for the popup:
 *                  text_color: color for the accept button text
 *                  primary_color: color for button, loading indicator and safari view controller bar button items
 *                  background color: color for button container and web view background
 * @param queryParams To identify query parameters
 */
- (void)showLegalWithService:(NSString *)serviceURL withQueryParams:(NSDictionary *)queryParams withColorDict:(NSDictionary *)colorDict withCompletionBlock:(void(^)(NSError *))completionBlock;

@end
