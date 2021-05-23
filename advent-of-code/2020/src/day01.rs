use crate::utils;
use std::collections::HashSet;

#[aoc_generator(day1)]
pub fn input_generator(input: &str) -> HashSet<u32> {
    utils::input_hashset(input)
}

#[aoc(day1, part1)]
pub fn solve_part_01(input: &HashSet<u32>) -> u32 {
    for x in input {
        let y = 2020 - x;
        if input.contains(&y) {
            return x * y;
        }
    }
    0
}

#[aoc(day1, part2)]
pub fn solve_part_02(input: &HashSet<u32>) -> u32 {
    for x in input {
        for y in input {
            if x + y > 2020 {
                continue;
            }
            let z = 2020 - x - y;
            if input.contains(&z) {
                return x * y * z;
            }
        }
    }
    0
}
