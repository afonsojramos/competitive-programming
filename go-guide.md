# Go Guide
In here I will *try* to save some of the most important lessons I learn while learning Golang.

Table of Contents
1. [Packages](#packages)
2. [Imports](#imports)
3. [Functions](#functions)
4. [Variables](#packages)

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