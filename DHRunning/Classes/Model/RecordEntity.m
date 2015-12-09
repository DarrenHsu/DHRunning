//
//  RecordEntity.m
//  DHRunning
//
//  Created by skcu1805 on 2014/5/2.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "RecordEntity.h"

@implementation RecordEntity

@dynamic distance;
@dynamic recordId;
@dynamic recordName;
@dynamic createTime;
@dynamic startTime;
@dynamic endTime;
@dynamic maxSpeed;
@dynamic avgSpeed;
@dynamic points;
@dynamic rs_User;

- (NSMutableArray *) unarchivedPoints {
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.points];
}

+ (NSData *) archivedPoints:(NSMutableArray *) points {
    if (!points)
        return nil;
    else
        return [NSKeyedArchiver archivedDataWithRootObject:points];
}


@end

@implementation RecordEntity (Predicate)

+ (NSPredicate *) addPredicate:(NSPredicate *) pre recordId:(NSString *) rid {
    if (rid) {
		NSPredicate *userPre = [NSPredicate predicateWithFormat:@"recordId == %@",rid];
		if (pre)
			return [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:pre, userPre, nil]];
		else
			return userPre;
	} else
		return pre ? pre : [NSPredicate predicateWithValue:YES];
}

@end

@implementation RecordEntity (Helper)

+ (void) addRecordWithRecordId:(NSString *) rid
                    recordName:(NSString *) name
                     startTime:(NSDate *) stime
                          user:(UserEntity *) user {
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
		DBLog(@"<DB> start %@",NSStringFromSelector(_cmd));
        
        UserEntity *_user = [user MR_inContext:localContext];
        if (!_user) return;
        
        NSPredicate *pre = [self addPredicate:nil recordId:rid];
        RecordEntity *rEntity = [RecordEntity MR_findFirstWithPredicate:pre inContext:localContext];
        if (!rEntity) {
            rEntity = [RecordEntity MR_createEntityInContext:localContext];
            [rEntity setRecordId:rid];
        }
        
        [rEntity setRecordName:name];
        [rEntity setStartTime:stime];
        [rEntity setRs_User:_user];
        [rEntity setCreateTime:[NSDate date]];

        NSMutableArray *points = [NSMutableArray new];
        [rEntity setPoints:[RecordEntity archivedPoints:points]];
        
		DBLog(@"<DB> end   %@",NSStringFromSelector(_cmd));
	}];
}

+ (void) deleteRecordWithRecordId:(NSString *) rid {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
		DBLog(@"<DB> start %@",NSStringFromSelector(_cmd));
        
        NSPredicate *pre = [self addPredicate:nil recordId:rid];
        [RecordEntity MR_deleteAllMatchingPredicate:pre inContext:localContext];
        
		DBLog(@"<DB> end   %@",NSStringFromSelector(_cmd));
	}];
}

+ (void) getRecordsWithCompletion:(void(^)(NSMutableArray *results, NSUInteger count)) completion {
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
	
	[context performBlock:^{
        DBLog(@"<DB> start %@",NSStringFromSelector(_cmd));
        
        NSArray *queryArray = [RecordEntity MR_findAllSortedBy:@"createTime" ascending:NO inContext:context];
        NSMutableArray *results = [NSMutableArray arrayWithArray:queryArray];
        
		DBLog(@"<DB> end   %@",NSStringFromSelector(_cmd));
		dispatch_async(dispatch_get_main_queue(), ^{
			if (!completion) return;
			completion(results, [results count]);
		});
	}];
}

+ (RecordEntity *) getRecordWithRecordId:(NSString *) rid {
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSPredicate *pre = [self addPredicate:nil recordId:rid];
    RecordEntity *rEntity = [RecordEntity MR_findFirstWithPredicate:pre inContext:context];
    return rEntity;
}

- (void) updateWithRecordName:(NSString *) name
                      endTime:(NSDate *) etime
                     distance:(float) dis
                     maxSpeed:(float) mspeed
                     avgSpeed:(float) aspeed
                        points:(NSMutableArray *) points {
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
		DBLog(@"<DB> start %@",NSStringFromSelector(_cmd));
        
        RecordEntity *_rEntity = [self MR_inContext:localContext];
        if (_rEntity) {
            [_rEntity setRecordName:name];
            [_rEntity setEndTime:etime];
            [_rEntity setDistance:[NSNumber numberWithFloat:dis]];
            [_rEntity setMaxSpeed:[NSNumber numberWithFloat:mspeed]];
            [_rEntity setAvgSpeed:[NSNumber numberWithFloat:aspeed]];
            [_rEntity setPoints:[RecordEntity archivedPoints:points]];
        }
        
		DBLog(@"<DB> end   %@",NSStringFromSelector(_cmd));
	}];
}

- (void) deleteSelf {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
		DBLog(@"<DB> start %@",NSStringFromSelector(_cmd));
        
        RecordEntity *_rEntity = [self MR_inContext:localContext];
        if (_rEntity) {
            [_rEntity MR_deleteEntityInContext:localContext];
        }
        
		DBLog(@"<DB> end   %@",NSStringFromSelector(_cmd));
	}];
}

@end