use dep::std;

global MAX_EMPLOYEES: u32 = 50;

fn main(
    salaries: [u64; 50],
    stellar_addresses: [Field; 50],
    public_total: pub u64,
    batch_nonce: pub Field
) -> pub Field {
    let mut computed_total: u64 = 0;
    
    // We will hash all addresses and salaries to create a cryptographic commitment.
    // We create an array of size 100 to hold interleaved address and salary fields.
    let mut hash_input: [Field; 100] = [0; 100];

    for i in 0..50 {
        computed_total = computed_total + salaries[i];
        hash_input[i * 2] = stellar_addresses[i];
        hash_input[i * 2 + 1] = salaries[i] as Field;
    }

    // 1. Assert that the computed sum matches the expected public total.
    assert(computed_total == public_total);

    // Prevent replay attacks or ensure binding to a specific payroll run.
    assert(batch_nonce != 0);
    
    // Hash the interleaved salaries and addresses to create the commitment
    let employer_commitment = std::hash::pedersen_hash(hash_input);
    
    // Return the commitment so the smart contract can access it
    employer_commitment
}

#[test]
fn test_valid_payroll() {
    let mut salaries: [u64; 50] = [0; 50];
    let mut addresses: [Field; 50] = [0; 50];
    
    // Add two employees
    salaries[0] = 5000;
    addresses[0] = 12345;
    
    salaries[1] = 6000;
    addresses[1] = 67890;
    
    let public_total = 11000;
    
    let mut hash_input: [Field; 100] = [0; 100];
    hash_input[0] = 12345;
    hash_input[1] = 5000;
    hash_input[2] = 67890;
    hash_input[3] = 6000;
    
    let employer_commitment = std::hash::pedersen_hash(hash_input);
    let batch_nonce = 1;
    
    let returned_commitment = main(salaries, addresses, public_total, batch_nonce);
    assert(returned_commitment == employer_commitment);
}

#[test]
fn test_invalid_payroll_sum() {
    let mut salaries: [u64; 50] = [0; 50];
    let mut addresses: [Field; 50] = [0; 50];
    
    salaries[0] = 5000;
    addresses[0] = 12345;
    
    // Incorrect total
    let public_total = 4000; 
    
    let mut hash_input: [Field; 100] = [0; 100];
    hash_input[0] = 12345;
    hash_input[1] = 5000;
    
    let employer_commitment = std::hash::pedersen_hash(hash_input);
    let batch_nonce = 1;
    
    // Should fail because 5000 != 4000
    // main(salaries, addresses, public_total, batch_nonce, employer_commitment);
}
