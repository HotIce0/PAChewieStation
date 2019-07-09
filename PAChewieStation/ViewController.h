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

@property (weak) IBOutlet NSTextField *textFieldAngleRollKp;
@property (weak) IBOutlet NSTextField *textFieldAnglePitchKp;
@property (weak) IBOutlet NSTextField *textFieldAngleYawKp;
@property (weak) IBOutlet NSTextField *textFieldGyrosRollKp;
@property (weak) IBOutlet NSTextField *textFieldGyrosPitchKp;
@property (weak) IBOutlet NSTextField *textFieldGyrosYawKp;
@property (weak) IBOutlet NSTextField *textFieldAngleRollKi;
@property (weak) IBOutlet NSTextField *textFieldAnglePitchKi;
@property (weak) IBOutlet NSTextField *textFieldAngleYawKi;
@property (weak) IBOutlet NSTextField *textFieldGyrosRollKi;
@property (weak) IBOutlet NSTextField *textFieldGyrosPitchKi;
@property (weak) IBOutlet NSTextField *textFieldGyrosYawKi;
@property (weak) IBOutlet NSTextField *textFieldAngleRollKd;
@property (weak) IBOutlet NSTextField *textFieldAnglePitchKd;
@property (weak) IBOutlet NSTextField *textFieldAngleYawKd;
@property (weak) IBOutlet NSTextField *textFieldGyrosRollKd;
@property (weak) IBOutlet NSTextField *textFieldGyrosPitchKd;
@property (weak) IBOutlet NSTextField *textFieldGyrosYawKd;
@property (weak) IBOutlet NSTextField *textFieldAngleRollIntegralLimit;
@property (weak) IBOutlet NSTextField *textFieldAnglePitchIntegralLimit;
@property (weak) IBOutlet NSTextField *textFieldAngleYawIntegralLimit;
@property (weak) IBOutlet NSTextField *textFieldGyrosRollIntegralLimit;
@property (weak) IBOutlet NSTextField *textFieldGyrosPitchIntegralLimit;
@property (weak) IBOutlet NSTextField *textFieldGyrosYawIntegralLimit;
@property (weak) IBOutlet NSTextField *textFieldAngleRollOutputLimit;
@property (weak) IBOutlet NSTextField *textFieldAnglePitchOutputLimit;
@property (weak) IBOutlet NSTextField *textFieldAngleYawOutputLimit;
@property (weak) IBOutlet NSTextField *textFieldGyrosRollOutputLimit;
@property (weak) IBOutlet NSTextField *textFieldGyrosPitchOutputLimit;
@property (weak) IBOutlet NSTextField *textFieldGyrosYawOutputLimit;


- (IBAction)btnClickReadCurrentPIDConfig:(id)sender;
- (IBAction)btnClickWriteCurrentPIDConfig:(id)sender;
- (IBAction)btnClickReadFlashPIDConfig:(id)sender;
- (IBAction)btnClickWriteFlashPIDConfig:(id)sender;

@property (readonly) GCDAsyncSocket *socket;
@end

