//
//  DHMap.m
//  DHRunning
//
//  Created by skcu1805 on 2014/9/1.
//  Copyright (c) 2014年 DH. All rights reserved.
//

#import "DHMap.h"
#import "DHLocation.h"

@implementation DHMap

+ (void) addMap:(GMSMapView *) map path:(GMSMutablePath *) path latitude:(CLLocationDegrees) latitude longtitude:(CLLocationDegrees) longtitude {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longtitude);
    [path addCoordinate:coordinate];
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor redColor];
    polyline.strokeWidth = 10.f;
    polyline.map = map;
}

+ (GMSMutablePath *) drawMap:(GMSMapView *) map coordinates:(NSArray *) coordinates {
    GMSMutablePath *path = [GMSMutablePath path];
    
    for (DHLocationCoordinate *dhcoordinate in coordinates) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(dhcoordinate.latitude, dhcoordinate.longitude);
        [path addCoordinate:coordinate];
    }
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor redColor];
    polyline.strokeWidth = 10.f;
    polyline.map = map;
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds];
    [map moveCamera:update];
    
    return path;
}

+ (GMSMarker *) drawMap:(GMSMapView *) map markIcon:(UIImage *) icon title:(NSString *) title snippet:(NSString *) snippet latitude:(CLLocationDegrees) newlatitude longtitude:(CLLocationDegrees) newlongtitude  {
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(newlatitude,newlongtitude);
    
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.icon = icon;
    marker.map = map;
    marker.title = title;
    marker.snippet = snippet;
    if (icon)
        marker.groundAnchor = CGPointMake(0.5, 1.3);
    
    return marker;
}

+ (GMSMarker *) drawMap:(GMSMapView *) map markerColor:(UIColor *) color title:(NSString *) title snippet:(NSString *) snippet latitude:(CLLocationDegrees) newlatitude longtitude:(CLLocationDegrees) newlongtitude  {
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(newlatitude,newlongtitude);
    
    UIImage *image = [GMSMarker markerImageWithColor:color];
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.icon = image;
    marker.map = map;
    marker.title = title;
    marker.snippet = snippet;
    
    return marker;
}


+ (void) moveMark:(GMSMarker *) marker latitude:(CLLocationDegrees) newlatitude longtitude:(CLLocationDegrees) newlongtitude {
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(newlatitude,newlongtitude);
    marker.position = position;
}

@end