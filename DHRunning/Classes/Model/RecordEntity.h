//
//  RecordEntity.h
//  DHRunning
//
//  Created by skcu1805 on 2014/5/2.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreData+MagicalRecord.h"
#import "DHLocation.h"
#import "UserEntity.h"

@class  UserEntity;

@interface RecordEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * recordId;
@property (nonatomic, retain) NSString * recordName;
@property (nonatomic, retain) NSDate * createTime;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * maxSpeed;
@property (nonatomic, retain) NSNumber * avgSpeed;
@property (nonatomic, retain) NSData * points;
@property (nonatomic, retain) UserEntity *rs_User;

- (NSMutableArray *) unarchivedPoints;
+ (NSData *) archivedPoints:(NSMutableArray *) points;
    
@end

@interface RecordEntity (Predicate)

+ (NSPredicate *) addPredicate:(NSPredicate *) pre recordId:(NSString *) rid;

@end

@interface RecordEntity (Helper)

+ (void) addRecordWithRecordId:(NSString *) rid
                    recordName:(NSString *) name
                     startTime:(NSDate *) stime
                          user:(UserEntity *) user;

+ (void) deleteRecordWithRecordId:(NSString *) rid;
+ (void) getRecordsWithCompletion:(void(^)(NSMutableArray *results, NSUInteger count)) completion;
+ (RecordEntity *) getRecordWithRecordId:(NSString *) rid;

- (void) updateWithRecordName:(NSString *) name
                      endTime:(NSDate *) etime
                     distance:(float) dis
                     maxSpeed:(float) mspeed
                     avgSpeed:(float) aspeed
                       points:(NSMutableArray *) points;

- (void) deleteSelf;

@end