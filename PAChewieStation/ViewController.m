//
//  ViewController.m
//  PAChewieStation
//
//  Created by hotice0 on 2019/7/8.
//  Copyright © 2019 hotice0. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize socket = _socket;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Init socket
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)connect:(id)sender {
    if (_socket.isConnected) {
        [_socket disconnect];
    } else {
        NSString * strAddr = self.textFieldAddr.stringValue;
        NSInteger iPort = self.textFieldPort.integerValue;
        [self.textFieldAddr setEnabled:false];
        [self.textFieldPort setEnabled:false];
        [self.btnConnect setTitle:@"connecting..."];
        [self.btnConnect setEnabled:false];
        [_socket connectToHost:strAddr onPort:iPort withTimeout:3 error:nil];
    }
}


- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port;
{
    [self.textFieldAddr setEnabled:false];
    [self.textFieldPort setEnabled:false];
    [self.btnConnect setEnabled:true];
    [self.btnConnect setTitle:@"disconnect"];
    // set status light to green
    [self.discreteLevelIndicatorConnectionStatus setCriticalFillColor:NSColor.greenColor];
    NSLog(@"[Client] Connected to %@:%hu", host, port);
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)socket withError:(NSError *)error;
{
    [self.textFieldAddr setEnabled:true];
    [self.textFieldPort setEnabled:true];
    [self.btnConnect setEnabled:true];
    [self.btnConnect setTitle:@"connect"];
    // set status light to rad
    [self.discreteLevelIndicatorConnectionStatus setCriticalFillColor:NSColor.redColor];
    NSLog(@"[Client] Closed connection: %@", error);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
{
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"[Client] Received: %@", text);
    
//    text = [text stringByAppendingString:@"\n"];
//    NSAttributedString *string = [[NSAttributedString alloc] initWithString:text];
//    NSTextStorage *storage = self.outputView.textStorage;
    
//    [storage beginEditing];
//    [storage appendAttributedString:string];
//    [storage endEditing];
    
    [sock readDataWithTimeout:-1 tag:0];
}

/*
 read config from PAChewie
 */
- (IBAction)btnReadConfig:(id)sender {
    
    [_socket writeData:<#(nonnull NSData *)#> withTimeout:<#(NSTimeInterval)#> tag:<#(long)#>
}

- (IBAction)btnSaveConfig:(id)sender {
}
@end
