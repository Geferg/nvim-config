#Requires AutoHotkey v2.0
#SingleInstance

; --- ø key (vkC0) ---
vkC0::SendText("(")             ; ø → (
+vkC0::SendText("{")            ; Shift+ø → {
^vkC0::SendText("[")            ; Ctrl+ø → [
<^>!vkC0::SendText("ø")         ; Ctrl+Shift+ø → original ø

; --- æ key (vkDE) ---
vkDE::SendText(")")             ; æ → )
+vkDE::SendText("}")            ; Shift+æ → }
^vkDE::SendText("]")            ; Ctrl+æ → ]
<^>!vkDE::SendText("æ")         ; Ctrl+Shift+æ → original
