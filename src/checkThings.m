function wegood = checkThings
VALID_TILL = '25-Dec-2014';
today = datenum(date);
if today > datenum(VALID_TILL)
    wegood = false;
else
    wegood = true;
end