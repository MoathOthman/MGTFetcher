//
//  MGTranslator.h
//  DdadDictionaryV2
//
//  Created by Moath on 1/20/13.
//
//

#import <Foundation/Foundation.h>
@protocol MGTranslateDelegate<NSObject>
-(void)didFinishFetchingTranslatedData:(NSString*)resultString;
-(void)MGTranslatorFailedWithError:(NSError*)error;
@end
    
@interface MGTranslator : NSObject{
    id <MGTranslateDelegate>delegate;
    NSMutableData *receivedData;
}

@property (nonatomic,assign)id <MGTranslateDelegate>delegate;

@property (nonatomic,assign)NSString *targetLanguage;
@property (nonatomic,assign)NSString *sourceLanguage;
@property (nonatomic,assign)NSString *textToBeTranslated;


-(NSString*)getLangCode:(NSString*)lang;
-(void)parseHTMLSource:(NSString *)source;
- (void)Translate;
@end
