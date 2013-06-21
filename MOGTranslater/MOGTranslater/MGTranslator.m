//
//  MGTranslator.m
//  DdadDictionaryV2
//
//  Created by Moath on 1/20/13.
//
//

#import "MGTranslator.h"
#include <math.h>
#import "HTMLParser.h"
@implementation MGTranslator
@synthesize textToBeTranslated=_textToBeTranslated,sourceLanguage=_sourceLanguage,targetLanguage=_targetLanguage,delegate;

-(id)init{
    
    
    if (self=[super init]) {
        
    }
    
    return self;  
}

-(NSString*)getLangCode:(NSString*)lang{
    
    if ([lang isEqualToString:@"Turkish"]) {
        return @"tr";
    }
    else if ([lang isEqualToString:@"Chinese"]) {
        return @"zh-CN";
    }
    else  if ([lang isEqualToString:@"Portuguese"]) {
        return @"bg";
        
    }else if([lang isEqualToString:@"dutch"]) {
        return @"nl";
        
    }
    else {
        return [lang substringToIndex:2];
    }
    
}

- (void)Translate{
    
    
         
       
        NSString *longPAir =[[NSString stringWithFormat:@"%@|%@",[self getLangCode:_sourceLanguage],[self getLangCode:_targetLanguage]]lowercaseString];
        NSString *hello =_textToBeTranslated ;
        NSString *stringUYRL=[NSString stringWithFormat: @"http://www.google.com/translate_t?hl=en&text=%@&langpair=%@",hello,longPAir];
        NSString *escapeur=[stringUYRL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL*    googleURL = [NSURL URLWithString:  escapeur  ] ;
        
        
        
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:googleURL
                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:20.0];
        // create the connection with the request
        // and start loading the data
        NSURLConnection *theConnection;
        
        theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        
        if (theConnection) {
            
            // Create the NSMutableData that will hold
            // the received data
            // receivedData is declared as a method instance elsewhere
            receivedData=[[NSMutableData data] retain];
        } else {
            // inform the user that the download could not be made
        }
        
        NSLog(@"string after formatting is %@",escapeur);
     
    
    
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
     
    [receivedData appendData:data];
  
    NSString *datastring;
    
  
    if ([_targetLanguage isEqualToString:@"Russian"]) {
        NSStringEncoding russianEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin5 );
        
        datastring = [[NSString alloc]initWithData:receivedData encoding:russianEncoding];
        
    }else
        if ([_targetLanguage isEqualToString:@"Turkish"]) {
            NSStringEncoding chineseEnc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin9);
            datastring = [[NSString alloc]initWithData:receivedData encoding:chineseEnc];
            
        }
        else if ([_targetLanguage isEqualToString:@"Chinese"]) {
            NSStringEncoding chineseEnc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingDOSChineseSimplif);
            datastring = [[NSString alloc]initWithData:receivedData encoding:chineseEnc];
            
        }
        else  if ([_targetLanguage isEqualToString:@"Portuguese"]) {
            //       NSStringEncoding chineseEnc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin6);
            NSLog(@"lang is porto");
            datastring = [[NSString alloc]initWithData:receivedData encoding:NSISOLatin1StringEncoding];
            
        }
        else if ([_targetLanguage isEqualToString:@"Arabic"]) {
            NSStringEncoding Arabicencoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatinArabic);
            datastring = [[NSString alloc]initWithData:receivedData encoding:Arabicencoding];
            
        }
        else if ([_targetLanguage isEqualToString:@"Japanese"]) {
            datastring =[[NSString alloc]initWithData:receivedData encoding:NSShiftJISStringEncoding];
            
        }else {
            datastring =[[NSString alloc]initWithData:receivedData encoding:NSASCIIStringEncoding];
            
        }
    
     
     // finding the tags and where the meaning is
    NSString *resultTag =@"id=result_box";
    NSRange startRang =[datastring rangeOfString:resultTag];
    NSString *endString =@"</span></span></div></div><div";
    NSRange EndRang=[datastring rangeOfString:endString];
    
    if (startRang.location!=NSNotFound && EndRang.location!=NSNotFound) {
        
        [self parseHTMLSource:datastring];
     }
     
}
 
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error   {
    NSLog(@"connection failed with error %@",error.description);
    
    [self.delegate MGTranslatorFailedWithError:error];
    
 }

- (void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    // do something with the data
    
    // receivedData is declared as a method instance elsewhere
    
    NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    [connection release];
    //
    [receivedData release];
    
}
-(void)parseHTMLSource:(NSString *)source{
    
    NSError *error =nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:source error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        //return;
    }
    
    HTMLNode *bodyNode = [parser body];
    
    NSArray *spanNodes = [bodyNode findChildTags:@"span"];
    
    NSString *resultText=@"";
    for (HTMLNode *spanNode in spanNodes) {
        NSLog(@"span attribut %@",[spanNode getAttributeNamed:@"id"]);
        if ( [spanNode getAttributeNamed:@"title"]  ) {
            NSLog(@"found result box");
            
            resultText =[[resultText stringByAppendingString:@"\n"]stringByAppendingString: [spanNode contents]];
            
        }
        
    }
    if(self.delegate &&[self.delegate respondsToSelector:@selector(didFinishFetchingTranslatedData:)]){
    [self.delegate didFinishFetchingTranslatedData:resultText];
    }
    
    [parser release];
    
}

@end
