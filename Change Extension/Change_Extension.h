//
//  Change_Extension.h
//  Change Extension
//
//  Created by Darren Ford on 8/04/2015.
//  Copyright (c) 2015 Darren Ford. All rights reserved.
//

#import <Automator/AMBundleAction.h>

@interface Change_Extension : AMBundleAction

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end
