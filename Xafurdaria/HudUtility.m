//
//  HudUtility.m
//  Inmet
//
//  Created by Presidência on 09/04/13.
//  Copyright (c) 2013 Cogerh/Funceme. All rights reserved.
//

#import "HudUtility.h"

@implementation HudUtility

-(void)setHUDPropertiesWithView:(UIView*)view{
    self.HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:self.HUD];
}

-(void)showLoadingHUD{
    self.HUD.mode = MBProgressHUDAnimationFade;
    self.HUD.labelText = @"Carregando...";
    self.HUD.detailsLabelText = @"";
    [self.HUD show:YES];
}

-(void)showDoneHuding{
    self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    // Set custom view mode
    self.HUD.mode = MBProgressHUDModeCustomView;
    
    self.HUD.labelText = @"Concluído";
    self.HUD.detailsLabelText = @"";
    
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:2];
}

-(void)showCustomHudWithMessage:(NSString*)message{
    self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete1x.png"]];
    
    // Set custom view mode
    self.HUD.mode = MBProgressHUDModeCustomView;
    
    self.HUD.labelText = message;
    self.HUD.detailsLabelText = @"";
    
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:2];
}

-(void)showCustomHudWithMessage:(NSString*)message andDetailsMessage:(NSString*)detailsMessage{
    self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete1x.png"]];
    
    // Set custom view mode
    self.HUD.mode = MBProgressHUDModeCustomView;
    
    self.HUD.labelText = message;
    self.HUD.detailsLabelText = detailsMessage;
    
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:3];
}

-(void)showDefaultErrorMessage{
    self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"delete1x.png"]];
    
    // Set custom view mode
    self.HUD.mode = MBProgressHUDModeCustomView;
    
    self.HUD.labelText = @"Desculpe!";
    self.HUD.detailsLabelText = @"Verifique sua conexão ou tente novamente mais tarde";
    
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:3];
}

@end
