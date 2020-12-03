import { readInput } from "../utils";

const puzzleInput = readInput("01")
    .split("\n")
    .map(line => +line);

const moduleFuel = (m: number) => Math.max(Math.floor(m / 3) - 2, 0);

const completeModuleFuel = (m: number): number => {
  const f = moduleFuel(m);
  if (f > 0) {
    return f + completeModuleFuel(f);
  }
  return 0;
};

const part1 = puzzleInput.reduce((a, b) => a + moduleFuel(b), 0);
console.log("Part 1: " + part1);

const part2 = puzzleInput.reduce((a, b) => a + completeModuleFuel(b), 0);
console.log("Part 2: " + part2);
