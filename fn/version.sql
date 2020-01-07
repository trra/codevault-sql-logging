{%- set functionName = 'version' -%}
IF OBJECT_ID('[{{schemaName}}].[{{functionName}}]', 'FN') IS NOT NULL DROP FUNCTION [{{schemaName}}].[{{functionName}}]
GO
CREATE FUNCTION [{{schemaName}}].[{{functionName}}] () RETURNS nvarchar(150) AS 
BEGIN
  RETURN concat_ws(' ', '{{package.name}}', '{{package.version}}')
END
GO
