//
//  ViewController.h
//  PAChewieStation
//
//  Created by hotice0 on 2019/7/8.
//  Copyright © 2019 hotice0. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GCDAsyncSocket.h"

@interface ViewController : NSViewController <GCDAsyncSocketDelegate>
@property (weak) IBOutlet NSLevelIndicator *discreteLevelIndicatorConnectionStatus;
@property (weak) IBOutlet NSTextField *textFieldAddr;
@property (weak) IBOutlet NSTextField *textFieldPort;
@property (weak) IBOutlet NSButton *btnConnect;
- (IBAction)btnReadConfig:(id)sender;
- (IBAction)btnSaveConfig:(id)sender;

@property (readonly) GCDAsyncSocket *socket;
@end

