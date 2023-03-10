/*
valstr
WARNING
This $function starts with a lowercase letter.

Description
Convert an integer into a string.

Name	Description
dest	The destination of the string.
value	The value to convert to a string.
pack (optional)	Whether to pack the destination (off by default).
Returns
This function does not return any specific values.

Examples
*/
new string[4];
new iValue = 250;
valstr(string,iValue); // string is now "250" =============================>>>>>>>>>>> very usefull
// valstr fix by Slice
stock FIX_valstr(dest[], value, bool:pack = false)
{
    // format can't handle cellmin properly
    static const cellmin_value[] = !"-2147483648";

    if (value == cellmin)
        pack && strpack(dest, cellmin_value, 12) || strunpack(dest, cellmin_value, 12);
    else
        format(dest, 12, "%d", value), pack && strpack(dest, dest, 12);
}
#define valstr FIX_valstr
/*
Notes
WARNING
Passing a high value to this function can cause the server to freeze/crash. Fixes are available. Below is a fix that can be put straight in to your script (before valstr is used anywhere). fixes.inc includes this fix.

Related Functions
strval: Convert a string into an integer.
*/
