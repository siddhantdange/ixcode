//
//  ViewController.m
//  ixCode
//
//  Created by Siddhant Dange on 2/14/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "ViewController.h"
#import "NSStack.h"

@interface ViewController ()<UIAlertViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSString *tempText;
@property (strong, nonatomic) UIImageView *errorImage;
@property (strong, nonatomic) UIImageView *buildImage;
@property (weak, nonatomic) IBOutlet UIImageView *loadingBar;

@property (strong, nonatomic) IBOutlet UITextView *log;
@property int errorLine;
@property (weak, nonatomic) IBOutlet UIImageView *errorNavImage;
@property (weak, nonatomic) IBOutlet UITextView *lineNum;
@property (weak, nonatomic) IBOutlet UITextView *lineNum2;
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;

@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Name of Project" message:@"Please enter the name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].delegate = self;
    [av show];
    [self.errorNavImage setAlpha:0];
    isMax = true;
    self.progressBar.progress = 0.0;
    NSString *lineNumbers = @"";
    for (int i = 0; i < 50; i++){
        lineNumbers = [lineNumbers stringByAppendingString:[NSString stringWithFormat:@"%i\n",i]];
    }
    
    NSLog(@"Numbers = %@",lineNumbers);
    self.errorImage = [[UIImageView alloc]initWithFrame:CGRectMake(357, 63+19*12, 385, 19)];
    [self.errorImage setBackgroundColor:[UIColor redColor]];
    [self.errorImage setAlpha:0.7];
    self.buildImage = [[UIImageView alloc]initWithFrame:CGRectMake(412, 311, 200, 200)];
    [self.log setFrame:CGRectMake(768, 0, 742, 238)];
    [self.lineNum setText:lineNumbers];
    [self.lineNum2 setText:lineNumbers];
    //self.loadingBar.layer.cornerRadius = self.loadingBar.frame.size.height/2;
    
    [self.view addSubview:self.buildImage];

}

- (void)makeMyProgressBarMoving {
    
    float actual = [self.progressBar progress];
    if (actual < 1) {
        self.progressBar.progress = actual + .05;
        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(makeMyProgressBarMoving) userInfo:nil repeats:NO];
    }
    else{
        
        
        
    }
    
}
- (IBAction)emails:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Project Share";
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"---------------- \nViewController.h\n ----------------  \n %@ \n ---------------- \nViewController.m\n ---------------- \n %@",self.textEditorh.text,self.textEditor.text];
    // To address
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)rightSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self stop:nil];
        [self.view endEditing:YES];
    }
}

- (IBAction)stop:(id)sender {
    [self.textEditorh setFrame:CGRectMake(22, 52, 469, 716)];
    [self.textEditor setFrame:CGRectMake(513, 54, 511, 714)];
    [self.lineNum setFrame:CGRectMake(0, 52, 27, 716)];
    [self.lineNum2 setFrame:CGRectMake(490, 54, 27, 716)];
    [self.buildImage setAlpha:0.0];
    self.progressBar.progress = 0.0;
    [self.log setFrame:CGRectMake(0, 768, 1024, 153)];
    [self.view endEditing:YES];
}


-(void)backtoNormal{
    [self.textEditorh setFrame:CGRectMake(22, 52, 469, 716)];
    [self.textEditor setFrame:CGRectMake(513, 54, 511, 714)];
    [self.lineNum setFrame:CGRectMake(0, 52, 27, 716)];
    [self.lineNum2 setFrame:CGRectMake(490, 54, 27, 716)];
    [self.buildImage setAlpha:0.0];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    NSStack* aStack=[[NSStack alloc]init];
    [aStack push:@"{"];
    NSLog([aStack pop]);
}
//}
//- (BOOL)isValid:(NSString *)string
//{
//    NSLog(@"string = %@",string);
//    NSLog(@"tempString = %@",self.tempText);
//    string = [string stringByReplacingOccurrencesOfString:self.tempText withString:@""];
//    NSLog(@"string = %@",string);
//    NSArray *lines = [string componentsSeparatedByString:@"\n"];
//    for (NSString *l in lines)
//    {
//        NSString *line = [l stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//        if ([self lineRequiresSemicolon:line])
//        {
//            if (![[line substringFromIndex:[line length] - 1] isEqualToString:@";"])
//                return false;
//        }
//    }
//    return true;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textField %@",textField.text);
    [self setEditorTextwithString:textField.text];
    [textField endEditing:YES];
}

