--Post İsteği
DECLARE @Object AS INT;
DECLARE @ResponseText AS VARCHAR(8000);
DECLARE @Body AS VARCHAR(8000) = 
'{
     "service"     :    "ProductsApi",
	 "method"      :    "list",
	 "username"     :     "EBS",
	 "password"     :     "EBS",

}'  

EXEC sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
EXEC sp_OAMethod @Object, 'open', NULL, 'POST','https://www.example.com/api', 'false'

--EXEC sp_OAMethod @Object, 'setRequestHeader', null, 'Content-Type', 'application/json'
EXEC sp_OAMethod @Object, 'send', null, @body

EXEC sp_OAMethod @Object, 'responseText', @ResponseText OUTPUT
SELECT @ResponseText

EXEC sp_OADestroy @Object

--Get İsteği
create function GetHttp
(
    @url varchar(8000)      
)
returns varchar(8000)
as
BEGIN
    DECLARE @win int 
    DECLARE @hr  int 
    DECLARE @text varchar(8000)

    EXEC @hr=sp_OACreate 'WinHttp.WinHttpRequest.5.1',@win OUT 
    IF @hr <> 0 EXEC sp_OAGetErrorInfo @win

    EXEC @hr=sp_OAMethod @win, 'Open',NULL,'GET',@url,'false'
    IF @hr <> 0 EXEC sp_OAGetErrorInfo @win

    EXEC @hr=sp_OAMethod @win,'Send'
    IF @hr <> 0 EXEC sp_OAGetErrorInfo @win

    EXEC @hr=sp_OAGetProperty @win,'ResponseText',@text OUTPUT
    IF @hr <> 0 EXEC sp_OAGetErrorInfo @win

    EXEC @hr=sp_OADestroy @win 
    IF @hr <> 0 EXEC sp_OAGetErrorInfo @win 

    RETURN @text
END

select dbo.GetHttp('https://www.routingnumbers.info/api/name.json?rn=122242597')
