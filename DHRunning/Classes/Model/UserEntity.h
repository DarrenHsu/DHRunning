//
//  UserEntity.h
//  DHRunning
//
//  Created by skcu1805 on 2014/5/2.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreData+MagicalRecord.h"

@class RecordEntity;

@interface UserEntity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sexy;
@property (nonatomic, retain) NSDate * borthday;
@property (nonatomic, retain) NSNumber * weight;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSSet *rs_Record;

@end

@interface UserEntity (Predicate)

+ (NSPredicate *) addPredicate:(NSPredicate *) pre name:(NSString *) name;

@end

@interface UserEntity (Helper)

+ (void) addDefaultUser;

+ (void) addUserWithName:(NSString *) name
                    sexy:(BOOL) sexy
                borthday:(NSDate *) bday
                  weight:(float) weight
                  height:(float) height;

+ (UserEntity *) getCurrentUser;

- (void) updateUserWith:(BOOL) sexy
               borthday:(NSDate *) bday
                 weight:(float) weight
                 height:(float) height;

@end

@interface UserEntity (CoreDataGeneratedAccessors)

- (void)addRs_RecordObject:(RecordEntity *)value;
- (void)removeRs_RecordObject:(RecordEntity *)value;
- (void)addRs_Record:(NSSet *)values;
- (void)removeRs_Record:(NSSet *)values;

@end

