all: ransomware_mac.c
	gcc -o ransomware_mac ransomware_mac.c
clean:
	$(RM) ransomware_mac
