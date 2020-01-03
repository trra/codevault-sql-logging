{%- meta package = 'package.json' -%}
{%- meta config = 'module.context.json' -%}
{%- meta core = 'core.json' -%}
{%- meta tables = 'tables.json' -%}
{%- set internalColumns = core.internalColumns | pickBy(core.objectType.logging) -%}

{%- set function = {name: 'packageInfo'} -%}
{%- set table = tables.records -%}
{%- set settings = config.settings -%}
{%- set dataTypes = config.dataTypes -%}

{%- extends "layout/_fn.sql" -%}
{%- block body %} () RETURNS nvarchar(max) AS 
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
{% endblock %}



