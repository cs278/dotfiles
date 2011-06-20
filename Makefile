# Makefile to install dotfiles into a home directory.
#
# Inspired by <https://github.com/ryanb/dotfiles/blob/master/Rakefile>
#
# Copyright © 2011 Chris Smith
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

SRC ?= ".dotfiles"
DESTDIR ?= "$(HOME)"
UUID ?= 2c45ad09-98ec-46b5-9cf9-9b8bdbfa8cd8

MOUNT=$(DESTDIR)/$(SRC)/secure

OPTS=! -path "*/.*"
OPTS+=! -name "Makefile"
OPTS+=! -name "README.md"
OPTS+=! -name "dotfiles.key*"
OPTS+=! -name "secure"
OPTS+= -printf "$(SRC)/%P\n.%P\n"


.PHONY: install

install:
	cd $(DESTDIR) && \
	cd $(SRC) && \
	find -type f $(OPTS) \
		| bash .lntree $(DESTDIR) && \
	find -type l $(OPTS) \
		| bash .lntree $(DESTDIR)

.PHONY: mount
mount:
	grep $(MOUNT) /proc/mounts || (\
		mount=$$(grep ^`readlink -f /dev/disk/by-uuid/$(UUID)` /proc/mounts | cut -d" " -f 2 || ( \
				sudo mount /dev/disk/by-uuid/$(UUID) 
			)	
		); echo $$mount \
	)
