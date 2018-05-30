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

@interface LegalConditionsVC () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet LCCircularProgressView *circularProgressView;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.legalConditionsWebView.delegate = self;
    [self.legalConditionsAcceptButton setEnabled:NO];
    
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
    
    NSNumber *width = self.configDict[legal_button_width];
    if(width) {
        self.legalConditionsButtonWidth.constant = width.floatValue;
    }
    
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

#pragma mark - UIWebViewDelegate
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        if (@available(iOS 9.0, *)) {
            SFSafariViewController *safariViewController = [[SFSafariViewController alloc] initWithURL:request.URL];
            if (@available(iOS 10.0, *)) {
                [safariViewController setPreferredControlTintColor:self.configDict[legal_primary_color]];
            } else {
                // Fallback on earlier versions
            }
            [self presentViewController:safariViewController animated:YES completion:^{}];
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:request.URL];
        }
        return NO;
    }
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.circularProgressView setHidden:NO];
    [self.circularProgressView startAnimating];
    [self.legalConditionsAcceptButton setEnabled:NO];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.circularProgressView setHidden:YES];
    [self.circularProgressView stopAnimating];
    [self.legalConditionsAcceptButton setEnabled:YES];
}

@end
