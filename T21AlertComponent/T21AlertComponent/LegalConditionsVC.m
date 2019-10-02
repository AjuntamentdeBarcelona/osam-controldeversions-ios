//
//  LegalConditionsVC.m
//  VersionControl
//
//  Created by Tempos21 on 09/05/2018.
//

@import SafariServices;

#import "LegalConditionsVC.h"
#import "LCCircularProgressView.h"
#import "T21LegalComponent.h"

#define STATUSBAR_SIZE ((IS_IPHONE_X)? 44 : 22)
#define IS_IPHONE_X ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) && [UIScreen mainScreen].bounds.size.height == 812.0

@interface LegalConditionsVC () <WKUIDelegate>

@property (weak, nonatomic) IBOutlet LCCircularProgressView *circularProgressView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *WKContentView;

@end

@implementation LegalConditionsVC

-(instancetype)initWithConfigDict:(NSDictionary *)configDict
{
    self = [super initWithNibName:@"LegalConditionsVC" bundle:[NSBundle bundleForClass:self.classForCoder]];
    if(self) {
        self.configDict = configDict;
    }
    return self;
}

- (BOOL)prefersStatusBarHidden{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIViewController *vc = [UIViewController alloc];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
    
    self.webConfiguration = [[WKWebViewConfiguration alloc] init];
    self.legalConditionsWebView = [[WKWebView alloc] initWithFrame:self.WKContentView.frame configuration:self.webConfiguration];
    self.legalConditionsWebView.navigationDelegate = self;

    [self.legalConditionsAcceptButton setEnabled:NO];
    [self.WKContentView addSubview:self.legalConditionsWebView];
    
    self.legalConditionsWebView.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint * height = [NSLayoutConstraint constraintWithItem:self.legalConditionsWebView
     attribute:NSLayoutAttributeHeight
     relatedBy:NSLayoutRelationEqual
        toItem:self.WKContentView
     attribute:NSLayoutAttributeHeight
    multiplier:1
      constant:0];
    NSLayoutConstraint * width = [NSLayoutConstraint constraintWithItem:self.legalConditionsWebView
     attribute:NSLayoutAttributeWidth
     relatedBy:NSLayoutRelationEqual
        toItem:self.WKContentView
     attribute:NSLayoutAttributeWidth
    multiplier:1
      constant:0];
    NSLayoutConstraint * leftConstraint = [NSLayoutConstraint constraintWithItem:self.legalConditionsWebView
     attribute:NSLayoutAttributeLeftMargin
     relatedBy:NSLayoutRelationEqual
        toItem:self.WKContentView
     attribute:NSLayoutAttributeLeftMargin
    multiplier:1
      constant:0];
    NSLayoutConstraint * rightConstraint = [NSLayoutConstraint constraintWithItem:self.legalConditionsWebView
     attribute:NSLayoutAttributeRightMargin
     relatedBy:NSLayoutRelationEqual
        toItem:self.WKContentView
     attribute:NSLayoutAttributeRightMargin
    multiplier:1
      constant:0];
    NSLayoutConstraint * bottomConstraint = [NSLayoutConstraint constraintWithItem:self.legalConditionsWebView
     attribute:NSLayoutAttributeBottomMargin
     relatedBy:NSLayoutRelationEqual
        toItem:self.WKContentView
     attribute:NSLayoutAttributeBottomMargin
    multiplier:1
      constant:0];

    [self.WKContentView addConstraint: height];
    [self.WKContentView addConstraint: width];
    [self.WKContentView addConstraint: leftConstraint];
    [self.WKContentView addConstraint: rightConstraint];
    [self.WKContentView addConstraint: bottomConstraint];
    
    
    self.circularProgressView.isInfiniteProgress = YES;
    
    UIColor *legalBackgroundColor = self.configDict[legal_background_color];
    if(legalBackgroundColor) {
        self.legalConditionsWebView.backgroundColor = legalBackgroundColor;
        self.legalConditionsButtonContainer.backgroundColor = legalBackgroundColor;
    }
    
    UIColor *legalPrimaryColor = self.configDict[legal_primary_color];
    if(legalPrimaryColor) {
        self.legalConditionsAcceptButton.backgroundColor = legalPrimaryColor;
        [self.circularProgressView setProgressLineWidth:3.0f andColor: legalPrimaryColor];
    }
    
    UIColor *legalTextColor = self.configDict[legal_text_color];
    if(legalTextColor) {
        self.legalConditionsAcceptButton.tintColor = legalTextColor;
    }

    UIImage *legalButtonImage = [UIImage imageNamed:self.configDict[legal_button_image]];
    if(legalButtonImage) {
        [self.legalConditionsAcceptButton setBackgroundImage:legalButtonImage forState:UIControlStateNormal];
        [self.legalConditionsAcceptButton setTitle:@"" forState:UIControlStateNormal];
        [self.legalConditionsAcceptButton setBackgroundColor:[UIColor clearColor]];
    }
    
    UIImage *legalBackgroundImage = [UIImage imageNamed:self.configDict[legal_background_image]];
    if(legalBackgroundImage) {
        [self.legalConditionsBackgroundImageView setImage:legalBackgroundImage];
    }
    
    NSNumber *backgroundHeight = self.configDict[legal_background_image_height];
    if(backgroundHeight) {
        self.legalConditionsButtonContainerHeight.constant = backgroundHeight.floatValue;
    }
    
    /*NSNumber *width = self.configDict[legal_button_width];
    if(width) {
        self.legalConditionsButtonWidth.constant = width.floatValue;
    }*/
    
    NSNumber *buttonHeight = self.configDict[legal_button_height];
    if(buttonHeight) {
        self.legalConditionsButtonHeight.constant = buttonHeight.floatValue;
    }
}

-(void)loadLegalConditionsURL:(NSString *)URL
{
    [self.legalConditionsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URL]]];
}

#pragma mark - IBActions

- (IBAction)legalConditionsDidPressAccept:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate legalConditionsVCDidPressAccept:self];
    }];
}

#pragma mark - WKUIDelegate
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (navigationAction.navigationType == WKNavigationTypeOther) {
        if (@available(iOS 13.0, *)) {
                
                    if(![[UIApplication sharedApplication] isStatusBarHidden])
                [self.navigationController.view setFrame:CGRectMake(0, STATUSBAR_SIZE, self.view.frame.size.width,self.view.frame.size.height )];
            else
                [self.navigationController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height )];
        }
        
    }
    decisionHandler(1);//WKNavigationActionPolicy.allow
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [self.circularProgressView setHidden:NO];
    [self.circularProgressView startAnimating];
    [self.legalConditionsAcceptButton setEnabled:NO];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.circularProgressView setHidden:YES];
    [self.circularProgressView stopAnimating];
    [self.legalConditionsAcceptButton setEnabled:YES];
}

@end
