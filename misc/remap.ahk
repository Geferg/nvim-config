; ø key
SC01B::Send "("
+SC01B::Send ")"
^SC01B::Send "["
^+SC01B::Send "]"

; æ key
SC01A::Send "{"
+SC01A::Send "}"
^SC01A::Send "["
^+SC01A::Send "]"

; AltGr (Right Alt) + o/w = original ø / æ
<^>!o::Send "ø"
<^>!w::Send "æ"
