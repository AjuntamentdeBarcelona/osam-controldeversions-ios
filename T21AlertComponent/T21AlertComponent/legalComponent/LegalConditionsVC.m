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

-(instancetype)initWithColorDict:(NSDictionary *)colorDict
{
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        self.colorDict = colorDict;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.legalConditionsWebView.delegate = self;
    
    self.legalConditionsWebView.backgroundColor = self.colorDict[legal_background_color];
    self.legalConditionsAcceptButton.backgroundColor = self.colorDict[legal_primary_color];
    self.legalConditionsAcceptButton.tintColor = self.colorDict[legal_text_color];
    self.legalConditionsButtonContainer.backgroundColor = self.colorDict[legal_background_color];
    
    [self.legalConditionsAcceptButton setEnabled:NO];
    
    self.circularProgressView.isInfiniteProgress = YES;
    [self.circularProgressView setProgressLineWidth:3.0f andColor: self.colorDict[legal_primary_color]];
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
                [safariViewController setPreferredControlTintColor:self.colorDict[legal_primary_color]];
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
