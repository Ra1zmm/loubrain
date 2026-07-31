#!/usr/bin/env node
// Builds dist/loubrain.skill - the uploadable package for Claude.
//
// A .skill file is a plain ZIP whose root holds the skill folder:
//     loubrain/SKILL.md
// Entry names must use forward slashes even on Windows; a backslash entry
// extracts on macOS/Linux as one file literally named "loubrain\SKILL.md".
//
// Written with zero dependencies (Node's built-in zlib only) so anyone can
// run `node build-skill.mjs` without installing anything.

import { deflateRawSync, crc32 } from 'node:zlib';
import { mkdirSync, readFileSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = dirname(fileURLToPath(import.meta.url));

// Only SKILL.md ships. evals/ is development-only and is deliberately excluded,
// matching what the official skill packager does.
const files = [['loubrain/SKILL.md', join(root, 'skills', 'loubrain', 'SKILL.md')]];

if (typeof crc32 !== 'function') {
  console.error('This script needs Node 20.12+ (for zlib.crc32). Node version:', process.version);
  process.exit(1);
}

const local = [];
const central = [];
let offset = 0;

for (const [name, path] of files) {
  const data = readFileSync(path);
  const compressed = deflateRawSync(data);
  const nameBuf = Buffer.from(name, 'utf8');
  const crc = crc32(data);

  const lfh = Buffer.alloc(30);
  lfh.writeUInt32LE(0x04034b50, 0);   // local file header signature
  lfh.writeUInt16LE(20, 4);           // version needed
  lfh.writeUInt16LE(0, 6);            // flags
  lfh.writeUInt16LE(8, 8);            // method: deflate
  lfh.writeUInt16LE(0, 10);           // mod time
  lfh.writeUInt16LE(0x21, 12);        // mod date (2000-01-01, keeps builds reproducible)
  lfh.writeUInt32LE(crc, 14);
  lfh.writeUInt32LE(compressed.length, 18);
  lfh.writeUInt32LE(data.length, 22);
  lfh.writeUInt16LE(nameBuf.length, 26);
  lfh.writeUInt16LE(0, 28);           // extra field length
  local.push(lfh, nameBuf, compressed);

  const cdh = Buffer.alloc(46);
  cdh.writeUInt32LE(0x02014b50, 0);   // central directory signature
  cdh.writeUInt16LE(20, 4);           // version made by
  cdh.writeUInt16LE(20, 6);           // version needed
  cdh.writeUInt16LE(0, 8);
  cdh.writeUInt16LE(8, 10);
  cdh.writeUInt16LE(0, 12);
  cdh.writeUInt16LE(0x21, 14);
  cdh.writeUInt32LE(crc, 16);
  cdh.writeUInt32LE(compressed.length, 20);
  cdh.writeUInt32LE(data.length, 24);
  cdh.writeUInt16LE(nameBuf.length, 28);
  cdh.writeUInt16LE(0, 30);           // extra
  cdh.writeUInt16LE(0, 32);           // comment
  cdh.writeUInt16LE(0, 34);           // disk number
  cdh.writeUInt16LE(0, 36);           // internal attrs
  cdh.writeUInt32LE(0, 38);           // external attrs
  cdh.writeUInt32LE(offset, 42);      // offset of local header
  central.push(cdh, nameBuf);

  offset += lfh.length + nameBuf.length + compressed.length;
}

const localBuf = Buffer.concat(local);
const centralBuf = Buffer.concat(central);

const eocd = Buffer.alloc(22);
eocd.writeUInt32LE(0x06054b50, 0);    // end of central directory signature
eocd.writeUInt16LE(0, 4);
eocd.writeUInt16LE(0, 6);
eocd.writeUInt16LE(files.length, 8);
eocd.writeUInt16LE(files.length, 10);
eocd.writeUInt32LE(centralBuf.length, 12);
eocd.writeUInt32LE(localBuf.length, 16);
eocd.writeUInt16LE(0, 20);            // comment length

mkdirSync(join(root, 'dist'), { recursive: true });
const out = join(root, 'dist', 'loubrain.skill');
writeFileSync(out, Buffer.concat([localBuf, centralBuf, eocd]));

console.log(`built ${out}`);
for (const [name] of files) console.log(`  ${name}`);
