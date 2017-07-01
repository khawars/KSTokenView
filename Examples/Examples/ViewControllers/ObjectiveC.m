//
//  ObjectiveC.m
//  Examples
//
//  Created by Khawar Shahzad on 01/01/2015.
//  Copyright (c) 2015 Khawar Shahzad. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ObjectiveC.h"
#import "Examples-Swift.h"
#import "DBCountry.h"

@interface ObjectiveC () <KSTokenViewDelegate> {
    NSString *requestURLString;
}
@property (strong, nonatomic) IBOutlet KSTokenView *tokenView;
@end

@implementation ObjectiveC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tokenView.delegate = self;
    self.tokenView.placeholder = @"Type to search";
    self.tokenView.promptText = @"Countries: ";
    self.tokenView.descriptionText = @"Countries";
    self.tokenView.separatorText = @", ";
    self.tokenView.activityIndicatorColor = [UIColor redColor];
    [self.view addSubview:self.tokenView];
    requestURLString = @"http://restcountries.eu/rest/v1/name/";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)tokenView:(KSTokenView *)tokenView performSearchWithString:(NSString *)string completion:(void (^)(NSArray *))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *requestURL = [NSString stringWithFormat:@"%@%@", requestURLString, string];
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:requestURL]
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (error == nil) {
                        NSError *errorJSON;
                        NSArray *countries = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJSON];
                        NSMutableArray *results = [[NSMutableArray alloc] init];
                        if ([countries isKindOfClass:[NSArray class]]) {
                            for (int counter = 0; counter < countries.count; counter++) {
                                NSDictionary *countryDictionary = countries[counter];
                                if  (countryDictionary) {
                                    DBCountry *country = [[DBCountry alloc] initWithName:[countryDictionary valueForKey:@"name"] capital:[countryDictionary valueForKey:@"capital"] region:[countryDictionary valueForKey:@"region"]];
                                    [results addObject:country];
                                    country = nil;
                                    completion(results);
                                }
                            }
                        }
                    }
                }] resume];
    });
}

- (NSString *)tokenView:(KSTokenView *)tokenView displayTitleForObject:(id)object {
    return  ((DBCountry *)object).name;
}


- (BOOL)tokenView:(KSTokenView *)tokenView shouldAddToken:(KSToken *)token {
    NSLog(@"shouldAddToken %@", token);
    return YES;
}

- (void)tokenView:(KSTokenView *)tokenView willAddToken:(KSToken *)token {
    NSLog(@"shouldAddToken %@", token);
}

- (void)tokenView:(KSTokenView *)tokenView didAddToken:(KSToken *)token {
    NSLog(@"didAddToken %@", token);
}

- (void)tokenView:(KSTokenView *)tokenView didFailToAdd:(KSToken *)token {
    NSLog(@"didFailToAdd %@", token);
}

- (BOOL)tokenView:(KSTokenView *)tokenView shouldDeleteToken:(KSToken *)token {
    return YES;
}

- (void)tokenView:(KSTokenView *)tokenView willDeleteToken:(KSToken *)token {
    NSLog(@"willDeleteToken %@", token);
}

- (void)tokenView:(KSTokenView *)tokenView didDeleteToken:(KSToken *)token {
    NSLog(@"didDeleteToken %@", token);
}

- (void)tokenView:(KSTokenView *)tokenView didFailToDeleteToken:(KSToken *)token {
    NSLog(@"didFailToDeleteToken %@", token);
}

- (void)tokenView:(KSTokenView *)tokenView willChangeFrame:(CGRect)frame {
    NSLog(@"willChangeFrame %@", NSStringFromCGRect(frame));
}

- (void)tokenView:(KSTokenView *)tokenView didChangeFrame:(CGRect)frame {
    NSLog(@"didChangeFrame %@", NSStringFromCGRect(frame));
}

- (void)tokenView:(KSTokenView *)tokenView didSelectToken:(KSToken *)token {
    NSLog(@"didSelectToken %@", token);
}

- (void)tokenViewDidBeginEditing:(KSTokenView *)tokenView {
    NSLog(@"tokenViewDidBeginEditing %@", tokenView);
}

- (void)tokenViewDidEndEditing:(KSTokenView *)tokenView {
    NSLog(@"tokenViewDidEndEditing %@", tokenView);
}

@end
