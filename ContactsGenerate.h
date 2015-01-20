//
//  ContactsGenerate.h
//  LibContacts
//
//  Created by linfeng on 14-12-19.
//
//

#import <Foundation/Foundation.h>

@interface ContactsGenerate : NSObject

- (instancetype)initWithDataNumber:(NSInteger)num;

- (void)generate;

- (void)clearAll;

- (void)removeLeave:(int)number;

@end
