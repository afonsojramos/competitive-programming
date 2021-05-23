import { readInput } from "../utils";
import { pipe } from "@arrows/composition";

type Wire = { dir: "R" | "L" | "U" | "D"; dis: number }[];
type Wires = [Wire, Wire];
type XYSteps = [number, number, number];
type Paths = [XYSteps[], XYSteps[]];
type XYStepsAStepsB = [string, number, number];
type Intersections = XYStepsAStepsB[];

const prepareInput = (rawInput: string) =>
  rawInput.split("\n").map((x) =>
    x.split(",").map((item) => ({
      dir: item.slice(0, 1),
      dis: Number(item.slice(1)),
    }))
  );

const input = prepareInput(readInput("03"));

const getPaths = (input: Wires) => {
  return input.map((wire) => {
    let steps = 0;
    let x = 0;
    let y = 0;
    let path: any[] = [];

    for (const { dir, dis } of wire) {
      path = path.concat(
        Array.from({ length: dis }, () => [
          `${dir === "R" ? ++x : dir === "L" ? --x : x},${
            dir === "U" ? ++y : dir === "D" ? --y : y
          }`,
          ++steps,
        ])
      );
    }

    return path;
  });
};

const findIntersections = (paths: Paths) => {
  const [a, b] = paths;

  const bCords = new Map(b.map((x) => [x[0], x[1]]));
  const intersections = [];

  for (const x of a) {
    const ySteps = bCords.get(x[0]);

    if (ySteps !== undefined) {
      intersections.push([x[0], x[1], ySteps]);
    }
  }

  return intersections;
};

const findNearestCross = (intersections: Intersections) => {
  return Math.min(
    ...intersections.map((item) => {
      const [x, y] = item[0].split(",").map(Number);
      return Math.abs(x) + Math.abs(y);
    })
  );
};

const goA = (intersections: Intersections) => {
  return findNearestCross(intersections);
};

const goB = (intersections: Intersections) => {
  return Math.min(...intersections.map((x) => x[1] + x[2]));
};

console.time("Time");
const intersections = pipe.now(
  input,
  getPaths,
  findIntersections
) as Intersections;
const resultA = goA(intersections);
const resultB = goB(intersections);
console.timeEnd("Time");

console.log("Solution to part 1:", resultA); // -> 258
console.log("Solution to part 2:", resultB); // -> 12304
