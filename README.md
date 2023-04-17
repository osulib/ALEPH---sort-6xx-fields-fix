# Fix for sorting Marc fields starting with 6 (six-hundred group, subject description fields)
## Case
By default, Aleph sort fix fix_doc_sort in versions 18-23 does not sort fields within hundred-groups 5xx,6xx,7xx,8xx and leave fields within these groups in original order. See [https://knowledge.exlibrisgroup.com/Aleph/Knowledge_Articles/Sort_Order_of_5XX%2C_6XX%2C_7XX%2C_8XX_Fields_in_catalog_record](https://knowledge.exlibrisgroup.com/Aleph/Knowledge_Articles/Sort_Order_of_5XX%2C_6XX%2C_7XX%2C_8XX_Fields_in_catalog_record)

## Solution
If you'd still like to sort Marc 6xx fields you can use own fix `mvk_sort_6xx_fields.pl`
This script/fix sorts 6-hundred fields according their code, including indicators. Does not sort by their subfields value.

## Implementation
1. Save the file `mvk_sort_6xx_fields.pl` to your `$aleph_exe` directory, or rather: save it to some directory you use for own extension and make just a symlink to it from the $aleph_exe, like:

`#> ln -s /your_directory/mvk_sort_6xx_fields.pl  $aleph_exe/mvk_sort_6xx_fields.pl`

2. Modify the first line of this script according to your path to Aleph Perl distribution, like

`#!/exlibris/aleph/a22_1/product/bin/perl`

3. Make the file executable:

`#> chmod + mvk_sort_6xx_fields.pl`

4. check/add this fix to your `XXX01/tab/tab_fix`. The standard fix_doc_sort should precede it, like:

`
INS   fix_doc_sort
INS   mvk_sort_6xx_fields.pl
`  


## Dependencies
Aleph versions 20-23, PHP from the Aleph distribution

## Example
**Before**

65007 $$asun

655 7 $$ahandbooks

65007 $$amoon


**After fix execution (record save to server in GUI**

65007 $$asun

65007 $$amoon

655 7 $$ahandbooks
