package main

import "core:c/libc"
import "core:fmt"
import "core:os"
import "core:strings"
import dro "lib/dynareadout"

main :: proc() {
    binout_file_name, path_name: cstring
    path_name = "/"

    if len(os.args) < 2 {
        fmt.eprintln("Invalid Arguments")
        os.exit(1)
    }

    binout_file_name = strings.clone_to_cstring(os.args[1])
    if len(os.args) >= 3 {
        path_name = strings.clone_to_cstring(os.args[2])
    }

    binout := dro.binout_open(binout_file_name)
    if err := dro.binout_open_error(&binout); err != nil {
        fmt.eprintf("failed to open binout: %s\n", err)
        libc.free(rawptr(err))
        os.exit(1)
    }
    defer dro.binout_close(&binout)

    type_id: dro.binout_type
    timed: b32
    real_path := dro.binout_simple_path_to_real(
        &binout,
        path_name,
        &type_id,
        &timed,
    )
    if real_path == nil {
        fmt.eprintf("The path \"%s\" does not exist\n", path_name)
        os.exit(1)
    }
    defer libc.free(rawptr(real_path))

    data_size: uint
    num_values, num_timesteps: uint

    switch type_id {
    case .INT8:
        if timed {
            fmt.eprintln("timed is not implemented for this type")
            os.exit(1)
        }

        data := dro.binout_read_i8(&binout, real_path, &data_size)
        if binout.error_string != nil {
            break
        }
        defer libc.free(rawptr(data))

        data_str := strings.string_from_ptr(
            transmute(^byte)data,
            int(data_size),
        )

        fmt.printf("'%s'\n", data_str)
    case .INT16:
        if timed {
            fmt.eprintln("timed is not implemented for this type")
            os.exit(1)
        }

        data := dro.binout_read_i16(&binout, real_path, &data_size)
        if binout.error_string != nil {
            break
        }
        defer libc.free(rawptr(data))

        fmt.print("[")
        for i: uint = 0; i < data_size; i += 1 {
            if i == data_size - 1 {
                fmt.printf("%v", data[i])
            } else {
                fmt.printf("%v, ", data[i])
            }
        }
        fmt.println("]")
    case .INT32:
        if timed {
            data := dro.binout_read_timed_i32(
                &binout,
                real_path,
                &num_values,
                &num_timesteps,
            )
            defer libc.free(rawptr(data))

            fmt.print("[")
            for t: uint = 0; t < num_timesteps; t += 1 {
                fmt.print("[")
                for v: uint = 0; v < num_values; v += 1 {
                    value := data[t * num_values + v]
                    if v == num_values - 1 {
                        fmt.printf("%v", value)
                    } else {
                        fmt.printf("%v, ", value)
                    }
                }
                if t == num_timesteps - 1 {
                    fmt.print("]")
                } else {
                    fmt.print("], ")
                }
            }
            fmt.println("]")
        } else {
            data := dro.binout_read_i32(&binout, real_path, &data_size)
            if binout.error_string != nil {
                break
            }
            defer libc.free(rawptr(data))

            fmt.print("[")
            for i: uint = 0; i < data_size; i += 1 {
                if i == data_size - 1 {
                    fmt.printf("%v", data[i])
                } else {
                    fmt.printf("%v, ", data[i])
                }
            }
            fmt.println("]")
        }
    case .INT64:
        if timed {
            data := dro.binout_read_timed_i64(
                &binout,
                real_path,
                &num_values,
                &num_timesteps,
            )
            defer libc.free(rawptr(data))

            fmt.print("[")
            for t: uint = 0; t < num_timesteps; t += 1 {
                fmt.print("[")
                for v: uint = 0; v < num_values; v += 1 {
                    value := data[t * num_values + v]
                    if v == num_values - 1 {
                        fmt.printf("%v", value)
                    } else {
                        fmt.printf("%v, ", value)
                    }
                }
                if t == num_timesteps - 1 {
                    fmt.print("]")
                } else {
                    fmt.print("], ")
                }
            }
            fmt.println("]")
        } else {
            data := dro.binout_read_i64(&binout, real_path, &data_size)
            if binout.error_string != nil {
                break
            }
            defer libc.free(rawptr(data))

            fmt.print("[")
            for i: uint = 0; i < data_size; i += 1 {
                if i == data_size - 1 {
                    fmt.printf("%v", data[i])
                } else {
                    fmt.printf("%v, ", data[i])
                }
            }
            fmt.println("]")
        }
    case .UINT8:
        if timed {
            fmt.eprintln("timed is not implemented for this type")
            os.exit(1)
        }

        data := dro.binout_read_u8(&binout, real_path, &data_size)
        if binout.error_string != nil {
            break
        }
        defer libc.free(rawptr(data))

        fmt.print("[")
        for i: uint = 0; i < data_size; i += 1 {
            if i == data_size - 1 {
                fmt.printf("%v", data[i])
            } else {
                fmt.printf("%v, ", data[i])
            }
        }
        fmt.println("]")
    case .UINT16:
        if timed {
            fmt.eprintln("timed is not implemented for this type")
            os.exit(1)
        }

        data := dro.binout_read_u16(&binout, real_path, &data_size)
        if binout.error_string != nil {
            break
        }
        defer libc.free(rawptr(data))

        fmt.print("[")
        for i: uint = 0; i < data_size; i += 1 {
            if i == data_size - 1 {
                fmt.printf("%v", data[i])
            } else {
                fmt.printf("%v, ", data[i])
            }
        }
        fmt.println("]")
    case .UINT32:
        if timed {
            fmt.eprintln("timed is not implemented for this type")
            os.exit(1)
        }

        data := dro.binout_read_u32(&binout, real_path, &data_size)
        if binout.error_string != nil {
            break
        }
        defer libc.free(rawptr(data))

        fmt.print("[")
        for i: uint = 0; i < data_size; i += 1 {
            if i == data_size - 1 {
                fmt.printf("%v", data[i])
            } else {
                fmt.printf("%v, ", data[i])
            }
        }
        fmt.println("]")
    case .UINT64:
        if timed {
            fmt.eprintln("timed is not implemented for this type")
            os.exit(1)
        }

        data := dro.binout_read_u64(&binout, real_path, &data_size)
        if binout.error_string != nil {
            break
        }
        defer libc.free(rawptr(data))

        fmt.print("[")
        for i: uint = 0; i < data_size; i += 1 {
            if i == data_size - 1 {
                fmt.printf("%v", data[i])
            } else {
                fmt.printf("%v, ", data[i])
            }
        }
        fmt.println("]")
    case .FLOAT32:
        if timed {
            data := dro.binout_read_timed_f32(
                &binout,
                real_path,
                &num_values,
                &num_timesteps,
            )
            defer libc.free(rawptr(data))

            fmt.print("[")
            for t: uint = 0; t < num_timesteps; t += 1 {
                fmt.print("[")
                for v: uint = 0; v < num_values; v += 1 {
                    value := data[t * num_values + v]
                    if v == num_values - 1 {
                        fmt.printf("%v", value)
                    } else {
                        fmt.printf("%v, ", value)
                    }
                }
                if t == num_timesteps - 1 {
                    fmt.print("]")
                } else {
                    fmt.print("], ")
                }
            }
            fmt.println("]")
        } else {
            data := dro.binout_read_f32(&binout, real_path, &data_size)
            if binout.error_string != nil {
                break
            }
            defer libc.free(rawptr(data))

            fmt.print("[")
            for i: uint = 0; i < data_size; i += 1 {
                if i == data_size - 1 {
                    fmt.printf("%v", data[i])
                } else {
                    fmt.printf("%v, ", data[i])
                }
            }
            fmt.println("]")
        }
    case .FLOAT64:
        if timed {
            data := dro.binout_read_timed_f64(
                &binout,
                real_path,
                &num_values,
                &num_timesteps,
            )
            defer libc.free(rawptr(data))

            fmt.print("[")
            for t: uint = 0; t < num_timesteps; t += 1 {
                fmt.print("[")
                for v: uint = 0; v < num_values; v += 1 {
                    value := data[t * num_values + v]
                    if v == num_values - 1 {
                        fmt.printf("%v", value)
                    } else {
                        fmt.printf("%v, ", value)
                    }
                }
                if t == num_timesteps - 1 {
                    fmt.print("]")
                } else {
                    fmt.print("], ")
                }
            }
            fmt.println("]")
        } else {
            data := dro.binout_read_f64(&binout, real_path, &data_size)
            if binout.error_string != nil {
                break
            }
            defer libc.free(rawptr(data))

            fmt.print("[")
            for i: uint = 0; i < data_size; i += 1 {
                if i == data_size - 1 {
                    fmt.printf("%v", data[i])
                } else {
                    fmt.printf("%v, ", data[i])
                }
            }
            fmt.println("]")
        }
    case .INVALID:
        num_children: uint
        children := dro.binout_get_children(&binout, real_path, &num_children)
        if binout.error_string != nil {
            break
        }
        defer dro.binout_free_children(children)

        d_start: uint = num_children
        d_end: uint = num_children
        has_metadata: bool
        for i: uint = 0; i < num_children; i += 1 {
            child := strings.string_from_null_terminated_ptr(
                transmute(^byte)children[i],
                9,
            )
            if len(child) == 7 &&
               child[0] == 'd' &&
               child[1] >= '0' &&
               child[1] <= '9' {
                if d_start == num_children {
                    d_start = i
                }
            } else {
                if d_start != num_children {
                    d_end = i - 1
                }

                if child == "metadata" {
                    has_metadata = true
                }
            }
        }

        if d_start != num_children && d_end == num_children {
            d_end = num_children - 1
        }

        if d_start == num_children && !has_metadata {
            for i: uint = 0; i < num_children; i += 1 {
                child := children[i]
                fmt.printf("%s\n", child)
            }
        } else {
            if d_start != num_children {
                d_count := d_end - d_start + 1
                fmt.printf("d000001 - d%06d:\n", d_count)

                d_path := strings.builder_make()
                fmt.sbprintf(&d_path, "%s/d000001", real_path)
                d_path_str := strings.clone_to_cstring(
                    strings.to_string(d_path),
                )

                d_files := dro.binout_get_children(
                    &binout,
                    d_path_str,
                    &num_children,
                )
                defer dro.binout_free_children(d_files)

                for i: uint = 0; i < num_children; i += 1 {
                    fmt.printf("  %s\n", d_files[i])
                }
            }

            if has_metadata {
                fmt.println("metadata")

                meta_path := strings.builder_make()
                fmt.sbprintf(&meta_path, "%s/metadata", real_path)
                meta_path_str := strings.clone_to_cstring(
                    strings.to_string(meta_path),
                )

                meta_files := dro.binout_get_children(
                    &binout,
                    meta_path_str,
                    &num_children,
                )
                defer dro.binout_free_children(meta_files)

                for i: uint = 0; i < num_children; i += 1 {
                    fmt.printf("  %s\n", meta_files[i])
                }
            }
        }
    }

    if binout.error_string != nil {
        fmt.eprintf(
            "failed to read \"%s\": %s\n",
            real_path,
            binout.error_string,
        )
        os.exit(1)
    }
}
