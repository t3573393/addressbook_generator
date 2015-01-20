//
//  ContactsGenerate.m
//  LibContacts
//
//  Created by linfeng on 14-12-19.
//
//

#import "ContactsGenerate.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#define MAXSIZE 20
#define MAXRECORDNUM 5

@interface ContactsGenerate ()

@property (nonatomic) NSInteger dataNumber;

@end

@implementation ContactsGenerate

- (instancetype)initWithDataNumber:(NSInteger)num
{
    if (self = [super init])
    {
        _dataNumber = num;
    }
    return self;
}

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

NSString *numLetters = @"0123456789";

- (NSString *)randomStringWithLength:(int)len
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    return randomString;
}

- (NSString *)randomPhoneWithLength
{
    NSMutableString *randomString = [NSMutableString stringWithString:@"813435"];
    for (int i=0; i<4; i++) {
        [randomString appendFormat: @"%C", [numLetters characterAtIndex: arc4random_uniform([numLetters length])]];
    }
    return randomString;
}

- (NSString *)randomEmailWithLength
{
    NSMutableString *randomString = [NSMutableString stringWithString:@"testEmail-"];
    for (int i=0; i<4; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    [randomString appendString:@"@ihandysoft.com"];
    return randomString;
}

- (void)generate
{
    CFErrorRef *error = nil;
    ABAddressBookRef libroDirec = ABAddressBookCreateWithOptions(NULL, error);
    
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(libroDirec, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted)
    {
        
        for(int n=0;n<self.dataNumber;n++)
        {
            NSString * addressString1 = [self randomStringWithLength:arc4random_uniform(MAXSIZE)];
            
            NSString * addressString2 = [self randomStringWithLength:arc4random_uniform(MAXSIZE)];
            
            NSString * cityName = [self randomStringWithLength:arc4random_uniform(MAXSIZE)];
            
            NSString * stateName = [self randomStringWithLength:arc4random_uniform(MAXSIZE)];
            
            NSString * postal = [self randomStringWithLength:arc4random_uniform(MAXSIZE)];
            
            NSString * prefName = [self randomStringWithLength:arc4random_uniform(MAXSIZE)];
            
            
            ABRecordRef persona = ABPersonCreate();
            
            ABRecordSetValue(persona, kABPersonFirstNameProperty, (__bridge CFTypeRef)(prefName), nil);
            
            ABMutableMultiValueRef multiHome = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
            
            NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
            
            NSString *homeStreetAddress=[addressString1 stringByAppendingString:addressString2];
            
            [addressDictionary setObject:homeStreetAddress forKey:(NSString *) kABPersonAddressStreetKey];
            
            [addressDictionary setObject:cityName forKey:(NSString *)kABPersonAddressCityKey];
            
            [addressDictionary setObject:stateName forKey:(NSString *)kABPersonAddressStateKey];
            
            [addressDictionary setObject:postal forKey:(NSString *)kABPersonAddressZIPKey];
            
            bool didAddHome = ABMultiValueAddValueAndLabel(multiHome, (__bridge CFTypeRef)(addressDictionary), kABHomeLabel, NULL);
            
            if(didAddHome)
            {
                ABRecordSetValue(persona, kABPersonAddressProperty, multiHome, NULL);
                
                NSLog(@"Address saved.....");
            }
            
            //##############################################################################
            
            for(int i=0;i<arc4random_uniform(MAXRECORDNUM);i++)
            {
                NSString *phoneNumber = [self randomPhoneWithLength];
                
                ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                
                bool didAddPhone = ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(phoneNumber), kABPersonPhoneMobileLabel, NULL);
                
                if(didAddPhone){
                    
                    ABRecordSetValue(persona, kABPersonPhoneProperty, multiPhone,nil);
                    
                    NSLog(@"Phone Number saved......");
                    
                }
                CFRelease(multiPhone);
            }
            
            //##############################################################################
            
            for(int i=0;i<arc4random_uniform(MAXRECORDNUM);i++)
            {
                
                NSString *emailString = [self randomEmailWithLength];
                
                ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABPersonEmailProperty);
                
                bool didAddEmail = ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFTypeRef)(emailString), kABOtherLabel, NULL);
                
                if(didAddEmail){
                    
                    ABRecordSetValue(persona, kABPersonEmailProperty, emailMultiValue, nil);
                    
                    NSLog(@"Email saved......");
                }
                
                CFRelease(emailMultiValue);
            }
            
            //##############################################################################
            BOOL isSuccess =  ABAddressBookAddRecord(libroDirec, persona, error);
            
            CFRelease(persona);
        }
    }
    
    
    ABAddressBookSave(libroDirec, nil);
    
    CFRelease(libroDirec);
    
    NSString * errorString = [NSString stringWithFormat:@"Information are saved into Contact"];
    
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"New Contact Info" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [errorAlert show];
    
}

- (void)clearAll
{
    CFErrorRef *error = nil;
    ABAddressBookRef libroDirec = ABAddressBookCreateWithOptions(NULL, error);
    
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(libroDirec, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted)
    {
        NSMutableArray *contactsBookArray = (__bridge NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(libroDirec);
        {
            for(id person in contactsBookArray)
            {
                ABAddressBookRemoveRecord(libroDirec, (__bridge ABRecordRef)person, error);
            }
        }
        
        if (contactsBookArray != nil)
        {
            CFRelease((__bridge CFTypeRef)(contactsBookArray));
        }
    }
    ABAddressBookSave(libroDirec, nil);
    
    CFRelease(libroDirec);
    
    NSString * errorString = [NSString stringWithFormat:@"Information are saved into Contact"];
    
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"New Contact Info" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [errorAlert show];
    
}

- (void)removeLeave:(int)number
{
    CFErrorRef *error = nil;
    ABAddressBookRef libroDirec = ABAddressBookCreateWithOptions(NULL, error);
    
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(libroDirec, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    }
    else { // we're on iOS 5 or older
        accessGranted = YES;
    }
    
    if (accessGranted)
    {
        NSMutableArray *contactsBookArray = (__bridge NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(libroDirec);
        NSInteger allCount = [contactsBookArray count];
        if (allCount <= number)
        {
            return ;
        }
        
        NSInteger needToDelete = allCount - number;
        {
            for(id person in contactsBookArray)
            {
                ABAddressBookRemoveRecord(libroDirec, (__bridge ABRecordRef)person, error);
                needToDelete --;
                if (needToDelete == 0)
                {
                    break;
                }
            }
        }
        
        if (contactsBookArray != nil)
        {
            CFRelease((__bridge CFTypeRef)(contactsBookArray));
        }
    }
    ABAddressBookSave(libroDirec, nil);
    
    CFRelease(libroDirec);
    
    NSString * errorString = [NSString stringWithFormat:@"Information are saved into Contact"];
    
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"New Contact Info" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [errorAlert show];

}

@end
