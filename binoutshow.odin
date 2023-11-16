package main

import "core:c/libc"
import "core:fmt"
import "core:os"
import dro "lib/dynareadout"

main :: proc() {
    binout := dro.binout_open("Hello binoutshow!")
    if err := dro.binout_open_error(&binout); err != nil {
        fmt.eprintf("failed to open binout: %s\n", err)
        libc.free(rawptr(err))
        os.exit(1)
    }
    defer dro.binout_close(&binout)
}
