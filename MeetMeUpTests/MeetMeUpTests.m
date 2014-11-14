//
//  MeetMeUpTests.m
//  MeetMeUpTests
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Event.h"
#import "Comment.h"

@interface MeetMeUpTests : XCTestCase

@end

@implementation MeetMeUpTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIfRetrievedNumberOfEventsIsFifteen
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for Events to return"];

    [Event performSearchWithKeyword:@"mobile" andComplete:^(NSArray *events)
    {
        XCTAssertEqual (events.count, 15);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testSecondEventHasOnlyOneCommentFrom99045732
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for Comments to return"];

    [Event performSearchWithKeyword:@"mobile" andComplete:^(NSArray *events)
    {
        Event *firstEvent = [events objectAtIndex:1];

        [firstEvent getCommentsWithBlock:^(NSArray *comments)
        {
            BOOL commentCountOneFrom99045732;
            Comment *firstComment = [comments objectAtIndex:0];
            NSString *firstCommentMemberID = firstComment.memberID;

            if (comments.count == 1 && [firstCommentMemberID isEqual: @"99045732"])
            {
                commentCountOneFrom99045732 = YES;
                XCTAssert(commentCountOneFrom99045732);
            }
        }];
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testAttendanceCountIncrement
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for comments to return"];

    [Event performSearchWithKeyword:@"mobile" andComplete:^(NSArray *events)
    {
        Event *secondEvent = [events objectAtIndex:1];

        int attendingCount = [[secondEvent RSVPCount] intValue];
        secondEvent.attending = YES;
        XCTAssertEqual(++attendingCount, [[secondEvent RSVPCount] intValue]);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testAttendanceCountDecrement
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for comments to return"];

    [Event performSearchWithKeyword:@"mobile" andComplete:^(NSArray *events) {

        Event *secondEvent = [events objectAtIndex:1];

        secondEvent.attending = YES;
        int attendingCount = [[secondEvent RSVPCount] intValue];
        secondEvent.attending = NO;
        XCTAssertEqual(--attendingCount, [[secondEvent RSVPCount] intValue]);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testAttendanceBooleanManagedProperly
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Waiting for comments to return"];

    [Event performSearchWithKeyword:@"mobile" andComplete:^(NSArray *events) {

        Event *secondEvent = [events objectAtIndex:1];

        secondEvent.attending = YES;

        XCTAssertEqual(secondEvent.attending, YES);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:10.0 handler:nil];

}

@end
