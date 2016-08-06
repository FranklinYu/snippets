# Hide Characters In Numbers

This small webpage generages some seemingly random digits where real characters
are hidden. To see the hidden characters, highlight a certain digit with the
"find" functionality of the browser (usually by pressing `Ctrl` + `F` on Windows
or `Cmd` + `F` on Mac). For example, highlight 1 in

```text
2104191111910963187048111388728018981451115511156108791116916
0170181870414885109661243198609812831317931717412124471321412
4111191110716050186731606165229213151910281513813163401681616
8189131372016760129831007169980615151016931911194102691971818
8148141362312440180561056163199251916219781617416107651931254
3142141111511117111199111681873781213091114013013111151115913
```

you can see "HELLO, WORLD!".

Note that Chrome does not support local AJAX. If you want to open the file
locally with Chrome, use a file server, such as

```shell
python -m SimpleHTTPServer
```
