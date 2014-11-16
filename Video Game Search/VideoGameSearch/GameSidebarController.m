//
//  GameSidebarController.m
//  VideoGameSearch
//
//  Created by Vincent Sam on 11/15/14.
//  Copyright (c) 2014 Vincent Sam. All rights reserved.
//

#import "GameSidebarController.h"
#import "SWRevealViewController.h"
#import "VGSUtils.h"

@interface GameSidebarController () {
    NSUserDefaults *userDefaults;
    NSNotificationCenter *notificationCenter;
}
@end

@implementation GameSidebarController

@synthesize searchTextField;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self searchFieldImage];
    
    if (!notificationCenter)
        notificationCenter = [NSNotificationCenter defaultCenter];
    
    searchTextField.delegate = self;
    
    self.clearsSelectionOnViewWillAppear = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == searchTextField) {
        [textField resignFirstResponder];
        [notificationCenter postNotificationName:GameSettingsMenuDismissed object:self.revealViewController];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = nil;
    textField.text = @"";
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!userDefaults)
        userDefaults = [NSUserDefaults standardUserDefaults];
    [self searchFieldsValue];
}

- (void)searchFieldImage
{
    [searchTextField setLeftViewMode:UITextFieldViewModeAlways];
    UIImageView *searchImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.png"]];
    CGRect rect = CGRectMake(0, 0, 15, 15);
    searchImage.image = [self imageWithImage:searchImage.image scaledToRect:rect];
    searchImage.frame = CGRectMake(0.0f, 0.0f, searchImage.image.size.width + 10.0f, searchImage.image.size.height + 10.0f);
    searchImage.contentMode = UIViewContentModeRight;
    searchTextField.leftView = searchImage;
    // Add a "textFieldDidChange" notification method to the text field control.
    [searchTextField addTarget:self
                        action:@selector(textFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
}

- (void)searchFieldsValue
{
    NSString *searchTerms = [userDefaults valueForKey:UserDefaultSearchParams];
    searchTextField.text = searchTerms;
}

- (void)textFieldDidChange:(id)sender
{
    if ([sender isKindOfClass:[UITextField class]]) {
        UITextField *textField = sender;
        NSString *searchTerms = textField.text;
        [userDefaults setValue:searchTerms forKey:UserDefaultSearchParams];
    }
}



- (UIImage *)imageWithImage:(UIImage *)image scaledToRect:(CGRect)rect
{
    UIGraphicsBeginImageContext( rect.size );
    [image drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(picture1);
    return [UIImage imageWithData:imageData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
