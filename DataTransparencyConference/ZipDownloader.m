//
//  ZipDownloader.m
//  DataTransparencyConference
//
//  Created by Weien on 8/5/13.
//  Copyright (c) 2013 Weien. All rights reserved.
//

#import "ZipDownloader.h"
#import "SSZipArchive.h"

@implementation ZipDownloader

+ (void) downloadZipAtURL:(NSURL*)url WithCompletion:(void (^)(void))completion {
//    NSURL* fileURL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/8902155/_site.zip"];
    
    dispatch_async(dispatch_queue_create("_site downloader", NULL), ^{
        NSError* error = nil;
        id data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
                NSLog(@"Failure to download zip file: %@", error);
            
            //get Application Support directory
            NSString *appSupportDir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
            
            // ensure this dir exists, from http://stackoverflow.com/a/12114488/2284713
            NSFileManager *manager = [NSFileManager defaultManager];
            if(![manager fileExistsAtPath:appSupportDir]) {
                __autoreleasing NSError *error;
                BOOL ret = [manager createDirectoryAtPath:appSupportDir withIntermediateDirectories:NO attributes:nil error:&error];
                if(!ret) {
                    NSLog(@"Failed to create appSupportDir: %@", error);
                    exit(0);
                }

                //we'll just addSkipBackupAttribute to the whole appSupportDir -- shouldn't have to do this more than at this point
                if ([self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:appSupportDir isDirectory:NO]])
                    NSLog(@"Successfully added SkipBackupAttribute to %@", appSupportDir);
            }
            
            //write our data to the file!
            NSString* completeFilePath = [appSupportDir stringByAppendingPathComponent:@"_site.zip"];
            NSError* writeError = nil;
            if (![data writeToFile:completeFilePath options:NSDataWritingAtomic error:&writeError]) {
                NSLog(@"Failure to write to file: %@", writeError);
            }
            else {
                // Unzipping
                [SSZipArchive unzipFileAtPath:completeFilePath toDestination:appSupportDir];
            }
            completion();
        });
    });
}

//from http://developer.apple.com/library/ios/#qa/qa1719/_index.html
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}


@end
