#!/usr/bin/env -S deno run -A

const status = await Deno.run({
  cmd: [
    "deno",
    "repl",
    "--unstable",
    "--compat",
    "--eval-file=https://deno.land/x/subshell@0.0.3-2/init.ts",
  ],
}).status();
