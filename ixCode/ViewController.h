//
//  ViewController.h
//  ixCode
//
//  Created by Siddhant Dange on 2/14/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ObjCParser.h"
#import "SImulatorViewController.h"
@interface ViewController : UIViewController<MFMailComposeViewControllerDelegate>{
    BOOL isMax;
    IBOutlet SImulatorViewController *simulatorVC;
}
@property (strong, nonatomic) IBOutlet UITextView *textEditor;
@property (strong, nonatomic) IBOutlet UITextView *textEditorh;
@property (weak, nonatomic) UIView *simulator;

-(void)logwithstring:(NSString *)nsstring;

//27

@end
