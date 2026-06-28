import { compile, createFileManager } from '@noir-lang/noir_wasm';
import fs from 'fs/promises';
import path from 'path';

async function main() {
    console.log("Compiling Noir circuit...");
    try {
        const circuitPath = path.resolve('../circuits/payroll_sum');
        
        // Use the Noir WASM compiler API with the file manager
        const fileManager = createFileManager(circuitPath);
        const compiled = await compile(fileManager, circuitPath);
        
        const outDir = path.resolve('../app');
        await fs.writeFile(path.join(outDir, 'payroll_sum.json'), JSON.stringify(compiled, null, 2));
        
        console.log("Successfully compiled circuit to app/payroll_sum.json!");
    } catch (err) {
        console.error("Failed to compile circuit:", err);
        process.exit(1);
    }
}

main();
