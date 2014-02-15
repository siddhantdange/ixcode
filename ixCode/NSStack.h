//
//  NSStack.h
//  ixCode
//
//  Created by Romi Phadte on 2/15/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStack : NSObject {
    NSMutableArray* m_array;
    int count;
}
- (void)push:(id)anObject;
- (id)pop;
- (void)clear;
@property (nonatomic, readonly) int count;
@end