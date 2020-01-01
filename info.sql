{%- set info = logging.description.info -%}
PRINT 'Function info()'
CREATE FUNCTION [{{logging.schemaName}}].[info] AS 
-- {{ info if info else 'Create info message in log table' }}
...
GO
