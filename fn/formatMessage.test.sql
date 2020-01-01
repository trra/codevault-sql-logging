{%- meta tables = 'tables.json' -%}
{%- meta config = 'config.json' -%}
{%- meta core = 'core.json' -%}
{%- set table = tables.records -%}
{%- set schemaName = table.schemaName if table.schemaName else config.settings.schemaName -%}
{%- set tableName = table.tableName -%}

PRINT '--- TEST FUNCTION [log].[formatMessage] ---'
DECLARE @test varchar(150) = ''
DECLARE @expect varchar(max) = ''
DECLARE @actual varchar(max) = ''

-- Test 
SET @test = 'message'
SET @expect = 'test message'
SET @actual = JSON_VALUE({{schemaName}}.formatMessage('test message'), '$.message')
PRINT '--- ' + CASE 
  WHEN @expect = @actual THEN 'PASSED' 
  ELSE 'FAILED' 
  END + ' [' + @test + ']: Expected: [' + @expect + '] Actual: [' + @actual +']'

-- Test 
SET @test = 'message object'
SET @expect = 'valid'
SET @actual = JSON_VALUE({{schemaName}}.formatMessage('{"code":"valid", "message": "test message"}'), '$.message.code')  
PRINT '--- ' + CASE 
  WHEN @expect = @actual THEN 'PASSED' 
  ELSE 'FAILED' 
  END + ' [' + @test + ']: Expected: [' + @expect + '] Actual: [' + @actual +']'

-- Test error messages
BEGIN TRY
  PRINT 1/0
END TRY
BEGIN CATCH  
-- Test
  SET @test = 'error number'
  SET @actual = JSON_VALUE({{schemaName}}.formatMessage('test error message'), '$.error.number')
  SET @expect = '8134'
  PRINT '--- ' + CASE 
    WHEN @expect = @actual THEN 'PASSED' 
    ELSE 'FAILED' 
    END + ' [' + @test + ']: Expected: [' + @expect + '] Actual: [' + @actual +']'

-- Test
  SET @test = 'error user message'
  SET @actual = JSON_VALUE({{schemaName}}.formatMessage('test error message'), '$.message')
  SET @expect = 'test error message'
  PRINT '--- ' + CASE 
    WHEN @expect = @actual THEN 'PASSED' 
    ELSE 'FAILED' 
    END + ' [' + @test + ']: Expected: [' + @expect + '] Actual: [' + @actual +']'

END CATCH
GO