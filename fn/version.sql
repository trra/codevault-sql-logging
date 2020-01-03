{%- meta package = 'package.json' -%}
{%- meta config = 'module.context.json' -%}
{%- meta core = 'core.json' -%}
{%- meta tables = 'tables.json' -%}
{%- set internalColumns = core.internalColumns | pickBy(core.objectType.logging) -%}

{%- set function = {name: 'version'} -%}
{%- set table = tables.records -%}
{%- set settings = config.settings -%}
{%- set dataTypes = config.dataTypes -%}

{%- extends "layout/_fn.sql" -%}
{%- block body %} () RETURNS nvarchar(150) AS 
BEGIN
  RETURN concat_ws(' ', '{{package.name}}', '{{package.version}}')
END
GO
{% endblock %}

{%- block test %}
PRINT '--- TEST FUNCTION [{{schemaName}}].[{{function.name}}] ---'
PRINT '--- [message]: ' + CASE 
  WHEN [{{schemaName}}].[{{function.name}}] like '{{package.name}} {{package.version}}'
  THEN 'PASSED' ELSE 'FAILED' END
GO
{% endblock %}


