# Document Variator Libreoffice Extension

Mark pieces of the document by bookmarks "Variant (number)(letter)" and click
the icon. The extension creates all variants of the document where for each
number is one letter chosen.

Example: With bookmarks "Variant 1A", "Variant 1B", "Variant 1C", "Variant 2A"
and "Variant 2B", variants AA, AB, BA, BB, CA, CB are created.

The filepicker expects you to specify the stem, e.g. by specifying "foo.pdf" as
the output file, you get "foo-AA.pdf", "foo-AB.pdf" etc.

Tables and Frames are broken and not easily fixable.

Images behave weirdly.

This is possibly a very unstable extension, use with care and always save your
files before using.

If you brave enough, you may [download the extension](https://raw.githubusercontent.com/marenamat/libreoffice-variator/refs/heads/main/variator.oxt) anyway.

## Install

Open the Extension manager (Ctrl+Alt+E), click Add, select the OXT file,
restart LibreOffice.

If I ever manage to make this stable enough, I'll submit this to the official
repository.

## Contributing

Refer to [CONTRIBUTING.md](CONTRIBUTING.md).

## TODO

- find out what is happening with images
- try to fix tables and frames
- add some nicer UI
- maybe rewrite to something less insane, VBA is crazy
