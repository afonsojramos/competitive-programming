import { readFileSync } from "fs";

export function readInput(day: string) {
  return readFileSync(`./src/day-${day}/${day}.txt`, "utf8").replace(/\r/g, "");
}
