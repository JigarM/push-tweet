//
//  TreeNode.h
//  pushtweet
//
//  Created by Erica Sadun on 4/6/09.
//

#import <CoreFoundation/CoreFoundation.h>

@interface TreeNode : NSObject
{
	TreeNode		*parent;
	NSMutableArray	*children;
	NSString		*key;
	NSString		*leafvalue;
}
@property (nonatomic, retain) 	TreeNode		*parent;
@property (nonatomic, retain) 	NSMutableArray	*children;
@property (nonatomic, retain) 	NSString		*key;
@property (nonatomic, retain) 	NSString		*leafvalue;

+ (TreeNode *) treeNode;

- (void) dump;

- (BOOL) isLeaf;
- (NSMutableArray *) keys;

- (TreeNode *) objectForKey: (NSString *) aKey;
- (NSMutableArray *) objectsForKey: (NSString *) aKey;
- (TreeNode *) objectForKeys: (NSArray *) keys;
- (NSString *) leafForKey: (NSString *) aKey;
- (NSMutableDictionary *) dictionaryForChildren;
@end
