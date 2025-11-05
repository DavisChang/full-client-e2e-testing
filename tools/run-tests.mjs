#!/usr/bin/env node
import { $ } from 'zx';
import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';

const argv = yargs(hideBin(process.argv))
  .option('env', { alias: 'e', default: 'dev', describe: 'Environment profile' })
  .option('platform', { alias: 'p', demandOption: true, choices: ['web', 'android', 'windows', 'mac'], describe: 'Target platform' })
  .option('suite', { alias: 's', describe: 'Optional suite path override' })
  .option('user', { alias: 'u', default: 'standard', describe: 'Credential role' })
  .help()
  .parse();

const suitePath = argv.suite ?? `tests/${argv.platform}`;
const outputDir = `reports/${argv.env}-${argv.platform}-${Date.now()}`;

await $`robot --variable ENV:${argv.env} --variable PLATFORM:${argv.platform} --variable USER_ROLE:${argv.user} -d ${outputDir} ${suitePath}`;
