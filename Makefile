sign:
	sudo ssh-keygen -s ca \
		-I "$$(hostname --fqdn)" \
		-n "$$(echo $$(hostname),$$(hostname --fqdn),$$(hostname -I|tr ' ' ',') | perl -pe 's{,\s*$$}{}')" \
		-V -5m:+365d -h \
			$$(sudo find /etc/ssh -name 'ssh_host_*.pub' | grep -v cert.pub)
	for a in $$(sudo find /etc/ssh -name '*-cert.pub'); do \
		echo HostCertificate $$a; done | sudo tee /etc/ssh/sshd_config.d/host-certificate.conf

ca:
	ssh-keygen -f $@

user:
	@echo echo \"@cert-authority \* $$(cat ca.pub)\" ">>" \~/.ssh/known_hosts
