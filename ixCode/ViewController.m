//
//  ViewController.m
//  ixCode
//
//  Created by Siddhant Dange on 2/14/14.
//  Copyright (c) 2014 Siddhant Dange. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIAlertViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) NSString *tempText;
@property (strong, nonatomic) UIImageView *errorImage;


@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Name of Project" message:@"Please enter the name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    [av textFieldAtIndex:0].delegate = self;
    [av show];
    isMax = true;
    self.errorImage = [[UIImageView alloc]initWithFrame:CGRectMake(357, 63+19*12, 385, 19)];
    [self.errorImage setBackgroundColor:[UIColor redColor]];
    [self.errorImage setAlpha:0.7];
}

- (IBAction)rightSwipe:(UISwipeGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.textEditorh setFrame:CGRectMake(0, 54, 511, 714)];
        [self.textEditor setFrame:CGRectMake(513, 54, 511, 714)];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
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
    NSString *string = [NSString stringWithFormat:@"// \n//  ViewController.m\n//  %@\n//\n//  Created by user on 2/14/14.\n//  Copyright (c) 2014 user. All rights reserved.\n//\n\n#import <ViewController.h>\n\n@implementation ViewController\n\n-(void)viewDidLoad{\n\n}\n\n@end",project];
    self.tempText = [NSString stringWithFormat:@"// \n//  ViewController.m\n//  %@\n//\n//  Created by user on 2/14/14.\n//  Copyright (c) 2014 user. All rights reserved.\n//\n\n#import <ViewController.h>\n\n@implementation ViewController\n\n",project];
    NSString *stringH = [NSString stringWithFormat:@"// \n//  ViewController.h\n//  %@\n//\n//  Created by user on 2/14/14.\n//  Copyright (c) 2014 user. All rights reserved.\n//\n\n#import <UIKit/UIKit.h>\n\n@interface ViewController : UIViewController\n\n@end",project];

    
    
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
    int i = 0;
    for (NSString *l in lines)
    {
        i++;
        NSString *line = [l stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (line.length > 0) {
        if ([self lineRequiresSemicolon:line])
        {
            if (![[line substringFromIndex:[line length] - 1] isEqualToString:@";"]){
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationDelay:1.0];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                [self.textEditorh setFrame:CGRectMake(0, 54, 511, 714)];
                [self.textEditor setFrame:CGRectMake(513, 54, 511, 714)];
                
                [UIView commitAnimations];
                [self.errorImage setFrame:CGRectMake(513, 62+14*11 + 14*i, 512, 14)];
                [self.view addSubview:self.errorImage];
                return false;
            }
        }
        }
    }
    return true;
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

- (IBAction)compileCode:(id)sender {
    if ([self lineRequiresSemicolon:self.textEditor.text]&&[self isValid:self.textEditor.text]) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        [self.textEditor setFrame:CGRectMake(357, 54, 385, 714)];
        [self.textEditorh setFrame:CGRectMake(0, 54, 355, 714)];
        [self.errorImage removeFromSuperview];
        [UIView commitAnimations];
    }
    else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationDelay:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        
        [self.textEditor setFrame:CGRectMake(0, 54, 1024, 714)];
        
        [UIView commitAnimations];
    }
}



@end
