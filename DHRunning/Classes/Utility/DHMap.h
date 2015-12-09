//
//  DHMap.h
//  DHRunning
//
//  Created by skcu1805 on 2014/9/1.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>

@interface DHMap : NSObject

+ (void) addMap:(GMSMapView *) map path:(GMSMutablePath *) path latitude:(CLLocationDegrees) latitude longtitude:(CLLocationDegrees) longtitude;
+ (GMSMutablePath *) drawMap:(GMSMapView *) map coordinates:(NSArray *) coordinates;
+ (GMSMarker *) drawMap:(GMSMapView *) map markIcon:(UIImage *) icon title:(NSString *) title snippet:(NSString *) snippet latitude:(CLLocationDegrees) newlatitude longtitude:(CLLocationDegrees) newlongtitude;
+ (GMSMarker *) drawMap:(GMSMapView *) map markerColor:(UIColor *) color title:(NSString *) title snippet:(NSString *) snippet latitude:(CLLocationDegrees) newlatitude longtitude:(CLLocationDegrees) newlongtitude;
+ (void) moveMark:(GMSMarker *) marker latitude:(CLLocationDegrees) newlatitude longtitude:(CLLocationDegrees) newlongtitude;

@end