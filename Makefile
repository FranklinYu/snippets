# # my Makefile functions
#
# ## Recursively search from the path for the given pattern
#
# Usage: `$(call rwc,<path>,<pattern>)`
#
# Example:
#
# * `$(call rwc,./,*c)` or `$(call rwc,,*c)` searches from the current directory
#   for all `*.c` files.
# * `$(call rwc,img/,*.jpg)` searches the folder `img/` and its subfolder for
#   JPG graphics.
#
# Optional whitespace before <path> and <pattern> is permitted.
#
rwc = $(wildcard $(addprefix $1,$2)) $(foreach d,$(wildcard $1*),$(call rwc,$d/,$2))
