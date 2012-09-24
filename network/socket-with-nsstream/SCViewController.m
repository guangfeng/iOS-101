//
//  SCViewController.m
//  nima
//
//  Created by Seimei on 12-9-25.
//  Copyright (c) 2012年 Seimei. All rights reserved.
//

#import "SCViewController.h"

@interface SCViewController ()

@end

@implementation SCViewController
@synthesize input = _input, output = _output;
@synthesize inStream = _inStream,outStream = _outStream, outQueue = _outQueue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        opened = 0;
        CFReadStreamRef *readStream;
        CFWriteStreamRef *writeStream;
        CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef *)@"127.0.0.1", 9090, &readStream, &writeStream);
        
        self.inStream = (__bridge_transfer NSInputStream *) readStream;
        self.outStream = (__bridge_transfer NSInputStream *) writeStream;
        
        [self.inStream setDelegate:self];
        [self.outStream setDelegate:self];
        
        [self.inStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [self.inStream open];
        [self.outStream open];
        
        
        self.outQueue = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.    
    self.output.text = [self.output.text stringByAppendingString:@"正在连接服务器...\n\n"];
    
    
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    NSLog(@"stream:handleEvent: is invoked...");
    
    switch (eventCode) {
        case NSStreamEventHasSpaceAvailable:
        {
            if (aStream == self.outStream) {
                NSLog(@"NSStreamEventHasSpaceAvailable\n");
                [self.input setText:@""];
            }
            
            
        }
            break;
        
        case NSStreamEventHasBytesAvailable:
        {
            if (aStream == self.inStream) {
                uint8_t buffer[1024];
                uint8_t len = 0;
                
                len = [self.inStream read:buffer maxLength:1204];
                NSData *_data = [NSData dataWithBytes:buffer length:len ];
                NSLog([NSString stringWithUTF8String:[_data bytes]]);
                self.output.text = [self.output.text stringByAppendingFormat:@"服务器:%@\n", [NSString stringWithUTF8String:[_data bytes]]];
            }
        }
            break;
        
        case NSStreamEventOpenCompleted:
        {
            if (!opened) {
                self.output.text = @"SYS: 服务器端口已经打开...\n";
            }
        }
            break;
            
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_output release];
    [_input release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setOutput:nil];
    [self setInput:nil];
    [super viewDidUnload];
}
- (IBAction)submit:(id)sender {
    if (sender == self.input)
    {
        if([self.input.text length])
        {
            NSData *_data = [self.input.text dataUsingEncoding:NSUTF8StringEncoding];
            [self.outStream write:[_data bytes] maxLength:[_data length]];
            [self.input resignFirstResponder];
            self.output.text = [self.output.text stringByAppendingFormat:@"客户端:%@\n", self.input.text];
                        
        }
    }


}

@end
