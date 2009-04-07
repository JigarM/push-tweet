//
//  TreeNode.m
//  pushtweet
//
//  Created by Erica Sadun on 4/6/09.
//

#import "TreeNode.h"

@implementation TreeNode
@synthesize parent;
@synthesize children;
@synthesize key;
@synthesize leafvalue;

// Initialize all nodes as branches
- (TreeNode *) init
{
	if (self = [super init]) leafvalue = nil;
	return self;
}

+ (TreeNode *) treeNode
{
	return [[[self alloc] init] autorelease];
}

// Determine whether the node is a leaf or a branch
- (BOOL) isLeaf
{
	return (leafvalue != nil);
}

// Return an array of all child keys
- (NSMutableArray *) keys
{
	NSMutableArray *results = [NSMutableArray array];
	for (TreeNode *node in children) [results addObject:[node key]];
	return results;
}

// Return the first child that matches the key
- (TreeNode *) objectForKey: (NSString *) aKey
{
	TreeNode *result = nil;
	for (TreeNode *node in children) 
		if ([[node key] isEqualToString: aKey]) result = node;
	return result;
}

// Return all children that match the key
- (NSMutableArray *) objectsForKey: (NSString *) aKey
{
	NSMutableArray *result = [NSMutableArray array];
	for (TreeNode *node in children) 
		if ([[node key] isEqualToString: aKey]) [result addObject:node];
	return result;
}

// Return the last child leaf value that matches the key
- (NSString *) leafForKey: (NSString *) aKey
{
	NSString *result = nil;
	for (TreeNode *node in children) 
		if ([[node key] isEqualToString: aKey]) result = [node leafvalue];
	if (result) return result;
	for (TreeNode *node in children)
	{
		result = [node leafForKey:aKey];
		if (result) return result;
	}
	return nil;
}

// Follow a key path that matches each first found branch
- (TreeNode *) objectForKeys: (NSArray *) keys
{
	if ([keys count] == 0) return self;
	
	NSMutableArray *nextArray = [NSMutableArray arrayWithArray:keys];
	[nextArray removeObjectAtIndex:0];
	
	for (TreeNode *node in children)
	{
		if ([[node key] isEqualToString:[keys objectAtIndex:0]])
			return [node objectForKeys:nextArray];
	}
	
	return nil;
}

// Print out the tree
- (void) dumpAtIndent: (int) indent
{
	for (int i = 0; i < indent; i++) printf("--");
	
	printf("[%2d] Key: %s ", indent, [key UTF8String]);
	if (leafvalue) printf("(%s)", [leafvalue UTF8String]);
	printf("\n");
	
	for (TreeNode *node in children) [node dumpAtIndent:indent + 1];
}

- (void) dump
{
	[self dumpAtIndent:0];
}

// When you're sure you're the parent of all leaves, transform to a dictionary
- (NSMutableDictionary *) dictionaryForChildren
{
	NSMutableDictionary *results = [NSMutableDictionary dictionary];
	
	for (TreeNode *node in children)
		if ([node isLeaf]) [results setObject:[node leafvalue] forKey:[node key]];
	
	return results;
}

- (void) dealloc
{
	self.parent = nil;
	self.children = nil;
	self.key = nil;
	self.leafvalue = nil;
	
	[super dealloc];
}

@end