function wegood = checkThings
VALID_TILL = '01-Sep-2016';
today = datenum(date);
if today > datenum(VALID_TILL)
    wegood = false;
else
    wegood = true;
end