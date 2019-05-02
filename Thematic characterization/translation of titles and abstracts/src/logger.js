/**
 * @overview Configures the default logger
 * Sets up winston's default logger so that it prints logs to console and to a file.
 * @author lu1sd4
 */

/**
 * @module logger
 * @description
 * Sets up the configuration values for the default instance of winston.
 * - **level**: debug
 * - **format**: colorize, timestamp, align, cli
 * - **transports**: console and file  
 * This module does not expose any members.
 * @requires winston
 * @see {@link https://github.com/winstonjs/winston#usage|winstonjs}
 */

const winston = require('winston');

/**
 * @type {string}
 * @description
 * Logfile name is the exact time of execution.  E.g. **2019-04-14T19:57:36.174Z.log**  
 * The logfile is created in the root directory of the project.
 * @alias module:logger~logFilename
 */
const logFilename = `${new Date().toISOString()}.log`;

winston.configure({
  level: 'debug',
  format: winston.format.combine(
    winston.format.colorize(),
    winston.format.timestamp(),
    winston.format.align(),
    winston.format.cli(),
  ),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: logFilename }),
  ],
});
