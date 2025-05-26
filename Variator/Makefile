%.vba.encoded: %.vba
	sed 's/&/\&amp;/g;s/"/\&quot;/g;s/</\&lt;/g;s/>/\&gt;/g;'"s/'/\&apos;/g;" $< > $@

$(s)/%.xba: $(s)/%.xba.head $(s)/%.vba.encoded $(s)/%.xba.tail
	cat $^ > $@

src := Variator.xba script.xlb dialog.xlb
$(pack-src)
