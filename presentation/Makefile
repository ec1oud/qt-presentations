# Build PDF and SVG versions of the groff/pic(1) diagrams in resources/,
# cropped to the drawing's actual extents rather than a full page.
#
# Sources (*.pic) live in resources/; generated diagrams are placed in this
# directory (alongside Slides.qml/slides.txt), matching how other generated
# diagram assets (e.g. dogzilla-components.svg) are referenced by bare
# filename from slides.txt.
#
# Background: `groff -Tps -p foo.pic` produces PostScript sized to a full
# page (A4/letter), because grops(1) always emits an explicit setpagedevice
# call for the paper size. That call overrides any bounding-box cropping
# done downstream, so gs/pdfwrite ends up writing a page-sized PDF no
# matter how small the actual drawing is.
#
# The fix (documented under "Encapsulated PostScript" in grops(1)):
#   1. Render with -P-b16, which suppresses grops's page-size setup code.
#   2. Measure the real ink bounding box with gs's "bbox" device, padded
#      by BBOX_PAD points on every side. gs's bbox device reports the exact
#      geometric extent of the ink with zero margin, so stroked borders end
#      up flush against the page edge; that looks slightly clipped once
#      rendered/rasterized (anti-aliasing has no room to work with). Padding
#      the box gives the artwork a hair of breathing room.
#   3. Splice that bounding box into the PostScript header and mark the
#      file as EPS.
#   4. Convert to PDF with `gs -dEPSCrop`, which sizes the output page to
#      the bounding box instead of a fixed paper size.
#
# groff/pic have no native SVG output device, so SVG is produced by
# converting the already-cropped PDF with Inkscape.
#
# Usage:
#   make            # build cropped PDFs and SVGs for every resources/*.pic
#   make pdf        # build only the cropped PDFs
#   make svg        # build only the SVGs (implies the PDFs)
#   make clean      # remove intermediate build files
#   make distclean  # also remove the generated PDFs/SVGs

RESOURCES_DIR := resources
BUILD_DIR     := build

# Extra margin, in points, added around the measured ink bounding box.
BBOX_PAD ?= 1

GROFF    ?= groff
GS       ?= gs
INKSCAPE ?= inkscape
AWK      ?= awk

PIC_SRCS := $(wildcard $(RESOURCES_DIR)/*.pic)
PDF_OUT  := $(PIC_SRCS:$(RESOURCES_DIR)/%.pic=%.pdf)
SVG_OUT  := $(PIC_SRCS:$(RESOURCES_DIR)/%.pic=%.svg)

.PHONY: all pdf svg clean distclean

all: pdf svg

pdf: $(PDF_OUT)

svg: $(SVG_OUT)

$(BUILD_DIR):
	mkdir -p $@

# Step 1: render the pic(1) diagram to PostScript. -P-b16 stops grops from
# emitting %%DocumentMedia / setpagedevice, which would otherwise force the
# page back to a fixed paper size later.
$(BUILD_DIR)/%.ps: $(RESOURCES_DIR)/%.pic | $(BUILD_DIR)
	$(GROFF) -P-b16 -Tps -p $< > $@

# Step 2: measure the drawing's actual ink bounding box, padded by
# BBOX_PAD points so stroked edges aren't left flush against the page
# border (see note above).
$(BUILD_DIR)/%.bbox: $(BUILD_DIR)/%.ps
	$(GS) -q -dNOPAUSE -dBATCH -sDEVICE=bbox -- $< 2>&1 >/dev/null | \
	$(AWK) -v pad=$(BBOX_PAD) '\
	  /^%%BoundingBox:/ { printf "%%%%BoundingBox: %d %d %d %d\n", $$2-pad, $$3-pad, $$4+pad, $$5+pad; next } \
	  /^%%HiResBoundingBox:/ { printf "%%%%HiResBoundingBox: %f %f %f %f\n", $$2-pad, $$3-pad, $$4+pad, $$5+pad; next } \
	  { print } \
	' > $@

# Step 3: splice the bounding box into the header and mark the file as EPS.
$(BUILD_DIR)/%.eps: $(BUILD_DIR)/%.ps $(BUILD_DIR)/%.bbox
	sed -e "/^%%Orientation/r $(BUILD_DIR)/$*.bbox" \
	    -e "/^%!PS-Adobe-3.0/s/$$/ EPSF-3.0/" $< > $@

# Step 4: crop-convert the EPS to a PDF sized to the drawing.
%.pdf: $(BUILD_DIR)/%.eps
	$(GS) -q -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dEPSCrop -sOutputFile=$@ $<

# Convert the cropped PDF to SVG.
%.svg: %.pdf
	$(INKSCAPE) $< --export-type=svg --export-filename=$@

clean:
	rm -rf $(BUILD_DIR)

distclean: clean
	rm -f $(PDF_OUT) $(SVG_OUT)
