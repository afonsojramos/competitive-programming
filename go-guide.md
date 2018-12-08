# Go Guide
In here I will *try* to save some of the most important lessons I learn while learning Golang.

### Table of Contents
1. [Install](#Install)
2. [Packages](#packages)
3. [Imports](#imports)
4. [Functions](#functions)
5. [Variables](#packages)
6. [For](#for)
7. [If](#if)
8. [Switch](#switch)
9. [Defer](#defer)
10. [Strings](#strings)
11. [Pointers](#pointers)
12. [Structs](#structs)
13. [Arrays](#arrays)
14. [Slices](#slices)
15. [Range](#range)

#### Install

Installing Go is rather easy since you have multiple options, allowing you to install it your way. I prefer to install it through my package manager, however it can be installed through [Go Intallation Guide](https://golang.org/doc/install).

One thing to note is that the `GOPATH` environment variable is very important since it specifies the location of your workspace. If no `GOPATH` is set, it is assumed to be `$HOME/go` on Unix systems and `%USERPROFILE%\go` on Windows. If you want to use a custom location as your workspace, you can set the GOPATH environment variable by running the following command.

```bash
# example of defining /home as the GOPATH
export GOPATH=$HOME
```

If you're using [VSCode's Go extension](https://github.com/Microsoft/vscode-go), it will also be useful to set the new `GOPATH` in the workspace settings, so that VSCode knows the new path to display import errors and such.

```bash
"go.gopath" = "$GOPATH"
```

#### Packages

Every Go program is made up of packages. When importing a package, only exported names can be referred to. Any "unexported" names are not accessible from outside the package.

A name is exported if it begins with a capital letter. For example, `Pi` is an exported name, which is exported from the `math` package.

```go
package main

import (
	"fmt"
	"math"
)

func main() {
	fmt.Println("Give me a slice of", math.Pi)
}
```

[⬆ Back to the top!](#go-guide)

#### Imports

Imports can be either multi-line or factored, but it is a good practice to use the latter. 
```go
// multi-line import
import "fmt"
import "math"
// factored import
import (
	"fmt"
	"math"
)
```

[⬆ Back to the top!](#go-guide)

#### Functions

Functions have their types defined after the declaration of parameters. Functions can also have multiple returns.

```go
func sub(x int, y int) int {
    return x - y
}

func add(x int, y int) (string, int) {
    return "Sum is equal to", y + x
}
```

Returns can also be naked, if return values are named at the top of the function, however, they harm readability in long functions.
```go
func moduleOf2(num int) (x int) {
	x = num % 2
	return
}
```

[⬆ Back to the top!](#go-guide)

#### Variables

A var declaration can include initializers, one per variable.

If an initializer is present, the type can be omitted, taking the type of the initializer. The same can be done for function arguments.

```go
var a, b = 10, "ten"
```

When listing several variables of the same type, the type only needs to be defined last.

```go
var this, is, pretty, cool bool
```

Inside a function, the `:=` **short assignment statement** can be used in place of a var declaration with implicit type.

Outside a function, every statement begins with a keyword (var, func, and so on) and so the := construct is not available.

```go
var a int = 2

func main() {
	b := 1
	this, is := "even nicer!", true

	fmt.Println("My name is Afonso, I'm", a, b, "and this is", this, is)
}

```

Furthermore, variables can be "factored" into blocks, as with import statements.

```go
var (
	ToBe   bool       = false
	MaxInt uint64     = 1<<64 - 1
	z      complex128 = cmplx.Sqrt(-5 + 12i)
)
```

Go's **basic variable types** are

```go
bool

string

int  int8  int16  int32  int64
uint uint8 uint16 uint32 uint64 uintptr

byte // alias for uint8

rune // alias for int32
     // represents a Unicode code point

float32 float64

complex64 complex128
```

Variables declared without an explicit initial value are given their *zero value*.

- 0 for numeric types

- false for the boolean type, and

- "" (the empty string) for strings.

You can have **type conversion** by simply using expression `T(v)` converts the value `v` to the type `T`.

```go
i := 42
f := float64(i)
u := uint(f)
```

When there are numeric values involved, type inference is, again, dependant on the right hand side. 

```go
var i int         // int 
j := i            // int
f := 3.142        // float64
g := 0.867 + 0.5i // complex128
fmt.Printf("These are our types\nj -> %T\nf -> %T\ng -> %T", j, f, g)

/* OUTPUT
These are our types
i -> int
f -> float64
g -> complex128 
*/
```

**Constants** cannot be declared using the := syntax and can be character, string, boolean, or numeric values.

`const Pi = 3.14`

**Constants** can be **untyped** taking the type by its context, and can be high precision values.

```go
const (
	// Shift 1 bit left 100 places.
	Big = 1 << 100
	// Shift it right again 99 places, so we end up with 1<<1 aka 2.
	Small = Big >> 99
)
```

[⬆ Back to the top!](#go-guide)

#### For

Like many other languages, the basic for loop has three components separated by semicolons, the init statement, the condition expression and the post statement; and it will stop iterating once the boolean condition evaluates to `false`. As you can see the expression does not need to be surrounded by parentheses `( )` but the braces `{ }` are required. 
```go
sum := 0
for i := 0; i < 10; i++ {
	sum += i
}
```

The init and post statements are optional.

```go
sum := 1
for ; sum < 1000; {
	sum += sum
}
```

And so are the semicolons, the **For is Go's "while"**

```go
sum := 1
for sum < 1000 {
	sum += sum
}
```

The so called "while (true)" can be just written like this: **`for {		}`**

[⬆ Back to the top!](#go-guide)

#### If

Go's `if`, similar to `for` loops, do not need be surrounded by parentheses ( ) but the braces { } are required.

```go
if grade > 10 {
	return "good enough"
}
```

Like `for`, the `if` statement can start with a **short statement** to execute before the condition. Obviously, variables declared by the statement are only in scope until the end of the if.

```go
if grade := getGrade(); grade > 10 {
	return grade
} else {
	grade += 10
}
```

As you can see, the short statement is also available inside any of the `else` blocks, making it extremely useful to reduce the number of calls of a certain function. This is also really good in terms of performance, since the variable is only available inside these blocks and does not occupy a place in the stack.

[⬆ Back to the top!](#go-guide)

#### Switch

Go's switch is like the one found in C, C++, Java, JavaScript, etc. however Go only runs the selected case, not all the cases that follow. In effect, the break statement that is needed at the end of each case in those languages is provided automatically in Go. Another important difference is that Go's switch cases do not need to be constants. And, of course, cases are evaluated from top to bottom, stopping when a case succeeds.

```go
switch state := getGameState(); state {
	case "menu":
		fmt.Println("Do you want to play?")
	case "boss":
		fmt.Println("Are you dead yet?")
	case "gameover":
		fmt.Println("Yep, guess so...")
	default:
		fmt.Println("Playing")
}
```

A `switch true { }` can also be used, either with true or not (`switch { }`), effectively creating a clean if-then-else chain.

[⬆ Back to the top!](#go-guide)

#### Defer

A defer statement defers the execution of a function until the surrounding function returns, however, note that the deferred call's arguments are evaluated immediately.

```go
func main() {
	defer fmt.Println("world")

	fmt.Println("hello")
}
// output -> hello world
```

When stacking defers calls are pushed onto a stack, and, when the function returns, its deferred calls are executed in last-in-first-out order.

```go
for i := 0; i < 10; i++ {
	defer fmt.Print(i)
}
// output -> 9 8 7 6 5 4 3 2 1 0
```

[⬆ Back to the top!](#go-guide)

#### Strings 

In Go, a string is just a **read-only slice of bytes**, which means that when accessing an index of a string you will get nothing but a byte, for example: `"abc"[0] = 97`. 

However, you must pay attention to the fact that a string holds arbitrary bytes and it is not required to hold Unicode text, UTF-8 text, or any other predefined format. So, when parsing some weird UTF-8 characters, take that in consideration, since as far as the content of a string is concerned, it is **just** equivalent to a slice of bytes.

This is extremely useful, because, if you think about it, most of the times you want a specific part of a string, it is for comparison purposes. For example, in Day 2 it was necessary to count the times a character appeared, which led me to create the following function, and it is absolutely beautiful.

```go
// CharCounts returns the count of each character in s.
func CharCounts(s string) map[rune]int {
	chars := make(map[rune]int)
	for _, c := range s {
		chars[c]++
	}
	return chars
}
```

[⬆ Back to the top!](#go-guide)

#### Pointers 

As usual, a pointer holds the memory address of a value. The type *T is a pointer to a T value, for example, `var p *int`, and its zero value is a `nil`. The & operator generates a pointer to its operand, while the * operator denotes the pointer's underlying value. Thankfully, unlike C, Go has no pointer arithmetic.

```go
universe, port := 42, 8080

p := &universe			// pointer to universe
fmt.Println(*p) 		// read universe through the pointer
*p = 24         		// set universe through the pointer
fmt.Print(universe)		// see the new value of universe

p = &port         		// pointer to port
*p = *p / 80   			// divide port through the pointer
fmt.Println(port) 		// see the new value of port
```

[⬆ Back to the top!](#go-guide)

#### Structs 

As you might know a `struct` is a collection of fields, which are accessed using a dot.

```go
type Position struct {
	X int
	Y int
}

func main() {
	pos := Position{1, 2}
	pos.X = 4
	fmt.Println(pos.X, pos.Y) // output -> 4 2
}
```

Struct fields can also be accessed through a `struct pointer`. To access a field of a struct when we have the `struct pointer` p we could write `(*p).field`. However, that notation is a pain in the assets, so the language permits us instead to write just p.X, without the explicit dereference.

```go
pos := Position{1, 2}
p := &pos
p.X = 1e9
fmt.Println(pos)
```

A **struct literal** denotes a newly allocated struct value by listing the values of its fields. You can also list just a subset of fields by using the `Name:` syntax. The special prefix `&` returns a pointer to the struct value.

```go
var (
	pos1 = Position{1, 2} 	// has type Vertex
	pos2 = Position{X: 1}  	// Y:0 is implicit
	pos3 = Position{}      	// X:0 and Y:0
	p  = &Position{1, 2} 	// has type *Vertex
)

func main() {
	fmt.Println(pos1, p, pos2, pos3)
}
```

[⬆ Back to the top!](#go-guide)

#### Arrays 

The type `[n]T` is an array of `n` values of type `T`. For example, `var a [10]int` declares a variable `a` as an array of *ten* integers.

An array's length is part of its type, so arrays cannot be resized, however Go provides a convenient way of working with arrays.

```go
var a [2]string
a[0] = "Advent of"
a[1] = "Code"
fmt.Println(a[0], a[1])	// output -> Advent of Code
fmt.Println(a)		// output -> [Advent of Code]

countToSix := [6]int{1, 2, 3, 4, 5, 6}
fmt.Println(countToSix) // output -> [1 2 3 4 5 6]
```

[⬆ Back to the top!](#go-guide)

#### Slices 

So, an array has a fixed size, solution -> **`slices`**. Slices are a dynamically-sized, and a flexible view into the elements of an array. In practice, slices are much more common than arrays in Go.

The type `[]T` is a slice with elements of type `T`.

A slice is formed by specifying two indices, a low and high bound, separated by a colon:

```go
a[low : high]
```

This selects a half-open range which includes the first element, but excludes the last one. The following expression creates a slice which includes elements 1 through 3 of a:

```go
countToSix := [6]int{1, 2, 3, 4, 5, 6}
var s []int = countToSix[1:4] // output -> [2 3 4]
```

However, deep down, slices are like references to arrays and do not store any data, they just describe a section of an underlying array. Changing the elements of a slice modifies the corresponding elements of its underlying array. 

***Note:*** Other slices that share the same underlying array will see those changes.

```go
countToSix := [6]int{1, 2, 3, 4, 5, 6}
fmt.Println(countToSix)	// output -> [1 2 3 4 5 6]

a := countToSix[0:2]
b := countToSix[1:3]
fmt.Println(a, b)	// output -> [1 2] [2 3]

b[0] = 42
fmt.Println(a, b)	// output -> [1 42] [42 3]
fmt.Println(countToSix)	// output -> [1 42 3 4 5 6]
```

A **slice literal** is like an array literal without the length.

This is an array literal: `[3]bool{true, true, false}`

And this creates the same array as above, then builds a slice that references it: `[]bool{true, true, false}`

When slicing, you may omit the high or low bounds to use their **slice defaults** instead.

The default is zero for the low bound and the length of the slice for the high bound, for example `[:2]` uses 2 as the high bound and zero (the default) as the low bound.

```go
func main() {
	s := []int{1, 2, 3, 4, 5, 6}
	printSlice(s) 	// output -> len=6 cap=6 [1 2 3 4 5 6]

	s = s[:3]	// Slice the slice to give it three of length.
	printSlice(s)	// output -> len=3 cap=6 [1 2 3]

	s = s[:4]	// Extend its length.
	printSlice(s)	// output -> len=4 cap=6 [1 2 3 4]

	s = s[2:]	// Drop its first two values.
	printSlice(s)	// output -> len=2 cap=4 [3 4]
}

func printSlice(s []int) {
	fmt.Printf("len=%d cap=%d %v\n", len(s), cap(s), s)
}
```

Slices have a zero value of `nil` with length and capacity of 0 and no underlying array.

You can also create slices with the built-in **`make`** function, effectively creating dynamically-sized arrays.

You can either create giving two arguments (creating a zeroed array) or three, providing capacity.

```go
a := make([]int, 5)	// output -> a len=5 cap=5 [0 0 0 0 0]

b := make([]int, 0, 5)	// output -> b len=0 cap=5 []

c := b[:2]		// output -> c len=2 cap=5 [0 0]

d := c[2:5]		// output -> d len=3 cap=3 [0 0 0]
```

You can also append new elements to a slice, using the provided **`append`** function, being the first parameter a slice of type `T`, and the rest are `T` values to append to the slice. As expected, the resulting value of append is a slice containing all the elements. 

Don't worry about the possibility of the backing array of s being too small to fit all the given values, since a bigger array will be allocated, andt he returned slice will point to the newly allocated array.

```go
var s []int		// output -> len=0 cap=0 []

s = append(s, 0)	// output -> len=1 cap=2 [0]

s = append(s, 1)	// output -> len=2 cap=2 [0 1]

s = append(s, 2, 3, 4)	// output -> len=5 cap=8 [0 1 2 3 4]
```

> Only pay attention to the length since capacity is more or less pseudo-random. What actually happens is that when you create the new underlying array, it copies all the values over, and then set that as the backing array for the slice. And when appending lots of values, there would be a need to do one copy for every single value, which would be very slow, so instead the runtime allocates more space than it thinks you need so that it has to make copies less often. If you still want to read a more in-depth guide about slices, go to [Golang's blog](https://blog.golang.org/go-slices-usage-and-internals).

[⬆ Back to the top!](#go-guide)

#### Range

The `range` form of the `for` loop iterates over a `slice` or `map` returning two values for each iteration. The first is the index, and the second is a copy of the element at that index. However, you can also only ask for one of the elements, skipping the index by assigning to _, or if you only want the index, dropping the value entirely.

```go
for index, value := range myslice {
	//
}
for index := range myslice {
	//
}
for _, value := range myslice {
	//
}
```

[⬆ Back to the top!](#go-guide)