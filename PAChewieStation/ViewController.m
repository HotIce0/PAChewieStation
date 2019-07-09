//
//  ViewController.m
//  PAChewieStation
//
//  Created by hotice0 on 2019/7/8.
//  Copyright © 2019 hotice0. All rights reserved.
//

#import "ViewController.h"
#import "StationProtocol.h"
@implementation ViewController

@synthesize socket = _socket;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Init socket
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
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
    // Parse Data to json object
    id recvData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if([recvData isKindOfClass:NSDictionary.class]) {
        [self parseProtocol:(NSDictionary *)recvData];
    } else {
        NSLog(@"The recv data fommat not correct");
    }
    
//    text = [text stringByAppendingString:@"\n"];
//    NSAttributedString *string = [[NSAttributedString alloc] initWithString:text];
//    NSTextStorage *storage = self.outputView.textStorage;
    
//    [storage beginEditing];
//    [storage appendAttributedString:string];
//    [storage endEditing];
    
    [sock readDataWithTimeout:-1 tag:0];
}

/*
 parse protocol
 */
- (void)parseProtocol:(NSDictionary *)dataDict {
    NSNumber *action = (NSNumber *)dataDict[@"action"];
    NSNumber *code = (NSNumber *)dataDict[@"code"];
    id data = dataDict[@"data"];
    NSLog(@"%@, %@, %@", action, code, data);
    switch ([action intValue]) {
        case SP_READ_CURRENT_PID_CONFIG_ACTION:{
            // Read PID config from PAChewie
            NSDictionary * pids = (NSDictionary *)data;
            NSArray *arrAngleRoll = pids[@"ANGLE_ROLL"],
            *arrAnglePitch = pids[@"ANGLE_PITCH"],
            *arrAngleYaw = pids[@"ANGLE_YAW"],
            *arrGyrosRoll = pids[@"GYROS_ROLL"],
            *arrGyrosPitch = pids[@"GYROS_PITCH"],
            *arrGyrosYaw = pids[@"GYROS_YAW"];
            // ANGLE ROLL
            self.textFieldAngleRollKp.stringValue = [NSString stringWithFormat:@"%@", arrAngleRoll[0]];
            self.textFieldAngleRollKi.stringValue = [NSString stringWithFormat:@"%@", arrAngleRoll[1]];
            self.textFieldAngleRollKd.stringValue = [NSString stringWithFormat:@"%@", arrAngleRoll[2]];
            self.textFieldAngleRollIntegralLimit.stringValue = [NSString stringWithFormat:@"%@", arrAngleRoll[3]];
            self.textFieldAngleRollOutputLimit.stringValue = [NSString stringWithFormat:@"%@", arrAngleRoll[4]];
            // ANGLE PITCH
            self.textFieldAnglePitchKp.stringValue = [NSString stringWithFormat:@"%@", arrAnglePitch[0]];
            self.textFieldAnglePitchKi.stringValue = [NSString stringWithFormat:@"%@", arrAnglePitch[1]];
            self.textFieldAnglePitchKd.stringValue = [NSString stringWithFormat:@"%@", arrAnglePitch[2]];
            self.textFieldAnglePitchIntegralLimit.stringValue = [NSString stringWithFormat:@"%@", arrAnglePitch[3]];
            self.textFieldAnglePitchOutputLimit.stringValue = [NSString stringWithFormat:@"%@", arrAnglePitch[4]];
            // ANGLE YAW
            self.textFieldAngleYawKp.stringValue = [NSString stringWithFormat:@"%@", arrAngleYaw[0]];
            self.textFieldAngleYawKi.stringValue = [NSString stringWithFormat:@"%@", arrAngleYaw[1]];
            self.textFieldAngleYawKd.stringValue = [NSString stringWithFormat:@"%@", arrAngleYaw[2]];
            self.textFieldAngleYawIntegralLimit.stringValue = [NSString stringWithFormat:@"%@", arrAngleYaw[3]];
            self.textFieldAngleYawOutputLimit.stringValue = [NSString stringWithFormat:@"%@", arrAngleYaw[4]];
            // GYROS ROLL
            self.textFieldGyrosRollKp.stringValue = [NSString stringWithFormat:@"%@", arrGyrosRoll[0]];
            self.textFieldGyrosRollKi.stringValue = [NSString stringWithFormat:@"%@", arrGyrosRoll[1]];
            self.textFieldGyrosRollKd.stringValue = [NSString stringWithFormat:@"%@", arrGyrosRoll[2]];
            self.textFieldGyrosRollIntegralLimit.stringValue = [NSString stringWithFormat:@"%@", arrGyrosRoll[3]];
            self.textFieldGyrosRollOutputLimit.stringValue = [NSString stringWithFormat:@"%@", arrGyrosRoll[4]];
            // GYROS PITCH
            self.textFieldGyrosPitchKp.stringValue = [NSString stringWithFormat:@"%@", arrGyrosPitch[0]];
            self.textFieldGyrosPitchKi.stringValue = [NSString stringWithFormat:@"%@", arrGyrosPitch[1]];
            self.textFieldGyrosPitchKd.stringValue = [NSString stringWithFormat:@"%@", arrGyrosPitch[2]];
            self.textFieldGyrosPitchIntegralLimit.stringValue = [NSString stringWithFormat:@"%@", arrGyrosPitch[3]];
            self.textFieldGyrosPitchOutputLimit.stringValue = [NSString stringWithFormat:@"%@", arrGyrosPitch[4]];
            // GYROS YAW
            self.textFieldGyrosYawKp.stringValue = [NSString stringWithFormat:@"%@", arrGyrosYaw[0]];
            self.textFieldGyrosYawKi.stringValue = [NSString stringWithFormat:@"%@", arrGyrosYaw[1]];
            self.textFieldGyrosYawKd.stringValue = [NSString stringWithFormat:@"%@", arrGyrosYaw[2]];
            self.textFieldGyrosYawIntegralLimit.stringValue = [NSString stringWithFormat:@"%@", arrGyrosYaw[3]];
            self.textFieldGyrosYawOutputLimit.stringValue = [NSString stringWithFormat:@"%@", arrGyrosYaw[4]];
            break;
        }
        default:{
            break;
        }
    }
}



