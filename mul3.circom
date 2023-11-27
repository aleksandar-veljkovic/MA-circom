pragma circom 2.1.6;

// include "circomlib/poseidon.circom";
// include "https://github.com/0xPARC/circom-secp256k1/blob/master/circuits/bigint.circom";

template Mul3 () {
    // Ulazni signali
    signal input a;
    signal input b;
    signal input c;

    // Izlazni signal
    signal output prod;

    // Pomocni signal
    signal prod_1 <== a * b;
    
    prod <== prod_1 * c;
}

component main = Mul3();

/* INPUT = {
    "a": "3",
    "b": "4",
    "c": "5"
} */