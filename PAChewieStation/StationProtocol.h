//
//  StationProtocol.h
//  PAChewieStation
//
//  Created by hotice0 on 2019/7/9.
//  Copyright © 2019 hotice0. All rights reserved.
//

#ifndef StationProtocol_h
#define StationProtocol_h

#define SP_CREATE_NSDATA_REQUSET_PROTOCOL(action, param) create_request_protocol(@action, param)
NSMutableData* create_request_protocol(id action, id param)
{
    NSMutableData *mutableData = [[NSMutableData alloc]initWithData:[NSJSONSerialization dataWithJSONObject:@{@"action": action, @"param": param} options:kNilOptions error:nil]];
    [mutableData appendData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    return mutableData;
}

// PID CONFIG READ && WRITE OPERATION
#define SP_READ_CURRENT_PID_CONFIG_ACTION 0
#define SP_READ_CURRENT_PID_CONFIG_PARAM @""

#define SP_WRITE_CURRENT_PID_CONFIG_ACTION 1

#define SP_READ_FLASH_PID_CONFIG_ACTION 2
#define SP_READ_FLASH_PID_CONFIG_PARAM @""

#define SP_WRITE_FLASH_PID_CONFIG_ACTION 3




#endif /* StationProtocol_h */
