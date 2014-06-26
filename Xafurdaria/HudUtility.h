//
//  HudUtility.h
//  Inmet
//
//  Created by Presidência on 09/04/13.
//  Copyright (c) 2013 Cogerh/Funceme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"


@interface HudUtility : NSObject <MBProgressHUDDelegate>{
    
}

@property (nonatomic,strong) MBProgressHUD* HUD;

-(void)setHUDPropertiesWithView:(UIView*)view;
-(void)showLoadingHUD;
-(void)showDoneHuding;
-(void)showCustomHudWithMessage:(NSString*)message;
-(void)showCustomHudWithMessage:(NSString*)message andDetailsMessage:(NSString*)detailsMessage;
-(void)showDefaultErrorMessage;

@end
