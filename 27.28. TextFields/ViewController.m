//
//  ViewController.m
//  27.28. TextFields
//
//  Created by Admin on 09.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    for (UITextField *obj in self.collectionTextFields){
        obj.delegate=self;
    }
    
}
 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
 
#pragma mark -UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *stringForValidate=[textField.text stringByAppendingString:string];
    //NSLog(@"in field: %@ replacementStr :%@",textField.text,stringForValidate);
    BOOL shouldValidate=YES;
    UILabel * currentLabel =[self labelByTextField:textField];
    switch (textField.tag) {
        case textFieldTypeFirstname:
            shouldValidate=[self inputControlString:stringForValidate WithPattern:@"^[a-zA-Z]+$" maxNumberOfSymbols:7];
            break;
        case textFieldTypeLastname:
            shouldValidate=[self inputControlString:stringForValidate WithPattern:@"^[a-zA-Z]+$" maxNumberOfSymbols:7];
            break;
        case textFieldTypeLogin:
            shouldValidate=[self inputControlString:stringForValidate WithPattern:@".*" maxNumberOfSymbols:7];
            break;
        case textFieldTypePassword:
            shouldValidate=[self inputControlString:stringForValidate WithPattern:@".*" maxNumberOfSymbols:7];
            break;
        case textFieldTypeAge:
            shouldValidate=[self inputControlString:stringForValidate WithPattern:@"^[0-9]{1,3}$" maxNumberOfSymbols:3];
            //there is an excess condition. or {1,3} or maxnumber 3. Both are here just for fun.
            break;
        case textFieldTypePhone:
            shouldValidate=[self inputPhoneControl:textField replacingString:string range:range];
            break;
        default:
            break;
    }
    
    
    if (shouldValidate) {
        [self putText:stringForValidate intoLabel:currentLabel];
    }
    
    return shouldValidate;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    BOOL shouldValidate=YES;
    switch (textField.tag) {
        case textFieldTypeMail:
           shouldValidate=[self inputControlString:textField.text WithPattern:@"^[^@]*@{1,1}[^@\\.]+\\.[^\\.@]+$" maxNumberOfSymbols:8];
            //pattern explanation: in the beginning any letters in any amount, then @ (add) only 1,then 1 or more characters which is not @ and not ".", then ".", then 1 or more characters which is not @ and not "." in the end of word.
            UILabel *label=[self labelByTextField:textField];
            
            if (!shouldValidate) {
                label.text=@"wrong";
            } else {
                label.text=textField.text;
            }
            
            shouldValidate=YES;
            break;
    }
    return shouldValidate;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
        if (textField.tag<textFieldTypeMail) {
            UITextField *nextField=[self.collectionTextFields objectAtIndex:(textField.tag+1-10)];
            [nextField becomeFirstResponder];
        } else {
            [textField resignFirstResponder];
        }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    UILabel *currentLabel=[self labelByTextField:textField];
        if (currentLabel) {
        [self putText:@"" intoLabel:currentLabel];
    }
    
    return YES;
}

#pragma mark -Control methods
- (BOOL) inputControlString:(NSString*)str WithPattern:(NSString*) pattern maxNumberOfSymbols:(NSInteger)maxNumberOfSymbols{
    if ([str length]>maxNumberOfSymbols) {
        return NO;
    }
    NSError *err=nil;
    NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&err];

    if (err)
    {
        NSLog(@"Couldn't create regex with given string and options");
    }
    
    NSRange rangeOfNSString=[regex rangeOfFirstMatchInString:str options:0 range:NSMakeRange(0, [str length])];
    if (rangeOfNSString.location!=NSNotFound) {
        return YES;
    } else {
        return NO;
    }
    
    //NSLog(@"only sentence with NSString: %@",arrayConsistOfSentencesWithNSString);
}

