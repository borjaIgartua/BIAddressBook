//
//  AddressBookTool.m
//  AddressBookExample
//
//  Created by Borja on 20/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

#import "BIAddressBook.h"

#import "Contact.h"
#import <AddressBook/AddressBook.h>

@interface BIAddressBook ()

/**
 * Read all the contacts into the addressBook
 *
 * @param contacts. The array to save the contacts
 * @param source. The addressBook current source
 * @param addressBook. The addressBook for read the contacts
 */
- (void)updateContacts:(NSMutableArray *)contacts
             forSource:(ABRecordRef)source
       withAddressBook:(ABAddressBookRef)addressBook;

/**
 * Read all the person information
 *
 * @param contacts. The array to save the contacts
 * @param contact. The contact storage into the addressBook
 */
- (void)updateContacts:(NSMutableArray *)contacts
             forContact:(ABRecordRef)contact;

/**
 * Return all the phone numbers asociated to a contact
 *
 * @param contact. The contact storage into the addressBook
 * @return all the phone numbers
 */
- (NSArray *)phonesForContact:(ABRecordRef)contact;

@end

@implementation BIAddressBook

/**
 * Read all the agenda contacts
 *
 * @param completionHandler. The block called when the contacs are read
 */
- (void)readAllContactsCompletion:(void (^)(NSArray *contacts, BOOL permissionsGranted))completionHandler {
    
    ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
       
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if (granted) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    
                    NSMutableArray *contacts = [[NSMutableArray alloc] init];
                    
                    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
                    
                        CFArrayRef sources = ABAddressBookCopyArrayOfAllSources(addressBook);
                        
                        CFIndex c = CFArrayGetCount(sources);
                        
                        for (CFIndex i=0; i<c; i++) {
                            
                            @autoreleasepool {
                                
                                ABRecordRef currentSource = CFArrayGetValueAtIndex(sources, i);
                                [self updateContacts:contacts forSource:currentSource withAddressBook:addressBook];
                            }
                        }
                        
                        CFRelease(addressBook);
                        CFRelease(sources);
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completionHandler(contacts, YES);
                        });
                });
                
            } else {
                completionHandler(nil, NO);
            }
        });
    });
}

/**
 * Read all the contacts into the addressBook
 *
 * @param contacts. The array to save the contacts
 * @param source. The addressBook current source
 * @param addressBook. The addressBook for read the contacts
 */
- (void)updateContacts:(NSMutableArray *)contacts
             forSource:(ABRecordRef)source
       withAddressBook:(ABAddressBookRef)addressBook {
    
    CFArrayRef allPeople = (ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName));
    CFIndex nPeople = CFArrayGetCount(allPeople);
    
    for (int i = 0; i < nPeople; i++) {
        
        @autoreleasepool {
            
            ABRecordRef contact = CFArrayGetValueAtIndex(allPeople, i);
            [self updateContacts:contacts forContact:contact];
        }
    }
    
    if (allPeople) {
        CFRelease(allPeople);
    }
}

/**
 * Read all the person information
 *
 * @param contacts. The array to save the contacts
 * @param contact. The contact storage into the addressBook
 */
- (void)updateContacts:(NSMutableArray *)contacts
            forContact:(ABRecordRef)contact {
    
    Contact *newContact = [[Contact alloc] init];
    
    CFStringRef nameRef = (CFStringRef)ABRecordCopyValue(contact,kABPersonFirstNameProperty);
    CFStringRef lastnameRef = (CFStringRef)ABRecordCopyValue(contact,kABPersonLastNameProperty);
    ABRecordID idrecord = ABRecordGetRecordID(contact);
    CFDataRef imgDataRef = ABPersonCopyImageData(contact);
    
    NSString *name = [(__bridge NSString*)nameRef copy];
    if (nameRef) {
        CFRelease(nameRef);
    }
    
    NSString *lastname = [(__bridge NSString*)lastnameRef copy];
    if (lastnameRef) {
        CFRelease(lastnameRef);
    }
    
    if (imgDataRef) {
        [newContact setImageData:[(__bridge NSData *)imgDataRef copy]];
        CFRelease(imgDataRef);
    }
    
    [newContact setName:name];
    [newContact setLastname:lastname];
    [newContact setRecordID:idrecord];
    [newContact setTelephones:[self phonesForContact:contact]];
    
    [contacts addObject:newContact];
}

/**
 * Return all the phone numbers asociated to a contact
 *
 * @param contact. The contact storage into the addressBook
 * @return all the phone numbers
 */
- (NSArray *)phonesForContact:(ABRecordRef)contact {
    
    ABMultiValueRef multiPhonesRef = ABRecordCopyValue(contact, kABPersonPhoneProperty);
    NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
    
    for(CFIndex i=0; i < ABMultiValueGetCount(multiPhonesRef); i++) {
        
        @autoreleasepool {
            
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhonesRef, i);
            NSString *phoneNumber = CFBridgingRelease(phoneNumberRef);
            
            if (phoneNumber) {
                [phoneNumbers addObject:phoneNumber];
            }
        }
    }
    
    if (multiPhonesRef) {
        CFRelease(multiPhonesRef);
    }
    
    return phoneNumbers;
}

@end
