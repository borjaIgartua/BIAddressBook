//
//  AddressBookTool.h
//  AddressBookExample
//
//  Created by Borja on 20/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BIAddressBook : NSObject

/**
 * Read all the agenda contacts
 *
 * @param completionHandler. The block called when the contacs are read
 */
- (void)readAllContactsCompletion:(void (^)(NSArray *contacts, BOOL permissionsGranted))completionHandler;

@end
