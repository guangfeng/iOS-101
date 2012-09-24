//
//  SCViewController.h
//  nima
//
//  Created by Seimei on 12-9-25.
//  Copyright (c) 2012年 Seimei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate,NSStreamDelegate>
{
    int opened;
}
@property (retain, nonatomic) NSMutableData *outQueue;

@property (retain, nonatomic) IBOutlet UITextView *output;
@property (retain, nonatomic) IBOutlet UITextField *input;
@property (retain, nonatomic) NSInputStream *inStream;
@property (retain, nonatomic) NSOutputStream *outStream;
- (IBAction)submit:(id)sender;
- (IBAction)haveBegan:(id)sender;

@end
