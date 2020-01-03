{%- meta package = 'package.json' -%}
{%- meta config = 'module.context.json' -%}
{%- meta core = 'core.json' -%}
{%- meta tables = 'tables.json' -%}
{%- set schemaName = table.records.schemaName if table.records.schemaName else config.settings.schemaName -%}
PRINT '--- codeVault package [{{package.name}}:{{package.version}}]'
IF NOT EXISTS ( SELECT 1 FROM sys.schemas WHERE name = '{{schemaName}}' ) 
  EXEC ( 'CREATE SCHEMA [{{schemaName}}] AUTHORIZATION [dbo]' );


{% set internalColumns = core.internalColumns | pickBy(core.objectType.logging) -%}
PRINT '--- CREATE TABLES ---'
{% import 'create.sql' as create -%}
{% for objectName, table in tables %}
  {%- if table.type in ['Table'] -%}
    {{ create.createTable(table, internalColumns, config.settings, core.dataTypes) }}
  {%- endif -%}
{% endfor %}

PRINT '--- CREATE FUNCTIONS ---'
{% include 'fn/version.sql' %}
{% include 'fn/packageInfo.sql' %}
{% include 'fn/formatMessage.sql' %}

PRINT '--- CREATE PROCEDURES ---'
{% for logLevel in config.settings.logLevels %}
  {%- set procedure = {name: logLevel} -%}
  {%- set table = tables.records -%}
  {{- create.spMessage(procedure, table, internalColumns, config.settings, core.dataTypes) }}
{% endfor %}

{%- meta package = 'package.json' -%}
Exec [{{schemaName}}].info 'codevault-20191231', '{{package.name}}', 'main', 'Code generation succeeded'
Exec [{{schemaName}}].info 'codevault-20191231', '{{package.name}}', 'package.json', '{{package | dump | safe}}'
Exec [{{schemaName}}].info 'codevault-20191231', '{{package.name}}', 'tables.json', '{{tables | dump | safe}}'
Exec [{{schemaName}}].info 'codevault-20191231', '{{package.name}}', 'config.json', '{{config | dump | safe}}'
Exec [{{schemaName}}].info 'codevault-20191231', '{{package.name}}', 'core.json', '{{core | dump | safe}}'
