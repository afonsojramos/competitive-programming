import { readFileSync } from 'fs';

let durationN: number;
let intN: number;
let streetsN: number;
let carsN: number;
let bonusN: number;

interface Intersection {
  inStreets: string[];
  outStreets: string[];
  ocurrences: number[];
}

interface Street {
  initInt: number;
  endInt: number;
  time: number;
}

interface Car {
  streetsN: number;
  streets: string[];
  posStreet: string;
}

const streets = new Map<string, Street>();
const ints = new Map<number, Intersection>();
const cars: Car[] = [];

/**
 * Reads an input file.
 */
function readFile(filename: string): void {
  // Read data from file
  let data = readFileSync(filename, 'utf-8');
  let dataByLine: string[] = data.split('\n');

  // Read first line
  const firstLine: string = <string>dataByLine.shift();
  const parsedFirstLine = firstLine.split(' ');
  durationN = parseInt(parsedFirstLine[0]);
  intN = parseInt(parsedFirstLine[1]);
  streetsN = parseInt(parsedFirstLine[2]);
  carsN = parseInt(parsedFirstLine[3]);
  bonusN = parseInt(parsedFirstLine[4]);

  // Read Streets
  for (let streetIndex = 0; streetIndex < streetsN; streetIndex++) {
    const streetLine = (<string>dataByLine.shift()).split(' ');

    const street: Street = {
      initInt: parseInt(streetLine[0]),
      endInt: parseInt(streetLine[1]),
      time: parseInt(streetLine[3]),
    };

    if (!ints.has(street.initInt)) {
      ints.set(street.initInt, { inStreets: [], outStreets: [], ocurrences: [] });
    }
    if (!ints.has(street.endInt)) {
      ints.set(street.endInt, { inStreets: [], outStreets: [], ocurrences: [] });
    }

    ints.get(street.initInt)?.outStreets.push(streetLine[2]);
    ints.get(street.endInt)?.inStreets.push(streetLine[2]);

    streets.set(streetLine[2], street);
  }

  for (let carIndex = 0; carIndex < carsN; carIndex++) {
    const carLine = (<string>dataByLine.shift()).split(' ');

    const car: Car = {
      streetsN: parseInt(<string>carLine.shift()),
      streets: carLine,
      posStreet: carLine[0],
    };

    cars.push(car);
  }

  // console.log('CARS');
  // console.log(cars);
  // console.log('INTERSECTIONS');
  // console.log(ints);
  // console.log('STREETS');
  // console.log(streets);
}

const countStreetOccurrences = (arr: Car[], val: string) =>
  arr.reduce((a, v) => (v.posStreet === val ? a + 1 : a), 0);

function arrayMin(arr: any[]) {
  return arr.reduce(function (p, v) {
    return ( p < v ? p : v );
  });
}

function arrayMax(arr: any[]) {
  return arr.reduce(function (p, v) {
    return ( p > v ? p : v );
  });
}
/**
 * Simulates.
 */
function simulate() {
  ints.forEach((intersection, key) => {
    console.log(key);
    intersection.inStreets.forEach((street) => {
      const streetOccurrences = countStreetOccurrences(cars, street);
      intersection.ocurrences.push(streetOccurrences);
    });

    const max = arrayMax(intersection.ocurrences)
    const res: number[] = [];
    intersection.ocurrences.forEach((item, index) => item === max ? res.push(index): null);

    res[0]

    intersection.ocurrences = []
  });
}

readFile('input/c.txt');
// simulate();
