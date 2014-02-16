//
//  ViewController.h
//  ixCode
//
//  Created by Siddhant Dange on 2/14/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    BOOL isMax;
    
}
@property (weak, nonatomic) IBOutlet UITextView *textEditor;
@property (weak, nonatomic) IBOutlet UITextView *textEditorh;
@property (weak, nonatomic) UIView *simulator;

-(void)logwithstring:(NSString *)nsstring;

@end
