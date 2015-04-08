//
//  Change_Extension.m
//  Change Extension
//
//  Created by Darren Ford on 8/04/2015.
//  Copyright (c) 2015 Darren Ford. All rights reserved.
//

#import "Change_Extension.h"

#import <OSAKit/OSAKit.h>

@interface Change_Extension ()

@property (weak) IBOutlet NSTextField *changedExtension;
@property (weak) IBOutlet NSButton *leaveOriginal;

@end

#define FILE_URL(file) [NSURL fileURLWithPath:file]

@implementation Change_Extension

- (BOOL)validateInputs:(NSArray*)files newExtension:(NSString*)newExtension error:(NSDictionary **)errorInfo
{
    for (NSString* file in files)
    {
        // Check to see if the new path already exists.  If so, then its an error
        if ([[NSFileManager defaultManager] fileExistsAtPath:file] == NO)
        {
            NSArray *objsArray = @[@(errOSASystemError),
                                   [NSString stringWithFormat:@"ERROR: File '%@' doesn't exist", file]];
            NSArray *keysArray = @[OSAScriptErrorNumber, OSAScriptErrorMessage];
            *errorInfo = [NSDictionary dictionaryWithObjects:objsArray forKeys:keysArray];
            return NO;
        }

        // Check to see if the new path already exists.  If so, then its an error
        NSString *newPath = [[file stringByDeletingPathExtension] stringByAppendingPathExtension:newExtension];
        if ([[NSFileManager defaultManager] fileExistsAtPath:newPath])
        {
            NSArray *objsArray = @[@(errOSASystemError),
                                   [NSString stringWithFormat:@"ERROR: File '%@' already exists", newPath]];
            NSArray *keysArray = @[OSAScriptErrorNumber, OSAScriptErrorMessage];
            *errorInfo = [NSDictionary dictionaryWithObjects:objsArray forKeys:keysArray];
            return NO;
        }
    }

    return YES;
}

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo
{
    // Add your code here, returning the data to be passed to the next action.
    NSString* newExtension = [_changedExtension stringValue];
    if ([newExtension length] == 0)
    {
        NSArray *objsArray = @[@(errOSASystemError),
                               [NSString stringWithFormat:@"ERROR: No extension specified"]];
        NSArray *keysArray = @[OSAScriptErrorNumber, OSAScriptErrorMessage];
        *errorInfo = [NSDictionary dictionaryWithObjects:objsArray forKeys:keysArray];
        return nil;
    }

    if ([self validateInputs:input newExtension:newExtension error:errorInfo] == NO)
    {
        return nil;
    }

    // If we've got here, then we should be safe. Go ahead and do it.
    NSMutableArray* results = [NSMutableArray arrayWithCapacity:[input count]];

    for (NSString* file in input)
    {
        NSError* error = nil;
        NSString *newPath = [[file stringByDeletingPathExtension] stringByAppendingPathExtension:newExtension];

        if ([_leaveOriginal state] == NSOffState)
        {
            [[NSFileManager defaultManager] moveItemAtURL:FILE_URL(file)
                                                    toURL:FILE_URL(newPath)
                                                    error:&error];
        }
        else
        {
            [[NSFileManager defaultManager] copyItemAtURL:FILE_URL(file)
                                                    toURL:FILE_URL(newPath)
                                                    error:&error];
        }
        
        if (error == nil)
        {
            [results addObject:newPath];
        }
    }
    
    return results;
}

@end
