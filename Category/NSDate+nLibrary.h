//
//  NSDate+nLibrary.h
//  nLibrary
//
//  Created by nickcheng on 14-1-23.
//  Copyright (c) 2014年 nickcheng.com. All rights reserved.
//
//  License: MIT License
//
//  Credits (Code snippets license): 
//  Erica Sadun, http://ericasadun.com
//  iPhone Developer's Cookbook 3.x and beyond
//  BSD License, Use at your own risk
//

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY     86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (nLibrary)

// Relative dates from the current date
+ (NSDate *)dateTomorrow;
+ (NSDate *)dateYesterday;
+ (NSDate *)dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *)dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *)dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *)dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *)dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *)dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Comparing dates
- (BOOL)isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)isYesterday;
- (BOOL)isSameWeekAsDate: (NSDate *) aDate;
- (BOOL)isThisWeek;
- (BOOL)isNextWeek;
- (BOOL)isLastWeek;
- (BOOL)isSameMonthAsDate: (NSDate *) aDate; 
- (BOOL)isThisMonth;
- (BOOL)isSameYearAsDate: (NSDate *) aDate;
- (BOOL)isThisYear;
- (BOOL)isNextYear;
- (BOOL)isLastYear;
- (BOOL)isEarlierThanDate: (NSDate *) aDate;
- (BOOL)isLaterThanDate: (NSDate *) aDate;
- (BOOL)isInFuture;
- (BOOL)isInPast;

// Date roles
- (BOOL)isTypicallyWorkday;
- (BOOL)isTypicallyWeekend;

// Adjusting dates
- (NSDate *)dateByAddingDays: (NSInteger) dDays;
- (NSDate *)dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *)dateByAddingHours: (NSInteger) dHours;
- (NSDate *)dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *)dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *)dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *)dateAtStartOfDay;

// Retrieving intervals
- (NSInteger)minutesAfterDate: (NSDate *) aDate;
- (NSInteger)minutesBeforeDate: (NSDate *) aDate;
- (NSInteger)hoursAfterDate: (NSDate *) aDate;
- (NSInteger)hoursBeforeDate: (NSDate *) aDate;
- (NSInteger)daysAfterDate: (NSDate *) aDate;
- (NSInteger)daysBeforeDate: (NSDate *) aDate;
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

// Retrieving date from string
// Returns an NSDate based on a string with formatting options passed to NSDateFormatter
+ (NSDate *)dateWithString:(NSString*)dateString formatString:(NSString*)dateFormatterString;
+ (NSDate *)dateWithISO8601String:(NSString*)str;      // Returns an NSDate with an ISO8610 format, aka ATOM: yyyy-MM-dd'T'HH:mm:ssZZZ
+ (NSDate *)dateWithDateString:(NSString*)str;         // Returns an NSDate with a 'yyyy-MM-dd' string
+ (NSDate *)dateWithDateTimeString:(NSString*)str;     // Returns an NSDate with a 'yyyy-MM-dd HH:mm:ss' string
+ (NSDate *)dateWithLongDateTimeString:(NSString*)str; // Returns an NSDate with a 'dd MMM yyyy HH:mm:ss' string
+ (NSDate *)dateWithRSSDateString:(NSString*)str;      // Returns an NSDate with an RSS formatted string: 'EEE, d MMM yyyy HH:mm:ss ZZZ' string
+ (NSDate *)dateWithAltRSSDateString:(NSString*)str;   // Returns an NSDate with an alternative RSS formatted string: 'd MMM yyyy HH:mm:ss ZZZ' string
+ (NSDate *)dateWithDateString8:(NSString *)str;
+ (NSDate *)dateWithDateInteger8:(NSInteger)digit;

- (NSString *)formattedExactRelativeDate; // just now, 2 minutes ago, 2 hours ago, 2 days ago, etc.
- (NSString *)formattedDateWithFormatString:(NSString*)dateFormatterString;  // Pass in an string compatible with NSDateFormatter
- (NSString *)formattedDate; // Returns date formatted to: EEE, d MMM 'at' h:mma
- (NSString *)formattedTime; // Returns date formatted to: NSDateFormatterShortStyle

// Returns date formatted to: Weekday if within last 7 days, Yesterday/Tomorrow, or NSDateFormatterShortStyle for everything else
- (NSString*)relativeFormattedDate;

// Returns date formatted to: Weekday if within last 7 days, Yesterday/Today/Tomorrow, or NSDateFormatterShortStyle for everything else
// If date is today, returns no Date, instead returns NSDateFormatterShortStyle for time
- (NSString*)relativeFormattedDateOnly;

// Returns date formatted to: Weekday if within last 7 days, Yesterday/Today/Tomorrow, or NSDateFormatterFullStyle for everything else
// Also returns NSDateFormatterShortStyle for time
- (NSString*)relativeFormattedDateTime;

// Returns date formatted to: Weekday if within last 7 days, Yesterday/Today/Tomorrow, or NSDateFormatterFullStyle for everything else
- (NSString*)relativeLongFormattedDate;

- (NSString *)iso8601Formatted;  // Returns date formatted for ISO8601/ATOM: yyyy-MM-dd'T'HH:mm:ssZZZ
- (NSString *)dateString;   // yyyy-MM-dd based on local timezone
- (NSString *)dateString8;  // yyyyMMdd based on local timezone

- (NSInteger)numberOfWeeksInMonth;  // Get number of weeks in month.
- (NSInteger)numberOfDaysInMonth;   // Get number of days in month.

- (NSDate *)firstDayOfMonth;  // Get first day of the month.
- (NSDate *)lastDayOfMonth;   // Get last day of the month.

- (NSDate *)beginningOfWeek;
- (NSDate *)endOfWeek;
- (NSDate *)beginningOfDay;

+ (NSString *)weekdayWordsFromInt:(NSInteger)wd;
+ (NSString *)weekdayShortWordsFromInt:(NSInteger)wd;

- (NSArray *)daysArrayInCurrentWeek;
- (NSArray *)daysArrayInCurrentMonth;


// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekOfMonth;
@property (readonly) NSInteger weekOfYear;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;
@property (readonly) NSInteger date8digit;

@end
