//
//  SImulatorViewController.h
//  ixCode
//
//  Created by Ash Bhat on 2/16/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ObjCParser;
@interface SImulatorViewController : UIViewController


@property (nonatomic, strong) ObjCParser *parser;

-(id)initWithParser:(ObjCParser*)parser;

@end
