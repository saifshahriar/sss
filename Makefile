SRC = sss.c util.c
OBJ = ${SRC:.c=.o}

all: sss

.c.o:
	${CC} -c ${CFLAGS} $<

sss: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS} -lX11 -lImlib2

clean:
	rm -f sss ${OBJ} sss-${VERSION}.tar.gz

dist: clean
	mkdir -p sss-${VERSION}
	cp -R LICENSE Makefile README.md
		sss.1 util.h ${SRC} sss-${VERSION}
	tar -cf sss-${VERSION}.tar sss-${VERSION}
	gzip sss-${VERSION}.tar
	rm -rf sss-${VERSION}

# install: all
# 	mkdir -p ${DESTDIR}${PREFIX}/bin
# 	cp -f dwm ${DESTDIR}${PREFIX}/bin
# 	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
# 	cp -f dwm_menu ${DESTDIR}${PREFIX}/bin
# 	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm_menu
# 	mkdir -p ${DESTDIR}${MANPREFIX}/man1
# 	sed "s/.TH \"DWM\" \"1\" \"October 25, 2022\" \"dwm-VERSION\" \"\"/.TH \"DWM\" \"1\" \"October 25, 2022\" \"dwm-${VERSION}\" \"General Commands Manual\"/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
# 	# sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
# 	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1
#
# uninstall:
# 	rm -f ${DESTDIR}${PREFIX}/bin/dwm\
# 		${DESTDIR}${MANPREFIX}/man1/dwm.1
#
# setup: install
# 	mkdir -p /usr/share/xsessions/
# 	mkdir -p /opt/dwm-saif
# 	cp ./dwm.desktop /usr/share/xsessions/
# 	cp ./* /opt/dwm-saif/

man:
	pandoc -s -t man sss.1.md -o sss.1

.PHONY: all clean dist
	# install uninstall setup man
