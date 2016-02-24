//
//  Contact.m
//  AddressBookExample
//
//  Created by Borja on 20/2/16.
//  Copyright © 2016 Borja. All rights reserved.
//

#import "Contact.h"

@implementation Contact

- (instancetype)initWithName:(NSString *)name
                    lastname:(NSString *)lasname
                   imageData:(NSData *)imageData
                    recordID:(NSInteger)recordID
                  telephones:(NSArray *)telephones {
    
    if(self = [super init]) {
        
        self.name = name;
        self.lastname = lasname;
        self.imageData = imageData;
        self.recordID = recordID;
        self.telephones = telephones;
    }
    
    return self;
}

@end
