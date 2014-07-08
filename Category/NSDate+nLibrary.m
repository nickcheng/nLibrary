//
//  NSDate+nLibrary.m
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

/*
 #import <humor.h> : Not planning to implement: dateByAskingBoyOut and dateByGettingBabysitter
 ----
 General Thanks: sstreza, Scott Lawrence, Kevin Ballard, NoOneButMe, Avi`, August Joki. Emanuele Vulcano, jcromartiej, Blagovest Dachev, Matthias Plappert,  Slava Bushtruk, Ali Servet Donmez, Ricardo1980, pip8786, Danny Thuerin, Dennis Madsen
*/

#import "NSDate+nLibrary.h"

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (nLibrary)

#pragma mark Relative Dates

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days {
	return [[NSDate date] dateByAddingDays:days];
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days {
	return [[NSDate date] dateBySubtractingDays:days];
}

+ (NSDate *) dateTomorrow {
	return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday {
	return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}

+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

#pragma mark Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate {
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return ((components1.year == components2.year) &&
          (components1.month == components2.month) &&
          (components1.day == components2.day));
}

- (BOOL) isToday {
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow {
	return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday {
	return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate {
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	
	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if (components1.week != components2.week) return NO;
	
	// Must have a time interval under 1 week. Thanks @aclark
	return (abs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) isThisWeek {
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

- (BOOL) isLastWeek {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

// Thanks, mspasov
- (BOOL) isSameMonthAsDate: (NSDate *) aDate {
  NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:self];
  NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:aDate];
  return ((components1.month == components2.month) &&
          (components1.year == components2.year));
}

- (BOOL) isThisMonth {
  return [self isSameMonthAsDate:[NSDate date]];
}

- (BOOL) isSameYearAsDate: (NSDate *) aDate {
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
	return (components1.year == components2.year);
}

- (BOOL) isThisYear {
  // Thanks, baspellis
	return [self isSameYearAsDate:[NSDate date]];
}

- (BOOL) isNextYear {
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return (components1.year == (components2.year + 1));
}

- (BOOL) isLastYear {
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return (components1.year == (components2.year - 1));
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate {
	return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate {
	return ([self compare:aDate] == NSOrderedDescending);
}

// Thanks, markrickert
- (BOOL) isInFuture {
  return ([self isLaterThanDate:[NSDate date]]);
}

// Thanks, markrickert
- (BOOL) isInPast {
  return ([self isEarlierThanDate:[NSDate date]]);
}

#pragma mark Roles

- (BOOL) isTypicallyWeekend {
  NSDateComponents *components = [CURRENT_CALENDAR components:NSWeekdayCalendarUnit fromDate:self];
  if ((components.weekday == 1) ||
      (components.weekday == 7))
    return YES;
  return NO;
}

- (BOOL) isTypicallyWorkday {
  return ![self isTypicallyWeekend];
}

#pragma mark Adjusting Dates

- (NSDate *) dateByAddingDays: (NSInteger) dDays {
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays {
	return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours {
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours {
	return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes {
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;			
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes {
	return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *) dateAtStartOfDay {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	components.hour = 0;
	components.minute = 0;
	components.second = 0;
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate {
	NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
	return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger) minutesAfterDate: (NSDate *) aDate {
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate {
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate {
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate {
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate {
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_DAY);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate {
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_DAY);
}

// Thanks, dmitrydims
// I have not yet thoroughly tested this
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate {
  NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:self toDate:anotherDate options:0];
  return components.day;
}

#pragma mark Decomposing Dates

- (NSInteger) nearestHour {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
	return components.hour;
}

- (NSInteger) hour {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.hour;
}

- (NSInteger) minute {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.minute;
}

- (NSInteger) seconds {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.second;
}

- (NSInteger) day {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.day;
}

- (NSInteger) month {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.month;
}

- (NSInteger) week {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.week;
}

- (NSInteger) weekOfMonth {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekOfMonth;
}

- (NSInteger) weekOfYear {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekOfYear;
}

- (NSInteger) weekday {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekday;
}

// e.g. 2nd Tuesday of the month is 2
- (NSInteger) nthWeekday {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekdayOrdinal;
}

- (NSInteger) year {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.year;
}

- (NSInteger) date8digit {
  return self.year * 10000 + self.month * 100 + self.day;
}

#pragma mark -
#pragma mark Retrieving date from string

+ (NSDate*)dateWithString:(NSString*)dateString formatString:(NSString*)dateFormatterString {
	if(!dateString) return nil;
	
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:dateFormatterString];
	
	NSDate *theDate = [formatter dateFromString:dateString];
	return theDate;
}

+ (NSDate*)dateWithISO8601String:(NSString*)dateString {
	if(!dateString) return nil;
	
	if([dateString hasSuffix:@" 00:00"]) {
		dateString = [[dateString substringToIndex:(dateString.length-6)] stringByAppendingString:@"GMT"];
	} else if ([dateString hasSuffix:@"Z"]) {
		dateString = [[dateString substringToIndex:(dateString.length-1)] stringByAppendingString:@"GMT"];
	}
	
	return [[self class] dateWithString:dateString formatString:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
}

+ (NSDate*)dateWithDateString:(NSString*)dateString {
	return [[self class] dateWithString:dateString formatString:@"yyyy-MM-dd"];
}

+ (NSDate*)dateWithDateTimeString:(NSString*)dateString {
	return [[self class] dateWithString:dateString formatString:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDate*)dateWithLongDateTimeString:(NSString*)dateString {
	return [[self class] dateWithString:dateString formatString:@"dd MMM yyyy HH:mm:ss"];
}

+ (NSDate*)dateWithRSSDateString:(NSString*)dateString {
	if ([dateString hasSuffix:@"Z"]) {
		dateString = [[dateString substringToIndex:(dateString.length-1)] stringByAppendingString:@"GMT"];
	}
	
	return [[self class] dateWithString:dateString formatString:@"EEE, d MMM yyyy HH:mm:ss ZZZ"];
}

+ (NSDate*)dateWithAltRSSDateString:(NSString*)dateString {
	if ([dateString hasSuffix:@"Z"]) {
		dateString = [[dateString substringToIndex:(dateString.length-1)] stringByAppendingString:@"GMT"];
	}
	
	return [[self class] dateWithString:dateString formatString:@"d MMM yyyy HH:mm:ss ZZZ"];
}

#pragma mark Relative date

- (NSString *)formattedExactRelativeDate {
	NSTimeInterval time = [self timeIntervalSince1970];
	NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
	NSTimeInterval diff = now - time;
	
	if(diff < 10) {
		return @"just now";
	} else if(diff < 60) {
		return [NSString stringWithFormat:@"%d seconds ago", (int)diff];
	}
	
	diff = round(diff/60);
	if(diff < 60) {
		if(diff == 1) {
			return [NSString stringWithFormat:@"%d minute ago", (int)diff];
		} else {
			return [NSString stringWithFormat:@"%d minutes ago", (int)diff];
		}
	}
	
	diff = round(diff/60);
	if(diff < 24) {
		if(diff == 1) {
			return [NSString stringWithFormat:@"%d hour ago", (int)diff];
		} else {
			return [NSString stringWithFormat:@"%d hours ago", (int)diff];
		}
	}
	
	if(diff < 7) {
		if(diff == 1) {
			return @"yesterday";
		} else {
			return [NSString stringWithFormat:@"%d days ago", (int)diff];
		}
	}
	
	return [self formattedDateWithFormatString:@"MM/dd/yy"];
}

- (NSString *)relativeFormattedDate {
  // Initialize the formatter.
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterShortStyle];
  [formatter setTimeStyle:NSDateFormatterNoStyle];
	
  // Initialize the calendar and flags.
  unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
  NSCalendar* calendar = [NSCalendar currentCalendar];
	
  // Create reference date for supplied date.
  NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
  [comps setHour:0];
  [comps setMinute:0];
  [comps setSecond:0];
	
  NSDate* suppliedDate = [calendar dateFromComponents:comps];
	
  // Iterate through the eight days (tomorrow, today, and the last six).
  int i;
  for (i = -1; i < 7; i++) {
    // Initialize reference date.
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    [comps setDay:[comps day] - i];
    NSDate* referenceDate = [calendar dateFromComponents:comps];
    // Get week day (starts at 1).
    int weekday = [[calendar components:unitFlags fromDate:referenceDate] weekday] - 1;
		
    if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0) {
      // Today
			[formatter setDateStyle:NSDateFormatterNoStyle];
			[formatter setTimeStyle:NSDateFormatterShortStyle];
			break;
    } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1) {
      // Yesterday
      [formatter setDateStyle:NSDateFormatterNoStyle];
      return @"Yesterday";
    } else if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
      // Day of the week
      return [[formatter weekdaySymbols] objectAtIndex:weekday];
    }
  }
	
  // It's not in those eight days.
  return [formatter stringFromDate:self];
}

- (NSString *)relativeFormattedDateOnly {
  // Initialize the formatter.
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterShortStyle];
  [formatter setTimeStyle:NSDateFormatterNoStyle];
	
  // Initialize the calendar and flags.
  unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
  NSCalendar* calendar = [NSCalendar currentCalendar];
	
  // Create reference date for supplied date.
  NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
  [comps setHour:0];
  [comps setMinute:0];
  [comps setSecond:0];
	
  NSDate* suppliedDate = [calendar dateFromComponents:comps];
	
  // Iterate through the eight days (tomorrow, today, and the last six).
  int i;
  for (i = -1; i < 7; i++) {
    // Initialize reference date.
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    [comps setDay:[comps day] - i];
    NSDate* referenceDate = [calendar dateFromComponents:comps];
    // Get week day (starts at 1).
    int weekday = [[calendar components:unitFlags fromDate:referenceDate] weekday] - 1;
		
    if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0) {
      // Today
      [formatter setDateStyle:NSDateFormatterNoStyle];
      return @"Today";
    } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1) {
      // Yesterday
      [formatter setDateStyle:NSDateFormatterNoStyle];
      return @"Yesterday";
    } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == -1) {
      // Yesterday
      [formatter setDateStyle:NSDateFormatterNoStyle];
      return @"Tomorrow";
    } else if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
      // Day of the week
      return [[formatter weekdaySymbols] objectAtIndex:weekday];
    }
  }
	
  // It's not in those eight days.
  return [formatter stringFromDate:self];
}

- (NSString *)relativeFormattedDateTime {
  // Initialize the formatter.
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterShortStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
	[formatter setAMSymbol:@"am"];
	[formatter setPMSymbol:@"pm"];
	
  // Initialize the calendar and flags.
  unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
  NSCalendar* calendar = [NSCalendar currentCalendar];
	
  // Create reference date for supplied date.
  NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
  [comps setHour:0];
  [comps setMinute:0];
  [comps setSecond:0];
	
  NSDate* suppliedDate = [calendar dateFromComponents:comps];
	
  // Iterate through the eight days (tomorrow, today, and the last six).
  int i;
  for (i = -1; i < 7; i++) {
    // Initialize reference date.
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    [comps setDay:[comps day] - i];
    NSDate* referenceDate = [calendar dateFromComponents:comps];
    // Get week day (starts at 1).
    int weekday = [[calendar components:unitFlags fromDate:referenceDate] weekday] - 1;
		
    if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0) {
      // Today
      [formatter setDateStyle:NSDateFormatterNoStyle];
      return [NSString stringWithFormat:@"Today, %@", [formatter stringFromDate:self]];
		} else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1) {
      // Yesterday
      [formatter setDateStyle:NSDateFormatterNoStyle];
			return [NSString stringWithFormat:@"Yesterday, %@", [formatter stringFromDate:self]];
    } else if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
      // Day of the week
      NSString* day = [[formatter weekdaySymbols] objectAtIndex:weekday];
			[formatter setDateStyle:NSDateFormatterNoStyle];
			return [NSString stringWithFormat:@"%@, %@", day, [formatter stringFromDate:self]];
    }
  }
	
  // It's not in those eight days.
  [formatter setDateStyle:NSDateFormatterShortStyle];
  [formatter setTimeStyle:NSDateFormatterNoStyle];
	NSString* date = [formatter stringFromDate:self];
	
  [formatter setDateStyle:NSDateFormatterNoStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
	NSString* time = [formatter stringFromDate:self];
	
	return [NSString stringWithFormat:@"%@, %@", date, time];
}

- (NSString *)relativeLongFormattedDate {
  // Initialize the formatter.
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterFullStyle];
  [formatter setTimeStyle:NSDateFormatterNoStyle];
	
  // Initialize the calendar and flags.
  unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekdayCalendarUnit;
  NSCalendar* calendar = [NSCalendar currentCalendar];
	
  // Create reference date for supplied date.
  NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
  [comps setHour:0];
  [comps setMinute:0];
  [comps setSecond:0];
	
  NSDate* suppliedDate = [calendar dateFromComponents:comps];
	
  // Iterate through the eight days (tomorrow, today, and the last six).
  int i;
  for (i = -1; i < 7; i++) {
    // Initialize reference date.
    comps = [calendar components:unitFlags fromDate:[NSDate date]];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    [comps setDay:[comps day] - i];
    NSDate* referenceDate = [calendar dateFromComponents:comps];
    // Get week day (starts at 1).
    int weekday = [[calendar components:unitFlags fromDate:referenceDate] weekday] - 1;
		
    if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0) {
      // Today
      [formatter setDateStyle:NSDateFormatterNoStyle];
      return @"Today";
    } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1) {
      // Yesterday
      [formatter setDateStyle:NSDateFormatterNoStyle];
      return @"Yesterday";
    } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == -1) {
      // Tomorrow
      [formatter setDateStyle:NSDateFormatterNoStyle];
      return @"Tomorrow";
    } else if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
      // Day of the week
      return [[formatter weekdaySymbols] objectAtIndex:weekday];
    }
  }
	
  // It's not in those eight days.
  return [formatter stringFromDate:self];
}

