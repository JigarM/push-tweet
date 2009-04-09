#import <CoreFoundation/CoreFoundation.h>
#import "XMLParser.h"

// Using this code:
//
// 1. You must supply your own push.pl (See Apple's dev forums)
// 2. Update the TWEET_FILE to your own choice of location.
// 3. Update the URL_STRING in XMLParser.m to the twitter search feed of your choice
// 4. SHOW_TICK, when set to YES, will show the start of each fetch loop.
// 5. Out of sheer paranoia, you'll need to supply your own PUSH_CMD
// 
// Pass the time interval between checks as the argument to the utility.
//
// Obviously, use at your own risk. Feel free to contribute bug fixes, etc.
//

#define TWEET_FILE	@"/Users/ericasadun/.tweet"
#define URL_STRING	@"http://search.twitter.com/search.atom?q=+ericasadun+OR+sadun++-sadunalpdag+-alpdag"
#define SHOW_TICK	NO

//@"You'll need to supply this on your own"
#define PUSH_CMD	[NSString stringWithFormat:@"perl push.pl '{\"aps\":{\"alert\":{\"body\":\"%@\",\"action-loc-key\":null}}}'", testString]

int main (int argc, const char * argv[]) {
	/* if (argc < 2)
	{
		printf("Usage: %s delay-in-seconds\n", argv[0]);
		exit(-1);
	} 
	
	int delay = atoi(argv[1]); */
	int delay = 5;
	printf("Initializing with delay of %d\n", delay);
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	while (1 > 0)
	{
	
		TreeNode *root = [[XMLParser sharedInstance] parseXMLFromURL: [NSURL URLWithString:URL_STRING]];
		TreeNode *found = nil;
		for (TreeNode *node in [root children])
		{
			if (![[node key] isEqualToString:@"entry"]) continue;
			if ([[node key] isEqualToString:@"entry"])
			{
				found = node;
				break;
			}
		}
		
		if (found)
		{
			NSString *testString = [NSString stringWithFormat:@"%@:%@", [found leafForKey:@"name"], [found leafForKey:@"title"]];
			NSString *prevString = [NSString stringWithContentsOfFile:TWEET_FILE encoding:NSUTF8StringEncoding error:nil];
			if (![prevString isEqualToString:testString])
			{
				// Update with the new tweet information
				NSLog(@"\nNew tweet from %@:\n   \"%@\"\n\n", [found leafForKey:@"name"], [found leafForKey:@"title"]);
				
				// Save the unmessed tweet to the ~/.tweet file
				[testString writeToFile:TWEET_FILE atomically:YES encoding:NSUTF8StringEncoding error:nil];
				
				// handle reserved stuff. There's got to be a better way to escape
				testString = [testString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
				testString = [testString stringByReplacingOccurrencesOfString:@"'" withString:@""];
				testString = [testString stringByReplacingOccurrencesOfString:@":" withString:@"-"];
				testString = [testString stringByReplacingOccurrencesOfString:@"{" withString:@"("];
				testString = [testString stringByReplacingOccurrencesOfString:@"}" withString:@")"];
				
				// push it
				system([PUSH_CMD UTF8String]);
			}
		}
		
		[NSThread sleepForTimeInterval:(double) delay];
		if (SHOW_TICK) printf("tick\n");
	}
	
	[pool drain];
    return 0;
}
