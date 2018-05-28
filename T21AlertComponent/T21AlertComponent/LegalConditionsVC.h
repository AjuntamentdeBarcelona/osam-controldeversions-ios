//
//  LegalConditionsVC.h
//  VersionControl
//
//  Created by Tempos21 on 09/05/2018.
//

#import <UIKit/UIKit.h>

@class LegalConditionsVC;

@protocol LegalConditionsVCDelegate <NSObject>

-(void)legalConditionsVCDidPressAccept:(LegalConditionsVC*)legalConditionsVC;

@end

@interface LegalConditionsVC : UIViewController

@property (unsafe_unretained, nonatomic) IBOutlet UIWebView *legalConditionsWebView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *legalConditionsAcceptButton;
@property (weak, nonatomic) IBOutlet UIView *legalConditionsButtonContainer;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *legalConditionsBackgroundImageView;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *legalConditionsButtonContainerHeight;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *legalConditionsButtonHeight;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *legalConditionsButtonWidth;
    
@property (nonatomic,weak) id<LegalConditionsVCDelegate> delegate;
@property (nonatomic,strong) NSDictionary *configDict;

-(void)loadLegalConditionsURL:(NSString *)URL;
-(instancetype)initWithConfigDict:(NSDictionary *)configDict;

@end
