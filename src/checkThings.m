function wegood = checkThings
VALID_TILL = '31-Dec-2016';
today = datenum(date);
if today > datenum(VALID_TILL)
    wegood = false;
else
    wegood = true;
end