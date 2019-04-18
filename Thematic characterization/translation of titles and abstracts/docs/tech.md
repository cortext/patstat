## Modules

<dl>
<dt><a href="#module_index">index</a></dt>
<dd><p>Entry point for the script.<br>Loads the configuration into a globally-accessible variable and sets up the logger.<br>This module does not expose any members and is rather an entry point for setup tasks.</p>
</dd>
<dt><a href="#module_db">db</a></dt>
<dd><p>Module that exposes database-related functionality.</p>
</dd>
<dt><a href="#module_db/mysql-helper">db/mysql-helper</a></dt>
<dd><p>Module for connecting and executing database queries.<br>It is the only module that interacts directly with the database.</p>
</dd>
<dt><a href="#module_db/queries">db/queries</a></dt>
<dd><p>Constructs, stores and exposes all of the relevant SQL queries for this
script</p>
</dd>
<dt><a href="#module_db/worker">db/worker</a></dt>
<dd><p>Module that exposes the Worker class, which retrieves rows in batches from
the database from a specific index to another specific index</p>
</dd>
<dt><a href="#module_logger">logger</a></dt>
<dd><p>Sets up the configuration values for the default instance of winston.</p>
<ul>
<li><strong>level</strong>: debug</li>
<li><strong>format</strong>: colorize, timestamp, align, cli</li>
<li><strong>transports</strong>: console and file<br>This module does not expose any members.</li>
</ul>
</dd>
<dt><a href="#module_main">main</a></dt>
<dd><p>Main module of the script. Sets up and runs the translation work.<br>This module does not expose any members, it is intended to be the main unit
of execution and use the other modules.</p>
</dd>
<dt><a href="#module_reporter">reporter</a></dt>
<dd><p>Module for printing and updating status messages about the workers
during the execution of the script. It uses <a href="https://github.com/ivanseidel/node-draftlog">draftlog</a> to update the lines printed
to the console.</p>
</dd>
<dt><a href="#module_translator/adapters/deepl">translator/adapters/deepl</a></dt>
<dd><p>Adapter for the deepl service. When using deepl, we must pass the API key via
the <code>deepl-key</code> command line arg.  </p>
<pre><code>$ node index --deepl-key=&lt;our_key&gt;
</code></pre><p>or</p>
<pre><code>$ node index -k &lt;our_key&gt;
</code></pre></dd>
<dt><a href="#module_translator">translator</a></dt>
<dd><p>Module that abstracts translation service into functionalities.<br>Uses the value of config.translation.service to use one of the adapters.<br>Adapters should implement the methods exposed by this module.</p>
</dd>
</dl>

## Classes

<dl>
<dt><a href="#Worker">Worker</a></dt>
<dd></dd>
</dl>

<a name="module_index"></a>

## index
Entry point for the script.  
Loads the configuration into a globally-accessible variable and sets up the logger.  
This module does not expose any members and is rather an entry point for setup tasks.

