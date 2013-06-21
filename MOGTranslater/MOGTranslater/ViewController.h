//
//  ViewController.h
//  MOGTranslater
//
//  Created by moath othman on 6/21/13.
//  Copyright (c) 2013 moath othman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MGTranslator.h"
@interface ViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,MGTranslateDelegate>{
    // pickerView
    NSMutableArray *SupportedLanguages;
    NSString *sourceLanguage;
    NSString *targetLanguage;
    IBOutlet UIPickerView *langPicker;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sourceAndTarget;

@property (weak, nonatomic) IBOutlet UITextView *sourceTextView;
@property (weak, nonatomic) IBOutlet UITextView *TargetTextView;
@property (weak, nonatomic) IBOutlet UIButton *translateButton;
- (IBAction)Translate:(UIButton *)sender;

@end
