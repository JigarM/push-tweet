//
//  XMLParser.h
//  pushtweet
//
//  Created by Erica Sadun on 4/6/09.
//

#import <CoreFoundation/CoreFoundation.h>
#import "TreeNode.h"

@interface XMLParser : NSObject
{
	NSMutableArray		*stack;
	TreeNode			*root;
}

+ (XMLParser *) sharedInstance;
- (NSURL *) getURL;
- (TreeNode *)parseXMLFile: (NSURL *) url;
@end

