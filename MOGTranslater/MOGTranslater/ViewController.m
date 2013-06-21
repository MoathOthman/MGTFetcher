//
//  ViewController.m
//  MOGTranslater
//
//  Created by moath othman on 6/21/13.
//  Copyright (c) 2013 moath othman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
static bool pickerButtonTouched=false;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SupportedLanguages =[[NSMutableArray alloc]initWithObjects:@"Arabic",@"English",@"Italian",@"French",@"Espanol",@"deutsch",@"dutch",@"Latin",@"Turkish", @"Chinese",@"Japanese",@"Russian",  nil];
    
    sourceLanguage =@"English";
    targetLanguage =@"Arabic";
    
    
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)pickLanguage:(id)sender {
    
    [self.sourceTextView resignFirstResponder];
    
    if(!pickerButtonTouched){
             langPicker =[[UIPickerView alloc]initWithFrame:CGRectMake(0, 100, 320, 216)];
            
                langPicker.layer.borderColor=[UIColor blackColor].CGColor;
        langPicker.layer.borderWidth=20;
        langPicker.layer.shadowColor=[UIColor blackColor].CGColor;
        langPicker.layer.shadowOffset=CGSizeMake(0,1);
        langPicker.layer.shadowOpacity=.8;
        langPicker.layer.shadowRadius=10;
        langPicker.delegate=self;
        langPicker.dataSource=self;
        langPicker.alpha=1;
        
        langPicker.showsSelectionIndicator=YES;
        [self.view addSubview:langPicker];
        pickerButtonTouched=true;
        [self performSelector:@selector(attachPopUpAnimation)];
        
    }else {
        [langPicker removeFromSuperview];
        pickerButtonTouched=false;
        [self performSelector:@selector(hideUploadView:) withObject:(id)sender];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    [self.TargetTextView resignFirstResponder];
    [self.sourceTextView resignFirstResponder];
    
    [langPicker removeFromSuperview];
    pickerButtonTouched=false;
    
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self.sourceTextView resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark PickerViewDelegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [SupportedLanguages count];;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [SupportedLanguages objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component ==0)
    {
        sourceLanguage =[SupportedLanguages objectAtIndex:row];
        
    }else if (component ==1) {
        targetLanguage =[SupportedLanguages objectAtIndex:row];
        
    }
    self.sourceAndTarget.title =[NSString stringWithFormat:@"%@->%@",sourceLanguage,targetLanguage];
}


- (IBAction)Translate:(UIButton *)sender {
    MGTranslator *_mgTranslator =[MGTranslator new];
    [_mgTranslator setSourceLanguage:sourceLanguage];
    [_mgTranslator setTargetLanguage:targetLanguage];
    [_mgTranslator setTextToBeTranslated:self.sourceTextView.text];
    _mgTranslator.delegate=self;
    [_mgTranslator Translate    ];
}

#pragma mark MGTranslator Delegate
-(void)didFinishFetchingTranslatedData:(NSString *)resultString{
    
    NSLog(@"MGTRanslator did finish fetching result");
    self.TargetTextView.text=resultString;
     
}
-(void)MGTranslatorFailedWithError:(NSError *)error{
     
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"error" message:@"problem occured while fetching the data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}

- (void) attachPopUpAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    langPicker.alpha=1;
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(1.1, 1.1, 1);
    CATransform3D scale4=  CATransform3DMakeScale(.9, .9, 1);
    CATransform3D scale5 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            [NSValue valueWithCATransform3D:scale5],
                            nil];
    
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.4],
                           [NSNumber numberWithFloat:0.7],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .25;
    
    [langPicker.layer addAnimation:animation forKey:@"popup"];
    
    
}
- (IBAction)hideUploadView:(id)sender  {
    
    [UIView animateWithDuration:1.25 animations:^{
        langPicker.transform=CGAffineTransformScale(langPicker.transform, 0.1, 0.1);
        langPicker.alpha=0;
        [langPicker setFrame:CGRectMake(300, 10, 10, 10)];
    } completion:^(BOOL finished) {
        
        
    }];
    
    
    
}


@end
