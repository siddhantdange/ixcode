//
//  ObjCParser.h
//  ixCode
//
//  Created by Siddhant Dange on 2/15/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjCParser : NSObject

-(void)initParserWithDispatchTable:(NSMutableDictionary*)dispatchTable andViewController:(UIViewController*)vc andLoggerBlock:(void(^)(NSString*))loggerBlock;
-(void)startMethod:(NSString*)method;

-(id)forwardingTargetForSelector:(SEL)aSelector;
-(void)forwardInvocation:(NSInvocation *)anInvocation;

@end
