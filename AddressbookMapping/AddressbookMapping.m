//
//  AddressbookMapping.m
//  qliq
//
//  Created by Aleksey Garbarev on 30.07.13.
//
//

#import "AddressbookMapping.h"

@implementation AddressbookMapping {
    NSDictionary *mappingDictionary;
}

- (id) initWithMappingDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        mappingDictionary = dictionary;
    }
    return self;
}

- (void) mapObject:(NSObject *)object fromABRecordRef:(ABRecordRef)abRecordRef
{
    for (NSString *key in [mappingDictionary allKeys]) {
        
        AddressbookMappingValue *addressbookValue = [mappingDictionary valueForKey:key];
        CFTypeRef abValueRef = ABRecordCopyValue(abRecordRef, addressbookValue.propertyId);
        
        if (abValueRef) {
            
            NSObject *value = [self valueFromAddressBookValue:addressbookValue andABValueRef:abValueRef];
            [object setValue:value forKey:key];
            
            CFRelease(abValueRef);
        }
    }
}

- (NSObject *) valueFromAddressBookValue:(AddressbookMappingValue *)addressbookValue andABValueRef:(CFTypeRef)abValue
{
    NSObject *value = nil;
    if ([self isSingleStringValue:abValue]) {
        value = (__bridge NSObject *)abValue;
    }
    else {
        value = [self valueWithTestBlock:addressbookValue.multivalueTestBlock fromMultiValueRef:abValue];
    }
    return value;
}

- (BOOL) isSingleStringValue:(CFTypeRef)value
{
    return CFGetTypeID(value) == CFStringGetTypeID();
}

- (NSObject *) firstValueFromMultiValueRef:(ABMultiValueRef)multiValueRef
{
    NSObject *stringValue = nil;
    if (ABMultiValueGetCount(multiValueRef) > 0) {
        stringValue = (__bridge_transfer NSObject *) ABMultiValueCopyValueAtIndex(multiValueRef, 0);
    }
    return stringValue;
}

- (NSObject *) valueWithTestBlock:(AddressbookMappingValueTestBlock)testBlock fromMultiValueRef:(ABMultiValueRef)multiValueRef
{
    if (!testBlock) {
        return [self firstValueFromMultiValueRef:multiValueRef];
    }
    
    NSObject *resultValue = nil;
    NSUInteger targetIndex = -1;
    NSUInteger count = ABMultiValueGetCount(multiValueRef);
    
    for (int i = 0; i < count; i++) {
        
        CFStringRef currentLabel = ABMultiValueCopyLabelAtIndex(multiValueRef, i);
        if (testBlock(currentLabel)) {
            targetIndex = i;
            break;
        }
        if (currentLabel) {
            CFRelease(currentLabel);
        }
    }
    
    if (targetIndex != -1) {
        resultValue = (__bridge_transfer NSObject *)ABMultiValueCopyValueAtIndex(multiValueRef, targetIndex);
    }
    
    return resultValue;
}


@end