/*
 read current PID config from PAChewie (Memory)
 */
- (IBAction)btnClickReadCurrentPIDConfig:(id)sender {
    if(_socket.isConnected) {
        // create protocol pkg
        NSData * request = SP_CREATE_NSDATA_REQUSET_PROTOCOL(SP_READ_CURRENT_PID_CONFIG_ACTION, SP_READ_CURRENT_PID_CONFIG_PARAM);
        NSLog(@"%@", [[NSString alloc]initWithData:request encoding:NSUTF8StringEncoding]);
        // send
        [_socket writeData:request withTimeout:-1 tag:SP_READ_CURRENT_PID_CONFIG_ACTION];
    }
}

- (NSDictionary *)dictWithPIDTextField {
    NSMutableArray * arrAngleRoll = [[NSMutableArray alloc]init],
            *arrAnglePitch = [[NSMutableArray alloc]init],
            *arrAngleYaw = [[NSMutableArray alloc]init],
            *arrGyrosRoll = [[NSMutableArray alloc]init],
            *arrGyrosPitch = [[NSMutableArray alloc]init],
            *arrGyrosYaw = [[NSMutableArray alloc]init];
    // ANGLE ROLL
    [arrAngleRoll addObject:[NSNumber numberWithFloat:self.textFieldAngleRollKp.floatValue]];
    [arrAngleRoll addObject:[NSNumber numberWithFloat:self.textFieldAngleRollKi.floatValue]];
    [arrAngleRoll addObject:[NSNumber numberWithFloat:self.textFieldAngleRollKd.floatValue]];
    [arrAngleRoll addObject:[NSNumber numberWithFloat:self.textFieldAngleRollIntegralLimit.floatValue]];
    [arrAngleRoll addObject:[NSNumber numberWithFloat:self.textFieldAngleRollOutputLimit.floatValue]];
    // ANGLE PITCH
    [arrAnglePitch addObject:[NSNumber numberWithFloat:self.textFieldAnglePitchKp.floatValue]];
    [arrAnglePitch addObject:[NSNumber numberWithFloat:self.textFieldAnglePitchKi.floatValue]];
    [arrAnglePitch addObject:[NSNumber numberWithFloat:self.textFieldAnglePitchKd.floatValue]];
    [arrAnglePitch addObject:[NSNumber numberWithFloat:self.textFieldAnglePitchIntegralLimit.floatValue]];
    [arrAnglePitch addObject:[NSNumber numberWithFloat:self.textFieldAnglePitchOutputLimit.floatValue]];
    // ANGLE PITCH
    [arrAngleYaw addObject:[NSNumber numberWithFloat:self.textFieldAnglePitchKp.floatValue]];
    [arrAngleYaw addObject:[NSNumber numberWithFloat:self.textFieldAnglePitchKi.floatValue]];
    [arrAngleYaw addObject:[NSNumber numberWithFloat:self.textFieldAnglePitchKd.floatValue]];
    [arrAngleYaw addObject:[NSNumber numberWithFloat:self.textFieldAnglePitchIntegralLimit.floatValue]];
    [arrAngleYaw addObject:[NSNumber numberWithFloat:self.textFieldAnglePitchOutputLimit.floatValue]];
    // ANGLE YAW
    [arrGyrosRoll addObject:[NSNumber numberWithFloat:self.textFieldAngleYawKp.floatValue]];
    [arrGyrosRoll addObject:[NSNumber numberWithFloat:self.textFieldAngleYawKi.floatValue]];
    [arrGyrosRoll addObject:[NSNumber numberWithFloat:self.textFieldAngleYawKd.floatValue]];
    [arrGyrosRoll addObject:[NSNumber numberWithFloat:self.textFieldAngleYawIntegralLimit.floatValue]];
    [arrGyrosRoll addObject:[NSNumber numberWithFloat:self.textFieldAngleYawOutputLimit.floatValue]];
    // GYROS ROLL
    [arrGyrosPitch addObject:[NSNumber numberWithFloat:self.textFieldGyrosRollKp.floatValue]];
    [arrGyrosPitch addObject:[NSNumber numberWithFloat:self.textFieldGyrosRollKi.floatValue]];
    [arrGyrosPitch addObject:[NSNumber numberWithFloat:self.textFieldGyrosRollKd.floatValue]];
    [arrGyrosPitch addObject:[NSNumber numberWithFloat:self.textFieldGyrosRollIntegralLimit.floatValue]];
    [arrGyrosPitch addObject:[NSNumber numberWithFloat:self.textFieldGyrosRollOutputLimit.floatValue]];
    // GYROS PITCH
    [arrGyrosPitch addObject:[NSNumber numberWithFloat:self.textFieldGyrosPitchKp.floatValue]];
    [arrGyrosPitch addObject:[NSNumber numberWithFloat:self.textFieldGyrosPitchKi.floatValue]];
    [arrGyrosPitch addObject:[NSNumber numberWithFloat:self.textFieldGyrosPitchKd.floatValue]];
    [arrGyrosPitch addObject:[NSNumber numberWithFloat:self.textFieldGyrosPitchIntegralLimit.floatValue]];
    [arrGyrosPitch addObject:[NSNumber numberWithFloat:self.textFieldGyrosPitchOutputLimit.floatValue]];
    // GYROS YAW
    [arrGyrosYaw addObject:[NSNumber numberWithFloat:self.textFieldGyrosYawKp.floatValue]];
    [arrGyrosYaw addObject:[NSNumber numberWithFloat:self.textFieldGyrosYawKi.floatValue]];
    [arrGyrosYaw addObject:[NSNumber numberWithFloat:self.textFieldGyrosYawKd.floatValue]];
    [arrGyrosYaw addObject:[NSNumber numberWithFloat:self.textFieldGyrosYawIntegralLimit.floatValue]];
    [arrGyrosYaw addObject:[NSNumber numberWithFloat:self.textFieldGyrosYawOutputLimit.floatValue]];
    
    NSDictionary *dictPIDs = @{
                               @"ANGLE_ROLL": arrAngleRoll,
                               @"ANGLE_PITCH": arrAnglePitch,
                               @"ANGLE_YAW": arrAngleYaw,
                               @"GYROS_ROLL": arrGyrosRoll,
                               @"GYROS_PITCH": arrGyrosPitch,
                               @"GYROS_YAW": arrGyrosYaw
                               };
    return dictPIDs;
}
/*
write current PID config to PAChewie (Memory)
 */
