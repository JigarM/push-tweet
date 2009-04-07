//
//  XMLParser.m
//  pushtweet
//
//  Created by Erica Sadun on 4/6/09.
//

#import "XMLParser.h"

#define URL_STRING	@"http://search.twitter.com/search.atom?q=+ericasadun+OR+sadun++-sadunalpdag+-alpdag"

@implementation XMLParser

static XMLParser *sharedInstance = nil;

// Use just one parser instance at any time
+(XMLParser *) sharedInstance 
{
    if(!sharedInstance) {
		sharedInstance = [[self alloc] init];
    }
    return sharedInstance;
}

// Hardwire Safari ref
-(NSURL *) getURL
{
	NSString *urlString = URL_STRING;
	return [NSURL URLWithString:urlString];
}

// Public parser returns the tree root. You may have to go down one node to the real results
- (TreeNode *)parseXMLFile: (NSURL *) url
{	
	stack = [NSMutableArray array];
	
	root = [TreeNode treeNode];
	root.parent = nil;
	root.leafvalue = nil;
	root.children = [NSMutableArray array];
	
	[stack addObject:root];
	
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
	[parser parse];
    [parser release];
	
	// pop down to real root
	
	TreeNode *realroot = [[root children] lastObject];
	root.children = nil;
	root.parent = nil;
	root.leafvalue = nil;
	root.key = nil;
	
	realroot.parent = nil;
	return realroot;
}

// Descend to a new element
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (qName) elementName = qName;
	
	TreeNode *leaf = [TreeNode treeNode];
	leaf.parent = [stack lastObject];
	[(NSMutableArray *)[[stack lastObject] children] addObject:leaf];
	
	leaf.key = [NSString stringWithString:elementName];
	leaf.leafvalue = nil;
	leaf.children = [[NSMutableArray alloc] init];
	
	[stack addObject:leaf];
}

// Pop after finishing element
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	[stack removeLastObject];
}

// Reached a leaf
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (![[stack lastObject] leafvalue])
	{
		[[stack lastObject] setLeafvalue:[NSString stringWithString:string]];
		return;
	}
	[[stack lastObject] setLeafvalue:[NSString stringWithFormat:@"%@%@", [[stack lastObject] leafvalue], string]];
}

@end



