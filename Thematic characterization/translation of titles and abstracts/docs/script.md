# Translation script

To get the translation done, we needed to get the texts from the database
tables, send them to a translation service and update the tables with the
results.

A script that makes such tasks was written on Node.js.
[Deepl](https://www.deepl.com/home) was used as translation service.

## Translating a table

Translating a table implies:

- For each row:

  1. Read the text that needs to be translated.
  2. Send this text to the service in order to get its translation.
  3. Save the translation in the corresponding row of the database.

## Script outline

Here is an outline of what this script does:

1. Gets parameters for connecting to the database (among other things) from a
   configuration file.
2. Splits up the work (all of the table rows) into intervals.
3. Simultaneously (concurrently) works on translating all of the intervals. The
   algorithm for **working** on an interval consists in:
   1. Getting the next batch of rows.
   2. Calling the translation service's API with the rows' texts.
   3. Updating each row with the resulting translations.
   4. If the interval is not finished, go to step 1.
4. Closes the database connection.

It is built on [Node.js](https://nodejs.org)

## Running the script

### Installing Node.js

It is recommended to run this using Node.js 10.15.

The simplest way to install Node.js is going to [the official download
page](https://nodejs.org/en/download/) and following the instructions for your
operating system.

You can verify if you have it running `node -v`. Its output should be something
like:

```
v10.15.1
```

### Installing dependencies

Once Node.js is installed, assuming you are on the root folder of the project,
run:

```
$ npm install
```

This will install the necessary libraries to run the script.

### Running the script

You must provide the script with your key for the deepl service. Run:

```
$ node index -k <deepl key>
```

And the script should start