//
//  MODKDownLoadApiManager.h
//  MODKPet
//
//  Created by 意想不到 on 2018/7/28.
//  Copyright © 2018年 意想不到. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MODKDownLoadApiManager;

typedef NS_ENUM (NSUInteger, MODKDownLoadApiManagerFileType){
    MODKDownLoadApiManagerFileTypeMusic // 音乐文件夹
};

// 文件下载类 会进行断点下载

@protocol MODKDownLoadApiManagerDelegate <NSObject>


/*
 * 下载成功
 * downloadUrl 下载的url
 * filePath 成功后的路径
 * filename 文件名
 */
- (void)managerCallApiSucess:(MODKDownLoadApiManager *)manager downloadUrl:(NSString *)downloadUrl fileName:(NSString *)filename filePath:(NSURL *)filePath;

- (void)managerCallApiFail:(MODKDownLoadApiManager *)manager downloadUrl:(NSString *)downloadUrl fileName:(NSString *)filename error:(NSError *)error;

- (void)managerCallProgress:(MODKDownLoadApiManager *)manager downloadUrl:(NSString *)downloadUrl fileName:(NSString *)filename progress:(NSProgress *)progress;


@end

@interface MODKDownLoadApiManager : NSObject

@property (nonatomic, weak) id <MODKDownLoadApiManagerDelegate> delegate;


/*
 * 1.文件下载 会先去检测 磁盘是否存在该文件 如果存在直接返回该文件的路径
 * 2. fileType 文件夹类型
 * 3. fileName 文件名 如果为nil 则为url的path路径（去掉后缀 以及“/”）
 *
 */

- (NSURLSessionDownloadTask *)downloadDataWithUrl:(NSString *)url fileType:(MODKDownLoadApiManagerFileType)fileType fileName:(NSString *)fileName;

- (void)cancelAllDownLoadTask;

@end
