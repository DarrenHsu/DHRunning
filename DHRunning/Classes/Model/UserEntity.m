//
//  UserEntity.m
//  DHRunning
//
//  Created by skcu1805 on 2014/5/2.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "UserEntity.h"
#import "RecordEntity.h"

@implementation UserEntity

@dynamic name;
@dynamic sexy;
@dynamic borthday;
@dynamic weight;
@dynamic height;
@dynamic rs_Record;

@end

@implementation UserEntity (Predicate)

+ (NSPredicate *) addPredicate:(NSPredicate *) pre name:(NSString *)name {
    if (name) {
		NSPredicate *userPre = [NSPredicate predicateWithFormat:@"name == %@",name];
		if (pre)
			return [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:pre, userPre, nil]];
		else
			return userPre;
	} else
		return pre ? pre : [NSPredicate predicateWithValue:YES];
}

@end

@implementation UserEntity (Helper)

+ (void) addDefaultUser {
    [self addUserWithName:@"Darren Hsu"
                     sexy:YES
                 borthday:[NSDate new]
                   weight:70
                   height:177.5];
}

+ (void) addUserWithName:(NSString *) name
                    sexy:(BOOL) sexy
                borthday:(NSDate *) bday
                  weight:(float) weight
                  height:(float) height {
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
		DBLog(@"<DB> start %@",NSStringFromSelector(_cmd));

        NSPredicate *pre = [self addPredicate:nil name:name];
        UserEntity *uEntity = [UserEntity MR_findFirstWithPredicate:pre inContext:localContext];
        if (!uEntity) {
            uEntity = [UserEntity MR_createEntityInContext:localContext];
            [uEntity setName:name];
        }
        
        [uEntity setSexy:[NSNumber numberWithBool:sexy]];
        [uEntity setBorthday:bday];
        [uEntity setWeight:[NSNumber numberWithFloat:weight]];
        [uEntity setHeight:[NSNumber numberWithFloat:height]];
        
		DBLog(@"<DB> end   %@",NSStringFromSelector(_cmd));
	}];
}

+ (UserEntity *) getCurrentUser {
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    UserEntity *uEntity = [UserEntity MR_findFirstInContext:context];
    return uEntity;
}

- (void) updateUserWith:(BOOL) sexy
               borthday:(NSDate *) bday
                 weight:(float) weight
                 height:(float) height {
    
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
		DBLog(@"<DB> start %@",NSStringFromSelector(_cmd));
        
        UserEntity *_uEntity = [self MR_inContext:localContext];
        if (_uEntity) {
            [_uEntity setSexy:[NSNumber numberWithBool:sexy]];
            [_uEntity setBorthday:bday];
            [_uEntity setWeight:[NSNumber numberWithFloat:weight]];
            [_uEntity setHeight:[NSNumber numberWithFloat:height]];
        }
        
		DBLog(@"<DB> end   %@",NSStringFromSelector(_cmd));
	}];
    
}


@end

@implementation UserEntity (CoreDataGeneratedAccessors)

- (void)addRs_RecordObject:(RecordEntity *)value{
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"rs_Record" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"rs_Record"] addObject:value];
    [self didChangeValueForKey:@"rs_Record" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
}
- (void)removeRs_RecordObject:(RecordEntity *)value{
	NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"rs_Record" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"rs_Record"] removeObject:value];
    [self didChangeValueForKey:@"rs_Record" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
}
- (void)addRs_Record:(NSSet *)values{
	[self willChangeValueForKey:@"rs_Record" withSetMutation:NSKeyValueUnionSetMutation usingObjects:values];
    [[self primitiveValueForKey:@"rs_Record"] unionSet:values];
    [self didChangeValueForKey:@"rs_Record" withSetMutation:NSKeyValueUnionSetMutation usingObjects:values];
}
- (void)removeRs_Record:(NSSet *)values{
	[self willChangeValueForKey:@"rs_Record" withSetMutation:NSKeyValueMinusSetMutation usingObjects:values];
    [[self primitiveValueForKey:@"rs_Record"] minusSet:values];
    [self didChangeValueForKey:@"rs_Record" withSetMutation:NSKeyValueMinusSetMutation usingObjects:values];
}

@end