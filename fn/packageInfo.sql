{%- set functionName = 'packageInfo' -%}
IF OBJECT_ID('[{{schemaName}}].[{{functionName}}]', 'FN') IS NOT NULL DROP FUNCTION [{{schemaName}}].[{{functionName}}]
GO
CREATE FUNCTION [{{schemaName}}].[{{functionName}}] () RETURNS nvarchar(max) AS 
BEGIN
  DECLARE @result nvarchar(max) = N'{}'
  DECLARE @package nvarchar(max) = N'{}'
  SET @package = JSON_MODIFY(@package, '$.name', '{{package.name}}')
  SET @package = JSON_MODIFY(@package, '$.version', '{{package.version}}')
  SET @result = JSON_MODIFY(@result, '$.package', JSON_QUERY(@package))

  SET @result = JSON_MODIFY(@result, '$.config', JSON_QUERY(N'{{settings | dump | safe }}'))
  RETURN @result
END
GO
