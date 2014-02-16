//
//  ViewController.m
//  TestProj
//
//  Created by Siddhant Dange on 1/10/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "ObjCParser.h"
#import <objc/objc-runtime.h>

@interface ObjCParser ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable, *superStack;
@property (nonatomic, copy) void (^loggerBlock)(NSString*);
@property (nonatomic, strong) NSNumber *integer;
@end

@implementation ObjCParser

-(void)startWithMethods:(NSMutableDictionary*)dispatchTable andViewController:(UIViewController*)vc andLoggerBlock:(void(^)(NSString*))loggerBlock{
    
    self.loggerBlock = loggerBlock;
    self.superStack = @{@"self" : vc, @"super" : vc.superclass, @"nil" : [NSNull null]}.mutableCopy;
    self.dispatchTable = @{
                           @"clicked" : @{
                                   @"type" : [self typeCodeFromMethodSignature:@"-(void)clicked"],
                                   @"body" : @"{UIColor *color = [UIColor whiteColor]; [[self view] setBackgroundColor:color];}"
                                   },
                           @"addButton" : @{
                                   @"type" : [self typeCodeFromMethodSignature:@"-(void)addButton"],
                                   @"body" : @"{UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake(200,100,300,300)]; UIColor *redColor = [UIColor redColor]; [newButton setBackgroundColor:redColor]; [newButton addTarget:self action:@selector(logLine) forControlEvents:UIControlEventTouchUpInside]; [[self view] addSubview:newButton];}"
                                   },
                           @"logLine" : @{
                                   @"type" : [self typeCodeFromMethodSignature:@"-(void)logLine"],
                                   @"body" : @"{[NSString *str = [[NSString alloc] initWithString:@\"hi\"]; [self printLog:str];}"
                                   }
                           }.mutableCopy;
    self.dispatchTable = dispatchTable.copy;
}

-(void)startMethod:(NSString*)method{
    [self processMethodBody:self.dispatchTable[method]];
}

-(void)printLog:(NSString*)str{
    self.loggerBlock(str);
}

-(NSString*)getMethodBody{
    //return @"{UIColor *color = [UIColor orangeColor]; [[self view] setBackgroundColor:color];}";
    
    
    //return @"{NSMutableString *string = [[NSMutableString alloc] initWithString:@\"yee\\shere!\"]; [string appendString:@\"\\slegoo!\"}";
    return @"{ UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50,100,100,50)]; [button addTarget:self action:@selector(addButton) forControlEvents:UIControlEventTouchUpInside]; UIColor *color = [UIColor redColor]; [button setBackgroundColor:color]; [button setTitle:@\"click\\sme!\" forState:UIControlStateNormal]; [[self view] addSubview:button]; UIColor *orangeColor = [UIColor orangeColor]; [[self view] setBackgroundColor:orangeColor];}";
}

