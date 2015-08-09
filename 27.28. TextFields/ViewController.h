//
//  ViewController.h
//  27.28. TextFields
//
//  Created by Admin on 09.08.15.
//  Copyright (c) 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, textFieldType){
    textFieldTypeFirstname=10,
    textFieldTypeLastname,
    textFieldTypeLogin,
    textFieldTypePassword,
    textFieldTypeAge,
    textFieldTypePhone,
    textFieldTypeMail
};

typedef NS_ENUM(NSInteger, labelType){
    labelTypeFirstname=20,
    labelTypeLastname,
    labelTypeLogin,
    labelTypePassword,
    labelTypeAge,
    labelTypePhone,
    labelTypeMail
};
@interface ViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *collectionTextFields;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *collectionLabels;


@end

