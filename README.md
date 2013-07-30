AddressbookMapping
==================

AddressbookMapping helps you fill object from ABRecordRef struct using mapping dictionary


Example of usage:

```objective-c
NSDictionary *mappingDictionary = @{
	@"firstName"  : [AddressbookMappingValue newWithPropertyID:kABPersonFirstNameProperty],
	@"middleName" : [AddressbookMappingValue newWithPropertyID:kABPersonMiddleNameProperty],
	@"lastName"   : [AddressbookMappingValue newWithPropertyID:kABPersonLastNameProperty],
	@"mobile"     : [AddressbookMappingValue newWithPropertyID:kABPersonPhoneProperty andLabel:kABPersonPhoneMobileLabel],
	@"phone"      : [AddressbookMappingValue newWithPropertyID:kABPersonPhoneProperty andNotLabel:kABPersonPhoneMobileLabel],
	@"email"      : [AddressbookMappingValue newWithPropertyID:kABPersonEmailProperty]
};
AddressbookMapping *addressbookMapping = [[AddressbookMapping alloc] initWithMappingDictionary:mappingDictionary];

ABRecordRef recordRef = ...
Contact *contact = ...

[addressbookMapping mapObject:contact fromABRecordRef:recordRef];
```
Then your contact object will have kABPersonFirstNameProperty as firstName property, kABPersonMiddleNameProperty as middleName etc..
	
iOS 6 Warning:
Note that using kABPersonFirstNameProperty and other propertyIds valid only when access granted to addressbook. In other case they will be 0.