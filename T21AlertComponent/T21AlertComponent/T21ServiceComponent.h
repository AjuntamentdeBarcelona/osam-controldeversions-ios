//
//  T21ServiceComponent.h
//  T21AlertComponent
//
//  Created by Tempos21 on 23/08/2017.
//  Copyright © 2017 Tempos21. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Define this enum to identify the key values fron json response.
 */

typedef enum GAServiceKeysEnum{
    eGAGooltrackingEnable = 0,
    eGADataIniciActivacio,
    eGADataFiActivacio
}T21GAServiceKeysEnum;

/*!
 Define this macro of this class as shared instance to use for other classes.
 */
#define _T21ServiceComponent [T21ServiceComponent sharedInstance]

/*!
 This is the generic alert class which will display diffrent types of alerts with ok, cancel or both button. This class will
 also provide the facilty to fetch the alert information from server.
 */
@interface T21ServiceComponent : NSObject

/*!
 * @discussion Create shared instance to use for other classes.
 */
+(T21ServiceComponent *)sharedInstance;

/*!
 * @discussion Check if a certain service, defined by serviceURL is active or not.
 * @param completionBlock To execute after service query, BOOL indicates if the service is active or not.
 */
- (void)verifyServiceEnabledURL:(NSString *)serviceURL withCompletionBlock:(void(^)(BOOL))completionBlock;
@end