#pragma mark Formatted date

- (NSString *)formattedDateWithFormatString:(NSString*)dateFormatterString {
	if(!dateFormatterString) return nil;
	
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:dateFormatterString];
	[formatter setAMSymbol:@"am"];
	[formatter setPMSymbol:@"pm"];
	return [formatter stringFromDate:self];
}

- (NSString *)formattedDate {
	return [self formattedDateWithFormatString:@"EEE, d MMM 'at' h:mma"];
}

- (NSString *)formattedTime {
  // Initialize the formatter.
  NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
  [formatter setDateStyle:NSDateFormatterNoStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
	
  return [formatter stringFromDate:self];
}

- (NSString *)iso8601Formatted {
	return [self formattedDateWithFormatString:@"yyyy-MM-dd'T'HH:mm:ssZ"];
}

- (NSString *)dateString {
  return [NSString stringWithFormat:@"%d-%02d-%02d", self.year, self.month, self.day];
}

- (NSString *)dateString8 {
  return [NSString stringWithFormat:@"%d%02d%02d", self.year, self.month, self.day];
}

#pragma mark

- (NSDate *)firstDayOfMonth {
  NSDateComponents *firstDayOfMonth = [CURRENT_CALENDAR components:NSDayCalendarUnit | NSMonthCalendarUnit |NSYearCalendarUnit fromDate:self];
  
  firstDayOfMonth.day = 1;
  
  return [CURRENT_CALENDAR dateFromComponents:firstDayOfMonth];
}

- (NSDate *)lastDayOfMonth {
  NSDateComponents *lastDayOfMonth = [CURRENT_CALENDAR components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:self];
  
  lastDayOfMonth.day = [self numberOfDaysInMonth];
  
  return [CURRENT_CALENDAR dateFromComponents:lastDayOfMonth];
}

- (NSInteger)numberOfWeeksInMonth {
  NSRange rng = [CURRENT_CALENDAR rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
  NSInteger numberOfWeeksInMonth = rng.length;
  return numberOfWeeksInMonth;
//  NSDate *firstDayInMonth = [self firstDayOfMonth];
//  NSDate *lastDayInMonth = [self lastDayOfMonth];
//  NSInteger firstWeekNumber = firstDayInMonth.weekOfMonth;
//  NSInteger lastWeekNumber =lastDayInMonth.weekOfMonth;
//  
//  return lastWeekNumber - firstWeekNumber + 1;
}

- (NSInteger)numberOfDaysInMonth {
  NSRange rng = [CURRENT_CALENDAR rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self];
  NSInteger numberOfDaysInMonth = rng.length;
  return numberOfDaysInMonth;
}

- (NSDate *)beginningOfWeek {
  // largely borrowed from "Date and Time Programming Guide for Cocoa"
  // we'll use the default calendar and hope for the best
  NSDate *beginningOfWeek = nil;
  BOOL ok = [CURRENT_CALENDAR rangeOfUnit:NSWeekCalendarUnit
                                startDate:&beginningOfWeek
                                 interval:NULL forDate:self];
  if (ok) {
    return beginningOfWeek;
  }
  
  // couldn't calc via range, so try to grab Sunday, assuming gregorian style
  // Get the weekday component of the current date
  NSDateComponents *weekdayComponents = [CURRENT_CALENDAR components:NSWeekdayCalendarUnit fromDate:self];
  
  /*
   Create a date components to represent the number of days to subtract from the current date.
   The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
   */
  NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
  [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
  beginningOfWeek = nil;
  beginningOfWeek = [CURRENT_CALENDAR dateByAddingComponents:componentsToSubtract toDate:self options:0];
  
  //normalize to midnight, extract the year, month, and day components and create a new date from those components.
  NSDateComponents *components = [CURRENT_CALENDAR components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                     fromDate:beginningOfWeek];
  return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *)beginningOfDay {
  // Get the weekday component of the current date
  NSDateComponents *components = [CURRENT_CALENDAR components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                     fromDate:self];
  return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *)endOfWeek {
  // Get the weekday component of the current date
  NSDateComponents *weekdayComponents = [CURRENT_CALENDAR components:NSWeekdayCalendarUnit fromDate:self];
  NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
  // to get the end of week for a particular date, add (7 - weekday) days
  [componentsToAdd setDay:(7 - [weekdayComponents weekday])];
  NSDate *endOfWeek = [CURRENT_CALENDAR dateByAddingComponents:componentsToAdd toDate:self options:0];
  
  return endOfWeek;
}

@end
