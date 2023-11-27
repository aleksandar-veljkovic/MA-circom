pragma circom 2.1.6;

include "circomlib/comparators.circom";
include "circomlib/mux1.circom";
include "circomlib/poseidon.circom";
// include "./node_modules/circomlib/circuits/comparators.circom";

template HiLow () {
    // Ulazni signali
    signal input guess;
    signal input solution;
    signal input salt;
    signal input solutionCommitment;

    // Izlazni signal
    signal output answer;

    component solutionHash = Hash();
    solutionHash.value <== solution;
    solutionHash.salt <== salt;

    // Provera jednakosti
    component isCorrectGuess = IsEqual();
    isCorrectGuess.in[0] <== guess;
    isCorrectGuess.in[1] <== solution;

    // Provera da li je guess < solution
    component isLessThenSolution = LessThan(252);
    isLessThenSolution.in[0] <== guess;
    isLessThenSolution.in[1] <== solution;
    
    // Provera da li je guess > solution
    component isGreaterThenSolution = GreaterThan(252);
    isGreaterThenSolution.in[0] <== guess;
    isGreaterThenSolution.in[1] <== solution;

    // 1: <
    // 2: =
    // 3: >

    component checkEqual = Mux1();
    checkEqual.c[0] <== 0;
    checkEqual.c[1] <== 2;
    checkEqual.s <== isCorrectGuess.out;

    component checkLess = Mux1();
    checkLess.c[0] <== 0;
    checkLess.c[1] <== 1;
    checkLess.s <== isLessThenSolution.out;

    component checkGreater = Mux1();
    checkGreater.c[0] <== 0;
    checkGreater.c[1] <== 3;
    checkGreater.s <== isGreaterThenSolution.out;

    solutionHash.h === solutionCommitment;
    answer <== checkLess.out + checkEqual.out + checkGreater.out;   
}

// template GuessNumber(solution) {
//     // Ulazni signal
//     signal input guess;

//     // Izlazni signal
//     signal output answer;

//     component isCorrectGuess = IsEqual();
//     isCorrectGuess.in[0] <== guess;
//     isCorrectGuess.in[1] <== solution;

//     answer <== isCorrectGuess.out;
// }

template Hash() {
    signal input value;
    signal input salt;

    component poseidonHash = Poseidon(2);
    poseidonHash.inputs[0] <== value;
    poseidonHash.inputs[1] <== salt;

    signal output h;
    h <== poseidonHash.out;
}

template Hash2() {
    signal input value;
    signal input salt;

    component poseidonHash = Poseidon(2);
    poseidonHash.inputs[0] <== value;
    poseidonHash.inputs[1] <== salt;

    signal output h;
    h <== poseidonHash.out;
}

// template GuessNumber2() {
//     // Ulazni signali
//     signal input guess;
//     signal input solution;
//     signal input salt;
//     signal input solutionCommitment;

//     // Izlazni signal
//     signal output answer;

//     component isCorrectGuess = IsEqual();
//     isCorrectGuess.in[0] <== guess;
//     isCorrectGuess.in[1] <== solution;

//     component solutionHash = Hash();
//     solutionHash.value <== solution;
//     solutionHash.salt <== salt;

//     solutionHash.h === solutionCommitment;
//     answer <== isCorrectGuess.out;
// }

component main { public [ solutionCommitment, guess ] } = HiLow();
// component main = Hash();

/* INPUT = {
    "guess": "4",
    "solution": "4",
    "salt": "874692756423789468972364897236",
    "solutionCommitment": "17895133937826850402404390894549410105261189905586572272425643279516209132100"
} */