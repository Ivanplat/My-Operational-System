GPPPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-builtin -fno-rtti -fno-exceptions -fno-leading-underscore
ASPARAMS = --32
LDPARAMS = -melf_i386

objects = compiled/loader.o compiled/gdt.o compiled/kernel.o

%.o: %.cpp
	g++ $(GPPPARAMS) -o $@ -c $<
	mv --force $@ compiled/

%.o: %.s
	as $(ASPARAMS) -o $@ $<
	mv --force $@ compiled/


createkernel:
	make kernel.o
	make loader.o
	make mykernel.bin

createiso:
	make createkernel
	make mykernel.iso

mykernel.bin: linker.ld $(objects)
	ld $(LDPARAMS) -T $< -o $@ $(objects)
	mv --force $@ compiled/

install: mykernel.bin
	sudo cp $< /boot/mykernel.bin

mykernel.iso: compiled/mykernel.bin
	mkdir iso
	mkdir iso/boot
	mkdir iso/boot/grub
	cp $< iso/boot
	echo 'set timeout=0' >> iso/boot/grub/grub.cfg
	echo 'set default=0' >> iso/boot/grub/grub.cfg
	echo '' >> iso/boot/grub/grub.cfg
	echo 'menuentry "My Operational System" {' >> iso/boot/grub/grub.cfg
	echo ' multiboot /boot/mykernel.bin' >> iso/boot/grub/grub.cfg
	echo ' boot' >> iso/boot/grub/grub.cfg
	echo '}' >> iso/boot/grub/grub.cfg
	grub-mkrescue --output=$@ iso
	rm -rf iso
	sleep 2
	make mvv

run: mykernel.iso
	(killall VirtualBox && sleep 1) || true
	VirtualBox --startvm "My Operational System" &

mvv: mykernel.iso
	mv --force mykernel.iso bin/