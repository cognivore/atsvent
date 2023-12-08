staload F = "libats/ML/SATS/filebas.sats"

// string0 means that the string has unknown length (thus, isn't dependently typed)
// string1 means that the string has known length (thus, is dependently typed)
extern castfn string1_of_string(x: string): [n: int] string(n)

fn treb_step (acc: int, next: string): int =
    let
        val next1 = string1_of_string(next)
        val strlen: int = string1_length(next1)
    in
        // TODO: add the actual adding of the coordinates here
        acc + strlen
    end

implement main0() = {
    var ref = fileref_open_opt("aa_trebuchet.txt", file_mode_r)

    val _ = case+ ref of
    | Some_vt (x) =>
        let
            var linestream = $F.streamize_fileref_line(x)
            var result = stream_vt_foldleft_cloptr(
                linestream,
                0,
                treb_step
            )
            val _ = fileref_close(x)
        in
            println! result
        end
    | ~None_vt() => println! "Failure"
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// This was my first attempt to write in ATS2.                                                                                        //
// The idea was to write composable code and pass the data extracted with some information about the sizes of the data around.        //
// But I found that it's a bit too difficult to punch through the perimiter of the side effects while staying in the viewtype world.  //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// staload EXTRA = "libats/ML/SATS/filebas.sats"

// fn step_stream
//     {n: int | n >= 1}
//     (next: string, acc: list_vt(string, n)): list_vt(string, n + 1) =
//     list_vt_cons(next, acc)

// fn read_trebuchet
//     () : Option_vt(string) =
//     let
//         val ref = fileref_open_opt("aa_trebuchet.txt", file_mode_r)
//     in
//         case+ ref of
//         | Some_vt (x) => let
//             var viewstream: stream_vt(string) = $EXTRA.streamize_fileref_line(x)
//             // Allocate n on the stack
//             val result: (int, string) = stream_vt_foldleft_cloptr(viewstream, "", lam ((acc_n, acc_str), next) => )
//             // var result: list_vt(string, n) = stream_vt_foldleft_cloptr(linestream, init, lam (acc, next) => list_vt_append(next, acc))
//             val _ = fileref_close(x)
//         in
//             Some_vt(list_vt_nil())
//         end
//         | ~None_vt() => None_vt
//     end


// implement main0 () = {
//     val trebuchet_opt = read_trebuchet()
//     val () = case+ trebuchet_opt of
//     | Some_vt (_) => println! "Success"
//     | ~None_vt() => println! "Failure"
// }