-(void)processMethodBody:(NSString*)methodBody{
    methodBody = [methodBody substringFromIndex:[methodBody rangeOfString:@"{"].location + 1];
    //[UIButton alloc] init];
    
    //split line by line
    NSMutableArray *bodyLines = [NSMutableArray new];
    NSMutableString *line = @"".mutableCopy;
    for(int i = 0; i < methodBody.length; i++){
        char c = [methodBody characterAtIndex:i];
        if(c != ';'){
            [line appendString:[NSString stringWithFormat:@"%c", c]];
        } else{
            [bodyLines addObject:line];
            line = @"".mutableCopy;
        }
    }
    
    for (NSString *line in bodyLines) {
        if([line rangeOfString:@"="].location != NSNotFound){
            NSString *rightSide = [line substringFromIndex:[line rangeOfString:@"="].location + 1];
            NSString *leftSide = [line substringToIndex:[line rangeOfString:@"="].location];
            
            id value = [self parseSingularMethod:rightSide withStack:self.superStack];
            NSString *classStr = [leftSide substringToIndex:[leftSide rangeOfString:@" "].location];
            classStr = [classStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *objName = [leftSide substringFromIndex:[leftSide rangeOfString:@"*"].location + 1];
            objName = [objName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            id obj = value;// [NSClassFromString(classStr) init];
            [self.superStack setObject:obj forKey:objName];
        } else{
            [self parseSingularMethod:line withStack:self.superStack];
        }
    }
    
    int breakpointHere = 3;
    NSLog(@"table: %@", self.superStack);
}

-(id)parseSingularMethod:(NSString*)method withStack:(NSDictionary*)stack{
    NSString *beginning = [method substringToIndex:[method rangeOfString:@"]" options:NSBackwardsSearch].location];
    
    NSString *unwrappedMethod = [beginning substringFromIndex:[beginning rangeOfString:@"["].location + 1];
    
    //right side
    NSString *pattern = @"[\\w\\]]\\s([^\\]]*)$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0 error:NULL];
    NSTextCheckingResult *match = [regex firstMatchInString:unwrappedMethod options:0 range:NSMakeRange(0, [unwrappedMethod  length])];
    NSString *rightSide = @"";
    if(match != nil){
        rightSide = [unwrappedMethod substringWithRange:[match rangeAtIndex:1]];
    }
    
    NSString *leftSide = [[unwrappedMethod substringToIndex:[unwrappedMethod rangeOfString:rightSide].location]    stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //collect arguments if any
    NSMutableArray *arguments = [NSMutableArray new];
    if([rightSide rangeOfString:@":"].location != NSNotFound){ //here:this andThis:here
        pattern = @":([^\\s]+)\\s*";
        regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
        NSArray *arr = [regex matchesInString:rightSide options:0 range:NSMakeRange(0, [rightSide length])];
        for(int i = 0; i < arr.count; i++){
            NSValue* argument = nil;
            NSString *argumentStr = [rightSide substringWithRange:[arr[i] range]];
            argumentStr = [[argumentStr substringFromIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet  whitespaceAndNewlineCharacterSet]];
            if(stack[argumentStr]){
                argument = [NSValue valueWithPointer:(__bridge void *)(stack[argumentStr])];
            } else if(NSClassFromString(argumentStr)){
                argument = [NSValue valueWithPointer:(__bridge void *)(NSClassFromString(argumentStr))];
            } else if([self eval:argumentStr toCaste:&argument] != nil){
                [self eval:argumentStr toCaste:&argument];
            }
            
            [arguments addObject:argument];
        }
        
        pattern = @"\\w+:";
        regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
        arr = [regex matchesInString:rightSide options:0 range:NSMakeRange(0, [rightSide length] )];
        NSMutableString *argumentSig = @"".mutableCopy;
        for(int i = 0; i < arr.count; i++){
            [argumentSig appendString:[rightSide substringWithRange:[arr[i] range]]];
        }
        rightSide = argumentSig.copy;
    }
    
    id obj;
    if([leftSide rangeOfString:@"]"].location != NSNotFound){
        obj = [self parseSingularMethod:leftSide withStack:stack];
    }
    
    if(stack[leftSide]){
        obj = stack[leftSide];
    }
    
    if(NSClassFromString(leftSide)){
        obj = NSClassFromString(leftSide);
    }
    
    SEL selector = NSSelectorFromString(rightSide);
    id returner = nil;
    if([obj respondsToSelector:selector]){
        
        NSMethodSignature * mySignature = [[obj class] instanceMethodSignatureForSelector:selector];
        if(mySignature){
            NSInvocation * myInvocation = [NSInvocation invocationWithMethodSignature:mySignature];
            
            // Set selector and object
            [myInvocation setTarget:obj];
            [myInvocation setSelector:selector];
            
            for(int i = 0; i < arguments.count; i++){
                
                NSValue *currentVal = arguments[i];
                NSUInteger bufferSize = 0;
                NSGetSizeAndAlignment([currentVal objCType], &bufferSize, NULL);
                void* argument = malloc(bufferSize);
                [currentVal getValue:argument];
                [myInvocation setArgument:argument atIndex:i + 2];
                free(argument);
                
            }
            
            // Invoke it
            [myInvocation invoke];
            unsigned long length = [[myInvocation methodSignature] methodReturnLength];
            if(length > 0){
                [myInvocation getReturnValue:&returner];
            }
        } else{
            returner = [obj performSelector:selector withObject:nil withObject:nil];
        }
    } else if(self.dispatchTable[NSStringFromSelector(selector)]){
        [self processMethodBody:self.dispatchTable[NSStringFromSelector(selector)]];
    }
    
    return returner;
}

-(NSValue*)eval:(NSString*)value toCaste:(NSValue**)caste{ //@"asdfa" 5
    NSValue* casted = nil;
    
    if([value rangeOfString:@"@\""].location != NSNotFound){
        NSString *middle = [value substringFromIndex:[value rangeOfString:@"\""].location + 1];
        value = [middle substringToIndex:[middle rangeOfString:@"\""].location];
        
        //change 'space' escapes to actual spaces
        while([value rangeOfString:@"\\s"].location != NSNotFound){
            unsigned long loc = [value rangeOfString:@"\\s"].location;
            value = [NSString stringWithFormat:@"%@ %@", [value substringToIndex:loc], [value substringFromIndex:loc + 2]];
        }
        casted = [NSValue valueWithPointer:(__bridge void*)([NSString stringWithString:value])];
    } else if([value rangeOfString:@"@selector"].location != NSNotFound){
        
        NSString *middle = [value substringFromIndex:[value rangeOfString:@"("].location + 1];
        value = [middle substringToIndex:[middle rangeOfString:@")"].location];
        casted = [NSValue valueWithPointer:NSSelectorFromString(value)];
        
    } else if([value rangeOfString:@"CGRectMake"].location != NSNotFound){
        
        NSString *middle = [value substringFromIndex:[value rangeOfString:@"("].location + 1];
        value = [middle substringToIndex:[middle rangeOfString:@")"].location];
        
        NSString *pattern = @"([\\d.]+)";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
        NSArray *arr = [regex matchesInString:value options:0 range:NSMakeRange(0, [value length])];
        
        CGRect rect = CGRectMake([value substringWithRange:[arr[0] range]].floatValue, [value substringWithRange:[arr[1] range]].floatValue,  [value substringWithRange:[arr[2] range]].floatValue, [value substringWithRange:[arr[3] range]].floatValue);
        casted = [NSValue valueWithCGRect:rect];
    } else{
        
        //if value is a number literal
        if((value.intValue == 0 && [value rangeOfString:@"0"].location == 0) || value.intValue != 0){
            if([value rangeOfString:@"."].location != NSNotFound){ //float
                casted = [NSValue valueWithPointer:(__bridge void *)(@(value.floatValue))];
            } else{
                casted = [NSValue valueWithPointer:(__bridge void *)(@(value.intValue))];
            }
        } else{
            NSDictionary *enums = @{
                                    @"UIControlStateNormal" : @(UIControlStateNormal),
                                    @"UIControlEventTouchUpInside" : @(UIControlEventTouchUpInside)
                                    };
            if(enums[value]){
                casted = [NSValue valueWithPointer:(__bridge void *)(enums[value])];
            }
        }
    }
    
    *caste = casted;
    
    return casted;
}

//-(void)clicked{
//    NSLog(@"clicked!");
//}

-(NSString*)selectorStringFromFullSignature:(NSString*)signature{
    NSMutableString *sigStr = signature.mutableCopy;
    
    while([self indexOf:@"(" inString:sigStr] != -1){
        int firstIdx = [self indexOf:@"(" inString:sigStr];
        
        int traverseIdx = firstIdx;
        while([sigStr characterAtIndex:traverseIdx] != ' ' && traverseIdx != sigStr.length-1){
            traverseIdx++;
        }
        
        
        sigStr = [NSString stringWithFormat:@"%@%@", [sigStr substringToIndex:firstIdx], [sigStr substringFromIndex:traverseIdx+1]].mutableCopy;
    }
    
    return sigStr;
}


-(NSString*)typeCodeFromMethodSignature:(NSString*)signature{
    NSMutableString *typeCode = [[NSMutableString alloc] init];
    
    NSMutableString *parameterSection = signature.mutableCopy;
    
    while([self indexOf:@"(" inString:parameterSection] != -1){
        
        //capture parameter type
        NSString *parameterType = [self substring:parameterSection from:[self indexOf:@"(" inString:parameterSection]+1 to: [self indexOf:@")"  inString:parameterSection]];
        
        //strip to bare class
        BOOL isObject = NO;
        if([self indexOf:@"*" inString:parameterType] != -1){ //if it's an object
            parameterType = [parameterType substringToIndex:[self indexOf:@"*" inString:parameterType]];
            isObject = YES;
        }
        
        
        if(isObject){
            [typeCode appendFormat:@"%s", @encode(typeof([NSClassFromString(parameterType) alloc]))];
        } else{
            
            if([[self primitiveTypes] objectForKey:parameterType]){
                [typeCode appendFormat:@"%@", [[self primitiveTypes] objectForKey:parameterType]];
            } else{
                NSLog(@"could not find: %@", parameterType);
            }
            
        }
        
        //change string
        parameterSection = [parameterSection substringFromIndex:[self indexOf:@")" inString: parameterSection] + 1].mutableCopy;
    }
    
    int max = typeCode.length;
    NSString *end = @"";
    if(max >= 3){
        end = [typeCode substringFromIndex:1];
    }
    return [NSString stringWithFormat:@"%c@:%@", [typeCode characterAtIndex:0], end];
}

-(NSDictionary*)primitiveTypes{
    return @{
             @"short" :[NSString stringWithFormat:@"%s", @encode(short)],
             @"char" : [NSString stringWithFormat:@"%s", @encode(char)],
             @"int" : [NSString stringWithFormat:@"%s", @encode(int)],
             @"float" : [NSString stringWithFormat:@"%s", @encode(float)],
             @"long" : [NSString stringWithFormat:@"%s", @encode(long)],
             @"double" : [NSString stringWithFormat:@"%s", @encode(double)],
             @"void" : [NSString stringWithFormat:@"%s", @encode(void)]
             };
}

#pragma -mark String methods

-(int)indexOf:(NSString*)substring inString:(NSString*)string{
    return ([string rangeOfString:substring].location != NSNotFound) ? (int)[string rangeOfString:  substring].location : -1;
}

-(NSString*)substring:(NSString*)string from:(int)first to:(int)second{
    NSString *middle = [string substringFromIndex:first];
    NSString *charStr = [NSString stringWithFormat:@"%c", [string characterAtIndex:second]];
    return [middle substringToIndex:[self indexOf:charStr inString:middle]];
}

-(BOOL)respondsToSelector:(SEL)aSelector{
    if([super respondsToSelector:aSelector] || self.dispatchTable[NSStringFromSelector(aSelector)]){
        return YES;
    }
    
    return NO;
}

-(id)forwardingTargetForSelector:(SEL)aSelector{
    
    if(self.dispatchTable[NSStringFromSelector(aSelector)]){
        
        [self processMethodBody:self.dispatchTable[NSStringFromSelector(aSelector)][@"body"]];
        [self methodIMPCopy:self.class forOrigSel:aSelector andAltSel:@selector(blankMethod)];
    }
    
    return self;
}

-(void)forwardInvocation:(NSInvocation *)anInvocation{
    if([self respondsToSelector:anInvocation.selector]){
        [self performSelector:anInvocation.selector withObject:nil];
    } else if([super respondsToSelector:anInvocation.selector]){
        [super performSelector:anInvocation.selector withObject:nil];
    }
}

-(void)blankMethod{
}

-(void)methodIMPCopy:(Class) aClass forOrigSel:(SEL)orig_sel andAltSel:(SEL)alt_sel{
    
    Method swizzled = class_getInstanceMethod(aClass, alt_sel);
    class_replaceMethod(aClass, orig_sel, method_getImplementation(swizzled), ((NSString*)self.dispatchTable[NSStringFromSelector(orig_sel)][@"type"]).UTF8String);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