- (BOOL) inputPhoneControl:(UITextField*) textField replacingString:(NSString*) string range:(NSRange) range{
    NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
    
    if ([components count] > 1) {
        return NO;
    }
    
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //+XX (XXX) XXX-XXXX
    
    //NSLog(@"new string = %@", newString);
    
    NSArray* validComponents = [newString componentsSeparatedByCharactersInSet:validationSet];
    
    newString = [validComponents componentsJoinedByString:@""];
    
    // XXXXXXXXXXXX
    
   // NSLog(@"new string fixed = %@", newString);
    
    static const int localNumberMaxLength = 7;
    static const int areaCodeMaxLength = 3;
    static const int countryCodeMaxLength = 3;
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength + countryCodeMaxLength) {
        return NO;
    }
    
    
    NSMutableString* resultString = [NSMutableString string];
    
    /*
     XXXXXXXXXXXX
     +XX (XXX) XXX-XXXX
     */
    
    NSInteger localNumberLength = MIN([newString length], localNumberMaxLength);
    
    if (localNumberLength > 0) {
        
        NSString* number = [newString substringFromIndex:(int)[newString length] - localNumberLength];
        
        [resultString appendString:number];
        
        if ([resultString length] > 3) {
            [resultString insertString:@"-" atIndex:3];
        }
        
    }
    
    if ([newString length] > localNumberMaxLength) {
        
        NSInteger areaCodeLength = MIN((int)[newString length] - localNumberMaxLength, areaCodeMaxLength);
        
        NSRange areaRange = NSMakeRange((int)[newString length] - localNumberMaxLength - areaCodeLength, areaCodeLength);
        
        NSString* area = [newString substringWithRange:areaRange];
        
        area = [NSString stringWithFormat:@"(%@) ", area];
        
        [resultString insertString:area atIndex:0];
    }
    
    if ([newString length] > localNumberMaxLength + areaCodeMaxLength) {
        
        NSInteger countryCodeLength = MIN((int)[newString length] - localNumberMaxLength - areaCodeMaxLength, countryCodeMaxLength);
        
        NSRange countryCodeRange = NSMakeRange(0, countryCodeLength);
        
        NSString* countryCode = [newString substringWithRange:countryCodeRange];
        
        countryCode = [NSString stringWithFormat:@"+%@ ", countryCode];
        
        [resultString insertString:countryCode atIndex:0];
    }
    
    
    textField.text = resultString;
    [self putText:resultString intoLabel:[self labelByTextField:textField]];
    
    
    return NO;
    
    
    
    //NSCharacterSet* set = [NSCharacterSet characterSetWithCharactersInString:@" ,?"];
    /*
     NSCharacterSet* set = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
     NSArray* words = [resultString componentsSeparatedByCharactersInSet:set];
     NSLog(@"words = %@", words);
     
     
     return [resultString length] <= 10;
     */
    
    
}

- (void) putText:(NSString*) text intoLabel:(UILabel*) label{
   
    
    label.text=text;
}
- (UILabel*) labelByTextField:(UITextField*) textField {
    UILabel *currentLabel=nil;
    NSInteger labeltype=0;
    switch (textField.tag) {
        case textFieldTypeFirstname:
            labeltype=labelTypeFirstname;
            break;
        case textFieldTypeLastname:
            labeltype=labelTypeLastname;
            break;
        case textFieldTypeLogin:
            labeltype=labelTypeLogin;
            break;
        case textFieldTypePassword:
            labeltype=labelTypePassword;
            break;
        case textFieldTypeAge:
            labeltype=labelTypeAge;
            break;
        case textFieldTypePhone:
            labeltype=labelTypePhone;
            break;
        case textFieldTypeMail:
            labeltype=labelTypeMail;
            break;
            
        default:
            break;
    }
    
    for (UILabel *obj in self.collectionLabels){
        if (obj.tag==labeltype) {
            currentLabel=obj;
        }
    }
    
    return currentLabel;

}
@end
