//
//  ObjCParser.h
//  ixCode
//
//  Created by Siddhant Dange on 2/15/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjCParser : NSObject

-(void)startWithMethods:(NSMutableDictionary*)dispatchTable andViewController:(UIViewController*)vc;
-(void)startMethod:(NSString*)method;

@end
