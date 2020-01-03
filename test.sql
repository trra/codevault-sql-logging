{%- meta package = 'package.json' -%}
{%- meta settings = 'module.context.json', objectName = 'settings' -%}
{%- meta core = 'core.json' -%}
{%- meta table = 'tables.json', objectName = 'records'  -%}
PRINT '--- codeVault package [{{package.name}}:{{package.version}}]'
SET NOCOUNT ON;

{% set _inColumns = core.internalColumns | pickBy(core.objectType.logging) | keyBy('code') -%}
{%- set schemaName = table.schemaName if table.schemaName else settings.schemaName -%}
PRINT '--- TEST FUNCTIONS ---'
{% include 'fn/formatMessage.test.sql' %}

PRINT '--- TEST PROCEDURES ---'
DECLARE @test varchar(150) = ''
DECLARE @expect varchar(max) = ''
DECLARE @actual varchar(max) = ''
{% for logLevel in settings.logLevels %}
-- Test [{{logLevel}}]
SET @test = 'info'
SET @expect = '{{logLevel}} message'
EXEC [{{schemaName}}].[{{logLevel}}] 'testSession', 'testPackage', 'testObject', @expect
SELECT TOP 1 @actual = JSON_VALUE(detail, '$.message') 
FROM [{{schemaName}}].[{{table.tableName}}] 
WHERE {{ _inColumns.sessionNo.name }} = 'testSession'
ORDER BY {{ _inColumns.createDate.name}} DESC

PRINT '--- ' + CASE 
  WHEN @expect = @actual THEN 'PASSED' 
  ELSE 'FAILED' 
  END + ' [' + @test + ']: Expected: [' + @expect + '] Actual: [' + @actual +']'

{% endfor %}
