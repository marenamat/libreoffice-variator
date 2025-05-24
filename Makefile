TARGET := variator.oxt

$(TARGET): registration/license.txt META-INF/manifest.xml description.xml Addons.xcu

dirs := Variator pkg-description icons

s = $(dir $(lastword $(MAKEFILE_LIST)))
pack-src = $(TARGET): $(addprefix $(s)/,$(src))

include $(addsuffix /Makefile,$(dirs))

$(TARGET):
	rm $(TARGET)
	zip $@ $^ 
