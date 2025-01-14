# Array is a primitive type with this API:
#
# - Array.new(len: U32)
# - Array.len(): U32
# - Array.set(idx: U32, elem: T)     -- panics when writing OOB
# - Array.get(idx: U32): T           -- panics when reading OOB or uninitialized element

import Prelude

type Vec[T]:
    data: Array[T]
    len: U32

fn Vec.withCapacity(cap: U32): Vec[T] =
    Vec(data = Array.new(cap), len = 0)

fn Vec.len(self): U32 =
    self.len

fn Vec.push(self, elem: T) =
    let cap = self.data.len()

    if self.len == cap:
        printStr("Growing the array from $(self.len) to $(self.len * 2)")
        let newData = Array.new(cap * 2)
        for i in 0 .. cap:
            newData.set(i, self.data.get(i))
        self.data = newData

    printStr("Setting vector elem $(self.len)")
    self.data.set(self.len, elem)
    self.len += 1

fn Vec.pop(self): Option[T] =
    if self.len == 0:
        return Option.None

    self.len -= 1
    Option.Some(self.data.get(self.len))

fn Vec.set(self, idx: U32, elem: T) =
    if idx >= self.len:
        panic("Vec.set OOB (len=$(self.len.toStr()), idx=$(idx.toStr()))")

    self.data.set(idx, elem)

fn Vec.get(self, idx: U32) =
    if idx >= self.len:
        panic("Vec.get OOB (len=$(self.len.toStr()), idx=$(idx.toStr()))")

    self.data.get(idx)

fn main(args: String) =
    let test = Vec.withCapacity(10)

    for i in 0 .. 20:
        test.push(i)

    for i in 0 .. test.len():
        printStr(test.get(i).toStr())
