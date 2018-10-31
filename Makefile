CLANGPARAMS = -m32 -fno-use-cxa-atexit -nostdlib -fno-rtti -fno-exceptions 
ASPARAMS = --32
LDPARAMS = -melf_i386


objects = loader.o kernel.o

%.o: %.cpp
	clang  $(CLANGPARAMS) -o $@ -c $< 

%.o: %.s
	as  $(ASPARAMS) -o $@ -c $< 

kernel.bin: linker.ld $(objects)
	ld $(LDPARAMS) -T $< -o build/$@ $(objects)

kernel.iso: kernel.bin
	mkdir -p build/iso/boot/grub
	cp build/$< build/iso/boot
	echo 'set timeout=0' >> build/iso/boot/grub/grub.cfg
	echo 'set default=0' >> build/iso/boot/grub/grub.cfg
	echo '' >> build/iso/boot/grub/grub.cfg
	echo 'menuentry "os" {' >> build/iso/boot/grub/grub.cfg
	echo '	multiboot /boot/kernel.bin' >> build/iso/boot/grub/grub.cfg
	echo '	boot' >> build/iso/boot/grub/grub.cfg
	echo '}' >> build/iso/boot/grub/grub.cfg
	echo '' >> build/iso/boot/grub/grub.cfg
	grub-mkrescue --output=build/$@ build/iso
	rm -rf build/iso

run: kernel.iso
	qemu-system-x86_64 -hda build/kernel.iso -m 512