-(void)setEditorTextwithString:(NSString *)project{
    NSString *string = [NSString stringWithFormat:@"// \n//  ViewController.m\n//  %@\n//\n//  Created by user on 2/16/14.\n//  Copyright (c) 2014 user. All rights reserved.\n//\n\n#import <ViewController.h>\n\n@implementation ViewController\n\n-(void)viewDidLoad{\n\n}\n\n@end",project];
    self.tempText = [NSString stringWithFormat:@"// \n//  ViewController.m\n//  %@\n//\n//  Created by user on 2/16/14.\n//  Copyright (c) 2014 user. All rights reserved.\n//\n\n#import <ViewController.h>\n\n@implementation ViewController\n\n",project];
    NSString *stringH = [NSString stringWithFormat:@"// \n//  ViewController.h\n//  %@\n//\n//  Created by user on 2/16/14.\n//  Copyright (c) 2014 user. All rights reserved.\n//\n\n#import <UIKit/UIKit.h>\n\n@interface ViewController : UIViewController\n\n@end",project];

    
    
    [self.textEditorh setText:stringH];
    [self.textEditor setText:string];
}

- (BOOL)isValid:(NSString *)string
{
    NSLog(@"string = %@",string);
    NSLog(@"tempString = %@",self.tempText);
    string = [string stringByReplacingOccurrencesOfString:self.tempText withString:@""];
    NSLog(@"string = %@",string);
    NSArray *lines = [string componentsSeparatedByString:@"\n"];
    int i = 11;
    for (NSString *l in lines)
    {
        i++;
        NSString *line = [l stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (line.length > 0) {
        if ([self lineRequiresSemicolon:line])
        {
            if (![[line substringFromIndex:[line length] - 1] isEqualToString:@";"]){
                
//                [UIView beginAnimations:nil context:nil];
//                [UIView setAnimationDuration:0.5];
//                [UIView setAnimationDelay:1.0];
//                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//                [self.textEditor setFrame:CGRectMake(395, 52, 350, 716)];
//                [self.textEditorh setFrame:CGRectMake(22, 52, 350, 716)];
//                [UIView commitAnimations];
                [self.errorImage setFrame:CGRectMake(513, 62+ 14*i, 512, 14)];
                if (i>self.errorLine) {
                    self.errorLine = i;
                }
                [self.view addSubview:self.errorImage];
                return false;
            }
        }
        }
    }
    return true;
}



-(int)errorLine:(NSString *)input{
    
    NSString *pattern=@"[\\[\\](){}]";
    NSDictionary *bracketMatch=@{@"{" : @"}", @"[" : @"]", @"(" : @")" };
    NSError *error=nil;
    NSStack *expressionStack=[[NSStack alloc]init];
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
    NSArray* matches = [regex matchesInString:input options:0 range: NSMakeRange(0, [input length])];
    for (NSTextCheckingResult* match in matches) {
        NSString* newBracket = [input substringWithRange:[match range]];
        NSString* oldBracket=[expressionStack pop];
        if(oldBracket==NULL) {
            if([bracketMatch valueForKey:newBracket])
                [expressionStack push:newBracket];
            else{
                int linenumber=[self lineFromPosition:[match range].location inText:input];
                [self logwithstring:[NSString stringWithFormat:@"Extra %@ at line %d", newBracket, linenumber]];
                return linenumber;
                
            }
        }
        else if([[bracketMatch valueForKey:oldBracket] isEqualToString:newBracket]){
            NSLog([@"matching:"stringByAppendingString:[oldBracket stringByAppendingString:newBracket]]);
        }
        else if([bracketMatch valueForKey:newBracket]==NULL){
            int linenumber=[self lineFromPosition:[match range].location inText:input];
            [self logwithstring:[NSString stringWithFormat:@"Extra %@ at line %d", newBracket, linenumber]];
            return [self lineFromPosition:[match range].location inText:input];
        }
        
        else{
            if (oldBracket)
            [expressionStack push:oldBracket];
            [expressionStack push:newBracket];
        }
    }
    if([expressionStack pop]){
        return [self lineFromPosition:[input length]-1 inText:input];
    }
    else{
        return -1;
    }
}

- (int)lineFromPosition:(int) position inText:(NSString*)string{
    NSArray *lines = [string componentsSeparatedByString:@"\n"];
    
    int currentLine=0;
    int currentCharacter=0;
    for (NSString* line in lines){
        currentCharacter+=[line length]+1;
        currentLine++;
        if (position<=currentCharacter){
            NSLog(@"SHIT %d",currentLine);
            return currentLine;
        }
    }
    NSLog(@"Shit %d",currentLine);
    return -1;
//    
//    NSString *pattern=@"\n";
//    NSError *error=nil;
//
//    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
//    NSArray* matches = [regex matchesInString:string options:0 range: NSMakeRange(0, [string length])];
//    
//    
//    
//    
//    for (NSTextCheckingResult* match in matches){
//        
//        currentLine++;
//        int len=[match range].length;
//        int loc=[match range].location;
//        NSString* line=[string substringWithRange:[match range]];
//        NSLog([NSString stringWithFormat:@"Line Number:%d,position%d,length%d: %@",currentLine,loc,len,line]);
//        if(position<=[match range].location){
//            return currentLine;
//        }
//        
//    }
//    return -1;
}


- (BOOL)lineRequiresSemicolon:(NSString *)line
{
    NSLog(@"%@",line);
    if ([[line substringToIndex:1] isEqualToString:@"{"])
        return false;
    else if ([[line substringToIndex:1] isEqualToString:@"}"])
        return false;
    else if ([line length] >= 3 && [[line substringToIndex:3] isEqualToString:@"for"])
        return false;
    else if ([line length] >= 2 && [[line substringToIndex:2] isEqualToString:@"if"])
        return false;
    else if ([line length] >= 5 && [[line substringToIndex:5] isEqualToString:@"while"])
        return false;
    else if ([[line substringToIndex:1] isEqualToString:@"@"])
    {
        if ([line length] >= 9 && [[line substringToIndex:9] isEqualToString:@"@property"])
            return true;
        else
            return false;
    }
    else if ([[line substringToIndex:1] isEqualToString:@"#"])
        return false;
    else if ([[line substringToIndex:1] isEqualToString:@"-"] || [[line substringToIndex:1] isEqualToString:@"+"])
        return false;
    return true;
}

- (NSDictionary *)parseClass:(NSString *)class
{
    NSMutableDictionary *parsed = [NSMutableDictionary dictionary];
    NSArray *lines = [class componentsSeparatedByString:@"\n"];
    NSString *className = @"";
    NSMutableDictionary *methods = [NSMutableDictionary dictionary];
    for (NSString *l in lines)
    {
        NSString *line = [l stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSLog(@"line: %@", line);
        if ([line length] >= [@"@implementation" length] && [[line substringToIndex:15] isEqualToString:@"@implementation"])
        {
            line = [[line substringFromIndex:15] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            className = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        else if ([line length] >= 1 && ([[line substringToIndex:1] isEqualToString:@"-"] || [[line substringToIndex:1] isEqualToString:@"+"]))
        {
            line = [[line substringFromIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            int openPIndex = (int)[line rangeOfString:@"("].location;
            int closePIndex = (int)[line rangeOfString:@")"].location;
            NSString *returnType = [line substringWithRange:NSMakeRange(openPIndex+1, closePIndex - openPIndex-1)];
            NSLog(@"method return type: %@", returnType);
            line = [[line substringFromIndex:closePIndex+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if ([[line substringFromIndex:[line length] - 1] isEqualToString:@"{"])
                line = [line substringToIndex:[line length] - 1];
            NSString *methodName = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSLog(@"method name: %@", methodName);
            NSString *fullMethod = [class substringFromIndex:[class rangeOfString:methodName].location];
            fullMethod = [fullMethod substringFromIndex:[fullMethod rangeOfString:@"{"].location + 1];
            int fullMethodLength = (int)[fullMethod length];
            int opening = 1;
            int indexOfClosingBracket = 0;
            for (int i = 0; i < fullMethodLength; i++)
            {
                NSString *currentCharacter = [fullMethod substringWithRange:NSMakeRange(i, 1)];
                if ([currentCharacter isEqualToString:@"{"])
                    opening++;
                else if ([currentCharacter isEqualToString:@"}"])
                    opening--;
                if (opening == 0)
                {
                    indexOfClosingBracket = i;
                    break;
                }
            }
            NSString *methodBody = [fullMethod substringToIndex:indexOfClosingBracket - 1];
            NSLog(@"method body: %@", [methodBody stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]);
            NSMutableDictionary *method = [NSMutableDictionary dictionary];
            [method setObject:returnType forKey:@"type"];
            [method setObject:methodBody forKey:@"body"];
            [methods setObject:method forKey:methodName];
        }
    }
    [parsed setObject:methods forKey:className];
    return parsed;
}

- (IBAction)compileCode:(id)sender {
        [self.view endEditing:YES];
    int errorline=[self errorLine:self.textEditor.text];
    
    if (errorline>self.errorLine) {
        self.errorLine = errorline;
    }
    
    [self.errorImage setFrame:CGRectMake(513, 62+14*(self.errorLine-1), 512, 14)];

    if ([self lineRequiresSemicolon:self.textEditor.text]&&[self isValid:self.textEditor.text]&&errorline==-1) {
        NSDictionary *VCDictionary = [self parseClass:self.textEditor.text];
#warning pass this dictionary to Sid
        
        
        [UIView animateWithDuration:1.5f
                         animations:^{
                             // temp.alpha=0.0f;
                             [self.loadingBar setFrame:CGRectMake(291, 26, 439, 14)];
                             self.progressBar.progress = 0.0;
                             [self performSelectorOnMainThread:@selector(makeMyProgressBarMoving) withObject:nil waitUntilDone:NO];                             //z[temp setAlpha:0.0];
                             
                             
                         }
                         completion:^(BOOL finished) {
                             [self.loadingBar setFrame:CGRectMake(291, 26, 0, 14)];
                             [self.buildImage setImage:[UIImage imageNamed:@"didFinish"]];
                             [self.buildImage setAlpha:1.0];
                             
                             [UIView animateWithDuration:1.5f
                                              animations:^{
                                                  // temp.alpha=0.0f;
                                                  [self.errorImage removeFromSuperview];
                                                  
                                              }
                                              completion:^(BOOL finished) {
                                                  [UIView animateWithDuration:1.0f
                                                                   animations:^{
                                                                       // temp.alpha=0.0f;
                                                                        [self.textEditor setFrame:CGRectMake(395, 52, 350, 716)];
                                                                       [self.textEditorh setFrame:CGRectMake(22, 52, 350, 716)];
                                                                       [self.log setFrame:CGRectMake(0, 615, 1024, 153)];
                                                                       [self.lineNum setFrame:CGRectMake(0, 52, 27, 615-52)];
                                                                       [self.lineNum2 setFrame:CGRectMake(370, 52, 27, 615-52)];
                                                                       //z[temp setAlpha:0.0];
                                                                   }
                                                                   completion:^(BOOL finished) {
                                                                       [self.buildImage setAlpha:0.0];
                                                                       [self.errorNavImage setAlpha:0];
                                                                   }];
                                              }];

                             
                         }];
        


        
    }
    else{
        [UIView animateWithDuration:1.5f
                         animations:^{
                             // temp.alpha=0.0f;
                             [self.buildImage setImage:[UIImage imageNamed:@"notFinish"]];
                             [self.buildImage setAlpha:1.0];
                             [self performSelectorOnMainThread:@selector(makeMyProgressBarMoving) withObject:nil waitUntilDone:NO];
                             [self.loadingBar setFrame:CGRectMake(291, 26, 439, 14)];
                             self.loadingBar.layer.cornerRadius = self.loadingBar.frame.size.height/2;
                             [self.log setFrame:CGRectMake(0, 768, 1024, 153)];
                             [self.lineNum setFrame:CGRectMake(0, 52, 27, 615-52)];
                             [self.lineNum2 setFrame:CGRectMake(490, 52, 27, 615-52)];
                             //z[temp setAlpha:0.0];
                             
                         }
                         completion:^(BOOL finished) {
                             [self.buildImage setAlpha:0.0];
                             [self.loadingBar setFrame:CGRectMake(291, 26, 0, 14)];
                             [self.buildImage setImage:[UIImage imageNamed:@"notFinish"]];
                             [self.buildImage setAlpha:1.0];
                             [self.log setFrame:CGRectMake(0, 615, 1024, 153)];
                             [self.lineNum setFrame:CGRectMake(0, 52, 27, 615-52)];
                             [self.lineNum2 setFrame:CGRectMake(490, 52, 27, 615-52)];
                             [self.errorNavImage setAlpha:1];
                         }];
    }
}

-(void)logwithstring:(NSString *)suchwow{
    self.log.text = [self.log.text stringByAppendingString:[NSString stringWithFormat:@"\n%@ ixCode: %@",[[NSDate date] description],suchwow]];
}

@end