- (IBAction)btnClickWriteCurrentPIDConfig:(id)sender {
    if(_socket.isConnected) {
        // get pids dict from user input
        NSDictionary * dictPIDs = [self dictWithPIDTextField];
        // craete protocol
        NSData * request = SP_CREATE_NSDATA_REQUSET_PROTOCOL(SP_WRITE_CURRENT_PID_CONFIG_ACTION, dictPIDs);
        NSLog(@"%@", [[NSString alloc]initWithData:request encoding:NSUTF8StringEncoding]);
        // send
        [_socket writeData:request withTimeout:-1 tag:SP_WRITE_CURRENT_PID_CONFIG_ACTION];
    }
}

/*
 read PID config in flash from PAChewie (read config.py in FLASH)
 */
- (IBAction)btnClickReadFlashPIDConfig:(id)sender {
    if(_socket.isConnected) {
        // create protocol pkg
        NSData * request = SP_CREATE_NSDATA_REQUSET_PROTOCOL(SP_READ_FLASH_PID_CONFIG_ACTION, SP_READ_FLASH_PID_CONFIG_PARAM);
        NSLog(@"%@", [[NSString alloc]initWithData:request encoding:NSUTF8StringEncoding]);
        // send
        [_socket writeData:request withTimeout:-1 tag:SP_READ_FLASH_PID_CONFIG_ACTION];
    }
}
/*
 write PID config to PAChewie (to alert config.py in FLASH)
 */
- (IBAction)btnClickWriteFlashPIDConfig:(id)sender {
    if(_socket.isConnected) {
        // get pids dict from user input
        NSDictionary * dictPIDs = [self dictWithPIDTextField];
        // craete protocol
        NSData * request = SP_CREATE_NSDATA_REQUSET_PROTOCOL(SP_WRITE_FLASH_PID_CONFIG_ACTION, dictPIDs);
        NSLog(@"%@", [[NSString alloc]initWithData:request encoding:NSUTF8StringEncoding]);
        // send
        [_socket writeData:request withTimeout:-1 tag:SP_WRITE_FLASH_PID_CONFIG_ACTION];
    }
}

@end
