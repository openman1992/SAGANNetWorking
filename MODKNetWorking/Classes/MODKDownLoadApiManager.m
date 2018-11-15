//
//  MODKDownLoadApiManager.m
//  MODKPet
//
//  Created by 意想不到 on 2018/7/28.
//  Copyright © 2018年 意想不到. All rights reserved.
//

#import "MODKDownLoadApiManager.h"
#import "AFNetworking.h"
#import "MODKApiProxy.h"

@interface MODKDownLoadApiManager ()

@property (nonatomic, strong) NSData *resumeData;

@property (nonatomic, strong) AFURLSessionManager *sessionManager;

@end

@implementation MODKDownLoadApiManager


#pragma mark - publick methods

- (NSURLSessionDownloadTask *)downloadDataWithUrl:(NSString *)url fileType:(MODKDownLoadApiManagerFileType)fileType fileName:(NSString *)fileName {
    NSURL *path = [self destinationUrl:url type:fileType fileName:fileName];
    __weak MODKDownLoadApiManager *weakself = self;
    NSURLSessionDownloadTask *task = nil;
    if ( [[NSFileManager defaultManager]fileExistsAtPath:path.path]) {
        // 存在直接返回
        if ([weakself.delegate respondsToSelector:@selector(managerCallApiSucess:downloadUrl:fileName:filePath:)]) {
            [weakself.delegate managerCallApiSucess:self downloadUrl:url fileName:fileName filePath:path];
        }
    } else {
       // 开始下载 1.判断是否存在resumedata 2.判断resumedata的临时文件是否存在 3.开始下载
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        request.HTTPMethod = @"POST";
       task = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            if ([weakself.delegate respondsToSelector:@selector(managerCallProgress:downloadUrl:fileName:progress:)]) {
                [weakself.delegate managerCallProgress:self downloadUrl:url fileName:fileName progress:downloadProgress];
            }
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return path;
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                if ([weakself.delegate respondsToSelector:@selector(managerCallApiFail:downloadUrl:fileName:error:)]) {
                    [weakself.delegate managerCallApiFail:self downloadUrl:url fileName:fileName error:error];
                }
            } else {
                if ([weakself.delegate respondsToSelector:@selector(managerCallApiSucess:downloadUrl:fileName:filePath:)]) {
                    [weakself.delegate managerCallApiSucess:self downloadUrl:url fileName:fileName filePath:filePath];
                }
            }
        }];
        [task resume];
    }
    return task;
}

- (void)cancelAllDownLoadTask {
    for (NSURLSessionDownloadTask *task in self.sessionManager.downloadTasks) {
        [task cancel];
    }
}

#pragma mark - private methods

- (NSURL *)destinationUrl:(NSString *)url type:(MODKDownLoadApiManagerFileType)type fileName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    documentsDir = [documentsDir stringByAppendingString:[NSString stringWithFormat:@"/%@",[self file:type]]];
    // 如果没有文件夹 则创建一个
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDir isDirectory:NULL]) {
         [[NSFileManager defaultManager] createDirectoryAtPath:documentsDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 取url的后缀名
    NSURL *urlss = [NSURL URLWithString:url];
    NSArray *houzuiArray = [urlss.path componentsSeparatedByString:@"."];
    NSString *houzui = nil;
    if (houzuiArray.count == 2) {
        houzui = houzuiArray[1];
    }
    if (type == MODKDownLoadApiManagerFileTypeMusic&&houzui == nil) {
        houzui = @"mp3";
    }
    NSString *path = houzuiArray[0];
    if (!fileName) {
        fileName = [path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    }
    if (houzui) {
        documentsDir = [documentsDir stringByAppendingString:[NSString stringWithFormat:@"/%@.%@",fileName,houzui]];
    } else {
        documentsDir = [documentsDir stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    }
    documentsDir = [NSString stringWithFormat:@"file://%@",documentsDir];
    return [NSURL URLWithString:documentsDir];
}

- (NSURL *)destinationResumeWithUrl:(NSString *)url type:(MODKDownLoadApiManagerFileType)type fileName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    documentsDir = [documentsDir stringByAppendingString:[NSString stringWithFormat:@"/%@",[self resumeFileName:type]]];
    // 如果没有文件夹 则创建一个
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDir isDirectory:NULL]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // 取url的后缀名
    NSURL *urlss = [NSURL URLWithString:url];
    NSArray *houzuiArray = [urlss.path componentsSeparatedByString:@"."];
    NSString *houzui = nil;
    if (houzuiArray.count == 2) {
        houzui = houzuiArray[1];
    }
    NSString *path = houzuiArray[0];
    if (!fileName) {
        fileName = [path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    }
    if (houzui) {
        documentsDir = [documentsDir stringByAppendingString:[NSString stringWithFormat:@"/%@.%@",fileName,houzui]];
    } else {
        documentsDir = [documentsDir stringByAppendingString:[NSString stringWithFormat:@"/%@",fileName]];
    }
    documentsDir = [NSString stringWithFormat:@"file://%@",documentsDir];
    return [NSURL URLWithString:documentsDir];
}

- (NSString *)file:(MODKDownLoadApiManagerFileType)type {
    switch (type) {
        case MODKDownLoadApiManagerFileTypeMusic:
            return @"music";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString *)resumeFileName:(MODKDownLoadApiManagerFileType)type {
    switch (type) {
        case MODKDownLoadApiManagerFileTypeMusic:
            return @"musicResume";
            break;
        default:
            break;
    }
    return @"";
}

#pragma mark - setter and getter

- (AFURLSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [[AFURLSessionManager alloc]init];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _sessionManager;
}

@end
