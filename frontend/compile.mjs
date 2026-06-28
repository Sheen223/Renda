import { compile } from '@noir-lang/noir_wasm';
import fs from 'fs';
import path from 'path';

// This script will compile main.nr using Noir WASM
const circuitPath = path.resolve('../circuits/payroll_sum/src/main.nr');
const code = fs.readFileSync(circuitPath, 'utf8');

try {
  console.log("Compiling Noir circuit...");
  // Assuming simple compile API for older versions or if it still works
  const result = compile(code); 
  fs.writeFileSync('circuit.json', JSON.stringify(result));
  console.log("Compiled successfully to circuit.json!");
} catch (e) {
  console.error("Failed to compile:", e);
}