**Requires**: [<code>logger</code>](#module_logger), [<code>main</code>](#module_main)  
<a name="module_index..config"></a>

### index~config : <code>object</code>
Configuration object loaded from the file `./config.json`  
This file must have the following structure (**not enforced in code** but the script
will fail at some point if any of the values is not provided):
```json
{
  "db": { // database-related parameters
    "connection": {
      "host": "",
      "port": "",
      "user": "",
      "password": "",
      "database": ""
    },
    "table": {
      "name": "", // name of the table for which we need to translate a column
      // name of the column by which we want to identify and sort rows
      // *if there is no index for this column in the table, this will take a VERY long time to finish
      "idColumnName": "",
      "columnToTranslate": "", // column that we want to translate
      "columnForTranslation": "" // column to store the translation
    }
  },
  "work": {
    "batchSize": 20, // size of each batch of texts to send to the translation API
    "nConcurrentWorks": 30 // number of concurrent works that will be querying, calling the API and updating the rows
  },
  "translation": {
    "service": "deepl" // name of the translation service (only deepl is supported currently)
  }
}
```

**Kind**: inner constant of [<code>index</code>](#module_index)  
<a name="module_db"></a>

## db
Module that exposes database-related functionality.

**Requires**: [<code>db/worker</code>](#module_db/worker), [<code>db/mysql-helper</code>](#module_db/mysql-helper)  

* [db](#module_db)
    * _static_
        * [.closeConnection](#module_db.closeConnection)
        * [.updateEnglishField](#module_db.updateEnglishField)
        * [.count()](#module_db.count) ⇒ <code>number</code>
        * [.nthRowIndex(n)](#module_db.nthRowIndex) ⇒
    * _inner_
        * [~Worker](#module_db..Worker) : <code>class</code>
        * [~mysql](#module_db..mysql) : <code>object</code>
        * [~dbConfig](#module_db..dbConfig) : <code>object</code>

<a name="module_db.closeConnection"></a>

### db.closeConnection
Ends the connection with the database.

**Kind**: static property of [<code>db</code>](#module_db)  
**See**: [closePool](#module_db/mysql-helper.closePool)  
<a name="module_db.updateEnglishField"></a>

### db.updateEnglishField
Updates the row identified by *id*, setting *text* as the new value for the 
field specified as `db.table.columnForTranslation` in the configuration.

**Kind**: static property of [<code>db</code>](#module_db)  
**See**: [queryUpdateEnglishField](#module_db/mysql-helper.queryUpdateEnglishField)  

| Param | Type | Description |
| --- | --- | --- |
| id | <code>string</code> | Id of the row we want to update with its translation |
| text | <code>string</code> | Translated text to add to the row |

<a name="module_db.count"></a>

### db.count() ⇒ <code>number</code>
Gets the number of rows in the table of interest.

**Kind**: static method of [<code>db</code>](#module_db)  
**Returns**: <code>number</code> - The number of rows in the table of interest  
<a name="module_db.nthRowIndex"></a>

### db.nthRowIndex(n) ⇒
Gets the value of the nth row's id column (specified in config).

**Kind**: static method of [<code>db</code>](#module_db)  
**Returns**: The value of the id column of the nth row (rows sorted by the id
column).  

| Param | Type | Description |
| --- | --- | --- |
| n | <code>number</code> | Position of the row for which we want the value of the id column. |

<a name="module_db..Worker"></a>

### db~Worker : <code>class</code>
Class for handling the batch reading of the table from a specified index to
another one.

**Kind**: inner constant of [<code>db</code>](#module_db)  
**See**: [worker](db/Worker)  
<a name="module_db..mysql"></a>

### db~mysql : <code>object</code>
Helper for several useful database queries.

**Kind**: inner constant of [<code>db</code>](#module_db)  
**See**: [mysql-helper](db/mysql-helper)  
<a name="module_db..dbConfig"></a>

### db~dbConfig : <code>object</code>
Parameters related to the table.  
Taken from the config.

**Kind**: inner constant of [<code>db</code>](#module_db)  
**See**: [index](#module_index)  
<a name="module_db/mysql-helper"></a>

## db/mysql-helper
Module for connecting and executing database queries.  
It is the only module that interacts directly with the database.

**Requires**: <code>module:mysql2/promise</code>, <code>module:winston</code>, [<code>db/queries</code>](#module_db/queries)  

* [db/mysql-helper](#module_db/mysql-helper)
    * _static_
        * [.queryNthRow(n)](#module_db/mysql-helper.queryNthRow) ⇒ <code>Promise.&lt;Array.&lt;object&gt;&gt;</code>
        * [.queryUpdateEnglishField(id, text)](#module_db/mysql-helper.queryUpdateEnglishField) ⇒ <code>Promise.&lt;Array.&lt;object&gt;&gt;</code>
        * [.queryBatchForId(id)](#module_db/mysql-helper.queryBatchForId) ⇒ <code>Promise.&lt;Array.&lt;object&gt;&gt;</code>
        * [.queryCount()](#module_db/mysql-helper.queryCount) ⇒ <code>Promise.&lt;Array.&lt;object&gt;&gt;</code>
        * [.closePool()](#module_db/mysql-helper.closePool)
    * _inner_
        * [~mysql](#module_db/mysql-helper..mysql) : <code>object</code>
        * [~logger](#module_db/mysql-helper..logger) : <code>object</code>
        * [~queries](#module_db/mysql-helper..queries) : <code>object</code>
        * [~poolConfig](#module_db/mysql-helper..poolConfig) : <code>object</code>
        * [~pool](#module_db/mysql-helper..pool) : <code>Pool</code>
        * [~runQuery(queryString, queryParams)](#module_db/mysql-helper..runQuery) ⇒ <code>Promise.&lt;Array.&lt;object&gt;&gt;</code>

<a name="module_db/mysql-helper.queryNthRow"></a>

### db/mysql-helper.queryNthRow(n) ⇒ <code>Promise.&lt;Array.&lt;object&gt;&gt;</code>
Queries the `n`th row of the table specified in the configuration ordered by
the id column also specified in the configuration.
Returns the result of 
[queries.queryNthRow](module:db/queries.queryNthRow) when called with
`n - 1`.

**Kind**: static method of [<code>db/mysql-helper</code>](#module_db/mysql-helper)  
**Returns**: <code>Promise.&lt;Array.&lt;object&gt;&gt;</code> - Result of the query as an array of rows  

| Param | Type | Description |
| --- | --- | --- |
| n | <code>number</code> | Position of the row we want. |

<a name="module_db/mysql-helper.queryUpdateEnglishField"></a>

### db/mysql-helper.queryUpdateEnglishField(id, text) ⇒ <code>Promise.&lt;Array.&lt;object&gt;&gt;</code>
Sets `text` as the new value for the column specified in the configuration,
in the row identified by `id`.
Returns the result of 
[queries.queryUpdateEnglishField](module:db/queries.queryUpdateEnglishField)
when called with `text` and `id`.

**Kind**: static method of [<code>db/mysql-helper</code>](#module_db/mysql-helper)  
**Returns**: <code>Promise.&lt;Array.&lt;object&gt;&gt;</code> - Result of the query as an array of rows  

| Param | Type | Description |
| --- | --- | --- |
| id | <code>string</code> | Value of the id column of the row to update. |
| text | <code>string</code> | Translated text to add to the row. |

<a name="module_db/mysql-helper.queryBatchForId"></a>

### db/mysql-helper.queryBatchForId(id) ⇒ <code>Promise.&lt;Array.&lt;object&gt;&gt;</code>
Returns the result of 
[queries.queryIdOffset](module:db/queries.queryIdOffset)
when called with `id`. **I. e.** `config.work.batchSize` rows, starting from the
`id`th.

**Kind**: static method of [<code>db/mysql-helper</code>](#module_db/mysql-helper)  
**Returns**: <code>Promise.&lt;Array.&lt;object&gt;&gt;</code> - Result of the query as an array of rows  

| Param | Type | Description |
| --- | --- | --- |
| id | <code>string</code> | Value of the id column of the first row of the batch |

<a name="module_db/mysql-helper.queryCount"></a>

### db/mysql-helper.queryCount() ⇒ <code>Promise.&lt;Array.&lt;object&gt;&gt;</code>
Gets the number of rows in the table of interest.  
Returns the result of 
[queries.queryCount](module:db/queries.queryCount)

**Kind**: static method of [<code>db/mysql-helper</code>](#module_db/mysql-helper)  
**Returns**: <code>Promise.&lt;Array.&lt;object&gt;&gt;</code> - Result of the query as an array of rows  
<a name="module_db/mysql-helper.closePool"></a>

### db/mysql-helper.closePool()
Ends all the connections opened by the 
[pool](#module_db/mysql-helper..pool).

**Kind**: static method of [<code>db/mysql-helper</code>](#module_db/mysql-helper)  
<a name="module_db/mysql-helper..mysql"></a>

### db/mysql-helper~mysql : <code>object</code>
Promise-wrapped MySQL client library

**Kind**: inner constant of [<code>db/mysql-helper</code>](#module_db/mysql-helper)  
**See**

- [Promise - Javascript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)
- [mysql2/promise](https://github.com/sidorares/node-mysql2#using-promise-wrapper)

<a name="module_db/mysql-helper..logger"></a>

### db/mysql-helper~logger : <code>object</code>
Reference to the default logger.

**Kind**: inner constant of [<code>db/mysql-helper</code>](#module_db/mysql-helper)  
**See**: [logger](#module_logger)  
<a name="module_db/mysql-helper..queries"></a>

### db/mysql-helper~queries : <code>object</code>
SQL query strings relevant to the script, constructed with values specified
in the `table` field of the configuration and placeholders to allow the use
of prepared statements.

**Kind**: inner constant of [<code>db/mysql-helper</code>](#module_db/mysql-helper)  
**See**

- [db/queries](#module_db/queries)
- [index](#module_index)

<a name="module_db/mysql-helper..poolConfig"></a>

### db/mysql-helper~poolConfig : <code>object</code>
Settings for the creation of the database connection pool, some are taken
from the global configuration and others are left as sensible defaults.

**Kind**: inner constant of [<code>db/mysql-helper</code>](#module_db/mysql-helper)  
**See**: [index](#module_index)  
<a name="module_db/mysql-helper..pool"></a>

### db/mysql-helper~pool : <code>Pool</code>
Database connection pool created from the configuration values specified in
[poolConfig](#module_db/mysql-helper..poolConfig).

**Kind**: inner constant of [<code>db/mysql-helper</code>](#module_db/mysql-helper)  
<a name="module_db/mysql-helper..runQuery"></a>

### db/mysql-helper~runQuery(queryString, queryParams) ⇒ <code>Promise.&lt;Array.&lt;object&gt;&gt;</code>
Executes a sql query with placeholders and values for each one of them,
using one of the connections from the [pool](#module_db/mysql-helper..pool).  
Releases the connection once the result is ready.

**Kind**: inner method of [<code>db/mysql-helper</code>](#module_db/mysql-helper)  
**Returns**: <code>Promise.&lt;Array.&lt;object&gt;&gt;</code> - Result of the query  

| Param | Type | Description |
| --- | --- | --- |
| queryString | <code>string</code> | SQL query to be executed |
| queryParams | <code>Array.&lt;string&gt;</code> | Parameters for the query's placeholders |

<a name="module_db/queries"></a>

## db/queries
Constructs, stores and exposes all of the relevant SQL queries for this
script


* [db/queries](#module_db/queries)
    * [~name](#module_db/queries..name) : <code>string</code>
    * [~idColumnName](#module_db/queries..idColumnName) : <code>string</code>
    * [~columnToTranslate](#module_db/queries..columnToTranslate) : <code>string</code>
    * [~columnForTranslation](#module_db/queries..columnForTranslation) : <code>string</code>
    * [~batchSize](#module_db/queries..batchSize) : <code>string</code>
    * [~config](#module_db/queries..config) : <code>object</code>
    * [~queryNthRow](#module_db/queries..queryNthRow) : <code>string</code>
    * [~queryIdOffset](#module_db/queries..queryIdOffset) : <code>string</code>
    * [~queryUpdateEnglishField](#module_db/queries..queryUpdateEnglishField) : <code>string</code>
    * [~queryCount](#module_db/queries..queryCount) : <code>string</code>

<a name="module_db/queries..name"></a>

### db/queries~name : <code>string</code>
Name of the table of interest.  
Taken from [config](#module_db/queries..config).

**Kind**: inner property of [<code>db/queries</code>](#module_db/queries)  
<a name="module_db/queries..idColumnName"></a>

### db/queries~idColumnName : <code>string</code>
Name of the column by which we want to sort and identify the rows.  
Taken from [config](#module_db/queries..config).  
**If the table is not indexed by this column, the script will take a
VERY LONG time to run**

**Kind**: inner property of [<code>db/queries</code>](#module_db/queries)  
<a name="module_db/queries..columnToTranslate"></a>

### db/queries~columnToTranslate : <code>string</code>
Name of the column with the text that we want to translate.  
Taken from [config](#module_db/queries..config).

**Kind**: inner property of [<code>db/queries</code>](#module_db/queries)  
<a name="module_db/queries..columnForTranslation"></a>

### db/queries~columnForTranslation : <code>string</code>
Name of the column where we want to add the translation.  
Taken from [config](#module_db/queries..config).

**Kind**: inner property of [<code>db/queries</code>](#module_db/queries)  
<a name="module_db/queries..batchSize"></a>

### db/queries~batchSize : <code>string</code>
Number of rows we want to read, translate and update during one iteration
of work.  
Taken from [config](#module_db/queries..config).

**Kind**: inner property of [<code>db/queries</code>](#module_db/queries)  
<a name="module_db/queries..config"></a>

### db/queries~config : <code>object</code>
Global config

**Kind**: inner constant of [<code>db/queries</code>](#module_db/queries)  
**See**: [index](#module_index)  
<a name="module_db/queries..queryNthRow"></a>

### db/queries~queryNthRow : <code>string</code>
String of a query that gets the nth row, with the table being ordered
according to [idColumnName](#module_db/queries..idColumnName).

**Kind**: inner constant of [<code>db/queries</code>](#module_db/queries)  
<a name="module_db/queries..queryIdOffset"></a>

### db/queries~queryIdOffset : <code>string</code>
String of a query that gets [batchSize](#module_db/queries..batchSize)
rows starting from the row with the specified index, with the table being 
ordered according to [idColumnName](#module_db/queries..idColumnName).

**Kind**: inner constant of [<code>db/queries</code>](#module_db/queries)  
<a name="module_db/queries..queryUpdateEnglishField"></a>

### db/queries~queryUpdateEnglishField : <code>string</code>
String of a query that sets the first placeholder as the value for
[columnForTranslation](#module_db/queries..columnForTranslation)
in the row where [idColumnName](#module_db/queries..idColumnName)'s value
equals the second placeholder.

**Kind**: inner constant of [<code>db/queries</code>](#module_db/queries)  
<a name="module_db/queries..queryCount"></a>

### db/queries~queryCount : <code>string</code>
String of a query that returns the number of rows in the 
[table of interest](#module_db/queries..name).

**Kind**: inner constant of [<code>db/queries</code>](#module_db/queries)  
<a name="module_db/worker"></a>

## db/worker
Module that exposes the Worker class, which retrieves rows in batches from
the database from a specific index to another specific index

**Requires**: [<code>db/mysql-helper</code>](#module_db/mysql-helper), <code>module:winston</code>  

* [db/worker](#module_db/worker)
    * [~id](#module_db/worker..id) : <code>number</code>
    * [~logger](#module_db/worker..logger) : <code>object</code>
    * [~mysql](#module_db/worker..mysql) : <code>object</code>

<a name="module_db/worker..id"></a>

### db/worker~id : <code>number</code>
Counter to give an id to every [Worker](#Worker)
instance created

**Kind**: inner property of [<code>db/worker</code>](#module_db/worker)  
<a name="module_db/worker..logger"></a>

### db/worker~logger : <code>object</code>
Reference to the default logger.

**Kind**: inner constant of [<code>db/worker</code>](#module_db/worker)  
**See**: [logger](#module_logger)  
<a name="module_db/worker..mysql"></a>

### db/worker~mysql : <code>object</code>
Helper for several useful database queries.

**Kind**: inner constant of [<code>db/worker</code>](#module_db/worker)  
**See**: [mysql-helper](db/mysql-helper)  
<a name="module_logger"></a>

## logger
Sets up the configuration values for the default instance of winston.
- **level**: debug
- **format**: colorize, timestamp, align, cli
- **transports**: console and file  
This module does not expose any members.

**Requires**: <code>{@link https://www.npmjs.com/package/winston\|winston}</code>  
**See**: [winstonjs](https://github.com/winstonjs/winston#usage)  
<a name="module_logger..logFilename"></a>

### logger~logFilename : <code>string</code>
Logfile name is the exact time of execution.  E.g. **2019-04-14T19:57:36.174Z.log**  
The logfile is created in the root directory of the project.

**Kind**: inner constant of [<code>logger</code>](#module_logger)  
<a name="module_main"></a>

## main
Main module of the script. Sets up and runs the translation work.  
This module does not expose any members, it is intended to be the main unit
of execution and use the other modules.

**Requires**: <code>{@link https://www.npmjs.com/package/winston\|winston}</code>, [<code>db</code>](#module_db), [<code>translator</code>](#module_translator), [<code>reporter</code>](#module_reporter)  

* [main](#module_main)
    * [~columnToTranslate](#module_main..columnToTranslate) : <code>string</code>
    * [~nConcurrentWorks](#module_main..nConcurrentWorks) : <code>string</code>
    * [~batchSize](#module_main..batchSize) : <code>string</code>
    * [~nRows](#module_main..nRows) : <code>string</code>
    * [~logger](#module_main..logger) : <code>object</code>
    * [~db](#module_main..db) : <code>object</code>
    * [~translator](#module_main..translator) : <code>object</code>
    * [~reporter](#module_main..reporter) : <code>object</code>
    * [~config](#module_main..config) : <code>object</code>
    * [~workers](#module_main..workers) : [<code>Array.&lt;Worker&gt;</code>](#Worker)
    * [~done()](#module_main..done)
    * [~doWork(from, to, intervalSize)](#module_main..doWork)
    * [~updateReport()](#module_main..updateReport)
    * [~setupWork()](#module_main..setupWork)
    * [~init()](#module_main..init)

<a name="module_main..columnToTranslate"></a>

### main~columnToTranslate : <code>string</code>
Name of the column whose values we want to translate.  
Taken from the [config](#module_main..config).

**Kind**: inner property of [<code>main</code>](#module_main)  
<a name="module_main..nConcurrentWorks"></a>

### main~nConcurrentWorks : <code>string</code>
Number of concurrent workers to split the work.
Taken from the [config](#module_main..config).  
**Do not confuse with Node.js Worker Threads.**

**Kind**: inner property of [<code>main</code>](#module_main)  
<a name="module_main..batchSize"></a>

### main~batchSize : <code>string</code>
Size of batches. Every service call and db query made by each worker will
take into account this value.  
Taken from the [config](#module_main..config).

**Kind**: inner property of [<code>main</code>](#module_main)  
<a name="module_main..nRows"></a>

### main~nRows : <code>string</code>
Total number of rows to translate. This value should be the same as the size
of the table we want to translate.
These rows will divided so that 
[nConcurrentWorks](#module_main..nConcurrentWorks) tasks are created,
each one consisting in the translation of an equal amount of rows.

**Kind**: inner property of [<code>main</code>](#module_main)  
<a name="module_main..logger"></a>

### main~logger : <code>object</code>
Reference to the default logger.

**Kind**: inner constant of [<code>main</code>](#module_main)  
**See**: [logger](#module_logger)  
<a name="module_main..db"></a>

### main~db : <code>object</code>
Object for interacting with the database

**Kind**: inner constant of [<code>main</code>](#module_main)  
**See**: [db](#module_db)  
<a name="module_main..translator"></a>

### main~translator : <code>object</code>
Object for interacting with the translation service

**Kind**: inner constant of [<code>main</code>](#module_main)  
**See**: [translator](#module_translator)  
<a name="module_main..reporter"></a>

### main~reporter : <code>object</code>
Object for reporting the work progress in the console

**Kind**: inner constant of [<code>main</code>](#module_main)  
**See**: [reporter](#module_reporter)  
<a name="module_main..config"></a>

### main~config : <code>object</code>
Configuration values taken from the global variable.

**Kind**: inner constant of [<code>main</code>](#module_main)  
**See**: [index](#module_index)  
<a name="module_main..workers"></a>

### main~workers : [<code>Array.&lt;Worker&gt;</code>](#Worker)
Array holding references to the workers. These are the
ones in charge of querying the database.

**Kind**: inner constant of [<code>main</code>](#module_main)  
**See**: [Worker](#Worker)  
<a name="module_main..done"></a>

### main~done()
Closes the database connection so that the program can 
exit successfully (if we keep the connection open it 
keeps hanging)

**Kind**: inner method of [<code>main</code>](#module_main)  
<a name="module_main..doWork"></a>

### main~doWork(from, to, intervalSize)
Does the fraction of the work consisting on reading, translating and updating
the rows with indexes between *from* and *to*, in batches of *batchSize*
rows.  
Updates to the *batchSize* rows are done concurrently, but the script does
not begin working on a batch until the work with the previous batch has
finished.  
Also registers the corresponding worker with the reporter so that its 
progress is printed and updated in the console.  
Its completion does not depend on other external updates to the status of the
program, thus, several calls to this function can run concurrently. The
amount of concurrent calls to this function is determined by 
[nConcurrentWorks](#module_main..nConcurrentWorks).

**Kind**: inner method of [<code>main</code>](#module_main)  
**See**

- [setupWork](#module_main..setupWork)
- [Worker](#Worker)


| Param | Type | Description |
| --- | --- | --- |
| from | <code>number</code> | index from which the worker will start its queries |
| to | <code>number</code> | index where the worker should stop querying |
| intervalSize | <code>number</code> | number of rows the worker should read |

<a name="module_main..updateReport"></a>

### main~updateReport()
Updates the output of the reporter with the current status of the workers.

**Kind**: inner method of [<code>main</code>](#module_main)  
<a name="module_main..setupWork"></a>

### main~setupWork()
Splits the work in [nConcurrentWorks](#module_main..nConcurrentWorks),
calculating the size of the work intervals and querying the left and right 
indexes for them.  
Initializes the reporter and starts the sub-works corresponding to the
intervals.  
Once the work is done, clears the reporter and ends the database connection.  
If the work is not completed, fails accordingly and ends the program.

**Kind**: inner method of [<code>main</code>](#module_main)  
<a name="module_main..init"></a>

### main~init()
Initializes the script

**Kind**: inner method of [<code>main</code>](#module_main)  
<a name="module_reporter"></a>

## reporter
Module for printing and updating status messages about the workers
during the execution of the script. It uses [draftlog](https://github.com/ivanseidel/node-draftlog) to update the lines printed
to the console.

**See**: [draftlog](https://github.com/ivanseidel/node-draftlog)  

* [reporter](#module_reporter)
    * _static_
        * [.init(totalRows)](#module_reporter.init)
        * [.addWorker(worker)](#module_reporter.addWorker)
        * [.update(workers)](#module_reporter.update)
    * _inner_
        * [~startTime](#module_reporter..startTime) : <code>number</code>
        * [~totalRows](#module_reporter..totalRows) : <code>number</code>
        * [~logLines](#module_reporter..logLines) : <code>object</code>
        * [~makeWorkerIdentifier(workerId)](#module_reporter..makeWorkerIdentifier) ⇒ <code>string</code>
        * [~makeTotalRowsMessage(rowsProcessed)](#module_reporter..makeTotalRowsMessage) ⇒ <code>string</code>
        * [~makeTotalRowsMessage(minutes, seconds)](#module_reporter..makeTotalRowsMessage) ⇒ <code>string</code>
        * [~makeTotalRowsMessage(rowsPerSecond)](#module_reporter..makeTotalRowsMessage) ⇒ <code>string</code>
        * [~makeWorkerProgressMessage(status)](#module_reporter..makeWorkerProgressMessage) ⇒ <code>string</code>

<a name="module_reporter.init"></a>

### reporter.init(totalRows)
Initializes the reporter module, prints the lines for the initial
overall values of the report (mostly zeros).

**Kind**: static method of [<code>reporter</code>](#module_reporter)  

| Param | Type | Description |
| --- | --- | --- |
| totalRows | <code>number</code> | Total number of rows to read |

<a name="module_reporter.addWorker"></a>

### reporter.addWorker(worker)
Adds a key-value pair to [logLines](#module_reporter..logLines) in which the key
is the result of [makeWorkerIdentifier](#module_reporter..makeWorkerIdentifier)
and the value is a function for updating the message that indicates the status of the
progress of the worker.
The result of [makeWorkerProgressMessage](#module_reporter..makeWorkerProgressMessage)
is printed to console and is easily updatable with the function saved in [logLines](#module_reporter..logLines)

**Kind**: static method of [<code>reporter</code>](#module_reporter)  
**See**: [draftlog](https://github.com/ivanseidel/node-draftlog)  

| Param | Type | Description |
| --- | --- | --- |
| worker | <code>db/Worker</code> | The worker for which a message will be printed and kept track of for updating |

<a name="module_reporter.update"></a>

### reporter.update(workers)
Updates the following report messages:
- Each worker.
- Time elapsed.
- Overall progress.
- Rows per second (Performance).

Using the data received from the workers to update the measurements.

**Kind**: static method of [<code>reporter</code>](#module_reporter)  

| Param | Type | Description |
| --- | --- | --- |
| workers | <code>Array.&lt;db/Worker&gt;</code> | An array containing the workers |

<a name="module_reporter..startTime"></a>

### reporter~startTime : <code>number</code>
Stores the exact moment when the reporter was initialized.
This should be just when the work starts.

**Kind**: inner property of [<code>reporter</code>](#module_reporter)  
<a name="module_reporter..totalRows"></a>

### reporter~totalRows : <code>number</code>
The amount of rows to be read.
We can have it here because it does not change during the work.

**Kind**: inner property of [<code>reporter</code>](#module_reporter)  
<a name="module_reporter..logLines"></a>

### reporter~logLines : <code>object</code>
Keeps track of the lines containing messages that will be updated

**Kind**: inner constant of [<code>reporter</code>](#module_reporter)  
<a name="module_reporter..makeWorkerIdentifier"></a>

### reporter~makeWorkerIdentifier(workerId) ⇒ <code>string</code>
Concatenates the word 'worker', a space and the worker's id.

**Kind**: inner method of [<code>reporter</code>](#module_reporter)  
**Returns**: <code>string</code> - A string which contains the word 'worker', a space and the worker's
id in that order.  

| Param | Type | Description |
| --- | --- | --- |
| workerId | <code>string</code> | The id of a worker |

<a name="module_reporter..makeTotalRowsMessage"></a>

### reporter~makeTotalRowsMessage(rowsProcessed) ⇒ <code>string</code>
Composes a message that indicates the overall progress of the work

**Kind**: inner method of [<code>reporter</code>](#module_reporter)  
**Returns**: <code>string</code> - A string that indicates the overall progress in terms of the rows
that have been read and [totalRows](#module_reporter..totalRows)  

| Param | Type | Description |
| --- | --- | --- |
| rowsProcessed | <code>number</code> | Number of rows that have been read |

<a name="module_reporter..makeTotalRowsMessage"></a>

### reporter~makeTotalRowsMessage(minutes, seconds) ⇒ <code>string</code>
Composes a message with the minutes and seconds that the work
has been running

**Kind**: inner method of [<code>reporter</code>](#module_reporter)  
**Returns**: <code>string</code> - A string that indicates the elapsed time  

| Param | Type | Description |
| --- | --- | --- |
| minutes | <code>number</code> | Number of minutes elapsed since the script began reading rows |
| seconds | <code>number</code> | Number of seconds belonging to the current minute |

<a name="module_reporter..makeTotalRowsMessage"></a>

### reporter~makeTotalRowsMessage(rowsPerSecond) ⇒ <code>string</code>
Composes a message with the word 'Performance' and the rows that
are being processed each second

**Kind**: inner method of [<code>reporter</code>](#module_reporter)  
**Returns**: <code>string</code> - A string of the form 'Performance <rows_per_second>/s'  

| Param | Type | Description |
| --- | --- | --- |
| rowsPerSecond | <code>number</code> | A measure of how many rows are being processed each second |

<a name="module_reporter..makeWorkerProgressMessage"></a>

### reporter~makeWorkerProgressMessage(status) ⇒ <code>string</code>
Composes a formatted message to describe the progress of a worker

**Kind**: inner method of [<code>reporter</code>](#module_reporter)  
**Returns**: <code>string</code> - The formatted message describing the worker's progress  

| Param | Type | Description |
| --- | --- | --- |
| status | <code>db/Worker~WorkerStatus</code> | The status of a worker |

<a name="module_translator/adapters/deepl"></a>

## translator/adapters/deepl
Adapter for the deepl service. When using deepl, we must pass the API key via
the `deepl-key` command line arg.  
```
$ node index --deepl-key=<our_key>
```
or

```
$ node index -k <our_key>
```


* [translator/adapters/deepl](#module_translator/adapters/deepl)
    * _static_
        * [.batchTranslate(texts)](#module_translator/adapters/deepl.batchTranslate) ⇒ <code>Array.&lt;string&gt;</code>
    * _inner_
        * [~logger](#module_translator/adapters/deepl..logger) : <code>object</code>
        * [~clArgs](#module_translator/adapters/deepl..clArgs) : <code>object</code>
        * [~deepl](#module_translator/adapters/deepl..deepl) : <code>object</code>
        * [~targetLanguage](#module_translator/adapters/deepl..targetLanguage) : <code>string</code>
        * [~clOptionDefinitions](#module_translator/adapters/deepl..clOptionDefinitions) : <code>object</code>
        * [~clOptions](#module_translator/adapters/deepl..clOptions) : <code>object</code>
        * [~key](#module_translator/adapters/deepl..key) : <code>object</code>

<a name="module_translator/adapters/deepl.batchTranslate"></a>

### translator/adapters/deepl.batchTranslate(texts) ⇒ <code>Array.&lt;string&gt;</code>
Implementation of [translator.batchTranslate](#module_translator.batchTranslate)
using the deepl client library.

**Kind**: static method of [<code>translator/adapters/deepl</code>](#module_translator/adapters/deepl)  
**Returns**: <code>Array.&lt;string&gt;</code> - Array of translated texts. Each item is the
translation of the item in the same position of the input array.  

| Param | Type | Description |
| --- | --- | --- |
| texts | <code>Array.&lt;string&gt;</code> | Array of texts to translate |

<a name="module_translator/adapters/deepl..logger"></a>

### translator/adapters/deepl~logger : <code>object</code>
Reference to the default logger.

**Kind**: inner constant of [<code>translator/adapters/deepl</code>](#module_translator/adapters/deepl)  
**See**: [logger](#module_logger)  
<a name="module_translator/adapters/deepl..clArgs"></a>

### translator/adapters/deepl~clArgs : <code>object</code>
Parser for command line arguments

**Kind**: inner constant of [<code>translator/adapters/deepl</code>](#module_translator/adapters/deepl)  
**See**: [command-line-args](https://www.npmjs.com/package/command-line-args)  
<a name="module_translator/adapters/deepl..deepl"></a>

### translator/adapters/deepl~deepl : <code>object</code>
Deepl client library

**Kind**: inner constant of [<code>translator/adapters/deepl</code>](#module_translator/adapters/deepl)  
<a name="module_translator/adapters/deepl..targetLanguage"></a>

### translator/adapters/deepl~targetLanguage : <code>string</code>
Code for the translation target language

**Kind**: inner constant of [<code>translator/adapters/deepl</code>](#module_translator/adapters/deepl)  
<a name="module_translator/adapters/deepl..clOptionDefinitions"></a>

### translator/adapters/deepl~clOptionDefinitions : <code>object</code>
Definition of command line parameters

**Kind**: inner constant of [<code>translator/adapters/deepl</code>](#module_translator/adapters/deepl)  
<a name="module_translator/adapters/deepl..clOptions"></a>

### translator/adapters/deepl~clOptions : <code>object</code>
Values of command line parameters passed to the program

**Kind**: inner constant of [<code>translator/adapters/deepl</code>](#module_translator/adapters/deepl)  
<a name="module_translator/adapters/deepl..key"></a>

### translator/adapters/deepl~key : <code>object</code>
Value of the 'deepl-key' command line parameter. If not present, the API 
cannot be used.

**Kind**: inner constant of [<code>translator/adapters/deepl</code>](#module_translator/adapters/deepl)  
<a name="module_translator"></a>

## translator
Module that abstracts translation service into functionalities.  
Uses the value of config.translation.service to use one of the adapters.  
Adapters should implement the methods exposed by this module.


* [translator](#module_translator)
    * _static_
        * [.batchTranslate(texts)](#module_translator.batchTranslate) ⇒ <code>Array.&lt;string&gt;</code>
    * _inner_
        * [~service](#module_translator..service) : <code>object</code>
        * [~config](#module_translator..config) : <code>object</code>
        * [~translationService](#module_translator..translationService) : <code>string</code>

<a name="module_translator.batchTranslate"></a>

### translator.batchTranslate(texts) ⇒ <code>Array.&lt;string&gt;</code>
Translates an array of texts.

**Kind**: static method of [<code>translator</code>](#module_translator)  
**Returns**: <code>Array.&lt;string&gt;</code> - Array of translated texts. Each item is the
translation of the item in the same position of the input array.  

| Param | Type | Description |
| --- | --- | --- |
| texts | <code>Array.&lt;string&gt;</code> | Array of texts to translate |

<a name="module_translator..service"></a>

### translator~service : <code>object</code>
Holds the reference to the translation adapter which is the one that should
directly interact with the service API.

**Kind**: inner property of [<code>translator</code>](#module_translator)  
<a name="module_translator..config"></a>

### translator~config : <code>object</code>
Global config

**Kind**: inner constant of [<code>translator</code>](#module_translator)  
**See**: [index](#module_index)  
<a name="module_translator..translationService"></a>

### translator~translationService : <code>string</code>
Name or key for the translation service.  
Taken from [config](#module_translator..config).

**Kind**: inner constant of [<code>translator</code>](#module_translator)  
**See**: [index](#module_index)  
<a name="Worker"></a>

## Worker
**Kind**: global class  

* [Worker](#Worker)
    * [new Worker(leftIndex, rightIndex, stepSize, totalRows)](#new_Worker_new)
    * _instance_
        * [.getRecords()](#Worker+getRecords) ⇒ <code>Promise.&lt;Array.&lt;object&gt;&gt;</code>
        * [.getStatus()](#Worker+getStatus) ⇒ [<code>WorkerStatus</code>](#Worker..WorkerStatus)
    * _inner_
        * [~WorkerStatus](#Worker..WorkerStatus) : <code>Object</code>

<a name="new_Worker_new"></a>

### new Worker(leftIndex, rightIndex, stepSize, totalRows)
Class representing a Worker


| Param | Type | Description |
| --- | --- | --- |
| leftIndex | <code>number</code> | The id of the first row this worker should retrieve |
| rightIndex | <code>number</code> | The id of the last row this worker should retrieve |
| stepSize | <code>number</code> | How many rows should this worker retrieve per query |
| totalRows | <code>number</code> | How many rows should this worker retrieve in total |

<a name="Worker+getRecords"></a>

### worker.getRecords() ⇒ <code>Promise.&lt;Array.&lt;object&gt;&gt;</code>
Get next batch of rows.  
Retrieves the next page of rows from the database, according to the
current value of [module:db/worker.Worker.leftIndex](module:db/worker.Worker.leftIndex) and updates it
to the index where the next page should start.  
If the new value of leftIndex is greater than or equal to the rightIndex,
it means the worker went through all the rows it was supposed to read.

**Kind**: instance method of [<code>Worker</code>](#Worker)  
**Returns**: <code>Promise.&lt;Array.&lt;object&gt;&gt;</code> - Next batch of rows  
<a name="Worker+getStatus"></a>

### worker.getStatus() ⇒ [<code>WorkerStatus</code>](#Worker..WorkerStatus)
Summarizes some attributes for reporting in a [WorkerStatus](#Worker..WorkerStatus) object

**Kind**: instance method of [<code>Worker</code>](#Worker)  
**Returns**: [<code>WorkerStatus</code>](#Worker..WorkerStatus) - Current status of the worker  
<a name="Worker..WorkerStatus"></a>

### Worker~WorkerStatus : <code>Object</code>
**Kind**: inner typedef of [<code>Worker</code>](#Worker)  
**Properties**

| Name | Type | Description |
| --- | --- | --- |
| id | <code>string</code> | Worker id |
| left | <code>string</code> | Index where this worker started |
| right | <code>string</code> | Index where this worker will stop |
| rowsProcessed | <code>string</code> | Rows this worker has read so far |
| totalRows | <code>string</code> | Approximate number of rows this worker should read |

