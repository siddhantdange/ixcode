//
//  SImulatorViewController.m
//  ixCode
//
//  Created by Ash Bhat on 2/16/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "SImulatorViewController.h"
#import "ObjCParser.h"

@interface SImulatorViewController ()
@property (nonatomic, strong) ObjCParser *parser;

@end

@implementation SImulatorViewController

-(id)initWithParser:(ObjCParser*)parser{
    self = [super init];
    self.parser = parser;
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma -mark forwarding

-(id)forwardingTargetForSelector:(SEL)aSelector{
    return [self.parser forwardingTargetForSelector:aSelector];
}

-(void)forwardInvocation:(NSInvocation *)anInvocation{
    [self.parser forwardInvocation:anInvocation];
}

@end
